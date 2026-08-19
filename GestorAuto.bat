@echo off
chcp 65001 >nul
title ¿Qué hay pa' ver hoy? - Auto Sincronizador

cls
echo ===================================================
echo     AUTO-ESCANER Y SINCRONIZADOR DE CATALOGO
echo ===================================================
echo.
echo Escaneando carpetas Filmes y Series...
echo.

:: Script de PowerShell para escanear y generar las líneas con tu URL fija y el nombre del archivo
powershell -Command "$index = 'index.html'; $lines = Get-Content $index -Encoding UTF8; $newItems = @(); $baseUrl = 'https://media.githubusercontent.com/media/fraudycrack/que_hay_pa_ver_hoy/refs/heads/main/'; if(Test-Path 'Filmes') { Get-ChildItem 'Filmes' -File | ForEach-Object { $fileName = $_.Name; $titleName = $_.BaseName; $url = $baseUrl + $fileName; $newItems += '        { type: ''filme'', title: '' ' + $titleName + ' '', url: '' ' + $url + ' '' },' } }; if(Test-Path 'Series') { Get-ChildItem 'Series' -File | ForEach-Object { $fileName = $_.Name; $titleName = $_.BaseName; $url = $baseUrl + $fileName; $newItems += '        { type: ''serie'', title: '' ' + $titleName + ' '', url: '' ' + $url + ' '' },' } }; if($newItems.Count -eq 0) { Write-Host '[!] No se encontraron archivos en Filmes o Series.' -ForegroundColor Yellow; exit }; for($i=0; $i -lt $lines.Length; $i++) { if($lines[$i] -match 'const catalogo = \[') { $insertIndex = $i + 1; break } } if($insertIndex) { $finalLines = $lines[0..($insertIndex-1)] + $newItems + $lines[$insertIndex..($lines.Length-1)]; $finalLines | Set-Content $index -Encoding UTF8; Write-Host '[OK] ¡Catalogo sincronizado y actualizado con exito!' -ForegroundColor Green } else { Write-Host '[X] Error: No se encontro la estructura en el index.html' -ForegroundColor Red }"

echo.
echo ===================================================
echo Proceso finalizado.
echo ===================================================
pause