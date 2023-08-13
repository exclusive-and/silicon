
{
    description = "Software Simulation of Synchronous Digital Circuits";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";

        overlay = final: prev:
        {
            haskell.packages.ghc96 = prev.haskell.packages.ghc96.override
            {
                overrides = self: super:
                {
                    base-compat = self.callHackage "base-compat" "0.13.0" {};
                    lattices    = self.callHackage "lattices" "2.2" {};
                };
            };
        };

        pkgs = import nixpkgs
        {
            inherit system;
            overlays = [ overlay ];
        };

        silicon = pkgs.haskell.package.ghc96.callCabal2nix "silicon" ./. {};

    in
    {
        overlays.default = overlay;

        packages.${system}.default = pkgs.silicon;
    };
}
