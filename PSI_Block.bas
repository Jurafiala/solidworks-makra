Option Explicit

Sub main()
    Dim mdl As ModelDoc2
    Set mdl = Application.SldWorks.ActiveDoc
    If mdl Is Nothing Or mdl.GetType <> swDocPART Then
        MsgBox "Open a part document", vbCritical
        Exit Sub
    End If
    Dim psi As String
    mdl.ConfigurationManager.ActiveConfiguration.CustomPropertyManager.Get4 _
        "PSI kod", False, "", psi
    Debug.Print "PSI code read: " & psi

    Dim face As Face2
    Set face = GetPlanarFace(mdl.SelectionManager)
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
    segs = ConvertFaceEdges(mdl, face)
    Debug.Print "Sketch started and edges converted"

    Dim c As Variant
    c = GetFaceCenter(face)
    Dim st As SketchText
    Set st = mdl.SketchManager.CreateText2(psi, c(0), c(1), c(2), height, 0)
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
    DeleteSegments mdl, segs
    Debug.Print "Converted edges removed"
End Sub

Function GetPlanarFace(sel As SelectionMgr) As Face2
    If sel.GetSelectedObjectCount2(-1) <> 1 Then Exit Function
    Dim f As Face2
    Set f = sel.GetSelectedObject6(1, -1)
    If Not f Is Nothing Then
        If f.GetSurface.IsPlane Then Set GetPlanarFace = f
    End If
End Function

Function AskTextOptions(code As String, ByRef h As Double, _
    ByRef fontName As String, ByRef bold As Boolean) As Boolean
    With New PSIForm
        .txtPSI.Text = code
        .Show vbModal
        If .Tag = "OK" Then
            h = Val(.txtHeight.Text) / 1000#
            fontName = .txtFont.Text
            bold = .chkBold.Value <> 0
            AskTextOptions = True
        End If
    End With
End Function

Function ConvertFaceEdges(mdl As ModelDoc2, f As Face2) As Variant
    Dim e As Edge
    For Each e In f.GetEdges
        e.Select False
    Next
    mdl.SketchManager.SketchUseEdge2 1
    mdl.ClearSelection2 True
    ConvertFaceEdges = mdl.ActiveSketch.GetSketchSegments
End Function

Sub DeleteSegments(mdl As ModelDoc2, segs As Variant)
    If IsEmpty(segs) Then Exit Sub
    Dim s As SketchSegment
    For Each s In segs
        s.Select False
    Next
    mdl.Extension.DeleteSelection2 0
    mdl.ClearSelection2 True
End Sub

Function GetFaceCenter(f As Face2) As Variant
    Dim b As Variant
    b = f.GetBox
    GetFaceCenter = Array((b(0) + b(3)) / 2, (b(1) + b(4)) / 2, (b(2) + b(5)) / 2)
End Function
