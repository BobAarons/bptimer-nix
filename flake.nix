{
  description = "BPTimer – Web panel to display live data from Blue Protocol: Star Resonance";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.stdenv.mkDerivation rec {
          pname = "bptimer";
          version = "0.2.0";
          src = pkgs.fetchurl {
            url = "https://github.com/woheedev/bptimer/releases/download/v${version}/bptimer-desktop-x86_64-unknown-linux-gnu";
            hash = "sha256-widXmZ13nAbCar2iIME6Ij6BDk4FPAVPrI5hEBq134M=";
          };

          nativeBuildInputs = with pkgs; [
            makeWrapper
            autoPatchelfHook
          ];

          buildInputs = [
            pkgs.libpcap
            pkgs.openssl
            pkgs.stdenv.cc.cc
          ];

          runtimeDependencies = [
            pkgs.wayland
            pkgs.libxkbcommon
            pkgs.libGL
            pkgs.libx11
            pkgs.libxcursor
            pkgs.libxi
          ];

          unpackPhase = "true";

          installPhase = ''
            install -Dm755 $src $out/bin/bptimer
          '';
        };
      }
    );

    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/bptimer";
      };
    });
  };
}
