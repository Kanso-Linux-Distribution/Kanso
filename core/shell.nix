
{ pkgs ? import <nixpkgs> {} }:

let
  pyEnv = (pkgs.python3.withPackages (ps: with ps; [ rtoml ]));
in
pkgs.mkShell {
  buildInputs = [
    pyEnv
    pkgs.helix
    pkgs.gum
  ];

  shellHook = ''
    alias helix="sudo hx"
  '';
}
