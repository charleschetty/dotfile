return {
  filetypes = { 'racket' },
  cmd = { 'racket', '-l', 'racket-langserver' },
  root_dir = vim.fs.root(0, '.git'),
}
