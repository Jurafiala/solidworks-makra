VERSION 5.00
Begin VB.Form PSIForm 
   Caption         =   "Text Options"
   ClientHeight    =   1800
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   3000
   Begin VB.TextBox txtHeight
      Height       =   300
      Left         =   120
      Top          =   120
      Text         =   "10"
      Width        =   1000
   End
   Begin VB.CheckBox chkBold
      Caption      =   "Bold"
      Left         =   120
      Top          =   480
   End
   Begin VB.CheckBox chkItalic
      Caption      =   "Italic"
      Left         =   120
      Top          =   720
   End
   Begin VB.CheckBox chkUnderline
      Caption      =   "Underline"
      Left         =   120
      Top          =   960
   End
   Begin VB.ComboBox cmbFontName
      Left         =   120
      Top          =   1200
      Width        =   2000
   End
End
Attribute VB_Name = "PSIForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub UserForm_Initialize()
    cmbFontName.AddItem "Arial"
    cmbFontName.AddItem "Calibri"
    cmbFontName.AddItem "Times New Roman"
End Sub

Private Sub OKButton_Click()
    Me.Hide
End Sub

Private Sub CancelButton_Click()
    Me.Tag = "Cancel"
    Me.Hide
End Sub
