var weekend = [0,6];
var weekendColor = "#e0e0e0";
var fontface = "Verdana";
var fontsize = 8;			// in "pt" units; used with "font-size" style element

var gNow = new Date();
var ggWinContent;
var ggPosX = -100;
var ggPosY = -100;

//Calendar.Months = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
Calendar.Months = ["一月", "二月", "三日", "四月", "五月", "六月","七月", "八月", "九月", "十月", "十一月", "十二月"];
// Non-Leap year Month days..
Calendar.DOMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
// Leap year Month days..
Calendar.lDOMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

function Calendar(p_item, p_month, p_year, p_format) {
	if ((p_month == null) && (p_year == null))	return;

	if (p_month == null) {
		this.gMonthName = null;
		this.gMonth = null;
		this.gYearly = true;
	} else {
		this.gMonthName = Calendar.get_month(p_month);
		this.gMonth = new Number(p_month);
		this.gYearly = false;
	}

	this.gYear = p_year;
	this.gFormat = p_format;
	this.gBGColor = "white";
	this.gFGColor = "black";
	this.gTextColor = "black";
	this.gHeaderColor = "black";
	this.gReturnItem = p_item;
}

Calendar.get_month = Calendar_get_month;
Calendar.get_daysofmonth = Calendar_get_daysofmonth;
Calendar.calc_month_year = Calendar_calc_month_year;

function Calendar_get_month(monthNo) {
	return Calendar.Months[monthNo];
}

function Calendar_get_daysofmonth(monthNo, p_year) {
	/* 
	Check for leap year ..
	1.Years evenly divisible by four are normally leap years, except for... 
	2.Years also evenly divisible by 100 are not leap years, except for... 
	3.Years also evenly divisible by 400 are leap years. 
	*/
	if ((p_year % 4) == 0) {
		if ((p_year % 100) == 0 && (p_year % 400) != 0)
			return Calendar.DOMonth[monthNo];
	
		return Calendar.lDOMonth[monthNo];
	} else
		return Calendar.DOMonth[monthNo];
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
	/* 
	Will return an 1-D array with 1st element being the calculated month 
	and second being the calculated year 
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();
	
	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}
	
	return ret_arr;
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
	/* 
	Will return an 1-D array with 1st element being the calculated month 
	and second being the calculated year 
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();
	
	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}
	
	return ret_arr;
}

// This is for compatibility with Navigator 3, we have to create and discard one object before the prototype object exists.
new Calendar();

Calendar.prototype.getMonthlyCalendarCode = function() {
	var vCode = "";
	var vHeader_Code = "";
	var vData_Code = "";
	
	// Begin Table Drawing code here..
	vCode += ("<div align=center><TABLE BORDER=1  BGCOLOR=\"" + this.gBGColor + "\" style='font-size:" + fontsize + "pt;'>");
	
	vHeader_Code = this.cal_header();
	vData_Code = this.cal_data();
	vCode += (vHeader_Code + vData_Code);
	
	vCode += "</TABLE></div>";
	
	return vCode;
}

Calendar.prototype.show = function() {
	var vCode = "";

	// build content into global var ggWinContent
	ggWinContent += ("<FONT FACE='" + fontface + "' ><B>");
	ggWinContent += (this.gMonthName + " " + this.gYear);
	ggWinContent += "</B><BR>";
	
	// Show navigation buttons
	var prevMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, -1);
	var prevMM = prevMMYYYY[0];
	var prevYYYY = prevMMYYYY[1];

	var nextMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, 1);
	var nextMM = nextMMYYYY[0];
	var nextYYYY = nextMMYYYY[1];
	
	ggWinContent += ("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0' style='font-size:" + fontsize + "pt;'><TR><TD ALIGN=center>");
	ggWinContent += ("[<A HREF=\"javascript:void(0);\" " +
		"onMouseOver=\"window.status='Go back one year'; return true;\" " +
		"onMouseOut=\"window.status=''; return true;\" " +
		"onClick=\"Build(" + 
		"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)-1) + "', '" + this.gFormat + "'" +
		");" +
		"\"><<��<\/A>]</TD><TD ALIGN=center>");
	ggWinContent += ("[<A HREF=\"javascript:void(0);\" " +
		"onMouseOver=\"window.status='Go back one month'; return true;\" " +
		"onMouseOut=\"window.status=''; return true;\" " +
		"onClick=\"Build(" + 
		"'" + this.gReturnItem + "', '" + prevMM + "', '" + prevYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\"><��<\/A>]</TD><TD ALIGN=center>");
	ggWinContent += "       </TD><TD ALIGN=center>";
	ggWinContent += ("[<A HREF=\"javascript:void(0);\" " +
		"onMouseOver=\"window.status='Go forward one month'; return true;\" " +
		"onMouseOut=\"window.status=''; return true;\" " +
		"onClick=\"Build(" + 
		"'" + this.gReturnItem + "', '" + nextMM + "', '" + nextYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\">��><\/A>]</TD><TD ALIGN=center>");
	ggWinContent += ("[<A HREF=\"javascript:void(0);\" " +
		"onMouseOver=\"window.status='Go forward one year'; return true;\" " +
		"onMouseOut=\"window.status=''; return true;\" " +
		"onClick=\"Build(" + 
		"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1) + "', '" + this.gFormat + "'" +
		");" +
		"\">��>><\/A>]</TD></TR></TABLE><BR>");

	// Get the complete calendar code for the month, and add it to the
	//	content var
	vCode = this.getMonthlyCalendarCode();
	ggWinContent += vCode;
}

Calendar.prototype.showY = function() {
	var vCode = "";
	var i;

	ggWinContent += "<FONT FACE='" + fontface + "' ><B>"
	ggWinContent += ("Year : " + this.gYear);
	ggWinContent += "</B><BR>";

	// Show navigation buttons
	var prevYYYY = parseInt(this.gYear) - 1;
	var nextYYYY = parseInt(this.gYear) + 1;
	
	ggWinContent += ("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0' style='font-size:" + fontsize + "pt;'><TR><TD ALIGN=center>");
	ggWinContent += ("[<A HREF=\"javascript:void(0);\" " +
		"onMouseOver=\"window.status='Go back one year'; return true;\" " +
		"onMouseOut=\"window.status=''; return true;\" " +
		"onClick=\"Build(" + 
		"'" + this.gReturnItem + "', null, '" + prevYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\"><<Year<\/A>]</TD><TD ALIGN=center>");
	ggWinContent += "       </TD><TD ALIGN=center>";
	ggWinContent += ("[<A HREF=\"javascript:void(0);\" " +
		"onMouseOver=\"window.status='Go forward one year'; return true;\" " +
		"onMouseOut=\"window.status=''; return true;\" " +
		"onClick=\"Build(" + 
		"'" + this.gReturnItem + "', null, '" + nextYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\">Year>><\/A>]</TD></TR></TABLE><BR>");

	// Get the complete calendar code for each month.
	// start a table and first row in the table
	ggWinContent += ("<TABLE WIDTH='100%' BORDER=0 CELLSPACING=0 CELLPADDING=5 style='font-size:" + fontsize + "pt;'><TR>");
	var j;
	for (i=0; i<12; i++) {
		// start the table cell
		ggWinContent += "<TD ALIGN='center' VALIGN='top'>";
		this.gMonth = i;
		this.gMonthName = Calendar.get_month(this.gMonth);
		vCode = this.getMonthlyCalendarCode();
		ggWinContent += (this.gMonthName + "/" + this.gYear + "<BR>");
		ggWinContent += vCode;
		ggWinContent += "</TD>";
		if (i == 3 || i == 7) {
			ggWinContent += "</TR><TR>";
			}

	}

	ggWinContent += "</TR></TABLE></font><BR>";
}

Calendar.prototype.cal_header = function() {
	var vCode = "";
	
	vCode = vCode + "<TR>";
	vCode = vCode + "<TD WIDTH='14%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>��</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>һ</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>��</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>��</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>��</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>��</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='16%'><FONT FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>��</B></FONT></TD>";
	vCode = vCode + "</TR>";
	
	return vCode;
}

Calendar.prototype.cal_data = function() {
	var vDate = new Date();
	vDate.setDate(1);
	vDate.setMonth(this.gMonth);
	vDate.setFullYear(this.gYear);

	var vFirstDay=vDate.getDay();
	var vDay=1;
	var vLastDay=Calendar.get_daysofmonth(this.gMonth, this.gYear);
	var vOnLastDay=0;
	var vCode = "";

	/*
	Get day for the 1st of the requested month/year..
	Place as many blank cells before the 1st day of the month as necessary. 
	*/
	vCode = vCode + "<TR>";
	for (i=0; i<vFirstDay; i++) {
		vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(i) + "><FONT FACE='" + fontface + "'> </FONT>&nbsp;</TD>";
	}

	// Write rest of the 1st week
	for (j=vFirstDay; j<7; j++) {
		vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + ">&nbsp;<FONT FACE='" + fontface + "'>" + 
			"<A HREF='javascript:void(0);' " + 
				"onMouseOver=\"window.status='set date to " +this.format_data(vDay) + "'; return true;\" " +
				"onMouseOut=\"window.status=' '; return true;\" " +
				"onClick=\"document." + this.gReturnItem + ".value='" + 
				this.format_data(vDay) + 
				"';ggPosX=-1;ggPosY=-1;nd();nd();\">" + 
				this.format_day(vDay) + 
			"</A>" + 
			"</FONT></TD>";
		vDay=vDay + 1;
	}
	vCode = vCode + "</TR>";

	// Write the rest of the weeks
	for (k=2; k<7; k++) {
		vCode = vCode + "<TR>";

		for (j=0; j<7; j++) {
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + ">&nbsp;<FONT FACE='" + fontface + "'>" + 
				"<A HREF='javascript:void(0);' " +
					"onMouseOver=\"window.status='set date to " + this.format_data(vDay) + "'; return true;\" " +
					"onMouseOut=\"window.status=' '; return true;\" " +
					"onClick=\"document." + this.gReturnItem + ".value='" + 
					this.format_data(vDay) + 
					"';window.scroll(0,ggPosY);ggPosX=-1;ggPosY=-1;nd();nd();\">" + 
				this.format_day(vDay) + 
				"</A>" + 
				"</FONT></TD>";
			vDay=vDay + 1;

			if (vDay > vLastDay) {
				vOnLastDay = 1;
				break;
			}
		}

		if (j == 6)
			vCode = vCode + "</TR>";
		if (vOnLastDay == 1)
			break;
	}
	
	// Fill up the rest of last week with proper blanks, so that we get proper square blocks
	for (m=1; m<(7-j); m++) {
		if (this.gYearly)
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
			"><FONT FACE='" + fontface + "' COLOR='gray'> </FONT></TD>";
		else
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
			"><FONT FACE='" + fontface + "' COLOR='gray'>" + m + "</FONT></TD>";
	}
	
	return vCode;
}

Calendar.prototype.format_day = function(vday) {
	var vNowDay = gNow.getDate();
	var vNowMonth = gNow.getMonth();
	var vNowYear = gNow.getFullYear();

	if (vday == vNowDay && this.gMonth == vNowMonth && this.gYear == vNowYear)
		return ("<FONT COLOR=\"RED\"><B>" + vday + "</B></FONT>");
	else
		return (vday);
}

Calendar.prototype.write_weekend_string = function(vday) {
	var i;

	// Return special formatting for the weekend day.
	for (i=0; i<weekend.length; i++) {
		if (vday == weekend[i])
			return (" BGCOLOR=\"" + weekendColor + "\"");
	}
	
	return "";
}

Calendar.prototype.format_data = function(p_day) {
	var vData;
	var vMonth = 1 + this.gMonth;
	vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
	var vMon = Calendar.get_month(this.gMonth).substr(0,3).toUpperCase();
	var vFMon = Calendar.get_month(this.gMonth).toUpperCase();
	var vY4 = new String(this.gYear);
	var vY2 = new String(this.gYear.substr(2,2));
	var vDD = (p_day.toString().length < 2) ? "0" + p_day : p_day;

	switch (this.gFormat) {
		case "MM\/DD\/YYYY" :
			vData = vMonth + "\/" + vDD + "\/" + vY4;
			break;
		case "MM\/DD\/YY" :
			vData = vMonth + "\/" + vDD + "\/" + vY2;
			break;
		case "MM-DD-YYYY" :
			vData = vMonth + "-" + vDD + "-" + vY4;
			break;
		//================================================================================
		case "YYYYMMDD" :
			vData = vY4 + vMonth + vDD;
			break;
		case "YYYY-MM-DD" :
			vData = vY4 + "-" + vMonth + "-" + vDD;
			break;
		case "MM-DD-YY" :
			vData = vMonth + "-" + vDD + "-" + vY2;
			break;
		case "DD\/MON\/YYYY" :
			vData = vDD + "\/" + vMon + "\/" + vY4;
			break;
		case "DD\/MON\/YY" :
			vData = vDD + "\/" + vMon + "\/" + vY2;
			break;
		case "DD-MON-YYYY" :
			vData = vDD + "-" + vMon + "-" + vY4;
			break;
		case "DD-MON-YY" :
			vData = vDD + "-" + vMon + "-" + vY2;
			break;
		case "DD\/MONTH\/YYYY" :
			vData = vDD + "\/" + vFMon + "\/" + vY4;
			break;
		case "DD\/MONTH\/YY" :
			vData = vDD + "\/" + vFMon + "\/" + vY2;
			break;
		case "DD-MONTH-YYYY" :
			vData = vDD + "-" + vFMon + "-" + vY4;
			break;
		case "DD-MONTH-YY" :
			vData = vDD + "-" + vFMon + "-" + vY2;
			break;
		case "DD\/MM\/YYYY" :
			vData = vDD + "\/" + vMonth + "\/" + vY4;
			break;
		case "DD\/MM\/YY" :
			vData = vDD + "\/" + vMonth + "\/" + vY2;
			break;
		case "DD-MM-YYYY" :
			vData = vDD + "-" + vMonth + "-" + vY4;
			break;
		case "DD-MM-YY" :
			vData = vDD + "-" + vMonth + "-" + vY2;
			break;
		default :
			vData = vMonth + "\/" + vDD + "\/" + vY4;
	}

	return vData;
}

function Build(p_item, p_month, p_year, p_format) {
	gCal = new Calendar(p_item, p_month, p_year, p_format);

	// Customize your Calendar here..
	gCal.gBGColor="white";
	gCal.gLinkColor="black";
	gCal.gTextColor="black";
	gCal.gHeaderColor="darkgreen";

	// initialize the content string
	ggWinContent = "";

	// Choose appropriate show function
	if (gCal.gYearly) {
		// and, since the yearly calendar is so large, override the positioning and fontsize
		// warning: in IE6, it appears that "select" fields on the form will still show
		//	through the "over" div; Note: you can set these variables as part of the onClick
		//	javascript code before you call the show_yearly_calendar function
		if (ggPosX == -1) ggPosX = 10;
		if (ggPosY == -1) ggPosY = 10;
		if (fontsize == 8) fontsize = 6;
		// generate the calendar
		gCal.showY();
		}
	else {
		gCal.show();
		}

	// if this is the first calendar popup, use autopositioning with an offset
	if (ggPosX == -1 && ggPosY == -1) {
		overlib(ggWinContent, AUTOSTATUSCAP, STICKY, CLOSECLICK, CSSSTYLE,
			TEXTSIZEUNIT, "pt", TEXTSIZE, 8, CAPTIONSIZEUNIT, "pt", CAPTIONSIZE, 8, CLOSESIZEUNIT, "pt", CLOSESIZE, 8,
			CAPTION, "ѡ������", OFFSETX, 20, OFFSETY, -20);
		// save where the 'over' div ended up; we want to stay in the same place if the user
		//	clicks on one of the year or month navigation links
		if ( (ns4) || (ie4) ) {
		        ggPosX = parseInt(over.left);
		        ggPosY = parseInt(over.top);
			} else if (ns6) {
			ggPosX = parseInt(over.style.left);
			ggPosY = parseInt(over.style.top);
			}
		}
	else {
		// we have a saved X & Y position, so use those with the FIXX and FIXY options
		overlib(ggWinContent, AUTOSTATUSCAP, STICKY, CLOSECLICK, CSSSTYLE,
			TEXTSIZEUNIT, "pt", TEXTSIZE, 8, CAPTIONSIZEUNIT, "pt", CAPTIONSIZE, 8, CLOSESIZEUNIT, "pt", CLOSESIZE, 8,
			CAPTION, "ѡ������", FIXX, ggPosX, FIXY, ggPosY);
		}
	window.scroll(ggPosX, ggPosY);
}

function show_calendar() {
	

	p_item = arguments[0];
	if (arguments[1] == null)
		p_month = new String(gNow.getMonth());
	else
		p_month = arguments[1];
	if (arguments[2] == "" || arguments[2] == null)
		p_year = new String(gNow.getFullYear().toString());
	else
		p_year = arguments[2];
	if (arguments[3] == null)
	
	//	p_format = "YYYY-MM-DD";         ===============================================  060303 �޸�Ĭ�ϵ�ʱ���ʽ
		p_format = "YYYYMMDD";
	else
		p_format = arguments[3];

	Build(p_item, p_month, p_year, p_format);
}
/*
Yearly Calendar Code Starts here
*/
function show_yearly_calendar() {
	

	p_item = arguments[0];
	if (arguments[1] == "" || arguments[1] == null)
		p_year = new String(gNow.getFullYear().toString());
	else
		p_year = arguments[1];
	if (arguments[2] == null)
	//	p_format = "YYYY-MM-DD";         ===============================================
		p_format = "YYYYMMDD";
	else
		p_format = arguments[2];

	Build(p_item, null, p_year, p_format);
}


var INARRAY=1;
var CAPARRAY=2;
var STICKY=3;
var BACKGROUND=4;
var NOCLOSE=5;
var CAPTION=6;
var LEFT=7;
var RIGHT=8;
var CENTER=9;
var OFFSETX=10;
var OFFSETY=11;
var FGCOLOR=12;
var BGCOLOR=13;
var TEXTCOLOR=14;
var CAPCOLOR=15;
var CLOSECOLOR=16;
var WIDTH=17;
var BORDER=18;
var STATUS=19;
var AUTOSTATUS=20;
var AUTOSTATUSCAP=21;
var HEIGHT=22;
var CLOSETEXT=23;
var SNAPX=24;
var SNAPY=25;
var FIXX=26;
var FIXY=27;
var FGBACKGROUND=28;
var BGBACKGROUND=29;
var PADX=30;// PADX2 out
var PADY=31;// PADY2 out
var FULLHTML=34;
var ABOVE=35;
var BELOW=36;
var CAPICON=37;
var TEXTFONT=38;
var CAPTIONFONT=39;
var CLOSEFONT=40;
var TEXTSIZE=41;
var CAPTIONSIZE=42;
var CLOSESIZE=43;
var FRAME=44;
var TIMEOUT=45;
var FUNCTION=46;
var DELAY=47;
var HAUTO=48;
var VAUTO=49;
var CLOSECLICK=50;
var CSSOFF=51;
var CSSSTYLE=52;
var CSSCLASS=53;
var FGCLASS=54;
var BGCLASS=55;
var TEXTFONTCLASS=56;
var CAPTIONFONTCLASS=57;
var CLOSEFONTCLASS=58;
var PADUNIT=59;
var HEIGHTUNIT=60;
var WIDTHUNIT=61;
var TEXTSIZEUNIT=62;
var TEXTDECORATION=63;
var TEXTSTYLE=64;
var TEXTWEIGHT=65;
var CAPTIONSIZEUNIT=66;
var CAPTIONDECORATION=67;
var CAPTIONSTYLE=68;
var CAPTIONWEIGHT=69;
var CLOSESIZEUNIT=70;
var CLOSEDECORATION=71;
var CLOSESTYLE=72;
var CLOSEWEIGHT=73;
if(typeof ol_fgcolor=='undefined'){var ol_fgcolor="#CCCCFF";}
if(typeof ol_bgcolor=='undefined'){var ol_bgcolor="#333399";}
if(typeof ol_textcolor=='undefined'){var ol_textcolor="#000000";}
if(typeof ol_capcolor=='undefined'){var ol_capcolor="#FFFFFF";}
if(typeof ol_closecolor=='undefined'){var ol_closecolor="#9999FF";}
if(typeof ol_textfont=='undefined'){var ol_textfont="Verdana,Arial,Helvetica";}
if(typeof ol_captionfont=='undefined'){var ol_captionfont="Verdana,Arial,Helvetica";}
if(typeof ol_closefont=='undefined'){var ol_closefont="Verdana,Arial,Helvetica";}
if(typeof ol_textsize=='undefined'){var ol_textsize="1";}
if(typeof ol_captionsize=='undefined'){var ol_captionsize="1";}
if(typeof ol_closesize=='undefined'){var ol_closesize="1";}
if(typeof ol_width=='undefined'){var ol_width="200";}
if(typeof ol_border=='undefined'){var ol_border="1";}
if(typeof ol_offsetx=='undefined'){var ol_offsetx=10;}
if(typeof ol_offsety=='undefined'){var ol_offsety=10;}
if(typeof ol_text=='undefined'){var ol_text="Default Text";}
if(typeof ol_cap=='undefined'){var ol_cap="";}
if(typeof ol_sticky=='undefined'){var ol_sticky=0;}
if(typeof ol_background=='undefined'){var ol_background="";}
if(typeof ol_close=='undefined'){var ol_close="Close";}
if(typeof ol_hpos=='undefined'){var ol_hpos=8;}
if(typeof ol_status=='undefined'){var ol_status="";}
if(typeof ol_autostatus=='undefined'){var ol_autostatus=0;}
if(typeof ol_height=='undefined'){var ol_height=-1;}
if(typeof ol_snapx=='undefined'){var ol_snapx=0;}
if(typeof ol_snapy=='undefined'){var ol_snapy=0;}
if(typeof ol_fixx=='undefined'){var ol_fixx=-1;}
if(typeof ol_fixy=='undefined'){var ol_fixy=-1;}
if(typeof ol_fgbackground=='undefined'){var ol_fgbackground="";}
if(typeof ol_bgbackground=='undefined'){var ol_bgbackground="";}
if(typeof ol_padxl=='undefined'){var ol_padxl=1;}
if(typeof ol_padxr=='undefined'){var ol_padxr=1;}
if(typeof ol_padyt=='undefined'){var ol_padyt=1;}
if(typeof ol_padyb=='undefined'){var ol_padyb=1;}
if(typeof ol_fullhtml=='undefined'){var ol_fullhtml=0;}
if(typeof ol_vpos=='undefined'){var ol_vpos=36;}
if(typeof ol_aboveheight=='undefined'){var ol_aboveheight=0;}
if(typeof ol_caption=='undefined'){var ol_capicon="";}
if(typeof ol_frame=='undefined'){var ol_frame=self;}
if(typeof ol_timeout=='undefined'){var ol_timeout=0;}
if(typeof ol_function=='undefined'){var ol_function=Function();}
if(typeof ol_delay=='undefined'){var ol_delay=0;}
if(typeof ol_hauto=='undefined'){var ol_hauto=0;}
if(typeof ol_vauto=='undefined'){var ol_vauto=0;}
if(typeof ol_closeclick=='undefined'){var ol_closeclick=0;}
if(typeof ol_css=='undefined'){var ol_css=51;}
if(typeof ol_fgclass=='undefined'){var ol_fgclass="";}
if(typeof ol_bgclass=='undefined'){var ol_bgclass="";}
if(typeof ol_textfontclass=='undefined'){var ol_textfontclass="";}
if(typeof ol_captionfontclass=='undefined'){var ol_captionfontclass="";}
if(typeof ol_closefontclass=='undefined'){var ol_closefontclass="";}
if(typeof ol_padunit=='undefined'){var ol_padunit="px";}
if(typeof ol_heightunit=='undefined'){var ol_heightunit="px";}
if(typeof ol_widthunit=='undefined'){var ol_widthunit="px";}
if(typeof ol_textsizeunit=='undefined'){var ol_textsizeunit="px";}
if(typeof ol_textdecoration=='undefined'){var ol_textdecoration="none";}
if(typeof ol_textstyle=='undefined'){var ol_textstyle="normal";}
if(typeof ol_textweight=='undefined'){var ol_textweight="normal";}
if(typeof ol_captionsizeunit=='undefined'){var ol_captionsizeunit="px";}
if(typeof ol_captiondecoration=='undefined'){var ol_captiondecoration="none";}
if(typeof ol_captionstyle=='undefined'){var ol_captionstyle="normal";}
if(typeof ol_captionweight=='undefined'){var ol_captionweight="bold";}
if(typeof ol_closesizeunit=='undefined'){var ol_closesizeunit="px";}
if(typeof ol_closedecoration=='undefined'){var ol_closedecoration="none";}
if(typeof ol_closestyle=='undefined'){var ol_closestyle="normal";}
if(typeof ol_closeweight=='undefined'){var ol_closeweight="normal";}
if(typeof ol_texts=='undefined'){var ol_texts=new Array("Text 0", "Text 1");}
if(typeof ol_caps=='undefined'){var ol_caps=new Array("Caption 0", "Caption 1");}
var otext="";
var ocap="";
var osticky=0;
var obackground="";
var oclose="Close";
var ohpos=8;
var ooffsetx=2;
var ooffsety=2;
var ofgcolor="";
var obgcolor="";
var otextcolor="";
var ocapcolor="";
var oclosecolor="";
var owidth=100;
var oborder=1;
var ostatus="";
var oautostatus=0;
var oheight=-1;
var osnapx=0;
var osnapy=0;
var ofixx=-1;
var ofixy=-1;
var ofgbackground="";
var obgbackground="";
var opadxl=0;
var opadxr=0;
var opadyt=0;
var opadyb=0;
var ofullhtml=0;
var ovpos=36;
var oaboveheight=0;
var ocapicon="";
var otextfont="Verdana,Arial,Helvetica";
var ocaptionfont="Verdana,Arial,Helvetica";
var oclosefont="Verdana,Arial,Helvetica";
var otextsize="1";
var ocaptionsize="1";
var oclosesize="1";
var oframe=self;
var otimeout=0;
var otimerid=0;
var oallowmove=0;
var ofunction=Function();
var odelay=0;
var odelayid=0;
var ohauto=0;
var ovauto=0;
var ocloseclick=0;
var ocss=51;
var ofgclass="";
var obgclass="";
var otextfontclass="";
var ocaptionfontclass="";
var oclosefontclass="";
var opadunit="px";
var oheightunit="px";
var owidthunit="px";
var otextsizeunit="px";
var otextdecoration="";
var otextstyle="";
var otextweight="";
var ocaptionsizeunit="px";
var ocaptiondecoration="";
var ocaptionstyle="";
var ocaptionweight="";
var oclosesizeunit="px";
var oclosedecoration="";
var oclosestyle="";
var ocloseweight="";
var ox=0;
var oy=0;
var oallow=0;
var oshowingsticky=0;
var oremovecounter=0;
var over=null;
var ns4=(document.layers)? true:false;
var ns6=(document.getElementById)? true:false;
var ie4=(document.all)? true:false;
var ie5=false;
if(ie4){
if((navigator.userAgent.indexOf('MSIE 5')> 0)||(navigator.userAgent.indexOf('MSIE 6')> 0)){
ie5=true;
}
if(ns6){
ns6=false;
}
}
if((ns4)||(ie4)||(ns6)){
document.onmousemove=mouseMove
if(ns4)document.captureEvents(Event.MOUSEMOVE)
}else{
overlib=no_overlib;
nd=no_overlib;
ver3fix=true;
}
function no_overlib(){
return ver3fix;
}
function overlib(){
otext=ol_text;
ocap=ol_cap;
osticky=ol_sticky;
obackground=ol_background;
oclose=ol_close;
ohpos=ol_hpos;
ooffsetx=ol_offsetx;
ooffsety=ol_offsety;
ofgcolor=ol_fgcolor;
obgcolor=ol_bgcolor;
otextcolor=ol_textcolor;
ocapcolor=ol_capcolor;
oclosecolor=ol_closecolor;
owidth=ol_width;
oborder=ol_border;
ostatus=ol_status;
oautostatus=ol_autostatus;
oheight=ol_height;
osnapx=ol_snapx;
osnapy=ol_snapy;
ofixx=ol_fixx;
ofixy=ol_fixy;
ofgbackground=ol_fgbackground;
obgbackground=ol_bgbackground;
opadxl=ol_padxl;
opadxr=ol_padxr;
opadyt=ol_padyt;
opadyb=ol_padyb;
ofullhtml=ol_fullhtml;
ovpos=ol_vpos;
oaboveheight=ol_aboveheight;
ocapicon=ol_capicon;
otextfont=ol_textfont;
ocaptionfont=ol_captionfont;
oclosefont=ol_closefont;
otextsize=ol_textsize;
ocaptionsize=ol_captionsize;
oclosesize=ol_closesize;
otimeout=ol_timeout;
ofunction=ol_function;
odelay=ol_delay;
ohauto=ol_hauto;
ovauto=ol_vauto;
ocloseclick=ol_closeclick;
ocss=ol_css;
ofgclass=ol_fgclass;
obgclass=ol_bgclass;
otextfontclass=ol_textfontclass;
ocaptionfontclass=ol_captionfontclass;
oclosefontclass=ol_closefontclass;
opadunit=ol_padunit;
oheightunit=ol_heightunit;
owidthunit=ol_widthunit;
otextsizeunit=ol_textsizeunit;
otextdecoration=ol_textdecoration;
otextstyle=ol_textstyle;
otextweight=ol_textweight;
ocaptionsizeunit=ol_captionsizeunit;
ocaptiondecoration=ol_captiondecoration;
ocaptionstyle=ol_captionstyle;
ocaptionweight=ol_captionweight;
oclosesizeunit=ol_closesizeunit;
oclosedecoration=ol_closedecoration;
oclosestyle=ol_closestyle;
ocloseweight=ol_closeweight;
if((ns4)||(ie4)||(ns6)){
oframe=ol_frame;
if(ns4)over=oframe.document.overDiv
if(ie4)over=oframe.overDiv.style
if(ns6)over=oframe.document.getElementById("overDiv");
}
var c=-1;
var ar=arguments;
for(i=0;i < ar.length;i++){
if(c < 0){
if(ar[i]==1){
otext=ol_texts[ar[++i]];
}else{
otext=ar[i];
}
c=0;
}else{
if(ar[i]==1){otext=ol_texts[ar[++i]];continue;}
if(ar[i]==2){ocap=ol_caps[ar[++i]];continue;}
if(ar[i]==3){osticky=1;continue;}
if(ar[i]==4){obackground=ar[++i];continue;}
if(ar[i]==NOCLOSE){oclose="";continue;}
if(ar[i]==6){ocap=ar[++i];continue;}
if(ar[i]==9 || ar[i]==7 || ar[i]==8){ohpos=ar[i];continue;}
if(ar[i]==10){ooffsetx=ar[++i];continue;}
if(ar[i]==11){ooffsety=ar[++i];continue;}
if(ar[i]==12){ofgcolor=ar[++i];continue;}
if(ar[i]==13){obgcolor=ar[++i];continue;}
if(ar[i]==14){otextcolor=ar[++i];continue;}
if(ar[i]==15){ocapcolor=ar[++i];continue;}
if(ar[i]==16){oclosecolor=ar[++i];continue;}
if(ar[i]==17){owidth=ar[++i];continue;}
if(ar[i]==18){oborder=ar[++i];continue;}
if(ar[i]==19){ostatus=ar[++i];continue;}
if(ar[i]==20){oautostatus=1;continue;}
if(ar[i]==21){oautostatus=2;continue;}
if(ar[i]==22){oheight=ar[++i];oaboveheight=ar[i];continue;}// Same param again.
if(ar[i]==23){oclose=ar[++i];continue;}
if(ar[i]==24){osnapx=ar[++i];continue;}
if(ar[i]==25){osnapy=ar[++i];continue;}
if(ar[i]==26){ofixx=ar[++i];continue;}
if(ar[i]==27){ofixy=ar[++i];continue;}
if(ar[i]==28){ofgbackground=ar[++i];continue;}
if(ar[i]==29){obgbackground=ar[++i];continue;}
if(ar[i]==30){opadxl=ar[++i];opadxr=ar[++i];continue;}
if(ar[i]==31){opadyt=ar[++i];opadyb=ar[++i];continue;}
if(ar[i]==34){ofullhtml=1;continue;}
if(ar[i]==36 || ar[i]==35){ovpos=ar[i];continue;}
if(ar[i]==37){ocapicon=ar[++i];continue;}
if(ar[i]==38){otextfont=ar[++i];continue;}
if(ar[i]==39){ocaptionfont=ar[++i];continue;}
if(ar[i]==40){oclosefont=ar[++i];continue;}
if(ar[i]==41){otextsize=ar[++i];continue;}
if(ar[i]==42){ocaptionsize=ar[++i];continue;}
if(ar[i]==43){oclosesize=ar[++i];continue;}
if(ar[i]==44){opt_FRAME(ar[++i]);continue;}
if(ar[i]==45){otimeout=ar[++i];continue;}
if(ar[i]==46){opt_FUNCTION(ar[++i]);continue;}
if(ar[i]==47){odelay=ar[++i];continue;}
if(ar[i]==48){ohauto=(ohauto==0)? 1 : 0;continue;}
if(ar[i]==49){ovauto=(ovauto==0)? 1 : 0;continue;}
if(ar[i]==50){ocloseclick=(ocloseclick==0)? 1 : 0;continue;}
if(ar[i]==51){ocss=ar[i];continue;}
if(ar[i]==52){ocss=ar[i];continue;}
if(ar[i]==53){ocss=ar[i];continue;}
if(ar[i]==54){ofgclass=ar[++i];continue;}
if(ar[i]==55){obgclass=ar[++i];continue;}
if(ar[i]==56){otextfontclass=ar[++i];continue;}
if(ar[i]==57){ocaptionfontclass=ar[++i];continue;}
if(ar[i]==58){oclosefontclass=ar[++i];continue;}
if(ar[i]==59){opadunit=ar[++i];continue;}
if(ar[i]==60){oheightunit=ar[++i];continue;}
if(ar[i]==61){owidthunit=ar[++i];continue;}
if(ar[i]==62){otextsizeunit=ar[++i];continue;}
if(ar[i]==63){otextdecoration=ar[++i];continue;}
if(ar[i]==64){otextstyle=ar[++i];continue;}
if(ar[i]==65){otextweight=ar[++i];continue;}
if(ar[i]==66){ocaptionsizeunit=ar[++i];continue;}
if(ar[i]==67){ocaptiondecoration=ar[++i];continue;}
if(ar[i]==68){ocaptionstyle=ar[++i];continue;}
if(ar[i]==69){ocaptionweight=ar[++i];continue;}
if(ar[i]==70){oclosesizeunit=ar[++i];continue;}
if(ar[i]==71){oclosedecoration=ar[++i];continue;}
if(ar[i]==72){oclosestyle=ar[++i];continue;}
if(ar[i]==73){ocloseweight=ar[++i];continue;}
}
}
if(odelay==0){
return overlib350();
}else{
odelayid=setTimeout("overlib350()", odelay);
if(osticky){
return false;
}else{
return true;
}
}
}
function nd(){
if(oremovecounter >=1){oshowingsticky=0};
if((ns4)||(ie4)||(ns6)){
if(oshowingsticky==0){
oallowmove=0;
if(over !=null)hideObject(over);
}else{
oremovecounter++;
}
}
return true;
}
function overlib350(){
var layerhtml;
if(obackground !="" || ofullhtml){
layerhtml=ol_content_background(otext, obackground, ofullhtml);
}else{
if(ofgbackground !="" && ocss==CSSOFF){
ofgbackground="BACKGROUND=\""+ofgbackground+"\"";
}
if(obgbackground !="" && ocss==CSSOFF){
obgbackground="BACKGROUND=\""+obgbackground+"\"";
}
if(ofgcolor !="" && ocss==CSSOFF){
ofgcolor="BGCOLOR=\""+ofgcolor+"\"";
}
if(obgcolor !="" && ocss==CSSOFF){
obgcolor="BGCOLOR=\""+obgcolor+"\"";
}
if(oheight > 0 && ocss==51){
oheight="HEIGHT=" + oheight;
}else{
oheight="";
}
if(ocap==""){
layerhtml=ol_content_simple(otext);
}else{
if(osticky){
layerhtml=ol_content_caption(otext, ocap, oclose);
}else{
layerhtml=ol_content_caption(otext, ocap, "");
}
}
}
if(osticky){
oshowingsticky=1;
oremovecounter=0;
}
layerWrite(layerhtml);
if(oautostatus > 0){
ostatus=otext;
if(oautostatus > 1){
ostatus=ocap;
}
}
oallowmove=0;
if(otimeout > 0){
if(otimerid > 0)clearTimeout(otimerid);
otimerid=setTimeout("cClick()", otimeout);
}
disp(ostatus);
if(osticky){
oallowmove=0;
return false;
}else{
return true;
}
}
function ol_content_simple(text){
if(ocss==CSSCLASS)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING="+oborder+" CELLSPACING=0 class=\""+obgclass+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 class=\""+ofgclass+"\"><TR><TD VALIGN=TOP><FONT class=\""+otextfontclass+"\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if(ocss==CSSSTYLE)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING="+oborder+" CELLSPACING=0 style=\"background-color: "+obgcolor+";height: "+oheight+oheightunit+";\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 style=\"color: "+ofgcolor+";background-color: "+ofgcolor+";height: "+oheight+oheightunit+";\"><TR><TD VALIGN=TOP><FONT style=\"font-family: "+otextfont+";color: "+otextcolor+";font-size: "+otextsize+otextsizeunit+";text-decoration: "+otextdecoration+";font-weight: "+otextweight+";font-style:"+otextstyle+"\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if(ocss==CSSOFF)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING="+oborder+" CELLSPACING=0 "+obgcolor+" "+oheight+"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 "+ofgcolor+" "+ofgbackground+" "+oheight+"><TR><TD VALIGN=TOP><FONT FACE=\""+otextfont+"\" COLOR=\""+otextcolor+"\" SIZE=\""+otextsize+"\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
set_background("");
return txt;
}
function ol_content_caption(text, title, close){
closing="";
closeevent="onMouseOver";
if(ocloseclick==1)closeevent="onClick";
if(ocapicon !="")ocapicon="<IMG SRC=\""+ocapicon+"\"> ";
if(close !=""){
if(ocss==CSSCLASS)closing="<TD ALIGN=RIGHT><A HREF=\"/\" "+closeevent+"=\"return cClick();\" class=\""+oclosefontclass+"\">"+close+"</A></TD>";
if(ocss==CSSSTYLE)closing="<TD ALIGN=RIGHT><A HREF=\"/\" "+closeevent+"=\"return cClick();\" style=\"color: "+oclosecolor+";font-family: "+oclosefont+";font-size: "+oclosesize+oclosesizeunit+";text-decoration: "+oclosedecoration+";font-weight: "+ocloseweight+";font-style:"+oclosestyle+";\">"+close+"</A></TD>";
if(ocss==CSSOFF)closing="<TD ALIGN=RIGHT><A HREF=\"/\" "+closeevent+"=\"return cClick();\"><FONT COLOR=\""+oclosecolor+"\" FACE=\""+oclosefont+"\" SIZE=\""+oclosesize+"\">"+close+"</FONT></A></TD>";
}
if(ocss==CSSCLASS)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING="+oborder+" CELLSPACING=0 class=\""+obgclass+"\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><FONT class=\""+ocaptionfontclass+"\">"+ocapicon+title+"</FONT></TD>"+closing+"</TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 class=\""+ofgclass+"\"><TR><TD VALIGN=TOP><FONT class=\""+otextfontclass+"\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if(ocss==CSSSTYLE)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING="+oborder+" CELLSPACING=0 style=\"background-color: "+obgcolor+";background-image: url("+obgbackground+");height: "+oheight+oheightunit+";\"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><FONT style=\"font-family: "+ocaptionfont+";color: "+ocapcolor+";font-size: "+ocaptionsize+ocaptionsizeunit+";font-weight: "+ocaptionweight+";font-style: "+ocaptionstyle+";\">"+ocapicon+title+"</FONT></TD>"+closing+"</TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 style=\"color: "+ofgcolor+";background-color: "+ofgcolor+";height: "+oheight+oheightunit+";\"><TR><TD VALIGN=TOP><FONT style=\"font-family: "+otextfont+";color: "+otextcolor+";font-size: "+otextsize+otextsizeunit+";text-decoration: "+otextdecoration+";font-weight: "+otextweight+";font-style:"+otextstyle+"\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
if(ocss==CSSOFF)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING="+oborder+" CELLSPACING=0 "+obgcolor+" "+obgbackground+" "+oheight+"><TR><TD><TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD><B><FONT COLOR=\""+ocapcolor+"\" FACE=\""+ocaptionfont+"\" SIZE=\""+ocaptionsize+"\">"+ocapicon+title+"</FONT></B></TD>"+closing+"</TR></TABLE><TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0 "+ofgcolor+" "+ofgbackground+" "+oheight+"><TR><TD VALIGN=TOP><FONT COLOR=\""+otextcolor+"\" FACE=\""+otextfont+"\" SIZE=\""+otextsize+"\">"+text+"</FONT></TD></TR></TABLE></TD></TR></TABLE>";
set_background("");
return txt;
}
function ol_content_background(text, picture, hasfullhtml){
if(hasfullhtml){
txt=text;
}else{
if(ocss==CSSCLASS)txt="<TABLE WIDTH="+owidth+owidthunit+" BORDER=0 CELLPADDING=0 CELLSPACING=0 HEIGHT="+oheight+oheightunit+"><TR><TD COLSPAN=3 HEIGHT="+opadyt+opadunit+"></TD></TR><TR><TD WIDTH="+opadxl+opadunit+"></TD><TD VALIGN=TOP WIDTH="+(owidth-opadxl-opadxr)+opadunit+"><FONT class=\""+otextfontclass+"\">"+text+"</FONT></TD><TD WIDTH="+opadxr+opadunit+"></TD></TR><TR><TD COLSPAN=3 HEIGHT="+opadyb+opadunit+"></TD></TR></TABLE>";
if(ocss==CSSSTYLE)txt="<TABLE WIDTH="+owidth+owidthunit+" BORDER=0 CELLPADDING=0 CELLSPACING=0 HEIGHT="+oheight+oheightunit+"><TR><TD COLSPAN=3 HEIGHT="+opadyt+opadunit+"></TD></TR><TR><TD WIDTH="+opadxl+opadunit+"></TD><TD VALIGN=TOP WIDTH="+(owidth-opadxl-opadxr)+opadunit+"><FONT style=\"font-family: "+otextfont+";color: "+otextcolor+";font-size: "+otextsize+otextsizeunit+";\">"+text+"</FONT></TD><TD WIDTH="+opadxr+opadunit+"></TD></TR><TR><TD COLSPAN=3 HEIGHT="+opadyb+opadunit+"></TD></TR></TABLE>";
if(ocss==CSSOFF)txt="<TABLE WIDTH="+owidth+" BORDER=0 CELLPADDING=0 CELLSPACING=0 HEIGHT="+oheight+"><TR><TD COLSPAN=3 HEIGHT="+opadyt+"></TD></TR><TR><TD WIDTH="+opadxl+"></TD><TD VALIGN=TOP WIDTH="+(owidth-opadxl-opadxr)+"><FONT FACE=\""+otextfont+"\" COLOR=\""+otextcolor+"\" SIZE=\""+otextsize+"\">"+text+"</FONT></TD><TD WIDTH="+opadxr+"></TD></TR><TR><TD COLSPAN=3 HEIGHT="+opadyb+"></TD></TR></TABLE>";
}
set_background(picture);
return txt;
}
function set_background(pic){
if(pic==""){
if(ie4)over.backgroundImage="none";
if(ns6)over.style.backgroundImage="none";
}else{
if(ns4){
over.background.src=pic;
}else if(ie4){
over.backgroundImage="url("+pic+")";
}else if(ns6){
over.style.backgroundImage="url("+pic+")";
}
}
}
function disp(statustext){
if((ns4)||(ie4)||(ns6)){
if(oallowmove==0){
placeLayer();
showObject(over);
oallowmove=1;
}
}
if(statustext !=""){
self.status=statustext;
}
}
function placeLayer(){
var placeX, placeY;
if(ofixx > -1){
placeX=ofixx;
}else{
winoffset=(ie4)? oframe.document.body.scrollLeft : oframe.pageXOffset;
if(ie4)iwidth=oframe.document.body.clientWidth;
if(ns4)iwidth=oframe.innerWidth;// was screwed in mozilla, fixed now?
if(ns6)iwidth=oframe.outerWidth;
if(ohauto==1){
if((ox - winoffset)>((eval(iwidth))/ 2)){
ohpos=7;
}else{
ohpos=8;
}
}
if(ohpos==9){// Center
placeX=ox+ooffsetx-(owidth/2);
}
if(ohpos==8){// Right
placeX=ox+ooffsetx;
if((eval(placeX)+ eval(owidth))>(winoffset + iwidth)){
placeX=iwidth + winoffset - owidth;
if(placeX < 0)placeX=0;
}
}
if(ohpos==7){// Left
placeX=ox-ooffsetx-owidth;
if(placeX < winoffset)placeX=winoffset;
}
if(osnapx > 1){
var snapping=placeX % osnapx;
if(ohpos==7){
placeX=placeX -(osnapx + snapping);
}else{
placeX=placeX +(osnapx - snapping);
}
if(placeX < winoffset)placeX=winoffset;
}
}
if(ofixy > -1){
placeY=ofixy;
}else{
scrolloffset=(ie4)? oframe.document.body.scrollTop : oframe.pageYOffset;
if(ovauto==1){
if(ie4)iheight=oframe.document.body.clientHeight;
if(ns4)iheight=oframe.innerHeight;
if(ns6)iheight=oframe.outerHeight;
iheight=(eval(iheight))/ 2;
if((oy - scrolloffset)> iheight){
ovpos=35;
}else{
ovpos=36;
}
}
if(ovpos==35){
if(oaboveheight==0){
var divref=(ie4)? oframe.document.all['overDiv'] : over;
oaboveheight=(ns4)? divref.clip.height : divref.offsetHeight;
}
placeY=oy -(oaboveheight + ooffsety);
if(placeY < scrolloffset)placeY=scrolloffset;
}else{
placeY=oy + ooffsety;
}
if(osnapy > 1){
var snapping=placeY % osnapy;
if(oaboveheight > 0 && ovpos==35){
placeY=placeY -(osnapy + snapping);
}else{
placeY=placeY +(osnapy - snapping);
}
if(placeY < scrolloffset)placeY=scrolloffset;
}
}
repositionTo(over, placeX, placeY);
}
function mouseMove(e){
if((ns4)||(ns6)){ox=e.pageX;oy=e.pageY;}
if(ie4){ox=event.x;oy=event.y;}
if(ie5){ox=event.x+oframe.document.body.scrollLeft;oy=event.y+oframe.document.body.scrollTop;}
if(oallowmove==1){
placeLayer();
}
}
function cClick(){
hideObject(over);
oshowingsticky=0;
return false;
}
function compatibleframe(frameid){
if(ns4){
if(typeof frameid.document.overDiv=='undefined')return false;
}else if(ie4){
if(typeof frameid.document.all["overDiv"]=='undefined')return false;
}else if(ns6){
if(frameid.document.getElementById('overDiv')==null)return false;
}
return true;
}
function layerWrite(txt){
txt +="\n";
if(ns4){
var lyr=oframe.document.overDiv.document
lyr.write(txt)
lyr.close()
}else if(ie4){
oframe.document.all["overDiv"].innerHTML=txt
}else if(ns6){
range=oframe.document.createRange();
range.setStartBefore(over);
domfrag=range.createContextualFragment(txt);
while(over.hasChildNodes()){
over.removeChild(over.lastChild);
}
over.appendChild(domfrag);
}
}
function showObject(obj){
if(ns4)obj.visibility="show";
else if(ie4)obj.visibility="visible";
else if(ns6)obj.style.visibility="visible";
}
function hideObject(obj){
if(ns4)obj.visibility="hide";
else if(ie4)obj.visibility="hidden";
else if(ns6)obj.style.visibility="hidden";
if(otimerid > 0)clearTimeout(otimerid);
if(odelayid > 0)clearTimeout(odelayid);
otimerid=0;
odelayid=0;
self.status="";
}
function repositionTo(obj,xL,yL){
if((ns4)||(ie4)){
obj.left=xL;
obj.top=yL;
}else if(ns6){
obj.style.left=xL + "px";
obj.style.top=yL+ "px";
}
}
function opt_FRAME(frm){
oframe=compatibleframe(frm)? frm : ol_frame;
if((ns4)||(ie4 ||(ns6))){
if(ns4)over=oframe.document.overDiv;
if(ie4)over=oframe.overDiv.style;
if(ns6)over=oframe.document.getElementById("overDiv");
}
return 0;
}
function opt_FUNCTION(callme){
otext=callme()
return 0;
}
