
{
  description = "Software Simulation of Synchronous Digital Circuits";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Overlay to manage dependencies in the Nix Haskell package set.
      haskOverlay = final: prev:
        {
          hask = final.haskell.packages.ghc96.override {
            overrides = haskfinal: haskprev: {
              base-compat = haskfinal.callHackage "base-compat" "0.13.0" {};
              lattices    = haskfinal.callHackage "lattices" "2.2" {};
            };
          };

          silicon = final.hask.callCabal2nix "silicon" ./. {};
        };

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [ haskOverlay ]; };
    in
    {
      overlays.default = haskOverlay;

      packages.${system}.default = pkgs.silicon;
    };
}
