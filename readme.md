### Ocaml environment using nix

This is a sandboxed and reproducible environment for ocaml.
It uses niv to pin nixpkgs to specific revision.

Nix shell provides aliases for utop and ocaml, which are bootstrapped with ocamlinit,
so that all nixpkgs ocaml packages are available.

To enter sandboxed environment use :

```
$ nix-shell
```

Another automated way of entering nix-shell is to use direnv.
To enable direnv for our project we have to do:

```
$ direnv allow
```

#### Dependencies:

- [nix](https://nix.dev)
- [niv](https://github.com/nmattia/niv)
- [direnv](https://direnv.net/)
