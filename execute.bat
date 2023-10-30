del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
bin\tasm /z src\ascii.asm
bin\tasm /z src\graphics.asm
pause
bin\tasm /z src\menu.asm
bin\tasm /z src\mouse.asm
bin\tasm /z src\board.asm
pause
bin\tasm /z src\move.asm
bin\tasm /z src\readFile.asm
bin\tasm /z src\delay.asm
bin\tasm /z src\score.asm
bin\tasm /z src\about.asm
bin\tasm /z src\option.asm
pause
bin\tlink main.obj ascii.obj graphics.obj menu.obj mouse.obj board.obj move.obj readFile.obj delay.obj score.obj option.obj  about.obj , target\main.exe
pause
copy *.obj target
del *.obj
pause

:: execute it
main.exe