local Plugin = {'majutsushi/tagbar'}

function Plugin.init()
  vim.keymap.set('n', '<F8>', ':TagbarOpen<cr>', {silent=true})
end

return Plugin
