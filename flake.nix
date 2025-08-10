{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShell.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [nodejs pnpm];
      shellHook = "pnpm install --frozen-lockfile";
    };
    packages.${system}.default = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "website";
      src = ./.;
      version = "unstable";
      nativeBuildInputs = [
        pkgs.nodejs
        pkgs.pnpm_9.configHook
      ];
      pnpmDeps = pkgs.pnpm_9.fetchDeps {
        inherit (finalAttrs) pname version src;
        fetcherVersion = 1;
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
    nixosModules.default = {...}: {
      services.static-web-server = {
        enable = true;
        listen = "0.0.0.0:80";
        root = self.packages.${system}.default;
      };
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [80];
      };
      system.stateVersion = "24.05";
    };
  };
}
