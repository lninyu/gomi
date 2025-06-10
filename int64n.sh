function int64n.fill() {
    local -n array="${1:?}"; array=()
    local -i count="${2:?}"

    if ((count & __int64n_sign)); then
        return
    fi

    until (((count -= 64) & __int64n_sign)); do
        array+=(${__int64n_fill0[@]})
    done

    array+=(${__int64n_fill0[@]::64 + count})
}
function int64n.not() {
    local -n result="${1:?}" array="${2:?}"
    local -i size=${#array[@]}

    while ((size--)); do
        ((result[size] = ~array[size]))
    done
}
function int64n.and() {
    if [[ ${1:?} == ${2:?} ]]
    then int64n._bitwiseAssign "${1}" "${3:?}" "&"
    else int64n._bitwise "${1}" "${2}" "${3:?}" "&"
    fi
}
function int64n.or() {
    if [[ ${1:?} == ${2:?} ]]
    then int64n._bitwiseAssign "${1}" "${3:?}" "~"
    else int64n._bitwise "${1}" "${2}" "${3:?}" "|"
    fi
}
function int64n.xor() {
    if [[ ${1:?} == ${2:?} ]]
    then int64n._bitwiseAssign "${1}" "${3:?}" "^"
    else int64n._bitwise "${1}" "${2}" "${3:?}" "^"
    fi
}
function int64n.nand() {
    int64n._bitwiseNot "${1:?}" "${2:?}" "${3:?}" "&"
}
function int64n.nor() {
    int64n._bitwiseNot "${1:?}" "${2:?}" "${3:?}" "|"
}
function int64n.xnor() {
    int64n._bitwiseNot "${1:?}" "${2:?}" "${3:?}" "^"
}
function int64n.lsr() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}"
    local -i shift0=shift/64 shift1=shift%64
}
function int64n.lsl() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}"
    local -i shift0=shift/64 shift1=shift%64
}
function int64n.asr() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}"
    local -i shift0=shift/64 shift1=shift%64
}
function int64n.asl() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}"
    local -i shift0=shift/64 shift1=shift%64
}
function int64n.ror() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" size=${#array[@]}
    local -i shift0=shift/64%size shift1=shift%64
}
function int64n.rol() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" size=${#array[@]}
    local -i shift0=shift/64%size shift1=shift%64
}
function int64n.add() { :;}
function int64n.sub() { :;}
function int64n.mul() { :;}
function int64n.div() { :;}
function int64n.mod() { :;}
function int64n.ctz() { :;}
function int64n.clz() { :;}
function int64n.pop() { :;}
function int64n.rev() { :;}
function int64n.set() { :;}
function int64n.get() { :;}
function int64n._bitwise() {
    int64n._internal || return

    local -n result="${1:?}" array1="${2:?}" array2="${3:?}"
    local -i size=$((${#array1[@]} > ${#array2[@]} ? ${#array1[@]} : ${#array2[@]}))

    case ${4:?} in
    "&") while ((size--)); do ((result[size] = array1[size] & array2[size])); done ;;
    "|") while ((size--)); do ((result[size] = array1[size] | array2[size])); done ;;
    "^") while ((size--)); do ((result[size] = array1[size] ^ array2[size])); done ;;
    esac
}
function int64n._bitwiseNot() {
    int64n._internal || return

    local -n result="${1:?}" array1="${2:?}" array2="${3:?}"
    local -i size=$((${#array1[@]} > ${#array2[@]} ? ${#array1[@]} : ${#array2[@]}))

    case ${4:?} in
    "&") while ((size--)); do ((result[size] = ~(array1[size] & array2[size]))); done ;;
    "|") while ((size--)); do ((result[size] = ~(array1[size] | array2[size]))); done ;;
    "^") while ((size--)); do ((result[size] = ~(array1[size] ^ array2[size]))); done ;;
    esac
}
function int64n._bitwiseAssign() {
    int64n._internal || return

    local -n array1="${1:?}" array2="${2:?}"
    local -i size=$((${#array1[@]} > ${#array2[@]} ? ${#array1[@]} : ${#array2[@]}))

    case ${4:?} in
    "&") while ((size--)); do ((array1[size] = array1[size] & array2[size])); done ;;
    "|") while ((size--)); do ((array1[size] = array1[size] | array2[size])); done ;;
    "^") while ((size--)); do ((array1[size] = array1[size] ^ array2[size])); done ;;
    esac
}
function int64n._arrayShiftR() {
    int64n._internal || return

    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" size=${#array[@]}

    if ((!shift)); then
        result=(${array[@]})
    elif ((0 < shift && shift < size)); then
        int64n.fill result shift
        result=(${result[@]::shift} ${array[@]::size - shift})
    else
        int64n.fill result size
    fi
}
function int64n._arrayShiftL() {
    int64n._internal || return

    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" size=${#array[@]}

    if ((!shift)); then
        result=(${array[@]})
    elif ((0 < shift && shift < size)); then
        int64n.fill result shift
        result=(${array[@]:shift} ${result[@]::shift})
    else
        int64n.fill result size
    fi
}
function int64n._arrayRotateR() {
    int64n._internal || return

    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" size=${#array[@]}

    if ((shift >= size ? (shift %= size) : (0 < shift))); then
        result=(${array[@]:size - shift:shift} ${array[@]::size - shift})
    fi
}
function int64n._arrayRotateL() {
    int64n._internal || return

    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" size=${#array[@]}

    if ((shift >= size ? (shift %= size) : (0 < shift))); then
        result=(${array[@]:shift} ${array[@]::shift})
    fi
}
function int64n._internal() {
    [[ ${FUNCNAME[2]%.*} == ${__int64n_ns} ]]
}

function _.int64n() {
    local -i i=0 fill0=() fill1=() mask=()

    until ((1 << i++ < 0)); do :; done
    if ((i ^ 64)); then exit 1; fi

    for i in {0..63} ; do
        ((fill0[i] = 0))
        ((fill1[i] = ~0))
        ((mask[i] = i ? (1 << i) - 1 : 0))
    done

    declare -gair __int64n_fill0=("${fill0[@]}")
    declare -gair __int64n_fill1=("${fill1[@]}")
    declare -gair __int64n_mask=("${mask[@]}")
    declare -gir __int64n_sign=0x8000000000000000
    declare -gr __int64n="${FUNCNAME%.*}"
} && { _.int64n; unset -f _.int64n;}
