@echo off
REM Double-click to run the DevOps interview prep tool.
REM Option 1 does everything: All_questions.txt -> Excel -> index.html -> verify -> push.
REM The work happens in DevOps_Prep.ps1.

REM UTF-8 console so arrows, dashes and checkmarks print correctly.
chcp 65001 >nul

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0DevOps_Prep.ps1"
