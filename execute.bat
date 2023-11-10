:: delete the files
del target\*.* /Q

:: assemble the files
bin\tasm /zi src\main.asm
bin\tasm /zi src\ascii.asm
bin\tasm /zi src\graphic.asm
bin\tasm /zi src\menu.asm
bin\tasm /zi src\mouse.asm
bin\tasm /zi src\board.asm
bin\tasm /zi src\move.asm
bin\tasm /zi src\file.asm
pause
bin\tasm /zi src\score.asm
bin\tasm /zi src\about.asm
bin\tasm /zi src\option.asm
bin\tlink /v main.obj ascii.obj graphic.obj menu.obj mouse.obj board.obj move.obj file.obj score.obj option.obj about.obj

:: copy the files
copy *.obj target
del *.obj
copy *.map target
del *.map 
copy *.exe target
del *.exe

:: execute it
target\main.exe