del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
bin\tasm /z src\ascii.asm
bin\tasm /z src\graphics.asm
bin\tasm /z src\menu.asm
bin\tasm /z src\mouse.asm
bin\tasm /z src\board.asm
bin\tasm /z src\move.asm
bin\tasm /z src\readFile.asm
bin\tasm /z src\delay.asm
bin\tasm /z src\score.asm
bin\tasm /z src\about.asm
bin\tasm /z src\option.asm
bin\tlink main.obj ascii.obj graphics.obj menu.obj mouse.obj board.obj move.obj readFile.obj delay.obj score.obj option.obj about.obj, target\main.exe

copy *.obj target
del *.obj

copy *.map target
del *.map

copy main.exe target
del main.exe

:: execute it
target\main.exe