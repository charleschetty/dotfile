sensors | grep 'Package id 0' | awk -F'[+:° ]+' '{printf "  %d°C\n", int($4+0.5)}'

