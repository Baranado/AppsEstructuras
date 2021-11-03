Attribute VB_Name = "modMathematics"
Option Explicit
'modulo: modMathematics
'funciones y procedimientos matematicos
'René Gonzalo Barañado Quiñones (02/11/2021)

Private Sub mainMathematics()
    Dim xDoubl As Double
    Dim yDoubl As Double
    xDoubl = 45.388
    yDoubl = 99.25
    Debug.Print ("Max")
    Debug.Print (Max(xDoubl, yDoubl))           'Para ver en la ventana inmediato
    Debug.Print ("Min")
    Debug.Print (Min(xDoubl, yDoubl))           'Para ver en la ventana inmediato
End Sub
Public Function Min(ByVal xDoubl As Double, ByVal yDoubl As Double) As Double
    'Min
    'devuelve el maximo valor de dos datos
    If xDoubl < yDoubl Then
        Min = xDoubl
        Else
        Min = yDoubl
    End If
End Function
Public Function Max(ByVal xDoubl As Double, ByVal yDoubl As Double) As Double
    'Max
    'devuelve el maximo valor de dos datos
    If xDoubl > yDoubl Then
        Max = xDoubl
        Else
        Max = yDoubl
    End If
End Function
