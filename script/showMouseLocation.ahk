#Requires AutoHotkey v2.0

; 设置坐标模式为屏幕绝对坐标（避免窗口干扰）[2,4](@ref)
CoordMode "Mouse", "Screen"

; 全局状态标记
global isActive := false

; 热键 Ctrl+Alt+T 切换显示状态
^!T:: {
    global isActive
    isActive := !isActive
    if (isActive) {
        SetTimer UpdatePosition, 100  ; 每100ms刷新坐标
    } else {
        SetTimer UpdatePosition, 0    ; 停止刷新
        ToolTip  ; 清除提示框
    }
}

; 坐标更新函数
UpdatePosition() {
    MouseGetPos &x, &y
    ToolTip "X: " x "`nY: " y, 10, 10  ; 在屏幕左上角显示坐标[1](@ref)
}