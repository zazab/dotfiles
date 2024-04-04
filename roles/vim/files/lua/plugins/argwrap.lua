local Plugin = {'FooSoft/vim-argwrap'}

function Plugin.init()
  vim.keymap.set('n', '<leader>a', ':ArgWrap<cr>', {silent=true})
end

return Plugin
