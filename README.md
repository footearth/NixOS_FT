# NixOS Config

## Mirror

```bash
# https://mirrors.tuna.tsinghua.edu.cn/help/nix/
>> sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
>> sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-20.03 nixos
>> sudo nix-channel --update
>> sudo nix-channel --list

>> sudo nixos-generate-config
>> sudo nixos-install --option binary-caches https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store
>> sudo nixos-rebuild switch # -j auto --update
```
