{
  description = "Personal collection of Nix build recipes";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      systems = lib.systems.flakeExposed;
      eachDefaultSystem = f: builtins.foldl' lib.attrsets.recursiveUpdate { }
        (map f systems);
    in
    eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        maipkgs = import ./pkgs { inherit pkgs; };
        formatter = pkgs.nixpkgs-fmt;
        linters = [ pkgs.statix ];
      in
      {
        legacyPackages.${system} = rec {
          # https://nixos.org/manual/nixpkgs/stable/#overriding-python-packages
          python = maipkgs.python3Packages.python.override {
            packageOverrides = final: prev: maipkgs.python3Packages;
            self = python;
          };
          python3Packages = maipkgs.python3Packages // { inherit python; };
        };

        packages.${system} = {
          inherit (maipkgs) bbfmm3d;
          inherit (maipkgs.python3Packages)
            cola-ml
            cola-plum-dispatch
            gpjax
            mktestdocs;
        };

        formatter.${system} = formatter;

        checks.${system}.lint = pkgs.stdenvNoCC.mkDerivation {
          name = "lint";
          src = ./.;
          doCheck = true;
          nativeCheckInputs = linters ++ lib.singleton formatter;
          checkPhase = ''
            nixpkgs-fmt --check .
            statix check
          '';
          installPhase = "touch $out";
        };

        apps.${system} = {
          update = {
            type = "app";
            program = lib.getExe (pkgs.writeShellApplication {
              name = "update";
              runtimeInputs = [ pkgs.nix-update ];
              text = lib.concatMapStringsSep "\n"
                (package: "nix-update --flake ${package} || true")
                (builtins.attrNames self.packages.${system});
            });
          };
        };

        devShells.${system}.default = (pkgs.mkShellNoCC.override {
          stdenv = pkgs.stdenvNoCC.override {
            initialPath = [ pkgs.coreutils ];
          };
        }) {
          packages = [
            pkgs.nix-update
          ]
          ++ linters
          ++ lib.singleton formatter;
        };
      }
    );
}
