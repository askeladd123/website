{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [nodejs pnpm];
          shellHook = "pnpm install --frozen-lockfile";
        };
        packages.default = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "website";
          src = ./.;
          version = "unstable";
          nativeBuildInputs = [
            pkgs.nodejs
            pkgs.pnpm_9.configHook
          ];
          pnpmDeps = pkgs.pnpm_9.fetchDeps {
            inherit (finalAttrs) pname version src;
            hash = "sha256-KKRBqMBLs386QW6fgt0GS9f9nq/yzFSN59XZyazQqlM=";
          };
          buildPhase = ''
            pnpm install --frozen-lockfile --offline
            pnpm build
          '';
          installPhase = ''
            mkdir -p $out
            cp -r dist/* $out/
          '';
        });
      }
    );
}
