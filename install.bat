@echo off
setlocal enabledelayedexpansion

@rem ��ȡ�����ļ��ļ�·��
set "strings_file=strings.json"
set "app_path=%localappdata%\gitkraken"

@rem file�ļ�·������Ϊ��
if not exist %strings_file% goto no_strings_file
if not exist %app_path% goto no_app_path

echo "��ѡ����Ҫ������ GitKraken �汾��:"
echo.

set count=1
for /d %%i in (%app_path%\app-*) do (
    set "folder[!count!]=%%~nxi"
    echo [!count!] %%~nxi
    set /a count+=1
)

echo.
<nul set /p "=�����Ӧ�����[?],���س�ȷ��: "
set /p "version="

@REM У������ֵ�ǲ��������ķ�Χ
set /a serial=%count%-1
if %version% gtr %serial% (
    echo.
    echo ���棺�������� [%version%] �쳣������ѡ�� [1 - %serial%] ��Χ�ڣ�
    pause
    exit
)

echo.
echo ���ڽ��� GitKraken !folder[%version%]! ���������Եȡ�����

set "app_strfile_path=%app_path%\!folder[%version%]!\resources\app.asar.unpacked\src"
set "new_strfile_name=!folder[%version%]!_%strings_file%"
set "backups=%cd%\backups"
@REM echo ���ڱ��� GitKraken !folder[%version%]! �汾�µ� %strings_file% �ļ���
ren %app_strfile_path%\%strings_file% %new_strfile_name%
move /y %app_strfile_path%\%new_strfile_name% %backups% >nul

echo.
echo ����ɱ��� %new_strfile_name% �ѱ����� %backups% Ŀ¼��

copy /y %cd%\%strings_file% %app_strfile_path% >nul

echo.
echo "��ϲ GitKraken !folder[%version%]! �����ɹ�!!!"
echo.
echo "3����˳�..."
ping -n 3 127.1 >nul
exit

:no_strings_file
  echo ���棺��ǰĿ¼�����ڴ������ %strings_file% �����ļ���
  pause
exit

:no_app_path
  echo ���棺%app_path% Ŀ¼������,���� Gitkraken ��װ·����
  pause
exit