# Pasteboard with iCloud

macOS与iOS的Handoff基本上是一个佛系功能，他们心情好的时候就复制一下，心情不好的时候罢工（90%几率），所以一直找一个稳定的方案做替代，直到我最近发现了一个“iCloud剪贴板”捷径，在手机端操作十分流畅，但是在电脑端使用起来颇为费劲，遂花了一晚上时间赶制了一个简陋的mac端支持脚本。

配置步骤

- 在iPhone中下载`Shortcuts`，然后在`Safari`打开[该网址](https://sharecuts.cn/shortcut/2409)并安装该捷径，感谢`失落无意义`提供的捷径；
- 在mac中安装`Hammerspoon`，一个很酷且极其容易上手的macOS上的自动化程序，其官网在[这里](https://www.hammerspoon.org/)；
- 安装完毕后点击`Hammerspoon > Open Config`会自动打开一个`init.lua`文件，如图
  ![image-20190820213122635](http://res.niuxuewei.com/2019-08-20-133123.png)
- 将`main.lua`的全部内容复制粘贴到`init.lua`，但是需要手动根据你的实际情况初始化几个参数：

  - PASTEBOARD_MENUBAR_ICON：必填，指定该脚本的icon路径（需要完整路径），推荐使用`pasteboard-normal.pdf`；
  - PASTEBOARD_FILE_PATH：必填，该捷径自动创建的文件路径，正常情况下应该是`/Users/<USERNAME>/Library/Mobile Documents/iCloud~is~workflow~my~workflows/Documents/Clipboard/Clipboard.txt`；
  - PASTEBOARD_SEPARATOR：分隔符，建议默认不要改动；
  - PASTEBOARD_ESCAPED_SEPARATOR：转义后的分隔符，建议默认不要改动。
- 配置完成后，点击`Hammerspoon > Reload Config`重新载入配置文件；
- Enjoy it.