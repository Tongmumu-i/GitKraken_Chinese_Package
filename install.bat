@echo off
setlocal enabledelayedexpansion

@rem 获取汉化文件文件路径
set "strings_file=strings.json"
set "app_path=%localappdata%\gitkraken"

@rem file文件路径不能为空
if not exist %strings_file% goto no_strings_file
if not exist %app_path% goto no_app_path

echo "请选择需要汉化的 GitKraken 版本号:"
echo.

set count=1
for /d %%i in (%app_path%\app-*) do (
    set "folder[!count!]=%%~nxi"
    echo [!count!] %%~nxi
    set /a count+=1
)

echo.
<nul set /p "=输入对应的序号[?],按回车确认: "
set /p "version="

@REM 校验输入值是不是正常的范围
set /a serial=%count%-1
if %version% gtr %serial% (
    echo.
    echo 警告：输入的序号 [%version%] 异常，不在选项 [1 - %serial%] 范围内！
    pause
    exit
)

echo.
echo 正在进行 GitKraken !folder[%version%]! 汉化，请稍等。。。

set "app_strfile_path=%app_path%\!folder[%version%]!\resources\app.asar.unpacked\src"
set "new_strfile_name=!folder[%version%]!_%strings_file%"
set "backups=%cd%\backups"
@REM echo 正在备份 GitKraken !folder[%version%]! 版本下的 %strings_file% 文件！
ren %app_strfile_path%\%strings_file% %new_strfile_name%
move /y %app_strfile_path%\%new_strfile_name% %backups% >nul

echo.
echo 已完成备份 %new_strfile_name% 已备份至 %backups% 目录！

copy /y %cd%\%strings_file% %app_strfile_path% >nul

echo.
echo "恭喜 GitKraken !folder[%version%]! 汉化成功!!!"
echo.
echo "3秒后退出..."
ping -n 3 127.1 >nul
exit

:no_strings_file
  echo 警告：当前目录不存在待处理的 %strings_file% 汉化文件！
  pause
exit

:no_app_path
  echo 警告：%app_path% 目录不存在,请检查 Gitkraken 安装路径！
  pause
exit