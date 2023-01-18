Attribute VB_Name = "Module21"
Sub Project_2_Conditional_Formatting()

Dim myrange As Range

Set myrange = Range("A1:DR307512")

myrange.FormatConditions.Delete

myrange.FormatConditions.Add Type:=xlCellValue, Operator:=xlBetween, _
    Formula1:="=100", Formula2:="=150"
myrange.FormatConditions(1).Interior.Color = RGB(254, 0, 0)
'Add Second Rule
myrange.FormatConditions.Add Type:=xlCellValue, Operator:=xlLess, _
    Formula1:="=100"
myrange.FormatConditions(2).Interior.Color = RGB(255, 255, 0)
'Add Third Rule
myrange.FormatConditions.Add Type:=xlCellValue, Operator:=xlGreater, _
    Formula1:="=150"
myrange.FormatConditions(3).Interior.Color = RGB(171, 255, 0)

    
End Sub


Public Sub Project_2_Pdf()
Dim wsA As Worksheet
Dim wbA As Workbook
Dim strTime As String
Dim strName As String
Dim strPath As String
Dim strFile As String
Dim strPathFile As String
Dim myFile As Variant
On Error GoTo errHandler

Set wbA = ActiveWorkbook
Set wsA = ActiveSheet
strTime = Format(Now(), "ddmmyyyy\_hhmm")

strPath = wbA.Path
If strPath = "" Then
  strPath = Application.DefaultFilePath
End If
strPath = strPath & "\"

strName = Replace(wsA.Name, " ", "")
strName = Replace(strName, ".", "_")

strFile = strName & "_" & strTime & ".pdf"
strPathFile = strPath & strFile

myFile = Application.GetSaveAsFilename _
    (InitialFileName:=strPathFile, _
        FileFilter:="PDF Files (*.pdf), *.pdf", _
        Title:="Select Folder and FileName to save")

If myFile <> "False" Then
    wsA.ExportAsFixedFormat _
        Type:=xlTypePDF, _
        Filename:=myFile, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, _
        IgnorePrintAreas:=False, _
        OpenAfterPublish:=False

    MsgBox "PDF file has been created: " _
      & vbCrLf _
      & myFile
End If

exitHandler:
    Exit Sub
errHandler:
    MsgBox "Could not create PDF file"
    Resume exitHandler
    
End Sub

Public Sub Project_2_Spelling_Mistake()
For Each sh In Worksheets
    Sheets(sh.Name).Cells.CheckSpelling
Next
End Sub

