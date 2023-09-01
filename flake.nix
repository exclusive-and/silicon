
{
    description = "Software Simulation of Synchronous Digital Circuits";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.05";
        adm = {
            url = "github:exclusive-and/ApplicativeDoMore";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, adm, ... }:
    let
        system = "x86_64-linux";

        applicative-do-more = adm.packages.${system}.default;

        overlay = final: prev:
        {
            silicon-depends = final.haskell.packages.ghc96.override
            {
                overrides = hself: hsuper:
                {
                    applicative-do-more = applicative-do-more;
                    base-compat = hself.base-compat_0_13_0;
                    lattices = hself.lattices_2_2;
                };
            };
        };

        pkgs = import nixpkgs
        {
            inherit system;
            overlays = [ overlay ];
        };

        silicon = pkgs.silicon-depends.callCabal2nix "silicon" ./. {};

        silicon-env = pkgs.silicon-depends.shellFor
        {
            packages = _: [ silicon ];

            nativeBuildInputs = [
                pkgs.haskell.packages.ghc96.cabal-install
                pkgs.haskell.packages.ghc96.haskell-language-server
            ];
        };

    in
    {
        overlays.default = overlay;
        packages.${system}.default = silicon;
        devShells.${system}.default = silicon-env;
    };
}
