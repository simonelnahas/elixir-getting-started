{ sources ? import ./nix/sources.nix
, pkgs ? import <nixpkgs> { }
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.lfe
    pkgs.rebar3
    pkgs.niv
  ];
}