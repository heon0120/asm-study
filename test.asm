; pingpong.asm
[org 0x100]          ; COM 파일의 시작 주소

section .text
start:
    mov ax, 0x0003   ; 텍스트 모드 설정
    int 0x10         ; BIOS 인터럽트 호출

    ; 초기 위치 설정
    mov bx, 10       ; 공의 X 위치
    mov dx, 10       ; 공의 Y 위치
    mov cx, 1        ; X 방향 (1: 오른쪽, -1: 왼쪽)
    mov si, 1        ; Y 방향 (1: 아래, -1: 위)

main_loop:
    ; 화면 지우기
    call clear_screen

    ; 공 그리기
    call draw_ball

    ; 키 입력 처리
    call read_input

    ; 공 위치 업데이트
    call update_ball_position

    ; 잠시 대기
    call delay

    jmp main_loop

; 화면 지우기
clear_screen:
    mov ah, 0x0E
    mov cx, 200      ; 줄 수
.clear_loop:
    mov bx, 80       ; 한 줄에 출력할 문자 수
    xor di, di       ; 현재 위치 초기화
.clear_line:
    mov al, ' '      ; 공백 문자
    int 0x10        ; 문자 출력
    inc di
    cmp di, bx
    jl .clear_line
    ; 줄 이동
    mov ah, 0x0E
    mov al, 0x0D     ; 캐리지 리턴
    int 0x10
    mov al, 0x0A     ; 라인 피드
    int 0x10
    loop .clear_loop
    ret

; 공 그리기
draw_ball:
    mov ah, 0x0E
    mov al, 'O'      ; 공을 나타내는 문자
    mov bh, 0        ; 페이지 수
    mov dh, [dx]     ; Y 위치
    mov dl, [bx]     ; X 위치
    int 0x10        ; 문자 출력
    ret

; 키 입력 처리
read_input:
    mov ah, 1        ; 키 입력 대기
    int 0x21
    jz .no_input     ; 입력 없으면 넘어감
    mov ah, 0       ; 키 읽기
    int 0x21
    cmp al, 'a'      ; 왼쪽으로 이동
    je .move_left
    cmp al, 'd'      ; 오른쪽으로 이동
    je .move_right
.no_input:
    ret

.move_left:
    dec bx           ; X 위치 감소
    ret

.move_right:
    inc bx           ; X 위치 증가
    ret

; 공 위치 업데이트
update_ball_position:
    add bx, cx       ; X 위치 업데이트
    add dx, si       ; Y 위치 업데이트

    ; 벽 충돌 처리
    cmp bx, 1
    jl .bounce_right
    cmp bx, 78
    jg .bounce_left
    cmp dx, 1
    jl .bounce_down
    cmp dx, 20
    jg .bounce_up
    jmp .done

.bounce_left:
    mov bx, 1
    jmp .done

.bounce_right:
    mov bx, 78
    jmp .done

.bounce_up:
    mov dx, 20
    jmp .done

.bounce_down:
    mov dx, 1
.done:
    ret

; 딜레이
delay:
    mov cx, 0xFFFF
.delay_loop:
    loop .delay_loop
    ret

; 프로그램 종료
section .bss