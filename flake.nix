
{
  description = "Software Simulation of Synchronous Digital Circuits";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      config = {};

      # Overlay to add our extra dependencies to the Nix Haskell package set.
      haskOverlay = final: prev:
        {
          hask = final.haskell.packages.ghc96.override {
            overrides = haskfinal: haskprev: {
              base-compat = haskfinal.callHackage "base-compat" "0.13.0" {};
              lattices    = haskfinal.callHackage "lattices" "2.2" {};
              silicon     = haskfinal.callCabal2nix "silicon" ./. {};
            };
          };

          silicon = final.hask.silicon;
        };

      system = "x86_64-linux";

      pkgs = import nixpkgs
        { inherit config system; overlays = [ haskOverlay ]; };
    in
    {
      packages.${system}.default = pkgs.silicon;
    };
}
