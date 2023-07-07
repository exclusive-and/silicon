
{
  description = "Software Simulation of Synchronous Digital Circuits";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      config = {};

      overlays = [
        (final: prev: {
          hask = final.haskell.packages.ghc96.override {
            overrides = haskfinal: haskprev: {
              silicon = haskfinal.callCabal2nix "silicon" ./. {};
            };
          };

          silicon = final.hask.silicon;
        })
      ];

      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit config overlays system; };
    in
    {
      overlays = overlays;

      packages.${system}.default = pkgs.silicon;
    };
}
