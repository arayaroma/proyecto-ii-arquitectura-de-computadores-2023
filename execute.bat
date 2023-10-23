:: remove all files from target
::pause
del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
::pause
bin\tasm /z src\ascii.asm
::pause
bin\tasm /z src\graphics.asm
::pause
bin\tasm /z src\menu.asm
::pause
pause
bin\tasm /z src\mouse.asm
pause
bin\tasm /z src\board.asm
pause
bin\tasm /z src\line.asm
::pause
bin\tasm /z src\rect.asm
bin\tasm /z src\state.asm
bin\tasm /z src\move.asm

pause
:: copy bin files into target
::copy *.obj target
::del *.obj
:: link the files
::bin\tlink target\main.obj target\ascii.obj target\graphics.obj target\menu.obj target\mouse.obj target\board.obj target\line.obj target\rect.obj target\main.exe
bin\tlink main.obj ascii.obj graphics.obj menu.obj mouse.obj board.obj line.obj rect.obj state.obj move.obj , target\main.exe
copy *.obj target
del *.obj
pause

:: execute it
target\main.exe