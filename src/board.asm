.MODEL SMALL
public board      
public row, col, lenthLine, color, direction            
extrn printLine:far
extrn printRectangle:far
public px, py, colorPaint, widthSize, highsize
.data 
    row dw 100
    col dw 100
    count db 0
	sCol dw 50
	sRow dw 150
    lenthLine dw 0
	color db 66
    direction db 0 

    pattern db 'BBBBBABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBc','$'
    px dw 582
    colorPaint db 66   
    py dw 150
    highsize dw 20
    widthSize dw 28

    contLine db 0
    cont db 0
.Code

board PROC far
    PUSH AX BX CX DX
    lea si, pattern
    printPattern:
        mov cont,0
        printPiece:
            mov ah,[si]
            cmp ah, '$'
            je endPattern
            cmp ah,'B'
            je free 
            jne notFree
            free:
                mov colorPaint, 63
                call printRectangle
                jmp init
            notFree:
                mov colorPaint, 66
                call printRectangle
            init:
                add py, 20 ; increment py position to next row
                inc si
            inc cont
            cmp cont, 10
            je pass
        jmp printPiece
        pass:
        pop cx
        mov py, 150 ; reset py position
        sub px, 28 ; increment px position to next col
        inc contLine 
        cmp contLine, 20
        je endPattern 
    jmp printPattern
    endPattern:
    
    mov color, 55

    ; mov column and col to start position
    mov cx, sRow
    mov row, cx
    mov cx, sCol
    mov col,cx
    ; print all columns
    strCol:
        inc count
        mov cx, sCol ; reset col
        mov col, cx; reset col
            mov lenthLine, 560
            mov direction, 0
            call printLine
        cmp count, 10 
        je endCols ; go end 
        add row, 20
    jmp strCol ; go start column
    endCols:
    mov count,0
    mov cx, scol
    mov col,cx
    strRow:
        mov cx, sRow
        mov row, cx
        inc count
        mov lenthLine, 200
        mov direction, 1
        call printLine
        cmp count, 21 
        je endRows ; go end 
        add col,28 ; increment col position to next col
    jmp strRow ; go start col
    endRows:
    POP DX CX BX AX
    mov ah, 00H ; wait for keypress
    int 16H 
    ret
board ENDP

end