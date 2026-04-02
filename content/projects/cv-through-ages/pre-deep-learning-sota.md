+++
title = "Pre-Deep Learning State of the Art"
weight = 2
+++

## Deformable Part Models (DPM) & Pictorial Structures

This was the state-of-the-art for object detection (Felzenszwalb's work) applied to text.

**The Concept:** Instead of detecting a whole word at once, model a word as a flexible collection of parts (characters).

**Pictorial Structures** use a "spring-like" model to connect characters:
- A "word" is defined mathematically as a generic region containing sub-regions (characters) that are roughly the same height, color, and spaced equidistantly
- **Link Energy:** If detections A and B are too far apart or have different colors, the "energy cost" of the connecting spring is too high, and they're not grouped as the same word

Reference: [Felzenszwalb's Deformable Part Models](https://cs.brown.edu/people/pfelzens/papers/lsvm-pami.pdf)

## Improved Binarization

Global Otsu thresholding fails on scene images with shadows. The solution: **Adaptive Thresholding** (specifically Sauvola's method, adapted from Niblack).

Instead of one threshold for the image, calculate a threshold for every pixel based on the mean and standard deviation of its neighbors.

In the 2010s, **Integral Images** made these calculations nearly as fast as Otsu, enabling high-quality local binarization in real-time on mobile phones (early "live translate" camera features).

See: [Adaptive Binarisation at Rescribe](https://blog.rescribe.xyz/posts/adaptive-binarisation/)

## Conditional Random Fields (CRF)

CRFs treated text recognition as a graph problem to fix OCR errors.

- **Nodes:** Image patches (potential letters)
- **Edges:** Probability of letters appearing next to each other (bigrams/trigrams)

Example: If the visual classifier says "60% H, 40% A" and the next letter is clearly 'E', the CRF weighs 'H-E' (common) vs 'A-E' (rare) to enforce 'HE' over 'AE'.

## Specialized Feature Descriptors

### HOG (Histogram of Oriented Gradients)

The standard feature descriptor for detecting character shapes before CNNs. It counts the direction of edges in grid cells (e.g., "this 8x8 patch has a lot of vertical lines").

### FASText (Busta et al., 2015)

*Note: Not to be confused with the 2021 deep learning "FAST" paper.*

A highly optimized corner detector designed specifically for strokes, intended to replace MSER for real-time video by detecting "stroke keypoints" rather than generic corners.

## The Classical Pipeline (circa 2015)

A complete text detector before deep learning might include:

1. **SWT or MSER** to find candidate regions
2. **HOG features** extracted from those regions
3. **Random Forest or SVM classifier** to determine "is this a letter?"
4. **Pictorial Structures** to group letters into lines
5. **CRF + Dictionary** to resolve the final text
