@echo off
chcp 65001 >nul
title ¿Qué hay pa' ver hoy? - Panel de Control

:menu
cls
echo ===================================================
echo     CENTRO MULTIMEDIA - PANEL DE GESTION
echo ===================================================
echo.
echo   [1] Agregar nueva pelicula o serie
echo   [2] Borrar un elemento existente
echo   [0] Salir
echo.
echo ===================================================
set /p "opcion=Elige una opcion (1, 2 o 0): "

if "%opcion%"=="1" goto agregar
if "%opcion%"=="2" goto borrar
if "%opcion%"=="0" exit

goto menu

:: ===================================================
:: SECCION: AGREGAR CONTENIDO
:: ===================================================
:agregar
cls
echo ===================================================
echo              AGREGAR NUEVO CONTENIDO
echo ===================================================
echo.

set /p "tipo=Tipo (escribe 'filme' o 'serie'): "
if /i "%tipo%"=="f" set tipo=filme
if /i "%tipo%"=="s" set tipo=serie
if not "%tipo%"=="filme" if not "%tipo%"=="serie" (
    echo [X] Error: Escribe 'filme' o 'serie'.
    pause
    goto agregar
)

echo.
set /p "nombre=Nombre del contenido: "
if "%nombre%"=="" ( 
    echo [X] Error: El nombre no puede estar vacio.
    pause
    goto agregar
)

echo.
set /p "url=Ruta del archivo o URL: "
if "%url%"=="" (
    echo [X] Error: La URL no puede estar vacia.
    pause
    goto agregar
)

cls
echo ===================================================
echo              RESUMEN DE LO QUE VAS A AÑADIR
echo ===================================================
echo  Tipo   : %tipo%
echo  Nombre : %nombre%
echo  URL    : %url%
echo ===================================================
echo.
set /p "confir=¿Esta todo correcto? (s/n): "
if /i "%confir%" NEQ "s" (
    echo [!] Cancelado.
    timeout /t 2 >nul
    goto menu
)

powershell -Command "$lines = Get-Content 'index.html' -Encoding UTF8; $newItem = '        { type: ''%tipo%'', title: ''%nombre%'', url: ''%url%'' },'; for($i=0; $i -lt $lines.Length; $i++) { if($lines[$i] -match 'const catalogo = \[') { $insertIndex = $i + 1; break } } if($insertIndex) { $newLines = $lines[0..($insertIndex-1)] + $newItem + $lines[$insertIndex..($lines.Length-1)]; $newLines | Set-Content 'index.html' -Encoding UTF8; Write-Host '[OK] ¡Añadido con éxito!' -ForegroundColor Green } else { Write-Host '[X] Error al ubicar el catalogo' -ForegroundColor Red }"

echo.
pause
goto menu

:: ===================================================
:: SECCION: BORRAR CONTENIDO
:: ===================================================
:borrar
cls
echo ===================================================
echo                BORRAR CONTENIDO
echo ===================================================
echo.
echo Leyendo el catalogo actual desde el index.html...
echo.

powershell -Command "$lines = Get-Content 'index.html' -Encoding UTF8; $count = 0; for($i=0; $i -lt $lines.Length; $i++) { if($lines[$i] -match 'title:') { $count++; Write-Host ('  [' + $count + '] ' + $lines[$i].Trim()) } }; if($count -eq 0) { Write-Host 'No hay elementos.' }" > "%TEMP%\catalog_list.tmp"

type "%TEMP%\catalog_list.tmp"
echo.
echo ===================================================
set /p "numBorrar=Escribe el número del elemento que quieres BORRAR (o 0 para volver): "

if "%numBorrar%"=="0" (
    del "%TEMP%\catalog_list.tmp" >nul 2>&1
    goto menu
)

powershell -Command "$lines = Get-Content 'index.html' -Encoding UTF8; $target = [int]'%numBorrar%'; $current = 0; $newLines = @(); for($i=0; $i -lt $lines.Length; $i++) { if($lines[$i] -match 'title:') { $current++; if($current -eq $target) { continue } } $newLines += $lines[$i] }; $newLines | Set-Content 'index.html' -Encoding UTF8; Write-Host '[OK] ¡Borrado con éxito!' -ForegroundColor Green"

del "%TEMP%\catalog_list.tmp" >nul 2>&1
echo.
pause
goto borrar