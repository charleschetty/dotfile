function _fifc_preview_opt -d "Show option description from fish completions (overrides fifc's broken man-page parser)"
    # fifc's built-in version tries to regex-parse man pages, which fails for most commands.
    # $fifc_desc already contains the option description from fish's native completion system.
    # That's exactly what fish shows in its own completion pager — just use it directly.
    set_color brgreen
    echo "$fifc_desc"
    set_color normal
end
