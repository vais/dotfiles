local M = {}
local repo_uses_eslint_plugin_prettier = {}

local function get_buffer_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return vim.fn.getcwd()
  end

  return vim.fn.fnamemodify(name, ':p:h')
end

local function find_project_root(bufnr)
  local start = get_buffer_dir(bufnr)
  local package_json = vim.fs.find('package.json', {
    upward = true,
    path = start,
    stop = vim.loop.os_homedir(),
  })[1]
  if not package_json then
    return nil
  end

  return vim.fn.fnamemodify(package_json, ':p:h')
end

local function read_package_json(root)
  local path = root .. '/package.json'
  local lines = vim.fn.readfile(path)
  if not lines or vim.tbl_isempty(lines) then
    return nil
  end

  local ok, decoded = pcall(vim.fn.json_decode, table.concat(lines, '\n'))
  if not ok or type(decoded) ~= 'table' then
    return nil
  end

  return decoded
end

local function package_has_eslint_plugin_prettier(root)
  if repo_uses_eslint_plugin_prettier[root] ~= nil then
    return repo_uses_eslint_plugin_prettier[root]
  end

  local pkg = read_package_json(root)
  if not pkg then
    repo_uses_eslint_plugin_prettier[root] = false
    return false
  end

  local deps = pkg.dependencies or {}
  local dev_deps = pkg.devDependencies or {}
  local uses_plugin = deps['eslint-plugin-prettier'] ~= nil
    or dev_deps['eslint-plugin-prettier'] ~= nil

  repo_uses_eslint_plugin_prettier[root] = uses_plugin
  return uses_plugin
end

local function apply_dynamic_javascript_fixer(bufnr)
  local root = find_project_root(bufnr)
  if not root then
    return
  end

  if not package_has_eslint_plugin_prettier(root) then
    return
  end

  vim.b[bufnr].ale_fixers = { javascript = { 'eslint' } }
end

function M.setup(group)
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'javascript' },
    callback = function(args)
      apply_dynamic_javascript_fixer(args.buf)
    end,
  })
end

return M
