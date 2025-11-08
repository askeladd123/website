{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    demo_pathfinding.url = "github:askeladd123/pathfinding-v2/main";
    demo_ants.url = "github:askeladd123/ants/main";
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
      demos = let
        base_url = "https://ask-pub.hel1.your-objectstorage.com/big-track";
        draw.scuffed_album = pkgs.fetchurl {
          url = "${base_url}/1d/1dfe1d2076f2a53043f084e43951bd31/scuffed-album-cover.png";
          hash = "sha256-Fx7HZ1TeCRCN5WZer35X8la+n3pDg/5U7BWDPp0yhvw=";
        };
        draw.scuffed_cover = pkgs.fetchurl {
          url = "${base_url}/bc/bcbf86bf80a758048d99b16c8c809b0e/scuffed-cover.png";
          hash = "sha256-EsP5kREaBuaxc5VgWmSywFSo4ZOZNtp19SxXXIaWhjA=";
        };
        draw.uber = pkgs.fetchurl {
          url = "${base_url}/1e/1eeef5c23c29a8b0aaf27128353452f5/logo-ubermensch.png";
          hash = "sha256-/cCY5mLCH5Gvb5Q35zXmiqLwFaaVfKrv0CB8cTgXnEg=";
        };
        draw.raving = pkgs.fetchurl {
          url = "${base_url}/6e/6e0c8be3aec954e04005bab9b00fdf54/logo-raving-high.png";
          hash = "sha256-IyFluanEf3+xj0OCdRdvaW21xDKlJMKPoqFYt/oh7Ms=";
        };
        draw.bandit = pkgs.fetchurl {
          url = "${base_url}/ca/ca07869261a803f7befc2b654a5add30/bandit-2019.png";
          hash = "sha256-89c8mB6/9EFnokSZZ0pQWVmVpo2gc/qtpT7F0/7pfyY=";
        };
        blender.tree = pkgs.fetchurl {
          url = "${base_url}/fa/fab879b038de56ecaa9fc026deb2cc5a/tre.mp4";
          hash = "sha256-zfieb4emWlxgqf6CzM1GLMXobeh96xAe5Y9BsxPQpYA=";
        };
        blender.sailBoat = pkgs.fetchurl {
          url = "${base_url}/98/986a5883f97eada1291dca0205497fc9/sail-boat.png";
          hash = "sha256-FSCX9QG0B4qjME7/yStcd3s3D72+6t9kpLcgT7vrbfs=";
        };
        blender.mosern = pkgs.fetchurl {
          url = "${base_url}/3c/3cf6f89066435a43eeefba7e317033d6/mosern.png";
          hash = "sha256-KlLJjmrcUils5O4kmDQ9DnsX3EMzq2/loyqbP3HeL1M=";
        };
        blender.hjelm = pkgs.fetchurl {
          url = "${base_url}/29/298cc3bf5d33093cbc9c234396cb7ca2/hjelm.mp4";
          hash = "sha256-/f3K2mjmStpNHVliDGykW1o8TmNZU8MM92AdE7wUWoU=";
        };
        blender.revolver = pkgs.fetchurl {
          url = "${base_url}/42/42fa0580ede29777dca13e59127766e3/revolver.png";
          hash = "sha256-Hrbw0JTTrZEfxUY4sJ+KEeejk4r+Pb0gbkmW0CQuLFA=";
        };
        blender.npp = pkgs.fetchurl {
          url = "${base_url}/8e/8e2ffc81b863198c7aa51d58381fb337/nppp-demo-animasjon.mp4";
          hash = "sha256-DTFlGgRRinVXbaZxy6sP/j8EqiGB6HKJ1xGTMUqTxgw=";
        };
        blender.thompson = pkgs.fetchurl {
          url = "${base_url}/99/9939c803eb7994c9f7efafcc586b3faf/thompson.png";
          hash = "sha256-9R8Vc/neFbGx372NkG+FXp7reLY1hxkmfNZiLXfCAe0=";
        };
        blender.axe = pkgs.fetchurl {
          url = "${base_url}/a9/a9b36316a09240ef468c2de65fe6d12f/axe.png";
          hash = "sha256-vMKniDu9ENKiFlICuu2iKvZoDjuGX6IAWxvUHNonclY=";
        };
        blender.fjell = pkgs.fetchurl {
          url = "${base_url}/f6/f6a3fbe41c200a9522c10dbcbf2f18d1/fjelltest.mp4";
          hash = "sha256-Gr/bNZpMd/xcJ7c5XXJ3BLyn3lwYaOVhvPx0wRuBSSY=";
        };
        other.se_drill = pkgs.fetchurl {
          url = "${base_url}/d2/d2e499e9eefdf42c69d6d21f63c65456/screenshot_space_engineers_drill.jpg";
          hash = "sha256-yxF9kJXrO9YCXA8MCrnvXf3Z/ArPB88kh02Rhsmm4bM=";
        };
        other.se_scene = pkgs.fetchurl {
          url = "${base_url}/e6/e6b3c37bda6769552b7982648a60d592/screenshot_space_engineers_scene.jpg";
          hash = "sha256-L/TmtbHZlR34pRKAsIXEzjuUEHvQnTc1wq/icM2gvIY=";
        };
        other.sailgame = pkgs.fetchurl {
          url = "${base_url}/43/4328275f8e1ba2c5242961f1e3c73013/sailboat-game-screenshot.png";
          hash = "sha256-fNC6ZxdMph+hXLg4p7e2kLaq4qqoMk3D3DZ33TnE8B0=";
        };
      in
        pkgs.runCommand "combine-demos" {} ''
          mkdir --parents $out/code
          ln --symbolic ${demo_pathfinding.packages.${system}.default} $out/code/pathfinding
          ln --symbolic ${demo_ants.packages.${system}.default} $out/code/ants

          mkdir --parents $out/draw
          ln --symbolic ${draw.uber} $out/draw/logo-ubermensch.png
          ln --symbolic ${draw.scuffed_album} $out/draw/scuffed-album-cover.png
          ln --symbolic ${draw.scuffed_cover} $out/draw/scuffed-cover.png
          ln --symbolic ${draw.raving} $out/draw/logo-raving-high.png
          ln --symbolic ${draw.bandit} $out/draw/bandit-2019.png

          mkdir --parents $out/blender
          ln --symbolic ${blender.tree} $out/blender/tre.mp4
          ln --symbolic ${blender.sailBoat} $out/blender/sail-boat.png
          ln --symbolic ${blender.mosern} $out/blender/mosern.png
          ln --symbolic ${blender.hjelm} $out/blender/hjelm.mp4
          ln --symbolic ${blender.revolver} $out/blender/revolver.png
          ln --symbolic ${blender.npp} $out/blender/nppp-demo-animasjon.mp4
          ln --symbolic ${blender.thompson} $out/blender/thompson.png
          ln --symbolic ${blender.axe} $out/blender/axe.png
          ln --symbolic ${blender.fjell} $out/blender/fjelltest.mp4

          mkdir --parents $out/other
          ln --symbolic ${other.se_drill} $out/other/screenshot_space_engineers_drill.jpg
          ln --symbolic ${other.se_scene} $out/other/screenshot_space_engineers_scene.jpg
          ln --symbolic ${other.sailgame} $out/other/sailboat-game-screenshot.png
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
        configuration = {
          # NOTE: uncache html so it responds to changed wasm filenames
          advanced.headers = [
            {
              source = "**/*.html";
              headers = {"Cache-Control" = "no-cache, must-revalidate";};
            }
            {
              source = "**/main.js";
              headers = {"Cache-Control" = "no-cache, must-revalidate";};
            }
          ];
        };
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
