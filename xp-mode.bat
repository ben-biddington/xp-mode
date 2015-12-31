@echo off

if not exist %HOME%\.pairs (
  echo Config file %HOME%\.pairs is missing
  exit /b
)

set lines=1

if [%1] == [] (
   call :count-lines
   exit /b
) else (
   call :set-author %1
   exit /b
)

:count-lines (
  setlocal
  set lines=0
  for /f %%i in ('type %HOME%\.pairs^|find "" /v /c') do set lines=%%i
  echo You have the following %lines% pairs in file %HOME%\.pairs

  for /f "tokens=* delims=" %%i in (%HOME%\.pairs) do echo %%i
  endlocal
  exit /b
)

:trim (
  setlocal enabledelayedexpansion
  set args=%*
  for /f "tokens=1*" %%a in ("!args!") do endlocal & set %1=%%b
  exit /b
)

:set-author (
  setlocal enabledelayedexpansion
  set line=%1
  set /a line-=1

  for /f "usebackq delims=" %%l in (`more +%line% %HOME%\.pairs`) do (
    set pair=%%l
    goto :jump
  )
  :jump

  for /f "tokens=1 delims=;" %%p in ("%pair%") do (
    set value=%%p
    call :trim result !value!
    set author_name=!result!
  )

  for /f "tokens=2 delims=;" %%p in ("%pair%") do (
    set value=%%p
    call :trim result !value!
    set author_email=!result!
  )

  echo setting GIT_AUTHOR_NAME=%author_name%
  echo setting GIT_AUTHOR_EMAIL=%author_email%

  endlocal & set author_name=%author_name% & set author_email=%author_email%
)

set GIT_AUTHOR_NAME=%author_name%
set GIT_AUTHOR_EMAIL=%author_email%

echo Author is now %GIT_AUTHOR_NAME%;%GIT_AUTHOR_EMAIL%
setlocal
for /f "usebackq tokens=*" %%a in (`git config user.name`) do echo Committer name is %%a
for /f "usebackq tokens=*" %%a in (`git config user.email`) do echo Committer email is %%a
endlocal