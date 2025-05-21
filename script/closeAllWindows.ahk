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
    ; 白名单，在这个名单中的应用窗体不会被关闭，如果一些特殊的窗体最小化，会导致 bug，比如资源管理器的任务栏或者小红车
    global whiteList := [
        NewWhiteWindow("Shell_SecondaryTrayWnd", ""), ; 辅助屏幕任务栏
        NewWhiteWindow("hell_TrayWnd", ""), ; 主屏幕任务栏
        NewWhiteWindow("workerW", ""),
        NewWhiteWindow("PseudoConsoleWindow", "") ; powershell
    ]
    ; 设置坐标模式为屏幕绝对坐标（避免窗口干扰）[2,4](@ref)
    CoordMode "Mouse", "Screen"
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
                ; 如果窗口在白名单中，不最小化
                ; className := WinGetClass(hWnd)
                if (!IsInWhiteWIndows(hWnd)) {
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

; 判断窗口是不是在白名单中
IsInWhiteWIndows(hWnd) {
    className := WinGetClass(hWnd)
    exePath := WinGetProcessPath(hWnd)
    for k, v in whiteList {
        ; 如果白名单应用的类名和路径都设置了，要都匹配才能算属于白名单
        if (v.className != '' && v.path != '') {
            if (v.className = className && v.path = exePath) {
                return true
            }
            else {
                continue
            }
        }
        ; 类名或路径有缺省，只需要匹配到类名或路径
        if (v.className != '' && className = v.className) {
            return true
        }
        if (v.path != '' && v.path = exePath) {
            return true
        }
        continue
    }
}

; 自定义遍历函数
HasValue(haystack, needle) {
    if !IsObject(haystack)  ; 非数组直接返回 false
        return false
    for k, v in haystack
        if (v = needle)    ; 不区分大小写比较
            return true
    return false
}

; 返回一个自定义窗体对象，用于白名单
NewWhiteWindow(className, path) {
    return { className: className, path: path }
}