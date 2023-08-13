
{
    description = "Software Simulation of Synchronous Digital Circuits";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.05";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";

        overlay = final: prev:
        {
            silicon-depends = final.haskell.packages.ghc96.override
            {
                overrides = hself: hsuper:
                {
                    base-compat = hself.callHackage "base-compat" "0.13.0" {};
                    lattices    = hself.callHackage "lattices" "2.2" {};
                };
            };
        };

        pkgs = import nixpkgs
        {
            inherit system;
            overlays = [ overlay ];
        };

        silicon = pkgs.silicon-depends.callCabal2nix "silicon" ./. {};


    in
    {
        overlays.default = overlay;

        packages.${system}.default = pkgs.silicon;
    };
}
