[bits 32]
section .text
global _start

_start:
    ; 커널 초기화
    mov eax, 1
    mov ebx, 0
    int 0x80

    ; 문자열 출력
    mov edx, msg_len
    mov ecx, msg
    mov ebx, 1        ; stdout
    mov eax, 4        ; sys_write
    int 0x80

    ; 무한 루프
.loop:
    jmp .loop

section .data
msg db 'Hello from the kernel!', 0xA
msg_len equ $ - msg
