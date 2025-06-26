if (( BASH_VERSINFO[0] > 4 || BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2 )); then
    function util.sleep() {
        read -srt "${1:?}" _
    }

    readonly -f util.sleep
fi
