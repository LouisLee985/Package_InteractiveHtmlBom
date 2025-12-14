@echo off
setlocal enabledelayedexpansion

:: 检查管理员权限
:: net file 1>NUL 2>NUL || powershell Start-Process -FilePath cmd.exe -ArgumentList """/c pushd %~dp0 && %~s0 %*""" -Verb RunAs -WindowStyle Hidden

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ====================== 配置区 ======================
set "EXE_FILE=generate_interactive_bom.exe"
set "MENU_NAME=open_with_interactivebom"
set "MENU_TEXT=InteractiveBom"
:: ====================================================

set "EXE_PATH=%~dp0%EXE_FILE%"

:: 主键路径：HKEY_CLASSES_ROOT\SystemFileAssociations\.json\shell
set "BASE_KEY=HKEY_CLASSES_ROOT\SystemFileAssociations\.json"
set "MENU_KEY=%BASE_KEY%\shell\%MENU_NAME%"

:: 1. 创建 shell 和菜单项键（如果不存在）
REG ADD "%BASE_KEY%\shell" /f >nul 2>&1
REG ADD "%MENU_KEY%" /ve /t REG_SZ /d "%MENU_TEXT%" /f >nul

:: 2. 添加图标
REG ADD "%MENU_KEY%" /v "Icon" /t REG_SZ /d "\"%EXE_PATH%\",0" /f >nul

:: 3. Shift+右键显示
REG ADD "%MENU_KEY%" /v "Extended" /t REG_SZ /d "" /f >nul

:: 4. 设置命令
set "COMMAND_KEY=%MENU_KEY%\command"
REG ADD "%COMMAND_KEY%" /ve /t REG_SZ /d "\"%EXE_PATH%\" \"%%1\"" /f >nul

echo.
echo ========================================
echo    .json 文件Shift+右键 即可看到：
echo   → %MENU_TEXT%
echo ========================================
echo.
pause
del "%~dp0REG_HKCR_BOM.bat"
endlocal
