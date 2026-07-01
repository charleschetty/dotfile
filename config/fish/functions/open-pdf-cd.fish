function open-pdf-cd --description "fzf open PDF from current directory"
    set -l files (fzf-tmux --query="$argv[1]" --multi --select-1 --exit-0 --height 40% 2>/dev/null)
    test -n "$files" && zathura 2>/dev/null $files &; disown
end
