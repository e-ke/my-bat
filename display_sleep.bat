rem "設定>システム>電源とバッテリー>電源>画面とスリープ" の設定をするバッチファイル

@echo off
chcp 65001 > nul
set /p monitor_minutes=画面の電源を切るまでの時間（分）: 
set /p sleep_minutes=スリープ状態にするまでの時間（分）: 

rem プライマリ電源スキームを取得
for /f "tokens=4" %%a in ('powercfg -getactivescheme') do set scheme=%%a

rem ディスプレイをオフにするまでの時間を設定
powercfg -change -monitor-timeout-ac %monitor_minutes%
powercfg -change -monitor-timeout-dc %monitor_minutes%

rem スリープ状態までの時間を設定
powercfg -change -standby-timeout-ac %sleep_minutes%
powercfg -change -standby-timeout-dc %sleep_minutes%

echo %monitor_minutes% 分後にオフになり、%sleep_minutes% 分後にスリープ状態になります。
pause
