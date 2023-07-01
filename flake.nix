
{
  description = "Software Simulation of Synchronous Digital Circuits";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; };

      ghc = pkgs.haskell.packages.ghc96.override
        {
          overrides = self: _: with nixpkgs.haskell.packages.ghc96;
            {
              base-compat = self.callHackage "base-compat" "0.13.0" {};
              lattices    = self.callHackage "lattices" "2.2" {};
            };
        };
    in
    {
      packages.${system}.default = ghc.callCabal2nix "silicon" ./. {};
    };
}
