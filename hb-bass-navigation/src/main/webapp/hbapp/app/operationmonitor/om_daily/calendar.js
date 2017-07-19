var weekend = [0,6];
var fontsize = 2;
var gNow = new Date();
isNav = (navigator.appName.indexOf("Netscape") != -1) ? true : false;
isIE = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;
// Non-Leap year Month days..
Calendar.DOMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
// Leap year Month days..
Calendar.lDOMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
function Calendar(options) {
    		options = options || {};
        this.gYear = gNow.getFullYear() + "";
        this.gMonth = gNow.getMonth() + "";
        this.gFormat = options.format||"YYYYMMDD";
        this.gBGColor = "white";
        this.gFGColor = "black";
        this.gTextColor = "black";
        this.gHeaderColor = "black";
        var _month = (parseInt(this.gMonth,10)+1)+"";
		_month = (_month.length==1?"0":"")+_month;
		var _date = gNow.getDate()+"";
		_date = (_date.length==1?"0":"")+_date;
        this.returnDate = this.gYear+_month+_date;
        this.calHTML = "";
        this.container = (typeof options.container == "string")?document.getElementById(options.container):options.container;
}
Calendar.get_daysofmonth = Calendar_get_daysofmonth;
Calendar.calc_month_year = Calendar_calc_month_year;
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
//new Calendar();
Calendar.prototype.render = function() {
        this.calHTML = "";
        var vCode = ""; 

        /*this.gWinCal.document.open();
        // Setup the page...
        this.wwrite("<html>");
        this.wwrite("<head><title>Calendar</title>");
        vCode = this.cal_style();
        this.wwrite(vCode);
        this.wwrite("</head>");
        this.wwrite("<body>");*/
                // Show navigation buttons
       
        
        this.wwrite("<table border=0 cellpadding=0 cellspacing=1 class=Calendar>");
        this.wwrite("<thead>");
        this.wwrite("<tr align=\"center\" valign=\"middle\">");
        this.wwrite("<td class=\"CalendarTitle\" colspan=\"7\">");
        this.wwrite("<A class=\"DayButton\" title=\"上一年\" HREF=\"javascript:void(0)\" onclick=\"{calendar.lastYear()}\">7<\/A>&nbsp;");
        this.wwrite("<A class=\"DayButton\" title=\"上一月\" HREF=\"javascript:void(0)\" onclick=\"{calendar.lastMonth()}\">3<\/A>&nbsp;");
        
        this.wwrite("<input maxlength=\"4\" name=\"year\" size=\"4\" readonly type=\"text\" value=" + this.gYear + " />年");
        this.wwrite("<input maxlength=\"2\" name=\"month\" size=\"1\" readonly type=\"text\" value=" + (parseInt(this.gMonth) + 1) + " />月");
        
        this.wwrite("<A class=\"DayButton\" title=\"下一月\" HREF=\"javascript:void(0)\" onclick=\"{calendar.nextMonth()}\">4<\/A>&nbsp;");
        this.wwrite("<A class=\"DayButton\" title=\"下一年\" HREF=\"javascript:void(0)\" onclick=\"{calendar.nextYear()}\">8<\/A>&nbsp;");
        
        vCode = "";
        vCode = "<TR>";
        vCode = vCode + "<TD class=DaySunTitle>日</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>一</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>二</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>三</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>四</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>五</FONT></TD>";
        vCode = vCode + "<TD class=DaySatTitle>六</FONT></TD>";
        vCode = vCode + "</TR></thead>";
        this.wwrite(vCode);
        
        // Get the complete calendar code for the month..
        vCode = this.getMonthlyCalendarCode();
        this.wwrite(vCode);
        
        this.wwrite("</font>");
        /*this.wwrite("</body></html>");
        this.gWinCal.document.close();*/
        
        if(this.container)this.container.innerHTML=this.calHTML;
} 

Calendar.prototype.lastYear = function() {
				this.gYear = (parseInt(this.gYear,10)-1) +"";
				this.render();
}

Calendar.prototype.nextYear = function() {
				this.gYear = (parseInt(this.gYear,10)+1) +"";
				this.render();
}

Calendar.prototype.lastMonth = function() {
				var prevMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, -1);
        var prevMM = prevMMYYYY[0];
        var prevYYYY = prevMMYYYY[1];
				this.gYear = prevYYYY+"";
				this.gMonth = prevMM+""
				this.render();
}

Calendar.prototype.nextMonth = function() {
				var nextMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, 1);
        var nextMM = nextMMYYYY[0];
        var nextYYYY = nextMMYYYY[1];
				this.gYear = nextYYYY+"";
				this.gMonth = nextMM+""	
				this.render();
}

Calendar.prototype.setReturnDate = function(returnDate,el) {
				var _month = (parseInt(this.gMonth,10)+1)+"";
				_month = (_month.length==1?"0":"")+_month;
				this.returnDate = this.gYear+_month+returnDate;
}

Calendar.prototype.wwrite = function(wtext) {
				this.calHTML +=wtext;
}
Calendar.prototype.getMonthlyCalendarCode = function() {
        var vCode = "";
        var vHeader_Code = "";
        var vData_Code = "";
        
        // Begin Table Drawing code here..
        
        //vHeader_Code = this.cal_header();
       
        vData_Code = this.cal_data();
        vCode = vCode + vHeader_Code + vData_Code;
                
        return vCode;
}
Calendar.prototype.cal_header = function() {
        var vCode = "";
        vCode = "<TR>";
        vCode = vCode + "<TD class=DaySunTitle>日</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>一</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>二</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>三</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>四</FONT></TD>";
        vCode = vCode + "<TD class=DayTitle>五</FONT></TD>";
        vCode = vCode + "<TD class=DaySatTitle>六</FONT></TD>";
        vCode = vCode + "</TR></thead>"; 

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
        vCode = vCode + "<TR style='cursor:hand'>";
        for (i=0; i<vFirstDay; i++) {
                vCode = vCode + "<TD class=CalendarTD>&nbsp;</TD>";
        }
        // Write rest of the 1st week
        for (j=vFirstDay; j<7; j++) {
            if (j == 0){
                 vCode = vCode + "<TD class=DaySun><A class=DaySunA HREF='#' "
            }else{
                if (j == 6){
                     vCode = vCode + "<TD class=DaySat><A class=DaySatA HREF='#' "
                }else{
                    vCode = vCode + "<TD class=Day><A class=DayA HREF='#' "
                }
            }
            vCode = vCode + "onClick=\"{calendar.setReturnDate("+vDay+",this)}\">" + this.format_day(vDay) + "</A>" + "</TD>";
            vDay=vDay + 1;
        }
        vCode = vCode + "</TR>";
        // Write the rest of the weeks
        for (k=2; k<7; k++) {
                vCode = vCode + "<TR>";
                for (j=0; j<7; j++) {
                    if (j == 0){
                        vCode = vCode + "<TD class=DaySun><A class=DaySunA HREF='#' "
                    }else{
                        if (j == 6){
                            vCode = vCode + "<TD class=DaySat><A class=DaySatA HREF='#' "
                        }else{
                            vCode = vCode + "<TD class=Day><A class=DayA HREF='#' "
                        }
                    }
                vCode = vCode + "onClick=\"{calendar.setReturnDate("+vDay+",this);}\" >"+
                                this.format_day(vDay) + 
                                "</A>" + 
                                "</TD>";
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
                        vCode = vCode + "<TD class=CalendarTD>&nbsp;</TD>";
                else
                        vCode = vCode + "<TD class=CalendarTD>" + m + "</TD>";
        }
        
        return vCode;
}
Calendar.prototype.format_day = function(vday) {
        var vNowDay = gNow.getDate();
        var vNowMonth = gNow.getMonth();
        var vNowYear = gNow.getFullYear();
        if (vday == vNowDay && this.gMonth == vNowMonth && this.gYear == vNowYear)
                return ("<FONT COLOR=\"8B0000\"><B>" + vday + "</B></FONT>");
        else
                return (vday);
}
Calendar.prototype.format_data = function(p_day) {
        var vData;
        var vMonth = 1 + this.gMonth;
        vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
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
                case "MM-DD-YY" :
                        vData = vMonth + "-" + vDD + "-" + vY2;
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
                        vData = vY4 + vMonth + vDD ;
        }
        return vData;
}
