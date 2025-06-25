function ucsdstr.encode() {
    local -r LC_ALL=C IFS=''
    local -n result="${1:?}" string="${2:?}"
    local -i length status

    ((length = ${#string}, status = length > 255, length = length < 256 ? length : 255))

    printf -v result "%x" ${length}
    printf -v result "%b%s" "\x${result}" "${string::length}"

    return ${status}
}

function ucsdstr.decode() {
    local -r LC_ALL=C IFS=''
    local -n result="${1:?}" string="${2:?}"
    local -i length

    printf -v length "%d" "'${string::1}"

    result="${string:1:length}"

    return $((${#string} < length + 1))
}
