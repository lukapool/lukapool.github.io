---
type: post
title: 使用 AppleScript 连接你的 AirPods
tags: [效率, AppleScript, Workflows]
---

### 引言
	个人觉得 AirPods 是一款十分出色的无线蓝牙耳机，但是我在使用该耳机的过程中仍然遇到某些问题。耳机在 iPhone 和 MacBook 相互切换的过程中经常遇到切换不成功或者切换时间长的情况，例如我想把 AirPods 的连接切换到 Macbook 上，需要点击电脑菜单栏上的蓝牙图标（需在蓝牙设置中设置才会显示）里面的 AirPods 子菜单中的 Connect 选项，AirPods 还不能保证点击一次就能成功连上。如果不成功，还要再操作一次。我曾经试过按四次 Connect 才成功切换 (T_T)。于是我在网上搜索了一下解决的方法，最后决定使用 AppleScript 帮助我完成连接耳机的繁琐操作。AppleScript 是一个好东西，功能十分强大。这里使用了 AppleScript 模拟用户点击菜单栏的功能。

### 代码
```applescript
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
```
[[下载代码]]({{ site.baseurl }}/assets/resource/airpods.applescript)
### 注意点
- 如果你的系统是中文环境，需要把 **"Connect"** 替换成中文，具体替换成什么自己看下菜单栏里面的选项名字。

### 使用方法
- 命令行方式执行：将代码保存在一个文件中，命名为*airpods.applescript*，在命令行中输入
```console
osascript /example/path/to/airpods.applescript
```
执行脚本。
- 使用 Alfred 新建一个 Workflow，把代码输入并设置触发 Workflow 的关键词。为了方便大家，我提供了用于英文 macOS 系统环境的 Workflow [下载链接]({{ site.baseurl }}/assets/resource/AirPods.alfredworkflow)，在 Alfred 中输入 airpods 关键词就能使用。配置使用过程如下图所示。
![配置Workflow]({{ site.baseurl }}/assets/img/1-1.png)
![配置关键词]({{ site.baseurl }}/assets/img/1-0.png)
![配置 AppleScript 脚本]({{ site.baseurl }}/assets/img/1-2.png)
![使用方法]({{ site.baseurl }}/assets/img/1-3.png)

### 总结
AppleScript 本身功能强大，结合 Alfred 使用将更能发挥出其优势。**AppleScipt + Alfred** 的组合将大大提高我们的工作效率。如果大家对于这篇博文有什么问题或意见，可以发邮件与我交流。

