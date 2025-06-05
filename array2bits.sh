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
