function int64n:fill() {
    local -n _0="${1:?}"; _0=()
    local -i size="${2:-0}"
    local -a temp=()

    temp+=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    temp+=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

    until (((size -= 64) & 0x8000000000000000)); do
        _0+=(${temp[@]})
    done

    _0+=(${temp[@]::64 + size})
}
function int64n:set() { :;}
function int64n:get() { :;}
function int64n:not() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i size=${#_1[@]}

    while ((size--)); do
        ((_0[size] = ~_1[size]))
    done
}
function int64n:and() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i size=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((size--)); do
        ((_0[size] = _1[size] & _2[size]))
    done
}
function int64n:or() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i size=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((size--)); do
        ((_0[size] = _1[size] | _2[size]))
    done
}
function int64n:xor() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i size=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((size--)); do
        ((_0[size] = _1[size] ^ _2[size]))
    done
}
function int64n:nand() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i size=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((size--)); do
        ((_0[size] = ~(_1[size] & _2[size])))
    done
}
function int64n:nor() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i size=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((size--)); do
        ((_0[size] = ~(_1[size] | _2[size])))
    done
}
function int64n:xnor() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i size=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((size--)); do
        ((_0[size] = ~(_1[size] ^ _2[size])))
    done
}
function int64n:andAssign() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i size=$((${#_0[@]} > ${#_1[@]} ? ${#_0[@]} : ${#_1[@]}))

    while ((size--)); do
        ((_0[size] &= _1[size]))
    done
}
function int64n:orAssign() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i size=$((${#_0[@]} > ${#_1[@]} ? ${#_0[@]} : ${#_1[@]}))

    while ((size--)); do
        ((_0[size] |= _1[size]))
    done
}
function int64n:xorAssign() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i size=$((${#_0[@]} > ${#_1[@]} ? ${#_0[@]} : ${#_1[@]}))

    while ((size--)); do
        ((_0[size] ^= _1[size]))
    done
}
function int64n:asr() {
    :
}
function int64n:asl() {
    :
}
function int64n:lsr() {
    :
}
function int64n:lsl() {
    :
}
function int64n:ror() {
    :
}
function int64n:rol() {
    :
}
