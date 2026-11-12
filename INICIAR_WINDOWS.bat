@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
 echo ERRO: Flutter SDK nao encontrado no PATH.
 pause
 exit /b 1
)
if not exist "android\gradlew.bat" (
 echo Gerando estrutura nativa Android pelo Flutter SDK...
 call flutter create --platforms=android --project-name alerta_ja .
 if errorlevel 1 goto fail
)
call flutter pub get
if errorlevel 1 goto fail
call flutter analyze
if errorlevel 1 goto fail
call flutter test
if errorlevel 1 goto fail
call flutter run
if errorlevel 1 goto fail
exit /b 0
:fail
echo Ocorreu um erro. Copie o texto acima para diagnostico.
pause
exit /b 1
