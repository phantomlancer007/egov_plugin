<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- #include file="../includes/common.asp" //-->
<!-- #include file="../includes/start_modules.asp" //-->

<%
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
' FILENAME: gift_details.asp
' AUTHOR: Steve Loar
' CREATED: 08/01/06
' COPYRIGHT: Copyright 2006 eclink, inc.
'			 All Rights Reserved.
'
' Description:  Allows the viewing of gift purchase details
'
' MODIFICATION HISTORY
' 1.0   02/14/06   JOHN STULLENBERGER - INITIAL VERSION
' 1.1	08/01/06   Steve Loar - Made the original receipt into this view details script
'
'--------------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------------
Dim iGiftPaymentId, oOrganization

Set oOrganization = New classOrganization

iGiftPaymentId = request("igiftpaymentid")
%>

<html>
<head>
	<title><%=oOrganization.GetOrgName()%> E-Gov Commemorative Gift Purchase Details</title>

	<link href="../global.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="../css/style_<%=iorgid%>.css" type="text/css">
	<link rel="stylesheet" type="text/css" href="receiptprint.css" media="print" />
</head>

<!--#Include file="../include_top.asp"-->

	<!--BEGIN:  USER REGISTRATION - USER MENU-->
<%	RegisteredUserDisplay( "../" ) %>
	<!--END:  USER REGISTRATION - USER MENU-->


<!--BEGIN: PAGE CONTENT-->
<div id="content">
	<div id="centercontent">
		<div id="receiptlinks">
			<img src="../images/arrow_2back.gif" align="absmiddle">&nbsp;<a href="javascript:history.go(-1)">&nbsp;Back</a><span id="printbutton"><input type="button" onclick="javascript:window.print();" value="Print" /></span>
		</div>

		<h3><%=Session("sOrgName")%> Commemorative Gift Purchase Details</h3>

		<% DisplayReciept iGiftPaymentId %>
	</div>
</div>

<% Set oOrganization = Nothing %>

<!--END: PAGE CONTENT-->


<!--#Include file="../include_bottom.asp"-->  


<%
'--------------------------------------------------------------------------------------------------
' USER DEFINED SUBROUTINES AND FUNCTIONS
'--------------------------------------------------------------------------------------------------

'--------------------------------------------------------------------------------------------------
' SUB DISPLAYRECIEPT()
'--------------------------------------------------------------------------------------------------
Sub DisplayReciept( iGiftPaymentId )
	Dim sSql, oGift 

	' Get payment information 
	sSql = "Select giftamount, paymenttype, paymentlocation, giftname, firstname, lastname, address1, "
	sSql = sSql & " address2, city, state, zip, phone, email, paymentdate "
	sSql = sSql & " from egov_gift_payment P, egov_gift G"
	sSql = sSql & " where P.giftid = G.giftid and P.giftpaymentid = " & iGiftPaymentId
	
	Set oGift = Server.CreateObject("ADODB.Recordset")
	oGift.Open sSQL, Application("DSN"), 3, 1

	If Not oGift.EOF Then 
		' Show the user info
		response.write vbcrlf & "<div class=""purchasereportshadow"">"
		response.write vbcrlf & "<table border=""0"" cellpadding=""3"" cellspacing=""0"" class=""purchasereport"">"
		response.write vbcrlf & "<tr><th colspan=""2"" align=""left"">Purchaser Contact Information</th></tr>"
		response.write vbcrlf & "<tr><td width=""20%"" valign=""top"">Name:</td><td>" & oGift("firstname") & " " & oGift("lastname")
	'	response.write "<br /><strong>" & sResidentDesc & "</strong>"
		response.write "</td></tr>"
		response.write vbcrlf & "<tr><td>Email:</td><td>" & oGift("email") & "</td></tr>"
		response.write vbcrlf & "<tr><td>Phone:</td><td>" & FormatPhone(oGift("phone")) & "</td></tr>"
		response.write vbcrlf & "<tr><td valign=""top"">Address:</td><td>" & oGift("address1") & "<br />" 
'		If Trim(oGift("address2")) = "" Then 
'			response.write oGift("address2") & "<br />" 
'		End If 
		response.write oGift("city") & ", " & oGift("state") & " " & oGift("zip") & "</td></tr>"
		response.write vbcrlf & "</table></div>"


		' TRANSACTION RESULT DETAILS
		response.write vbcrlf & "<div class=""purchasereportshadow"">"
		response.write "<table border=""0"" cellpadding=""3"" cellspacing=""0"" class=""purchasereport"">"
		response.write "<tr><th colspan=""2"" align=""left""><b>Purchase Details</b></th></tr>"
		response.write "<tr><td width=""20%"">Purchase Date: </td><td> " & oGift("paymentdate") & "</td></tr>"
		
		response.write "<tr><td>Payment Method:</td><td> " & GetPaymentTypeName(oGift("paymenttype")) & " </td></tr>"
		response.write "<tr><td>Payment Location:</td><td> " & GetPaymentLocationName(oGift("paymentlocation")) & " </td></tr>"
		response.write "<tr><td>Amount: </td><td> " & FormatCurrency(oGift("giftamount"),2) & "</td></tr>"
		response.write "</table></div>"
		
		' PRODUCT INFORMATION
		response.write vbcrlf & "<div class=""purchasereportshadow"">"
		response.write "<table border=""0"" cellpadding=""3"" cellspacing=""0"" class=""purchasereport"">"
		response.write "<tr><th colspan=""2"" align=""left""><b>Gift Information</b></th></tr>"
		response.write "<tr><td width=""20%"">Order Number:</td><td> " & iGiftPaymentId & "F3000 </td></tr>"
		response.write "<tr><td>Product:</td><td>" & oGift("giftname") & "</td></tr>"
		response.write "<tr><td valign=top>Details: </td><td  valign=top>" & GetFieldValues(iGiftPaymentId) &  "</td></tr>"
		response.write "</table></div>"
	Else
		response.write "<p>No details are available.</p>"
	End If 

	oGift.close
	Set oGift = Nothing 

End Sub


'------------------------------------------------------------------------------------------------------------
' FUNCTION FN_DISPLAYPAYMENTS()
'------------------------------------------------------------------------------------------------------------
Function GetFieldValues(iGiftPaymentID)
		
	sReturnValue = ""
	sSQL = "SELECT dbo.egov_gift_value.giftvalue, dbo.egov_gift_value.giftpaymentid, dbo.egov_gift_value.fieldid, dbo.egov_gift_fields.fieldprompt FROM dbo.egov_gift_value INNER JOIN dbo.egov_gift_fields ON dbo.egov_gift_value.fieldid = dbo.egov_gift_fields.fieldid  where giftpaymentid='" & iGiftPaymentID & "' ORDER BY dbo.egov_gift_value.giftpaymentid, dbo.egov_gift_value.fieldid"

	Set oGiftDetails = Server.CreateObject("ADODB.Recordset")
	oGiftDetails.Open sSQL, Application("DSN") , 3, 1

	If NOT oGiftDetails.EOF Then
		
		Do While NOT oGiftDetails.EOF 
			sReturnValue = sReturnValue & "<b>" & oGiftDetails("fieldprompt") & "</b> : <i>" & oGiftDetails("giftvalue") & "</i><br>" 			
			oGiftDetails.MoveNext
		Loop
	
	End If

	oGiftDetails.close
	Set oGiftDetails = Nothing 

	GetFieldValues = sReturnValue

End Function


'--------------------------------------------------------------------------------------------------
' FUNCTION GETPAYMENTTYPENAME(IPAYMENTTYPEID)
'--------------------------------------------------------------------------------------------------
Function GetPaymentTypeName(ipaymenttypeid)

		' SET DEFAULT RETURN VALUE
		sReturnValue = "UNKNOWN"

		' SELECT PAYMENT TYPE NAME
		sSQL = "Select * FROM egov_paymenttypes where paymenttypeid = '" & ipaymenttypeid & "'"
		Set oPaymentType = Server.CreateObject("ADODB.Recordset")
		oPaymentType.Open sSQL, Application("DSN"), 3, 1

		' IF PAYMENT TYPE ID FOUND
		If not oPaymentType.EOF Then
			'SET RETURN VALUE TO PAYMENT NAME
			sReturnValue = oPaymentType("paymenttypename")
		End If
		
		' CLEAN UP OBJECT
		Set oPaymentType = Nothing

		' RETURN VALUE
		GetPaymentTypeName = sReturnValue
			
End Function


'--------------------------------------------------------------------------------------------------
' FUNCTION GETPAYMENTLOCATIONNAME(IPAYMENTLOCATIONID)
'--------------------------------------------------------------------------------------------------
Function GetPaymentLocationName(ipaymentlocationid)

		' SET DEFAULT RETURN VALUE
		sReturnValue = "UNKNOWN"

		' SELECT PAYMENT TYPE NAME
		sSQL = "Select * FROM egov_paymentlocations where paymentlocationid = '" & ipaymentlocationid & "'"
		Set oPaymentLocation = Server.CreateObject("ADODB.Recordset")
		oPaymentLocation.Open sSQL, Application("DSN"), 3, 1

		' IF PAYMENT TYPE ID FOUND
		If not oPaymentLocation.EOF Then
			'SET RETURN VALUE TO PAYMENT NAME
			sReturnValue = oPaymentLocation("paymentlocationname")
		End If
		
		' CLEAN UP OBJECT
		Set oPaymentLocation = Nothing

		' RETURN VALUE
		GetPaymentLocationName = sReturnValue
			
End Function


'------------------------------------------------------------------------------------------------------------
' FUNCTION STOREGIFTINFORMATION()
'------------------------------------------------------------------------------------------------------------
Function StoreGiftInformation(iOrgID)
		
		iReturnValue = 0

		Set oCmd = Server.CreateObject("ADODB.Command")
		 With oCmd
		.ActiveConnection = Application("DSN")
		.CommandText = "StoreGiftInformation"
		.CommandType = 4

		' INITIATATOR INFORMATION
		.Parameters.Append oCmd.CreateParameter("sFirstName", 200, 1, 50, request("txtfirstname"))
		.Parameters.Append oCmd.CreateParameter("smiddle", 200, 1, 50, request("txtMI"))
		.Parameters.Append oCmd.CreateParameter("slastname", 200, 1, 50, request("txtlastname"))
		.Parameters.Append oCmd.CreateParameter("saddress1", 200, 1, 50, request("txthome_address1"))
		.Parameters.Append oCmd.CreateParameter("saddress2", 200, 1, 50, request("txthome_address2"))
		.Parameters.Append oCmd.CreateParameter("scity", 200, 1, 50, request("txthome_city"))
		.Parameters.Append oCmd.CreateParameter("sstate", 200, 1, 50, request("cbohome_state"))
		.Parameters.Append oCmd.CreateParameter("szip", 200, 1, 50, request("txthome_zip"))
		.Parameters.Append oCmd.CreateParameter("sphone", 200, 1, 50, request("txtPhone1")&"-"&request("txtPhone2")&"-"&request("txtPhone3"))
		.Parameters.Append oCmd.CreateParameter("semail", 200, 1, 50, request("txtEmail"))

		' ACKNOWLEDGEMENT
		.Parameters.Append oCmd.CreateParameter("sack_name", 200, 1, 300, request("txtack_name"))

		' CHECK TO SEE IF THE ADDRESS ARE THE SAME
		If request("chkSameAs") = "TRUE" Then
			' USE SAME VALUES AS ABOVE
			.Parameters.Append oCmd.CreateParameter("sack_address1", 200, 1, 300, request("txthome_address1"))
			.Parameters.Append oCmd.CreateParameter("sack_address2", 200, 1, 300, request("txthome_address2"))
			.Parameters.Append oCmd.CreateParameter("sack_city", 200, 1, 300, request("txthome_city"))
			.Parameters.Append oCmd.CreateParameter("sack_state", 200, 1, 300, request("cbohome_state"))
			.Parameters.Append oCmd.CreateParameter("sack_zip", 200, 1, 300, request("txthome_zip"))
		Else
			' USE VALUES ENTERED 
			.Parameters.Append oCmd.CreateParameter("sack_address1", 200, 1, 300, request("txtack_address1"))
			.Parameters.Append oCmd.CreateParameter("sack_address2", 200, 1, 300, request("txtack_address2"))
			.Parameters.Append oCmd.CreateParameter("sack_city", 200, 1, 300, request("txtack_city"))
			.Parameters.Append oCmd.CreateParameter("sack_state", 200, 1, 300, request("txtack_state"))
			.Parameters.Append oCmd.CreateParameter("sack_zip", 200, 1, 300,request("txtAcknoledgeZip"))
		End If


		' GIFT INFORMATION
		.Parameters.Append oCmd.CreateParameter("decgiftamount", 6, 1,4 , request("amount"))
		.Parameters.Append oCmd.CreateParameter("igiftid", 3, 1, 4, request("GIFTID"))
		.Parameters.Append oCmd.CreateParameter("giftpaymentid", 3, 2, 4)

		' GIFT FIELD INFORMATION
		' CALL TO STORE VALUE INFORMATION
		.Execute

		iGiftPaymentID = .Parameters("giftpaymentid")
		
		If iGiftPaymentID <> "" Then
			iReturnValue = iGiftPaymentID
		End If

		' STORE FIELD VALUES
		StoreFieldValues(iGiftPaymentID)

     End With

	 Set oCmd = Nothing

	StoreGiftInformation = iReturnValue

End Function


'------------------------------------------------------------------------------------------------------------
' SUB STOREFIELDVALUES(IGIFTPAYMENTID)
'------------------------------------------------------------------------------------------------------------
Sub StoreFieldValues(iGiftPaymentID)
		
		' LOOP THRU EACH OF THE FIELDS AND ENTER VALUES SUBMITTED
		For Each oField IN Request.Form
			
			If Left(oField,7) = "custom_" Then
				' GET VALUES
				arrValues = split(oField,"_")
				iFieldID = clng(arrValues(1))
				iFieldGroup = clng(arrValues(2))

				 Set oCmd = Server.CreateObject("ADODB.Command")
				 With oCmd
				.ActiveConnection = Application("DSN")
				.CommandText = "StoreGiftFieldValues"
				.CommandType = 4
				
				' STORE VALUES
				.Parameters.Append oCmd.CreateParameter("iFieldID", 3, 1, 4, iFieldID)
				.Parameters.Append oCmd.CreateParameter("iGiftPaymentID", 3, 1, 4, iGiftPaymentID)
				.Parameters.Append oCmd.CreateParameter("sValue", 200, 1, 2000, request(oField))
				.Execute

				End With

				Set oCmd = Nothing
			End If

		Next

		' WRITE PAYMENTID INPUT VALUE
		response.write "<input type=""hidden"" name=""iGiftPaymentID"" value=""" & iGiftPaymentID & """>"
		response.write "<input type=hidden name=""iPAYMENT_MODULE"" value=""" & request("iPAYMENT_MODULE") & """>"


End Sub


'------------------------------------------------------------------------------------------------------------
' FUNCTION STOREFACILITYINFORMATION()
'------------------------------------------------------------------------------------------------------------
Function StoreFacilityInformation(iOrgID)
		
		iReturnValue = 0

		Set oCmd = Server.CreateObject("ADODB.Command")
		 With oCmd
		.ActiveConnection = Application("DSN")
		.CommandText = "StoreGiftInformation"
		.CommandType = 4

		' RESERVATION INFORMATION
		.Parameters.Append oCmd.CreateParameter("checkintime", 200, 1, 50, request("checkintime"))
		.Parameters.Append oCmd.CreateParameter("checkindate", 200, 1, 50, request("checkindate"))
		.Parameters.Append oCmd.CreateParameter("checkouttime", 200, 1, 50, request("checkouttime"))
		.Parameters.Append oCmd.CreateParameter("checkoutdate", 200, 1, 50, request("checkoutdate"))
		.Parameters.Append oCmd.CreateParameter("lesseeid", 3, 1, 4, request("lesseeid"))
		.Parameters.Append oCmd.CreateParameter("facilitytimepartid", 3, 1, 4, request("timepartid"))
		.Parameters.Append oCmd.CreateParameter("facilityid", 3, 1, 4, request("facilityid"))
		.Parameters.Append oCmd.CreateParameter("orgid", 3, 1, 4, iOrgID)
		.Parameters.Append oCmd.CreateParameter("amount", 3, 1, 4, request("amount"))
		.Parameters.Append oCmd.CreateParameter("facilitypaymentid", 3, 2, 4)

		' CALL TO STORE VALUE INFORMATION
		.Execute

		iFacilityPaymentID = .Parameters("facilitypaymentid")
		
		If iFacilityPaymentID <> "" Then
			iReturnValue = iFacilityPaymentID
		End If

		' STORE FIELD VALUES
		StoreFacilityFieldValues(iFacilityPaymentID)

     End With

	 Set oCmd = Nothing

	StoreFacilityInformation = iReturnValue
	 

End Function


'------------------------------------------------------------------------------------------------------------
' SUB STOREFACILITYFIELDVALUES(IFACILITYPAYMENTID)
'------------------------------------------------------------------------------------------------------------
Sub StoreFacilityFieldValues(iFacilityPaymentID)
		
		' LOOP THRU EACH OF THE FIELDS AND ENTER VALUES SUBMITTED
		For Each oField IN Request.Form
			
			If Left(oField,7) = "custom_" Then
				' GET VALUES
				arrValues = split(oField,"_")
				iFieldID = clng(arrValues(1))

				 Set oCmd = Server.CreateObject("ADODB.Command")
				 With oCmd
				.ActiveConnection = Application("DSN")
				.CommandText = "StoreFacilityFieldValues"
				.CommandType = 4
				
				' STORE VALUES
				.Parameters.Append oCmd.CreateParameter("iFieldID", 3, 1, 4, iFieldID)
				.Parameters.Append oCmd.CreateParameter("iFacilityPaymentID", 3, 1, 4, iFacilityPaymentID)
				.Parameters.Append oCmd.CreateParameter("sValue", 200, 1, 2000, request(oField))
				.Execute

				End With

				Set oCmd = Nothing
			End If

		Next

End Sub


'------------------------------------------------------------------------------------------------------------
' SUB UPDATEFACILITYPAYMENT(IFACILITYPAYMENTID, SAUTHCODE, SPNREF, SRESULT, SRESPMSG)
'------------------------------------------------------------------------------------------------------------
Sub UpdateFacilityPayment(iFacilityPaymentId, sAuthCode, sPNRef, sResult, sRespMsg, itype, ilocation)
	
	Set oCmd = Server.CreateObject("ADODB.Command")
		With oCmd
			.ActiveConnection = Application("DSN")
			.CommandText = "UpdateFacilityPayment"
			.CommandType = 4
			.Parameters.Append oCmd.CreateParameter("@iFacilityPaymentID", 3, 1, 4, iFacilityPaymentId)
			.Parameters.Append oCmd.CreateParameter("@sAuthCode", 200, 1, 50, sAuthCode)
			.Parameters.Append oCmd.CreateParameter("@sPNRef", 200, 1, 50, sPNRef)
			.Parameters.Append oCmd.CreateParameter("@sResult", 200, 1, 50, sResult)
			.Parameters.Append oCmd.CreateParameter("@sReplyMsg", 200, 1, 255, sRespMsg)
			.Parameters.Append oCmd.CreateParameter("@paymenttype", 200, 1, 4, itype)
			.Parameters.Append oCmd.CreateParameter("@paymentlocation", 200, 1, 4, ilocation)
			.Execute
	End With

	Set oCmd = Nothing

End Sub


'------------------------------------------------------------------------------------------------------------
' Sub UpdateGiftPayment(iGiftPaymentId, sAuthCode, sPNRef, sResult, sRespMsg,iType,iLocation)
'------------------------------------------------------------------------------------------------------------
Sub UpdateGiftPayment(iGiftPaymentId, sAuthCode, sPNRef, sResult, sRespMsg,iType,iLocation)
	
	Set oCmd = Server.CreateObject("ADODB.Command")
		With oCmd
			.ActiveConnection = Application("DSN")
			.CommandText = "UpdateGiftPayment2"
			.CommandType = 4
			.Parameters.Append oCmd.CreateParameter("@iGiftPaymentID", 3, 1, 4, iGiftPaymentId)
			.Parameters.Append oCmd.CreateParameter("@sAuthCode", 200, 1, 50, sAuthCode)
			.Parameters.Append oCmd.CreateParameter("@sPNRef", 200, 1, 50, sPNRef)
			.Parameters.Append oCmd.CreateParameter("@sResult", 200, 1, 50, sResult)
			.Parameters.Append oCmd.CreateParameter("@sReplyMsg", 200, 1, 255, sRespMsg)
			.Parameters.Append oCmd.CreateParameter("@iPaymentType", 3, 1, 4, iType)
			.Parameters.Append oCmd.CreateParameter("@iPaymentLocation", 3, 1, 4, iLocation)
			.Execute

	End With

	Set oCmd = Nothing

End Sub


'------------------------------------------------------------------------------------------------------------
' Sub UserInfo(iUserID)
'------------------------------------------------------------------------------------------------------------
Sub UserInfo(iUserID)

	' SELECT ROW WITH THIS USER'S INFORMATION
	sSQL = "SELECT * FROM egov_users WHERE userid = '" & iUserId & "'"
	Set oUser = Server.CreateObject("ADODB.Recordset")
	oUser.Open sSQL, Application("DSN") , 3, 1

	' IF RECORDSET NOT EMPTY THEN DISPLAY USER INFORMATION
	If NOT oUser.EOF Then
		
		response.write "<P><table>"
		response.write "<tr><td colspan=2><b>User Information</b></td></tr>"
		response.write "<tr><td>Name: </td><td>" & oUser("userfname") & " " & oUser("userlname")  &  "</td></tr>"
		response.write "<tr><td>Address: </td><td>" & oUser("useraddress") & "</td></tr>"
		response.write "<tr><td>City: </td><td>" & oUser("usercity") & "</td></tr>"
		response.write "<tr><td>State: </td><td>" & oUser("userstate") & "</td></tr>"
		response.write "<tr><td>Zip: </td><td>" & oUser("userzip") & "</td></tr>"
		response.write "</table></p></blockquote></div></p>"

	Else

		' RECORDSET EMPTY DON'T DISPLAY ANY INFORMATION

	End If

	Set oUser = Nothing
	
End Sub


'--------------------------------------------------------------------------------------------------
'  SUB SETWEEKLYDATES(SSTARTDATE,SENDDATE,WFREQUENCY,WDAYOFTHEWEEK)
'--------------------------------------------------------------------------------------------------
Sub SetWeeklyDates(sStartDate,sEndDate,wfrequency,wdayoftheweek)

	' GET NEXT DATE OF SPECIFIED DAY OF WEEK (COULD BE START DATE BUT NOT ALWAYS)
	dTemp = GetNextWeekDay(wdayoftheweek,sStartDate)

	' LOOP UNTIL END DATE
	Do While cdate(dTemp) <= cdate(sEndDate)
		' WRITE DAY OF WEEK
		
		' GET CURRENT STATUS OF TIMEPART AND DATE
		sStatus = GetTimePartStatus(request("L"),request("selTimePartID"),dTemp)
		
		' NOT RESERVED OR ONHOLD THEN MARK AVAILABLE
		If sStatus = "OPEN" or sStatus = "CANCELLED" Then
			' STORE RESERVATION INFORMATION
			iFacilityPaymentID = StoreFacilityInformationRecurrent(iOrgId,dTemp,dTemp)
			
			' UPDATE DATABASE
			UpdateFacilityPayment iFacilityPaymentID, "EGOVLINK_ADMIN","EGOVLINK_ADMIN","APPROVED","APPROVED",request("paymenttype"),request("paymentlocation")
		Else
			' DISPLAY NOT AVAILABLE
			response.write ucase("<font color=red><B>" & dTemp & "-" & WeekDayName(WeekDay(dTemp)) &  " NOT AVAILABLE!</b></font><BR>")
		End If

		' ADD SPECIFIED WEEK FREQUENCY
		dTemp = DateAdd("ww",wfrequency,dTemp)
	Loop

End Sub


'--------------------------------------------------------------------------------------------------
'  SUB SETMONTHLYDATES(SSTARTDATE,SENDDATE,MSERIES,MFREQUENCY,MDAYOFTHEWEEK)
'--------------------------------------------------------------------------------------------------
Sub SetMonthlyDates(sStartDate,sEndDate,mseries,mfrequency,mdayoftheweek)

	' GET NEXT DATE OF SPECIFIED DAY OF WEEK (COULD BE START DATE BUT NOT ALWAYS)
	dTemp = GetNextOrdinalDayMonth(mdayoftheweek,mseries,Month(sStartDate),Year(sStartDate))

	' LOOP UNTIL END DATE
	Do While cdate(dTemp) <= cdate(sEndDate) 

		' IF SERIES IS GREATER THAN OR EQUAL THEN USE VALUE
		If Cdate(dTemp) >= Cdate(sStartDate)  Then

			' GET CURRENT STATUS OF TIMEPART AND DATE
			sStatus = GetTimePartStatus(request("L"),request("selTimePartID"),dTemp)
			
			' NOT RESERVED OR ONHOLD THEN MARK AVAILABLE
			If sStatus = "OPEN" or sStatus = "CANCELLED" Then
				' STORE RESERVATION INFORMATION
				iFacilityPaymentID = StoreFacilityInformationRecurrent(iOrgId,dTemp,dTemp)
				
				' UPDATE DATABASE
				UpdateFacilityPayment iFacilityPaymentID, "EGOVLINK_ADMIN","EGOVLINK_ADMIN","APPROVED","APPROVED",request("paymenttype"),request("paymentlocation")
			Else	
				' DISPLAY NOT AVAILABLE
				response.write ucase("<font color=red><B>" & dTemp & "-" & WeekDayName(WeekDay(dTemp)) &  " NOT AVAILABLE!</b></font><BR>")
			End If

		End If

		' ADD SPECIFIED MONTHLY FREQUENCY
		dTemp = DateAdd("m",mfrequency,dTemp)

		' GET NEXT DATE OF SPECIFIED DAY OF WEEK AND SERIES
		dTemp = GetNextOrdinalDayMonth(mdayoftheweek,mseries,Month(dTemp),Year(dTemp))
	Loop

End Sub


'--------------------------------------------------------------------------------------------------
'  SUB SETYEARLYDATES(SSTARTDATE,SENDDATE,YSERIES,YDAYOFTHEWEEK,YMONTH)
'--------------------------------------------------------------------------------------------------
Sub SetYearlyDates(sStartDate,sEndDate,yseries,ydayoftheweek,ymonth)

	' GET NEXT DATE OF SPECIFIED DAY OF WEEK (COULD BE START DATE BUT NOT ALWAYS)
	dTemp = GetNextOrdinalDayMonth(ydayoftheweek,yseries,ymonth,Year(sStartDate))


	' LOOP UNTIL END DATE
	Do While cdate(dTemp) <= cdate(sEndDate)
		
		' IF SERIES IS GREATER THAN OR EQUAL THEN USE VALUE
		If Cdate(dTemp) >= Cdate(sStartDate) Then
		
			' GET CURRENT STATUS OF TIMEPART AND DATE
			sStatus = GetTimePartStatus(request("L"),request("selTimePartID"),dTemp)
			
			' NOT RESERVED OR ONHOLD THEN MARK AVAILABLE
			If sStatus = "OPEN" or sStatus = "CANCELLED" Then
				' STORE RESERVATION INFORMATION
				iFacilityPaymentID = StoreFacilityInformationRecurrent(iOrgId,dTemp,dTemp)
				
				' UPDATE DATABASE
				UpdateFacilityPayment iFacilityPaymentID, "EGOVLINK_ADMIN","EGOVLINK_ADMIN","APPROVED","APPROVED",request("paymenttype"),request("paymentlocation")
			Else
				' DISPLAY NOT AVAILABLE
				response.write ucase("<font color=red><B>" & dTemp & "-" & WeekDayName(WeekDay(dTemp)) &  " NOT AVAILABLE!</b></font><BR>")
			End If

		End If

		' ADD SPECIFIED 1 TO YEAR
		dTemp = DateAdd("yyyy",1,dTemp)

		' GET NEXT DATE OF SPECIFIED DAY OF WEEK AND SERIES
		dTemp = GetNextOrdinalDayMonth(ydayoftheweek,yseries,Month(dTemp),Year(dTemp))
	Loop

End Sub


'--------------------------------------------------------------------------------------------------
'  FUNCTION GETNEXTWEEKDAY(IWEEKDAY,DTEMPDATE)
'--------------------------------------------------------------------------------------------------
Function GetNextWeekDay(iWeekDay,dTempdate)
  
  ' LOOP TO THE NEXT SPECIFIED DAY OF THE WEEK
  Do While Not  clng(WeekDay(dTempdate)) = clng(iWeekDay) 
	' ADD 1 DAY TO CURRENT DATE
	dTempdate = DateAdd("d",1,dTempdate)
 Loop

  ' RETURN SPECIFIED DATE
  GetNextWeekDay=dTempdate

End Function


'--------------------------------------------------------------------------------------------------
'  FUNCTION GETNEXTORDINALDAYMONTH(IWEEKDAY,IPOS,IMONTH,IYEAR)
'--------------------------------------------------------------------------------------------------
Function GetNextOrdinalDayMonth(iWeekDay,ipos,iMonth,iYear)

	' INITIALIZE DATE VALUES
	dTemp = cdate(iMonth & "/1/" &iYear)
	dReturnValue = dTemp

	' PERFORM DATE LOOKUP BASED ON ORDINAL POSITION
	Select Case ipos

		Case 1
			
			' FIRST OCCURRENCE
			 Do While Not  clng(WeekDay(dTemp)) = clng(iWeekDay) 
				' ADD 1 DAY TO CURRENT DATE
				dTemp = DateAdd("d",1,dTemp)
			 Loop

			 dReturnValue = dTemp

		Case 2

			' SECOND OCCURRENCE
			 Do While iCount < 1
				' ADD 1 DAY TO CURRENT DATE
				dTemp = DateAdd("d",1,dTemp)

				' FOUND DAY OF WEEK MATCH
				If (clng(WeekDay(dTemp)) = clng(iWeekDay)) Then
					iCount = iCount + 1 ' ADD 1 TO OCCURENCE COUNT
					dReturnValue = dTemp
				End If
			 Loop

			 

		Case 3
			
			' THIRD OCCURRENCE
			 Do While iCount < 2
				' ADD 1 DAY TO CURRENT DATE
				dTemp = DateAdd("d",1,dTemp)

				' FOUND DAY OF WEEK MATCH
				If (clng(WeekDay(dTemp)) = clng(iWeekDay)) Then
					iCount = iCount + 1 ' ADD 1 TO OCCURENCE COUNT
					dReturnValue = dTemp
				End If
			 Loop

			 

		Case 4

			' FOURTH OCCURRENCE
			 Do While iCount < 3
				' ADD 1 DAY TO CURRENT DATE
				dTemp = DateAdd("d",1,dTemp)

				' FOUND DAY OF WEEK MATCH
				If (clng(WeekDay(dTemp)) = clng(iWeekDay)) Then
					iCount = iCount + 1 ' ADD 1 TO OCCURENCE COUNT
					dReturnValue = dTemp
				End If
			 Loop

			 

		Case 5

			datNextMonth = dateAdd("m",1,dTemp)

			' LAST OCCURRENCE
			 Do While iCount < 5 AND (cdate(dtemp) < cdate(datNextMonth))
				' ADD 1 DAY TO CURRENT DATE
				dTemp = DateAdd("d",1,dTemp)
				
				' FOUND DAY OF WEEK MATCH
				If (clng(WeekDay(dTemp)) = clng(iWeekDay)) Then
					iCount = iCount + 1 ' ADD 1 TO OCCURENCE COUNT
					dReturnValue = dTemp
				End If
			 Loop

			

	End Select

	' RETURN DATE VALUE
	GetNextOrdinalDayMonth = dReturnValue

End Function


'--------------------------------------------------------------------------------------------------
' SUB PROCESSRECURRENT()
'--------------------------------------------------------------------------------------------------
Sub ProcessRecurrent()

	' RECURRENCE TEST
	sStartDate = request("checkindate")
	sEndDate = request("recurrentenddate")
	
	' WEEKLY VALUES
	wfrequency = request("wfrequencynumber")
	wdayoftheweek = request("wdayofweek")

	' MONTHLY VALUES
	mseries = request("mseries")
	mfrequency = request("mfrequencynumber")
	mdayoftheweek = request("mdayofweek")

	' YEARLY TEST VALUES
	yseries = request("yseries")
	ydayoftheweek = request("ydayofweek")
	ymonth = request("ymonth")


	' CALL ROUTINE TO CREATE SERIES
	Select Case request("wrecurrenttimepart")
	
		Case "weekly"
			' CALL WEEKLY DATES
			Call SetWeeklyDates(sStartDate,sEndDate,wfrequency,wdayoftheweek)

		Case "monthly"
			' CALL MONTHLY DATES
			Call SetMonthlyDates(sStartDate,sEndDate,mseries,mfrequency,mdayoftheweek)

		Case "yearly"
			' CALL YEARLY DATES
			Call SetYearlyDates(sStartDate,sEndDate,yseries,ydayoftheweek,ymonth)

	End Select

End Sub


'--------------------------------------------------------------------------------------------------
' FUNCTION GETTIMEPARTSTATUS(IFACILITYID,ITIMEPARTID,STIMERANGE)
'--------------------------------------------------------------------------------------------------
Function GetTimePartStatus(iFacilityid,itimepartid,datDate)

	sReturnValue= "OPEN"

	' GET STATUS OF THIS TIME PART FROM SQL IF AVAILABLE
	sSQL = "Select distinct status FROM egov_facilityschedule where facilityid = '" & iFacilityId & "' AND facilitytimepartid='" & itimepartid & "' AND checkindate='" & datDate & "'"
	Set oStatus = Server.CreateObject("ADODB.Recordset")
	oStatus.Open sSQL, Application("DSN"), 3, 1
	
	' IF RESERVATION HAS BEEN MADE FOR THIS TIME PART GET ITS STATUS
	If not oStatus.EOF Then
		sReturnValue = oStatus("status")
	End If

	' CLEAN UP OBJECTS
	Set oStatus = Nothing
	
	' RETURN STATUS
	GetTimePartStatus = sReturnValue

End Function


'------------------------------------------------------------------------------------------------------------
' FUNCTION STOREFACILITYINFORMATIONRECURRENT(IORGID,CHECKINDATE,CHECKOUTDATE)
'------------------------------------------------------------------------------------------------------------
Function StoreFacilityInformationRecurrent(iOrgID,checkindate,checkoutdate)
		
		iReturnValue = 0

		Set oCmd = Server.CreateObject("ADODB.Command")
		 With oCmd
		.ActiveConnection = Application("DSN")
		.CommandText = "StoreFacilityInformationRecurrent"
		.CommandType = 4

		' RESERVATION INFORMATION
		.Parameters.Append oCmd.CreateParameter("checkintime", 200, 1, 50, request("checkintime"))
		.Parameters.Append oCmd.CreateParameter("checkindate", 200, 1, 50, checkindate)
		.Parameters.Append oCmd.CreateParameter("checkouttime", 200, 1, 50, request("checkouttime"))
		.Parameters.Append oCmd.CreateParameter("checkoutdate", 200, 1, 50, checkoutdate)
		.Parameters.Append oCmd.CreateParameter("lesseeid", 3, 1, 4, request("lesseeid"))
		.Parameters.Append oCmd.CreateParameter("facilitytimepartid", 3, 1, 4, request("timepartid"))
		.Parameters.Append oCmd.CreateParameter("facilityid", 3, 1, 4, request("facilityid"))
		.Parameters.Append oCmd.CreateParameter("orgid", 3, 1, 4, iOrgID)
		.Parameters.Append oCmd.CreateParameter("amount", 3, 1, 4, request("amount"))
		.Parameters.Append oCmd.CreateParameter("irecurrentid", 3, 1, 4, request("irecurrentid"))
		.Parameters.Append oCmd.CreateParameter("facilitypaymentid", 3, 2, 4)

		' CALL TO STORE VALUE INFORMATION
		.Execute

		iFacilityPaymentID = .Parameters("facilitypaymentid")
		
		If iFacilityPaymentID <> "" Then
			iReturnValue = iFacilityPaymentID
		End If

		' STORE FIELD VALUES
		StoreFacilityFieldValues(iFacilityPaymentID)

     End With

	 Set oCmd = Nothing

	StoreFacilityInformationRecurrent = iReturnValue
	 

End Function


'--------------------------------------------------------------------------------------------------
' Sub ShowUserInfo( iUserId )
'--------------------------------------------------------------------------------------------------
Sub ShowUserInfo( iUserId )
	Dim oCmd, sResidentDesc, sUserType

'	sUserType = GetUserResidentType(iUserid)
'	' If they are not one of these (R, N), we have to figure which they are
'	If sUserType <> "R" And sUserType <> "N" Then
'		' This leaves E and B - See if they are a resident, also
'		sUserType = GetResidentTypeByAddress(iUserid, Session("OrgID"))
'	End If 

'	sResidentDesc = GetResidentTypeDesc(sUserType)

	Set oCmd = Server.CreateObject("ADODB.Command")
	With oCmd
		.ActiveConnection = Application("DSN")
	    .CommandText = "GetEgovUserInfoList"
	    .CommandType = 4
		.Parameters.Append oCmd.CreateParameter("@iUserId", 3, 1, 4, iUserId)
	    Set oUser = .Execute
	End With

	response.write vbcrlf & "<div class=""purchasereportshadow"">"
	response.write vbcrlf & "<table border=""0"" cellpadding=""3"" cellspacing=""0"" class=""purchasereport"">"
	response.write vbcrlf & "<tr><th colspan=""2"" align=""left"">Purchaser Contact Information</th></tr>"
	response.write vbcrlf & "<tr><td width=""20%"" valign=""top"">Name:</td><td>" & oUser("userfname") & " " & oUser("userlname")
'	response.write "<br /><strong>" & sResidentDesc & "</strong>"
	response.write "</td></tr>"
	response.write vbcrlf & "<tr><td>Email:</td><td>" & oUser("useremail") & "</td></tr>"
	response.write vbcrlf & "<tr><td>Phone:</td><td>" & FormatPhone(oUser("userhomephone")) & "</td></tr>"
	response.write vbcrlf & "<tr><td valign=""top"">Address:</td><td>" & oUser("useraddress") & "<br />" 
	If oUser("useraddress2") = "" Then 
		response.write oUser("useraddress2") & "<br />" 
	End If 
	response.write oUser("usercity") & ", " & oUser("userstate") & " " & oUser("userzip") & "</td></tr>"
	response.write vbcrlf & "</table></div>"

	oUser.close
	Set oUser = Nothing
	Set oCmd = Nothing
	
End Sub 


'--------------------------------------------------------------------------------------------------
' Function FormatPhone( Number )
'--------------------------------------------------------------------------------------------------
Function FormatPhone( Number )
	If Len(Number) = 10 Then
		FormatPhone = "(" & Left(Number,3) & ") " & Mid(Number, 4, 3) & "-" & Right(Number,4)
	Else
		FormatPhone = Number
	End If
End Function


%>


