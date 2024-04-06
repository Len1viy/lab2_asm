; Sorting columns of matrix by sum elements of columns

section .data
n:
	dd	5
m:
	dd	6
matrix:
	dd	8407, -1130, -1515, 6802, 87, -5110
	dd	7075, -6996, 1312, -8429, 4935, -1330
	dd	2775, -1512, 8329, -922, 502, 3594
	dd	-6180, 6880, 6951, -6374, 7670, -2187
	dd	7563, 7387, -66, 5448, -4057, -9239
sums:
	dd	0, 0, 0, 0, 0, 0
adresses:
	dd	0, 0, 0, 0, 0, 0
ans_matrix:
	dd	0, 0, 0, 0, 0, 0
	dd	0, 0, 0, 0, 0, 0
	dd	0, 0, 0, 0, 0, 0
	dd	0, 0, 0, 0, 0, 0
	dd	0, 0, 0, 0, 0, 0



section .text
global _start
_start:
	mov	r11d, [m]
	mov	r10d, [n]
	cmp	r11d, 0
	jle	end
	mov	ebx, matrix
	mov	r12d, adresses
	xor	edi, edi
	mov	ecx, r11d
am:
	lea	eax, [matrix + edi*4]
	mov	[r12 + rdi*4], eax
	inc	edi
	loop	am
	mov	ecx, r11d
m1:
	xor	edi, edi
	mov	eax, [rbx]
	push	rcx
	mov	ecx, r10d
	dec	ecx
	jecxz	m3
m2:
	add	edi, [m]
	add	eax, [rbx + rdi*4]
	loop	m2
m3:
	add	edi, [m]
	mov	[rbx + rdi * 4], eax
	add	ebx, 4
	pop	rcx
	loop	m1
	xor	ebx, ebx
	mov	ebx, sums
	mov	ecx, [m]
	dec	ecx
	jle	end
	xor	edi, edi
m4:
	inc	edi
	mov	eax, [rbx + rdi * 4]
	mov	r13d, [r12 + rdi*4]
	mov	r8d, 0
	mov	r9d, edi
m5:
	xor	esi, esi
	add	esi, r8d
	add	esi, r9d
	shr	esi, 1
	cmp	eax, [rbx + rsi*4]
	%ifdef DESC
		jge	m7
	%else
		jle	m7
	%endif
m6:
	mov	r8d, esi
	inc	r8d
	cmp	r8d, r9d
	jg	m8
	jmp	m5
m7:
	mov	r9d, esi
	dec	r9d
	cmp	r8d, r9d
	jg	m8
	jmp	m5
m8:
	mov	esi, edi
m9:
	dec	esi
	cmp	esi, r8d
	jl	m10
	mov	edx, [rbx + rsi*4]
	mov	r14d, [r12 + rsi*4]
	mov	[rbx+rsi*4+4], edx
	mov	[r12+rsi*4+4], r14d
	jmp	m9
m10:
	inc	esi
	mov	[rbx + rsi*4], eax
	mov	[r12 + rsi*4], r13d
	loop	m4
	mov	r15d, ans_matrix
	mov	ecx, r11d
	xor	edi, edi
	xor	rax, rax
m11:
	mov	esi, [r12d]
	xor	edx, edx
	mov	edi, esi
	push	rcx
	mov	ecx, r10d
m12:
	mov	eax, [rdi + rdx*4]
	
	mov	[r15 + rdx*4], eax
	add	edx, r11d
	loop	m12
	add	r12d, 4
	add	r15d, 4
	pop	rcx
	loop	m11
end:
	mov	eax, 60
	mov	edi, 0
	syscall

