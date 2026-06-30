function uvm --description "UV Manager Wrapper"
    set -l cmd $argv[1]
    set -l name $argv[2]
    set -l program "/home/charles/Documents/github/uvm/uvm-rs/target/release/uvm-rs"

    if test "$cmd" = activate
        if test -z "$name"
            echo "Usage: uvm activate <name>"
            return 2
        end

        set -l out ($program get-path "$name" 2>/dev/null)
        if test $status -ne 0
            echo "Error: failed to get activate script for '$name'"
            return 1
        end

        source "$out"
        echo "Activated: $name"
    else
        $program $argv
    end
end
