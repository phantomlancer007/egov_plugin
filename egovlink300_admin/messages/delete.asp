<!-- #include file="../includes/common.asp" //-->
<%
On Error Resume Next

Dim sDelete, oCmd, Item
sDelete = ""

For Each Item In Request.Form
  If Left(Item,4) = "del_" Then
    sDelete = sDelete & Mid(Item,5) & ","
  End If
Next
sDelete = Left(sDelete, Len(sDelete)-1)

If sDelete & "" <> "" Then
  Set oCmd = Server.CreateObject("ADODB.Command")
  With oCmd
    .ActiveConnection = Application("DSN")
    .CommandText = "DelMailMessages"
    .CommandType = adCmdStoredProc
    .Parameters.Append oCmd.CreateParameter("UserID", adInteger, adParamInput, 4, Session("UserID"))
    .Parameters.Append oCmd.CreateParameter("PmailIDs", adVarChar, adParamInput, 1000, sDelete)
    .Parameters.Append oCmd.CreateParameter("IsCreator", adInteger, adParamInput, 4, Request.Form("IsCreator"))
    .Execute
  End With
  Set oCmd = Nothing
End If

Response.Redirect Request.Form("BackPage")
%>