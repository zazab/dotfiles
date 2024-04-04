local Plugin = {'scrooloose/syntastic'}

function Plugin.init()
  -- set statusline+=%#warningmsg#
  -- set statusline+=%{SyntasticStatuslineFlag()}
  -- set statusline+=%*

  vim.g.syntastic_always_populate_loc_list = 1
  vim.g.syntastic_loc_list_height = 5
  vim.g.syntastic_auto_loc_list = 0
  vim.g.syntastic_check_on_open = 1
  vim.g.syntastic_check_on_wq = 0

  vim.g.syntastic_go_checkers = {'gometalinter'}
  vim.g.syntastic_go_gometalinter_args = '--config ~/.config/gometalinter.json --fast'

  vim.g.syntastic_javascript_checkers = {'eslint'}

end

return Plugin
