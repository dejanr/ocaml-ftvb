let
  commit = "aa440d87866d43d463021b4ea2eaf3ac50d1f9a0"; # nixos-unstable on 2019-05-31
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${commit}.tar.gz";
    sha256 = "152vdrdwnsd1nwj3mn4dy67wab4izaz84dalj54wi677zayacs9k";
  };
  pkgs = import nixpkgs { config = {}; };

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
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:."
    alias utop="utop -init ${ocamlInit}"
    alias ocaml="ocaml -init ${ocamlInit}"
  '';
}
