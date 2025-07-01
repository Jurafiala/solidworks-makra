Attribute VB_Name = "MainModule"

Sub main()
    Dim height As Double
    Dim bold As Boolean
    Dim italic As Boolean
    Dim underline As Boolean
    Dim fontName As String

    If Not AskTextOptions(height, bold, italic, underline, fontName) Then Exit Sub

    Dim fmt As IGetTextFormat
    ' Assuming GetTextFormat returns an IGetTextFormat object
    Set fmt = GetTextFormat()

    fmt.Bold = bold
    fmt.Italic = italic
    fmt.Underline = underline
    fmt.TypeFaceName = fontName
    fmt.Height = height

    ApplyTextFormat fmt
End Sub

' Placeholder implementations for missing API
Public Function GetTextFormat() As IGetTextFormat
    ' TODO: Retrieve format from SolidWorks API
End Function

Public Sub ApplyTextFormat(fmt As IGetTextFormat)
    ' TODO: Apply format to document using SolidWorks API
End Sub
