extrn setVideoMode:far
extrn printMenu:far
extrn clearScreen:far

.model small
.stack 100H     
.data

exit macro 
   mov ah, 4CH
   int 21H
endm

.code
   mov ax, @DATA            
   mov ds, ax 
                     
   call setVideoMode
   call clearScreen
   call printMenu
   exit

end