#Requires AutoHotkey v2.0
/*
    AutoHotkey 2.0 脚本
    作者：icexmoon@qq.com
    描述：电脑外接多个显示器时，可以最小化鼠标所在显示器的当前单个窗口
    版本：v1.0
*/
#+d:: ; 快捷键 win+shift+D
{
    try {
        ; 获取鼠标当前位置的窗口句柄
        MouseGetPos &MouseX, &MouseY, &WinID
        if (WinID = 0)  ; 没有有效窗口时退出
            return

        ; 最小化目标窗口（支持多显示器环境）
        WinMinimize "ahk_id " WinID
    }
    catch Error as e {
        MsgBox "操作失败: " e.Message
    }
}