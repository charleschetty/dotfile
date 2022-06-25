export HISTSIZE=1000
export EDITOR="vim"
__conda_setup="$('/home/charles/SourceFile/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/charles/SourceFile/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/charles/SourceFile/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/charles/SourceFile/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

export PATH="/home/charles/.local/bin:$PATH"
export PATH="~/.npm-global/bin:$PATH"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/autojump/autojump.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#ZSH_AUTOSUGGEST_STRATEGY=(history completion)

alias n=neofetch
alias bty='for W in $(wmctrl -l |grep "Typora" |awk '"'"'{print $1}'"'"'); do xprop -id $W -format _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100))); done'
alias provpn='export all_proxy=http://127.0.0.1:7890 '
alias bqt='for W in $(wmctrl -l |grep "Qt Creator" |awk '"'"'{print $1}'"'"'); do xprop -id $W -format _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100))); done'
alias stx=' ssh -i ~/.ssh/01.pem ubuntu@myip'
alias sfx=' sftp -i ~/.ssh/01.pem ubuntu@myip'
alias aliyun=' /home/charles/.local/bin/aliyundrive-webdav  --refresh-token="mytocken" --port=8080  --auth-user=myuser --auth-password=mypswd'
alias bypm='for W in $(wmctrl -l |grep "YesPlayMusic" |awk '"'"'{print $1}'"'"'); do xprop -id $W -format _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100))); done'
alias pw=poweroff
alias boffice='for W in $(wmctrl -l |grep "LibreOffice" |awk '"'"'{print $1}'"'"'); do xprop -id $W -format _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100))); done'
alias rb=reboot
alias bkate='for W in $(wmctrl -l |grep "Kate" |awk '"'"'{print $1}'"'"'); do xprop -id $W -format _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100))); done'
alias bcode='for W in $(wmctrl -l |grep "Visual Studio Code" |awk '"'"'{print $1}'"'"'); do xprop -id $W -format _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100))); done'
alias vpn="expressvpn connect"
alias dvpn="expressvpn disconnect"
alias ls="lsd"
alias c="clear"
alias cn="clear;n"
alias du="dust"
alias e="exa --icons"
alias vi3="vim ~/.config/i3/config"
alias top="gotop"
n


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


 HISTFILE=$HOME/.zsh_history
 HISTSIZE=5000
 SAVEHIST=5000
## Settings for umask
setopt appendhistory
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY

source ~/.powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#eval "$(starship init zsh)"
