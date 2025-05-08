{ pkgs, config, ... }:

{
  home.shellAliases = {
    ls = "eza";
    cd = "z";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      extended = true;
      share = false;
      ignoreAllDups = true;
    };
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.bash = {
    enable = true;
  };

  programs.nh.enable = true;

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv.enable = true;

  programs.bat.enable = true;

  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "aarya.patel@gmail.com";
    userName = "Aarya Patel";
  };

  programs.eza = {
    enable = true;
    git = true;
    colors = "auto";
    icons = "auto";
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableTransience = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  home.packages = with pkgs; [
    fd
    ripgrep
    ncdu
    rmlint
    unzip
    autossh
    nix-output-monitor
    nix-fast-build
    nix-tree
  ];
}
