@echo off
echo Setting NeoVim config.

set target=%APPDATA%\..\Local\nvim\init.vim
del %target% >nul 2>&1
mkdir %APPDATA%\..\Local\nvim >nul 2>&1
mklink /H %target% %~dp0nvim\init.vim

echo Done!
