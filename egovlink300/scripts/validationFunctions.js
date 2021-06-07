<!--
//*****************************************************************************************
// validationFunctions.js  Version 1.0  Time Stamp: 4/01/02 4:25:50PM  Size=6K(or 5,832 bytes)
//						
//
// a javascript file to validate form elements
// contains many of the functions from easyform
//
//*****************************************************************************************


//--------------------------------------------------------------------------
// DataType Validation Routines
//--------------------------------------------------------------------------

//checks a string to see if it is a valid zipcode
function isZipCode (value){
	var x,i;
	
	//Convert 5 digit zip to 9 digit by adding "0000"
	if (value.length == 5) {
		if (isNumeric(value)) {
			value=value+"0000";
			return true;
		} else {
			return false;
		}
	}
	
	// If length ten (XXXXX-YYYY), remove non-numeric then check length 9
	if(value.length == 10) {
		value=numericize(value);
	}
	
	//Check length 9
	if (value.length == 9) {
		if (isNumeric(value)) {
			return true;
		} else {
			return false;
		}
	}
	return false;
}

//returns true if string is integer
function isInteger(s) {
  if (isNumeric(s)) {
    if (parseInt(s) == s)
      return true; 
  }
  return false;
}

//returns true if string is numeric
function isNumeric(s) {
  /*var i;
	for (i=0; i<s.length; i++){   
	  var c = s.charAt(i);
	  if (!isDigit(c))
			return false;
	}
	return true;*/
	return (!isNaN(s));
}

//returns true if string is a currency
function isCurrency(s) {
  s = replace(s, "$", "");
  s = replace(s, ".", "");
  s = replace(s, ",", "");
  return isNumeric(s);
}

//returns true if string is a date
function isDate(s) {
  s = replace(s, "/", "");
  s = replace(s, "-", "");
  s = replace(s, ":", "");
  s = replace(s, "AM", "");
  s = replace(s, "PM", "");
  return isNumeric(s);
}

//return true is string is a valid credit card
function isCreditCard(s) {
  s = replace(s, "-", "");
  s = replace(s, " ", "");
  return isNumeric(s); 
}

//returns true if c is a number
function isDigit (c) {
	return ((c >= "0") && (c <= "9"))
}

function numericize(s){
	// s is a string
	var i,j;
	j="";
	for (i=0;i<s.length;i++){
		if (isDigit(s.charAt(i))){
			 j = j + s.charAt(i);
		}
	}
	return j;
}

//returns true if is a valid Social Security Number
function isSSN (s) {
	var x,i;

	// Check 11 digit with dashes (strip out dashes, check if valid)
	if (s.length == 11){
		s=numericize(s);
	}
	
	// Check 9 digit integer
	if (s.length == 9){
		if (isNumeric(s)){
			return true;
		} else {
			return false;
		}
	}
	return false;
}

function isPhone (value) {
	if (value.length > 10){
		value = numericize(value);
	}
	
	//Check if first digit is 0 or 1. Invalid phone number.
	if ((value.charAt(0) == '0') || (value.charAt(0) == '1')) {
		return false;
	}
	
	//Should be 3 digit area code + 7 digit phone number, as a 10 digit string
	if (value.length == 10){
		if (isNumeric(value)){
			return true;
		} else {
			return false;
		}
	}
	else{
		return false;
	}
	return true;
}

function isEmail (value){
	var i,ii;
	var j;
	var k,kk;
    var jj;
    var len;

    // Check valid email
    // Must have a "@" and a "." to be valid.
    // Must have at least 1 character before "@"
    // Must have at least 1 character after "@" and before "."
    // Must have at least 2 characters after "."
    if (value.length >0){
		i=value.indexOf("@");
		ii=value.indexOf("@",i+1);
		j=value.indexOf(".",i);
		k=value.indexOf(",");
		kk=value.indexOf(" ");
		jj=value.lastIndexOf(".")+1;
		len=value.length;
		if ((i>0) && (j>(1+1)) && (k==-1) && (ii==-1) && (kk==-1) &&
			(len-jj >=2) && (len-jj<=3)) {}
		else {			
				return false;
		}
	}
    return true;
}

//--------------------------------------------------------------------------
// String Functions
//--------------------------------------------------------------------------

//returns the left n characters from str.
function left(str,n) {
	return str.substring(0,n);
}

//returns a substring of str starting at 'start' that's n characters long.
function mid(str,start,n) {
	strlen = str.length;
	var jj = str.substring(start-1,strlen);
	jj = jj.substring(0,n);
	return jj;
}

//returns a number indicating the spot where smstring appears in lrgstring (right to left search)
function inStrRev(lrgstring,smstring) {
	strlen1 = smstring.length;
	strlen2 = lrgstring.length;
	foundAt = 0;
	for (i=strlen2;i>=0;i--) {
		comp = lrgstring.substring(i-1,strlen2);
		comp = comp.substring(0,strlen1)	;	
		if (comp == smstring) {
			foundAt = i;
			break;
		}
	}
	return foundAt;
}

function lcase(str) {
	//returns str in all lowercase letters.
	return str.toLowerCase()
}

function inStr(lrgstring,smstring) {
	//returns a number indicating the spot where smstring appears in lrgstring (left to right search)
	strlen1 = smstring.length;
	strlen2 = lrgstring.length;
	foundAt = -1;
	for (i=0;i<=strlen2;i++) {
		comp = lrgstring.substring(i-1,strlen2);
		comp = comp.substring(0,strlen1);
		if (comp == smstring) {
			foundAt = i;
			break;
		}
	}
	return foundAt;
}

function replace(str, oldseq, newseq) {
  //replaces the oldseq string with the newseq string in the source string
  var r = "";
  len = oldseq.length;
  
  pos = inStr(str, oldseq);
  while (pos >= 0) {
    if (pos != 0) {
      r = r + left(str,pos-1) + newseq;
      str = mid(str,pos+len,str.length-(pos+len-1));
    }
    else {
      r = r + newseq;
      str = mid(str,pos+len+1,str.length-(pos+len-1));
    }
    pos = inStr(str, oldseq);
  }
  r = r + str;
  return r;
}

/*function : isValidDate( string ) 

version: 1.0.0  
This function validates a date as a real date in the format mm/dd/yyyy.  

*/  

function isValidDate( strValue ) 
{
	var daterege = /^\d{1,2}[-/]\d{1,2}[-/]\d{4}$/;
	var dateOk = daterege.test(strValue);

	if (! dateOk )
	{
		return false;
	}
	else
	{
		//var strSeparator = strValue.substring(2,3) 
		var arrayDate = strValue.split('/'); 
		if (arrayDate[0].length == 1)
		{
			arrayDate[0] = '0' + arrayDate[0];
		}
		//create a lookup for months not equal to Feb.
		var arrayLookup = { '01' : 31,'03' : 31, 
				'04' : 30,'05' : 31,
				'06' : 30,'07' : 31,
				'08' : 31,'09' : 30,
				'10' : 31,'11' : 30,'12' : 31}
		var intDay = parseInt(arrayDate[1],10); 

		//check if month value and day value agree
		if(arrayLookup[arrayDate[0]] != null)
		{
			if(intDay <= arrayLookup[arrayDate[0]] && intDay != 0)
				return true; //found in lookup table, good date
		}

		//check for February (bugfix 20050322)
		//bugfix  for parseInt kevin
		//bugfix  biss year  O.Jp Voutat
		var intMonth = parseInt(arrayDate[0],10);
		if (intMonth == 2) 
		{ 
			var intYear = parseInt(arrayDate[2]);
			if (intDay > 0 && intDay < 29) 
			{
				return true;
			}
			else if (intDay == 29) 
			{
				if ((intYear % 4 == 0) && (intYear % 100 != 0) || (intYear % 400 == 0)) 
				{
					// year div by 4 and ((not div by 100) or div by 400) ->ok
					return true;
				}   
			}
		}
	}  
	return false; //any other values, bad date
}

function yearDiff(sFirstDate, sSecondDate) 
{
	date1 = new Date();
	date2 = new Date();
	diff  = new Date();

	if (isValidDate(sFirstDate)) { // Validates first date 
		date1temp = new Date(sFirstDate);
		date1.setTime(date1temp.getTime());
	}
	else return false; // otherwise exits

	if (isValidDate(sSecondDate)) { // Validates second date 
		date2temp = new Date(sSecondDate);
		date2.setTime(date2temp.getTime());
	}
	else return false; // otherwise exits

	// sets difference date to difference of first date and second date

	diff.setTime(Math.abs(date1.getTime() - date2.getTime()));

	timediff = diff.getTime();

	iYears = Math.floor(timediff / (1000 * 60 * 60 * 24 * 7 * 52));

	return iYears; 
}


//-->