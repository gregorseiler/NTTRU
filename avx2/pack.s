.global poly_pack_uniform
poly_pack_uniform:

xor		%eax,%eax
.p2align 5
_looptop_pack_uniform:
#load
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5
vmovdqa		192(%rsi),%ymm6
vmovdqa		224(%rsi),%ymm7

vpsllw		$13,%ymm1,%ymm15
vpaddw		%ymm15,%ymm0,%ymm0
vmovdqu		%ymm0,(%rdi)
add		$32,%rdi

vpsrlw		$3,%ymm1,%ymm1
vpsllw		$10,%ymm2,%ymm15
vpaddw		%ymm15,%ymm1,%ymm1
vmovdqu		%ymm1,(%rdi)
add		$32,%rdi

vpsrlw		$6,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm15
vpaddw		%ymm15,%ymm2,%ymm2
vmovdqu		%ymm2,(%rdi)
add		$32,%rdi

vpsrlw		$9,%ymm3,%ymm3
vpsllw		$4,%ymm4,%ymm15
vpaddw		%ymm15,%ymm3,%ymm3
vmovdqu		%ymm3,(%rdi)
add		$32,%rdi

vpsrlw		$12,%ymm4,%ymm4
vpsllw		$1,%ymm5,%ymm15
vpaddw		%ymm15,%ymm4,%ymm4
vpsllw		$14,%ymm6,%ymm15
vpaddw		%ymm15,%ymm4,%ymm4
vmovdqu		%ymm4,(%rdi)
add		$32,%rdi

vmovdqa		256(%rsi),%ymm8
vmovdqa		288(%rsi),%ymm9
vmovdqa		320(%rsi),%ymm10
vmovdqa		352(%rsi),%ymm11
vmovdqa		384(%rsi),%ymm12
vmovdqa		416(%rsi),%ymm13
vmovdqa		448(%rsi),%ymm14
vmovdqa		480(%rsi),%ymm15

vpsrlw		$2,%ymm6,%ymm6
vpsllw		$11,%ymm7,%ymm0
vpaddw		%ymm0,%ymm6,%ymm6
vmovdqu		%ymm6,(%rdi)
add		$32,%rdi

vpsrlw		$5,%ymm7,%ymm7
vpsllw		$8,%ymm8,%ymm0
vpaddw		%ymm0,%ymm7,%ymm7
vmovdqu		%ymm7,(%rdi)
add		$32,%rdi

vpsrlw		$8,%ymm8,%ymm8
vpsllw		$5,%ymm9,%ymm0
vpaddw		%ymm0,%ymm8,%ymm8
vmovdqu		%ymm8,(%rdi)
add		$32,%rdi

vpsrlw		$11,%ymm9,%ymm9
vpsllw		$2,%ymm10,%ymm0
vpaddw		%ymm0,%ymm9,%ymm9
vpsllw		$15,%ymm11,%ymm0
vpaddw		%ymm0,%ymm9,%ymm9
vmovdqu		%ymm9,(%rdi)
add		$32,%rdi

vpsrlw		$1,%ymm11,%ymm11
vpsllw		$12,%ymm12,%ymm0
vpaddw		%ymm0,%ymm11,%ymm11
vmovdqu		%ymm11,(%rdi)
add		$32,%rdi

vpsrlw		$4,%ymm12,%ymm12
vpsllw		$9,%ymm13,%ymm0
vpaddw		%ymm0,%ymm12,%ymm12
vmovdqu		%ymm12,(%rdi)
add		$32,%rdi

vpsrlw		$7,%ymm13,%ymm13
vpsllw		$6,%ymm14,%ymm0
vpaddw		%ymm0,%ymm13,%ymm13
vmovdqu		%ymm13,(%rdi)
add		$32,%rdi

vpsrlw		$10,%ymm14,%ymm14
vpsllw		$3,%ymm15,%ymm0
vpaddw		%ymm0,%ymm14,%ymm14
vmovdqu		%ymm14,(%rdi)
add		$32,%rdi

add		$512,%rsi
add		$256,%eax
cmp		$768,%eax
jb		_looptop_pack_uniform

ret

.global poly_unpack_uniform
poly_unpack_uniform:

vmovdqa		_low_mask(%rip),%ymm15

xor		%eax,%eax
.p2align 5
_looptop_unpack_uniform:
#load
vmovdqu		(%rsi),%ymm0
vmovdqu		32(%rsi),%ymm1
vmovdqu		64(%rsi),%ymm2
vmovdqu		96(%rsi),%ymm3
vmovdqu		128(%rsi),%ymm4
vmovdqu		160(%rsi),%ymm5
vmovdqu		192(%rsi),%ymm6
vmovdqu		224(%rsi),%ymm7
vmovdqu		256(%rsi),%ymm8
vmovdqu		288(%rsi),%ymm9
vmovdqu		320(%rsi),%ymm10
vmovdqu		352(%rsi),%ymm11
vmovdqu		384(%rsi),%ymm12

vpand		%ymm15,%ymm0,%ymm13
vmovdqa		%ymm13,(%rdi)
add		$32,%rdi

vpsrlw		$13,%ymm0,%ymm0
vpsllw		$3,%ymm1,%ymm13
vpaddw		%ymm13,%ymm0,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,(%rdi)
add		$32,%rdi

vpsrlw		$10,%ymm1,%ymm1
vpsllw		$6,%ymm2,%ymm13
vpaddw		%ymm13,%ymm1,%ymm1
vpand		%ymm15,%ymm1,%ymm1
vmovdqa		%ymm1,(%rdi)
add		$32,%rdi

vpsrlw		$7,%ymm2,%ymm2
vpsllw		$9,%ymm3,%ymm13
vpaddw		%ymm13,%ymm2,%ymm2
vpand		%ymm15,%ymm2,%ymm2
vmovdqa		%ymm2,(%rdi)
add		$32,%rdi

vpsrlw		$4,%ymm3,%ymm3
vpsllw		$12,%ymm4,%ymm13
vpaddw		%ymm13,%ymm3,%ymm3
vpand		%ymm15,%ymm3,%ymm3
vmovdqa		%ymm3,(%rdi)
add		$32,%rdi

vpsrlw		$1,%ymm4,%ymm4
vpand		%ymm15,%ymm4,%ymm13
vmovdqa		%ymm13,(%rdi)
add		$32,%rdi

vpsrlw		$13,%ymm4,%ymm4
vpsllw		$2,%ymm5,%ymm13
vpaddw		%ymm13,%ymm4,%ymm4
vpand		%ymm15,%ymm4,%ymm4
vmovdqa		%ymm4,(%rdi)
add		$32,%rdi

vpsrlw		$11,%ymm5,%ymm5
vpsllw		$5,%ymm6,%ymm13
vpaddw		%ymm13,%ymm5,%ymm5
vpand		%ymm15,%ymm5,%ymm5
vmovdqa		%ymm5,(%rdi)
add		$32,%rdi

vpsrlw		$8,%ymm6,%ymm6
vpsllw		$8,%ymm7,%ymm13
vpaddw		%ymm13,%ymm6,%ymm6
vpand		%ymm15,%ymm6,%ymm6
vmovdqa		%ymm6,(%rdi)
add		$32,%rdi

vpsrlw		$5,%ymm7,%ymm7
vpsllw		$11,%ymm8,%ymm13
vpaddw		%ymm13,%ymm7,%ymm7
vpand		%ymm15,%ymm7,%ymm7
vmovdqa		%ymm7,(%rdi)
add		$32,%rdi

vpsrlw		$2,%ymm8,%ymm8
vpand		%ymm15,%ymm8,%ymm13
vmovdqa		%ymm13,(%rdi)
add		$32,%rdi

vpsrlw		$13,%ymm8,%ymm8
vpsllw		$1,%ymm9,%ymm13
vpaddw		%ymm13,%ymm8,%ymm8
vpand		%ymm15,%ymm8,%ymm8
vmovdqa		%ymm8,(%rdi)
add		$32,%rdi

vpsrlw		$12,%ymm9,%ymm9
vpsllw		$4,%ymm10,%ymm13
vpaddw		%ymm13,%ymm9,%ymm9
vpand		%ymm15,%ymm9,%ymm9
vmovdqa		%ymm9,(%rdi)
add		$32,%rdi

vpsrlw		$9,%ymm10,%ymm10
vpsllw		$7,%ymm11,%ymm13
vpaddw		%ymm13,%ymm10,%ymm10
vpand		%ymm15,%ymm10,%ymm10
vmovdqa		%ymm10,(%rdi)
add		$32,%rdi

vpsrlw		$6,%ymm11,%ymm11
vpsllw		$10,%ymm12,%ymm13
vpaddw		%ymm13,%ymm11,%ymm11
vpand		%ymm15,%ymm11,%ymm11
vmovdqa		%ymm11,(%rdi)
add		$32,%rdi

vpsrlw		$3,%ymm12,%ymm12
vmovdqa		%ymm12,(%rdi)
add		$32,%rdi

add		$416,%rsi
add		$256,%eax
cmp		$768,%eax
jb		_looptop_unpack_uniform

ret

.global poly_pack_short
poly_pack_short:

vmovdqa		_16x3(%rip),%ymm0
vpsrlw		$1,%ymm0,%ymm0

xor		%eax,%eax
.p2align 5
_looptop_pack_short:
#load
vmovdqa		(%rsi),%ymm1
vmovdqa		32(%rsi),%ymm2
vmovdqa		64(%rsi),%ymm3
vmovdqa		96(%rsi),%ymm4
vmovdqa		128(%rsi),%ymm5
vmovdqa		160(%rsi),%ymm6
vmovdqa		192(%rsi),%ymm7
vmovdqa		224(%rsi),%ymm8

vpaddw		%ymm0,%ymm1,%ymm1
vpaddw		%ymm0,%ymm2,%ymm2
vpaddw		%ymm0,%ymm3,%ymm3
vpaddw		%ymm0,%ymm4,%ymm4
vpaddw		%ymm0,%ymm5,%ymm5
vpaddw		%ymm0,%ymm6,%ymm6
vpaddw		%ymm0,%ymm7,%ymm7
vpaddw		%ymm0,%ymm8,%ymm8
vpsllw		$2,%ymm2,%ymm2
vpsllw		$4,%ymm3,%ymm3
vpsllw		$6,%ymm4,%ymm4
vpsllw		$8,%ymm5,%ymm5
vpsllw		$10,%ymm6,%ymm6
vpsllw		$12,%ymm7,%ymm7
vpsllw		$14,%ymm8,%ymm8
vpaddw		%ymm2,%ymm1,%ymm1
vpaddw		%ymm4,%ymm3,%ymm3
vpaddw		%ymm6,%ymm5,%ymm5
vpaddw		%ymm8,%ymm7,%ymm7
vpaddw		%ymm1,%ymm3,%ymm1
vpaddw		%ymm7,%ymm5,%ymm5
vpaddw		%ymm1,%ymm5,%ymm1
vmovdqu		%ymm1,(%rdi)

add		$256,%rsi
add		$32,%rdi
add		$128,%eax
cmp		$768,%eax
jb		_looptop_pack_short

ret
