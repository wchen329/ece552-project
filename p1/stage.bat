@echo off
echo This will put all project files in the same top-level folder called "p1_stage"
pause
FOR /R %%f IN (*.v) DO copy %%f ..\p1_all
