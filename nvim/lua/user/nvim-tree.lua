local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    -- webdev_colors = true,
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          -- arrow_open = "",
          -- arrow_closed = "",
          arrow_open = "",
          arrow_closed = ">",
          -- default = "",
          -- open = "",
          empty = "",
          empty_open = "",
          default = "",
          open = "",

          symlink = "",
          symlink_open = "",
        },
        -- folder = {
        --   arrow_open = "",
        --   arrow_closed = "",
        --   default = "",
        --   open = "",
        --   empty = "",
        --   empty_open = "",
        --   symlink = "",
        --   symlink_open = "",
        -- },
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
  -- diagnostics = {
  --   enable = true,
  --   show_on_dirs = true,
  --   icons = {
  --     hint = "",
  --     info = "",
  --     warning = "",
  --     error = "",
  --   },
  -- },
  view = {
    width = 30,
    height = 30,
    side = "left",
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
  },
}

require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
