; Sorting columns of matrix by sum elements of columns
bits 64
section .data
;n:
;	dd	5
;m:
;	dd	6
;matrix:
;	dd	8407, -1130, -1515, 6802, 87, -5110
;	dd	7075, -6996, 1312, -8429, 4935, -1330
;	dd	2775, -1512, 8329, -922, 502, 3594
;	dd	-6180, 6880, 6951, -6374, 7670, -2187
;	dd	7563, 7387, -66, 5448, -4057, -9239
;sums:
;	dd	0, 0, 0, 0, 0, 0
;adresses:
;	dd	0, 0, 0, 0, 0, 0
;ans_matrix:
;	dd	0, 0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0, 0
;n:
;	dd	4
;m:
;	dd	5
;matrix:
;	dd	1278, 976, 1554, 2293, -4714
;	dd	-1159, -682, 9710, 4072, 5340
;	dd	1660, 7524, 9863, 9775, -994
;	dd	9260, 7917, -3676, 2675, -326
;sums:
;	dq	0, 0, 0, 0, 0
;adresses:
;	dd	0, 0, 0, 0, 0
;ans_matrix:
;	dd	0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0
;	dd	0, 0, 0, 0, 0


n:
  dd  6
m:
  dd  6
matrix:
  dd  3,  1, -5, 6, 6, 2
  dd  4, -10, 4, 4, 2, 2
  dd  5,  2, -10, -12, 4, 10
  dd  -5, 0, -10, 4, 1, 2
  dd  -3, 20, 10, 4, 2, 4
  dd  0, 0, 23, 0, 0, 10
section .bss
sums:
  resq    6
adresses:
  resd  6
ans_matrix:
  resd    36
section .text
global _start
_start:
	mov	r11d, [m]
	mov	r10d, [n]
	cmp	r11d, 1
	jle	end
	mov	ebx, matrix
	mov	r12d, adresses
	xor	edi, edi
	mov	ecx, r11d
	xor	r15d, r15d
am: ; Генерация массива указателей на столбцы
	lea	eax, [matrix + edi*4]
	mov	[r12 + rdi*4], eax
	inc	edi
	loop	am
	mov	ecx, r11d
m1: ; Подсчет сумм по столбцам
	xor	rax, rax
	xor	edi, edi
	movsx	rax, dword[rbx]
	push	rcx
	mov	ecx, r10d
	dec	ecx
	jecxz	m3
m2:
	add	edi, [m]
	movsx	r14, dword[rbx + rdi*4]
	add	rax, r14
	loop	m2
m3:
	add	edi, [m]
	mov	[sums + r15 * 8], rax
	add	ebx, 4
	inc	r15d
	pop	rcx
	loop	m1
	xor	r15, r15
	xor	ebx, ebx
	mov	ebx, sums
	mov	ecx, [m]
	dec	ecx
	jle	end
	xor	edi, edi
m4:
	inc	edi
	mov	rax, [rbx + rdi * 8]
	mov	r13d, [r12 + rdi * 4]
	mov	r8d, 0
	mov	r9d, edi
m5: ; Начало сортировки
	xor	esi, esi
	add	esi, r8d
	add	esi, r9d
	shr	esi, 1
	cmp	rax, [rbx + rsi*8]
	%ifdef DESC
		jge	m7
	%else
		jle	m7
	%endif
m6: ; Сдвиг левой границы
	mov	r8d, esi
	inc	r8d
	cmp	r8d, r9d
	jg	m8
	jmp	m5
m7: ; Сдвиг правой границы
	mov	r9d, esi
	dec	r9d
	cmp	r8d, r9d
	jg	m8
	jmp	m5
m8: ; перемещение элемента на найденную позицию
	mov	esi, edi
m9:
	dec	esi
	cmp	esi, r8d
	jl	m10
	mov	rdx, [rbx + rsi*8]
	mov	r14d, [r12 + rsi*4]
	mov	[rbx+rsi*8+8], rdx
	mov	[r12+rsi*4+4], r14d
	jmp	m9
m10:
	inc	esi
	mov	[rbx + rsi*8], rax
	mov	[r12 + rsi*4], r13d
	loop	m4
; Генерация итоговой матрицы
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

