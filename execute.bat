del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
::pause
bin\tasm /z src\ascii.asm
::pause
bin\tasm /z src\graphics.asm
::pause
bin\tasm /z src\menu.asm
bin\tasm /z src\mouse.asm
bin\tasm /z src\score.asm
bin\tasm /z src\about.asm
bin\tasm /z src\board.asm
bin\tasm /z src\option.asm
pause

:: link the files
bin\tlink main.obj ascii.obj graphics.obj menu.obj mouse.obj score.obj about.obj board.obj option.obj, target\main.exe

:: copy bin files into target
copy *.obj target
del *.obj
::pause
pause
bin\tasm /z src\mouse.asm
pause
bin\tasm /z src\board.asm
pause
::pause
bin\tasm /z src\rect.asm
bin\tasm /z src\state.asm
bin\tasm /z src\move.asm
bin\tasm /z src\readFile.asm
bin\tasm /z src\delay.asm
pause
bin\tlink main.obj ascii.obj graphics.obj menu.obj mouse.obj board.obj  rect.obj state.obj move.obj readFile.obj delay.obj, target\main.exe
copy *.obj target
del *.obj
pause

:: execute it
target\main.exe