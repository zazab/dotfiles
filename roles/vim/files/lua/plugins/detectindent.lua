local Plugin = {'ciaranm/detectindent'}

function Plugin.init()
  vim.g.detectindent_preferred_expandtab = 1
  vim.g.detectindent_preferred_indent = 4
end

return Plugin
