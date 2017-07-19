//����У��
function isNumeric(tstValue)
{
   var i=0;
   var str=""+tstValue;
   var l=str.length;
   var c=str.charAt(i++);
   var Ok="0123456789., ";

   while ((c==' ') && (i<l)) {
      c=str.charAt(i++);
   }
   if (i==l) return (Ok.indexOf(c)>=0);
   if ((c=='+')||(c=='-')) c=str.charAt(i++);
   while ((Ok.indexOf(c)>=0) && (i<l)) {
      c=str.charAt(i++);
   }
   if (i==l) return (Ok.indexOf(c)>=0);
   if ((c=='e')||(c=='E')) {
      c=str.charAt(i++);
      while ((c==' ') && (i<l)) {
         c=str.charAt(i++);
      }
      if (i==l) return true;
      if ((c=='+')||(c=='-')) c=str.charAt(i++);
      if (Ok.indexOf(c)<0) return false;
      while ((((c>='0')&&(c<='9'))||(c==' ')) && (i<l)) {
         c=str.charAt(i++);
      }
      return ((i==l) && (((c>='0')&&(c<='9'))||(c==' ')));
   }
   else
      return false;
}

//����ѡ��
function doHandleMonth(year,month,day){
if(month*1==2){
        if(year*1%4==0 || year*1%400==0)
        {
			  for (var i = day.options.length-1;i>=0;--i)
			  {
					day.options.remove(i);
			  }
					var nullOption = document.createElement('OPTION');
					nullOption.value="--";
					nullOption.text="--";
					day.options.add(nullOption);
			  for(var i=1;i<30;++i){
					var oOption = document.createElement('OPTION');
					i=(i>9)?i:""+"0"+i;
					oOption.value=i;
					oOption.text=i;
					day.options.add(oOption);
			   }
        }
        else
        {
				for (var i = day.options.length-1;i>=0;--i)
				{
					day.options.remove(i);
				}
				var nullOption = document.createElement('OPTION');
					nullOption.value="--";
					nullOption.text="--";
					day.options.add(nullOption);
				for(var i=1;i<29;++i){
					var oOption = document.createElement('OPTION');
							i=(i>9)?i:""+"0"+i;
					oOption.value=i;
					oOption.text=i;
					day.options.add(oOption);
				}
        }
}else if(month*1==4||month*1==6||month*1==9||month*1==11){
	for (var i = day.options.length-1;i>=0;--i)
	{
		day.options.remove(i);
	}
	var nullOption = document.createElement('OPTION');
					nullOption.value="--";
					nullOption.text="--";
					day.options.add(nullOption);
	for(var i=1;i<31;++i){
		var oOption = document.createElement('OPTION');
                i=(i>9)?i:""+"0"+i;
		oOption.value=i;
		oOption.text=i;
		day.options.add(oOption);
	}
}else{
	for (var i = day.options.length-1;i>=0;--i)
	{
		day.options.remove(i);
	}
	var nullOption = document.createElement('OPTION');
					nullOption.value="--";
					nullOption.text="--";
					day.options.add(nullOption);
	for(var i=1;i<32;++i){
		var oOption = document.createElement('OPTION');
		i=(i>9)?i:""+"0"+i;
                oOption.value=i;
		oOption.text=i;
		day.options.add(oOption);
	}
}

}

function validatebyyear (thisobj, month, day)
  // ���������ؼ�У��   thisobj: ���䶯�Ŀؼ�    month: �·�������ؼ���   day: ����������ؼ���
  // Daniel Lyx 2000-11-03
  
  { 
    monthobj = document.all (month);
    dayobj = document.all (day);
    SelectIndex = dayobj.selectedIndex;
    y = thisobj.options [thisobj.selectedIndex].text;
    
	if (monthobj.options [monthobj.selectedIndex].text == "2")
	  { if (y % 4 == 0 && y % 100 != 0 || y % 400 == 0)
          { ubound = 29;
          }
        else
          { ubound = 28;
          }
		for (i = dayobj.options.length - 1; i > ubound - 1; i--)
		   dayobj.remove (i);
		for (i = dayobj.options.length; i < ubound; i++)
		   { oOption = document.createElement ("OPTION");
		     oOption.text = i + 1;
		     dayobj.add (oOption);
		   }
		   
		if (SelectIndex > dayobj.options.length - 1)
		  { SelectIndex = dayobj.options.length - 1;
		  }
		dayobj.selectedIndex = SelectIndex;
	  }
  }

function validatebymonth (thisobj, year, day)
  // �·�������ؼ�У��   thisobj: ���䶯�Ŀؼ�    year: ���������ؼ���   day: ����������ؼ���
  // Daniel Lyx 2000-11-03
  
  { yearobj = document.all (year);
    dayobj = document.all (day);
    SelectIndex = dayobj.selectedIndex;
    y=yearobj.options [yearobj.selectedIndex].text;
    
    switch (thisobj.options [thisobj.selectedIndex].text)
      { case "2" :
          { if (y % 4 == 0 && y % 100 != 0 || y % 400 ==0)
              { ubound = 29;
              }
            else
              { ubound = 28;
              }
            break;
          }
        case "4" :
        case "6" :
        case "9" :
        case "11" :
          { ubound = 30;
            break;
          }
        default :
          { ubound = 31;
          }
      }
      
    for (i = dayobj.options.length - 1; i > ubound - 1; i--)
	   dayobj.remove (i);
	for (i = dayobj.options.length; i < ubound; i++)
	   { oOption = document.createElement ("OPTION");
	     oOption.text = i + 1;
	     dayobj.add (oOption);
	   }
	   
	if (SelectIndex > dayobj.options.length - 1)
	  { SelectIndex = dayobj.options.length - 1;
	  }
	dayobj.selectedIndex = SelectIndex;

   }
