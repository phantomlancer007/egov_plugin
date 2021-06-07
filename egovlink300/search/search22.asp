<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- #include file="../includes/common.asp" //-->
<!-- #include file="../includes/start_modules.asp" //-->
<%
Response.Buffer = True

' Try a blacklist filter of bad stuff to the query. Need to move this to a stored procedure for the calendar
If InStr(UCase(Request("SearchString")),"DECLARE") > 0 And InStr(UCase(Request("SearchString")),"VARCHAR") > 0 And InStr(UCase(Request("SearchString")),"EXEC") > 0 Then 
	response.End 
End If
If InStr(UCase(request("path")),"SELECT") > 0 And InStr(UCase(request("path")),"VARCHAR") > 0 And InStr(UCase(request("path")),"CAST") > 0 Then 
	response.redirect "home.asp"
End If

%>

<%
' CAPTURE CURRENT PATH
Session("RedirectPage") = Request.ServerVariables("SCRIPT_NAME") & "?" & Request.QueryString()
Session("RedirectLang") = "Return to Action Line"
%>



<!-- ### Montgomery Wrapper ### -->
<script language="Javascript" src="scripts/modules.js"></script>
<script language="Javascript" src="scripts/easyform.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta name="description" content="City of Montgomery Ohio Web Site" />
	<meta name="keywords" content="Montgomery Ohio, Suburb, Premiere Residential Community, Tree City USA, Parks, Historical District, Historical downtown, family frinedly city, excellent schools, nationally recognized schools, Hamilton County" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />

	<title>Montgomery, Ohio - Search</title>

	<link rel="stylesheet" type="text/css" media="screen" href="http://www.montgomeryohio.org/styles/screen.css" />
	<link rel="stylesheet" type="text/css" media="print" href="http://www.montgomeryohio.org/styles/print.css" />
	<link rel="stylesheet" type="text/css" href="search.css" />
	<link rel="stylesheet" type="text/css" href="../css/styles.css" />
	<link rel="stylesheet" type="text/css" href="../global.css" />
	<link rel="stylesheet" type="text/css" href="../css/style_<%=iorgid%>.css" />

</head>

<body>

<%	'RegisteredUserDisplay( "../" ) %>

<div id="wrapper">

	<div id="header">
		<h1 class="replace" id="logo">City of Montgomery, Ohio<span></span></h1>

	</div>
	
  <div id="content">
<!-- ### Montgomery Wrapper ### -->
    	
	<!-- EGovLink Custom Search -->

<%
	PageSize = 5
	SiteLocale = "EN-US"
	Dim strDisplayTable, scopePath 

	'Set Initial Conditions
	NewQuery = FALSE
	UseSavedQuery = FALSE
	SearchString = ""
	QueryForm = Request.ServerVariables("PATH_INFO")
  
	'Did the user press a SUBMIT button to execute the form? If so get the form variables.
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		SearchString = Trim(Left(Request("SearchString"),100))
		FreeText = Request.Form("FreeText")
		'NOTE: this will be true only if the button is actually pushed.
		If Request.Form("Action") = "Go" Then
			NewQuery = TRUE
			RankBase = 1000
		End If
	Elseif session("strHomeSearch") <> "" Then
		SearchString = session("strHomeSearch")
		session("strHomeSearch") = ""
		NewQuery = TRUE
	ElseIf Request.ServerVariables("REQUEST_METHOD") = "GET" Then
		SearchString = Request.QueryString("qu")
		FreeText = Request.QueryString("FreeText")
		FormScope = Request.QueryString("sc")
		RankBase = Request.QueryString("RankBase")
		If Request.QueryString("pg") <> "" Then
			NextPageNumber = Request.QueryString("pg")
			NewQuery = FALSE
			UseSavedQuery = TRUE
		Else
			NewQuery = SearchString <> ""
		End if
	End If

%>
</head>
<!--#Include file="../include_top_functions.asp"-->

  <!--Begin Page Header -->
  <div style="padding-left:22px; padding-top:9px;"><b><font style="font-family:Verdana,Arial; font-size:18px;">Site Search</font></b></div>
  <!--End Page Header -->
  
  <!--Begin Search Form -->
    <form name="frmSearch" action="<%=QueryForm%>" method="post">
    <input type="hidden" name="Action" value="Go" />
    <table width="95%" align="center">
      <tr><td><b>Enter your query below:</b></td></tr>
       <tr><td><input type="text" name="SearchString" size="65" maxlength="100" value="<%= SearchString %>" style="background-color:#eeeeee;width:255px; height:19px; border:1px solid #000033;" /></td></tr>
	   
	   <tr>
	   <td align="right" width="255"><a href="#" onClick='document.frmSearch.submit()'><img src="images/go.gif" border="0"><%=langGo%></a>
         </form></td>
       </tr>
    </table>
  </form>
  <!--End Search Form-->
  <% if request("searchstring") <> "" then %>
  	<center>
  	<table>
		<tr>
			<td>
				<fieldset style="background:#ddd;text-align:center;padding-top:2px;padding-bottom:2px;margin:0px;bordercolor:black;"><a href=#web>Web Search</a> | <a href=#doc>Document Search</a> | <a href=#cal>Calendar Search</a></fieldset><br>
				<a name=web></a>
				<fieldset>
  					<legend>Web Search</legend>
					<!--#include file="inc_websearch.asp"-->
				</fieldset>
				<br>
				<fieldset style="background:#ddd;text-align:center;padding-top:2px;padding-bottom:2px;margin:0px;bordercolor:black;"><a href=#web>Web Search</a> | <a href=#doc>Document Search</a> | <a href=#cal>Calendar Search</a></fieldset><br>
				<a name=doc></a>
				<fieldset>
  					<legend>Document Search</legend>
					<!--#include file="inc_docsearch22.asp"-->
				</fieldset>
				<br>
				<fieldset style="background:#ddd;text-align:center;padding-top:2px;padding-bottom:2px;margin:0px;bordercolor:black;"><a href=#web>Web Search</a> | <a href=#doc>Document Search</a> | <a href=#cal>Calendar Search</a></fieldset><br>
				<a name=cal></a>
				<fieldset>
  					<legend>Calendar Search</legend>
					<!--#include file="inc_calsearch.asp"-->
				</fieldset>
			</td>
		</tr>
	</table>
	</center>
	<% end if %>

<!-- ### Montgomery Wrapper ### -->
  </div>
  <div id="sidebar">
		<ul id="mainnav">
			<li id="mainnavtop"><a href="http://www.montgomeryohio.org/default.htm">Home</a></li>
			<li><a href="http://www.montgomeryohio.org/contact.htm">Contact Us</a> </li>
			<li><a href="http://www.montgomeryohio.org/empl-vol.htm">Employment/Volunteer</a></li>
			<li><a href="http://www.montgomeryohio.org/resident/resident.htm">Resident</a></li>
			<li><a href="http://www.montgomeryohio.org/business/business.htm">Business</a></li>
			<li><a href="http://www.montgomeryohio.org/government/government.htm">Government</a></li>
			<li><a href="http://www.montgomeryohio.org/discover/discover.htm">Discover Montgomery</a></li>
		</ul>		
		<h3>ONLINE SERVICES</h3>
		<ul id="online_list">
			<li id="online_listtop"><a href="http://www.egovlink.com/montgomery/action.asp">Action Line</a></li>
			<li><a href="http://www.montgomeryohio.org/discover/recreation/pool.htm#pool_pass"> Purchase Pool Pass </a></li>
			<li><a href="http://www.egovlink.com/montgomery/recreation/facility_list.asp">Facility Reservations</a></li>
			<li><a href="http://www.egovlink.com/montgomery/classes/class_list.asp">Class/Event Registration </a></li>
			<li><a href="http://www.egovlink.com/montgomery/events/calendar.asp">Community Calendar </a></li>
			<li><a href="http://www.egovlink.com/montgomery/docs/menu/home.asp">City Documents </a></li>
			<li><a href="http://www.montgomeryohio.org/government/gifts.htm">Commemorative Gifts</a></li>
		    <li><a href="http://www.montgomeryohio.org/CodeRed.htm">Emergency Contact System</a> </li>
			<li><a href="http://www.montgomeryohio.org/multilanguage.htm">Multi-Language Resources</a></li>
		</ul>
  </div>
		
	<div id="footer">
		<ul>
			<li><a href="disclaimer.htm">Disclaimer</a></li>
			<li><a href="security_policy.htm">Security Policy</a></li>
			<li><a href="copyright.htm">Copyright</a></li>
			<li><a href="accessability_statement.htm">Accessibility</a></li>
			<li><a href="multilanguage.htm">Multi-Language Resources</a></li>
			<li><a href="http://207.67.17.74:8000/council">Intranet</a></li>
		</ul>
		<p>Copyright &copy; 2001 - <%=Year(Now())%> City of Montgomery</p>
	</div>
</div>
</body>
</html>

<!-- ### Montgomery Wrapper ### -->

<%

'###############################FUNCTIONS###########################################

'------------------------------------------------------------------------------------------------------------
' Function GetExtentionImage(name)
'------------------------------------------------------------------------------------------------------------
Function GetExtentionImage(name)
      url = path & "/" & name
      url = Replace(url, " ", "%20")

      imgSrc = "images/document.gif"

      pos = InStr(1, name, ".")
      If pos > 0 Then
        Select Case Mid(name,pos+1,3)
          Case "doc"
            imgSrc = "images/msword.gif"
          Case "xls"
            imgSrc = "images/msexcel.gif"
          Case "ppt"
            imgSrc = "images/msppt.gif"
          Case "htm"
            imgSrc = "images/msie.gif"
          Case "pdf"
            imgSrc = "images/pdf.gif"
        End Select
        temp = Left(name,pos-1)
      Else
        temp = name
      End If
      
      GetExtentionImage = imgSrc
End Function


'------------------------------------------------------------------------------------------------------------
' Function PageOf()
'------------------------------------------------------------------------------------------------------------
Function PageOf()
	' Display the page number 
	 strReturn = "Page " & CurrentPage 
    
	If RS.PageCount <> -1 Then
     strReturn = strReturn & " of " & RS.PageCount
	End If
	
	PageOf = strReturn

End Function


'------------------------------------------------------------------------------------------------------------
' Function LocalizeDate(d,iUserOffset)
'------------------------------------------------------------------------------------------------------------
Function LocalizeDate(d,iUserOffset)
   localOffset = 0
 
   If iUserOffset = "" Then
       iUserOffset =0
   End If

  ' Call this function each time you want to display a date
  LocalizeDate= dateAdd("n", localOffset - iUserOffset,d) & sPostDate
End Function 


'--------------------------------------------------------------------------------------------------
' Function DBsafe( strDB )
'--------------------------------------------------------------------------------------------------
Function DBsafe( strDB )
	Dim sNewString
	If Not VarType( strDB ) = vbString Then DBsafe = strDB : Exit Function
	sNewString = Replace( strDB, "'", "''" )
	DBsafe = sNewString
End Function


%>
