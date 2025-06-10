declare -i i

# `i & msb` may be faster than `i < 0`
time { for i in {-499999..500000}; do ((i < 0)); done;}
time { for i in {-499999..500000}; do ((i & 0x8000000000000000)); done;}

# `(())` may be faster than `:`
time { for _ in {0..999999}; do :; done;}
time { for _ in {0..999999}; do ((1)); done;}
