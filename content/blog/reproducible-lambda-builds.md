+++
title = "Adding Determinism to Python Lambda Artifacts"
date = 2025-12-06
+++

I spent too long debugging why my Lambda builds in Python kept producing different zip hashes despite no code changes.
It turns out that even after eliminating other sources of non-determinism, reproducible builds of Python code can be tricky due to bytecode compilation.

## The context

While not all of our lambda functions are in Python, those that are tend to be small and simple.[^rust]
Bundling them for deployment as zipfiles is simpler and faster in CI than setting up container builds for all of them, and integrates well with our IAC setup using the AWS Terraform provider.

The non-determinism of zip archives is well known by people working on build reproducibility,
and there are [well-trod workaround paths](https://reproducible-builds.org/docs/archives/#zip-files)[^ci-zip].
We're ultimately zipping up a bunch of `.py` files, so I don't mean to imply this is the same as that work (typically done in the context of software distributions), but there's a lot to learn from that world when it comes to software delivery.[^reproducible]

## The problem

After making the zip archival deterministic, I was surprised to see that the `tofu plan` jobs still planned to redeploy all lambdas every run.

I tracked down which files in the artifacts didn't match (just a matter of `diff`) and realized the issue was in the bytecode (`__pycache__/*.pyc` files). You may wonder why that was included at all, especially when AWS [recommends you don't include `__pycache__` directories](https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-pycache).

Stepping back a moment, these lambdas are in the same repository as some other Python containers.
I've fully embraced `uv` for Python now, and it's used throughout the repo: including for lambdas, as several have one or two dependencies.
`uv` can pre-compile your and your dependencies' source files into bytecode,
and they recommend doing so in their excellent [documentation on containerization](https://docs.astral.sh/uv/guides/integration/docker/).

It turns out that I set the `UV_COMPILE_BYTECODE=1` flag for all CI jobs in the entire repository when it was first created.
I did notice this when lambdas were first added to the repo some time later, but didn't think too much of it.
My first thought was that the flag could speed up cold starts, since Python wouldn't need to compile on first import.
We already make sure the build environment/Python version matches the Lambda execution target[^caution], so it's fine, right?

I still think this is a reasonable suggestion for container builds, but there are two issues which cause pre-compiled Python bytecode to be non-deterministic.
First, timestamps are embedded in bytecode files. By default, `.pyc` files include the source file's modification timestamp. Different build environments or times means different hashes. You can work around this by setting `SOURCE_DATE_EPOCH=0`, a standardized environment variable that tells build tools (including the bytecode compiler) to use a fixed timestamp instead.

Second, CPython's marshal module can have non-deterministic serialization: this behavior has been [known for some time](https://bugs.python.org/issue34033).
When Python serializes bytecode, the output depends on interpreter state and compilation order.
If files are processed in varying order (as occurs with `uv`'s parallel compilation workers[^uvsource] or standard `python -m compileall -j4`) the output differs.

The root cause is how CPython handles reference flags (`FLAG_REF`) during serialization.
The issue tracking this is filed as a [feature request](https://github.com/python/cpython/issues/129724) looking for a design that doesn't regress performance of the bytecode compiler.

## The fix

The simplest solution is to not ship bytecode at all:

```bash
UV_COMPILE_BYTECODE=0
```

In fact, that's a bit misleading; you don't have to set this environment variable, you just have to do nothing to get the default behavior![^hindsight] When skipping bytecode compilation entirely, the lambda zips hash consistently.

Yes, this means slightly slower cold starts since Python has to compile bytecode on first import. There is still an interesting trade-off, because the Lambda execution environment has to unzip your code, and that part will be faster on a smaller archive without bytecode included. Either way, if you care about these milliseconds, you probably have bigger concerns.

## Why bother?

Reproducible builds let you trust your CI cache invalidation and avoid noise in your deployment plans. It's nice to know that no code changes also means no changes to your deployment artifact. In this case, the right answer was just turning a feature off.

P.S. While writing this post, I actually discovered the tool [`add-det`](https://github.com/keszybz/add-determinism).
In addition to fixing common annoyances like zipfile timestamps, it has support for normalizing `.pyc` bytecode.
Like I mentioned before, I preferred to remove it in this case, but if you would rather keep your bytecode in your build artifacts, give it a try and let me know how it works for you!

[^rust]: I've had success writing slightly more complex lambdas in Rust, and Rust in AWS Lambda [is now GA](https://aws.amazon.com/about-aws/whats-new/2025/11/aws-lambda-rust/) with the official stabilization of components like the Rust Lambda Runtime. (I've found it was already stable for a while, though!)

[^ci-zip]: If you're curious, our CI script looks like this:
```sh
find . -exec touch -d 1970-01-01T00:00:00Z {} +
find . -type f -print | sort | TZ=UTC zip -oX -@ ${LAMBDA_NAME}-payload.zip
```

[^reproducible]: You can see the (impressive) reproducibility rates of packages in [NixOS/`nixpkgs`](https://reproducible.nixos.org/) or [Arch Linux](https://reproducible.archlinux.org/) on their websites. Besides enhancing trust, build reproducibility could be especially powerful in concert with future work like a content-addressed Nix store.

[^caution]: The only reason given for AWS's suggestion to exclude bytecode is avoiding issues with a "build machine with a different architecture or operating system." As you'll see, I ultimately did disable bytecode pre-compilation, but if you are paying attention to such things (as you should), I think you're probably fine to ignore this generic bit of advice.

[^hindsight]: It may have been wiser of me to scope environment variables like this `uv`-specific flag to only the jobs that explicitly wanted it, even if that meant a tiny bit more repetition. It can be hard to resist the allure of simplicity, though!

[^uvsource]: See uv's [compile.rs](https://github.com/astral-sh/uv/blob/main/crates/uv-installer/src/compile.rs), which spawns multiple worker processes each running a Python interpreter that compiles files via [pip_compileall.py](https://github.com/astral-sh/uv/blob/main/crates/uv-installer/src/pip_compileall.py).
