section .text
    global _start

_start:
    ; 비디오 모드 설정 (텍스트 모드)
    mov ax, 0x0003
    int 0x10

main_loop:
    ; 키보드 입력 대기
    mov ah, 0x00
    int 0x16          ; 키보드 입력을 받음

    ; 입력된 키를 화면에 표시
    mov ah, 0x0E
    int 0x10         ; AL에 있는 문자를 화면에 출력

    ; 무한 루프
    jmp main_loop
