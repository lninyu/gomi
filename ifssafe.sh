function encode() {
    local -r IFS= LC_ALL=C
    local -n result="${1:?}"
    local -i i=0
    local temp

    result=;
    while [[ "${2:i:1}" ]]; do
        printf -v temp "%02x" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}"
        printf -v temp "%016x" "$((0x8080808080808080|(0x${temp}&127|(0x${temp}&127<<7)<<1|(0x${temp}&127<<14)<<2|(0x${temp}&127<<21)<<3|(0x${temp}&127<<28)<<4|(0x${temp}&127<<35)<<5|(0x${temp}&127<<42)<<6|(0x${temp}&127<<49)<<7)))"
        printf -v temp "%b" "\x${temp:0:2}" "\x${temp:2:2}" "\x${temp:4:2}" "\x${temp:6:2}" "\x${temp:8:2}" "\x${temp:10:2}" "\x${temp:12:2}" "\x${temp:14:2}"
        result+="${temp}"
    done
}

function decode() {
    local -r IFS= LC_ALL=C
    local -n result="${1:?}"
    local -i i=0
    local temp

    result=;
    while [[ "${2:i:1}" ]]; do
        printf -v temp "%02x" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}" "'${2:i++:1}"
        printf -v temp "%014x" "$((0x${temp}&127|(0x${temp}&(127<<8))>>1|(0x${temp}&(127<<16))>>2|(0x${temp}&(127<<24))>>3|(0x${temp}&(127<<32))>>4|(0x${temp}&(127<<40))>>5|(0x${temp}&(127<<48))>>6|(0x${temp}&(127<<56))>>7))"
        printf -v temp "%b" "\x${temp:0:2}" "\x${temp:2:2}" "\x${temp:4:2}" "\x${temp:6:2}" "\x${temp:8:2}" "\x${temp:10:2}" "\x${temp:12:2}"
        result+="${temp}"
    done
}
