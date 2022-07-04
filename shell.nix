{ 
 pkgs ? import <nixpkgs> { }
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.elixir
    pkgs.niv
  ];
}