{
  description = "rojekti flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system}.default = (import ./default.nix { inherit pkgs; });

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        cargo

        # tmuxinator for testing feature parity
        (ruby.withPackages (ps: with ps; [ tmuxinator ]))
      ];
    };
  };
}
