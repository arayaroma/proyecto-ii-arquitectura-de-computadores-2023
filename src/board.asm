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

    pattern db 'ABBBBABBBBBaBBBBBBBBBaBBBBBBBBBBaBBBBBBBBBaBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBcB','$'
    px db 75
    colorPaint db 66   
    py db 9
    highsize dw 20
    widthSize dw 28

    contLine db 0
    cont db 0
.Code

board PROC far
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
                mov colorPaint, 1
                call printRectangle
                jmp init
            notFree:
                mov colorPaint, 66
                call printRectangle
            init:
                inc py  ; increment py position to next row
                ; inc py  ; increment py position to next row

                inc si
                inc cont
                cmp cont, 10
                je pass
        jmp printPiece
        pass:
        pop cx
        mov py, 9 ; reset py position
        sub px, 3 ; increment px position to next col
        inc contLine 
        cmp contLine, 25
        je endPattern 
    jmp printPattern
    endPattern:

    ret
board ENDP

end