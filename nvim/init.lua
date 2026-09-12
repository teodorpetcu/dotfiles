vim.o.number = true
vim.o.relativenumber = false

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.smarttab = true

vim.o.textwidth = 80
vim.o.wrap = true
vim.o.linebreak = true

vim.o.updatetime = 100 -- 100ms; default is 4s

vim.o.termguicolors = true

vim.o.guicursor = "" -- don't change default terminal cursor

-- this is probably (most definitely) not optimal
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function(_)
    vim.o.tabstop = 2
	vim.o.shiftwidth = 2
  end
})

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true

vim.cmd("colorscheme retrobox")

-- search

vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- other

vim.o.swapfile = false
vim.o.backup = false

vim.o.scrolloff = 8

vim.o.mouse = ""
vim.o.mousemodel = "extend"

vim.o.signcolumn = "yes"

vim.g.mapleader = "\\"

-- disable arrow keys and mouse
vim.keymap.set({"n", "i", "v"}, "<up>", "")
vim.keymap.set({"n", "i", "v"}, "<down>", "")
vim.keymap.set({"n", "i", "v"}, "<left>", "")
vim.keymap.set({"n", "i", "v"}, "<right>", "")
vim.keymap.set({"n", "c", "i", "v"}, "<BS>", "")
vim.keymap.set({"n", "c", "i", "v"}, "<DEL>", "")
vim.keymap.set({"n", "c", "i", "v"}, "<C-c>", "")

-- switch windows with <leader><key> (synonym with <C-w><key>)
for _,winkey in ipairs({ "h", "j", "k", "l", "H", "J", "K", "L" })
do
    vim.keymap.set({"n"}, "<leader>" .. winkey, ":wincmd " .. winkey .. "<CR>")
end

-- bindings
vim.keymap.set("n", "<leader>gf", ":e <cfile><CR>")

-- packages

vim.pack.add{
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { src = 'https://github.com/preservim/nerdcommenter' },
    { src = 'https://github.com/airblade/vim-gitgutter' },
}

require("nvim-autopairs").setup { map_bs = false, map_cr = true, map_c_h = true, map_c_w = true }

-- treesitter

TREESITTER_LANGS = { "nix", "rust", "haskell", "c", "dockerfile", "javascript", "yaml", "toml", "markdown", "lua", "bash", "zsh", "python" }

require("nvim-treesitter").install(TREESITTER_LANGS)

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.api.nvim_create_autocmd('FileType', {
  pattern = TREESITTER_LANGS,
  callback = function() vim.treesitter.start() end,
})

-- LSP
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- disable "Undefined global" warnings on vim and hyprland
vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim", "hl" } } } } })

LSP_SERVERS = { "rust_analyzer", "hls", "pyright", "nil_ls", "ccls", "lua_ls", "ts_ls" }

for _,lsp_server in ipairs(LSP_SERVERS)
do
    vim.lsp.enable(lsp_server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- disable highlighting from LSPs ; prefer treesitter highlighting
    client.server_capabilities.semanticTokensProvider = nil
    -- enable completion through default <C-x><C-o> followed by <C-y>
    if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    end
  end,
});

-- diagnostic messages style
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
  underline = true,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})
