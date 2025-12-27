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
        -- essentials

        { "tpope/vim-rsi" }, -- cmd line like key bindings
        { "tpope/vim-sleuth" }, -- auto shift width, tab stop
        { "lewis6991/satellite.nvim" }, -- scrollbar
        { "tpope/vim-fugitive" }, -- git
        { "sindrets/diffview.nvim" }, -- git diffview

        -- ai
        {
            "olimorris/codecompanion.nvim",
            opts = {},
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
        },

        -- lang stuff

        { "NoahTheDuke/vim-just", lazy = true },
        { "IndianBoy42/tree-sitter-just", lazy = true },
        -- todo

        -- { "epwalsh/obsidian.nvim" },
        -- { "preservim/vim-pencil" },

        -- themes

        -- { "ellisonleao/gruvbox.nvim" },

        -- lazyvim plugins

        {
            "nvim-mini/mini.surround",
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
            enabled = false,
            opts = {
                cmdline = {
                    view = "cmdline",
                },
            },
        },
        {
            "LazyVim/LazyVim",
            import = "lazyvim.plugins",
        },
        -- import/override with our plugins
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
    install = { colorscheme = { "habamax" } },
    checker = {
        enabled = true, -- check for plugin updates periodically
        notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                -- "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                -- "tohtml",
                "tutor",
                -- "zipPlugin",
            },
        },
    },
})

local not_in_wayland = (vim.env.WAYLAND_DISPLAY == nil) and (vim.env.DISPLAY == nil)
local on_real_tty = (vim.env.XDG_SESSION_TYPE == "tty") or (vim.env.TERM == "linux")

if not_in_wayland and on_real_tty then
    vim.opt.termguicolors = false
    vim.cmd("colorscheme default")
end
