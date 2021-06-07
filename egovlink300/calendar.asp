<% response.end %>
<!-- #include file="includes/common.asp" //-->
<%
Function GetDaysInMonth(iMonth, iYear)
	Dim dTemp
	dTemp = DateAdd("d", -1, DateSerial(iYear, iMonth + 1, 1))
	GetDaysInMonth = Day(dTemp)
End Function

Function GetWeekdayMonthStartsOn(dAnyDayInTheMonth)
	Dim dTemp
	dTemp = DateAdd("d", -(Day(dAnyDayInTheMonth) - 1), dAnyDayInTheMonth)
	GetWeekdayMonthStartsOn = WeekDay(dTemp)
End Function

Function SubtractOneMonth(dDate)
	SubtractOneMonth = DateAdd("m", -1, dDate)
End Function

Function AddOneMonth(dDate)
	AddOneMonth = DateAdd("m", 1, dDate)
End Function

Dim dDate     ' Date we're displaying calendar for
Dim iDIM      ' Days In Month
Dim iDOW      ' Day Of Week that month starts on
Dim iCurrent  ' Variable we use to hold current day of month as we write table
Dim iPosition ' Variable we use to hold current position in table

' Get selected date
If IsDate(Request.QueryString("date")) Then
	dDate = CDate(Request.QueryString("date"))
Else
	If IsDate(Request.QueryString("month") & "-" & Request.QueryString("day") & "-" & Request.QueryString("year")) Then
		dDate = CDate(Request.QueryString("month") & "-" & Request.QueryString("day") & "-" & Request.QueryString("year"))
	Else
		dDate = Date()
		' The annoyingly bad solution for those of you running IIS3
		If Len(Request.QueryString("month")) <> 0 Or Len(Request.QueryString("day")) <> 0 Or Len(Request.QueryString("year")) <> 0 Or Len(Request.QueryString("date")) <> 0 Then
		  dDate = CDate(Request.QueryString("month") & "-" & GetDaysInMonth(Request.QueryString("month"), Request.QueryString("year")) & "-" & Request.QueryString("year"))
		End If
	End If
End If

'Now we've got the date.  Now get Days in the choosen month and the day of the week it starts on.
iDIM = GetDaysInMonth(Month(dDate), Year(dDate))
iDOW = GetWeekdayMonthStartsOn(dDate)
%>

<html>
<head>
  <title><%=langBSEventsCalendar%></title>
  <style type="text/css">
  <!--
    body {scrollbar-base-color:#6699cc; scrollbar-highlight-color:#ffffff; scrollbar-arrow-color:#99ccff;}
    .cal {border-left:1px solid #93bee1; border-top:1px solid #93bee1;}
    .cal td {border-right:1px solid #93bee1; border-bottom:1px solid #93bee1; font-family:Tahoma,Arial; font-size:11px;}
    select {font-family:Arial,Tahoma,Verdana; font-size:13px;}
  //-->
  </style>
</head>

<body topmargin="0" leftmargin="0" bottommargin="0" rightmargin="0" marginwidth="0" marginheight="0">
  <form name="frmDate" action="calendar.asp" method="get">
  <input type="hidden" name="day" value="<%= Day(Now) %>">
  
  <table border="0" cellpadding="3" cellspacing="0" bgcolor="#ffffff" class="cal" width="100%" height="100%">
    <tr height="2%">
      <td bgcolor="#ffffff" align="center" colspan="7">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="15%" style="border:0px;" nowrap> &nbsp;<img src="../images/arrow_back.gif" align="absmiddle">&nbsp;<A HREF="calendar.asp?date=<%= SubtractOneMonth(dDate) %>"><FONT face="Arial" COLOR=#ffffff SIZE="1"><%=langPreviousMonth%></FONT></A></td>
            <td width="70%" align="center" style="border:0px;">
              <select name="month" onchange="document.all.frmDate.submit();">
                <option value=1><%=langMonth01%></option>
                <option value=2><%=langMonth02%></option>
                <option value=3><%=langMonth03%></option>
                <option value=4><%=langMonth04%></option>
                <option value=5><%=langMonth05%></option>
                <option value=6><%=langMonth06%></option>
                <option value=7><%=langMonth07%></option>
                <option value=8><%=langMonth08%></option>
                <option value=9><%=langMonth09%></option>
                <option value=10><%=langMonth10%></option>
                <option value=11><%=langMonth11%></option>
                <option value=12><%=langMonth12%></option>
              </select>
              <select name="year" onchange="document.all.frmDate.submit();">
                <option value=2000>2000</option>
                <option value=2001>2001</option>
                <option value=2002>2002</option>
                <option value=2003>2003</option>
                <option value=2004>2004</option>
                <option value=2005>2005</option>
                <option value=2006>2006</option>
              </select>
              <script language="Javascript">
                document.all.month.selectedIndex = <%= Month(dDate)-1 %>;
                document.all.year.value = <%= Year(dDate) %>;
              </script>
            </td>
            <td width="15%" align="right" style="border:0px;" nowrap>&nbsp;<A HREF="calendar.asp?date=<%= AddOneMonth(dDate) %>"><FONT face="Arial" COLOR=#ffffff SIZE="1"><%=langNextMonth%></FONT></A>&nbsp;<img src="../images/arrow_forward.gif" align="absmiddle">&nbsp;<img src="../images/spacer.gif" width="1" height="30" align="absmiddle"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr height="1%">
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay1%></B></FONT></td>
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay2%></B></FONT></td>
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay3%></B></FONT></td>
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay4%></B></FONT></td>
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay5%></B></FONT></td>
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay6%></B></FONT></td>
      <td ALIGN="center" BGCOLOR=#93bee1 width="13%"><FONT COLOR=#003366><B><%=langDay7%></B></FONT><img src="../images/spacer.gif" width="1" height="20" align="absmiddle"></td>
    </TR>
    <%
    ' Write spacer cells at beginning of first row if month doesn't start on a Sunday.
    If iDOW <> 1 Then
      Response.Write vbTab & "<tr>" & vbCrLf
      iPosition = 1
      Do While iPosition < iDOW
        Response.Write vbTab & vbTab & "<td>&nbsp;</td>" & vbCrLf
        iPosition = iPosition + 1
      Loop
    End If

    ' Write days of month in proper day slots
    iCurrent = 1
    iPosition = iDOW
    Do While iCurrent <= iDIM
      ' If we're at the begginning of a row then write TR
      If iPosition = 1 Then
        Response.Write vbTab & "<tr>" & vbCrLf
      End If

      ' If the day we're writing is the selected day then highlight it somehow.
      If iCurrent = Day(dDate) And Month(dDate) = Month(Now()) And Year(dDate) = Year(Now()) Then
        Response.Write vbTab & vbTab & "<td height=""15%"" id=""day_" & iCurrent & """ style=""border:2px solid #ff0000"" valign=""top""><font size=""2"">" & iCurrent & "</font></td>" & vbCrLf
      Else
        Response.Write vbTab & vbTab & "<td height=""15%"" id=""day_" & iCurrent & """ valign=""top""><font size=""2"">" & iCurrent & "</font></td>" & vbCrLf
      End If
      
      ' If we're at the endof a row then write /TR
      If iPosition = 7 Then
        Response.Write vbTab & "</tr>" & vbCrLf
        iPosition = 0
      End If
      
      ' Increment variables
      iCurrent = iCurrent + 1
      iPosition = iPosition + 1
    Loop

    ' Write spacer cells at end of last row if month doesn't end on a Saturday.
    If iPosition <> 1 Then
      Do While iPosition <= 7
        Response.Write vbTab & vbTab & "<td>&nbsp;</td>" & vbCrLf
        iPosition = iPosition + 1
      Loop
      Response.Write vbTab & "</tr>" & vbCrLf
    End If


    '------------------------------------------------------ determine what days we have events on and mark in calendar
    Dim oCmd, oRst, sScript, iDay
    ''Application("DSN") = "Driver={SQL Server}; Server=10.0.8.13; Database=Boardsite2; UID=sa; PWD=devsql;"
    DSNnew = "Driver={SQL Server}; Server=10.0.8.13; Database=Boardsite2; UID=sa; PWD=devsql;"
    
    Set oCmd = Server.CreateObject("ADODB.Command")
    With oCmd
      ''.ActiveConnection = Application("DSN")
      .ActiveConnection = DSNnew
      .CommandText = "ListMonthEvents"
      .CommandType = adCmdStoredProc
      .Parameters.Append oCmd.CreateParameter("OrgID", adInteger, adParamInput, 4, Session("OrgID"))
      .Parameters.Append oCmd.CreateParameter("Date", adDateTime, adParamInput, 4, dDate)
    End With
                
    Set oRst = Server.CreateObject("ADODB.Recordset")
    With oRst
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .Open oCmd
    End With
    Set oCmd = Nothing

    sScript = ""

    If Not oRst.EOF Then
      sScript = "<script language=""Javascript"">"
      Do While Not oRst.EOF
        iDay = Day(oRst("EventDate"))
      
  	  Set oCmd2 = Server.CreateObject("ADODB.Command")
	    With oCmd2
	      .ActiveConnection = Application("DSN")
	      .CommandText = "ListMonthEvents"
	      .CommandType = adCmdStoredProc
	      .Parameters.Append oCmd2.CreateParameter("OrgID", adInteger, adParamInput, 4, Session("OrgID"))
	      .Parameters.Append oCmd2.CreateParameter("Date", adDateTime, adParamInput, 4, dDate)
	    End With

          Set oRst2 = Server.CreateObject("ADODB.Recordset")
	    With oRst2
	      .CursorLocation = adUseClient
	      .CursorType = adOpenStatic
	      .LockType = adLockReadOnly
	      .Open oCmd2
	    End With
	 Set oCmd2 = Nothing

	perday = 0
	Do While Not oRst2.EOF
		if Day(oRst2("EventDate")) = iDay then
			perday = perday + 1
		end if

		oRst2.MoveNext
	Loop


	if perday >= 2 then
	        sScript = sScript & "document.all.day_" & iDay & ".innerHTML = ""<span style='width:100%; height:100%; cursor:pointer; cursor:hand;' onclick='document.location.href=\""calendarevents.asp?date="& Month(dDate) & "-" & iDay & "-" & Year(dDate) & "\""'><font size=2><b>" & iDay & "</b></font><br><font size=1>" & perday & " Events</font></span>"";" & vbCrLf
	else
	        sScript = sScript & "document.all.day_" & iDay & ".innerHTML = ""<span style='width:100%; height:100%; cursor:pointer; cursor:hand;' onclick='document.location.href=\""calendarevents.asp?date="& Month(dDate) & "-" & iDay & "-" & Year(dDate) & "\""'><font size=2><b>" & iDay & "</b></font><br><font size=1>" & oRst("Subject") & "</font></span>"";" & vbCrLf
	end if
 sScript = sScript & "document.all.day_" & iDay & ".style.backgroundColor = '#ffff00';" &  vbCrLf
        oRst.MoveNext
      Loop
      sScript = sScript & "</script>"
    End If
    Set oRst = Nothing

    Response.Write sScript
    %>
  </table>
  </form>
</body>
</html>
