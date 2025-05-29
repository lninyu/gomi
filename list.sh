## data structure
# list: {
#     meta: {
#         type: string,
#         gcfunc: string,
#         gcrate: int,
#         gctick: int,
#         refs: {
#             offset: int,
#             length: int
#         }[]
#     },
#     data: string[]
# }

declare -r LIST_TYPE="me.lninyu.list"

function list:new() {
    local -r IFS=$'\x20'
    local -n list="${1:?}"
    local -r gcfunc="${2:-"fullgc"}"
    local -i gcrate="${3:-0}"

    if [[ "${list@a}${#list[@]}" == "a0" && "${gcfunc}" =~ ^fullgc$|^defrag$|^squash$ ]]; then
        list=("${LIST_TYPE}" "${gcfunc}" "$((gcrate < 0 ? 0 : gcrate))" 0)
        list=("${list[*]}")
    else
        return 1
    fi
}
function list:get() {
    local -r IFS=$'\x20'
    local -n result="${1:?}" list="${2:?}"
    local -a meta=(${list[0]})
    local -i idx="${3:-0}"

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}${result@a}" == "aa" ]] && ((0 <= idx && idx < ${#meta[@]} / 2 - 2)); then
        result=("${list[@]:meta[idx = idx * 2 + 4]:meta[idx + 1]}")
    else
        return 1
    fi
}
function list:set() {
    "${FUNCNAME[0]%:*}:update" "${@}"
}
function list:append() {
    local -r IFS=$'\x20'
    local -i flag=0; [[ "${1}" == "-r" || "${1}" == "--raw" ]] && { flag=1; shift; }
    local -n list="${1:?}"
    local -a meta=(${list[0]})

    if ((flag))
        then local -a data=("${@:2}")
        else local -n data="${2:?}"
    fi

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}${data@a}" == "aa" ]]; then
        meta+=("${#list[@]}" "${#data[@]}")
        list+=("${data[@]}")
        list[0]="${meta[*]}"
    else
        return 1
    fi
}
function list:insert() {
    local -r IFS=$'\x20'
    local -i flag=0; [[ "${1}" == "-r" || "${1}" == "--raw" ]] && { flag=1; shift; }
    local -n list="${1:?}"
    local -a meta=(${list[0]})
    local -i idx="${2:-0}"

    if ((flag))
        then local -a data=("${@:3}")
        else local -n data="${3:?}"
    fi

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}${data@a}" == "aa" ]] && ((0 <= idx && idx < ${#meta[@]} / 2 - 2)); then
        ((idx = idx * 2 + 4))

        meta+=([idx]="${#list[@]}" "${#data[@]}" "${meta[@]:idx}")
        list+=("${data[@]}")
        list[0]="${meta[*]}"
    else
        return 1
    fi
}
function list:update() {
    local -r IFS=$'\x20'
    local -i flag=0; [[ "${1}" == "-r" || "${1}" == "--raw" ]] && { flag=1; shift; }
    local -n list="${1:?}"
    local -a meta=(${list[0]})
    local -i idx="${2:-0}" size

    if ((flag))
        then local -a data=("${@:3}")
        else local -n data="${3:?}"
    fi

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}${data@a}" == "aa" ]] && ((0 <= idx && idx < ${#meta[@]} / 2 - 2)); then
        ((idx = idx * 2 + 4))

        if ((0 <= ${#data[@]} && ${#data[@]} <= meta[idx + 1])); then
            meta[idx + 1]="${#data[@]}"
            list+=([(meta[idx])]="${data[0]}" "${data[@]:1}")
            list[0]="${meta[*]}"
        else
            meta[idx + 0]="${#list[@]}"
            meta[idx + 1]="${#data[@]}"
            list+=("${data[@]}")
            list[0]="${meta[*]}"
        fi
    else
        return 1
    fi
}
function list:remove() {
    local -r IFS=$'\x20'
    local -n list="${1:?}"
    local -a meta=(${list[0]})
    local -i idx="${2:-0}"

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}" == "a" ]] && ((0 <= idx && idx < ${#meta[@]} / 2 - 2)); then
        meta[idx * 2 + 5]=0
        list[0]="${meta[*]}"
    else
        return 1
    fi
}
function list:delete() {
    local -r IFS=$'\x20'
    local -n list="${1:?}"
    local -a meta=(${list[0]})
    local -i idx="${2:-0}"

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}" == "a" ]] && ((0 <= idx && idx < ${#meta[@]} / 2 - 2)); then
        meta+=([idx * 2 + 4]="" "")
        meta=(${meta[*]})
        list[0]="${meta[*]}"
    else
        return 1
    fi
}
function list:fullgc() {
    local -r IFS=$'\x20'
    local -i flag; [[ "${1}" == "-t" || "${1}" == "--try" ]] && { flag=1; shift; }
    local -n list="${1:?}"
    local -a meta=(${list[0]})

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}" == "a" ]]; then
        if ((flag && meta[2] && ++meta[3] < meta[2])); then
            list[0]="${meta[*]}"
            return 2
        fi

        list:squash "${1}"
        list:defrag "${1}"
    else
        return 1
    fi
}
function list:defrag() {
    local -r IFS=$'\x20'
    local -i flag; [[ "${1}" == "-t" || "${1}" == "--try" ]] && { flag=1; shift; }
    local -n list="${1:?}"
    local -a meta=(${list[0]}) temp=()
    local -i idx


    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}" == "a" ]]; then
        if ((flag && meta[2] && ++meta[3] < meta[2])); then
            list[0]="${meta[*]}"
            return 2
        fi

        list:new temp "${meta[1]}" "${meta[2]}"

        for ((idx = 4; idx < ${#meta[@]}; idx+=2)); do
            meta[idx]="${#temp[@]}"
            temp+=("${list[@]:meta[idx]:meta[idx + 1]}")
        done

        list=("${temp[@]}")
        meta[3]=0
        list[0]="${meta[*]}"
    else
        return 1
    fi
}
function list:squash() {
    local -r IFS=$'\x20'
    local -i flag; [[ "${1}" == "-t" || "${1}" == "--try" ]] && { flag=1; shift; }
    local -n list="${1:?}"
    local -a meta=(${list[0]})
    local -i idx

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}" == "a" ]]; then
        if ((flag && meta[2] && ++meta[3] < meta[2])); then
            list[0]="${meta[*]}"
            return 2
        fi

        for ((idx = 4; idx < ${#meta[@]}; idx+=2)); do
            ((meta[idx + 1])) || meta+=([idx]="" "")
        done

        meta=(${meta[*]})
        meta[3]=0
        list[0]="${meta[*]}"
    else
        return 1
    fi
}
function list:length() {
    local -r IFS=$'\x20'
    local -n result="${1:?}" list="${2:?}"
    local -a meta=(${list[0]})

    if [[ "${meta[0]}" == "${LIST_TYPE}" && "${list@a}" == "a" ]]; then
        ((result = ${#meta[@]} / 2 - 2))
    else
        return 1
    fi
}
function list:equals() {
    local -r IFS=$'\x20'
    local -n listA="${1:?}" listB="${2:?}"
    local -a metaA=(${listA[0]}) metaB=(${listB[0]})
    local -i tmp1 tmp2 size
    local -a A B

    if [[ "${metaA[0]}" != "${LIST_TYPE}" || "${metaB[0]}" != "${LIST_TYPE}" ]]; then
        return 1
    fi

    if (((size = ${#metaA[@]}) != ${#metaB[@]})); then
        return 1
    fi

    for ((tmp1 = 4; tmp1 < size; tmp1 += 2)); do
        A=("${listA[@]:metaA[tmp1]:metaA[tmp1 + 1]}")
        B=("${listB[@]:metaB[tmp1]:metaB[tmp1 + 1]}")

        for ((tmp2 = 0; tmp2 < ${#A[@]}; ++tmp2)); do
            [[ "${A[tmp2]}" != "${B[tmp2]}" ]] && return 1
        done
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && function list:test() {
    :
} && list:test
