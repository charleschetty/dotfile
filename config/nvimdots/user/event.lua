-- 用户自定义事件/初始化（core/event.lua 在启动时 require 本文件，
-- 顶层语句会在加载阶段执行；返回的 table 会合并进 autocmd 定义）。
--
-- 关掉用不到的可选 host provider（node / perl / ruby）：
-- 否则 `:checkhealth` 会一直报
--   WARNING Missing "neovim" npm (or yarn, pnpm) package.
--   WARNING "Neovim::Ext" cpan module is not installed
--   WARNING `neovim-ruby-host` not found.
-- Python 3 provider 由 core/options.lua 负责，保持启用（pynvim 已装）。
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- 兼容垫片：消掉 blink.compat / cmp-latex-symbols 在 0.12 上的 deprecation 刷屏。
require("user.compat")

-- 这里只做“加载即执行”的初始化，没有额外的 autocmd 需要注册。
return {}
