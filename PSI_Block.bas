Attribute VB_Name = "PSI_Block"

Public Function AskTextOptions(ByRef height As Double, ByRef bold As Boolean, _
                               ByRef italic As Boolean, ByRef underline As Boolean, _
                               ByRef fontName As String) As Boolean
    Dim frm As PSIForm
    Set frm = New PSIForm
    frm.Show
    If frm.Tag = "Cancel" Then
        AskTextOptions = False
    Else
        height = Val(frm.txtHeight.Text)
        bold = frm.chkBold.Value
        italic = frm.chkItalic.Value
        underline = frm.chkUnderline.Value
        fontName = frm.cmbFontName.Text
        AskTextOptions = True
    End If
    Unload frm
End Function
