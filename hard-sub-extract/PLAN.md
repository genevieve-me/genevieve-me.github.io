Build up a blog post which goes over different methods for subtitle extraction, increasing in complexity.
Start with a slideshow: ffmpeg with simple video filter to detect changed frames, crop to known subtitle region, tesseract.

Two challenges for generalizing:
- Video changes more than the subtitles
- Subtitles might not be in a fixed area

For the first problem, we could OCR sampled frames at 1FPS and deduplicate text.
For the second problem, we can try a vague heuristic like cropping to the bottom 15%, but sometimes
subtitles might go to the top of a scene. Feeding the whole image into OCR model will worsen performance.

note that real-world OCR engines typically consist of two stages:
- text detection/bounding box computation
- OCR on those specific boxes

Since 2018, Tesseract uses a neural network (CNN for feature extraction with LSTM for transcription) for turning the bounding box image snippets into text.
However, the bounding boxes are computed via 'legacy' algorithmic approaches via the Leptonica image processing library.

### Overview of text region detection

traditional computer vision approaches rely on text properties like consistent color, contrast, stroke width
- Connected Components Analysis (small connected regions of similar pixels are likely characters)
  - Threshold the grayscaled image (aka Otsu's Method; above/below threshold become black/white) then group adjacent pixels into components/blobs
    - This can miss text of slightly different colors depending on the chosen threshold
  - Extremal Regions are connected groups of pixels with higher or lower brightness than their boundaries
    - An ER approach is similar to running CCA on every threshold (0-255). ERs are connected components from any thresholded image.
    - The 'component tree' (aka Max-Tree / Min-Tree) tracks which component merged into which as the threshold changed.
    - Maximally Stable Extremal Regions (MSER) selects regions that don't vary much as the extremal region threshold is changed. more robust to scale/lighting changes for finding character regions
      - Edge-Enhanced MSER (Chen et al., 2011): This variant enforced that the boundary of the MSER region must align with the edges detected by Canny, rather than just looking at intensity.
      - Tree Pruning: Instead of classifying every region, analyze the parent-child relationship in the component tree to discard regions that didn't "evolve" like text (e.g., regions that grew too quickly were likely shadows, not letters).
    - ERFilter in `opencv-contrib` using [Neumann & Matas](https://ieeexplore.ieee.org/document/6248097) algorithm runs a trained classifier (Boosted Decision Trees) to find letter-like ERs from the full component tree
  - Filter out non-text regions with geometric heuristics like aspect ratio, eccentricity, solidity
  - Character regions are merged into words and lines via algorithms based on their spatial arrangement/bounding box overlap
    - e.g., distance between characters must be < X% of character height; collinear characters with similar heights/colors
- Edge detection: high contrast. combine with "morphological operators"
  - This approach is often referred to as a texture-based or frequency-based approach.
  - Why: Dense text creates a high frequency of edges. By applying a "closing" morphological operation (dilation followed by erosion), you smear those individual edges together into a single white blob (the word/line), which makes detection easier. This is a very common technique in older license plate detection pipelines.
- Stroke Width Transform: text regions have much lower variation in stroke width
  - The key advantage of SWT (Epshtein et al., 2010) over MSER/CCA is that it is local.
  - Why: MSER and CCA look at the whole region (global features). SWT looks at pixels and their neighbors to compute the width. This makes SWT exceptionally good at separating text from vegetation or fences (which have high contrast/edges but irregular widths), where edge detection or MSER might fail.
  - Instead of looking for "regions of color" (like MSER or blobs), it looks for "regions of constant width."
  - It shoots a ray from every edge pixel to the opposing edge. If the distance (width) is consistent, it marks that pixel as part of a "stroke."

Tesseract/Leptonica by default still use the first approach, dating back to the 80s/90s, so it really benefits from cropping your images, _especially_ when the background is very 'noisy' like in many videos.
Potential failure modes on a full screengrab:
- A high-contrast edge from a tree branch or sharp shadow in the shot gets flagged as a component, and tesseract ends up adding junk `/|` to the output
- Since Leptonica by default uses a global threshold, it computes the optimal threshold based on the whole image. That threshold could be inappropriate for the subtitles (eg a very dark or bright scene)
  - For example, `r` and `n` merge into `m` because of a somewhat-similar background color, even if the text is easily legible to a human

State of the art before deep learning:

#### Deformable Part Models (DPM) & Pictorial Structures

This was the state-of-the-art for object detection (like Felzenszwalb’s work) applied to text.

- The Concept: Instead of detecting a whole word at once, the algorithm models a word as a flexible collection of parts (characters).

- Pictorial Structures: They used a "spring-like" model to connect characters.
  A "word" was defined mathematically: "A generic region (the word) containing several sub-regions (characters) that are roughly the same height, color, and spaced equidistantly."

- Link Energy: If detection A and detection B were too far apart or had different colors, the "energy cost" of the spring connecting them would be too high, and the algorithm would decide they weren't part of the same word.

- Paper: <https://docs.opencv.org/4.x/d9/d12/group__dpm.html> or <https://cs.brown.edu/people/pfelzens/papers/lsvm-pami.pdf>

#### Improved Binarization

Improvements to binarization: Global Otsu thresholding fails on scene images with shadows and was replaced with Adaptive Thresholding (specifically Sauvola’s method, adapted from Niblack). Instead of one threshold for the image, the threshold is calculated for every pixel based on the mean and standard deviation of its neighbors.

[Adaptive Thresholding to Binarize Degraded Documents with Sauvola Method using Integral Images](https://wahabaftab.com/Sauvola-Thresholding-Integral-Images/)

Although these methods were not new, in the 2010s "Integral Images" were used to make these calculations almost as fast as Otsu Binarization. This allowed high-quality local binarization to run in real-time on mobile phones (e.g., early 'live translate' camera features).

See also:
[Adaptive Binarisation (Rescribe: Historical OCR, and all things around it)](https://blog.rescribe.xyz/posts/adaptive-binarisation/)

#### Conditional Random Fields (CRF)

Fixed OCR errors. It treated text recognition as a graph problem.

Graph nodes are image patches (potential letters), and edges represented the probability of those letters appearing next to each other (Bigrams/Trigrams). If the visual classifier said "This looks 60% like 'H' and 40% like 'A'" and the next letter was clearly 'E', the CRF would weigh the 'H-E' (common) vs 'A-E' (rare) probabilities to enforce the correct word 'HE' over 'AE'.

#### Specialized Feature Descriptors (FASText / HOG)

- HOG (Histogram of Oriented Gradients): This was the standard feature descriptor for detecting the shape of characters before CNNs learned features automatically. It counted the direction of edges in grid cells (e.g., "this 8x8 patch has a lot of vertical lines").

- FASText (Bušta et al., 2015): Note: Do not confuse this with the 2021 Deep Learning "FAST" paper.
- This was a highly optimized "corner" detector designed specifically for strokes. It was an extremely fast filter intended to replace MSER for real-time video, detecting "stroke keypoints" rather than just generic corners.

### Summary of the "Classical" Pipeline (circa 2015)

If you were building a text detector prior to deep learning approaches, it could include:

- SWT or MSER to find candidate regions.

- HOG features extracted from those regions.

- Random Forest or SVM classifier to say "Yes/No, this is a letter."

- Pictorial Structures to group those letters into lines.

- CRF + Dictionary to resolve the final text.

## Deep learning approaches
- i.e., require a separate pre-training step to create a model
- The "TextBoxes model" ([paper](https://arxiv.org/abs/1611.06779)) is used by the `cv::text::TextDetectorCNN` class
- [Efficient and Accurate Scene Text Detector (EAST)](https://arxiv.org/abs/1704.03155).
  - Can be used in OpenCV via `net = cv2.dnn.readNet(model_file); net.forward(...)`
- DBNet - segmentation based model used by PaddleOCR. It typically consists of a backbone (like ResNet) and a Feature Pyramid Network (FPN)
  - Differentiable Binarization (DB) is the process of converting a probability map into a binary map using an adaptive threshold
  - _Real-time Scene Text Detection with Differentiable Binarization_ (2019)
  - DBNet++ (2022) adds an Adaptive Scale Fusion (ASF) module
- CRAFT, used by EasyOCR
- Lately, PaddleOCR seems to have trained its own model? https://www.paddleocr.ai/main/en/version3.x/module_usage/text_detection.html#1-overview
  - Even though it seems this may just be a 'rebrand' of DBNet
- Not sure how this differs from PaddleOCR: https://github.com/RapidAI/RapidOCR
