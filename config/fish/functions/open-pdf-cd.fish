function open-pdf-cd --description "Fuzzy-search PDF in current directory and open with zathura"
    set -l files (fzf-tmux --query="$argv[1]" --multi --select-1 --exit-0 --height 40% 2>/dev/null)
    if test -n "$files"
        zathura 2>/dev/null $files &; disown
    end
end
