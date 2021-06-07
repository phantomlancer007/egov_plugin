<!-- #include file="../includes/common.asp" //-->
<%
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
' FILENAME: displaydelete.asp
' AUTHOR: Steve Loar
' CREATED: 05/19/2010
' COPYRIGHT: Copyright 2010 eclink, inc.
'			 All Rights Reserved.
'
' Description:  Deletes displays. Called from displayedit.asp
'
' MODIFICATION HISTORY
' 1.0   05/19/2010	Steve Loar - INITIAL VERSION
'
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
Dim iDisplayId, sSql

If request("displayid") <> "" Then
	iDisplayId = CLng(request("displayid"))
Else
	response.redirect "displaylist.asp"
End If 


' Remove the organization specific displays
sSql = "DELETE FROM egov_organizations_to_displays WHERE displayid = " & iDisplayId
response.write sSql & "<br /><br />"
RunSQLStatement sSql

' Remove the displays
sSql = "DELETE FROM egov_organization_displays WHERE displayid = " & iDisplayId
response.write sSql & "<br /><br />"
RunSQLStatement sSql

response.redirect "displaylist.asp?msg=d"


%>