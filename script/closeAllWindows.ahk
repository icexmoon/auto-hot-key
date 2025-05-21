#Requires AutoHotkey v2.0
/*
    AutoHotkey 2.0 脚本
    作者：icexmoon@qq.com
    描述：电脑外接多个显示器时，可以最小化鼠标所在显示器的所有已打开窗口
    版本：v1.0
*/
#d:: ; 覆盖系统默认的 win+D 热键，可以按照喜好替换
; 获取鼠标所在显示器的坐标范围
{
    mouseX := 0, mouseY := 0
    MouseGetPos(&mouseX, &mouseY)
    activeMonitor := GetMonitorAtCoords(mouseX, mouseY)
    ; MsgBox activeMonitor
    ; 获取所有窗口列表
    windows := WinGetList()

    ; 遍历窗口并最小化符合条件的窗口
    for hWnd in windows {
        try {
            if WinExist("ahk_id " hWnd)
                && IsWindowOnMonitor(hWnd, activeMonitor)
                && !WinActive("Program Manager")
            {
                ; 如果窗口是辅助监视器的任务栏，不能最小化
                className := WinGetClass(hWnd)
                if (className != "Shell_SecondaryTrayWnd") {
                    WinMinimize("ahk_id " hWnd)
                }
            }
        }
    }
}

; 判断窗口是否在指定显示器内
IsWindowOnMonitor(hWnd, monitorNum) {
    title := WinGetTitle("ahk_id " hWnd)
    className := WinGetClass(hWnd)
    exePath := WinGetProcessPath(hWnd)
    ; 获取窗口位置
    WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)
    winCenterX := winX + winW // 2
    winCenterY := winY + winH // 2

    ; 获取显示器边界
    MonitorGet(monitorNum, &left, &top, &right, &bottom)
    isInCurrentWindow := (winCenterX >= left) && (winCenterX <= right)
        && (winCenterY >= top) && (winCenterY <= bottom)
    return isInCurrentWindow
}

; 根据坐标获取显示器编号
GetMonitorAtCoords(x, y) {
    count := MonitorGetCount() ;
    Loop count {
        MonitorGet(A_Index, &L, &T, &R, &B) ;
        if (x >= L && x <= R && y >= T && y <= B)
            return A_Index
    }
    return 1 ; 默认返回主显示器
}