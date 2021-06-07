<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- #include file="../includes/common.asp" //-->
<!-- #include file="../includes/time.asp" //-->
<%
'------------------------------------------------------------------------------
'
'------------------------------------------------------------------------------
' FILENAME: account_distribution.asp
' AUTHOR: Steve Loar
' CREATED: 07/19/07
' COPYRIGHT: Copyright 2007 eclink, inc.
'			 All Rights Reserved.
'
' Description:  
'
' MODIFICATION HISTORY
' 1.0   7/19/07		Steve Loar - INITIAL VERSION
'
'------------------------------------------------------------------------------
'
'------------------------------------------------------------------------------
Dim iLocationId, iAdminUserId, iPaymentLocationId, iReportType, sRptTitle, sRptType, iAccountNo, bOrgHasAccounts

' INITIALIZE AND DECLARE VARIABLES
' SPECIFY FOLDER LEVEL
sLevel = "../" ' Override of value from common.asp

' USER SECURITY CHECK
PageDisplayCheck "account distribution new", sLevel	' In common.asp

' PROCESS REPORT FILTER VALUES
' PROCESS DATE VALUES

fromDate = Request("fromDate")
toDate = Request("toDate")
today = Date()

' IF EMPTY DEFAULT TO CURRENT TO DATE
If toDate = "" or IsNull(toDate) Then
	toDate = today 
End If

If fromDate = "" or IsNull(fromDate) Then 
	'fromDate = cdate(Month(today)& "/1/" & Year(today)) 
	fromDate = today
End If

If request("locationid") = "" Then
	iLocationId = 0
Else
	iLocationId = CLng(request("locationid"))
End If 

If request("accountid") = "" Then
	iAccountNo = 0
Else
	iAccountNo = CLng(request("accountid"))
End If 

If request("adminuserid") = "" Then
	iAdminUserId = 0
Else
	iAdminUserId = CLng(request("adminuserid"))
End If 

If request("paymentlocationid") = "" Then
	iPaymentLocationId = 0
Else
	iPaymentLocationId = CLng(request("paymentlocationid"))
End If 

If request("reporttype") = "" Then 
	iReportType = CLng(1)
Else
	iReportType = CLng(request("reporttype"))
End If 

If iReportType = CLng(1) Then
	sRptTitle = "Summary"
	sRptType = "Summary"
Else
	sRptTitle = "Detail"
	sRptType = "Detail"
End If 

If request("journalentrytypeid") = "" Then
	iJournalEntryTypeId = 0
Else
	iJournalEntryTypeId = CLng(request("journalentrytypeid"))
End If 

' BUILD SQL WHERE CLAUSE
varWhereClause = " AND (P.paymentDate >= '" & fromDate & "' AND P.paymentDate <= '" & DateAdd("d",1,toDate) & "') "
varWhereClause = varWhereClause & " AND A.orgid = " & session("orgid") 
If iLocationId > 0 Then
	varWhereClause = varWhereClause & " AND P.adminlocationid = " & iLocationId
End If 

If iAdminUserId > 0 Then
	varWhereClause = varWhereClause & " AND adminuserid = " & iAdminUserId
End If 

If iPaymentLocationId > 0 Then
	If iPaymentLocationId = CLng(2) Then
		varWhereClause = varWhereClause & " AND P.paymentlocationid = 3 " 
	Else
		varWhereClause = varWhereClause & " AND P.paymentlocationid < 3 " 
	End If 
End If 

If iJournalEntryTypeId > 0 Then 
	varWhereClause = varWhereClause & " AND P.journalentrytypeid = " & iJournalEntryTypeId
End If 

If CLng(iAccountNo) > CLng(0) Then
	varWhereClause = varWhereClause & " AND A.accountid = " & iAccountNo & " "
End If 

' Not every org has general ledger accounts so we need to be able to hide/show accordingly.
bOrgHasAccounts = OrgHasFeature("gl accounts")


%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<title>E-Gov Administration Console {Account Distribution Report}</title>

	<link rel="stylesheet" type="text/css" href="../menu/menu_scripts/menu.css" />
	<link rel="stylesheet" type="text/css" href="../global.css" />
	<link rel="stylesheet" type="text/css" href="../classes/classes.css" />
	<link rel="stylesheet" type="text/css" href="reporting.css" />
	<link rel="stylesheet" type="text/css" href="pageprint.css" media="print" />

	<script language="JavaScript" src="../scripts/jquery-1.7.2.min.js"></script>

	<script language="Javascript" src="../scripts/getdates.js"></script>
	<script language="Javascript" src="../scripts/isvaliddate.js"></script>
	<script language="javascript" src="../scripts/formvalidation_msgdisplay.js"></script>

	<script language="Javascript">
	<!--

		$(document).ready(function() {
			$('#fromDateCal').click(function() {
				eGovLink.Reporting.doCalendar('fromDate');
				});
			$('#toDateCal').click(function() {
				eGovLink.Reporting.doCalendar('toDate');
				});
		});

		// create the egov NameSpace
		var eGovLink = eGovLink || {}; 

		// create the Reporting sub-NameSpace with the methods inside
		eGovLink.Reporting = (function () {

			var doCalendar = function( ToFrom ) 
			{
				w = (screen.width - 350)/2;
				h = (screen.height - 350)/2;
				//eval('window.open("../recreation/gr_calendarpicker.asp?p=1&ToFrom=' + ToFrom + '", "_calendar", "width=350,height=250,toolbar=0,statusbar=0,scrollbars=1,menubar=0,left=' + w + ',top=' + h + '")');
				eval('window.open("calendarpicker.asp?updatefield=' + ToFrom + '&date=' + $("#" + ToFrom ).val() + '", "_calendar", "width=350,height=250,toolbar=0,statusbar=0,scrollbars=1,menubar=0,left=' + w + ',top=' + h + '")');
			}

			var validate = function( _Action )
			{
				var okToPost = true; 

				// check to date
				if ($("#toDate").val() != "")
				{
					if ( ! isValidDate( $("#toDate").val() ) )
					{
						inlineMsg("toDate",'<strong>Invalid Value: </strong>The "To" date should be in the format of MM/DD/YYYY.',8,"toDate");
						okToPost = false;
					}
				}

				// check from date
				if ($("#fromDate").val() != "")
				{
					if ( ! isValidDate( $("#fromDate").val() ) )
					{
						inlineMsg("fromDate",'<strong>Invalid Value: </strong>The "From" date should be in the format of MM/DD/YYYY.',8,"fromDate");
						okToPost = false;
					}
				}

				if (_Action === 'export')
				{
					document.reportFilter.action = "account_distribution_new_export.asp";
				}
				else
				{
					document.reportFilter.action = "account_distribution_new.asp";
				}

				if (okToPost)
				{
					document.reportFilter.submit();
				}
			}

			// This makes the functions publically accessible
			return {
				doCalendar: doCalendar,
				validate: validate
				};

		}());


	//-->
	</script>


</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">

<% ShowHeader sLevel %>
<!--#Include file="../menu/menu.asp"--> 

<div id="idControls" class="noprint">
	<input type="button" class="button" onclick="javascript:window.print();" value="Print" />
</div>

<!--BEGIN PAGE CONTENT-->
<div id="content">
	<div id="centercontent">

<form action="account_distribution_new.asp" method="post" name="reportFilter">

	<table border="0" cellpadding="10" cellspacing="0" class="start" width="100%">
		<tr>
			<td><font size="+1"><strong>Account Distribution <%=sRptTitle%></strong></font></td>
		</tr>
		<tr>
			<td>
				<fieldset>
					<legend><strong>Select</strong></legend>
				
					<!--BEGIN: FILTERS-->
					<!--BEGIN: DATE FILTERS-->
					<p>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><strong>Payment Date: </strong></td>
							<td>
								<input type="text" id="fromDate" name="fromDate" value="<%=fromDate%>" size="10" maxlength="10" />
								<a id="fromDateCal" href="#"><img src="../images/calendar.gif" border="0" /></a>		 
							</td>
							<td>&nbsp;</td>
							<td>
								<strong>To:</strong>
							</td>
							<td>
								<input type="text" id="toDate" name="toDate" value="<%=toDate%>" size="10" maxlength="10" />
								<a id="toDateCal" href="#"><img src="../images/calendar.gif" border="0" /></a>
							</td>
							<td>&nbsp;</td>
							<td><%DrawDateChoices "Date" %></td>
						</tr>
					</table>
					</p>
					<!--END: DATE FILTERS-->
					<p>
						<strong>Admin Location: </strong><% ShowAdminLocations iLocationId %>&nbsp;&nbsp;
						<strong>Admin: </strong><% ShowAdminUsers iAdminUserId %>
					</p>
					<p>
						<strong>Payment Location: </strong><% ShowPaymentLocations iPaymentLocationId %>&nbsp;&nbsp;
						<strong>Report Type: </strong><% ShowReportTypes iReportType %>&nbsp;&nbsp;
						<strong>Entries: </strong><% ShowJournalEntryTypes iJournalEntryTypeId %>
					</p>
<%					If bOrgHasAccounts Then		%>
						<p>
							<strong>GL Account: </strong>
<%
							ShowAccountPicks "accountid", iAccountNo, True 
%>
						</p>
<%					Else
						response.write "<input type=""hidden"" id=""accountid"" name=""accountid"" value=""0"" />"
					End If 
%>

					<p>
						<input class="button" type="button" value="View Report" onClick="eGovLink.Reporting.validate('screen');" />
						&nbsp;&nbsp;<input type="button" class="button" value="Download to Excel" onClick="eGovLink.Reporting.validate('export');" />
					</p>

				</fieldset>
				<!--END: FILTERS-->
		    </td>
		</tr>
		<tr>
 
			<td colspan="3" valign="top">
	  
				<!--BEGIN: DISPLAY RESULTS-->
				<%
				
				If sRptType = "Detail" Then
					DisplayDetails varWhereClause
				Else
					DisplaySummary varWhereClause
				End If 
				
				%>
				<!-- END: DISPLAY RESULTS -->
      
			</td>
		 </tr>
	</table>
  </form>
	</div>
</div>
<!--END: PAGE CONTENT-->

<!--#Include file="../admin_footer.asp"-->  

</body>
</html>


<%
'------------------------------------------------------------------------------------------------------------
' DrawDateChoices sName
'------------------------------------------------------------------------------------------------------------
Sub DrawDateChoices( ByVal sName )

	response.write vbcrlf & "<select onChange=""getDates(this.value, '" & sName & "');"" class=""calendarinput"" name=""" & sName & """>"
	response.write vbcrlf & "<option value=""0"">Or Select Date Range from Dropdown...</option>" 
	response.write vbcrlf & "<option value=""11"">This Week</option>"
	response.write vbcrlf & "<option value=""12"">Last Week</option>"
	response.write vbcrlf & "<option value=""1"">This Month</option>"
	response.write vbcrlf & "<option value=""2"">Last Month</option>" 
	response.write vbcrlf & "<option value=""3"">This Quarter</option>" 
	response.write vbcrlf & "<option value=""4"">Last Quarter</option>"
	response.write vbcrlf & "<option value=""6"">Year to Date</option>"
	response.write vbcrlf & "<option value=""5"">Last Year</option>"
	response.write vbcrlf & "<option value=""7"">All Dates to Date</option>"
	response.write vbcrlf & "</select>"

End Sub


'------------------------------------------------------------------------------
' DisplaySummary sWhereClause
'------------------------------------------------------------------------------
Sub DisplaySummary( ByVal sWhereClause )
	Dim sSql, oRs, oDisplay, iOldAccountId, dTotal, dTotalCredit, dTotalDebit, dGrandTotal, bHasData

	iOldAccountId = CLng(0) 
	dTotal = CDbl(0.00)
	dTotalCredit = CDbl(0.00)
	dTotalDebit = CDbl(0.00)
	dGrandTotal = CDbl(0.00)
	bHasData = False 

	' Got some data now make a holding recordset
	Set oDisplay = server.CreateObject("ADODB.RECORDSET") 
	oDisplay.fields.append "accountid", adInteger, , adFldUpdatable
	oDisplay.fields.append "accountname", adVarChar, 50, adFldUpdatable
	oDisplay.fields.append "accountnumber", adVarChar, 20, adFldUpdatable
	oDisplay.fields.append "creditamt", adCurrency, , adFldUpdatable
	oDisplay.fields.append "debitamt", adCurrency, , adFldUpdatable
	oDisplay.fields.append "totalamt", adCurrency, , adFldUpdatable
	oDisplay.fields.append "ispaymentaccount", adBoolean, , adFldUpdatable
	oDisplay.fields.append "iscitizenaccount", adBoolean, , adFldUpdatable

	oDisplay.CursorLocation = 3
	'oDisplay.CursorType = 3

	oDisplay.open 

	' Pull all account data except the citizen accounts
	sSql = "SELECT A.accountname, A.accountnumber, A.accountid, L.entrytype, L.ispaymentaccount, 0 AS iscitizenaccount, "
	sSql = sSql & "SUM(L.amount) AS amount "
	sSql = sSql & " FROM egov_accounts A, egov_accounts_ledger L, egov_class_payment P "
	sSql = sSql & " WHERE A.accountid = L.accountid AND L.paymentid = P.paymentid "
	sSql = sSql & " AND L.amount >= 0.00 AND P.isforrentals = 0 AND P.journalentrytypeid < 5 " & sWhereClause
	sSql = sSql & " GROUP BY A.accountname, A.accountnumber, A.accountid, L.entrytype, L.ispaymentaccount "
	sSql = sSql & " ORDER BY A.accountid, L.entrytype"
'	response.write sSql & "<br /><br />"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open sSql, Application("DSN"), 0, 1

	If Not oRs.EOF Then 
		bHasData = True 

		' Loop through and build the display recordset.
		Do While Not oRs.EOF
			If CLng(oRs("accountid")) <> iOldAccountId Then
				oDisplay.addnew 
				oDisplay("accountid")        = oRs("accountid")
				oDisplay("accountname")      = oRs("accountname") 
				oDisplay("accountnumber")    = oRs("accountnumber")
				oDisplay("ispaymentaccount") = oRs("ispaymentaccount")
				oDisplay("iscitizenaccount") = oRs("iscitizenaccount") 
				If sRptType = "Detail" Then
  					oDisplay("paymentid") = oRs("paymentid")
				End If 
				oDisplay("creditamt") = 0.00
				oDisplay("debitamt") = 0.00
				oDisplay("totalamt") = 0.00
				iOldAccountId = CLng(oRs("accountid"))
			End If 
			If oRs("entrytype") = "credit" Then
				oDisplay("creditamt") = CDbl(oRs("amount"))
				'dTotal = CDbl(oRs("amount"))
				oDisplay("totalamt") = CDbl(oDisplay("totalamt")) + CDbl(oRs("amount"))
			End If 
			If oRs("entrytype") = "debit" Then
				oDisplay("debitamt") = -CDbl(oRs("amount"))
				'dTotal = -CDbl(oRs("amount"))
				oDisplay("totalamt") = CDbl(oDisplay("totalamt")) - CDbl(oRs("amount"))
			End If 
				
			oDisplay.Update
			oRs.MoveNext
		Loop
	End If 

	oRs.Close
	Set oRs = Nothing 

	'Get the citizen accounts summary here - These are payments for classes only
	sSql = "SELECT A.accountname, A.accountnumber, A.accountid, L.entrytype, L.ispaymentaccount, 1 AS iscitizenaccount, "
	sSql = sSql & " SUM(L.amount) AS amount "
	sSql = sSql & " FROM egov_accounts A, egov_accounts_ledger L, egov_class_payment P, egov_organizations_to_paymenttypes OP "
	sSql = sSql & " WHERE L.paymentid = P.paymentid AND L.paymenttypeid = 4 AND P.isforrentals = 0 AND P.journalentrytypeid = 1 "
	sSql = sSql & " AND A.accountid = OP.accountid AND OP.paymenttypeid = L.paymenttypeid "
	sSql = sSql & " AND OP.orgid = P.orgid " & sWhereClause 
	sSql = sSql & " GROUP BY A.accountname, A.accountnumber, A.accountid, L.entrytype, L.ispaymentaccount "
	sSql = sSql & " ORDER BY A.accountid, L.entrytype"
	'response.write sSql & "<br /><br />"
	'response.end

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open sSql, Application("DSN"), 0, 1

	If Not oRs.EOF then
		bHasData = True 

		' Loop through and build the display recordset.
		Do While Not oRs.EOF
			If CLng(oRs("accountid")) <> iOldAccountId Then
				oDisplay.addnew 
				oDisplay("accountid") = oRs("accountid")
				oDisplay("accountname") = oRs("accountname") 
				oDisplay("accountnumber") = oRs("accountnumber")
				'oDisplay("ispaymentaccount") = oRs("ispaymentaccount")
				'oDisplay("iscitizenaccount") = oRs("iscitizenaccount")
				oDisplay("ispaymentaccount") = True 
				oDisplay("iscitizenaccount") = True 
				If sRptType = "Detail" Then
					oDisplay("paymentid") = oRs("paymentid")
				End If 
				oDisplay("creditamt") = 0.00
				oDisplay("debitamt") = 0.00
				oDisplay("totalamt") = 0.00
				iOldAccountId = CLng(oRs("accountid"))
			End If 
			If oRs("entrytype") = "credit" Then
				oDisplay("creditamt") = oDisplay("creditamt") + CDbl(oRs("amount"))
				'dTotal = CDbl(oRs("amount"))
				oDisplay("totalamt") = CDbl(oDisplay("totalamt")) + CDbl(oRs("amount"))
			End If 
			If oRs("entrytype") = "debit" Then
				oDisplay("debitamt") = oDisplay("debitamt") - CDbl(oRs("amount"))
				'dTotal = -CDbl(oRs("amount"))
				oDisplay("totalamt") = CDbl(oDisplay("totalamt")) - CDbl(oRs("amount"))
			End If 
				
			oDisplay.Update
			oRs.MoveNext
		Loop
	End If 

	oRs.Close
	Set oRs = Nothing 
		
	If bHasData Then 
		'sort the Display recordset
		oDisplay.Sort = "ispaymentaccount DESC, iscitizenaccount ASC, accountname ASC, accountnumber ASC "

		' Show results
		oDisplay.MoveFirst
		'response.write vbcrlf & "<div class=""receiptpaymentshadow"">"
		response.Write vbcrlf & "<table cellspacing=""0"" cellpadding=""2"" border=""0"" width=""100%"" class=""receiptpayment"">"
		response.write vbcrlf & "<tr class=""tablelist"">" 
		response.write "<th>Account Name</th><th>Account Number</th><th>Total Amt<br />Credited</th>" 
		response.write "<th>Total Amt<br />Debited</th><th>Total Amt<br />Transfered</th></tr>" 

		bgcolor = "#eeeeee"
		Do While Not oDisplay.EOF
			bgcolor = changeBGColor(bgcolor,"#eeeeee","#ffffff")

			response.write vbcrlf & "<tr bgcolor=""" &  bgcolor  & """>" & vbcrlf
			response.write "<td align=""left"">"   & oDisplay("accountname")                & "</td>"
			response.write "<td align=""center"">" & oDisplay("accountnumber")              & "</td>"
			response.write "<td align=""right"">"  & FormatNumber(oDisplay("creditamt"), 2) & "</td>"
			response.write "<td align=""right"">"  & FormatNumber(oDisplay("debitamt"), 2)  & "</td>" 
			response.write "<td align=""right"">"  & FormatNumber(oDisplay("totalamt"), 2)  & "</td>" 

			dTotalCredit = dTotalCredit + CDbl(oDisplay("creditamt"))
			dTotalDebit  = dTotalDebit  + CDbl(oDisplay("debitamt"))
			dGrandTotal  = dGrandTotal  + dTotalCredit - dTotalDebit

			response.write "</tr>" 
			oDisplay.MoveNext
		Loop 

		'Totals Row
		response.write vbcrlf & "<tr class=""totalrow"">" 
		response.write "<td colspan=""2"" align=""right"">Totals:</td>"
		response.write "<td align=""right"">" & FormatNumber(dTotalCredit, 2)                & "</td>"
		response.write "<td align=""right"">" & FormatNumber(dTotalDebit, 2)                 & "</td>"
		response.write "<td align=""right"">" & FormatNumber((dTotalCredit + dTotalDebit),2) & "</td>" 
		response.write "</tr>"

		response.write vbcrlf & "</table>" 
		'response.write vbcrlf & "</div>" 

	Else
		response.write "<p>No information could be found for the criteria selected.</p>"
	End If 


	oDisplay.Close
	Set oDisplay = Nothing 

End Sub 


'------------------------------------------------------------------------------
' DisplayDetails sWhereClause
'------------------------------------------------------------------------------
Sub DisplayDetails( ByVal sWhereClause )
	Dim sSql, oRs, oDisplay, iOldAccountId, iOldPaymentId, dTotal, dTotalCredit, dTotalDebit, dGrandTotal, bHasData

	iOldAccountId = CLng(0) 
	iOldPaymentId = CLng(0)
	dTotal = CDbl(0.00)
	dTotalCredit = CDbl(0.00)
	dTotalDebit = CDbl(0.00)
	dGrandTotal = CDbl(0.00)
	bHasData = False 

	' Got some data now make a holding recordset
	Set oDisplay = server.CreateObject("ADODB.RECORDSET") 
	oDisplay.fields.append "accountid", adInteger, , adFldUpdatable
	oDisplay.fields.append "accountname", adVarChar, 50, adFldUpdatable
	oDisplay.fields.append "accountnumber", adVarChar, 20, adFldUpdatable
	oDisplay.fields.append "receiptno", adInteger, , adFldUpdatable
	oDisplay.fields.append "paymentdate", adDBTimeStamp, , adFldUpdatable
	oDisplay.fields.append "paymenttypeid", adInteger, , adFldUpdatable
	oDisplay.fields.append "journalentrytypeid", adInteger, , adFldUpdatable
	oDisplay.fields.append "userid", adInteger, , adFldUpdatable
	oDisplay.fields.append "creditamt", adCurrency, , adFldUpdatable
	oDisplay.fields.append "debitamt", adCurrency, , adFldUpdatable
	oDisplay.fields.append "totalamt", adCurrency, , adFldUpdatable
	oDisplay.fields.append "ispaymentaccount", adBoolean, , adFldUpdatable
	oDisplay.fields.append "iscitizenaccount", adBoolean, , adFldUpdatable

	oDisplay.CursorLocation = 3
	'oDisplay.CursorType = 3

	oDisplay.Open 

	sSql = "SELECT A.accountname, A.accountnumber, A.accountid, L.entrytype, P.paymentid, L.amount, P.paymentdate, "
	sSql = sSql & " ISNULL(L.paymenttypeid,0) AS paymenttypeid, ISNULL(P.userid,0) AS userid, P.journalentrytypeid, L.ispaymentaccount, 0 AS iscitizenaccount "
	sSql = sSql & " FROM egov_accounts A, egov_accounts_ledger L, egov_class_payment P "
	sSql = sSql & " WHERE A.accountid = L.accountid AND L.paymentid = P.paymentid "
	sSql = sSql & " AND L.amount <> 0.00 AND P.isforrentals = 0 AND P.journalentrytypeid < 5 " & sWhereClause 
	sSql = sSql & " ORDER BY A.accountid, P.paymentid, L.entrytype"
	'response.write sSql & "<br /><br />"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open sSql, Application("DSN"), 0, 1

	If Not oRs.EOF Then
		bHasData = True 
		' Loop through and build the display recordset.
		Do While Not oRs.EOF
			If CLng(oRs("accountid")) <> iOldAccountId Or CLng(oRs("paymentid")) <> iOldPaymentId Then
				oDisplay.addnew 
				oDisplay("accountid")        = oRs("accountid")
				oDisplay("accountname")      = oRs("accountname")
				oDisplay("accountnumber")    = oRs("accountnumber")
				oDisplay("ispaymentaccount") = oRs("ispaymentaccount")

				If oRs("accountname") = "Citizen Accounts" Then 
  					oDisplay("iscitizenaccount") = True 
				Else  
		  			oDisplay("iscitizenaccount") = False 
				End If 

				oDisplay("receiptno")          = oRs("paymentid")
				oDisplay("paymentdate")        = oRs("paymentdate")
				oDisplay("paymenttypeid")      = oRs("paymenttypeid")
				oDisplay("journalentrytypeid") = oRs("journalentrytypeid")
				'Response.write "[" & oRs("userid") & "]<br />"
				oDisplay("userid")             = oRs("userid")
				oDisplay("creditamt")          = CDbl(0.00)
				oDisplay("debitamt")           = CDbl(0.00)
				oDisplay("totalamt")           = CDbl(0.00)
				iOldAccountId                  = CLng(oRs("accountid"))
				iOldPaymentId                  = CLng(oRs("paymentid"))
			End If 

			If oRs("entrytype") = "credit" Then
  				oDisplay("creditamt") = oDisplay("creditamt") + CDbl(oRs("amount"))
		  		oDisplay("totalamt")  = oDisplay("totalamt")  + CDbl(oRs("amount"))
			End If 

			If oRs("entrytype") = "debit" Then
  				oDisplay("debitamt") = oDisplay("debitamt") - CDbl(oRs("amount"))
		  		oDisplay("totalamt") = oDisplay("totalamt") - CDbl(oRs("amount"))
			End If 
			oDisplay.Update
			oRs.MoveNext
		Loop
	End If 
	oRs.Close 
	Set oRs = Nothing 

	'Citizen Accounts  - These are payments for classes only
	sSql = "SELECT A.accountname, A.accountnumber, A.accountid, L.entrytype, P.paymentid, L.amount, P.paymentdate, "
	sSql = sSql & " ISNULL(L.paymenttypeid,0) AS paymenttypeid, P.userid, P.journalentrytypeid, L.ispaymentaccount, 1 AS iscitizenaccount "
	sSql = sSql & " FROM egov_accounts_ledger L, egov_class_payment P, egov_accounts A, egov_organizations_to_paymenttypes OP "
	sSql = sSql & " WHERE L.paymentid = P.paymentid "
	sSql = sSql & " AND L.paymenttypeid = 4 AND P.isforrentals = 0 AND P.journalentrytypeid = 1 "
	sSql = sSql & " AND A.accountid = OP.accountid "
	sSql = sSql & " AND OP.paymenttypeid = L.paymenttypeid "
	sSql = sSql & " AND OP.orgid = P.orgid "
	sSql = sSql & sWhereClause 
	sSql = sSql & " ORDER BY A.accountid, P.paymentid, L.entrytype"
	'response.write sSql & "<br /><br />"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open sSql, Application("DSN"), 0, 1

	If Not oRs.EOF Then
		bHasData = True 
		iOldAccountId = CLng(0)

		' Loop through and build the display recordset.
		Do While Not oRs.EOF
			If CLng(oRs("accountid")) <> iOldAccountId Or CLng(oRs("paymentid")) <> iOldPaymentId Then
				oDisplay.addnew 
				oDisplay("accountid")          = oRs("accountid")
				oDisplay("accountname")        = oRs("accountname") 
				oDisplay("accountnumber")      = oRs("accountnumber")
				oDisplay("ispaymentaccount")   = True 
				oDisplay("iscitizenaccount")   = True 
				oDisplay("receiptno")          = oRs("paymentid")
				oDisplay("paymentdate")        = oRs("paymentdate")
				oDisplay("paymenttypeid")      = oRs("paymenttypeid")
				oDisplay("journalentrytypeid") = oRs("journalentrytypeid")
				oDisplay("userid")             = oRs("userid")
				oDisplay("creditamt")          = CDbl(0.00)
				oDisplay("debitamt")           = CDbl(0.00)
				oDisplay("totalamt")           = CDbl(0.00)
				iOldAccountId                  = CLng(oRs("accountid"))
				iOldPaymentId                  = CLng(oRs("paymentid"))
			End If 

			If oRs("entrytype") = "credit" Then
 				oDisplay("creditamt") = oDisplay("creditamt") + CDbl(oRs("amount"))
		   	oDisplay("totalamt")  = oDisplay("totalamt")  + CDbl(oRs("amount"))
			End If 

			If oRs("entrytype") = "debit" Then
  				oDisplay("debitamt") = oDisplay("debitamt") - CDbl(oRs("amount"))
		  		oDisplay("totalamt") = oDisplay("totalamt") - CDbl(oRs("amount"))
			End If 
			oDisplay.Update
			oRs.MoveNext
		Loop
		 
	End If 
	oRs.Close
	Set oRs = Nothing 


	If bHasData Then 
		'sort the Display recordset
		oDisplay.Sort = "ispaymentaccount DESC, iscitizenaccount ASC, accountname ASC, accountnumber ASC, receiptno ASC"

		' Show results
		oDisplay.MoveFirst
		'response.write "<div class=""receiptpaymentshadow"">" & vbcrlf
		response.Write "<table cellspacing=""0"" cellpadding=""2"" border=""0"" width=""100%"" class=""receiptpayment"">" & vbcrlf
		response.write "  <tr class=""tablelist"">" & vbcrlf
		response.write "      <th>Account Name</th>" & vbcrlf
		response.write "      <th>Account Number</th>" & vbcrlf
		response.write "      <th>Receipt No.</th>" & vbcrlf
		response.write "      <th>Date</th>" & vbcrlf
		response.write "      <th>Total Amt<br />Credited</th>" & vbcrlf
		response.write "      <th>Total Amt<br />Debited</th>" & vbcrlf
		response.write "      <th>Total Amt<br />Transfered</th>" & vbcrlf
		response.write "  </tr>" & vbcrlf

		bgcolor         = "#eeeeee"
		iOldAccountId   = CLng(0)
		dCreditSubTotal = CDbl(0.00)
		dDebitSubTotal  = CDbl(0.00)
		dSubTotal       = CDbl(0.00)

		Do While Not oDisplay.EOF
			If bgcolor="#eeeeee" Then 
				bgcolor="#ffffff" 
			Else 
				bgcolor="#eeeeee"
			End If 

  			response.write vbcrlf & "<tr bgcolor=""" &  bgcolor  & """>"

		  	If iOldAccountId <> CLng(oDisplay("accountid")) Then 
				   'Put out a sub total row
    				If iOldAccountId <> CLng(0) Then 
						response.write vbcrlf & "<tr class=""totalrow"">"
						response.write "<td colspan=""4"" align=""right"">Sub-Total:</td>"
						response.write "<td align=""right"">" & FormatNumber(dCreditSubTotal, 2) & "</td>"
						response.write "<td align=""right"">" & FormatNumber(dDebitSubTotal, 2)  & "</td>"
						response.write "<td align=""right"">" & FormatNumber(dSubTotal,2)        & "</td>" 
						response.write "</tr>"
  		  			End If 

  		  			response.write "<td align=""left"">"   & oDisplay("accountname")   & "</td>" 
    				response.write "<td align=""center"">" & oDisplay("accountnumber") & "</td>" 

					iOldAccountId   = CLng(oDisplay("accountid"))
					dCreditSubTotal = CDbl(0.00)
					dDebitSubTotal  = CDbl(0.00)
					dSubTotal       = CDbl(0.00)
		  	Else 
				'Need place holders 
				response.write "<td>&nbsp;</td>" 
				response.write "<td>&nbsp;</td>" 
		  	End If 

		  	If clng(oDisplay("journalentrytypeid")) > clng(2) Then 
				'citizen account activity
				response.write "<td align=""center"">"
				response.write "<a href=""../purchases/viewjournal.asp?uid=" & oDisplay("userid") & "&pid=" & oDisplay("receiptno") & "&rt=c&it=ci&jet=d"">" & oDisplay("receiptno") & "</a>"
				response.write "</td>" 
  			Else 
				'purchase
				response.write "<td align=""center"">"
				response.write "<a href=""../classes/view_receipt.asp?iPaymentId=" & oDisplay("receiptno") & """>" & oDisplay("receiptno") & "</a>"
				response.write "</td>" 
  			End If 

		  	response.write "<td align=""right"">" & FormatDateTime(oDisplay("paymentdate"), 2) & "</td>" 
  			response.write "<td align=""right"">" & FormatNumber(oDisplay("creditamt"), 2)     & "</td>" 
		  	response.write "<td align=""right"">" & FormatNumber(oDisplay("debitamt"), 2)      & "</td>" 
  			response.write "<td align=""right"">" & FormatNumber(oDisplay("totalamt"), 2)      & "</td>" 

  			dCreditSubTotal = dCreditSubTotal + CDbl(oDisplay("creditamt"))
		  	dTotalCredit    = dTotalCredit + CDbl(oDisplay("creditamt"))
  			dDebitSubTotal  = dDebitSubTotal + CDbl(oDisplay("debitamt"))
		  	dTotalDebit     = dTotalDebit + CDbl(oDisplay("debitamt"))
  			dSubTotal       = dSubTotal + CDbl(oDisplay("totalamt"))
		  	dGrandTotal     = dGrandTotal + CDbl(oDisplay("totalamt"))

  			response.write "  </tr>" & vbcrlf

			oDisplay.MoveNext
		Loop 

		'Put out a sub total row
		If iOldAccountId <> CLng(0) Then 
			response.write vbcrlf & "<tr class=""totalrow"">"
			response.write "<td colspan=""4"" align=""right"">Sub-Total:</td>" & vbcrlf
			response.write "<td align=""right"">" & FormatNumber(dCreditSubTotal, 2) & "</td>" 
			response.write "<td align=""right"">" & FormatNumber(dDebitSubTotal, 2)  & "</td>" 
			response.write "<td align=""right"">" & FormatNumber(dSubTotal,2)        & "</td>"
			response.write "</tr>"
		End If 

		'Totals Row
		response.write vbcrlf & "<tr class=""totalrow"">" 
		response.write "<td colspan=""4"" align=""right"">Totals:</td>" 
		response.write "<td align=""right"">" & FormatNumber( dTotalCredit, 2 ) & "</td>"
		response.write "<td align=""right"">" & FormatNumber( dTotalDebit, 2 )  & "</td>" 
		response.write "<td align=""right"">" & FormatNumber( dGrandTotal, 2 )  & "</td>" 
		response.write "</tr>" 
		response.write vbcrlf & "</table>" 
		'response.write vbcrlf & "</div>"
	
	Else
		response.write "<p>No information could be found for the criteria selected.</p>"
	End If

	oDisplay.Close
	Set oDisplay = Nothing

End Sub 


'------------------------------------------------------------------------------
' ShowAdminLocations iLocationId
'------------------------------------------------------------------------------
Sub ShowAdminLocations( ByVal iLocationId )
	Dim sSql, oRs
	
	sSql = "SELECT locationid, name FROM egov_class_location "
	sSql = sSql & "WHERE orgid = " & session("orgid") & " ORDER BY name"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open  sSql, Application("DSN"), 0, 1

	If Not oRs.EOF Then 
		response.write vbcrlf & "<select name=""locationid"">"

		response.write vbcrlf & "<option value=""0"""
		If CLng(0) = CLng(iLocationId) Then 
			response.write " selected=""selected"" "
		End If 
		response.write ">Show All Locations</option>"

  		Do While Not oRs.EOF 
			response.write vbcrlf & "<option value=""" & oRs("locationid") & """"
			If CLng(oRs("locationid")) = CLng(iLocationId) Then 
				response.write " selected=""selected"" "
			End If 
			response.write ">" & oRs("name") & "</option>"
			oRs.MoveNext
  		Loop 
  		response.write vbcrlf & "</select>" 
	End If 

	oRs.Close
	Set oRs = Nothing 

End Sub 


'------------------------------------------------------------------------------
' ShowPaymentLocations iPaymentLocationId 
'------------------------------------------------------------------------------
Sub ShowPaymentLocations( ByVal iPaymentLocationId )

	response.write vbcrlf & "<select name=""paymentlocationid"">"
	response.write vbcrlf & "<option value=""0"" "
	If CLng(0) = CLng(iPaymentLocationId) Then ' none selected
		 response.write " selected=""selected"" "
	End If 
	response.write ">Web Site and Office</option>"

	response.write vbcrlf & "<option value=""1"""
	If CLng(1) = CLng(iPaymentLocationId) Then 
		response.write " selected=""selected"" "
	End If 
	response.write ">Office Only</option>"

	response.write vbcrlf & "<option value=""2"""
	If CLng(2) = CLng(iPaymentLocationId) Then 
		response.write " selected=""selected"" "
	End If 
	response.write ">Web Site Only</option>"

	response.write vbcrlf & "</select>"

End Sub 


'------------------------------------------------------------------------------
' ShowReportTypes iReportType 
'------------------------------------------------------------------------------
Sub ShowReportTypes( ByVal iReportType )
	
	response.write vbcrlf & "<select name=""reporttype"">"

	response.write vbcrlf & "<option value=""1"""
	If CLng(1) = CLng(iReportType) Then 
		response.write " selected=""selected"" "
	End If 
	response.write ">Summary</option>"

	response.write vbcrlf & "<option value=""2"""
	If CLng(2) = CLng(iReportType) Then 
		response.write " selected=""selected"" "
	End If 
	response.write ">Detail</option>"

	response.write vbcrlf & "</select>"
	
End Sub 


'------------------------------------------------------------------------------
' ShowAdminUsers iAdminUserId 
'------------------------------------------------------------------------------
Sub ShowAdminUsers( ByVal iAdminUserId )
	Dim sSql, oRs
	
	sSql = "SELECT userid, firstname, lastname FROM users "
	sSql = sSql & "WHERE isrootadmin = 0 AND orgid = " & session("orgid")
	sSql = sSql & " ORDER BY lastname, firstname"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open  sSql, Application("DSN"), 0, 1

	If Not oRs.EOF Then 
		response.write vbcrlf & "<select name=""adminuserid"">"
		response.write vbcrlf & "<option value=""0"" "
		If CLng(0) = CLng(iAdminUserId) Then ' none selected
			 response.write " selected=""selected"" "
		End If 
		response.write ">Show All</option>"
		Do While Not oRs.EOF 
			response.write vbcrlf & "<option value=""" & oRs("userid") & """"
			If CLng(oRs("userid")) = CLng(iAdminUserId) Then 
				response.write " selected=""selected"" "
			End If 
			response.write ">" & oRs("firstname") & " " & oRs("lastname") & "</option>"
			oRs.MoveNext
		Loop 
		response.write vbcrlf & "</select>"
	End If 

	oRs.Close
	Set oRs = Nothing 

End Sub 


'------------------------------------------------------------------------------
' ShowJournalEntryTypes iJournalEntryTypeId 
'------------------------------------------------------------------------------
Sub ShowJournalEntryTypes( ByVal iJournalEntryTypeId )
	Dim sSql, oRs
	
	sSql = "SELECT journalentrytypeid, displayname + ' Only' AS displayname FROM egov_journal_entry_types "
	sSql = sSql & "WHERE journalentrytype = 'refund' "
	sSql = sSql & " OR journalentrytype = 'purchase' ORDER BY displayorder"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open  sSql, Application("DSN"), 0, 1

	If Not oRs.EOF Then 
		response.write vbcrlf & "<select name=""journalentrytypeid"">"
		response.write vbcrlf & "<option value=""0"" "
		If CLng(0) = CLng(iJournalEntryTypeId) Then ' none selected
			 response.write " selected=""selected"" "
		End If 
		response.write ">Show All</option>"
		Do While Not oRs.EOF 
			response.write vbcrlf & "<option value=""" & oRs("journalentrytypeid") & """"
			If CLng(oRs("journalentrytypeid")) = CLng(iJournalEntryTypeId) Then 
				response.write " selected=""selected"" "
			End If 
			response.write ">" & oRs("displayname") & "</option>"
			oRs.MoveNext
		Loop 
		response.write vbcrlf & "</select>"
	End If 

	oRs.Close
	Set oRs = Nothing 

End Sub 


'--------------------------------------------------------------------------------------------------
' void ShowAccountPicks sSelectName, iAccountNo, bShowAllPick
'--------------------------------------------------------------------------------------------------
Sub ShowAccountPicks( ByVal sSelectName, ByVal iAccountNo, ByVal bShowAllPick )
	Dim sSql, oRs

	sSql = "SELECT accountid, accountname FROM egov_accounts WHERE orgid = " & session("orgid")
	sSql = sSql & " AND accountstatus = 'A' ORDER BY accountname"

	Set oRs = Server.CreateObject("ADODB.Recordset")
	oRs.Open sSql, Application("DSN"), 0, 1

	response.write vbcrlf & "<select id=""" & sSelectName & """ name=""" & sSelectName & """>"
	If bShowAllPick Then 
		response.write "<option value=""0"">Include All GL Accounts</option>"
	End If 
	Do While Not oRs.EOF
		response.write vbcrlf & "<option value=""" & oRs("accountid") & """"

		If iAccountNo <> "" Then 
			If CLng(oRS("accountid")) = CLng(iAccountNo) Then
				response.write " selected=""selected"" "
			End If
		End If 

		response.write ">" & oRs("accountname") & "</option>"
		oRs.MoveNext 
	Loop
	response.write vbcrlf & "</select>"

	oRs.Close
	Set oRs = Nothing 

End Sub


%>
