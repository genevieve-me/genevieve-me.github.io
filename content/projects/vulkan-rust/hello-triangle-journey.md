+++
title = "The Hello Triangle Journey"
weight = 1
+++

## Project Philosophy

Build Vulkan rendering from the ground up in Rust with **zero dependencies** - no `ash`, no `vulkano`, just raw FFI to libvulkan using `#[repr(C)]` structs.

## Why This Approach?

- **Deep understanding**: No abstractions hiding what's happening
- **Wayland-native**: Modern Linux display protocol from the start
- **Rust safety where possible**: Still get Rust's type system benefits
- **Learning by doing**: Every struct and function call is intentional

## The Goal

Start with the simplest possible Vulkan program and incrementally add complexity:

1. **Hello Triangle** - The classic first step
2. **Textures and samplers**
3. **3D transformations**
4. **Lighting models**
5. **Physically-based rendering (PBR)**
6. **Ray tracing** (long-term)

## Technical Challenges

- Wayland surface creation without windowing libraries
- Vulkan initialization boilerplate in pure Rust
- Memory management and synchronization
- SPIR-V shader compilation

## Next Steps

- Define core Vulkan structs (`VkApplicationInfo`, `VkInstanceCreateInfo`, etc.)
- Implement Wayland surface connection
- Create the rendering pipeline
