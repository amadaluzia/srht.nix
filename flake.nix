{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, ... }: let
    inherit (nixpkgs) lib;
    pkgsFor = nixpkgs.legacyPackages;
    forAllSystems = f: lib.genAttrs (import systems) (system: f system pkgsFor.${system});
  in {
    devShells = forAllSystems (_: pkgs: {
      default = pkgs.callPackage ./flake/shell.nix { };
    });

    formatter = forAllSystems (_: pkgs: pkgs.writeShellApplication {
      name = "linter";
      runtimeInputs = [
	pkgs.deadnix
	pkgs.statix
	pkgs.nixfmt-rfc-style
	pkgs.go
      ];
      text = ''
	find . -iname "*.nix" -exec nixfmt {} + \; -exec deadnix -e {} + \; -exec statix fix {} \;
	find . -iname "*.go" -exec go fmt {} \;
      '';
    });
  };
}
