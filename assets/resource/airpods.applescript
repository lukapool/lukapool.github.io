-- 功能说明: 快速在 Macbook 上切换到 AirPods
-- 修改: Luka 2018/2/19
-- 修改: Luka 2018/2/22; 防止 AirPods 没开机时无限尝试连接；
tell application "System Events" to tell process "SystemUIServer"
	set maxTryCount to 5
	set flag to 0
	set tryCount to 0
	set bt to (first menu bar item whose description is "bluetooth") of menu bar 1
	repeat until flag = 1
		click bt
		tell (first menu item whose title contains "AirPods") of menu of bt
			click
			tell menu 1
				if exists menu item "Connect" then -- 耳机没连接
					click menu item "Connect"
					set tryCount to tryCount + 1
					if tryCount = maxTryCount + 1 then
						exit repeat
					end if
					log "开始第" & tryCount & "次连接..."
					delay 6
				else if exists menu item "Disconnect" then
					key code 53 -- 为了关闭下拉菜单栏
					set flag to 1
					log "可能已经连上 AirPods 了..."
				else
					log "还在连接中..."
					key code 53
					delay 1
				end if
			end tell
		end tell
	end repeat
	if flag = 1 then
		return "成功连上 AirPods!!"
	else
		return "你没打开 AirPods!!"
	end if
end tell

