# 4.2
function util.sleep() {
    read -srt "${1:?}" _
}

readonly -f util.sleep
