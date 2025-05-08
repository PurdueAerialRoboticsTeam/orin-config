{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # Language server deps
      lua-language-server
      rust-analyzer
      nixd
      tree-sitter
      clang-tools
      texlab
      clang
      inputs.bacon-ls.defaultPackage.${pkgs.system}
    ];
  };

  home.packages = with pkgs; [
    bacon
  ];

  xdg = {
    enable = true;
    configFile."nvim" = {
      source = ./dotfiles/nvim;
      recursive = true;
    };
  };
}
