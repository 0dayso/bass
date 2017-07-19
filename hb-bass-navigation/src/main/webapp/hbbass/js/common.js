//数字校验
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

//日期选择
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
  // 年份下拉框控件校验   thisobj: 所变动的控件    month: 月份下拉框控件名   day: 日子下拉框控件名
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
  // 月份下拉框控件校验   thisobj: 所变动的控件    year: 年份下拉框控件名   day: 日子下拉框控件名
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

//打开“客户明细”
function openList(regulation_id)
{
  window.open('./hiveoff_result_list.jsp?regulation_id='+regulation_id+'','_blank',' toolbar=yes,location=no,directories=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes');
}

function doSelectOper(){
  for (var i = formx.subopertype.options.length-1;i>=0;--i)
  {
    formx.subopertype.options.remove(i);
  }
	
  varTemp=document.formx.opertype.options(document.formx.opertype.selectedIndex).value;
	
       if(document.formx.opertype.selectedIndex<1||document.formx.opertype.selectedIndex==null){return;}
	var opertype=document.formx.opertype.options(document.formx.opertype.selectedIndex).value;
	var oXmlDoc=new ActiveXObject('MSXML');
	var sUrl='select_sp_xml.jsp?opertype='+opertype;
	oXmlDoc.url=sUrl;
	var oRoot=oXmlDoc.root;

	if(oRoot.children !=null)
	{
		for(var i=0;i<oRoot.children.length;++i)
		{
			   var oItem2=oRoot.children.item(i).children.item(0);
			   var oItem3=oRoot.children.item(i).children.item(1);
			   sValue=oItem2.text;
			   sName=oItem3.text;
			   
			   var oOption = document.createElement('OPTION');
			   oOption.value=sValue;
			   oOption.text=sName;
			   formx.subopertype.options.add(oOption);
		}	
	
	}
}


function adv_format(value,num) //四舍五入
{
var a_str = formatnumber(value,num);
var a_int = parseFloat(a_str);
if (value.toString().length>a_str.length)
{
var b_str = value.toString().substring(a_str.length,a_str.length+1)
var b_int = parseFloat(b_str);
if (b_int<5)
{
return a_str
}
else
{
var bonus_str,bonus_int;
if (num==0)
{
bonus_int = 1;
}
else
{
bonus_str = "0."
for (var i=1; i<num; i++)
bonus_str+="0";
bonus_str+="1";
bonus_int = parseFloat(bonus_str);
}
a_str = formatnumber(a_int + bonus_int, num)
}
}
// 20061128 添加去小数点后0的操作,将3.00 换成3
if(a_str.indexOf('.')!=-1)
{
   if(parseFloat(a_str)-parseFloat(a_str.substring(0,a_str.indexOf('.')))==0)
   a_str=a_str.substring(0,a_str.indexOf('.'));
}
return a_str
}


function formatnumber(value,num) //直接去尾
{
var a,b,c,i
a = value.toString();
b = a.indexOf('.');
c = a.length;
if (num==0)
{
if (b!=-1)
a = a.substring(0,b);
}
else
{
if (b==-1)
{
a = a + ".";
for (i=1;i<=num;i++)
a = a + "0";
}
else
{
a = a.substring(0,b+num+1);
for (i=c;i<=b+num;i++)
a = a + "0";
}
}
return a
}

/*
*  tid 要进行计算的tbody的名称
*  startrow 开始行 0
*  startcol 开始列 0
*/
function do_tab_sum(tid,startrow,startcol)
{
  var tbody=document.getElementById(tid);
  var trnum= tbody.children.length-1;  // 表格行数 ,最后行作为合计备用
  var tdnum=tbody.children.item(0).children.length-1; //列数,最右边的列作为合计备用
  var everyrowsum=new Array();  //计算每行的和值
  var everycolsum=new Array();  //计算每列的和值
  for(i=startrow;i<trnum;i++)
  {
  	everyrowsum[i]=0.0;
  	for(j=startcol;j<tdnum;j++)
  	{
  		if(tbody.children.item(i).children.item(j).className=="number"&&tbody.children.item(i).children.item(j).innerHTML.length!=0&&!isNaN(tbody.children.item(i).children.item(j).innerHTML))
  		{
  			everyrowsum[i]+=parseFloat(tbody.children.item(i).children.item(j).innerHTML);
   		}
  
  	}
	if(everyrowsum[i]!=0)
	{
	 tbody.children.item(i).children.item(tdnum).innerHTML=adv_format(everyrowsum[i],2);
	 }
	 else
	 {
	   tbody.children.item(i).children.item(tdnum).innerHTML="--";
	 }
  		//alert("everyrowsum["+i+"]="+everyrowsum[i]);
  }
  for(i=startcol;i<tdnum+1;i++)
  {
		  	everycolsum[i]=0.0;
		  	for(j=startrow;j<trnum;j++)
		    {
		  	   if(tbody.children.item(j).children.item(i).className=="number"&&tbody.children.item(j).children.item(i).innerHTML.length!=0&&!isNaN(tbody.children.item(j).children.item(i).innerHTML))
  		     {
		  	      everycolsum[i]+=parseFloat(tbody.children.item(j).children.item(i).innerHTML);
		  	   }
		  	  
		  	}
			if(everycolsum[i]!=0)
			{
			tbody.children.item(trnum).children.item(i).innerHTML=adv_format(everycolsum[i],2);
			}
			else
			{
			tbody.children.item(trnum).children.item(i).innerHTML="--";
			}
			
		  	//alert("everycolsum["+i+"]="+everycolsum[i]);
  	}

}


