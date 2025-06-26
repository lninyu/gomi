# 4.3
function double.toRaw() {
    local -n result="${1:?}"
    local a b

    printf -v a "%.13a" "${2:?}"; b=${a%p*}

    ((result = ${a::1}1 & 0x8000000000000000 | (${a#*+} + 1023) << 52 | 0x1${b#*.} >> 1))
}

function double.fromRaw() {
    local -n result="${1:?}"
    local -i i64="${2:?}" a b

    if ((a = i64 << 1 & 0xfffffffffffff, b = (i64 >> 52) - 1023 & 0x7ff, i64 & 0x8000000000000000))
        then printf -v result -- "-0x1.%xp+%d" ${a} ${b}
        else printf -v result "0x1.%xp+%d" ${a} ${b}
    fi
}
