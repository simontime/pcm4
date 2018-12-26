extern fopen
extern fclose
extern feof
extern fputc
extern fgetc
extern strncmp
extern printf

section .data

usage:  db 'Usage: %s [-e, -d] input output',10,0
read:   db 'rb',0
write:  db 'wb',0
decode: db '-d',0
encode: db '-e',0

section .text
global main

main:
	push r13
	mov  r13, rsi
	push r12
	push rbp
	push rbx
	push rcx
	cmp  edi, 4
	je   init
	mov  rsi, qword [rsi]
	mov  edi, usage
	xor  eax, eax
	call printf
	mov  eax, 1
	jmp  exit

init:
	mov  rdi, qword [rsi + 0x10]
	mov  esi, read
	call fopen
	mov  rdi, qword [r13 + 0x18]
	mov  esi, write
	mov  rbp, rax
	call fopen
	mov  rdi, qword [r13 + 8]
	mov  edx, 2
	mov  esi, decode
	mov  r12, rax
	call strncmp
	test eax, eax
	je   decodefile

decodefile:
	mov  rdi, rbp
	call feof
	test eax, eax
	jne  check
	mov  rdi, rbp
	call fgetc
	mov  rsi, r12
	mov  edi, eax
	mov  ebx, eax
	sar  edi, 4
	and  ebx, 0xf
	imul edi, edi, 0x11
	call fputc
	imul edi, ebx, 0x11
	mov  rsi, r12
	call fputc
	jmp  decodefile

check:
	mov  rdi, qword [r13 + 8]
	mov  edx, 2
	mov  esi, encode
	mov  r13d, 0x11
	call strncmp
	test eax, eax
	je   encodefile
	jmp  close

encodefile:
	mov  rdi, rbp
	call feof
	test eax, eax
	jne  close
	mov  rdi, rbp
	call fgetc
	mov  rdi, rbp
	mov  ebx, eax
	call fgetc
	mov  rsi, r12
	mov  edi, eax
	mov  eax, ebx
	cdq
	idiv r13d
	mov  ebx, eax
	mov  eax, edi
	cdq
	sal  ebx, 4
	idiv r13d
	mov  edi, eax
	or   edi, ebx
	call fputc
	jmp  encodefile

close:
	mov  rdi, rbp
	call fclose
	mov  rdi, r12
	call fclose
	xor  eax, eax
	jmp  exit	

exit:
	pop  rdx
	pop  rbx
	pop  rbp
	pop  r12
	pop  r13
	ret