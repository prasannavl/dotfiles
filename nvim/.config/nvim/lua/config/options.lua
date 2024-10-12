-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
o = vim.opt

o.wrap = true
o.breakindent = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = -1

-- Ensure left/right at beginning/end of line moves to the prev/next
o.whichwrap:append({
  ["<"] = true,
  [">"] = true,
  ["["] = true,
  ["]"] = true,
  h = true,
  l = true,
})

-- Default '/' is too distracting
o.fillchars:append({ diff = "-" })
