{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3   # running kanso
    git       # config version
    nano      # editor
    cage      # ui
    foot      # terminal
    fastfetch # information
    btop      # monitor
    impala    # network
    gum       # Kanso Pannel
    tmux      # Window management
  ];
}

