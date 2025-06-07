declare -ai _MASK_L=(0) _MASK_R=(0); {
    declare -i i
    for i in {1..63}; do
        ((_MASK_L[i] =   (1 <<       i ) - 1 ))
        ((_MASK_R[i] = ~((1 << (64 - i)) - 1)))
    done
    unset i

    readonly _MASK_L _MASK_R
}

function int64n:fill() {
    local -n _0="${1:?}"; _0=()
    local -i _2=${2//[^0-9]/}
    local -ai temp=(${3:-0})

    temp+=(${temp[@]} ${temp[@]} ${temp[@]})
    temp+=(${temp[@]} ${temp[@]} ${temp[@]})
    temp+=(${temp[@]} ${temp[@]} ${temp[@]}) # 4**3

    until (((_2 -= 64) & 0x8000000000000000)); do
        _0+=(${temp[@]})
    done

    _0+=(${temp[@]::64 + _2})
}
function int64n:set() { :;}
function int64n:get() { :;}
function int64n:not() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i _2=${#_1[@]}

    while ((_2--)); do
        ((_0[_2] = ~_1[_2]))
    done
}
function int64n:and() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i _3=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((_3--)); do
        ((_0[_3] = _1[_3] & _2[_3]))
    done
}
function int64n:or() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i _3=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((_3--)); do
        ((_0[_3] = _1[_3] | _2[_3]))
    done
}
function int64n:xor() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i _3=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((_3--)); do
        ((_0[_3] = _1[_3] ^ _2[_3]))
    done
}
function int64n:nand() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i _3=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((_3--)); do
        ((_0[_3] = ~(_1[_3] & _2[_3])))
    done
}
function int64n:nor() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i _3=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((_3--)); do
        ((_0[_3] = ~(_1[_3] | _2[_3])))
    done
}
function int64n:xnor() {
    local -n _0="${1:?}" _1="${2:?}" _2="${3:?}"
    local -i _3=$((${#_1[@]} > ${#_2[@]} ? ${#_1[@]} : ${#_2[@]}))

    while ((_3--)); do
        ((_0[_3] = ~(_1[_3] ^ _2[_3])))
    done
}
function int64n:andAssign() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i _2=$((${#_0[@]} > ${#_1[@]} ? ${#_0[@]} : ${#_1[@]}))

    while ((_2--)); do
        ((_0[_2] &= _1[_2]))
    done
}
function int64n:orAssign() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i _2=$((${#_0[@]} > ${#_1[@]} ? ${#_0[@]} : ${#_1[@]}))

    while ((_2--)); do
        ((_0[_2] |= _1[_2]))
    done
}
function int64n:xorAssign() {
    local -n _0="${1:?}" _1="${2:?}"
    local -i _2=$((${#_0[@]} > ${#_1[@]} ? ${#_0[@]} : ${#_1[@]}))

    while ((_2--)); do
        ((_0[_2] ^= _1[_2]))
    done
}
function int64n:asr() { :;}
function int64n:asl() { :;}
function int64n:lsr() {
    local -n result="${1:?}" array="${2:?}"
    local -i _shift="${3//[^0-9]/}"
    local -i shiftW=_shift/64 shiftB=_shift%64
    local -i i=-1 j=${#array[@]}-shiftW-1

    if ((shiftW)); then
        result=(${array[@]:shiftW})

        while ((shiftW--)); do
            result+=(0)
        done
    else
        result=(${array[@]})
    fi

    if ((shiftB)); then
        while ((++i < j)); do
            ((result[i] = result[i] >> shiftB | (result[i+1] & _MASK_L[shiftB]) << (64 - shiftB)))
        done

        ((result[i] >>= shiftB))
    fi
}
function int64n:lsl() { :;}
function int64n:ror() { :;}
function int64n:rol() { :;}
function int64n:add() { :;}
function int64n:sub() { :;}
function int64n:mul() { :;}
function int64n:div() { :;}
function int64n:mod() { :;}

function array2bits() {
    local -n array="${1:?}"
    local -i i=${#array[@]} j
    local text

    while ((j = 64, i--)); do
        while ((j--)); do
            text+=$((array[i] >> j & 1))
        done

        text+=$'\n'
    done

    if [[ ${2} ]]; then
        text="${text//0/${2::1}}"
        echo -n "${text//1/${2:1:1}}"
    else
        echo -n "${text}"
    fi
}

declare a=(16 8 4 2 1)
int64n:lsr a a 65
array2bits a .+
