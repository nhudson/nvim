local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  enable = true, -- enable profiling via :PackerCompile profile=true
  threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  --max_jobs = 20, -- Limit the number of simultaneous jobs. nil means no limit. Set to 20 in order to prevent PackerSync form being "stuck" -> https://github.com/wbthomason/packer.nvim/issues/746
  -- Have packer use a popup window
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
  log = {
    level = 'warn'
  },
})

-- Install your plugins here
return packer.startup(function(use)
  use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
  use({ "nvim-lualine/lualine.nvim", requires = { 'kyazdani42/nvim-web-devicons', opt = true } }) -- Status Line and Bufferline
  use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
  use({ "windwp/nvim-autopairs" }) -- Autopairs, integrates with both cmp and treesitter
  use({ "folke/tokyonight.nvim" }) -- color theme
  use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
  use({ "hrsh7th/cmp-buffer" }) -- buffer completions
  use({ "hrsh7th/cmp-path" }) -- path completions
  use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lua" })
  use({ "hrsh7th/cmp-cmdline" })
  use({ "hrsh7th/cmp-calc" })
  use({ "lukas-reineke/cmp-rg" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
  use({ "L3MON4D3/LuaSnip" }) --snippets
  use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use
  use({ "neovim/nvim-lspconfig" }) -- enable LSP
  use({ "williamboman/mason.nvim"}) -- simple to use language server installer
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  use({ "RRethy/vim-illuminate" })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- treesitter code highlighting
  use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })  -- syntax aware text-objects, select, move, swap, and peek support.
  use({ "RRethy/nvim-treesitter-endwise", after = "nvim-treesitter" }) -- add end in Ruby, Lua, Vimscript, Bash and Elixir
  use({ "simrat39/rust-tools.nvim" }) -- rust specific tools
  use({ "saecki/crates.nvim" }) -- helper to maintain crates.io deps
  use({ "ray-x/go.nvim", requires = "ray-x/guihua.lua", ft = { "go" } }) -- A modern go neovim plugin based on treesitter, nvim-lsp and dap debugger. 
  use({ "akinsho/toggleterm.nvim", requires = "kdheepak/lazygit.nvim" }) -- toggle multiple terminals during an editing session


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
