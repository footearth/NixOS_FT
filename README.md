# NixOS Config

### Net

```bash
>> systemctl stop dhcpcd
>> sudo ip addr add 10.10.10.201/24 dev ens18
>> sudo ip route add default via 10.10.10.1 dev ens18
>> sudo cat > /etc/resolv.conf < EOF
   nameserver 223.5.5.5
   nameserver 8.8.8.8
   EOF
```

### Passwd

```bash
>> sudo su -
>> passwd
>> passwd nixos
```

### sshd

```bash
>> systemctl start sshd
```

### Mount

```bash
>> sudo mkfs.fat -F32 /dev/sda1
>> sudo mkswap /dev/sda2
>> sudo mkfs.ext4 /dev/sda3

>> sudo mount /dev/sda3 /mnt
>> sudo swapon /dev/sda2
>> sudo mkdir /mnt/boot
>> sudo mount /dev/sda1 /mnt/book

>> sudo umount /dev/sda1
>> sudo swapoff /dev/sda2
>> sudo umount /dev/sda3
```

### Channel

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
