VERSION 5.00
Begin VB.UserForm PSIForm
   Caption         =   "PSI Text"
   ClientHeight    =   1980
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   2400
   StartUpPosition =   1
   Begin VB.TextBox txtPSI
      Height          =   300
      Left            =   60
      Locked          =   -1  'True
      TabIndex        =   0
      Top             =   60
      Width           =   2280
   End
   Begin VB.TextBox txtHeight
      Height          =   300
      Left            =   60
      TabIndex        =   1
      Text            =   "15"
      Top             =   420
      Width           =   2280
   End
   Begin VB.TextBox txtFont
      Height          =   300
      Left            =   60
      TabIndex        =   2
      Text            =   "Arial"
      Top             =   780
      Width           =   2280
   End
   Begin VB.CheckBox chkBold
      Caption         =   "Bold"
      Height          =   300
      Left            =   60
      TabIndex        =   3
      Top             =   1080
      Width           =   2280
   End
   Begin VB.CommandButton cmdOK
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   360
      Left            =   60
      TabIndex        =   4
      Top             =   1500
      Width           =   900
   End
   Begin VB.CommandButton cmdCancel
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   360
      Left            =   1380
      TabIndex        =   5
      Top             =   1500
      Width           =   900
   End
End
Attribute VB_Name = "PSIForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdCancel_Click()
    Me.Hide
End Sub
Private Sub cmdOK_Click()
    Me.Tag = "OK"
    Me.Hide
End Sub
