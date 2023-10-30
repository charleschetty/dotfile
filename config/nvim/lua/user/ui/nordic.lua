
--[[ vim.g.nord_contrast = true ]]
vim.g.nord_borders = true
--[[ vim.g.nord_disable_background = false ]]
vim.g.nord_italic = true
vim.g.nord_bold = true
-- local highlights = require('nord').bufferline.highlights({
--     italic = true,
--     bold = true,
-- })
return function()
  require('nord').set()
end


