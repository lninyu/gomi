##
# @brief Register a callback function with optional arguments to a callback list.
#
# @param[in,out] 1 Name of the callback list (must be an indexed array).
# @param[in] 2 Callback function name (must exist).
# @param[in] 3... Optional arguments to pass to the callback when dispatched.
#
# @details
#   - Validates that the list is an indexed array.
#   - Initializes the list if it's empty.
#   - Verifies that the given callback function exists using `declare -F`.
#   - Appends the callback function name and its optional arguments to the list.
#   - Updates metadata (stored in list[0]) with offset and length info
#     for each registered callback entry.
#
# @example
#   declare -a callbacks
#   callback:register callbacks "foo_func" "arg1" "arg2"
#
function callback:register() {
    local -n list="${1:?}"; [[ "${list@a}" == "a" ]] || return 1
    local -a meta=(${list[0]})

    ((${#list[@]})) || list[0]=""

    if declare -F "${2:?}" &> /dev/null; then
        meta+=(${#list[@]} $((${#} - 1)))
        list+=("${@:2}")
        list[0]="${meta[*]}"
    fi
}

##
# @brief Dispatch all registered callbacks in a callback list.
#
# @param[in] 1 Name of the callback list (must be an indexed array).
#
# @details
#   - Validates that the provided list is an indexed array.
#   - Reads metadata (offset and length) from list[0] to determine
#     where each callback and its arguments are stored.
#   - Iterates through the list, executing each callback function
#     with its corresponding arguments.
#
# @example
#   callback:dispatch callbacks
#
function callback:dispatch() {
    local -n list="${1:?}"; [[ "${list@a}" == "a" ]] || return 1
    local -a meta=(${list[0]})
    local -i size idx

    for ((size = ${#meta[@]}, idx = 0; idx < size; idx += 2)); do
        "${list[@]:meta[idx]:meta[idx+1]}"
    done
}
