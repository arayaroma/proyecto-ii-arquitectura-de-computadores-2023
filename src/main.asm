; main.asm
; author: arayaroma
; 
.8086
.model small
.stack 100H     
extrn MenuDriver:far

.data

exit macro 
   mov ah, 4CH
   int 21H
endm

.code 
   mov ax, @DATA            
   mov ds, ax 

   call MenuDriver
   exit

end