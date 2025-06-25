eval "readonly _gof_ch=({\ ,▝,▘,▀,▗,▐,▚,▜,▖,▞,▌,▛,▄,▟,▙,█}{\ ,▝,▘,▀,▗,▐,▚,▜,▖,▞,▌,▛,▄,▟,▙,█})"

function conway.updateChunk() { local -i j k l m n o p q r s t u v w x y A B C D F G H I
((D=${5:?}>>1&0x7f7f7f7f7f7f7f7f|${4:?}<<7&0x8080808080808080,F=$5<<1&0xfefefefefefefefe|\
${6:?}>>7&0x0101010101010101,B=$5>>8&0xffffffffffffff|${2:?}<<56,H=$5<<8|0xff&${8:?}>>56,\
A=D>>8&0xffffffffffffff|${1:?}<<63&0x8000000000000000|$2<<55&0x7f00000000000000,C=F>>8&\
0xffffffffffffff|${3:?}<<49&0x0100000000000000|$2<<57,G=D<<8|${7:?}>>49&0x80|$8>>57&0x7f,\
I=F<<8|${9:?}>>63&0x01|$8>>55&0xfe,w=(n=(j=A^B)^(k=C^D))^(o=(l=F^G)^(m=H^I)),x=(p=A&B)|(q\
=C&D)|(r=F&G)|(s=H&I)|(t=j&k)|(u=l&m)|(v=n&o),y=(p&q|p&r|q&r)|(s&t|s&u|s&v|t&u|t&v|u&v)|(\
p|q|r)&(s|t|u|v),(${10:?}=($5|w)&x&~y)^$5));}

function conway.printChunk() {
    local -i a
    local -n b="${2:?}"

    ((a = ${1:?} >> 2 & 0x3000300030003000\
        | $1 >> 4 & 0x0300030003000300\
        | $1 >> 6 & 0x0030003000300030\
        | $1 >> 8 & 0x0003000300030003\
        | $1 << 8 & 0xc000c000c000c000\
        | $1 << 6 & 0x0c000c000c000c00\
        | $1 << 4 & 0x00c000c000c000c0\
        | $1 << 2 & 0x000c000c000c000c))

    b=( "${_gof_ch[a >> 56 & 255]}${_gof_ch[a >> 48 & 255]}"
        "${_gof_ch[a >> 40 & 255]}${_gof_ch[a >> 32 & 255]}"
        "${_gof_ch[a >> 24 & 255]}${_gof_ch[a >> 16 & 255]}"
        "${_gof_ch[a >> 8 & 255]}${_gof_ch[a & 255]}")
}

function conway.updateBlock() {
    local -n chunks="${1:?}" result="${2:?}"
    local -i tl tc tr cl cc cr bl bc br i j

    for i in {1..8}{1..8}; do
        ((  tl = chunks[i - 11], tc = chunks[i - 10], tr = chunks[i -  9],\
            cl = chunks[i -  1], cc = chunks[i     ], cr = chunks[i +  1],\
            bl = chunks[i +  9], bc = chunks[i + 10], br = chunks[i + 11]))

        if ((tc || cl || cc || cr || bc))
            then conway.updateChunk tl tc tr cl cc cr bl bc br result[$((j++))]; ((++IT))
            else (( result[j++] = 0 ))
        fi
    done
}

function conway.printBlock() {
    local -n chunks="${1:?}"
    local -i i j k l=0
    local text cell

    for i in {0..7}; do
        for j in {0..7}; do
            (( k = i << 4 ))

            conway.printChunk chunks[$((l++))] cell

            text[k    ]+="${cell[0]}"
            text[k + 1]+="${cell[1]}"
            text[k + 2]+="${cell[2]}"
            text[k + 3]+="${cell[3]}"
        done
    done

    echo -n $'\033[H'
    printf "\033[${2}G%s\n" "${text[@]}"
}

function conway.main() {
    local -i i gen next p0 p1 p2 p3 w0 w1 w2 w3

    for i in {0..63}; do
        p0[i]="SRANDOM | SRANDOM << 32"
        p1[i]="SRANDOM | SRANDOM << 32"
        p2[i]="SRANDOM | SRANDOM << 32"
        p3[i]="SRANDOM | SRANDOM << 32"
    done

    until (()); do
        if (( next <= ${EPOCHREALTIME/.} )); then
            {
                conway.printBlock p0  1
                conway.printBlock p1 33
                conway.printBlock p2 65
                conway.printBlock p3 97
            } &

            printf "\033[2K it: %d, generation: %d" ${IT} ${gen}

            (( next = ${EPOCHREALTIME/.} + 100000 ))
        fi

        w0=(${p3[63]} ${p0[@]:56:8} ${p1[56]})
        w1=(${p0[63]} ${p1[@]:56:8} ${p2[56]})
        w2=(${p1[63]} ${p2[@]:56:8} ${p3[56]})
        w3=(${p2[63]} ${p3[@]:56:8} ${p0[56]})

        for i in {0..56..8}; do
            w0+=(${p3[i+7]} ${p0[@]:i:8} ${p1[i]})
            w1+=(${p0[i+7]} ${p1[@]:i:8} ${p2[i]})
            w2+=(${p1[i+7]} ${p2[@]:i:8} ${p3[i]})
            w3+=(${p2[i+7]} ${p3[@]:i:8} ${p0[i]})
        done

        w0+=(${p3[7]} ${p0[@]::8} ${p1[0]})
        w1+=(${p0[7]} ${p1[@]::8} ${p2[0]})
        w2+=(${p1[7]} ${p2[@]::8} ${p3[0]})
        w3+=(${p2[7]} ${p3[@]::8} ${p0[0]})

        conway.updateBlock w0 p0
        conway.updateBlock w1 p1
        conway.updateBlock w2 p2
        conway.updateBlock w3 p3

        ((++gen))
    done
}

conway.main
