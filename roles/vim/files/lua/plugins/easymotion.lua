local Plugin = {'Lokaltog/vim-easymotion'}

function Plugin.init()
  vim.g.EasyMotion_do_mapping = 0
  vim.g.EasyMotion_smartcase = 1

  -- map <Leader> <Plug>(easymotion-prefix)
  -- vim.keymap.set({'v', 'n'}, '<leader>', '<Plug>(easymotion-prefix)')
  vim.keymap.set('n', '<leader>s', '<Plug>(easymotion-s2)')
  vim.keymap.set('n', '<leader>j', '<Plug>(easymotion-j)')
  vim.keymap.set('n', '<leader>k', '<Plug>(easymotion-k)')
  vim.keymap.set('n', '<leader>/', '<Plug>(easymotion-sn)')
end

return Plugin
