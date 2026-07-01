function open-pdf --description "fzf open PDF from ~/Documents/BOOK/ (falls back to cwd)"
    set -l orig_dir $PWD
    if test -d ~/Documents/BOOK
        cd ~/Documents/BOOK
    end
    set -l files (fzf-tmux --query="$argv[1]" --multi --select-1 --exit-0 --height 40% 2>/dev/null)
    test -n "$files" && zathura 2>/dev/null $files &; disown
    cd $orig_dir
end
