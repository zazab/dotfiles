local Plugin = {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
}

function Plugin.init()
  -- See :help telescope.builtin
  vim.keymap.set('n', '<leader>/', ':Neotree toggle current reveal_force_cwd<cr>')
  vim.keymap.set('n', '<leader>\\', ':Neotree reveal<cr>')
  vim.keymap.set('n', '<leader>gd', ':Neotree float reveal_file=<cfile> reveal_force_cwd<cr>')
  vim.keymap.set('n', '<leader>b', ':Neotree toggle show buffers right<cr>')
  vim.keymap.set('n', '<leader>s', ':Neotree float git_status<cr>')
end

return Plugin
