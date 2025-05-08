return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_compiler_method = 'tectonic'
      vim.g.tex_conceal = "abdmgs"
      vim.g.tex_flavor = "latex"
    end
  }
}
