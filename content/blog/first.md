+++
title = "My first post"
date = 2019-11-27
draft = true
+++

This is my first blog post.

Mocking an async context manager, eg for `aiohttp`:

What we need to mock:
- aiohttp.ClientSession: this can be treated as a dummy object, it just needs a `post` method. Mock
- The `session.post` *synchronous* method. returns a class implementing the async context manager protocol. Mock
- the async context manager (ACM) class returned by `session.post`. again a Mock
- The `__aenter__` method of the context manager. a real async method that returns AsyncMock
- The actual response object returned by ACM's `__aenter__` async method (named `as response`). AsyncMock
- The `__aexit__` async method of the ACM. must return None to not suppress the exception
    the default return_value of a Mock is a truthy MagicMock
    if aexit returns something truthy, the exception is suppressed
- The `.text()` method of the response object. AsyncMock

```py
@pytest.fixture
def mock_session() -> AsyncMock:
    """A mock for aiohttp.ClientSession."""
    return AsyncMock(spec=aiohttp.ClientSession)

@pytest.fixture
def mock_response() -> AsyncMock:
    """A mock for aiohttp.ClientResponse."""
    return AsyncMock(spec=aiohttp.ClientResponse)

# Mock aiohttp.ClientResponse returned by __aenter__ method
# of the async context manager returned by post()
mock_response.status = HTTPStatus.OK
mock_response.text = AsyncMock(return_value=json.dumps(mock_oxylabs_response))
# Mock for aiohttp.ClientSession.post that correctly handles the async context manager.
# A mock_response will be returned by `async with ... as response`
mock_context_manager = Mock()
mock_context_manager.__aenter__ = AsyncMock(return_value=mock_response)
mock_context_manager.__aexit__ = AsyncMock(return_value=None)
mock_session.post = Mock(return_value=mock_context_manager)
```

Similar to
```py
import asyncio
import contextlib

# can either define it ourselves
@contextlib.asynccontextmanager
async def mock_async_context_manager():
    try:
        yield
    finally:
        pass

# or use mocks
mock_acm_factory = Mock(return_value=mock_async_context_manager())

async def test_mock_async_context_manager():
    async with mock_async_context_manager():
        pass

asyncio.run(test_mock_async_context_manager())
```

There we go.

Is this the most interesting thing I hope to write about? Certainly not. But it was something recent and easy enough to write about that I could use it to motivate myself to get this site and blog officially up and running.

Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet. Lorem ipsum dolor emet.
