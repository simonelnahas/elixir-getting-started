{ sources ? import ./nix/sources.nix
, pkgs ? import <nixpkgs> { }
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.elixir
    pkgs.niv
  ];
}