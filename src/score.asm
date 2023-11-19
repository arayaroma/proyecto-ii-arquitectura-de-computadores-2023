; score.asm
; author: arayaroma
;
.8086
.model small
public ScoreboardDriver, ConvertScoreTxt, driverValidate

; about.asm
extrn OnActionBackButton:far

;board 
extrn scorePlayer:word, player_score_value:byte

; menu.asm
extrn MenuDriver:far

; mouse.asm
extrn SetMousePosition:far, ShowMouse:far, GetKeyPressed:far
extrn HideMouse:far, mouseStatus:byte, delayClickMause:far

; graphics.asm
extrn ClearScreen:far, PrintMessage:far, nombre:byte
extrn PrintBackButton:far, OnActionBackButton:far, is_in_back_area:byte
extrn PrintScoreBoard:far

.data
    score				db "../src/score/score",0
    scoreboard_text 	db 'Scoreboard', '$'
    handle 				dw 0          ; Handle del archivo
    ScoreTable 			db "Score Table", "$"
    first 				db ""
	buffer_aux 			db 128 dup(" "), "$"
	buffer 				db 1 dup(" "), "$"
	nombre2 			db 128 dup(" "), "$"
	nombre1 			db 128 dup(" "), "$"
	nombre3 			db 128 dup(" "), "$"
	;aqui el puntaje
	puntaje_jugador 	db 128 dup(" "), "$"
	puntaje1 			db 128 dup(" "), "$"
	puntaje2 			db 128 dup(" "), "$"
	puntaje3 			db 128 dup(" "), "$"
	puntaje1Int 		dw  0 
	puntaje2Int 		dw  0 
	puntaje3Int 		dw  0 
	auxNumberConvert  	db 10 dup(" ")
	txt 				db " ", 0

.code

clearScoreName proc near

	mov puntaje1Int, 0
	mov puntaje2Int, 0
	mov puntaje3Int, 0

	lea si,auxNumberConvert
	mov cx, 10
	clear_loopN:
	mov al, " "
	mov [si], al
	inc si
	loop clear_loopN

	lea si, nombre1
	lea di,puntaje1
	mov cx, 128
	clear_loop1:
	mov al, " "
	mov [si], al
	mov [di], al
	inc di
	inc si
	loop clear_loop1
	lea si,nombre2
	lea di,puntaje2
	mov cx, 128
	clear_loop2:
	mov al, " "
	mov [si], al
	mov [di], al
	inc di
	inc si
	loop clear_loop2
	lea si,nombre3
	lea di,puntaje3
	mov cx, 128
	clear_loop3:
	mov al, " "
	mov [si], al
	mov [di], al
	inc di
	inc si
	loop clear_loop3


ret
clearScoreName endp

ScoreboardDriver proc far
	call delayClickMause
    call ClearScreen
    call openReadScore
	call read_file
	call close_file

    call PrintScore
    call ShowMouse
do_loop:
	call PrintBackButton
	call OnActionBackButton
	cmp [is_in_back_area], 1
	cmp [mouseStatus], 1
	je return_to_main_menu
	jne do_loop

return_to_main_menu:
	call HideMouse
	call delayClickMause
	call MenuDriver

    ret
ScoreboardDriver endp

clear_AuxNumber proc near
	push ax
	lea si, auxNumberConvert
	mov cx, 10
	clear_loop:
	mov al, 0
	mov [si], al
	inc si
	loop clear_loop
	pop ax
	ret
clear_AuxNumber endp

; ax, numero a convertir
; di, resultado
ConvertScoreTxt proc far
	call clear_AuxNumber
	mov bx,10
	lea si,auxNumberConvert
	inc si
	xor cx,cx
	loopConvert:
	inc cx 
	xor dx, dx
	div bx
	add dx, 48  
	mov [si],dx 
	
	cmp ax, 0
	je endLoop
	inc si
	jmp loopConvert
	endLoop:
	;lea di, player_score_value
	loop_next_number:
	mov al, [si]
	mov [di],al
	inc di
	dec si
	mov al, [si]

	;je end_convert
	loop loop_next_number
	end_convert:
		mov al, '$'
		mov [di], al

	ret
ConvertScoreTxt endp

openReadScore proc near
	mov ah, 3Dh
	mov al,00h
    lea dx, score
    int 21h
    mov handle, ax
ret
openReadScore endp

read_file proc near
	call clearScoreName
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

convertirCadena proc near
; Después de obtener las cadenas de puntajes
	lea si, puntaje1
	call ConvertirCadenaAEntero
	mov puntaje1Int, ax

	lea si, puntaje2
	call ConvertirCadenaAEntero
	mov puntaje2Int, ax

	lea si, puntaje3
	call ConvertirCadenaAEntero
	mov puntaje3Int, ax
ret
convertirCadena endp

ConvertirCadenaAEntero proc near
	xor ax, ax ; Limpiar AX
    xor dx, dx ; Limpiar DX
convertirLoop:
    ; Cargar el carácter actual de la cadena
	xor bx , bx
    MOV bl, [SI]

    ; Verificar si es el carácter nulo (fin de la cadena)
    CMP bl, "$"
    JE  finConvertir

    ; Convertir el carácter ASCII a número (suponiendo dígitos decimales)
    SUB bl, '0'

	add ax, bx

	MOV bl,[SI+1]
	CMP bl, "$"
	JE finConvertir
    ; Multiplicar el número actual por 10
    MOV BX, 10
    MUL BX
    ; Sumar el dígito convertido
    ; Mover al siguiente carácter en la cadena
    INC SI

    ; Repetir el bucle de conversión
    JMP convertirLoop

finConvertir:
ret
ConvertirCadenaAEntero endp

inc_buffer proc near
	mov ah, 3Fh
	mov bx, handle
	mov cx, 1
	lea dx, buffer
	int 21h
	lea di, buffer
	ret
inc_buffer endp

calcular_logitud proc near
calcular:
    cmp byte ptr [di], '$'
    je fin_calcular_longitud
    inc di
    inc cx
    jmp calcular
fin_calcular_longitud:
	ret
calcular_logitud endp

; Cerrar el archivo
close_file proc near
	MOV AH, 3EH
	MOV BX, handle
	INT 21H
	ret
close_file endp

PrintScore proc near
    ; mov dh, 6
    ; mov dl, 35 
    ; call SetMousePosition
    ; mov dx, offset ScoreTable 
    ; call PrintMessage
	call PrintScoreBoard

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

clear_file proc near
		; Abrir el archivo con la opción de escritura (truncate)
		; Abrir el archivo para escritura (o creación si no existe)
		mov ah, 3Ch
		lea dx, score
		mov cx, 0 ; Modo de apertura, 0 significa crear o abrir para escritura
		int 21h

ret
clear_file endp

espacio_blanco proc near
	xor si, si
	mov al, ' '
    mov [si], al
	mov ah, 40h
    mov bx, handle
    mov cx, 1 ; Número de bytes a escribir
    lea dx, [si]
    int 21h
	xor si, si
ret 
espacio_blanco endp

write_file proc near
 ; Abrir el archivo para escritura (o creación si no existe)
    mov ah, 3Ch
    lea dx, score
    mov cx, 0 ; Modo de apertura, 0 significa crear o abrir para escritura
    int 21h
	
    mov handle, ax ; Almacenar el handle del archivo en handle}
	
	xor di,di
	lea di, nombre1
	xor cx,cx
	call calcular_logitud
	lea di, nombre1
    ; Escribir en el archivo
    mov ah, 40h
    mov bx, handle
    lea dx, [di]
    int 21h
	
	call espacio_blanco
	
	xor di,di
	lea di, puntaje1
	xor cx,cx
	call calcular_logitud
	lea di, puntaje1
    ; Escribir en el archivo
    mov ah, 40h
    mov bx, handle
    lea dx, [di]
    int 21h
	
	call espacio_blanco
	
	xor di,di
	lea di, nombre2
	xor cx,cx
	call calcular_logitud
	lea di, nombre2
    ; Escribir en el archivo
    mov ah, 40h
    mov bx, handle
    lea dx, [di]
    int 21h
	
	call espacio_blanco
	
	xor di,di
	lea di, puntaje2
	xor cx,cx
	call calcular_logitud
	lea di, puntaje2
    ; Escribir en el archivo
    mov ah, 40h
    mov bx, handle
    lea dx, [di]
    int 21h
	
	call espacio_blanco
	
	xor di,di
	lea di, nombre3
	xor cx,cx
	call calcular_logitud
	lea di, nombre3
    ; Escribir en el archivo
    mov ah, 40h
    mov bx, handle
    lea dx, [di]
    int 21h
	
	call espacio_blanco

	xor dx, dx
	xor ax,ax
	xor di,di
	lea di, puntaje3
	xor cx,cx
	call calcular_logitud
	lea di, puntaje3
    mov ah, 40h
    mov bx, handle
    lea dx, [di]
    int 21h
	
	xor si, si
	mov al, '#'
    mov [si], al
	mov ah, 40h
    mov bx, handle
    mov cx, 1 ; Número de bytes a escribir
    lea dx, [si]
    int 21h
	xor si, si
	
ret 
write_file endp

validaciones proc near
	
	xor dx, dx
	mov dx, scorePlayer
	cmp dx, puntaje1Int
	jb end_validate  
	call evaluate3_position
	
	mov dx, scorePlayer
	cmp dx,puntaje2Int
	jb end_validate
	call evaluate2_position

	mov dx, scorePlayer
	cmp dx, puntaje3Int
	jb end_validate
	call evaluate1_position
	
end_validate:
ret
validaciones endp 

driverValidate proc far
	call openReadScore
	
	call read_file
	call close_file
	call convertirCadena
	call validaciones	

	call clear_file
	call close_file

	call write_file
	call close_file
	ret
driverValidate endp

evaluate3_position proc near
		mov nombre1, 0
		mov al, ' '
		lea di, nombre1
		clear_name3:
			mov [di],al
			mov ah,[di+1]
			cmp ah, '$'
			je end_clear_name3
			inc di
			jmp clear_name3
		end_clear_name3:
		lea si, nombre
		lea di, nombre1
		changeName3:
			mov ah,[si]
			mov [di],ah
			cmp ah, '$'
			je end_ChangeName3
			inc si
			inc di
			jmp changeName3
		end_ChangeName3:
		lea si, player_score_value
		lea di, puntaje1
		changePuntaje3:
			mov ah,[si]
			mov [di],ah
			cmp ah, '$'
			je end_evaluate3
			inc si
			inc di
		jmp changePuntaje3
end_evaluate3:
ret
evaluate3_position endp

evaluate2_position proc near
    ; Intercambiar los valores
    mov si, offset nombre1 ; Cargar la dirección de nombre1 en si
    mov di, offset nombre ; Cargar la dirección de buffer en di

    mov cx,128 ; Número de bytes a intercambiar (longitud de las cadenas, incluyendo el caracter '$')
    call changeName ; Llamar a la función para intercambiar

    mov si, offset nombre2 ; Cargar la dirección de nombre2 en si
    mov di, offset nombre1 ; Cargar la dirección de nombre1 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar

    mov si, offset nombre ; Cargar la dirección de buffer en si
    mov di, offset nombre2 ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
	
	mov si, offset puntaje2 ; Cargar la dirección de buffer en si
    mov di, offset player_score_value ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
	
	mov si, offset puntaje1 ; Cargar la dirección de buffer en si
    mov di, offset puntaje2 ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
	
	mov si, offset player_score_value ; Cargar la dirección de buffer en si
    mov di, offset puntaje1 ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
end_evaluate2:
ret
evaluate2_position endp

evaluate1_position proc near
    ; Intercambiar los valores
    mov si, offset nombre2 ; Cargar la dirección de nombre1 en si
    mov di, offset nombre ; Cargar la dirección de buffer en di

    mov cx,128 ; Número de bytes a intercambiar (longitud de las cadenas, incluyendo el caracter '$')
    call changeName ; Llamar a la función para intercambiar

    mov si, offset nombre3 ; Cargar la dirección de nombre2 en si
    mov di, offset nombre2 ; Cargar la dirección de nombre1 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar

    mov si, offset nombre ; Cargar la dirección de buffer en si
    mov di, offset nombre3 ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
	
	mov si, offset puntaje3 ; Cargar la dirección de buffer en si
    mov di, offset player_score_value ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
	
	mov si, offset puntaje2 ; Cargar la dirección de buffer en si
    mov di, offset puntaje3 ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
	
	mov si, offset player_score_value ; Cargar la dirección de buffer en si
    mov di, offset puntaje2 ; Cargar la dirección de nombre2 en di
	mov cx,128
    call changeName ; Llamar a la función para intercambiar
ret
evaluate1_position endp

changeName proc near
    push ax
    push bx
    push cx
    push si
    push di
    mov ax, ds
    mov es, ax

    ; Ajustar cx para incluir el caracter '$'
    inc cx

    rep movsb ; Mover los datos de ds:si a es:di
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
changeName endp

end