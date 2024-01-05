@echo off
SETLOCAL EnableDelayedExpansion
chcp 65001 > nul
REM コマンドの出力を変数に格納し、現在の状態を表示
FOR /F "tokens=* USEBACKQ" %%F IN (`Powershell -Command "(Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State"`) DO (
    SET state=%%F
)

REM 状態が0または1以外の場合、管理者権限での実行を促す
IF NOT "!state!"=="Disabled" (
    IF NOT "!state!"=="Enabled" (
        echo 管理者権限で実行してください。
        GOTO END
    )
)

echo VirtualMachinePlatformの状態: !state!

REM ユーザー入力のプロンプト
SET /P action="VirtualMachinePlatformの状態を変更します (0=何もしない, 1=状態を変更): "

REM ユーザー入力が1の場合のみ処理を実行
IF "!action!"=="1" (
    REM StateがDisabledの場合に、機能を有効化
    IF "!state!"=="Disabled" (
        Powershell -Command "Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform"
        echo VirtualMachinePlatformを有効化しました
    ) ELSE IF "!state!"=="Enabled" (
        Powershell -Command "Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform"
        echo VirtualMachinePlatformを無効化しました
    )
) ELSE (
    echo 何も処理は行われませんでした。
)
:END
ENDLOCAL
pause