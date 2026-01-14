# -inf's nix config

Replace 'desired-disko.nix' in the end with disko config you like

```console
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount desired-disko.nix
```
