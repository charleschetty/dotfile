function clean-pac --description "Remove orphaned pacman packages"
    set -l pkgs (paru -Qqdt 2>/dev/null)
    if test (count $pkgs) -gt 0
        paru -Rs $pkgs
    else
        echo "No orphaned packages to remove."
    end
end
