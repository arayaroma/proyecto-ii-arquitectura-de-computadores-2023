.MODEL SMALL
public board, BoardDriver                

; include util.inc
include src\macros\util.inc

; graphics.asm
extrn ClearScreen:far
extrn ShowMouse:far
extrn PrintMessage:far

; mouse.asm
extrn SetMousePosition:far

.data 
    col dw 10
    row dw 20
    count db 0
	sCol dw 50
	sRow dw 150
    board_text db 'Board', '$'

	
.Code

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
    jmp strCol ; go start column
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
    jmp strRow ; go start row
    endRows:
    POP DX CX BX AX
    ret
board ENDP

BoardDriver proc far
    call ClearScreen

    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset board_text 
    call PrintMessage

    call board
    call ShowMouse
    ret
BoardDriver endp

end