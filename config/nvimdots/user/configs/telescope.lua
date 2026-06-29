return function(opts)
	vim.schedule(function()
		pcall(require("telescope").load_extension, "media_files")
		pcall(require("telescope").load_extension, "thesaurus")
	end)
	return opts
end
