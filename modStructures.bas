Attribute VB_Name = "modStructures"
Option Explicit
'modulo: modStructures
'funciones y procedimientos matematicos
'René Gonzalo Barañado Quiñones (02/11/2021)
Const convForce = 0.45359237
Const convLength = 0.3048
Dim lbf As Double
Dim ft As Double
Dim inch As Double
Dim pcf As Double
Dim psi As Double
Private Sub mainStructures()
    Dim propertHoAo() As Variant
    Dim sectionsRec() As Variant
    Dim nodes() As Variant
    Dim bars() As Variant
    Dim support() As Variant
    Dim force() As Variant
    ReDim propertHoAo(1)
    ReDim sectionsRec(1)
    ReDim nodes(2)
    ReDim bars(1)
    ReDim support(1)
    propertHoAo = Array(Array(0.281227831855664, 2.402769506094E-06, 0.2), _
                        Array(0.21, 0.00000232, 0.2))
    sectionsRec = Array(Array(20, 30, 1), Array(25, 45, 0))
    nodes = Array(Array(0, 0, 0), Array(300, 400, 200), Array(500, 200, 100))
    bars = Array(Array(0, 1, 1), Array(2, 1, 0))
    support = Array(Array(0, 1, 1, 1, 1, 1, 1), Array(2, 0, 0, 1, 0, 0, 0))
    force = Array(10, 20, 30, 40, 50, 60, 0, 0, 0, 0)
    Dim materials() As Variant
    Dim sections() As Variant
    Dim members() As Variant
    Dim lengths() As Variant
    Dim cosine() As Variant
    Dim transfor() As Variant
    Dim matrixComp() As Variant
    Dim compatibility() As Variant
    Dim stiffArrayLocal() As Variant
    Dim stiffArrayGlobal() As Variant
    Dim stiffArrayTot() As Double
    Dim augmentedmatrix() As Double
    Dim displacements() As Double
    lbf = convForce / 1000                          'valor de la relacion lbf/[tonf]
    ft = convLength * 100                           'valor de la relacion ft/[cm]
    inch = ft / 12
    pcf = lbf / ft ^ 3
    psi = lbf / inch ^ 2
    materials = MaterialsHoAo(propertHoAo)
    sections = PropertSectionRec(sectionsRec, materials)
    members = PropertBars(nodes, bars, support, sections)
    lengths = members(0)
    transfor = members(1)
    compatibility = members(2)
    stiffArrayLocal = members(3)
    stiffArrayGlobal = MatrixAssembly(stiffArrayLocal, transfor, compatibility)
    stiffArrayTot = modArrays.SumListMatrix(stiffArrayGlobal)
    augmentedmatrix = AugmentArrayList(stiffArrayTot, force)
    displacements = modArrays.EndColum(ReduceMatrix(augmentedmatrix))
    Debug.Print ("Desplazamientos en los nudos")
    Call modGraphics.ViewVector(displacements)
End Sub
Sub units(ByVal unit As Byte)
    valueforce = Array(convForce, convForce / 1000)
    valuelength = Array(convLength, convLength * 100)
    keyforcelength = Array("kgf-m", "tonf-cm")
    valueforcelength = Array(Array(0, 0), Array(1, 1))
    unitforce = valueforcelength(unit)(0)
    unitlength = valueforcelength(unit)(1)
    lbf = valueforce(unitforce)
    ft = valuelength(unitlength)
    inch = ft / 12
    pcf = lbf / ft ^ 3
    psi = lbf / inch ^ 2
End Sub
Public Function MaterialsHoAo(ByVal HoAoListA As Variant) As Variant
    'MaterialesHoAo
    'devuelve las propiedades fisicas necesarias para el calculo, a partir de otras
    'propiedades caracteristicas del hormigon armado "xListA"
    Dim xRow As Byte
    Dim iloop As Byte
    Dim xListA As Variant
    Dim fc As Double
    Dim wc As Double
    Dim mu As Double
    Dim Ec As Double
    Dim Gc As Double
    xRow = UBound(HoAoListA)
    ReDim xListA(xRow)
    For iloop = 0 To xRow
        fc = HoAoListA(iloop)(0)
        wc = HoAoListA(iloop)(1)
        mu = HoAoListA(iloop)(2)
        Ec = (wc / pcf) ^ 1.5 * 33 * Sqr(fc * psi)
        Gc = Ec / 2 / (1 + mu)
        xListA(iloop) = Array(Ec, Gc)
    Next iloop
    MaterialsHoAo = xListA
End Function
Public Function PropertSectionRec(ByVal sectRecListA As Variant, ByVal matListA As Variant) As Variant
    'PropertSection
    'devuelve las propiedades de la seccion rectangular necesarias para el calculo
    'a partir de las dimensiones de las mismas
    Dim xRow As Byte
    Dim iloop As Byte
    Dim b As Double
    Dim h As Double
    Dim Ao As Double
    Dim Az As Double
    Dim Ay As Double
    Dim Iz As Double
    Dim Iy As Double
    Dim rbh As Double
    Dim Jo As Double
    Dim Ec As Double
    Dim Gc As Double
    Dim xListA As Variant
    xRow = UBound(sectRecListA)
    ReDim xListA(xRow)
    For iloop = 0 To xRow
        b = sectRecListA(iloop)(0)
        h = sectRecListA(iloop)(1)
        Ao = b * h
        Az = 5 / 6 * Ao
        Ay = Az
        Iz = b * h ^ 3 / 12
        Iy = b ^ 3 * h / 12
        rbh = modMathematics.Min(b / h, h / b)
        Jo = modMathematics.Max(b, rbh ^ 3 * h ^ 4 * (1 / 3 - 0.21 * rbh * (1 - rbh ^ 4 / 12)))
        Ec = matListA(sectRecListA(iloop)(2))(0)
        Gc = matListA(sectRecListA(iloop)(2))(1)
        xListA(iloop) = Array(Ao, Az, Ay, Iz, Iy, Jo, Ec, Gc)
    Next iloop
    PropertSectionRec = xListA
End Function
Public Function PropertBars(ByVal nudoListA As Variant, ByVal barraListA As Variant, ByVal support As Variant, ByVal sectListA As Variant) As Variant
    'PropertBars(nudoListA, barraListA, support) = Array(longListA, coseListA, transfListA, AcListA)
    'devuelve las longitudes, los cosenos directores, las matrices de transformacion y la matriz de compatibilidad
    'de las barras de la estructura
    Dim xRow As Byte
    Dim yRow As Byte
    Dim iloop As Byte
    Dim jloop As Byte
    Dim kcgByte As Byte
    Dim posByte As Byte
    Dim deltaListA  As Variant
    Dim longListA As Variant
    Dim coseListA As Variant
    Dim transfListA() As Variant
    Dim trArray(11, 11) As Double
    Dim CgArray() As Byte
    Dim VcArray() As Variant
    Dim AcListA() As Variant
    Dim AoArray() As Byte
    Dim kList() As Variant
    xRow = UBound(barraListA)
    yRow = UBound(nudoListA)
    ReDim longListA(xRow)
    ReDim coseListA(xRow)
    ReDim transfListA(xRow)
    ReDim CgArray(yRow, 5)
    ReDim VcArray(xRow, 11)
    ReDim AcListA(xRow)
    ReDim kList(xRow)
    For iloop = 0 To xRow
        deltaListA = Array(nudoListA(barraListA(iloop)(1))(0) - nudoListA(barraListA(iloop)(0))(0), _
                           nudoListA(barraListA(iloop)(1))(1) - nudoListA(barraListA(iloop)(0))(1), _
                           nudoListA(barraListA(iloop)(1))(2) - nudoListA(barraListA(iloop)(0))(2))
        longListA(iloop) = Sqr(deltaListA(0) ^ 2 + deltaListA(1) ^ 2 + deltaListA(2) ^ 2)
        coseListA(iloop) = Array(deltaListA(0) / longListA(iloop), _
                                 deltaListA(1) / longListA(iloop), _
                                 deltaListA(2) / longListA(iloop))
        trArray(0, 0) = coseListA(iloop)(0)
        trArray(0, 1) = coseListA(iloop)(1)
        trArray(0, 2) = coseListA(iloop)(2)
        trArray(2, 2) = Sqr(trArray(0, 0) ^ 2 + trArray(0, 1) ^ 2)
        If trArray(2, 2) <> 0 Then
            trArray(1, 0) = -trArray(0, 1) / trArray(2, 2)
            trArray(1, 1) = trArray(0, 0) / trArray(2, 2)
            Else
            trArray(1, 1) = 1
        End If
        trArray(2, 0) = -trArray(1, 1) * trArray(0, 2)
        trArray(2, 1) = trArray(1, 0) * trArray(0, 2)
        For jloop = 1 To 3
            trArray(3 * jloop, 3 * jloop) = trArray(0, 0)
            trArray(3 * jloop, 3 * jloop + 1) = trArray(0, 1)
            trArray(3 * jloop, 3 * jloop + 2) = trArray(0, 2)
            trArray(3 * jloop + 1, 3 * jloop) = trArray(1, 0)
            trArray(3 * jloop + 1, 3 * jloop + 1) = trArray(1, 1)
            trArray(3 * jloop + 1, 3 * jloop + 2) = trArray(1, 2)
            trArray(3 * jloop + 2, 3 * jloop) = trArray(2, 0)
            trArray(3 * jloop + 2, 3 * jloop + 1) = trArray(2, 1)
            trArray(3 * jloop + 2, 3 * jloop + 2) = trArray(2, 2)
        Next jloop
        transfListA(iloop) = trArray
    Next iloop
    For iloop = 0 To UBound(support)
        For jloop = 1 To 6
            If support(iloop)(jloop) <> 0 Then
                CgArray(support(iloop)(0), jloop - 1) = 1
            End If
        Next jloop
    Next iloop
    For iloop = 0 To yRow
        For jloop = 0 To 5
            CgArray(iloop, jloop) = 1 - CgArray(iloop, jloop)
        Next jloop
    Next iloop
    For iloop = 0 To yRow
        For jloop = 0 To 5
            If CgArray(iloop, jloop) = 1 Then
                kcgByte = kcgByte + 1
                CgArray(iloop, jloop) = kcgByte
            End If
        Next jloop
    Next iloop
    For iloop = 0 To xRow
        For jloop = 0 To 5
            VcArray(iloop, jloop) = CgArray(barraListA(iloop)(0), jloop)
            VcArray(iloop, 6 + jloop) = CgArray(barraListA(iloop)(1), jloop)
        Next jloop
    Next iloop
    ReDim AoArray(11, kcgByte - 1)
    For iloop = 0 To xRow
        AcListA(iloop) = AoArray
        For jloop = 0 To 11
            If VcArray(iloop, jloop) <> 0 Then
                AcListA(iloop)(jloop, VcArray(iloop, jloop) - 1) = 1
            End If
        Next jloop
    Next iloop
    For iloop = 0 To xRow
        posByte = barraListA(iloop)(2)
        kList(iloop) = LocalStiffness(longListA(iloop), _
                                    sectListA(posByte)(6), sectListA(posByte)(7), _
                                    sectListA(posByte)(0), sectListA(posByte)(1), sectListA(posByte)(2), _
                                    sectListA(posByte)(3), sectListA(posByte)(4), sectListA(posByte)(5))
    Next iloop
    PropertBars = Array(longListA, transfListA, AcListA, kList)
End Function
Public Function LocalStiffness(ByVal LoDoubl As Double, ByVal EcDoubl As Double, ByVal GcDoubl As Double, _
                               ByVal AoDoubl As Double, ByVal AszDoubl As Double, ByVal AsyDoubl As Double, _
                               ByVal IzDoubl As Double, ByVal IyDoubl As Double, ByVal JoDoubl As Double) As Variant
    'LocalStiffness
    'Determina la matriz de rigidez local de un elememto
    Dim vzDoubl As Double
    Dim vyDoubl As Double
    Dim phizDoubl As Double
    Dim phiyDoubl As Double
    Dim kArray(11, 11) As Double
    vzDoubl = 3 * IzDoubl / AszDoubl / LoDoubl ^ 2 * EcDoubl / GcDoubl
    vyDoubl = 3 * IyDoubl / AsyDoubl / LoDoubl ^ 2 * EcDoubl / GcDoubl
    phizDoubl = 2 * IzDoubl / (1 + 4 * vzDoubl) * EcDoubl / LoDoubl
    phiyDoubl = 2 * IyDoubl / (1 + 4 * vyDoubl) * EcDoubl / LoDoubl
    kArray(4, 4) = 2 * (1 + vzDoubl) * phizDoubl:    kArray(10, 10) = kArray(4, 4)
    kArray(5, 5) = 2 * (1 + vyDoubl) * phiyDoubl:    kArray(11, 11) = kArray(5, 5)
    kArray(4, 10) = (1 - 2 * vzDoubl) * phizDoubl:   kArray(10, 4) = kArray(4, 10)
    kArray(5, 11) = (1 - 2 * vyDoubl) * phiyDoubl:   kArray(11, 5) = kArray(5, 11)
    kArray(0, 0) = AoDoubl * EcDoubl / LoDoubl:      kArray(6, 6) = kArray(0, 0):     kArray(0, 6) = -kArray(0, 0):    kArray(6, 0) = kArray(0, 6)
    kArray(1, 1) = 6 * phiyDoubl / LoDoubl ^ 2:      kArray(7, 7) = kArray(1, 1):     kArray(1, 7) = -kArray(1, 1):    kArray(7, 1) = kArray(1, 7)
    kArray(2, 2) = 6 * phizDoubl / LoDoubl ^ 2:      kArray(8, 8) = kArray(2, 2):     kArray(2, 8) = -kArray(2, 2):    kArray(8, 2) = kArray(2, 8)
    kArray(3, 3) = GcDoubl * JoDoubl / LoDoubl:      kArray(9, 9) = kArray(3, 3):     kArray(3, 9) = -kArray(3, 3):    kArray(9, 3) = kArray(3, 9)
    kArray(1, 5) = kArray(1, 1) * LoDoubl / 2:       kArray(1, 11) = kArray(1, 5):    kArray(11, 1) = kArray(1, 5):    kArray(5, 1) = kArray(1, 5)
    kArray(7, 11) = -kArray(1, 5):                   kArray(5, 7) = kArray(7, 11):    kArray(7, 5) = kArray(7, 11):    kArray(11, 7) = kArray(7, 11)
    kArray(2, 4) = -kArray(2, 2) * LoDoubl / 2:      kArray(4, 2) = kArray(2, 4):     kArray(2, 10) = kArray(2, 4):    kArray(10, 2) = kArray(2, 4):
    kArray(8, 10) = -kArray(2, 4):                   kArray(10, 8) = kArray(8, 10):   kArray(4, 8) = kArray(8, 10):    kArray(8, 4) = kArray(8, 10)
    LocalStiffness = kArray
End Function
Public Function MatrixAssembly(ByVal kListA As Variant, ByVal TrListA As Variant, ByVal AcListA As Variant) As Variant
    'MatrixAssembly
    'ensambla la matriz global para los grados de libertad
    Dim xRow As Byte
    Dim iloop As Byte
    Dim KGListA() As Variant
    Dim k1Array() As Double
    Dim k2Array() As Double
    Dim k3Array() As Double
    Dim ActArray() As Double
    Dim k4Array() As Double
    xRow = UBound(kListA)
    ReDim matrizRigidez(xRow)
    ReDim KGListA(xRow)
    For iloop = 0 To xRow
        k1Array = modArrays.Transpose(TrListA(iloop))
        k2Array = modArrays.MultMatrix(k1Array, kListA(iloop))
        k3Array = modArrays.MultMatrix(k2Array, TrListA(iloop))
        ActArray = modArrays.Transpose(AcListA(iloop))
        k4Array = modArrays.MultMatrix(ActArray, k3Array)
        KGListA(iloop) = modArrays.MultMatrix(k4Array, AcListA(iloop))
    Next iloop
    MatrixAssembly = KGListA
End Function
