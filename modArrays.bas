Attribute VB_Name = "modArrays"
Option Explicit
'modulo: modArrays
'funciones y procedimientos para manipular estructras tipo array
'René Gonzalo Barañado Quiñones (02/11/2021)

Private Sub mainArrays()
    Dim xArray() As Double
    Dim yArray() As Double
    Dim zArray() As Double
    Dim xList() As Variant
    Dim xListA() As Variant
    Dim xDoubl As Double
    Dim xByte As Byte
    Dim yByte As Byte
    'Datos
    ReDim xArray(4, 6)
    xArray(0, 0) = -6.99:  xArray(0, 1) = -8.65:  xArray(0, 2) = 2.3:    xArray(0, 3) = -10.07: xArray(0, 4) = 2.86:   xArray(0, 5) = -9.63:  xArray(0, 6) = -2.76
    xArray(1, 0) = 4.38:   xArray(1, 1) = -8.96:  xArray(1, 2) = 9.66:   xArray(1, 3) = -7.81:  xArray(1, 4) = -6:     xArray(1, 5) = -9.91:  xArray(1, 6) = -1.83
    xArray(2, 0) = -1.01:  xArray(2, 1) = -7.05:  xArray(2, 2) = -9.55:  xArray(2, 3) = -2.93:  xArray(2, 4) = 10.34:  xArray(2, 5) = 5.33:   xArray(2, 6) = -3
    xArray(3, 0) = 7.39:   xArray(3, 1) = -9.95:  xArray(3, 2) = 10.2:   xArray(3, 3) = 9.06:   xArray(3, 4) = 0.27:   xArray(3, 5) = 3.48:   xArray(3, 6) = -5.96
    xArray(4, 0) = -6.47:  xArray(4, 1) = 9.82:   xArray(4, 2) = 9.56:   xArray(4, 3) = -2.56:  xArray(4, 4) = 6.36:   xArray(4, 5) = 5.13:   xArray(4, 6) = -8.87
    ReDim yArray(4, 6)
    yArray(0, 0) = -60.99:  yArray(0, 1) = -80.65:   yArray(0, 2) = 20.3:    yArray(0, 3) = -100.07: yArray(0, 4) = 20.86:   yArray(0, 5) = -90.63:  yArray(0, 6) = -20.76
    yArray(1, 0) = 40.38:   yArray(1, 1) = -80.96:  yArray(1, 2) = 90.66:   yArray(1, 3) = -70.81:  yArray(1, 4) = -60:     yArray(1, 5) = -90.91:  yArray(1, 6) = -10.83
    yArray(2, 0) = -10.01:  yArray(2, 1) = -70.05:  yArray(2, 2) = -90.55:  yArray(2, 3) = -20.93:  yArray(2, 4) = 100.34:  yArray(2, 5) = 50.33:   yArray(2, 6) = -30
    yArray(3, 0) = 70.39:   yArray(3, 1) = -90.95:  yArray(3, 2) = 100.2:   yArray(3, 3) = 90.06:   yArray(3, 4) = 4.27:    yArray(3, 5) = 30.48:   yArray(3, 6) = -50.96
    yArray(4, 0) = -60.47:  yArray(4, 1) = 90.82:   yArray(4, 2) = 90.56:   yArray(4, 3) = -20.56:  yArray(4, 4) = 60.36:   yArray(4, 5) = 50.13:   yArray(4, 6) = -80.87
    ReDim zArray(6, 3)
    zArray(0, 0) = -60.99:  zArray(0, 1) = -80.65:   zArray(0, 2) = 20.3:    zArray(0, 3) = -100.07
    zArray(1, 0) = 40.38:   zArray(1, 1) = -80.96:  zArray(1, 2) = 90.66:   zArray(1, 3) = -70.81
    zArray(2, 0) = -10.01:  zArray(2, 1) = -70.05:  zArray(2, 2) = -90.55:  zArray(2, 3) = -20.93
    zArray(3, 0) = 70.39:   zArray(3, 1) = -90.95:  zArray(3, 2) = 100.2:   zArray(3, 3) = 90.06
    zArray(4, 0) = -60.47:  zArray(4, 1) = 90.82:   zArray(4, 2) = 90.56:   zArray(4, 3) = -20.56
    zArray(5, 0) = 70.39:   zArray(5, 1) = -90.95:  zArray(5, 2) = 100.2:   zArray(5, 3) = 90.06
    zArray(6, 0) = -60.47:  zArray(6, 1) = 90.82:   zArray(6, 2) = 90.56:   zArray(6, 3) = -20.56
    xList = Array(-6.99, -8.65, 2.3, -10.07, 2.86, -9.63, -2.76)
    xListA = Array(Array(-6.99, -8.65, 2.3, -10.07, 2.86, -9.63, -2.76), _
                   Array(4.38, -8.96, 9.66, 7.81, -6, 9.91, -1.83), _
                   Array(-1.01, -7.05, -9.55, 2.93, 10.34, 5.33, -3), _
                   Array(7.39, -9.95, 10.2, 9.06, 0.27, 3.48, -5.96), _
                   Array(-6.47, 9.82, 9.56, -2.56, 6.36, 5.13, -8.87))
    'funciones
    Debug.Print ("AugmentArrayList")
    Call modGraphics.ViewMatrixS(AugmentArrayList(xArray, xList))               'Para ver en la ventana inmediato
    Debug.Print ("AugmentArrays")
    Call modGraphics.ViewMatrixS(AugmentArrays(xArray, yArray))                 'Para ver en la ventana inmediato
    Debug.Print ("SumMatrix")
    Call modGraphics.ViewMatrixS(SumMatrix(xArray, yArray))                     'Para ver en la ventana inmediato
    Debug.Print ("MultMatrix")
    Call modGraphics.ViewMatrixS(MultMatrix(xArray, zArray))                    'Para ver en la ventana inmediato
    Debug.Print ("Transpose")
    Call modGraphics.ViewMatrixS(Transpose(xArray))                             'Para ver en la ventana inmediato
    Debug.Print ("MultConstRows")
    Call modGraphics.ViewMatrixS(MultConstRows(xArray, xDoubl, xByte))          'Para ver en la ventana inmediato
    Debug.Print ("MultSumRows")
    Call modGraphics.ViewMatrixS(MultSumRows(xArray, xDoubl, xByte, yByte))     'Para ver en la ventana inmediato
    Debug.Print ("ChangeRows")
    Call modGraphics.ViewMatrixS(ChangeRows(xArray, xByte, yByte))              'Para ver en la ventana inmediato
    Debug.Print ("EndColum")
    Call modGraphics.ViewVector(EndColum(xArray))                               'Para ver en la ventana inmediato
    Debug.Print ("ReduceMatrix")
    Call modGraphics.ViewMatrixS(ReduceMatrix(xArray))                          'Para ver en la ventana inmediato
    Debug.Print ("MaxList")
    Debug.Print (MaxList(xList))                                                'Para ver en la ventana inmediato
End Sub
Public Function SumListMatrix(ByVal xListA As Variant) As Variant
    'SumListMatrix
    'suma todas las matrices que se encuentran dentro una lista
    Dim xRow As Byte
    Dim iloop As Byte
    Dim yRow As Byte
    Dim yCol As Byte
    Dim xArray() As Double
    xRow = UBound(xListA)
    yRow = UBound(xListA(0), 1)
    yCol = UBound(xListA(0), 2)
    ReDim xArray(yRow, yCol)
    For iloop = 0 To xRow
        xArray = SumMatrix(xListA(iloop), xArray)
    Next iloop
    SumListMatrix = xArray
End Function
Public Function ReduceMatrix(xArray)
    Dim xRow As Byte
    Dim xCol As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim xByte As Byte
    Dim xDoubl As Double
    Dim yDoubl As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    For jloop = 0 To xRow
        xByte = jloop
        xDoubl = Abs(xArray(jloop, jloop))
        For iloop = jloop + 1 To xRow
            yDoubl = Abs(xArray(iloop, jloop))
            If yDoubl > xDoubl Then
                xByte = iloop
                xDoubl = yDoubl
            End If
        Next iloop
        If xByte <> jloop Then
            xArray = ChangeRows(xArray, xByte, jloop)
        End If
        For iloop = 0 To xRow
            If iloop <> jloop Then
                xArray = MultSumRows(xArray, -xArray(iloop, jloop) / xArray(jloop, jloop), jloop, iloop)
            End If
        Next iloop
    Next jloop
    For iloop = 0 To xRow
        xArray = MultConstRows(xArray, 1 / xArray(iloop, iloop), iloop)
    Next iloop
    ReduceMatrix = xArray
End Function
Public Function EndColum(ByVal xArray As Variant) As Variant
    'EndColum
    'devuelve la ultima columna de la matriz "xArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim iloop As Byte
    Dim xList() As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    ReDim xList(xRow)
    For iloop = 0 To xRow
        xList(iloop) = xArray(iloop, xCol)
    Next iloop
    EndColum = xList
End Function
Public Function ChangeRows(ByVal xArray As Variant, ByVal xByte As Byte, ByVal yByte As Byte) As Variant
    'ChangeRows
    'funcion para cambiar la fila "xByte" con la fila "yBite" de la matriz "xArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim jloop As Byte
    Dim xDoubl As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    For jloop = 0 To xCol
        xDoubl = xArray(xByte, jloop)
        xArray(xByte, jloop) = xArray(yByte, jloop)
        xArray(yByte, jloop) = xDoubl
    Next jloop
    ChangeRows = xArray
End Function
Public Function MultSumRows(ByVal xArray As Variant, ByVal xDoubl As Double, ByVal xByte As Byte, ByVal yByte As Byte) As Variant
    'MultSumRows
    'multplica un valor "xDoubl" a una fila "xByte"
    'y la suma a otra fila "yByte" de una matriz "xArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim jloop As Byte
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    For jloop = 0 To xCol
        xArray(yByte, jloop) = xDoubl * xArray(xByte, jloop) + xArray(yByte, jloop)
    Next jloop
    MultSumRows = xArray
End Function
Public Function MultConstRows(ByVal xArray As Variant, ByVal xDoubl As Double, ByVal xByte As Byte) As Variant
    'MultConstRows
    'multilplica una constante "xDoubl" a la fila "xByte" de la matriz "xArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim jloop As Byte
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    For jloop = 0 To xCol
        xArray(xByte, jloop) = xDoubl * xArray(xByte, jloop)
    Next jloop
    MultConstRows = xArray
End Function
Public Function Transpose(ByVal xArray As Variant) As Variant
    'Transpose
    'funcion para transponer la matriz "xArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim yArray() As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    ReDim yArray(xCol, xRow)
    For iloop = 0 To xRow
        For jloop = 0 To xCol
            yArray(jloop, iloop) = xArray(iloop, jloop)
        Next jloop
    Next iloop
    Transpose = yArray
End Function
Public Function SumMatrix(ByVal xArray As Variant, ByVal yArray As Variant) As Variant
    'SumMatrix
    'suma las matrices "xArray" y "yArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim zArray() As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    ReDim zArray(xRow, xCol)
    For iloop = 0 To xRow
        For jloop = 0 To xCol
            zArray(iloop, jloop) = xArray(iloop, jloop) + yArray(iloop, jloop)
        Next jloop
    Next iloop
    SumMatrix = zArray
End Function
Public Function MultMatrix(ByVal xArray As Variant, ByVal yArray As Variant) As Variant
    'MultMatrix
    'multiplica la matriz "xArray" y la matriz "yArray"
    Dim xRow As Byte
    Dim xCol As Byte
    Dim yCol As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim kLoop As Byte
    Dim zArray() As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(yArray, 2)
    yCol = UBound(xArray, 2)
    ReDim zArray(xRow, xCol)
    For iloop = 0 To xRow
        For jloop = 0 To xCol
            For kLoop = 0 To yCol
                zArray(iloop, jloop) = zArray(iloop, jloop) + yArray(kLoop, jloop) * xArray(iloop, kLoop)
            Next kLoop
        Next jloop
    Next iloop
    MultMatrix = zArray
End Function
Public Function AugmentArrays(ByVal xArray As Variant, ByVal yArray As Variant) As Variant
    'AugmentArrays
    'concatena la matriz "xArray" y la matriz "yArray"
    Dim xRow As Byte
    Dim yRow As Byte
    Dim xCol As Byte
    Dim yCol As Byte
    Dim xByte As Byte
    Dim yByte As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim zArray() As Double
    xRow = UBound(xArray, 1)
    yRow = UBound(yArray, 1)
    xCol = UBound(xArray, 2)
    yCol = UBound(yArray, 2)
    xByte = Max(xRow, yRow)
    yByte = xCol + yCol + 1
    ReDim zArray(xByte, yByte)
    For iloop = 0 To xByte
        For jloop = 0 To yByte
            If (jloop <= xCol) And (iloop <= xRow) Then
                zArray(iloop, jloop) = xArray(iloop, jloop)
                ElseIf (jloop > xCol) And (iloop <= yRow) Then
                zArray(iloop, jloop) = yArray(iloop, jloop - xCol - 1)
            End If
        Next jloop
    Next iloop
    AugmentArrays = zArray
End Function
Public Function AugmentArrayList(ByVal xArray As Variant, ByVal xList As Variant) As Variant
    'AugmentArrayList
    'concatena la matriz "xArray" y el vector "xList"
    Dim xRow As Byte
    Dim yRow As Byte
    Dim xCol As Byte
    Dim yCol As Byte
    Dim xByte As Byte
    Dim yByte As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim zArray() As Double
    xRow = UBound(xArray, 1)
    xCol = UBound(xArray, 2)
    yRow = UBound(xList)
    xByte = Max(xRow, yRow)
    yByte = xCol + 1
    ReDim zArray(xByte, yByte)
    For iloop = 0 To xByte
        For jloop = 0 To yByte
            If (jloop <= xCol) And (iloop <= xRow) Then
                zArray(iloop, jloop) = xArray(iloop, jloop)
                ElseIf (jloop > xCol) And (iloop <= yRow) Then
                zArray(iloop, jloop) = xList(iloop)
            End If
        Next jloop
    Next iloop
    AugmentArrayList = zArray
End Function
Public Function MaxList(ByVal xList As Variant) As Double
    'MaxList
    'devuelve el maximo valor de un vector
    Dim iloop As Byte
    Dim xDoubl As Double
    xDoubl = xList(0)
    For iloop = 1 To UBound(xList)
        If xList(iloop) > xDoubl Then xDoubl = xList(iloop)
    Next iloop
    MaxList = xDoubl
End Function
