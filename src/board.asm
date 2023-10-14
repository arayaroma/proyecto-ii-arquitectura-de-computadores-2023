.8086
.model small


INCLUDE util.asm
public board
.data
    col dw 0
    row dw 0
    count db 0
	sCol dw 50 ; start column
	sRow dw 150 ; start row 
.code


board PROC far
        PUSH AX BX CX DX
        ; mov column and row to start position
        mov cx, sCol
        mov col, cx
        mov cx, sRow
        mov row,cx
        mov cx, 160
        ; print all columns
        strCol:
            inc count
            mov cx, sRow ; reset row
            mov row,cx ; reset row
            mov cx, 160 
                prtCol:
                    push cx
                        printPoint col row 66 ; print point
                    pop cx
                    inc row ; increment row position
                loop prtCol
            cmp count, 40 
            je endCols ; go end 
            add col, 14
        jmp strCol
    endCols:
        mov count,0
        mov cx, sRow
        mov row,cx
        strRow:
            mov cx, sCol
            mov col, cx
            inc count
            mov cx,546
            prtRow:
                push cx
                    printPoint col row 66 ; print point
                pop cx
                inc col ; increment column position
            loop prtRow
            cmp count, 9 
                je endRows ; go end 
            
            add row,20
        jmp strRow 
        endRows:
        POP DX CX BX AX
        ret
    board ENDP
end