{ mkShell, nil, nixd, nixfmt-rfc-style, deadnix, statix, go, python3 }: let
  custom = {
    python3 = python3.withPackages (ps: [
      ps.build
    ]);
  };
in mkShell {
  packages = [
    nil
    nixd
    nixfmt-rfc-style
    deadnix
    statix
    go
    custom.python3
  ];
}
