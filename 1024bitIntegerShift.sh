# 1024bit integer
k:new() {
    local -n array="${1:?}"

    if [[ ${array@a}${#array[@]} == ai0 ]]; then
        array=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    fi
}

k:asl() {
    k:lsl "${@}"
}

k:asr() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" a b c fill=()
    local -i shift0=shift/64 shift1=shift%64

    if ((shift & 0x8000000000000000)); then
        k:lsl "${1}" "${2}" "${3:1}"
        return
    fi

    if ((array[15] & 0x8000000000000000))
        then fill=(-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1)
        else fill=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    fi

    if ((0 < shift0 && shift0 < 16)); then
        result=(${array[@]:shift0} ${fill[@]::shift0})
    elif ((!shift0)); then
        result=(${array[@]})
    else
        result=(${fill[@]})
        return
    fi

    if ((shift1)); then
        ((a=64-shift1,b=(1<<shift1)-1,c=(1<<a)-1,result[0]=result[0]>>shift1&c|(result[1]&b)<<a,result[1]=result[1]>>shift1&c|(result[2]&b)<<a,result[2]=result[2]>>shift1&c|(result[3]&b)<<a,result[3]=result[3]>>shift1&c|(result[4]&b)<<a,result[4]=result[4]>>shift1&c|(result[5]&b)<<a,result[5]=result[5]>>shift1&c|(result[6]&b)<<a,result[6]=result[6]>>shift1&c|(result[7]&b)<<a,result[7]=result[7]>>shift1&c|(result[8]&b)<<a,result[8]=result[8]>>shift1&c|(result[9]&b)<<a,result[9]=result[9]>>shift1&c|(result[10]&b)<<a,result[10]=result[10]>>shift1&c|(result[11]&b)<<a,result[11]=result[11]>>shift1&c|(result[12]&b)<<a,result[12]=result[12]>>shift1&c|(result[13]&b)<<a,result[13]=result[13]>>shift1&c|(result[14]&b)<<a,result[14]=result[14]>>shift1&c|(result[15]&b)<<a,result[15]=result[15]>>shift1))
    fi
}

k:lsl() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" a b fill=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    local -i shift0=shift/64 shift1=shift%64

    if ((shift & 0x8000000000000000)); then
        k:lsr "${1}" "${2}" "${3:1}"
        return
    fi

    if ((0 < shift0 && shift0 < 16)); then
        result=(${fill[@]::shift0} ${array[@]::${#array[@]} - shift0})
    elif ((!shift0)); then
        result=(${array[@]})
    else
        result=(${fill[@]})
        return
    fi
    
    if ((shift1)); then
        ((a=64-shift1,b=(1<<shift1)-1,result[15]=result[15]<<shift1|result[14]>>a&b,result[14]=result[14]<<shift1|result[13]>>a&b,result[13]=result[13]<<shift1|result[12]>>a&b,result[12]=result[12]<<shift1|result[11]>>a&b,result[11]=result[11]<<shift1|result[10]>>a&b,result[10]=result[10]<<shift1|result[9]>>a&b,result[9]=result[9]<<shift1|result[8]>>a&b,result[8]=result[8]<<shift1|result[7]>>a&b,result[7]=result[7]<<shift1|result[6]>>a&b,result[6]=result[6]<<shift1|result[5]>>a&b,result[5]=result[5]<<shift1|result[4]>>a&b,result[4]=result[4]<<shift1|result[3]>>a&b,result[3]=result[3]<<shift1|result[2]>>a&b,result[2]=result[2]<<shift1|result[1]>>a&b,result[1]=result[1]<<shift1|result[0]>>a&b,result[0]=result[0]<<shift1))
    fi
}

k:lsr() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" a b c fill=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    local -i shift0=shift/64 shift1=shift%64

    if ((shift & 0x8000000000000000)); then
        k:lsl "${1}" "${2}" "${3:1}"
        return
    fi

    if ((0 < shift0 && shift0 < 16)); then
        result=(${array[@]:shift0} ${fill[@]::shift0})
    elif ((!shift0)); then
        result=(${array[@]})
    else
        result=(${fill[@]})
        return
    fi

    if ((shift1)); then
        ((a=64-shift1,b=(1<<shift1)-1,c=(1<<a)-1,result[0]=result[0]>>shift1&c|(result[1]&b)<<a,result[1]=result[1]>>shift1&c|(result[2]&b)<<a,result[2]=result[2]>>shift1&c|(result[3]&b)<<a,result[3]=result[3]>>shift1&c|(result[4]&b)<<a,result[4]=result[4]>>shift1&c|(result[5]&b)<<a,result[5]=result[5]>>shift1&c|(result[6]&b)<<a,result[6]=result[6]>>shift1&c|(result[7]&b)<<a,result[7]=result[7]>>shift1&c|(result[8]&b)<<a,result[8]=result[8]>>shift1&c|(result[9]&b)<<a,result[9]=result[9]>>shift1&c|(result[10]&b)<<a,result[10]=result[10]>>shift1&c|(result[11]&b)<<a,result[11]=result[11]>>shift1&c|(result[12]&b)<<a,result[12]=result[12]>>shift1&c|(result[13]&b)<<a,result[13]=result[13]>>shift1&c|(result[14]&b)<<a,result[14]=result[14]>>shift1&c|(result[15]&b)<<a,result[15]=result[15]>>shift1&c))
    fi
}

k:rol() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" a b c size=${#array[@]}
    local -i shift0=shift/64%16 shift1=shift%64

    if ((shift & 0x8000000000000000)); then
        k:ror "${1}" "${2}" "${3:1}"
        return
    fi

    if ((!shift0))
        then result=(${array[@]})
        else result=(${array[@]:size - shift0:shift0} ${array[@]::size - shift0})
    fi

    if ((shift1)); then
        ((a=64-shift1,b=(1<<shift1)-1,c=result[15],result[15]=result[15]<<shift1|result[14]>>a&b,result[14]=result[14]<<shift1|result[13]>>a&b,result[13]=result[13]<<shift1|result[12]>>a&b,result[12]=result[12]<<shift1|result[11]>>a&b,result[11]=result[11]<<shift1|result[10]>>a&b,result[10]=result[10]<<shift1|result[9]>>a&b,result[9]=result[9]<<shift1|result[8]>>a&b,result[8]=result[8]<<shift1|result[7]>>a&b,result[7]=result[7]<<shift1|result[6]>>a&b,result[6]=result[6]<<shift1|result[5]>>a&b,result[5]=result[5]<<shift1|result[4]>>a&b,result[4]=result[4]<<shift1|result[3]>>a&b,result[3]=result[3]<<shift1|result[2]>>a&b,result[2]=result[2]<<shift1|result[1]>>a&b,result[1]=result[1]<<shift1|result[0]>>a&b,result[0]=result[0]<<shift1|c>>a&b))
    fi
}

k:ror() {
    local -n result="${1:?}" array="${2:?}"
    local -i shift="${3:?}" a b c d size=${#array[@]}
    local -i shift0=shift/64%16 shift1=shift%64

    if ((shift & 0x8000000000000000)); then
        k:rol "${1}" "${2}" "${3:1}"
        return
    fi

    if ((!shift0))
        then result=(${array[@]})
        else result=(${array[@]:shift0} ${array[@]::shift0})
    fi

    if ((shift1)); then
        ((a=64-shift1,b=(1<<shift1)-1,c=(1<<a)-1,d=result[0],result[0]=result[0]>>shift1&c|(result[1]&b)<<a,result[1]=result[1]>>shift1&c|(result[2]&b)<<a,result[2]=result[2]>>shift1&c|(result[3]&b)<<a,result[3]=result[3]>>shift1&c|(result[4]&b)<<a,result[4]=result[4]>>shift1&c|(result[5]&b)<<a,result[5]=result[5]>>shift1&c|(result[6]&b)<<a,result[6]=result[6]>>shift1&c|(result[7]&b)<<a,result[7]=result[7]>>shift1&c|(result[8]&b)<<a,result[8]=result[8]>>shift1&c|(result[9]&b)<<a,result[9]=result[9]>>shift1&c|(result[10]&b)<<a,result[10]=result[10]>>shift1&c|(result[11]&b)<<a,result[11]=result[11]>>shift1&c|(result[12]&b)<<a,result[12]=result[12]>>shift1&c|(result[13]&b)<<a,result[13]=result[13]>>shift1&c|(result[14]&b)<<a,result[14]=result[14]>>shift1&c|(result[15]&b)<<a,result[15]=result[15]>>shift1&c|(d&b)<<a))
    fi
}
