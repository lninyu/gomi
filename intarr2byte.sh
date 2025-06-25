function iatb.encode() {
    local -r IFS= LC_ALL=C
    local -n array="${1:?}"
    local temp

    printf -v temp "%016x" "${array[@]}"

    local -i index count=${#array[@]}
    local -a iahex

    while ((count--)); do ((index = count << 4))
        iahex[count]="\x${temp:index:2}\x${temp:index+2:2}\x${temp:index+4:2}\x${temp:index+6:2}\x${temp:index+8:2}\x${temp:index+10:2}\x${temp:index+12:2}\x${temp:index+14:2}"
    done

    printf "%b" "${iahex[@]}"
}

function iatb.decode() {
    local -r IFS= LC_ALL=C
    local -n array="${1:?}"
    local a b c d

    while read -d "" -srn1 a; do
        printf -v a "%02x" "'${a}"; b+=${a}
    done

    (( c = ${#b}, d = c >> 4 ))

    until (( (c -= 16) & 0x8000000000000000 )); do
        (( array[--d] = 0x${b:c:16} ))
    done
}
