@echo off
setlocal enabledelayedexpansion

REM === CONFIGURABLE ===
set "QUEUE_LIST=DEV.QUEUE.1,DEV.QUEUE.2"
set "QMGR_NAME=QM1"
set "DELIMITER=,"
set "TEMPLATE=verify_queue_config.mqsc.template"
set "SCRIPT_DIR=scripts"
set "LOG_DIR=output"
set "TIMESTAMP=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "SUMMARY_FILE=%LOG_DIR%\summary_report_%TIMESTAMP%.log"

REM === Create directories ===
if not exist "%SCRIPT_DIR%" mkdir "%SCRIPT_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM === Clear summary file ===
echo IBM MQ Queue Configuration Summary Report > "%SUMMARY_FILE%"
echo Queue Manager: %QMGR_NAME% >> "%SUMMARY_FILE%"
echo Generated: %DATE% %TIME% >> "%SUMMARY_FILE%"
echo ------------------------------------------ >> "%SUMMARY_FILE%"

REM === Parse queue list ===
for %%Q in (%QUEUE_LIST%) do (
    set "QUEUE=%%Q"
    set "SCRIPT_FILE=%SCRIPT_DIR%\verify_%%Q.mqsc"
    set "LOG_FILE=%LOG_DIR%\%%Q_mq_config_check_%TIMESTAMP%.log"

    echo.
    echo 🔍 Verifying queue: %%Q

    powershell -Command "Get-Content '%TEMPLATE%' | ForEach-Object { $_ -replace '\{QUEUE_NAME\}', '%%Q' } | Set-Content '%SCRIPT_DIR%\verify_%%Q.mqsc'"

    docker exec -i ibm-mq runmqsc %QMGR_NAME% < "%SCRIPT_FILE%" > "%LOG_FILE%"

    (
        echo.
        echo Queue: %%Q
        echo ----------------------------------
    ) >> "%SUMMARY_FILE%"

    powershell -Command "Select-String -Path '%LOG_FILE%' -Pattern 'BOQNAME\(\)|BOTHRESH\(0\)|DEFPSIST\(NO\)|MAXDEPTH\(0\)|MAXMSGL\(0\)|DEADQ\(\)' | ForEach-Object { '⚠️  Potential issue: ' + $_.Line }" >> "%SUMMARY_FILE%"

    echo ✅ Full log: %LOG_FILE% >> "%SUMMARY_FILE%"
)

echo.
echo ✅ All queue checks completed.
echo 📄 Summary report saved to: %SUMMARY_FILE%
