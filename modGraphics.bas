Attribute VB_Name = "modGraphics"
Option Explicit
'modulo: modGraphics
'funciones y procedimientos para manipular estructras tipo array
'René Gonzalo Barañado Quiñones (02/11/2021)

Private Sub mainGraphics()
    'Datos
    Dim xList() As Variant
    Dim xListA() As Variant
    Dim xArray() As Double
    ReDim xArray(4, 6)
    xArray(0, 0) = -6.99:  xArray(0, 1) = -8.65:  xArray(0, 2) = 2.3:    xArray(0, 3) = -10.07: xArray(0, 4) = 2.86:   xArray(0, 5) = -9.63:  xArray(0, 6) = -2.76
    xArray(1, 0) = 4.38:   xArray(1, 1) = -8.96:  xArray(1, 2) = 9.66:   xArray(1, 3) = -7.81:  xArray(1, 4) = -6:     xArray(1, 5) = -9.91:  xArray(1, 6) = -1.83
    xArray(2, 0) = -1.01:  xArray(2, 1) = -7.05:  xArray(2, 2) = -9.55:  xArray(2, 3) = -2.93:  xArray(2, 4) = 10.34:  xArray(2, 5) = 5.33:   xArray(2, 6) = -3
    xArray(3, 0) = 7.39:   xArray(3, 1) = -9.95:  xArray(3, 2) = 10.2:   xArray(3, 3) = 9.06:   xArray(3, 4) = 0.27:   xArray(3, 5) = 3.48:   xArray(3, 6) = -5.96
    xArray(4, 0) = -6.47:  xArray(4, 1) = 9.82:   xArray(4, 2) = 9.56:   xArray(4, 3) = -2.56:  xArray(4, 4) = 6.36:   xArray(4, 5) = 5.13:   xArray(4, 6) = -8.87
    xList = Array(-6.99, -8.65, 2.3, -10.07, 2.86, -9.63, -2.76)
    xListA = Array(Array(-6.99, -8.65, 2.3, -10.07, 2.86, -9.63, -2.76), _
                   Array(4.38, -8.96, 9.66, 7.81, -6, 9.91, -1.83), _
                   Array(-1.01, -7.05, -9.55, 2.93, 10.34, 5.33, -3), _
                   Array(7.39, -9.95, 10.2, 9.06, 0.27, 3.48, -5.96), _
                   Array(-6.47, 9.82, 9.56, -2.56, 6.36, 5.13, -8.87))
    'Procedimientos
    Debug.Print ("ViewMatrixS")
    Call ViewMatrixS(xArray)                'Para ver en la ventana inmediato
    Debug.Print ("ViewMatrixD")
    Call ViewMatrixD(xListA)                'Para ver en la ventana inmediato
    Debug.Print ("ViewVector")
    Call ViewVector(xList)                  'Para ver en la ventana inmediato
End Sub
Public Sub ViewMatrixS(ByVal xArry As Variant)
    'ViewMatrixS
    'Muestra en la terminal los valores de la matriz "xArry"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim xStr As String
    xRow = UBound(xArry, 1)
    xCol = UBound(xArry, 2)
    xStr = ""
    For iloop = 0 To xRow
        For jloop = 0 To xCol
            xStr = xStr & Round(xArry(iloop, jloop), 3) & vbTab
        Next jloop
        xStr = xStr & vbNewLine
    Next iloop
    Debug.Print (xStr)
End Sub
Public Sub ViewMatrixD(ByVal xListA As Variant)
    'ViewMatrixD
    'Muestra en la terminal los valores de la lista "xlist"
    'la lista esta conformado por vectores del tipo Array
    Dim xRow As Byte
    Dim xCol As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim xStr As String
    xRow = UBound(xListA)
    xCol = UBound(xListA(0))
    xStr = ""
    For iloop = 0 To xRow
        For jloop = 0 To xCol
            xStr = xStr & Round(xListA(iloop)(jloop), 3) & vbTab
        Next jloop
        xStr = xStr & vbNewLine
    Next iloop
    Debug.Print (xStr)
End Sub
Public Sub ViewVector(ByVal xList As Variant)
    'viewVector
    'muestra en la terminal los valores de la lista "xlist"
    Dim xRow As Byte
    Dim iloop As Byte
    xRow = UBound(xList)
    For iloop = 0 To xRow
        Debug.Print (xList(iloop))
    Next iloop
End Sub
