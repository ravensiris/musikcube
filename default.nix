{ lib
, llvmPackages_11
, cmake
, pkg-config
, boost
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg
, gnutls
, lame
, libev
, libmicrohttpd
, libopenmpt
, mpg123
, ncurses
, stdenv
, taglib
, asio
# Linux Dependencies
, alsa-lib ? stdenv.isLinux
, pulseaudio ? stdenv.isLinux
, systemdSupport ? stdenv.isLinux
, systemd ? stdenv.isLinux
# Darwin Dependencies
, Cocoa ? stdenv.isDarwin
, SystemConfiguration ? stdenv.isDarwin}:

llvmPackages_11.stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost
    curl
    ffmpeg
    gnutls
    lame
    libev
    libmicrohttpd
    libopenmpt
    mpg123
    ncurses
    taglib
    asio
  ] ++ lib.optionals systemdSupport [
    systemd
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib pulseaudio
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa SystemConfiguration
  ];

  cmakeFlags = [
    "-DDISABLE_STRIP=true"
  ];

  postFixup = lib.optionals stdenv.isDarwin ''
    install_name_tool -add_rpath $out/share/${pname} $out/share/${pname}/${pname}
    install_name_tool -add_rpath $out/share/${pname} $out/share/${pname}/${pname}d
  '';

  meta = with lib; {
    homepage = "https://github.com/nixvital/nix-based-cpp-starterkit";
    description = ''
      A template for Nix based C++ project setup.";
    '';
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd3;
    # maintainers = [ maintainers.breakds ];
  };
}
