with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "khcp";
  buildInputs = [
  rubber
  tetex
  ];
}
