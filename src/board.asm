.MODEL SMALL
public board                  
include src\macros\util.inc

.data 
    col dw 10
    row dw 10
    count db 0
	sCol dw 50
	sRow dw 150
    lenthLine dw 0
	color db 63
    direction db 0 ; 0 = right, 1 = down
.Code



board PROC far

   ; printSquare col row 63 50

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
        waitEvent
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


printLine proc
    mov cx, lenthLine

    prtRow:
        push cx
            printPoint col row color ; print point
        pop cx
        cmp direction, 0
            je ptrCol
        inc col ; increment row position    
        jmp entPrt
        ptrCol:
            inc row ; increment row position
        entPrt:   
    loop prtRow

    ret
printLine endp
end