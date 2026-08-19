@echo off
chcp 65001 >nul
title ¿Qué hay pa' ver hoy? - Auto Sincronizador Inteligente

cls
echo ===================================================
echo     AUTO-ESCANER Y SINCRONIZADOR INTELIGENTE
echo ===================================================
echo.
echo Escaneando carpetas Filmes y Series...
echo.

powershell -Command "$index = 'index.html'; $lines = Get-Content $index -Encoding UTF8; $existingContent = $lines -join \"`n\"; $newItems = @(); $addedFilmes = @(); $addedSeries = @(); $baseUrl = 'https://media.githubusercontent.com/media/fraudycrack/que_hay_pa_ver_hoy/refs/heads/main/'; if(Test-Path 'Filmes') { Get-ChildItem 'Filmes' -File | ForEach-Object { $fileName = $_.Name; $titleName = $_.BaseName; $encodedFile = [Uri]::EscapeDataString($fileName); $url = $baseUrl + $encodedFile; if(-not $existingContent.Contains($url)) { $newItems += '        { type: ''filme'', title: '' ' + $titleName + ' '', url: '' ' + $url + ' '' },'; $addedFilmes += $titleName } } }; if(Test-Path 'Series') { Get-ChildItem 'Series' -File | ForEach-Object { $fileName = $_.Name; $titleName = $_.BaseName; $encodedFile = [Uri]::EscapeDataString($fileName); $url = $baseUrl + $encodedFile; if(-not $existingContent.Contains($url)) { $newItems += '        { type: ''serie'', title: '' ' + $titleName + ' '', url: '' ' + $url + ' '' },'; $addedSeries += $titleName } } }; if($newItems.Count -eq 0) { Write-Host '[!] No hay archivos nuevos por añadir.' -ForegroundColor Yellow; exit }; for($i=0; $i -lt $lines.Length; $i++) { if($lines[$i] -match 'const catalogo = \[') { $insertIndex = $i + 1; break } } if($insertIndex) { $finalLines = $lines[0..($insertIndex-1)] + $newItems + $lines[$insertIndex..($lines.Length-1)]; $finalLines | Set-Content $index -Encoding UTF8; Write-Host '[OK] ¡Catalogo actualizado!' -ForegroundColor Green; Write-Host ''; Write-Host '--- REPORTE DE LO NUEVO AÑADIDO ---' -ForegroundColor Cyan; if($addedFilmes.Count -gt 0) { Write-Host ' [Filmes nuevos]:'; foreach($f in $addedFilmes) { Write-Host ('   - ' + $f) } }; if($addedSeries.Count -gt 0) { Write-Host ' [Series nuevas]:'; foreach($s in $addedSeries) { Write-Host ('   - ' + $s) } } } else { Write-Host '[X] Error: No se encontro la estructura en el index.html' -ForegroundColor Red }"

echo.
echo ===================================================
echo Proceso finalizado.
echo ===================================================
pause