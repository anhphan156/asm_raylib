.intel_syntax noprefix
.global _start

.data
str: .asciz "hello\n"
color: .quad 0xFF0000FF
radius: .float 50.0

.text
_start:
	mov rdi, 800
	mov rsi, 600
	lea rdx, [str]
	call InitWindow

run:
	call WindowShouldClose
	test rax,rax
	jnz close

	call BeginDrawing

	mov rdi, 0xFFFFFFFF
	call ClearBackground

	lea rdi, [str]
	mov rsi, 200
	mov rdx, 200
	mov rcx, 30
	movd r8d, [color]
	call DrawText

	mov rdi, 450
	mov rsi, 450
	movss xmm0, [radius]
	mov rdx, 0xFFaabbFF
	call DrawCircle

	call EndDrawing

	jmp run

close:
	call CloseWindow

	mov rax, 231
	mov rdi, 0
	syscall

