@echo off

setlocal

set filename=C:\Windows\pair.bat

echo @echo off > %filename%
echo %cd%\xp-mode.bat %%* >> %filename%