@echo off
REM set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%time:~0,2%%time:~3,2%%time:~6,2%
set FILENAME=DirTree_%TIMESTAMP%.txt

echo --------------------------------------------------
echo 正在生成当前目录的完整目录树（包含所有文件和子目录）...
echo.

REM /F: 显示所有文件夹和文件名
REM /A: 使用 ASCII 字符，避免编码显示问题

tree /F /A > "%FILENAME%"

echo.
echo --------------------------------------------------
echo ? 完整目录树已生成!
echo ?? 文件名: "%FILENAME%"
echo --------------------------------------------------

exit