local Plugin = {'nvim-lualine/lualine.nvim'}

Plugin.event = 'VeryLazy'

-- See :help lualine.txt
Plugin.opts = {
  options = {
    theme = 'tokyonight',
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {'NvimTree', 'neo-tree'}
    }
  },
}

function Plugin.init()
  vim.opt.showmode = false
end

return Plugin
