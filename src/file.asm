; file.asm
; author: jesus abarca
; author: arayaroma
; author: amadorsalazar
;
.8086
.model small
public OpenFile, closeFile , getNextLine
public playHit, configAudio,playBonus, playGameOver

; move.asm
extrn movimiento:byte

; option.asm
extrn nombre:byte

; mouse.asm
extrn ShowMouse:far, SetMousePosition:far

; graphics.asm
extrn PrintMessage:far

.data
    pat1 				    db "../src/patterns/pat1"
	null1 					db 0
	pat2 				    db "../src/patterns/pat2"
	null2 					db 0
	pat3 				    db "../src/patterns/pat3"
	null3 					db 0
	pat4 				    db "../src/patterns/pat4"
	null4 					db 0
	pat5 				    db "../src/patterns/pat5"
	null5 					db 0
	pat6 				    db "../src/patterns/pat6"
	null6 					db 0
	pat7 				    db "../src/patterns/pat7"
	null7 					db 0
	pat8 				    db "../src/patterns/pat8"
	null8 					db 0
	pat9 				    db "../src/patterns/pat9"
	null9 					db 0
	pat10 				    db "../src/patterns/pat10"
	null10 					db 0

    handle 					dw 0
	hit1Path            	db "../src/audio/hit1.wav"
	null12 					db 0
	bonusPath            	db "../src/audio/bn.wav"
	null13 					db 0
	gemeO    				db "../src/audio/GO.wav"
	null11 					db 0
	is_open_error           db ?
    is_read_error           db ?
    open_error_message      db "Error opening file!", '$'
    read_error_message      db "Error reading file!", '$'
	filehandle dw 0          ; Handle del archivo
    bufferAudio db 0              ; Increase the bufferAudio size to 1 byte
    delayAudio dw 20 

	lastCom 				dw ?

.code

playHit proc far

    mov filehandle,0
    lea dx, hit1Path
    call PlayMusic
ret
playHit endp

playBonus proc far

	mov filehandle,0
	lea dx, bonusPath
	call PlayMusic
ret
playBonus endp

playGameOver proc far

	mov filehandle,0
	lea dx, gemeO
	call PlayMusic
ret
playGameOver endp


loadPattern proc near
	mov bx, 10
	call randomNumber
	cmp dx, 0
	je Epat1
	cmp dx, 1
	je Epat2
	cmp dx, 2
	je Epat3
	cmp dx, 3
	je Epat4
	cmp dx, 4
	je Epat5
	cmp dx, 5
	je Epat6
	cmp dx, 6
	je Epat7
	cmp dx, 7
	je Epat8
	cmp dx, 8
	je Epat9
	cmp dx, 9
	je Epat10

	Epat1:
		lea dx, pat1
	jmp endLoadPattern
	Epat2:
		lea dx, pat2
	jmp endLoadPattern
	Epat3:
		lea dx, pat3
	jmp endLoadPattern
	Epat4:
		lea dx, pat4
	jmp endLoadPattern
	Epat5:
		lea dx, pat5
	jmp endLoadPattern
	Epat6:
		lea dx, pat6
	jmp endLoadPattern
	Epat7:
		lea dx, pat7
	jmp endLoadPattern
	Epat8:
		lea dx, pat8
	jmp endLoadPattern
	Epat9:
		lea dx, pat9
	jmp endLoadPattern
	Epat10:
		lea dx, pat10

	endLoadPattern:
ret
loadPattern endp
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
	call loadPattern
	mov ah, 3Dh
	mov al, 00h
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
	; mov bx,7
	; call randomNumber
	; cmp dx,5
	; jne endGetNextLine
	call setwildcards


	endGetNextLine:
	pop dx
	pop cx
	pop bx
	pop ax
	ret
getNextLine endp

setwildcards proc 

	lea di,movimiento
	loopFree:
	mov al,[di]
	cmp al," "
	je fildFree
	inc di
	jmp loopFree
	fildFree:
	inc di
	getNumWildcards:
	mov bx, 13
	call randomNumber

	cmp lastCom, dx
	je getNumWildcards
	mov lastCom, dx


	cmp dx, 4
	je setRed
	cmp dx, 8
	je setBlue
	cmp dx, 12
	je setGreen
	jmp endSetWildcards
	setRed:
	mov al, 'r'
	mov [di], al
	jmp endSetWildcards
	setGreen:
	mov al, 'v'
	mov [di], al
	jmp endSetWildcards

	setBlue:
	mov al, 'a'
	mov [di], al
	jmp endSetWildcards

	endSetWildcards:
ret
setwildcards endp
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

; set bx limit
; return random number in dx
randomNumber proc near
    mov ah, 00h
    int 1ah
    mov ax, dx
    xor dx, dx
    div bx
ret
randomNumber endp

read proc  
    getBit:
    mov ah, 3Fh
    mov bx, filehandle
    mov cx, 1
    lea dx, bufferAudio
    int 21h
    cmp cx, ax 
    jne endFile
    xor ax, ax
    mov al, bufferAudio
    mov bl, 54
    mul bx
    shr ax, 8
    out 42h, al ; Send data
    mov cx, delayAudio
    rloop:
    loop rloop
    jmp getBit
    endFile:
    ret
read endp



PlayMusic proc  
    mov ah, 3Dh
	mov al, 00h
    int 21h
    mov filehandle, ax

    call read

    mov ah, 3Eh
    mov bx, filehandle
    int 21h
    ret
PlayMusic endp

configAudio proc far
    mov al, 90h
    out 43h, al
    in al, 61h
    or al, 3
    out 61h, al
    cli

ret
configAudio endp

end