Attribute VB_Name = "AnalisisEstructural"
Const convforce = 0.45359237
Const convlength = 0.3048
Public unidades As Byte
Public lbf As Double
Public ft As Double
Public pcf As Double
Public psi As Double
Public nudos() As Variant
Public barras() As Variant
Public secciones() As Variant
Public paneles() As Variant
Public losas() As Variant
Public HoAo() As Variant
Public datesupport() As Variant
Public cosenos() As Variant
Public longitudes() As Double
Public propSeccion() As Variant
Public k1() As Variant
Public fisicMat() As Variant
Public restriccion() As Variant
Public tiporestriccion() As Variant
Public CG() As Variant
Public AC() As Variant
Public A0() As Byte
Public ListTR() As Variant
Public TR(11, 11) As Double
Public matrizRigidez() As Variant
Public kCG As Byte
Public VC() As Byte
Public Fuerza() As Variant
Sub main()
    unidades = 1
    Call units(unidades)
    Call Datos
    Call propertieHoAo(HoAo)
    Call propsect
    Call lengcos
    Call IndicesCompatibilidad
    Call transformada
    Call rigideceslocales
    Call ensamblarMatriz
    resul = SumaMatriz(matrizRigidez(0), matrizRigidez(1))
    matrizAumentada = augmentArrayList(resul, Fuerza)
    desplazamientos = UltimaColumn(ReducirMatriz(matrizAumentada))
    Call viewvector(desplazamientos)

End Sub
Function UltimaColumn(Matriz)
    fila = UBound(Matriz, 1)
    colum = UBound(Matriz, 2)
    Dim aux()
    ReDim aux(fila)
    For iloop = 0 To fila
        aux(iloop) = Matriz(iloop, colum)
    Next iloop
    UltimaColumn = aux
End Function
Sub Datos()
    ReDim HoAo(1)
    HoAo(0) = Array(0.281227831855664, 2.402769506094E-06, 0.2)
    HoAo(1) = Array(0.21, 0.00000232, 0.2)
    ReDim secciones(1)
    secciones(0) = Array(20, 30, 1)
    secciones(1) = Array(25, 45, 0)
    '    ReDim losas(0)
    '    losas(0) = Array(15, 1)
    ReDim nudos(2)
    nudos(0) = Array(0, 0, 0)
    nudos(1) = Array(300, 400, 200)
    nudos(2) = Array(500, 200, 100)
    '    nudos(3) = Array(600, 500, 0)
    '    nudos(4) = Array(0, 0, 400)
    '    nudos(5) = Array(6, 0, 400)
    '    nudos(6) = Array(0, 500, 400)
    '    ReDim Preserve nudos(7)             'permite aumentar datos
    '    nudos(7) = Array(600, 500, 400)
    ReDim barras(1)
    barras(0) = Array(0, 1, 1)
    barras(1) = Array(2, 1, 0)
    '    barras(2) = Array(3, 7, 1)
    '    barras(3) = Array(4, 8, 1)
    '    barras(4) = Array(5, 6, 2)
    '    barras(5) = Array(7, 8, 2)
    '    barras(6) = Array(5, 7, 2)
    '    ReDim Preserve barras(7)            'permite aumentar datos
    '    barras(7) = Array(6, 8, 2)
    restriccion = Array(0, 2)
    tiporestriccion = Array(Array(1, 1, 1, 1, 1, 1), _
    Array(0, 0, 1, 0, 0, 0))
    '    ReDim paneles(0, 2)
    '    paneles(0, 0) = Array(5, 6, 7, 8)   'nudos del panel
    '    paneles(0, 1) = 1                   'espesor y material tickness
    'datesupport = Array(Array(1, 1, 1, 1, 1, 1), Array(1, 1, 1, 0, 0, 0), Array(0, 0, 1, 0, 0, 0))
    Fuerza = Array(10, 20, 30, 40, 50, 60, 0, 0, 0, 0)
End Sub
Sub cambiarfilas(ByRef Matriz, ByVal filai, ByVal filaj)
    Dim filas As Byte
    filas = UBound(Matriz, 1)
    Dim columnas As Byte
    columnas = UBound(Matriz, 2)
    For jloop = 0 To columnas
        aux = Matriz(filai, jloop)
        Matriz(filai, jloop) = Matriz(filaj, jloop)
        Matriz(filaj, jloop) = aux
    Next jloop
End Sub
Sub multsumfilas(ByRef Matriz, ByVal valor, ByVal filai, ByVal filaj)
    Dim filas As Byte
    filas = UBound(Matriz, 1)
    Dim columnas As Byte
    columnas = UBound(Matriz, 2)
    For jloop = 0 To columnas
        'aux = Matriz(filai, jloop)
        Matriz(filaj, jloop) = valor * Matriz(filai, jloop) + Matriz(filaj, jloop)
    Next jloop
End Sub
Sub multConstfilas(ByRef Matriz, ByVal valor, ByVal filai)
    Dim filas As Byte
    filas = UBound(Matriz, 1)
    Dim columnas As Byte
    columnas = UBound(Matriz, 2)
    For jloop = 0 To columnas
        Matriz(filai, jloop) = valor * Matriz(filai, jloop)
    Next jloop
End Sub
Sub matrices()
    Dim matrizA() As Double
    ReDim matrizA(4, 6)
    matrizA(0, 0) = -6.99:  matrizA(0, 1) = -8.65:  matrizA(0, 2) = 2.3:    matrizA(0, 3) = -10.07: matrizA(0, 4) = 2.86:   matrizA(0, 5) = -9.63:  matrizA(0, 6) = -2.76
    matrizA(1, 0) = 4.38:   matrizA(1, 1) = -8.96:  matrizA(1, 2) = 9.66:   matrizA(1, 3) = -7.81:  matrizA(1, 4) = -6:     matrizA(1, 5) = -9.91:  matrizA(1, 6) = -1.83
    matrizA(2, 0) = -1.01:  matrizA(2, 1) = -7.05:  matrizA(2, 2) = -9.55:  matrizA(2, 3) = -2.93:  matrizA(2, 4) = 10.34:  matrizA(2, 5) = 5.33:   matrizA(2, 6) = -3
    matrizA(3, 0) = 7.39:   matrizA(3, 1) = -9.95:  matrizA(3, 2) = 10.2:   matrizA(3, 3) = 9.06:   matrizA(3, 4) = 0.27:   matrizA(3, 5) = 3.48:   matrizA(3, 6) = -5.96
    matrizA(4, 0) = -6.47:  matrizA(4, 1) = 9.82:   matrizA(4, 2) = 9.56:   matrizA(4, 3) = -2.56:  matrizA(4, 4) = 6.36:   matrizA(4, 5) = 5.13:   matrizA(4, 6) = -8.87
    Dim matrizB() As Double
    ReDim matrizB(4, 4)
    matrizB(0, 0) = -6.99:  matrizB(0, 1) = -8.65:  matrizB(0, 2) = 2.3:    matrizB(0, 3) = -10.07: matrizB(0, 4) = 2.86
    matrizB(1, 0) = 4.38:   matrizB(1, 1) = -8.96:  matrizB(1, 2) = 9.66:   matrizB(1, 3) = -7.81:  matrizB(1, 4) = -6
    matrizB(2, 0) = -1.01:  matrizB(2, 1) = -7.05:  matrizB(2, 2) = -9.55:  matrizB(2, 3) = -2.93:  matrizB(2, 4) = 10.34
    matrizB(3, 0) = 7.39:   matrizB(3, 1) = -9.95:  matrizB(3, 2) = 10.2:   matrizB(3, 3) = 9.06:   matrizB(3, 4) = 0.27
    matrizB(4, 0) = -6.47:  matrizB(4, 1) = 9.82:   matrizB(4, 2) = 9.56:   matrizB(4, 3) = -2.56:  matrizB(4, 4) = 6.36
End Sub
Function MaxList(lista)
    longitud = UBound(lista)
    Max = lista(0)
    For iloop = 1 To longitud
        If lista(iloop) Then Max = lista(iloop)
        Next iloop
End Function
Function augmentArrayList(ByVal matrizA, ByVal matrizB)
    filaA = UBound(matrizA, 1)
    columnaA = UBound(matrizA, 2)
    filaB = UBound(matrizB)
    filaC = Max(filaA, filaB)
    columnaC = columnaA + 1
    Dim matrizC()
    ReDim matrizC(filaC, columnaC)
    For iloop = 0 To filaC
        For jloop = 0 To columnaC
            If (jloop <= columnaA) And (iloop <= filaA) Then
                matrizC(iloop, jloop) = matrizA(iloop, jloop)
                ElseIf (jloop > columnaA) And (iloop <= filaB) Then
                matrizC(iloop, jloop) = matrizB(iloop)
            End If
        Next jloop
    Next iloop
    augmentArrayList = matrizC
End Function

Function augmentArrays(matrizA, matrizB)
    filaA = UBound(matrizA, 1)
    columnaA = UBound(matrizA, 2)
    filaB = UBound(matrizB, 1)
    columnaB = UBound(matrizB, 2)
    filaC = Max(filaA, filaB)
    columnaC = columnaA + columnaB + 1
    Dim matrizC()
    ReDim matrizC(filaC, columnaC)
    For iloop = 0 To filaC
        For jloop = 0 To columnaC
            If jloop <= columnaA Then
                matrizC(iloop, jloop) = matrizA(iloop, jloop)
                Else
                matrizC(iloop, jloop) = matrizB(iloop, jloop - columnaA - 1)
            End If
        Next jloop
    Next iloop
    augmentArrays = matrizC
End Function
Function ReducirMatriz(Matriz)
    fila = UBound(Matriz, 1)
    Column = UBound(Matriz, 2)
    For jloop = 0 To fila
        indx = jloop
        aux = Abs(Matriz(jloop, jloop))
        For iloop = jloop + 1 To fila
            valor = Matriz(iloop, jloop)
            If Abs(valor) > aux Then
                indx = iloop
                aux = Abs(valor)
            End If
        Next iloop
        Call cambiarfilas(Matriz, indx, jloop)
        For iloop = 0 To fila
            If iloop <> jloop Then
                Call multsumfilas(Matriz, -Matriz(iloop, jloop) / Matriz(jloop, jloop), jloop, iloop)
            End If
        Next iloop
    Next jloop
    For iloop = 0 To fila
        Call multConstfilas(Matriz, 1 / Matriz(iloop, iloop), iloop)
    Next iloop
    ReducirMatriz = Matriz
End Function
Sub ensamblarMatriz()
    filas = UBound(barras, 1)
    ReDim matrizRigidez(filas)
    For iloop = 0 To filas
        aux1 = multipMatriz(k1(iloop), ListTR(iloop))
        aux2 = trasponer(ListTR(iloop))
        aux3 = multipMatriz(aux2, aux1)
        aux4 = multipMatriz(aux3, AC(iloop))
        aux5 = trasponer(AC(iloop))
        aux6 = multipMatriz(aux5, aux4)
        matrizRigidez(iloop) = aux6
    Next iloop
End Sub
Function SumaMatriz(a, b)
    filas = UBound(a, 1)
    columna = UBound(a, 2)
    Dim aux() As Double
    ReDim aux(filas, columna)
    For iloop = 0 To filas
        For jloop = 0 To columna
            aux(iloop, jloop) = a(iloop, jloop) + b(iloop, jloop)
        Next jloop
    Next iloop
    SumaMatriz = aux
End Function
Function multipMatriz(a, b)
    fila = UBound(a, 1)
    columna = UBound(b, 2)
    enlace = UBound(a, 2)
    Dim aux() As Double
    ReDim aux(fila, columna)
    For iloop = 0 To fila
        For jloop = 0 To columna
            For kloop = 0 To enlace
                aux(iloop, jloop) = aux(iloop, jloop) + b(kloop, jloop) * a(iloop, kloop)
            Next kloop
        Next jloop
    Next iloop
    multipMatriz = aux
End Function
Function trasponer(x)
    Dim aux()
    fila = UBound(x, 1)
    columna = UBound(x, 2)
    ReDim aux(columna, fila)
    For iloop = 0 To fila
        For jloop = 0 To columna
            aux(jloop, iloop) = x(iloop, jloop)
        Next jloop
    Next iloop
    trasponer = aux
End Function
Sub transformada()
    filasbarra = UBound(barras)
    ReDim ListTR(filasbarra)
    For iloop = 0 To filasbarra
        TR(0, 0) = cosenos(iloop)(0)
        TR(0, 1) = cosenos(iloop)(1)
        TR(0, 2) = cosenos(iloop)(2)
        TR(2, 2) = Sqr(TR(0, 0) ^ 2 + TR(0, 1) ^ 2)
        If TR(2, 2) <> 0 Then
            TR(1, 0) = -TR(0, 1) / TR(2, 2)
            TR(1, 1) = TR(0, 0) / TR(2, 2)
            Else
            TR(1, 1) = 1
        End If
        TR(2, 0) = -TR(1, 1) * TR(0, 2)
        TR(2, 1) = TR(1, 0) * TR(0, 2)
        For jloop = 1 To 3
            TR(3 * jloop, 3 * jloop) = TR(0, 0)
            TR(3 * jloop, 3 * jloop + 1) = TR(0, 1)
            TR(3 * jloop, 3 * jloop + 2) = TR(0, 2)
            TR(3 * jloop + 1, 3 * jloop) = TR(1, 0)
            TR(3 * jloop + 1, 3 * jloop + 1) = TR(1, 1)
            TR(3 * jloop + 1, 3 * jloop + 2) = TR(1, 2)
            TR(3 * jloop + 2, 3 * jloop) = TR(2, 0)
            TR(3 * jloop + 2, 3 * jloop + 1) = TR(2, 1)
            TR(3 * jloop + 2, 3 * jloop + 2) = TR(2, 2)
        Next jloop
        ListTR(iloop) = TR
    Next iloop
End Sub
Sub IndicesCompatibilidad()
    Call Datos
    filasnudos = UBound(nudos)
    filasrestricciones = UBound(tiporestriccion)
    ReDim CG(filasnudos, 5)
    For iloop = 0 To filasrestricciones
        For jloop = 0 To 5
            If tiporestriccion(iloop)(jloop) <> 0 Then
                CG(restriccion(iloop), jloop) = 1
            End If
        Next jloop
    Next iloop
    For iloop = 0 To filasnudos
        For jloop = 0 To 5
            CG(iloop, jloop) = 1 - CG(iloop, jloop)
        Next jloop
    Next iloop
    kCG = 0
    For iloop = 0 To filasnudos
        For jloop = 0 To 5
            If CG(iloop, jloop) = 1 Then
                kCG = kCG + 1
                CG(iloop, jloop) = kCG
            End If
        Next jloop
    Next iloop
    filasbarras = UBound(barras)
    ReDim VC(filasbarras, 11)
    For iloop = 0 To filasbarras
        For jloop = 0 To 5
            VC(iloop, jloop) = CG(barras(iloop)(0), jloop)
            VC(iloop, 6 + jloop) = CG(barras(iloop)(1), jloop)
        Next jloop
    Next iloop
    ReDim AC(filasbarras)
    ReDim A0(11, kCG - 1)
    For iloop = 0 To filasbarras
        AC(iloop) = A0
        For jloop = 0 To 11
            If VC(iloop, jloop) <> 0 Then
                AC(iloop)(jloop, VC(iloop, jloop) - 1) = 1
            End If
        Next jloop
    Next iloop
End Sub

Function fRigidLocal(ByVal Lo As Double, ByVal Ec As Double, ByVal Gc As Double, ByVal Ao As Double, ByVal Asz As Double, ByVal Asy As Double, ByVal Iz As Double, ByVal Iy As Double, ByVal Jo As Double)
    vz = 3 * Iz / Asz / Lo ^ 2 * Ec / Gc
    vy = 3 * Iy / Asy / Lo ^ 2 * Ec / Gc
    phiz = 2 * Iz / (1 + 4 * vz) * Ec / Lo
    phiy = 2 * Iy / (1 + 4 * vy) * Ec / Lo
    Dim aux(11, 11) As Double
    aux(4, 4) = 2 * (1 + vz) * phiz:    aux(10, 10) = aux(4, 4)
    aux(5, 5) = 2 * (1 + vy) * phiy:    aux(11, 11) = aux(5, 5)
    aux(4, 10) = (1 - 2 * vz) * phiz:   aux(10, 4) = aux(4, 10)
    aux(5, 11) = (1 - 2 * vy) * phiy:   aux(11, 5) = aux(5, 11)
    aux(0, 0) = Ao * Ec / Lo:           aux(6, 6) = aux(0, 0):     aux(0, 6) = -aux(0, 0):    aux(6, 0) = aux(0, 6)
    aux(1, 1) = 6 * phiy / Lo ^ 2:      aux(7, 7) = aux(1, 1):     aux(1, 7) = -aux(1, 1):    aux(7, 1) = aux(1, 7)
    aux(2, 2) = 6 * phiz / Lo ^ 2:      aux(8, 8) = aux(2, 2):     aux(2, 8) = -aux(2, 2):    aux(8, 2) = aux(2, 8)
    aux(3, 3) = Gc * Jo / Lo:           aux(9, 9) = aux(3, 3):     aux(3, 9) = -aux(3, 3):    aux(9, 3) = aux(3, 9)
    aux(1, 5) = aux(1, 1) * Lo / 2:     aux(1, 11) = aux(1, 5):    aux(11, 1) = aux(1, 5):    aux(5, 1) = aux(1, 5)
    aux(7, 11) = -aux(1, 5):   aux(5, 7) = aux(7, 11):    aux(7, 5) = aux(7, 11):    aux(11, 7) = aux(7, 11)
    aux(2, 4) = -aux(2, 2) * Lo / 2:    aux(4, 2) = aux(2, 4):     aux(2, 10) = aux(2, 4):    aux(10, 2) = aux(2, 4):
    aux(8, 10) = -aux(2, 4):   aux(10, 8) = aux(8, 10):   aux(4, 8) = aux(8, 10):    aux(8, 4) = aux(8, 10)
    fRigidLocal = aux
End Function
Sub rigideceslocales()
    filas = UBound(barras)
    ReDim k1(filas)
    For iloop = 0 To filas
        Lo = longitudes(iloop)
        Ec = fisicMat(secciones(barras(iloop)(2))(2))(0)
        Gc = fisicMat(secciones(barras(iloop)(2))(2))(1)
        Ao = propSeccion(barras(iloop)(2))(0)
        Asz = propSeccion(barras(iloop)(2))(1)
        Asy = propSeccion(barras(iloop)(2))(2)
        Iz = propSeccion(barras(iloop)(2))(3)
        Iy = propSeccion(barras(iloop)(2))(4)
        Jo = propSeccion(barras(iloop)(2))(5)
        k1(iloop) = fRigidLocal(Lo, Ec, Gc, Ao, Asz, Asy, Iz, Iy, Jo)
    Next iloop
End Sub
Sub propertieHoAo(ByRef HoAo)
    filas = UBound(HoAo)
    ReDim fisicMat(filas)
    For iloop = 0 To filas
        Ec = (HoAo(iloop)(1) / pcf) ^ 1.5 * 33 * Sqr(HoAo(iloop)(0) * psi)
        Gc = Ec / 2 / (1 + HoAo(iloop)(2))
        fisicMat(iloop) = Array(Ec, Gc)
    Next iloop
End Sub
Sub lengcos()
    filas = UBound(barras)
    ReDim longitudes(filas)
    ReDim cosenos(filas)
    Dim delta(2)
    For iloop = 0 To filas
        For jloop = 0 To 2
            delta(jloop) = nudos(barras(iloop)(1))(jloop) - nudos(barras(iloop)(0))(jloop)
        Next jloop
        longitudes(iloop) = Sqr(delta(0) ^ 2 + delta(1) ^ 2 + delta(2) ^ 2)
        cosenos(iloop) = Array(delta(0) / longitudes(iloop), delta(1) / longitudes(iloop), delta(2) / longitudes(iloop))
    Next iloop
End Sub
Sub propsect()
    filas = UBound(secciones)
    ReDim propSeccion(filas)
    For iloop = 0 To filas
        b = secciones(iloop)(0)
        h = secciones(iloop)(1)
        Ao = b * h
        Az = 5 / 6 * Ao
        Ay = Az
        Iz = b * h ^ 3 / 12
        Iy = b ^ 3 * h / 12
        rbh = Application.WorksheetFunction.Min(b / h, h / b)
        Jo = rbh ^ 3 * h ^ 4 * (1 / 3 - 0.21 * rbh * (1 - rbh ^ 4 / 12))
        propSeccion(iloop) = Array(Ao, Az, Ay, Iz, Iy, Jo)
    Next iloop
End Sub
Sub units(ByVal unit As Byte)
    '"kgf", "tonf"
    valueforce = Array(convforce, convforce / 1000)
    '"m", "cm"
    valuelength = Array(convlength, convlength * 100)
    keyforcelength = Array("kgf-m", "tonf-cm")
    valueforcelength = Array(Array(0, 0), Array(1, 1))
    '    Debug.Print ("Elija una opcion")
    '    i = 0
    '    For Each Item In keyforcelength
    '        Debug.Print (i & " : " & Item)
    '        i = i + 1
    '    Next Item
    unitforce = valueforcelength(unit)(0)
    unitlength = valueforcelength(unit)(1)
    lbf = valueforce(unitforce)
    ft = valuelength(unitlength)
    inch = ft / 12
    pcf = lbf / ft ^ 3
    psi = lbf / inch ^ 2
End Sub
Sub viewvector(ByVal x)
    filas = UBound(x)
    For iloop = 0 To filas
        Debug.Print (x(iloop))
    Next iloop
End Sub
Sub viewmatrixDinamic(ByVal x)
    filas = UBound(x)
    columnas = UBound(x(0))
    For iloop = 0 To filas
        For jloop = 0 To columnas
            txt = txt & Round(x(iloop)(jloop), 3) & vbTab
        Next jloop
        txt = txt & vbNewLine
    Next iloop
    Debug.Print (txt)
End Sub
Sub viewmatrixStatic(ByVal x)
    filas = UBound(x, 1)
    columnas = UBound(x, 2)

    For iloop = 0 To filas
        For jloop = 0 To columnas
            txt = txt & Round(x(iloop, jloop), 3) & vbTab
        Next jloop
        txt = txt & vbNewLine
    Next iloop
    Debug.Print (txt)
End Sub
Function Max(a, b)
    If a > b Then
        Max = a
        Else
        Max = b
    End If
End Function
