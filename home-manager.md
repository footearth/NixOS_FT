# Home Manager

```bash
>> sudo nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
>> sudo nix-channel --update
>> echo "export NIX_PATH=\$HOME/.nix-defexpr/channels\${NIX_PATH:+:}\$NIX_PATH" >> $HOME/.profile 
>> nix-shell '<home-manager>' -A install
>> echo '. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"' >> $HOME/.profile
>> home-manager switch
```
