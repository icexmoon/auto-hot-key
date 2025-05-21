#Requires AutoHotkey v2.0
/*
    AutoHotkey 2.0 脚本
    作者：icexmoon@qq.com
    描述：电脑外接多个显示器时，可以最小化鼠标所在显示器的所有已打开窗口
*/ 
#d::  ; 覆盖系统默认的 win+D 热键，可以按照喜好替换
    {
        MouseGetPos &MouseX, &MouseY
        activeMonitor := GetMonitorAtCoords(MouseX, MouseY)

        DetectHiddenWindows False
        windows := WinGetList()

        for hWnd in windows {
            try {
                if WinExist("ahk_id " hWnd)
                    && WinGetTitle("ahk_id " hWnd) != ""
                && !WinActive("Program Manager")
                && IsWindowOnMonitor(hWnd, activeMonitor)
                {
                    WinMinimize "ahk_id " hWnd
                }
            }
        }
    }

    ; 获取指定坐标所在的显示器序号
    GetMonitorAtCoords(x, y) {
        count := MonitorGetCount()
        loop count {
            MonitorGet(A_Index, &L, &T, &R, &B)
            if (x >= L && x <= R && y >= T && y <= B)
                return A_Index
        }
        return 1
    }

    ; 判断窗口是否在指定显示器上
    IsWindowOnMonitor(hWnd, monitorNum) {
        WinGetPos(&x, &y, &w, &h, "ahk_id " hWnd)
        centerX := x + w//2
        centerY := y + h//2
        return GetMonitorAtCoords(centerX, centerY) == monitorNum
    }