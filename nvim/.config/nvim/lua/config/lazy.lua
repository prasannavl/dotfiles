local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "ellisonleao/gruvbox.nvim" },
    -- TODO
    -- { "epwalsh/obsidian.nvim" },
    -- { "preservim/vim-pencil" },
    { "tpope/vim-rsi" },
    { "sindrets/diffview.nvim" },
    { "tpope/vim-fugitive" }, -- git
    { "tpope/vim-sleuth" }, -- auto shift width, tab stop
    { "nvim-telescope/telescope-symbols.nvim" }, -- emojis
    { "lewis6991/satellite.nvim" }, -- scrollbar
    { "NoahTheDuke/vim-just", lazy = true },
    { "IndianBoy42/tree-sitter-just", lazy = true },
    {
      "echasnovski/mini.surround",
      opts = {
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      },
    },
    {
      "folke/noice.nvim",
      opts = {
        cmdline = {
          view = "cmdline",
        },
      },
    },
    { "catppuccin/nvim", name = "catppuccin" },
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
        -- colorscheme = "gruvbox",
      },
    import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
