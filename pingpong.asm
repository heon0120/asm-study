[bits 16]
[org 0x7C00]

; 변수 정의
ball_x db 40          ; 공의 x 위치
ball_y db 12          ; 공의 y 위치
dir_x db 1           ; x 방향
dir_y db 1           ; y 방향

start:
    ; 화면 초기화
    mov ax, 0x0003
    int 0x10

    ; 게임 루프
.loop:
    call draw_ball
    call input
    call update_ball
    call delay
    jmp .loop

; 공 그리기
draw_ball:
    mov ax, 0x0E
    mov bh, 0          ; 페이지 번호
    mov bl, 7          ; 색상 (흰색)
    mov cx, ball_x
    mov dx, ball_y
    int 0x10          ; 문자 출력
    mov ah, 0x00
    int 0x10          ; 위치 조정
    mov al, 'O'       ; 공 문자
    int 0x10
    ret

; 공 위치 업데이트
update_ball:
    ; 현재 위치 가져오기
    mov al, [ball_x]
    add al, [dir_x]
    mov [ball_x], al

    mov al, [ball_y]
    add al, [dir_y]
    mov [ball_y], al

    ; 벽 충돌 체크
    cmp al, 0
    jl .bounce_y
    cmp al, 24
    jg .bounce_y
    jmp .end_update

.bounce_y:
    ; 방향 반전
    xor [dir_y], 1

.end_update:
    ; x 방향 체크
    mov al, [ball_x]
    cmp al, 0
    jl .bounce_x
    cmp al, 79
    jg .bounce_x
    jmp .end_update_x

.bounce_x:
    xor [dir_x], 1

.end_update_x:
    ret

; 입력 처리
input:
    ; 키 입력을 확인하여 공의 방향 변경
    mov ah, 1
    int 0x21
    jz .no_input

    ; 입력이 있을 경우
    mov ah, 0
    int 0x21
    cmp al, 'a'       ; 왼쪽 키
    je .move_left
    cmp al, 'd'       ; 오른쪽 키
    je .move_right
    jmp .no_input

.move_left:
    dec [ball_x]
    jmp .no_input

.move_right:
    inc [ball_x]
    jmp .no_input

.no_input:
    ret

; 지연 함수
delay:
    mov cx, 0xFFFF
.delay_loop:
    loop .delay_loop
    ret

; 부트 섹터 끝
times 510-($-$$) db 0
dw 0xAA55
