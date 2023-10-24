:: remove all files from target
del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
bin\tasm /z src\ascii.asm
bin\tasm /z src\graphics.asm
bin\tasm /z src\menu.asm
bin\tasm /z src\mouse.asm
bin\tasm /z src\score.asm
bin\tasm /z src\about.asm
bin\tasm /z src\board.asm

:: link the files
bin\tlink main.obj ascii.obj graphics.obj menu.obj mouse.obj score.obj about.obj board.obj, target\main.exe
pause

:: copy bin files into target
copy *.obj target
del *.obj

:: execute it
target\main.exe