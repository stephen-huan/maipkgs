# Maipkgs

Maipkgs is my personal collection of Nix
build recipes, modules, and expressions.

This repository aims to reduce redundancy in the "Nix as a package
manager" use case. For Nix(OS) as an operating system, my [NixOS
configuration](https://github.com/stephen-huan/nixos-config/) is
also a flake that exposes its packages, overlays, and modules.

## Contents

### Packages

All packages are exposed through the flake attribute
`maipkgs.packages.${system}`. Python packages are additionally exposed through
both `maipkgs.legacyPackages.${system}.python3Packages` as well as the
`maipkgs.legacyPackages.${system}.python.withPackages` interface.

- [BBFMM3D](https://github.com/ruoxi-wang/BBFMM3D) and
  (my [fork](https://github.com/stephen-huan/PBBFMM3D)
  of) [PBBFMM3D](https://github.com/ruoxi-wang/PBBFMM3D)
- [DPPy](https://dppy.readthedocs.io/)
- [GPJax](https://docs.jaxgaussianprocesses.com/) and its dependencies
  - `cola-ml`
  - `cola-plum-dispatch`
  - `gpjax`
- [HLIBpro](https://www.hlibpro.com/)
- [jax-triton](https://github.com/jax-ml/jax-triton) with
  [triton-cpu support](https://github.com/jax-ml/jax-triton/pull/322)
- (Triton) [kernels](https://github.com/triton-lang/kernels)
- [mugrade](https://github.com/dlsyscourse/mugrade), the grading
  system for [10-714 Deep Learning Systems](https://dlsyscourse.org/)
- [SLEEF](https://sleef.org/)
- [triton-cpu](https://github.com/triton-lang/triton-cpu)
