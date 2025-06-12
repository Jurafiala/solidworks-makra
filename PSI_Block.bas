Option Explicit

Sub main()
    Dim sw As SldWorks.SldWorks: Set sw = Application.SldWorks
    Dim mdl As ModelDoc2: Set mdl = sw.ActiveDoc
    If mdl Is Nothing Or mdl.GetType <> swDocPART Then
        MsgBox "Open a part document", vbCritical
        Exit Sub
    End If
    Dim psi As String
    mdl.ConfigurationManager.ActiveConfiguration.CustomPropertyManager.Get4 _
        "PSI kod", False, "", psi
    Debug.Print "PSI code read: " & psi

    Dim face As Face2: Set face = GetPlanarFace(mdl.SelectionManager)
    If face Is Nothing Then
        MsgBox "Select one planar face", vbCritical
        Exit Sub
    End If

    Dim height As Double, fontName As String, isBold As Boolean
    If Not AskTextOptions(psi, height, fontName, isBold) Then Exit Sub
    Debug.Print "Height (m): " & height
    Debug.Print "Font: " & fontName & ", Bold: " & isBold

    face.Select False
    mdl.InsertSketch2 True
    Dim segs As Variant
    segs = ConvertFaceEdges(face)
    Debug.Print "Sketch started and edges converted"

    Dim box As Variant: box = face.GetBox
    Dim cx As Double, cy As Double, cz As Double
    cx = (box(0) + box(3)) / 2
    cy = (box(1) + box(4)) / 2
    cz = (box(2) + box(5)) / 2
    Dim st As SketchText
    Set st = mdl.SketchManager.CreateText2(psi, cx, cy, cz, height, 0)
    With st.IGetTextFormat(0)
        .CharHeight = height
        .TypeFaceName = fontName
        .Bold = isBold
        .Italic = False
        .Underline = False
        st.SetTextFormat 0, .Clone
    End With
    st.Select False
    With mdl.SketchManager.MakeSketchBlockFromSelected(False, False)
        .Name = "PSI_Block"
    End With
    Debug.Print "PSI_Block inserted"
    DeleteSegments segs
    Debug.Print "Converted edges removed"
End Sub

Function GetPlanarFace(sel As SelectionMgr) As Face2
    If sel.GetSelectedObjectCount2(-1) = 1 Then
        Dim f As Face2: Set f = sel.GetSelectedObject6(1, -1)
        If Not f Is Nothing Then
            If f.GetSurface.IsPlane Then Set GetPlanarFace = f
        End If
    End If
End Function

Function AskTextOptions(code As String, ByRef h As Double, _
    ByRef fontName As String, ByRef bold As Boolean) As Boolean
    Dim frm As PSIForm: Set frm = New PSIForm
    frm.txtPSI.Text = code
    frm.Show vbModal
    If frm.Tag = "OK" Then
        h = Val(frm.txtHeight.Text) / 1000#
        fontName = frm.txtFont.Text
        bold = frm.chkBold.Value <> 0
        AskTextOptions = True
    End If
    Unload frm
End Function

Function ConvertFaceEdges(f As Face2) As Variant
    Dim edges As Variant: edges = f.GetEdges
    Dim i As Long
    For i = LBound(edges) To UBound(edges)
        Dim e As Edge: Set e = edges(i)
        e.Select i = 0
    Next i
    Application.SldWorks.ActiveDoc.SketchManager.SketchUseEdge2 1
    Application.SldWorks.ActiveDoc.ClearSelection2 True
    ConvertFaceEdges = Application.SldWorks.ActiveDoc.ActiveSketch.GetSketchSegments
End Function

Sub DeleteSegments(segs As Variant)
    If IsEmpty(segs) Then Exit Sub
    Dim mdl As ModelDoc2: Set mdl = Application.SldWorks.ActiveDoc
    Dim ext As ModelDocExtension: Set ext = mdl.Extension
    Dim i As Long
    For i = LBound(segs) To UBound(segs)
        Dim s As SketchSegment: Set s = segs(i)
        s.Select i = 0
    Next i
    ext.DeleteSelection2 0
    mdl.ClearSelection2 True
End Sub
