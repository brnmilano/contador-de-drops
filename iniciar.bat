@echo off
title Contador de drops
cd /d "%~dp0"
echo Iniciando o contador de drops...
echo Pasta: %~dp0
echo.

set "PS="
if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not defined PS if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PS=%ProgramFiles%\PowerShell\7\pwsh.exe"
if not defined PS for /f "delims=" %%i in ('where pwsh 2^>nul') do if not defined PS set "PS=%%i"
if not defined PS for /f "delims=" %%i in ('where powershell 2^>nul') do if not defined PS set "PS=%%i"

if not defined PS (
  echo ERRO: o PowerShell nao foi encontrado neste computador.
  echo Procurado em:
  echo   %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe
  echo   %ProgramFiles%\PowerShell\7\pwsh.exe
  pause
  exit /b 1
)

if exist "%~dp0COMO-USAR.txt" start "" "%~dp0COMO-USAR.txt"
echo Usando: %PS%
echo.
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0contador.ps1"
echo.
echo O contador foi encerrado. Codigo de saida: %errorlevel%
echo Se apareceu alguma mensagem de erro acima, copie e envie para o Claude.
pause
