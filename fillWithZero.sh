# fill with zero
function fill() {
    local -n self="${1:?}"; self=()
    local -i size="${2:-0}"
    local -a temp=({,,,}{,,,}{,,,}0)

    until (((size -= 64) & 0x8000000000000000)); do
        self+=(${temp[@]})
    done

    self+=(${temp[@]::64 + size})
}
