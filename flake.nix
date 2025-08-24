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
    nixosModules.default = {lib, ...}: {
      services.static-web-server = {
        enable = true;
        listen = "0.0.0.0:80";
        root = self.packages.${system}.default;
      };
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [80];
        useHostResolvConf = lib.mkForce false; # NOTE: fixes bug https://github.com/NixOS/nixpkgs/issues/162686
      };
      system.stateVersion = "24.05";
    };
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      # INFO: imperative use:
      # ```nushell
      # nixos-container create website --flake .#default
      # nixos-container start website
      # curl $'http://(nixos-container show-ip website)/'
      # ```
      inherit system;
      modules = [
        self.nixosModules.default
        ({...}: {boot.isContainer = true;})
      ];
    };
  };
}
