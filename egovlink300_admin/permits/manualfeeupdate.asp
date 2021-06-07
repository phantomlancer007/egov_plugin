<!-- #include file="../includes/common.asp" //-->
<!-- #include file="permitcommonfunctions.asp" //-->
<%
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
' FILENAME: manualfeeupdate.asp
' AUTHOR: Steve Loar
' CREATED: 04/10/2008
' COPYRIGHT: Copyright 2008 eclink, inc.
'			 All Rights Reserved.
'
' Description:  This updates manual fee amounts. Called via AJAX
'
' MODIFICATION HISTORY
' 1.0   04/10/2008   Steve Loar - INITIAL VERSION
'
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
Dim iPermitFeeId, sFeeAmounts, sSql

iPermitFeeId = CLng(request("permitfeeid"))
sFeeAmount = CDbl(request("feeamount"))

sSql = "UPDATE egov_permitfees SET feeamount = " & sFeeAmount & " WHERE permitfeeid = " & iPermitFeeId
RunSQL sSql

response.write "Success"


%>