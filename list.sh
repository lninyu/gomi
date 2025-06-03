# wow many pickles
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
    local -i pick="${2:?}"

    case "${3:?}" in
        -r|--raw)
            local -n self="${1:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick <= ${#view[@]})); then
                view+=([pick]=${#self[@]} ${#}-3 ${view[@]:pick})
                self+=("${@:4}" [3]="${view[*]}")
            fi ;;
        *)
            local -n self="${1:?}" data="${3:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick <= ${#view[@]})); then
                view+=([pick]=${#self[@]} ${#data[@]} ${view[@]:pick})
                self+=("${data[@]}" [3]="${view[*]}")
            fi ;;
    esac
}

function list:update() {
    local -i pick="${2:?}" size

    case "${3:?}" in
        -r|--raw)
            local -n self="${1:?}"
            local -a view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick < ${#view[@]})); then
                if ((0 <= (size = ${#} - 3) && size <= view[pick+1])); then
                    ((self[2] += view[pick+1] - size))
                    view[pick+1]=${size}
                    self+=([view[pick] ]="${4}" "${@:5}" [3]="${view[*]}")
                else
                    ((self[2] += size - view[pick+1]))
                    view+=([pick]=${#self[@]} ${size})
                    self+=("${@:4}" [3]="${view[*]}")
                fi
            fi ;;
        *)
            local -n self="${1:?}" data="${3:?}"
            local -ai view=(${self[3]})

            if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick < ${#view[@]})); then
                if ((0 <= (size = ${#data[@]}) && size <= view[pick+1])); then
                    ((self[2] += view[pick+1] - size))
                    view[pick+1]=${size}
                    self+=([view[pick] ]="${data[0]}" "${data[@]:1}" [3]="${view[*]}")
                else
                    ((self[2] += size - view[pick+1]))
                    view+=([pick]=${#self[@]} ${size})
                    self+=("${data[@]}" [3]="${view[*]}")
                fi
            fi ;;
    esac

    if ((self[1] && self[1] <= self[2])); then
        list:defrag "${1}"
    fi
}

function list:remove() {
    local -n self="${1:?}"
    local -i pick="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick < ${#view[@]})); then
        ((self[2] += view[pick+1], view[pick+1] = 0))
        self[3]="${view[*]}"

        if ((self[1] && self[1] <= self[2])); then
            list:defrag "${1}"
        fi
    fi
}

function list:delete() {
    local -n self="${1:?}"
    local -i pick="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick < ${#view[@]})); then
        ((self[2] += view[pick+1]))
        view+=([pick]="" "")
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
    local -n self="${1:?}" data="${3:?}"
    local -i pick="${2:?}"
    local -a view=(${self[3]})

    if ((self[0] == 1818850164 && 0 <= (pick <<= 1) && pick < ${#view[@]})); then
        data=("${self[@]:view[pick]:view[pick+1]}")
    fi
}

function list:defrag() {
    local -n self="${1:?}"
    local -a view=(${self[3]}) temp=()
    local -i pick size="${#view[@]}"

    if ((self[0] == 1818850164)); then
        list_new temp "${self[1]}"

        for ((pick = 0; pick < size; pick += 2)); do
            temp+=("${self[@]:view[pick]:view[pick+1]}" [3]+="${#temp[@]} ${view[pick+1]} ")
        done

        self=("${temp[@]}")
    fi
}

function list:squash() {
    local -n self="${1:?}"
    local -a view=(${self[3]}) temp=()
    local -i pick size="${#view[@]}"

    if ((self[0] == 1818850164)); then
        for ((pick = 0; pick < size; pick += 2)); do
            if ((!view[pick+1])); then
                view+=([pick]="" "")
            fi
        done

        self[3]="${view[*]}"
    fi
}

function list:equals() {
    local -n self="${1:?}" list="${2:?}"
    local -a view=(${self[3]}) temp=(${list[3]}) A B
    local -i pick idx2

    if ((self[0] == 1818850164 && list[0] == 1818850164 && ${#view[@]} == ${#temp[@]})); then
        for ((pick = 0; pick < ${#view[@]}; pick += 2)); do
            if ((view[pick+1] != temp[pick+1])); then
                return 1
            fi

            A=("${self[@]:view[pick]:view[pick+1]}")
            B=("${list[@]:temp[pick]:temp[pick+1]}")

            for ((idx2 = 0; idx2 < ${#A[@]}; ++idx2)); do
                if [[ "${A[idx2]}" != "${B[idx2]}" ]]; then
                    return 1
                fi
            done
        done

        return 0
    fi

    return 1
}
