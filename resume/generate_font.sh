#!/usr/bin/env bash

# Regenerates the Source Sans 3 variable webfont via woff2_compress.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
static_dir="${repo_root}/static"
variable_font_src="${static_dir}/fonts/SourceSans3-VariableFont_wght.ttf"

if ! command -v woff2_compress >/dev/null 2>&1; then
  echo "woff2_compress must be installed to regenerate the Source Sans 3 variable webfont." >&2
  exit 1
fi

echo "Regenerating Source Sans 3 variable webfont via woff2_compress..."
woff2_compress "${variable_font_src}"
