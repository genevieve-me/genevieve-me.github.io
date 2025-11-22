#!/usr/bin/env bash

# Builds the resume PDF via Typst.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
resume_dir="${repo_root}/resume"
fonts_dir="${resume_dir}/fonts"
typst_src="${resume_dir}/Genevieve_Mendoza_resume.typ"
static_dir="${repo_root}/static"
pdf_dir="${static_dir}/resume"
pdf_path="${pdf_dir}/genevieve-mendoza-resume.pdf"
variable_font_src="${static_dir}/fonts/SourceSans3-VariableFont_wght.ttf"
license_src="${fonts_dir}/OFL_Source.txt"
license_dest="${static_dir}/fonts/OFL_SourceSans3.txt"

mkdir -p "${pdf_dir}" "${static_dir}/fonts"

export TYPST_FONT_PATHS="${fonts_dir}"

if ! command -v typst >/dev/null 2>&1; then
  echo "Required tool 'typst' is not available on PATH." >&2
  exit 1
fi

echo "Compiling Typst sources → ${pdf_path}"
typst compile "${typst_src}" "${pdf_path}"

html_path="${pdf_dir}/genevieve-mendoza-resume.html"
echo "Compiling Typst sources → ${html_path}"
typst compile --features html --input target=html "${typst_src}" "${html_path}"

if [[ -f "${license_src}" ]]; then
  cp "${license_src}" "${license_dest}"
fi

echo "Resume assets generated in ${pdf_dir} and fonts synced to ${license_dest}"
