# 4.2
function util.external() {
    local -i a="${1:-1}"
    local -r b="${2:-.}"

    [[ "${FUNCNAME[a < 1 && (a = 1), a]%${b}*}" != "${FUNCNAME[a + 1]%${b}*}" ]]
}

readonly -f util.external
