# -inf's nix config

> [!WARNING]
> Very-very work in progress, don't recomend to use.

Replace 'desired-disko.nix' in the end with disko config you like

```console
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount desired-disko.nix
```
