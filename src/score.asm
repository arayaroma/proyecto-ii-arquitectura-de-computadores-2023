; score.asm
; author: arayaroma
;
.8086
.model small
public ScoreboardDriver

; mouse.asm
extrn SetMousePosition:far
extrn ShowMouse:far

; graphics.asm
extrn ClearScreen:far
extrn PrintMessage:far
extrn nombre:byte
.data
    score			db "../src/score/score",0
    scoreboard_text db 'Scoreboard', '$'
    handle dw 0          ; Handle del archivo
    ScoreTable db "Score Table", "$"
    first db ""
	buffer_aux db 128 dup(" "), "$"
	buffer db 1 dup(" "), "$"
	nombre2 db 128 dup(" "), "$"
	nombre1 db 128 dup(" "), "$"
	nombre3 db 128 dup(" "), "$"
	;aqui el puntaje
	puntaje_jugador db 128 dup(" "), "$"
	puntaje1 db 128 dup(" "), "$"
	puntaje2 db 128 dup(" "), "$"
	puntaje3 db 128 dup(" "), "$"
	puntaje1Int dw  0 
	puntaje2Int dw  0 
	puntaje3Int dw  0 
	puntajeOriginal dw 0
	puntajeTexto db 10 dup(" "), 10,13, "$"
	resultPuntaje  db 10 dup(" ")
	txt db "", 0
.code

openReadScore proc near
	mov ah, 3Dh
	mov al,00h
    lea dx, score
    int 21h
    mov handle, ax ; 
ret
openReadScore endp

read_file proc near
	lea si, nombre1
	optener_nombre1:
		call inc_buffer;
		mov al, [di]
		cmp al, " "
		je final_nombre1
		mov [si],al
		inc si
		jmp optener_nombre1
	final_nombre1:
		mov ah,'$'
		mov [si], ah
		xor si,si
		lea si, puntaje1
	optener_puntaje1:
		call inc_buffer;
		mov al, [di]
		cmp al, " "
		je final_puntaje1
		mov [si],al
		inc si
		jmp optener_puntaje1
	final_puntaje1:
		mov ah,'$'
		mov [si], ah
		xor si,si
		lea si, nombre2
	optener_nombre2:
		call inc_buffer;
		mov al, [di]
		cmp al, " "
		je final_nombre2
		mov [si],al
		inc si
		jmp optener_nombre2
	final_nombre2:
		mov ah,'$'
		mov [si], ah
		xor si,si
		lea si, puntaje2
	optener_puntaje2:
		call inc_buffer;
		mov al, [di]
		cmp al, " "
		je final_puntaje2
		mov [si],al
		inc si
		jmp optener_puntaje2
	final_puntaje2:
		mov ah,'$'
		mov [si], ah
		xor si,si
		lea si, nombre3
	optener_nombre3:
		call inc_buffer;
		mov al, [di]
		cmp al, " "
		je final_nombre3
		mov [si],al
		inc si
		jmp optener_nombre3
	final_nombre3:
		mov ah,'$'
		mov [si], ah
		xor si,si
		lea si, puntaje3
	optener_puntaje3:
		call inc_buffer;
		mov al, [di]
		cmp al, "#"
		je final_puntaje3
		mov [si],al
		inc si
		jmp optener_puntaje3
	final_puntaje3:
	mov ah, '$'
	mov [si], ah
ret
read_file endp

inc_buffer proc near
	mov ah, 3Fh
	mov bx, handle
	mov cx, 1
	lea dx, buffer
	int 21h
	lea di, buffer
	ret
inc_buffer endp

close_file proc near
; Cerrar el archivo
		MOV AH, 3EH
		MOV BX, handle
		INT 21H
ret
close_file endp

PrintScore proc near


    mov dh, 6
    mov dl, 35 
    call SetMousePosition

    mov dx, offset ScoreTable 
    call PrintMessage

    mov dh, 9
    mov dl, 30 
    call SetMousePosition

    mov dx, offset nombre3 
    call PrintMessage

    mov dh, 9
    mov dl, 46 
    call SetMousePosition

    mov dx, offset puntaje3 
    call PrintMessage


    mov dh, 11
    mov dl, 30 
    call SetMousePosition

    mov dx, offset nombre2
    call PrintMessage

    mov dh, 11
    mov dl, 46 
    call SetMousePosition

    mov dx, offset puntaje2
     call PrintMessage

    mov dh, 13
    mov dl, 30 
    call SetMousePosition

    mov dx, offset nombre1
    call PrintMessage

    mov dh, 13
    mov dl, 46 
    call SetMousePosition
    mov dx, offset puntaje1
    call PrintMessage
    ret
PrintScore endp
ScoreboardDriver proc far
    call ClearScreen
    call openReadScore
	call read_file
	call close_file
    call PrintScore

    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset scoreboard_text 
    call PrintMessage

    call ShowMouse
    ret
ScoreboardDriver endp

end