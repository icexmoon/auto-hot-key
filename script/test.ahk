#Requires AutoHotkey v2.0
;测试用脚本
#+d:: ; 快捷键 win+shift+D
    {
        ; 打印当前鼠标所在坐标
        MouseGetPos(&mouseX, &mouseY)
        ; 打印所有显示器的边界
        count := MonitorGetCount() ; ✅ 正确调用
        Loop count {
            MonitorGet(A_Index, &L, &T, &R, &B) ; ✅ 正确传递变量引用
            MsgBox "Left: " L "Top" T "Right" R "Bottom" B
        }
    }
