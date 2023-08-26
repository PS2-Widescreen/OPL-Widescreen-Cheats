@REM saves time when looking for IDs in the crappyformat AAAA-12345
@echo %1 | @busybox.exe grep -Eo "[a-zA-Z]{4}-[0-9]{5}" | @busybox.exe sed "s/-/_/g" | @busybox.exe sed "s/./&./8"