{
  lib,
  fetchurl,
  libpcap,
  openssl,
  wayland,
  autoPatchelfHook,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "bptimer";
  version = "0.1.10";

  src = fetchurl {
    url = "https://github.com/woheedev/bptimer/releases/download/v${version}/bptimer-desktop-x86_64-unknown-linux-gnu";
    hash = "sha256-tRLAR9UOP+zxWZT9M5RM44vEDVHY+WgQJESvdWR/UIM=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libpcap
    openssl
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libxkbcommon
    libGL
    libx11
    libxcursor
    libxi
  ];

  unpackPhase = "true";

  sourceRoot = ".";

  installPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -m755 -D $src $out/bin/bptimer
  '';

  meta = {
    description = "Web panel to display live data from Blue Protocol: Star Resonance";
    homepage = "https://github.com/woheedev/bptimer";
    platforms = lib.platforms.linux;
    mainProgram = "bptimer";
  };
}
