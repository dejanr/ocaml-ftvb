let
  sources = import ./nix/sources.nix;
  nixpkgs = sources.nixpkgs;
  pkgs = import nixpkgs {};

  ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocamlPackages_latest;
  ocamlVersion = (builtins.parseDrvName ocamlPackages.ocaml.name).version;
  findlibSiteLib = "${ocamlPackages.findlib}/lib/ocaml/${ocamlVersion}/site-lib";
  ocamlInit = pkgs.writeText "ocamlinit" ''
    let () =
      try Topdirs.dir_directory "${findlibSiteLib}"
      with Not_found -> ()
    ;;
    #use "topfind";;
  '';

in

pkgs.mkShell {
  buildInputs = with ocamlPackages; [
    ocaml
    findlib
    utop
  ] ++ [
    pkgs.opam
    pkgs.niv
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:."
    alias utop="utop -init ${ocamlInit}"
    alias ocaml="ocaml -init ${ocamlInit}"
  '';
}
