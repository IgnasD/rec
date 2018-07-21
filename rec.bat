@echo off
cd /d %~dps0
cls
title FripTV
color 17
if "%1"=="planinis" goto planinis
if exist friptv.exe goto nustatymai
echo Nerastas friptv.exe
goto isejimas
:nustatymai
set /p kanalas=Kanalo numeris: 
set /p trukme=Iraso trukme (minutemis): 
set /p failas=Failo pavadinimas (su galune): 
set /p isjungimas=Isjungti kompiuteri po irasymo? [T/N]: 
set /p pradeti=Pradeti dabar? [T/N]: 
if /i "%pradeti%"=="T" goto irasymas
set /p diena=Kelinta diena pradeti? (jeigu siandien, nerasykite nieko): 
set /p laikas=Kokiu laiku pradeti? (formatas HH:mm): 
if "%diena%"=="" (set data=%laikas% /interactive) else (set data=%laikas% /interactive /next:%diena%)
if /i "%isjungimas%"=="T" (set isjungti=1) else (set isjungti=0)
at %data% %~s0 planinis %isjungti% %kanalas% %trukme% %failas% > nul
echo Irasymas prasides tavo nurodytu laiku. Sis langas tau nebereikalingas.
goto isejimas
:planinis
echo Planinis irasymas (%DATE% %TIME%):
set kanalas=%3
echo Kanalo numeris: %kanalas%
set trukme=%4
echo Iraso trukme (minutemis): %trukme%
set failas=%5
echo Failo pavadinimas (su galune): %failas%
if "%2"=="1" set isjungimas=T
:irasymas
echo Pradedamas irasymas. Sekanti zinute pranes apie irasymo pabaiga.
friptv.exe /silent /ch=%kanalas% /file=%failas% /t=%trukme%
echo Irasymas baigtas.
if /i not "%isjungimas%"=="T" goto isejimas
echo Paleidziama kompiuterio isjungimo seka.
shutdown -s -t 60 -c "Irasymas baigtas." -f
:isejimas
echo Spauskite betkoki klavisa, kad iseitumete.
pause>nul
exit