{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    vim
    ntp inetutils iw wpa_supplicant networkmanager
    htop nload ncdu
    mosh tmux zsh fish
    wget curl httpie
    # bash-it oh-my-zsh oh-my-fish
    bat ag fd fzf z-lua autojump
    # jethrokuan/z jethrokuan/fzf
    git tig

    kind kubectl kubectx k9s
  ];
}
