[bits 16]
[org 0x7C00]

start:
    ; 화면을 지우기
    mov ax, 0x0003
    int 0x10

    ; 문자열 출력
    mov si, msg
    call print_string

    ; 무한 루프
.loop:
    jmp .loop

print_string:
    lodsb               ; AL에 다음 문자 로드
    or al, al          ; AL이 0인지 확인
    jz .done           ; 0이면 끝
    mov ah, 0x0E      ; BIOS 문자 출력 기능
    int 0x10          ; 문자 출력
    jmp print_string
.done:
    ret

msg db 'Hello, Kernel!', 0

times 510-($-$$) db 0
dw 0xAA55
