.intel_syntax noprefix
.global _start

.data
vec: .float 200, 200, 0, 0
pos: .float 400, 300, 0, 0
window: .long 800, 600, 0, 0
minus_one: .float -1, -1, -1, -1
one: .float 1, 1, 1, 1
two: .float 2, 2, 2, 2
col_mask: .float 1, 1, -1, -1
str: .asciz "hello\n"
color: .quad 0xFF0000FF
radius: .float 50

.text
_start:
	mov edi, [window]
	mov esi, [window + 4]
	lea rdx, [str]
	call InitWindow

run:
	call WindowShouldClose
	test rax,rax
	jnz close

	# integrating position
	call GetFrameTime
	shufps xmm0, xmm0, 0
	mulps xmm0, [vec]
	addps xmm0, [pos]
	movaps [pos], xmm0

out:
	# vec = vec * (1 - 2 * collision)
	# collision detection
	shufps xmm0, xmm0, 0x44
	mov eax, [radius]
	movq xmm1, rax
	shufps xmm1, xmm1, 0x0
	mulps xmm0, [col_mask]
	addps xmm0, xmm1
	cvtdq2ps xmm1, [window]
	cmpps xmm0, xmm1, 1
	cvtdq2ps xmm0, xmm0
	mulps xmm0, [minus_one]

	movaps xmm1, xmm0
	shufps xmm1, xmm1, 0b00001110
	mulps xmm0, xmm1

	# vec
	movaps xmm2, [vec]
	shufps xmm2, xmm2, 0x44
	# vec = vec * (1 - 2 * collision)
	mulps xmm0, [two]
	movaps xmm1, [one]
	subps xmm1, xmm0
	mulps xmm1, [minus_one]
	mulps xmm2, xmm1
	movaps [vec], xmm2

	call BeginDrawing

	mov rdi, 0xFFFFFFFF
	call ClearBackground

	lea rdi, [str]
	mov rsi, 200
	mov rdx, 200
	mov rcx, 30
	mov r8, [color]
	call DrawText

	movaps xmm0, [pos]
	movss xmm1, [radius]
	mov rdi, 0xFF0000ff
	call DrawCircleV

	call EndDrawing

	jmp run

close:
	call CloseWindow

	mov rax, 231
	xor rdi, rdi
	syscall

