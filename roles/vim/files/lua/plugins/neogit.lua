local Plugin = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    --"ibhagwan/fzf-lua",            -- optional
  },
  config = function() 
    require("neogit").setup({
        kind = "split_above",
        git_services = {
          ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
          ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
          ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
          ["stash.avito.ru"] = "https://stash.msk.avito.ru/projects/${owner}/repos/{$repository}/pull-requests?create&sourceBranch=refs%2Fheads%2F${branch_name}"
        },
      })

  end
}

function Plugin.init()
  nmap('<leader>gs', ':Neogit<cr>')
end

return Plugin
