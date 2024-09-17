{
  description = "Nix Flake for SpiecEasi R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        SpiecEasi = pkgs.rPackages.buildRPackage {
          name = "SpiecEasi";
          src = self;
          propagatedBuildInputs = builtins.attrValues {
            inherit (pkgs.rPackages)
              MASS
              Matrix
              RcppArmadillo
              VGAM
              glmnet
              huge
              pulsar
              ;
          };
        };
        rvenv = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            devtools
          ];
        };
      in
      {
        packages.default = SpiecEasi;
        devShells.default = pkgs.mkShell {
          buildInputs = [ SpiecEasi ];
          inputsFrom = pkgs.lib.singleton SpiecEasi;
          packages = pkgs.lib.singleton rvenv;
        };
      }
    );
}
