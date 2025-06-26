# 4.3
function double.toRaw() {
    local -n result="${1:?}"
    local a b

    printf -v a "%.13a" "${2:?}"; b=${a%p*}

    ((result = ${a::1}1 & 0x8000000000000000 | (${a#*+} + 1023) << 52 | 0x1${b#*.} & 0xfffffffffffff))
}

function double.fromRaw() {
    local -n result="${1:?}"
    local -i a b

    if ((a = ${2:?} & 0xfffffffffffff, b = ((${2} >> 52) - 1023) & 0x7ff, ${2} & 0x8000000000000000))
        then printf -v result -- "-0x1.%.13xp+%d" ${a} ${b}
        else printf -v result "0x1.%.13xp+%d" ${a} ${b}
    fi
}
