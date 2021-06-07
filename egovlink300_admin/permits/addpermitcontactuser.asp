<!-- #include file="../includes/common.asp" //-->
<!-- #include file="permitcommonfunctions.asp" //-->
<%
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
' FILENAME: addpermitcontactuser.asp
' AUTHOR: Steve Loar
' CREATED: 02/06/2009
' COPYRIGHT: Copyright 2009 eclink, inc.
'			 All Rights Reserved.
'
' Description:  Adds users to contractors. Called via AJAX from contactuserpicker.asp
'
' MODIFICATION HISTORY
' 1.0   02/06/2009	Steve Loar - INITIAL VERSION
'
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
Dim iPermitContactTypeId, sSql, iUserId

iPermitContactTypeId = CLng(request("permitcontacttypeid"))
iUserId = CLng(request("userid"))

If iPermitContactTypeId > CLng(0) Then 
	' Add to the permit contact table
	sSql = "INSERT INTO egov_permitcontacttypes_to_users ( permitcontacttypeid, userid ) VALUES ( " & iPermitContactTypeId
	sSql = sSql & ", " & iUserId & " )"
	RunSQL sSql
End If 

response.write "Success"

%>