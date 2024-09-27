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

- [GPJax](https://docs.jaxgaussianprocesses.com/) and dependencies
  - `cola-ml`
  - `cola-plum-dispatch`
  - `gpjax`
  - `mktestdocs`
