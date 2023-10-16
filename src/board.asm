.MODEL SMALL
public board      
public col, row, lenthLine, color, direction            
extrn printLine:far
extrn printRectangle:far
public px, py, colorPaint, widthSize, highsize
.data 
    col dw 100
    row dw 100
    count db 0
	sCol dw 50
	sRow dw 150
    lenthLine dw 0
	color db 66
    direction db 0 


    px dw 100
    colorPaint db 66   
    py dw 100
    highsize dw 55
    widthSize dw 55

.Code

board PROC far

    call printRectangle
    mov color, 55
    PUSH AX BX CX DX
    ; mov column and row to start position
    mov cx, sCol
    mov col, cx
    mov cx, sRow
    mov row,cx
    ; print all columns
    strCol:
        inc count
        mov cx, sRow ; reset row
        mov row, cx; reset row
            mov lenthLine, 160
            mov direction, 0
            call printLine
        cmp count, 40 
        je endCols ; go end 
        add col, 14
    jmp strCol ; go start column
    endCols:
    mov count,0
    mov cx, sRow
    mov row,cx
    strRow:
        mov cx, sCol
        mov col, cx
        inc count
        mov lenthLine, 546
        mov direction, 1
        call printLine
        ;printVertLine col row 66 546 ; print vertical line
        cmp count, 9 
        je endRows ; go end 
        add row,20 ; increment row position to next row
    jmp strRow ; go start row
    endRows:
    POP DX CX BX AX
    ret
board ENDP

end