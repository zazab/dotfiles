-- Space as leader key
vim.g.mapleader = ' '


function map(mode, lhs, rhs, options) 
  vim.keymap.set(mode, lhs, rhs, options)
end

function nmap(lhs, rhs)
  map('n', lhs, rhs, { noremap = true, silent = true })
end

function imap(lhs, rhs)
  map('i', lhs, rhs, {})
end

-- Smart way to move between windows
nmap('<C-j>', '<C-W>j')
nmap('<C-k>', '<C-W>k')
nmap('<C-h>', '<C-W>h')
nmap('<C-l>', '<C-W>l')
nmap('<leader>+', '<C-W>+')
nmap('<leader>-', '<C-W>-')
nmap('<leader>_', '<c-w>_')
nmap('<leader>=', '<c-w>=')
nmap('<leader>llll', ':set list!<cr>')
nmap('<', '<<')
nmap('>', '>>')
nmap('j', 'gj')
nmap('k', 'gk')
nmap('<leader>w', ':w<cr>')
nmap('<leader><cr>', ':noh<cr>')
nmap('<leader>bd', ':bd<cr>')
nmap('0', '^')
