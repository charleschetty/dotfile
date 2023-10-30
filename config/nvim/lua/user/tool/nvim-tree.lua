local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

return function()
  local opts = {
    open_on_stepup = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    sort_by = "case_sensitive",

    filters = {
      dotfiles = false,
    },
    renderer = {
      root_folder_modifier = ":t",
      -- webdev_colors = true,
      group_empty = true,
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_open = "",
            arrow_closed = ">",
            empty = "",
            empty_open = "",
            default = "",
            open = "",

            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            untracked = "U",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },

    view = {
      width = 30,
      side = "left",

    },
  }

  require 'nvim-web-devicons'.setup {

    override = {
      zsh = {
        icon = "",
        color = "#428850",
        cterm_color = "65",
        name = "Zsh"
      }
    },
    default = true,
  }
  require("nvim-tree").setup(opts)
end
