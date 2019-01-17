.global poly_add
poly_add:

xor		%eax,%eax
.p2align 5
_looptop_add:
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		(%rdx),%ymm3
vmovdqa		32(%rdx),%ymm4
vmovdqa		64(%rdx),%ymm5

vpaddw		%ymm0,%ymm3,%ymm0
vpaddw		%ymm1,%ymm4,%ymm1
vpaddw		%ymm2,%ymm5,%ymm2

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)

add		$96,%rsi
add		$96,%rdx
add		$96,%rdi
add		$48,%eax
cmp		$768,%eax
jb		_looptop_add

ret

.global poly_triple
poly_triple:

xor		%eax,%eax
.p2align 5
_looptop_triple:
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5

vpaddw		%ymm0,%ymm0,%ymm6
vpaddw		%ymm1,%ymm1,%ymm7
vpaddw		%ymm2,%ymm2,%ymm8
vpaddw		%ymm3,%ymm3,%ymm9
vpaddw		%ymm4,%ymm4,%ymm10
vpaddw		%ymm5,%ymm5,%ymm11

vpaddw		%ymm0,%ymm6,%ymm0
vpaddw		%ymm1,%ymm7,%ymm1
vpaddw		%ymm2,%ymm8,%ymm2
vpaddw		%ymm3,%ymm9,%ymm3
vpaddw		%ymm4,%ymm10,%ymm4
vpaddw		%ymm5,%ymm11,%ymm5

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)

add		$192,%rsi
add		$192,%rdi
add		$96,%eax
cmp		$768,%eax
jb		_looptop_triple

ret
