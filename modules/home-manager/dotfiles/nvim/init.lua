require("config.lazy")

if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true
end

vim.opt.background = 'dark'
vim.cmd.colorscheme('srcery')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.linebreak = true
vim.opt.showbreak="++"
vim.opt.textwidth=80
vim.opt.showmatch=true
vim.opt.visualbell=true
vim.opt.hlsearch=true
vim.opt.smartcase=true
vim.opt.ignorecase=true
vim.opt.incsearch=true
vim.opt.autoindent=true
vim.opt.expandtab=true

vim.opt.shiftwidth=2      -- Number of auto-indent spaces
vim.opt.smartindent=true  -- Enable smart-indent
vim.opt.smarttab=true     -- Enable smart-tabs
vim.opt.tabstop=2         -- Number of spaces per Tab
vim.opt.softtabstop=2     -- Number of spaces per Tab

vim.opt.ruler=true        -- Show row and column ruler information

vim.opt.undolevels=1000   -- Number of undo levels
vim.opt.backspace={'indent','eol','start'}  -- Backspace behaviour

vim.opt.mouse='a'         -- allow mouse for pasting etc

vim.opt.so=7              -- Keep 7 lines visible at the top and bottom of the screen when scrolling

-- use n and N to center the next search result on the screen
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Escape from terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- show whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }

vim.opt.showmode = false

vim.cmd.filetype('on')
vim.cmd.syntax('on')

-- conceal
vim.opt.conceallevel = 2

-- Set background to be clear
vim.cmd([[autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE]])

