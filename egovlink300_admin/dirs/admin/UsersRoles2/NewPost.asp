<FORM METHOD=POST name="aaaa" ACTION="<%=thisname%>?iofaction=<%=ActNewPostSave%>&groupid=<%=request.querystring("groupid")%>">
<table border="0" width="550" class='tablelist'>
	<% 
	intcolumns=UBOUND(conTABLEFIELDS)
'   response.write "intcolumns="&intcolumns
	for j=0 to intcolumns
	'===================================================
		if l_register(j) then 
	'--------------------------------------------
	if l_length(j)>=100 then
	'------------------------
	%>
  	    <tr>
	<td width="200"><% =fields_description(j) %></td>
    <td width="351"><TEXTAREA name="<% =conTABLEFIELDS(j) %>" ROWS="2" COLS="50"></TEXTAREA></td>
	   </tr>
	<%
	'-------------------------
	elseif l_type(j)=50 then  ' means it is bit	
	'-------------------------
	%>
	<tr>
    <td width="200"><% =fields_description(j) %></td>
    <td width="351"><input type=radio name="<% =conTABLEFIELDS(j)%>" value=true>Yes&nbsp;&nbsp;
	                <input type=radio name="<% =conTABLEFIELDS(j)%>" value=false>No
	</td>
    </tr>
	<!---------------------->
	<% else %>
	<!--------------------->
	  <tr>
	<td width="200"><% =fields_description(j) %></td>
    <td width="351">
	<input type=text name="<%=conTABLEFIELDS(j)%>" size=<%=l_length(j)%> maxlength=<%=l_length(j)%>>
	<<
	<select name='from_<%=conTABLEFIELDS(j)%>'
	onChange='goOnChange(document.aaaa.<%=conTABLEFIELDS(j)%>,document.aaaa.from_<%=conTABLEFIELDS(j)%>)'>
	<% 
	list j 
	%>
	</SELECT>	
	</td>
	  </tr>
  <%
  '-------------------------
  end if
  '----------------------------------------------
  end if 
 '=================================================
  next 
  %>
</table>
<INPUT TYPE="submit" value='<%=langSubmitNewRecord%>'>
</FORM>
</form>

<script language=javascript>
function goOnChange(toname,fromname)
{
//document.aaaa.toname.value =document.aaaa.fromname[document.aaaa.fromname.selectedIndex].value;
toname.value=fromname[fromname.selectedIndex].value;
}
</script>