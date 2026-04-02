+++
title = "Classical Text Detection Methods"
weight = 1
+++

Found at /home/genevieve/dev/hard-sub-extract

## The Problem

Hardcoded subtitle extraction faces two core challenges:
- Video changes more than just the subtitles (scene changes, motion)
- Subtitles might not be in a fixed area (top vs bottom placement)

A naive approach (crop to known subtitle region, detect frame changes, run OCR) works for slideshows but fails on real video content.

## Understanding OCR Pipelines

Real-world OCR engines typically consist of two stages:
1. **Text detection/bounding box computation**
2. **OCR on those specific boxes**

Since 2018, Tesseract uses neural networks (CNN for feature extraction + LSTM for transcription) for the text recognition step. However, bounding boxes are still computed via "legacy" algorithmic approaches using the Leptonica image processing library.

## Traditional Computer Vision Approaches

These rely on text properties like consistent color, contrast, and stroke width.

### Connected Components Analysis (CCA)

Small connected regions of similar pixels are likely characters.

1. Threshold the grayscaled image (Otsu's Method)
2. Group adjacent pixels into components/blobs
3. Filter non-text with geometric heuristics (aspect ratio, eccentricity, solidity)
4. Merge character regions into words/lines based on spatial arrangement

**Limitation:** Can miss text of slightly different colors depending on the chosen threshold.

### Extremal Regions and MSER

Extremal Regions are connected groups of pixels with higher or lower brightness than their boundaries - essentially running CCA at every threshold (0-255).

**Maximally Stable Extremal Regions (MSER)** selects regions that don't vary much as the threshold changes, making it more robust to scale and lighting variations.

Variants include:
- **Edge-Enhanced MSER** (Chen et al., 2011): Enforces that MSER boundaries align with Canny edges
- **Tree Pruning**: Analyzes parent-child relationships to discard non-text regions
- **ERFilter** (Neumann & Matas): Uses trained classifiers (Boosted Decision Trees) on the full component tree

### Stroke Width Transform (SWT)

Text regions have much lower variation in stroke width (Epshtein et al., 2010).

Instead of looking for "regions of color," SWT looks for "regions of constant width" by shooting rays from edge pixels to opposing edges.

**Key advantage:** SWT is local (pixel-level) rather than global (region-level), making it excellent at separating text from vegetation or fences where edge detection or MSER might fail.

### Edge/Texture-Based Methods

Dense text creates high-frequency edges. Applying morphological operations (dilation + erosion) smears individual edges into blobs representing words/lines.

This was common in older license plate detection pipelines.

## Why Tesseract Struggles with Full Screenshots

Tesseract/Leptonica's default CCA approach dates back to the 80s/90s, so it really benefits from cropped images - especially with noisy backgrounds.

Failure modes on full screengrabs:
- High-contrast edges (tree branches, shadows) get flagged as components, adding junk to output
- Global thresholding computes an inappropriate threshold for subtitles (e.g., `r` and `n` merge into `m`)
