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
- [CoLA](https://cola.readthedocs.io/en/latest/)
- [DPPy](https://dppy.readthedocs.io/)
- [GPJax](https://docs.jaxgaussianprocesses.com/)
- [HLIBpro](https://www.hlibpro.com/)
- [jax-triton](https://github.com/jax-ml/jax-triton) with
  [triton-cpu support](https://github.com/jax-ml/jax-triton/pull/322)
- (Triton) [kernels](https://github.com/triton-lang/kernels)
- [mugrade](https://github.com/dlsyscourse/mugrade), the grading
  system for [10-714 Deep Learning Systems](https://dlsyscourse.org/)
- [SLEEF](https://sleef.org/) and
  [TLFloat](https://shibatch.github.io/tlfloat-doxygen/)
- [triton-cpu](https://github.com/triton-lang/triton-cpu)

### Binary cache

In order to reduce build times for CUDA packages, the [Nix-community
cache](https://nix-community.org/cache/) as well as the [Flox
cache](https://flox.dev/blog/the-flox-catalog-now-contains-nvidia-cuda/) can
be used in addition to the default [NixOS cache](https://cache.nixos.org/).
An example NixOS configuration is provided below.

```nix
nix.settings = {
  substituters = [
    "https://nix-community.cachix.org?priority=41"
    "https://cache.flox.dev?priority=42"
  ];
  trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
  ];
};
```

Alternatively, modify `/etc/nix/nix.conf` or `~/.config/nix/nix.conf` directly.

```ini
extra-substituters = https://nix-community.cachix.org?priority=41
extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
extra-substituters = https://cache.flox.dev?priority=42
extra-trusted-public-keys = flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=
```
