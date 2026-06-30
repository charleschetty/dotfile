function open-pdf --description "Fuzzy-search PDF in ~/Documents/BOOK/ and open with zathura"
    set -l currentpath $PWD
    cd ~/Documents/BOOK/
    set -l files (fzf-tmux --query="$argv[1]" --multi --select-1 --exit-0 --height 40% 2>/dev/null)
    if test -n "$files"
        zathura 2>/dev/null $files &; disown
    end
    cd $currentpath
end
