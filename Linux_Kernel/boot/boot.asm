; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit macOS only.
; To assemble and run:
;
;   nasm -f macho64 hello_world.asm
;	ld -macosx_version_min 10.7.0 -o hello_world hello_world.o
;	./hello_world
;	
;	MakeOS_Linux Kernel
;   first Step  ) nasm -f bin boot.nasm
;   second Step ) qemu-system-x86_64 -drive format=raw,file=boot
; ----------------------------------------------------------------------------------------
org 0x7C00                      ; BIOS는 이 주소에서 프로그램을 로드
bits 16                         ; 여기서는 16비트 모드

start:
	mov ax, 0xB800
	mov es, ax

	mov byte[es:0], 'j'
	mov byte[es:1], 0x09
	mov byte[es:2], 'i'
	mov byte[es:3], 0x09
	mov byte[es:4], 'w'
	mov byte[es:5], 0x08
	mov byte[es:6], 'o'
	mov byte[es:7], 0x08
	mov byte[es:8], 'o'
	mov byte[es:9], 0x08

	mov ax, 0xB810
	mov es, ax
	mov byte[es:02h], 'w'
	mov byte[es:04h], 'e'
	mov byte[es:06h], 'l'
	mov byte[es:08h], 'l'
	mov byte[es:0ah], 'c'
	mov byte[es:0ch], 'o'
	mov byte[es:0eh], 'm'
	mov byte[es:10h], 'e'
	mov byte[es:12h], ' '
	mov byte[es:14h], '!'
	mov byte[es:16h], '!'
	mov byte[es:18h], '!'

	cli                     ; interrupts 비활성화
	mov si, msg             ; SI는 msg를 가리킨다.
	mov ah, 0x0E            ; 문자를 인쇄할 BIOS를 카리킨다.
.loop	lodsb               ; SI를 AL에 로드하고 add the SI [next char]
	or al, al               ; string END 체크
	jz halt                 ; 종료되면 점프하여 정지
	int 0x10                ; 그렇지않으면 문자인쇄를 위해 interrupts 호출
	jmp .loop               ; loop

halt:	hlt                     ; 실행 중지 CPU command
msg:	db "Hello, World!", 0   ; message to print

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55
