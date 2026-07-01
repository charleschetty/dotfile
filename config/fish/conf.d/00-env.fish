# ─── Environment Variables (loaded before plugins) ─────────────────────

# CUDA
set -gx CUDA_HOME /opt/cuda
set -gx CUDA_TOOLKIT_PATH /opt/cuda
set -gx LD_LIBRARY_PATH /opt/cuda/lib64

# PATH — fish_add_path prepends; order: last called = first in PATH
fish_add_path /home/charles/.local/bin
fish_add_path /home/charles/.npm-global/bin
fish_add_path /home/charles/go/bin
fish_add_path /opt/cuda/include
fish_add_path /opt/cuda/bin

# fzf: set FZF_DEFAULT_OPTS so fzf.fish doesn't override with its own defaults
# (fzf.fish only sets its defaults when NEITHER FZF_DEFAULT_OPTS nor FZF_DEFAULT_OPTS_FILE is set)
# fzf.fish explicitly passes --preview to fzf, which overrides whatever is here.
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=40% --preview-window=wrap --marker="*" --history=/home/charles/.local/share/fish/fzf_history'

# fzf default file search command (used by standalone fzf, fzf.fish pipes fd directly)
set -gx FZF_DEFAULT_COMMAND 'fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f'

# fzf.fish customizations (NO quotes — fish brace-expands {a,b} → a b, which fd expects)
set -gx fzf_preview_file_cmd 'bash ~/.zsh/file_preview.sh'
set -gx fzf_preview_dir_cmd 'eza -l --no-user --no-time --icons --no-permissions --no-filesize'
set -gx fzf_fd_opts --max-depth 1 --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor}

# Add plugin functions to auto-load path (fzf.fish + fifc)
# User functions must come FIRST so they can override plugin functions
set -g fish_function_path \
    $fish_function_path \
    ~/.config/fish/plugins/fzf.fish/functions \
    ~/.config/fish/plugins/fifc/functions

# ─── fifc: fzf-powered Tab completion (replaces zsh fzf-tab) ──────────
# fd options for file/directory completion (depth=1 keeps it fast)
set -gx fifc_fd_opts --max-depth 1 --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor}
# bat options for file preview in fzf completion
set -gx fifc_bat_opts --style=numbers
# eza options for directory preview in fzf completion
set -gx fifc_exa_opts --icons --tree --level=2
# Editor to open files from fzf completion (Ctrl-o)
set -gx fifc_editor nvim

# CJK character width for fzf
set -gx RUNEWIDTH_EASTASIAN 0
