.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv_exp(%rip),%rdx

#level0
mov		%rdx,%r9
add		$2048,%r9
xor		%rax,%rax
.p2align 5
_looptop_start_01234:
#load
vmovdqa		(%rsi),%ymm4
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm6
vmovdqa		96(%rsi),%ymm7
vmovdqa		128(%rsi),%ymm8
vmovdqa		160(%rsi),%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#zetas
vmovdqa		(%rdx),%ymm2
vmovdqa		32(%rdx),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#shuffle
vpslld		$16,%ymm5,%ymm10
vpslld		$16,%ymm7,%ymm11
vpslld		$16,%ymm9,%ymm12
vpblendw	$0xAA,%ymm10,%ymm4,%ymm10
vpblendw	$0xAA,%ymm11,%ymm6,%ymm11
vpblendw	$0xAA,%ymm12,%ymm8,%ymm12
vpsrld		$16,%ymm4,%ymm13
vpsrld		$16,%ymm6,%ymm14
vpsrld		$16,%ymm8,%ymm15
vpblendw	$0xAA,%ymm5,%ymm13,%ymm13
vpblendw	$0xAA,%ymm7,%ymm14,%ymm14
vpblendw	$0xAA,%ymm9,%ymm15,%ymm15

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7
vmovdqa		%ymm14,%ymm8
vmovdqa		%ymm15,%ymm9

#level1
#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#zetas
vmovdqa		512(%rdx),%ymm2
vmovdqa		544(%rdx),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#reduce2
vpmulhw		%ymm1,%ymm4,%ymm10
vpmulhw		%ymm1,%ymm5,%ymm11
vpmulhw		%ymm1,%ymm6,%ymm12
vpsraw		$11,%ymm10,%ymm10
vpsraw		$11,%ymm11,%ymm11
vpsraw		$11,%ymm12,%ymm12
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpmullw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#shuffle
vpsllq		$32,%ymm5,%ymm10
vpsllq		$32,%ymm7,%ymm11
vpsllq		$32,%ymm9,%ymm12
vpblendd	$0xAA,%ymm10,%ymm4,%ymm10
vpblendd	$0xAA,%ymm11,%ymm6,%ymm11
vpblendd	$0xAA,%ymm12,%ymm8,%ymm12
vpsrlq		$32,%ymm4,%ymm13
vpsrlq		$32,%ymm6,%ymm14
vpsrlq		$32,%ymm8,%ymm15
vpblendd	$0xAA,%ymm5,%ymm13,%ymm13
vpblendd	$0xAA,%ymm7,%ymm14,%ymm14
vpblendd	$0xAA,%ymm9,%ymm15,%ymm15

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7
vmovdqa		%ymm14,%ymm8
vmovdqa		%ymm15,%ymm9

#level2
#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#zetas
vmovdqa		1024(%rdx),%ymm2
vmovdqa		1056(%rdx),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#shuffle
vpunpcklqdq	%ymm5,%ymm4,%ymm10
vpunpcklqdq	%ymm7,%ymm6,%ymm11
vpunpcklqdq	%ymm9,%ymm8,%ymm12
vpunpckhqdq	%ymm5,%ymm4,%ymm13
vpunpckhqdq	%ymm7,%ymm6,%ymm14
vpunpckhqdq	%ymm9,%ymm8,%ymm15

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7
vmovdqa		%ymm14,%ymm8
vmovdqa		%ymm15,%ymm9

#level3
#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#zetas
vmovdqa		1536(%rdx),%ymm2
vmovdqa		1568(%rdx),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#reduce2
vpmulhw		%ymm1,%ymm4,%ymm10
vpmulhw		%ymm1,%ymm5,%ymm11
vpmulhw		%ymm1,%ymm6,%ymm12
vpsraw		$11,%ymm10,%ymm10
vpsraw		$11,%ymm11,%ymm11
vpsraw		$11,%ymm12,%ymm12
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpmullw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#shuffle
vperm2i128	$0x20,%ymm5,%ymm4,%ymm10
vperm2i128	$0x20,%ymm7,%ymm6,%ymm11
vperm2i128	$0x20,%ymm9,%ymm8,%ymm12
vperm2i128	$0x31,%ymm5,%ymm4,%ymm13
vperm2i128	$0x31,%ymm7,%ymm6,%ymm14
vperm2i128	$0x31,%ymm9,%ymm8,%ymm15

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7
vmovdqa		%ymm14,%ymm8
vmovdqa		%ymm15,%ymm9

#level4
#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#zetas
vpbroadcastd	(%r9),%ymm2
vpbroadcastd	4(%r9),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)
vmovdqa		%ymm8,128(%rdi)
vmovdqa		%ymm9,160(%rdi)

add		$192,%rsi
add		$192,%rdi
add		$64,%rdx
add		$8,%r9
add		$96,%rax
cmp		$768,%rax
jb		_looptop_start_01234

sub		$1536,%rdi

#levels5/6
mov		$96,%rax
.p2align 5
_looptop_level_56:

xor		%rcx,%rcx
.p2align 5
_looptop_start_56:

#zetas
vpbroadcastd	(%r9),%ymm2
vpbroadcastd	4(%r9),%ymm3

xor		%r8,%r8
.p2align 5
_looptop_j_56:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		(%rdi,%rax,2),%ymm7
vmovdqa		32(%rdi,%rax,2),%ymm8
vmovdqa		64(%rdi,%rax,2),%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#reduce2
vpmulhw		%ymm1,%ymm4,%ymm10
vpmulhw		%ymm1,%ymm5,%ymm11
vpmulhw		%ymm1,%ymm6,%ymm12
vpsraw		$11,%ymm10,%ymm10
vpsraw		$11,%ymm11,%ymm11
vpsraw		$11,%ymm12,%ymm12
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpmullw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,(%rdi,%rax,2)
vmovdqa		%ymm8,32(%rdi,%rax,2)
vmovdqa		%ymm9,64(%rdi,%rax,2)

add		$96,%rdi
add		$48,%r8
cmp		%rax,%r8
jb		_looptop_j_56

add		%rax,%rdi
add		%rax,%rdi
add		$8,%r9
add		%rax,%rcx
add		%rax,%rcx
cmp		$768,%rcx
jb		_looptop_start_56

sub		$1536,%rdi
add		%rax,%rax
cmp		$384,%rax
jb		_looptop_level_56

#level 7
#zetas
vpbroadcastd	(%r9),%ymm2
vpbroadcastd	4(%r9),%ymm3
vpbroadcastd	8(%r9),%ymm13
vpbroadcastd	12(%r9),%ymm14
vpsllw		$1,%ymm13,%ymm15
vpsllw		$1,%ymm14,%ymm1

xor		%rax,%rax
.p2align 5
_looptop_j_7:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		768(%rdi),%ymm7
vmovdqa		800(%rdi),%ymm8
vmovdqa		832(%rdi),%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm4
vpsubw		%ymm8,%ymm5,%ymm5
vpsubw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm13,%ymm4,%ymm10
vpmullw		%ymm13,%ymm5,%ymm11
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm14,%ymm4,%ymm4
vpmulhw		%ymm14,%ymm5,%ymm5
vpmulhw		%ymm14,%ymm6,%ymm6

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#mul
vpmullw		%ymm15,%ymm7,%ymm10
vpmullw		%ymm15,%ymm8,%ymm11
vpmullw		%ymm15,%ymm9,%ymm12
vpmulhw		%ymm1,%ymm7,%ymm7
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm7,%ymm7
vpsubw		%ymm11,%ymm8,%ymm8
vpsubw		%ymm12,%ymm9,%ymm9

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,768(%rdi)
vmovdqa		%ymm8,800(%rdi)
vmovdqa		%ymm9,832(%rdi)

add		$96,%rdi
add		$48,%rax
cmp		$384,%rax
jb		_looptop_j_7

ret
