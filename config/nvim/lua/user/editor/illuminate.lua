return function()
  require('illuminate').configure({
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		delay = 100,
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "alpha",
      "NvimTree",
      "packer",
      "neogitstatus",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "TelescopePrompt",
    },
		under_cursor = false,
  })
end
