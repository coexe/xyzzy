@echo off
setlocal

if "%1"=="" goto usage

set TAG=%1
set ARCHIVE=xyzzy-%TAG%.zip

set BASEDIR=%~dp0
set GIT_REPO=%BASEDIR%
set DISTROOT=%BASEDIR%\_dist
set DISTDIR=%BASEDIR%\_dist\xyzzy
set BUILDDIR=%BASEDIR%\_dist\build

call git tag %TAG% || exit /b 1

cd %BASEDIR%
rd /S /Q %DISTROOT% 2> nul

mkdir %DISTROOT%
mkdir %BUILDDIR%
mkdir %DISTDIR%
mkdir %DISTDIR%\lisp
mkdir %DISTDIR%\etc
mkdir %DISTDIR%\html
mkdir %DISTDIR%\reference
mkdir %DISTDIR%\site-lisp

cd %BUILDDIR%
call git clone %GIT_REPO% %BUILDDIR% || exit /b 1
call git checkout %TAG% || git tag; exit /b 1
call build.bat || exit /b 1

xcopy /F /G /H /R /K /Y *.exe %DISTDIR%
xcopy /F /G /H /R /K /Y /S /E lisp %DISTDIR%\lisp\
xcopy /F /G /H /R /K /Y /S /E etc %DISTDIR%\etc\
xcopy /F /G /H /R /K /Y /S /E html %DISTDIR%\html\
xcopy /F /G /H /R /K /Y /S /E reference %DISTDIR%\reference\

cd %DISTDIR%
7za a %DISTROOT%\%ARCHIVE% .
goto :eof

:usage
echo Usage: %0 TAG
goto :eof