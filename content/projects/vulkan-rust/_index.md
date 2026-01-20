+++
title = "Vulkan from Scratch in Rust"
description = "Zero-dependency Vulkan rendering on Wayland/Linux using pure Rust"
sort_by = "weight"
template = "projects.html"
page_template = "projects-page.html"
+++

Building a Vulkan renderer from scratch on Linux (Wayland) using pure Rust with no external dependencies - just `#[repr(C)]` structs for direct libvulkan FFI.

The long-term goal is to progressively build complexity from "hello triangle" toward physically-based rendering (PBR) and eventually ray tracing, while gaining a deep understanding of the graphics pipeline.

Found at /home/genevieve/dev/graphics/vulkan-experiment
