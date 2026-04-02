+++
title = "Deep Learning Text Detection"
weight = 3
+++

## The Shift to Neural Networks

Deep learning approaches require a separate pre-training step to create a model, but achieve significantly better accuracy on diverse inputs.

## Key Models

### TextBoxes (2016)

[Paper](https://arxiv.org/abs/1611.06779) - Used by `cv::text::TextDetectorCNN` in OpenCV.

### EAST - Efficient and Accurate Scene Text Detector (2017)

[Paper](https://arxiv.org/abs/1704.03155)

Can be used in OpenCV via:
```python
net = cv2.dnn.readNet(model_file)
net.forward(...)
```

### DBNet - Differentiable Binarization (2019)

A segmentation-based model used by PaddleOCR. Architecture typically consists of:
- Backbone (like ResNet)
- Feature Pyramid Network (FPN)

**Differentiable Binarization (DB)** is the process of converting a probability map into a binary map using an adaptive threshold.

*Real-time Scene Text Detection with Differentiable Binarization* (2019)

**DBNet++ (2022)** adds an Adaptive Scale Fusion (ASF) module.

### CRAFT

Character Region Awareness for Text detection - used by EasyOCR.

## Modern OCR Frameworks

- **PaddleOCR**: Seems to have trained their own models, though it may be a rebrand/refinement of DBNet. See [PaddleOCR docs](https://www.paddleocr.ai/main/en/version3.x/module_usage/text_detection.html)

- **RapidOCR**: [GitHub](https://github.com/RapidAI/RapidOCR) - relationship to PaddleOCR unclear

## Next Steps

- Implement a basic subtitle extraction pipeline using classical methods
- Compare results with PaddleOCR/EasyOCR
- Explore video-specific optimizations (temporal consistency, deduplication)
