# Home Manager

```bash
>> sudo nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
>> sudo nix-channel --update
>> cat < EOF >> $HOME/.profile 
   export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
   EOF
>> nix-shell '<home-manager>' -A install
>> cat < EOF >> $HOME/.profile
   . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
   EOF
>> home-manager switch
```
