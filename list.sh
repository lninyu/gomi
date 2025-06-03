function list:new() {
    local -n self="${1:?}"

    if ((!${#self[@]}))
        then local -i rate="${2//[^0-9]/}"; self=(1818850164 ${rate} 0 "")
        else return 1
    fi
}

function list:append() {
    case "${2:?}" in
        -r|--raw)
            local -n self="${1:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164)); then
                view+=(${#self[@]} ${#}-2)
                self+=("${@:3}" [3]="${view[*]}")
            fi ;;
        *)
            local -n self="${1:?}" data="${2:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164)); then
                view+=(${#self[@]} ${#data[@]})
                self+=("${data[@]}" [3]="${view[*]}")
            fi ;;
    esac
}

function list:insert() {
    local -i index="${2:?}"

    case "${3:?}" in
        -r|--raw)
            local -n self="${1:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index <= ${#view[@]})); then
                view+=([index]=${#self[@]} ${#}-3 ${view[@]:index})
                self+=("${@:4}" [3]="${view[*]}")
            fi ;;
        *)
            local -n self="${1:?}" data="${3:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index <= ${#view[@]})); then
                view+=([index]=${#self[@]} ${#data[@]} ${view[@]:index})
                self+=("${data[@]}" [3]="${view[*]}")
            fi ;;
    esac
}

function list:update() {
    local -i index="${2:?}" size

    case "${3:?}" in
        -r|--raw)
            local -n self="${1:?}"
            local -a view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
                if ((0 <= (size = ${#} - 3) && size <= view[index+1])); then
                    ((self[2] += view[index+1] - size))
                    view[index+1]=${size}
                    self+=([view[index] ]="${4}" "${@:5}" [3]="${view[*]}")
                else
                    ((self[2] += size - view[index+1]))
                    view+=([index]=${#self[@]} ${size})
                    self+=("${@:4}" [3]="${view[*]}")
                fi

                if ((self[1] && self[1] <= self[2])); then
                    list:defrag "${1}"
                fi
            fi ;;
        *)
            local -n self="${1:?}" data="${3:?}"
            local -a view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
                if ((0 <= (size = ${#data[@]}) && size <= view[index+1])); then
                    ((self[2] += view[index+1] - size))
                    view[index+1]=${size}
                    self+=([view[index] ]="${data[0]}" "${data[@]:1}" [3]="${view[*]}")
                else
                    ((self[2] += size - view[index+1]))
                    view+=([index]=${#self[@]} ${size})
                    self+=("${data[@]}" [3]="${view[*]}")
                fi

                if ((self[1] && self[1] <= self[2])); then
                    list:defrag "${1}"
                fi
            fi ;;
    esac
}

function list:remove() {
    local -n self="${1:?}"
    local -i index="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
        ((self[2] += view[index+1], view[index+1] = 0))
        self[3]="${view[*]}"

        if ((self[1] && self[1] <= self[2])); then
            list:defrag "${1}"
        fi
    fi
}

function list:delete() {
    local -n self="${1:?}"
    local -i index="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
        ((self[2] += view[index+1]))
        view+=([index]="" "")
        view=(${view[*]})
        self[3]="${view[*]}"

        if ((self[1] && self[1] <= self[2])); then
            list:defrag "${1}"
        fi
    fi
}

function list:set() {
    list:update "${@}"
}

function list:get() {
    local -n self="${1:?}" result="${3:?}"
    local -i index="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
        result=("${self[@]:view[index]:view[index+1]}")
    fi
}

function list:defrag() {
    local -n self="${1:?}"

    if ((self[0] == 1818850164)); then
        local -a view=(${self[3]}) temp=()
        local -i index size="${#view[@]}"

        list_new temp "${self[1]}"

        for ((index = 0; index < size; index += 2)); do
            temp+=("${self[@]:view[index]:view[index+1]}" [3]+="${#temp[@]} ${view[index+1]} ")
        done

        self=("${temp[@]}")
    fi
}

function list:squash() {
    local -n self="${1:?}"

    if ((self[0] == 1818850164)); then
        local -a view=(${self[3]})
        local -i index size="${#view[@]}"

        for ((index = 0; index < size; index += 2)); do
            if ((!view[index+1])); then
                view+=([index]="" "")
            fi
        done

        view=(${view[*]})
        self[3]="${view[*]}"
    fi
}

function list:equals() {
    local -n listA="${1:?}" listB="${2:?}"
    local -a viewA=(${listA[3]}) viewB=(${listB[3]}) sliceA sliceB

    if ((listA[0] == 1818850164 && listB[0] == 1818850164 && ${#viewA[@]} == ${#viewB[@]})); then
        local -i idx1 idx2 va=${#viewA[@]} sa=${#sliceA[@]}

        for ((idx1 = 0; idx1 < va; idx1 += 2)); do
            if ((viewA[idx1+1] != viewB[idx1+1])); then
                return 1
            fi

            sliceA=("${listA[@]:viewA[idx1]:viewA[idx1+1]}")
            sliceB=("${listB[@]:viewB[idx1]:viewB[idx1+1]}")

            for ((idx2 = 0; idx2 < sa; ++idx2)); do
                if [[ "${sliceA[idx2]}" != "${sliceB[idx2]}" ]]; then
                    return 1
                fi
            done
        done
    else
        return 1
    fi
}

function list:forEach() {
    local -n self="${1:?}"
    local -r func="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164)) && declare -F "${func}" &> /dev/null; then
        for ((index = 0; index < ${#view[@]}; index += 2)); do
            "${func}" "${self[@]:view[index]:view[index+1]}"
        done
    fi
}

function list:filter() {
    local -n self="${1:?}" result="${2:?}"
    local -r func="${3:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164)) && declare -F "${func}" &> /dev/null; then
        list:new "${2}"

        for ((index = 0; index < ${#view[@]}; index += 2)); do
            if "${func}" "${self[@]:view[index]:view[index+1]}"; then
                result+=("${self[@]:view[index]:view[index+1]}" [3]+="${#result[@]} ${view[index+1]} ")
            fi
        done
    fi
}

function list:map() {
    local -n self="${1:?}" result="${2:?}"
    local -r func="${3:?}"
    local -a view=(${self[3]}) temp

    if ((self[0] == 1818850164)) && declare -F "${func}" &> /dev/null; then
        list:new "${2}"

        for ((index = 0; index < ${#view[@]}; index += 2)); do
            temp=()
            "${func}" temp "${self[@]:view[index]:view[index+1]}"
            result+=("${temp[@]}" [3]+="${#result[@]} ${#temp[@]} ")
        done
    fi
}
