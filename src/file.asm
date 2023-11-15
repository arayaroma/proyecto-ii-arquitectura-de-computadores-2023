; file.asm
; author: jesus abarca
; author: arayaroma
;
.8086
.model small
public OpenFile, closeFile , getNextLine
; public OpenScoreFile, WriteScoreFile

; move.asm
extrn movimiento:byte

; option.asm
extrn nombre:byte

; mouse.asm
extrn ShowMouse:far
extrn SetMousePosition:far

; graphics.asm
extrn PrintMessage:far

.data
    filename 				db "../src/patterns/arch"
	; score					db "../src/patterns/score"
	; score_handle			dw 0
    handle 					dw 0

	is_open_error           db ?
    is_read_error           db ?
    open_error_message      db "Error opening file!", '$'
    read_error_message      db "Error reading file!", '$'
	randomNumber 			db 0
.code

; OpenFile
; 
; AL = 0 (read only), 1 (write only), 2 (read/write)
; AH = 3Dh (open file)
; BX = file handle
; CX = number of bytes to read
; DS:DX = address of buffer
;
OpenFile proc far

	call ClearVariables
	call generateBasicRandomNumber
	mov ah, 3Dh
	mov al, 00h
	lea dx, filename
	int 21h
	jc open_error

	mov handle, ax
	jmp _return

open_error:
	call OpenError
	jmp return

_return:
	ret
OpenFile endp

; OpenScoreFile proc far
; 	call ClearVariables
; 	mov ah, 3Dh
; 	mov al, 02h
; 	lea dx, score
; 	int 21h
; 	jc score_open_error

; 	mov score_handle, ax
; 	jmp final

; score_open_error:
; 	call OpenError
; 	jmp final	

; final:
; 	ret
; OpenScoreFile endp

; WriteScoreFile proc far
; 	mov ah, 40h
; 	mov bx, score_handle
; 	mov cx, 10
; 	lea dx, nombre
; 	int 21h
; 	jc write_error
; 	jmp do_end

; write_error:
; 	call OpenError
; 	jmp do_end

; do_end:
; 	ret
; WriteScoreFile endp

; CloseFile
;
; AH = 3Eh (close file)
; BX = file handle
;
CloseFile proc far
	xor ax, ax
	mov ah, 3Eh
	mov bx, handle
	int 21h
	ret
CloseFile endp 

getNextLine proc far
	push ax
	push bx
	push cx
	push dx
	init:
    mov ah, 3Fh
    mov bx, handle
    mov cx, 10
    lea dx, movimiento
    int 21h

	cmp ax,cx
	jne reOpen
	mov movimiento[10],"$"

	jmp return
	reOpen:
	call CloseFile
	call OpenFile
	jmp init
	return:
	pop dx
	pop cx
	pop bx
	pop ax
	ret
getNextLine endp

; ReadError
;
; Show error message when reading file
;
ReadError proc near
    mov [is_read_error], 1
    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset read_error_message
    call PrintMessage
    ret
ReadError endp

; OpenError
;
; Show error message when opening a file
;
OpenError proc near
    mov [is_open_error], 1
    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset open_error_message
    call PrintMessage
    ret
OpenError endp

ClearVariables proc near
	xor cx, cx
	mov handle, 0
	ret
ClearVariables endp

generateBasicRandomNumber proc
	mov ax, 40h
	mov es, ax
	mov ax, [es:6Ch]
	and al, 00000111b
	mov [randomNumber], al
	mov ax, 40h
	mov es, ax
	mov ax, [es:6Ch]
	and al, 00000001b
	add [randomNumber], al
	mov ax, 40h
	mov es, ax
	mov ax, [es:6Ch]
	and al, 00000001b
	add [randomNumber], al
	ret
generateBasicRandomNumber endp

end