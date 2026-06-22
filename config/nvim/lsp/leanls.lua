local function will_use_lake_server(dir)
  return vim.uv.fs_stat(vim.fs.joinpath(dir, 'lakefile.lean'))
    or vim.uv.fs_stat(vim.fs.joinpath(dir, 'lakefile.toml'))
end

local function is_core_lean4_directory(dir)
  if
    vim.uv.fs_stat(vim.fs.joinpath(dir, 'Init.lean'))
    and vim.uv.fs_stat(vim.fs.joinpath(dir, 'Lean.lean'))
    and vim.uv.fs_stat(vim.fs.joinpath(dir, 'kernel'))
    and vim.uv.fs_stat(vim.fs.joinpath(dir, 'runtime'))
  then
    return true
  end
  if
    vim.uv.fs_stat(vim.fs.joinpath(dir, 'LICENSE'))
    and vim.uv.fs_stat(vim.fs.joinpath(dir, 'LICENSES'))
    and vim.uv.fs_stat(vim.fs.joinpath(dir, 'src'))
  then
    return true
  end
  return false
end

return {
  filetypes = { 'lean' },
  cmd = function(dispatchers, config)
    local cmd_cwd = config.cmd_cwd
    if not cmd_cwd and config.root_dir and vim.uv.fs_realpath(config.root_dir) then
      cmd_cwd = config.root_dir
    end
    local local_cmd
    if cmd_cwd and will_use_lake_server(cmd_cwd) then
      local_cmd = { 'lake', 'serve', '--', config.root_dir }
    else
      local_cmd = { 'lean', '--server', config.root_dir }
    end
    return vim.lsp.rpc.start(local_cmd, dispatchers, {
      cwd = cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    fname = vim.fs.normalize(fname)
    local packages_suffix = '/.lake/packages/'
    local _, endpos = fname:find(packages_suffix)
    if endpos then
      on_dir(fname:sub(1, endpos - packages_suffix:len()))
      return
    end
    on_dir(
      vim.fs.root(fname, { 'lakefile.toml', 'lakefile.lean', 'lean-toolchain' })
        or vim.iter(vim.fs.parents(fname)):find(is_core_lean4_directory)
    )
  end,
  init_options = {
    editDelay = 10,
    hasWidgets = true,
  },
  capabilities = {
    lean = {
      silentDiagnosticSupport = true,
      rpcWireFormat = 'v1',
    },
  },
}
