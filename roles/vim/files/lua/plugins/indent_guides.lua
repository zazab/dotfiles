local Plugin = {'nathanaelkane/vim-indent-guides'}

function Plugin.init()
  vim.g.indent_guides_enable_on_vim_startup=1
  vim.g.indent_guides_color_change_percent=10
  vim.g.indent_guides_guide_size=1
  vim.g.indent_guides_start_level=2
end

return Plugin
