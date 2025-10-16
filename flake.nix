{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    demo_pathfinding.url = "github:askeladd123/pathfinding-v2";
    demo_ants.url = "github:askeladd123/ants";
  };
  outputs = {
    self,
    nixpkgs,
    demo_pathfinding,
    demo_ants,
  }: let
    basename = "website";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [nodejs];
    };
    packages.${system} = rec {
      demos = pkgs.runCommand "combine-demos" {} ''
        mkdir $out
        ln --symbolic ${demo_pathfinding.packages.${system}.default} $out/pathfinding
        ln --symbolic ${demo_ants.packages.${system}.default} $out/ants
      '';
      default = let
        main = pkgs.buildNpmPackage {
          name = "${basename}-no-demos";
          src = ./.;
          npmDepsHash = "sha256-z8hxmEft8V9suUzJAMX6GMuShnedVrReRE+GqpEKYDg=";
          installPhase = ''
            mkdir $out
            cp --recursive --no-preserve=mode,ownership dist/. $out/
          '';
        };
      in
        pkgs.symlinkJoin {
          name = basename;
          paths = [main];
          postBuild = ''
            ln --symbolic ${demos} $out/external
          '';
        };
    };
    apps.${system}.default = let
      testServer = pkgs.writeShellApplication {
        name = "${basename}-test-server";
        runtimeInputs = with pkgs; [static-web-server];
        text = ''
          echo "serving, visit http://localhost:8080 in a browser"
          static-web-server --port 8080 --root ${self.packages.${system}.default}
        '';
      };
    in {
      type = "app";
      program = "${testServer}/bin/${basename}-test-server";
    };
    nixosModules.default = {lib, ...}: {
      services.static-web-server = {
        enable = true;
        listen = "0.0.0.0:80";
        root = self.packages.${system}.default;
      };
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [80];
      };
      networking.useHostResolvConf = lib.mkForce false; # NOTE: fixes bug https://github.com/NixOS/nixpkgs/issues/162686
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
