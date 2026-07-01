# ─── Fish Configuration (mirrors ~/.zshrc) ─────────────────────────────
#   zsh-autosuggestions → fish built-in
#   fast-syntax-highlighting → fish built-in
#   fzf.zsh → PatrickF1/fzf.fish (key bindings: Ctrl+R, Ctrl+Alt+F, etc.)
#   fzf-tab → gazorby/fifc (Tab key triggers fzf completion)
#   p10k → starship (below)

if not status is-interactive
    return
end

# ─── Init: zoxide (defines z + zi; cd expands to z via abbr) ────────────
zoxide init fish | source
abbr -a cd z

# ─── Init: starship prompt ──────────────────────────────────────────────
starship init fish | source

# ─── Init: conda ────────────────────────────────────────────────────────
if test -f /home/charles/.lib/anaconda/etc/profile.d/conda.sh
    # conda.sh is bash; use bass or eval in fish-compatible way
    # For now: manual activation path only (use 'conda activate' via conda's fish integration)
end

# ─── Greeting (replaces zshrc's startup `n` call) ───────────────────────
function fish_greeting
    ccfetch 2>/dev/null
end

# ─── Aliases (fish alias supports wrapping; abbr for interactive expansion)
alias vs="systemctl status v2raya.service"
alias sv="systemctl start v2raya.service"
alias dv="systemctl stop v2raya.service"
alias ls="eza --icons always"
alias c="clear"
alias du="dust"
alias vi3="vim ~/.config/i3/config"
alias top="btm"
alias p="procs"
alias t="tldr"
alias nv="nvim"
alias nvdot='NVIM_APPNAME=nvimdots nvim'
alias find='fd --exclude ~/SourceFile --exclude ~/go'
alias grep="rg"
alias mon="xrandr --output HDMI-A-0 --same-as eDP --auto"
alias diff="delta"
abbr -a sed sd  # abbr (not alias) — plugins like fifc need real sed internally
alias yt-dlp="yt-dlp -f bestvideo+bestaudio --merge-output-format mp4"
alias df="duf"
alias g="gitui"
alias ter="zellij"
alias st="gummy start"
alias rt="gummy -t 6500 -b 4"
alias dt="gummy -t 5400 -b 4"
alias sudo="sudo env PATH=\$PATH"
alias n="ccfetch"
alias intel_env="bash -c '. /opt/intel/oneapi/setvars.sh && exec fish'"
alias opp="open-pdf"  # 'opp' not 'op' — avoids conflict with 1Password CLI
alias opc="open-pdf-cd"

# open-pdf/open-pdf-cd launch their own fzf — disable file path completion
complete -c open-pdf -f
complete -c open-pdf-cd -f
complete -c opp -f
complete -c opc -f
