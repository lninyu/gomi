function ctz() {
    local -n result="${1:?}"
    local -i i="${2:?}" j=64

    ((i &= -i, i && --j, i & 0x00000000ffffffff && (j -= 32), i & 0x0000ffff0000ffff && (j -= 16), i & 0x00ff00ff00ff00ff && (j -= 8), i & 0x0f0f0f0f0f0f0f0f && (j -= 4), i & 0x3333333333333333 && (j -= 2), i & 0x5555555555555555 && --j, result = j))
}

function clz() {
    local -n result="${1:?}"
    local -i i="${2:?}" j=0

    ((i ? (!(i & 0xffffffff00000000) && (j += 32, i <<= 32), !(i & 0xffff000000000000) && (j += 16, i <<= 16), !(i & 0xff00000000000000) && (j += 8, i <<= 8), !(i & 0xf000000000000000) && (j += 4, i <<= 4), !(i & 0xc000000000000000) && (j += 2, i <<= 2), !(i & 0x8000000000000000) && ++j, result = j) : (result = 64)))
}

function pop() {
    local -n result="${1:?}"
    local -i i="${2:?}"

    ((i -= i >> 1 & 0x5555555555555555, i = (i & 0x3333333333333333) + (i >> 2 & 0x3333333333333333), i = i + (i >> 4) & 0x0f0f0f0f0f0f0f0f, i += i >> 8, i += i >> 16, i += i >> 32, result = i & 127))
}

function rev() {
    local -n result="${1:?}"
    local -i i="${2:?}"

    ((i = i >> 1 & 0x5555555555555555 | (i & 0x5555555555555555) << 1, i = i >> 2 & 0x3333333333333333 | (i & 0x3333333333333333) << 2, i = i >> 4 & 0x0f0f0f0f0f0f0f0f | (i & 0x0f0f0f0f0f0f0f0f) << 4, i = i >> 8 & 0x00ff00ff00ff00ff | (i & 0x00ff00ff00ff00ff) << 8, i = i >> 16 & 0x0000ffff0000ffff | (i & 0x0000ffff0000ffff) << 16, i = i >> 32 & 0x00000000ffffffff | (i & 0x00000000ffffffff) << 32, result = i))
}
