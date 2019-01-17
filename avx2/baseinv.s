.global poly_baseinv
poly_baseinv:
mov             %rsp,%r11
and             $31,%r11
add             $32,%r11
sub             %r11,%rsp

vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xqinv(%rip),%ymm1

lea		zetas_exp(%rip),%rdx
add		$1656,%rdx
xor		%rcx,%rcx
xor		%rax,%rax
.p2align 5
_looptop:
#positive zeta
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm7
vmovdqu		(%rdx),%ymm14
vmovdqu		32(%rdx),%ymm15

#premul
vpmullw		%ymm1,%ymm3,%ymm2
vpmullw		%ymm1,%ymm5,%ymm4
vpmullw		%ymm1,%ymm7,%ymm6

#mul 1
vpmullw		%ymm5,%ymm14,%ymm8
vpmullw		%ymm7,%ymm14,%ymm10
vpmullw		%ymm7,%ymm2,%ymm12
vpmullw		%ymm5,%ymm4,%ymm14
vpmulhw		%ymm5,%ymm15,%ymm9
vpmulhw		%ymm7,%ymm15,%ymm11
vpmulhw		%ymm7,%ymm3,%ymm13
vpmulhw		%ymm5,%ymm5,%ymm15

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm8,%ymm9,%ymm8
vpsubw		%ymm10,%ymm11,%ymm9
vpsubw		%ymm12,%ymm13,%ymm10
vpsubw		%ymm14,%ymm15,%ymm11

#add
vpsubw		%ymm10,%ymm11,%ymm10

#mul 2
vpmullw		%ymm3,%ymm2,%ymm11
vpmullw		%ymm9,%ymm4,%ymm13
vpmullw		%ymm9,%ymm6,%ymm6
vpmullw		%ymm5,%ymm2,%ymm4
vpmulhw		%ymm3,%ymm3,%ymm12
vpmulhw		%ymm9,%ymm5,%ymm14
vpmulhw		%ymm9,%ymm7,%ymm7
vpmulhw		%ymm5,%ymm3,%ymm5
vpmullw		%ymm1,%ymm8,%ymm15

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm11,%ymm12,%ymm11
vpsubw		%ymm13,%ymm14,%ymm12
vpmullw		%ymm1,%ymm9,%ymm13
vpsubw		%ymm6,%ymm7,%ymm6
vpsubw		%ymm4,%ymm5,%ymm7

#add
vpsubw		%ymm12,%ymm11,%ymm11
vpsubw		%ymm7,%ymm6,%ymm6

#mul 3
vpmullw		%ymm10,%ymm15,%ymm12
vpmullw		%ymm6,%ymm13,%ymm14
vpmullw		%ymm11,%ymm2,%ymm4
vpmulhw		%ymm10,%ymm8,%ymm13
vpmulhw		%ymm6,%ymm9,%ymm15
vpmulhw		%ymm11,%ymm3,%ymm5

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm12,%ymm13,%ymm12
vpsubw		%ymm14,%ymm15,%ymm13
vpsubw		%ymm4,%ymm5,%ymm14

#add
vpaddw		%ymm12,%ymm13,%ymm12
vpaddw		%ymm12,%ymm14,%ymm12

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm6,32(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm12,(%rsp)

add		$96,%rsi
add		$96,%rdi

#negative zeta
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm7
vmovdqu		(%rdx),%ymm14
vmovdqu		32(%rdx),%ymm15

#premul
vpmullw		%ymm1,%ymm3,%ymm2
vpmullw		%ymm1,%ymm5,%ymm4
vpmullw		%ymm1,%ymm7,%ymm6

#mul 1
vpmullw		%ymm5,%ymm14,%ymm8
vpmullw		%ymm7,%ymm14,%ymm10
vpmullw		%ymm7,%ymm2,%ymm12
vpmullw		%ymm5,%ymm4,%ymm14
vpmulhw		%ymm5,%ymm15,%ymm9
vpmulhw		%ymm7,%ymm15,%ymm11
vpmulhw		%ymm7,%ymm3,%ymm13
vpmulhw		%ymm5,%ymm5,%ymm15

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm8,%ymm9,%ymm8
vpsubw		%ymm10,%ymm11,%ymm9
vpsubw		%ymm12,%ymm13,%ymm10
vpsubw		%ymm14,%ymm15,%ymm11

#add
vpsubw		%ymm10,%ymm11,%ymm10

#mul 2
vpmullw		%ymm3,%ymm2,%ymm11
vpmullw		%ymm9,%ymm4,%ymm13
vpmullw		%ymm9,%ymm6,%ymm6
vpmullw		%ymm5,%ymm2,%ymm4
vpmulhw		%ymm3,%ymm3,%ymm12
vpmulhw		%ymm9,%ymm5,%ymm14
vpmulhw		%ymm9,%ymm7,%ymm7
vpmulhw		%ymm5,%ymm3,%ymm5
vpmullw		%ymm1,%ymm8,%ymm15

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm11,%ymm12,%ymm11
vpsubw		%ymm13,%ymm14,%ymm12
vpmullw		%ymm1,%ymm9,%ymm13
vpsubw		%ymm6,%ymm7,%ymm6
vpsubw		%ymm4,%ymm5,%ymm7

#add
vpaddw		%ymm12,%ymm11,%ymm11
vpaddw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm6,%ymm0,%ymm6

#mul 3
vpmullw		%ymm10,%ymm15,%ymm12
vpmullw		%ymm6,%ymm13,%ymm14
vpmullw		%ymm11,%ymm2,%ymm4
vpmulhw		%ymm10,%ymm8,%ymm13
vpmulhw		%ymm6,%ymm9,%ymm15
vpmulhw		%ymm11,%ymm3,%ymm5

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm12,%ymm13,%ymm12
vpsubw		%ymm14,%ymm15,%ymm13
vpsubw		%ymm4,%ymm5,%ymm14

#add
vpaddw		%ymm12,%ymm13,%ymm12
vpsubw		%ymm12,%ymm14,%ymm12

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm6,32(%rdi)
vmovdqa		%ymm10,64(%rdi)

sub		$96,%rdi

#inverse of determinants
#load
vmovdqa		(%rsp),%ymm2
vmovdqa		%ymm12,%ymm6

#reduce2
vmovdqa		_low_mask(%rip),%ymm15
vpsraw		$13,%ymm2,%ymm3
vpsraw		$13,%ymm6,%ymm7
vpand		%ymm15,%ymm2,%ymm2
vpand		%ymm15,%ymm6,%ymm6
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm7,%ymm6,%ymm6
vpsllw		$9,%ymm3,%ymm3
vpsllw		$9,%ymm7,%ymm7
vpaddw		%ymm3,%ymm2,%ymm2
vpaddw		%ymm7,%ymm6,%ymm6

vmovdqa		%ymm2,%ymm4
vmovdqa		%ymm6,%ymm8

#a^2
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm9,%ymm8,%ymm8

#a^4, t = a^3
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^8, t = a^7
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^16, t = a^15
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^32, t = a^31
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^64, t = a^63
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^128, t = a^127
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^256, t = a^255
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^512, t = a^511
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^1024
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm9,%ymm8,%ymm8

#a^2048, t = a^1535
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#a^4096, t = a^3583
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm4,%ymm4,%ymm5
vpmullw		%ymm6,%ymm8,%ymm7
vpmullw		%ymm8,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm4,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm6
vpmulhw		%ymm8,%ymm8,%ymm8
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm5,%ymm5
vpmullw		%ymm1,%ymm7,%ymm7
vpmullw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm9,%ymm8,%ymm8

#t = a^7679
vpmullw		%ymm2,%ymm4,%ymm3
vpmullw		%ymm6,%ymm8,%ymm7
vpmulhw		%ymm2,%ymm4,%ymm2
vpmulhw		%ymm6,%ymm8,%ymm6
vpmullw		%ymm1,%ymm3,%ymm3
vpmullw		%ymm1,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm3,%ymm2,%ymm2
vpsubw		%ymm7,%ymm6,%ymm6

#divide by determinant
#premul
vpmullw		%ymm1,%ymm2,%ymm3
vpmullw		%ymm1,%ymm6,%ymm7

#load b0
vmovdqa		(%rdi),%ymm4
vmovdqa		96(%rdi),%ymm8

#mul
vpmullw		%ymm3,%ymm4,%ymm5
vpmullw		%ymm7,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm9,%ymm8,%ymm8

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm8,96(%rdi)

add		$32,%rdi

#load b1
vmovdqa		(%rdi),%ymm4
vmovdqa		96(%rdi),%ymm8

#mul
vpmullw		%ymm3,%ymm4,%ymm5
vpmullw		%ymm7,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm9,%ymm8,%ymm8

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm8,96(%rdi)

add		$32,%rdi

#load b2
vmovdqa		(%rdi),%ymm4
vmovdqa		96(%rdi),%ymm8

#mul
vpmullw		%ymm3,%ymm4,%ymm5
vpmullw		%ymm7,%ymm8,%ymm9
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm5,%ymm4,%ymm4
vpsubw		%ymm9,%ymm8,%ymm8

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm8,96(%rdi)

#check for invertibility
vpxor		%ymm15,%ymm15,%ymm15
vpcmpeqw	%ymm15,%ymm2,%ymm2
vpcmpeqw	%ymm15,%ymm6,%ymm6
vpor		%ymm6,%ymm2,%ymm2
vperm2i128	$0x10,%ymm2,%ymm2,%ymm3
por		%xmm3,%xmm2
vpshufd		$0x0E,%xmm2,%xmm3
por		%xmm3,%xmm2
vpextrq		$0,%xmm2,%r10
or		%r10,%rcx

add		$32,%rdi

add		$96,%rsi
add		$96,%rdi
add		$64,%rdx
add		$32,%rax
cmp		$256,%rax
jb		_looptop

add             %r11,%rsp
mov		%rcx,%rax
ret
