<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.GregorianCalendar,java.text.SimpleDateFormat,java.util.*"%>
<%@ page import="com.asiainfo.database.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>一经数据质量平衡性</title>
<script src="/hbbass/js/calendarSubmit.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
<style>  
<!--  
.input_text   { width:90px;FONT-SIZE: 13px;text-align:right; BORDER:0px solid;background-color:#DFDFDF}  
.input_text_h { width:90px;FONT-SIZE: 13px;text-align:right;BORDER:0px solid;}
-->  
</style>
<style type="text/css">
	/*html, body {
        margin:0;
        padding:0;
        border:0 none;
        overflow:hidden;
        height:100%;
    }*/
  #loading{
		position:absolute;
		left:40%;
		top:35%;
		border:1px solid #6593cf;
		padding:2px;
		background:#c3daf9;
		width:200px;
		text-align:center;
		z-index:20001;
	}
	#loading .loading-indicator{
		border:1px solid #a3bad9;
		background:white url(/hbbass/common2/image/block-bg.gif) repeat-x;
		color:#003366;
		font:bold 13px tahoma,arial,helvetica;
		padding:10px;
		margin:0;
	}
</style>
<script language="JavaScript">

function createRequest()
{
	var xmlrequest = false;
	if(window.ActiveXObject)
		try{
			xmlrequest = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e){
			try{
				xmlrequest = new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e){}
		}
	else
		xmlrequest = new XMLHttpRequest();
		
	return xmlrequest;
} 

function toQuery()
{ 
	form1.action="boi.jsp";
	form1.submit();
}

function toupdate1()
{ 

	form1.sqlstr.value=genesql();
	form1.action="boi_db.jsp";
	form1.target="_blank";
	form1.submit();
}

function accAdd(arg1,arg2){ 
var r1,r2,m; 
try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0} 
try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0} 
m=Math.pow(10,Math.max(r1,r2)) 
return (arg1*m+arg2*m)/m 
} 
//给Number类型增加一个add方法，调用起来更加方便。 
Number.prototype.add = function (arg){ 
return accAdd(arg,this); 
}

function changeValue(textid)
{ 
	  var pos=textid.indexOf("_");
	  var formpre=textid.substring(0,pos);
	  var formid =textid.substring(pos+1);
	  var num=parseInt(formid/4);
	  
	  var form_s1=document.getElementById(formpre+"_"+((num*4)+1));
	  var form_s2=document.getElementById(formpre+"_"+((num*4)+2));
	  var form_s3=document.getElementById(formpre+"_"+((num*4)+3));
	  var form_s4=document.getElementById(formpre+"_"+((num*4)+4));
	  // form_s4.value=(parseFloat(form_s1.value)+parseFloat(form_s2.value)+parseFloat(form_s3.value)).toFixed(4);
	  form_s4.value=accAdd(accAdd(form_s1.value,form_s2.value),form_s3.value);
}

function genesql()
{
   var resultTbody=document.getElementById("resultTbody");	
   var rownum=resultTbody.rows.length; 
   var colnum=resultTbody.rows[0].cells.length;
   var strtemp="";

   for(i=1;i<=rownum;i++)
   {
    	if(strtemp=="")
    	{
    		strtemp=document.getElementById("charge_"+i).value+","+
    		        document.getElementById("acccharge_"+i).value+","+
    		        document.getElementById("simple_charge_"+i).value+","+
    		        document.getElementById("real_charge_"+i).value+","+
    		        document.getElementById("final_charge_"+i).value+","+
    		        document.getElementById("mon_charge_"+i).value+","+
    		        document.getElementById("kpicode_"+i).value+","+
    		        document.getElementById("brandcode_"+i).value;
    	}
    	else 
    	{
    		strtemp+="|"+document.getElementById("charge_"+i).value+","+
    		        document.getElementById("acccharge_"+i).value+","+
    		        document.getElementById("simple_charge_"+i).value+","+
    		        document.getElementById("real_charge_"+i).value+","+
    		        document.getElementById("final_charge_"+i).value+","+
    		        document.getElementById("mon_charge_"+i).value+","+
    		        document.getElementById("kpicode_"+i).value+","+
    		        document.getElementById("brandcode_"+i).value;
    	}	
   }
   return strtemp;
}

function  toupdate()
{
	 var querydate=form1.querydate.value;
	 var hidtoday=form1.hidtoday.value;
	 if(querydate<hidtoday)
	 {
	 	alert("昨天以前数据不允许修改！");
	 	return;
	 	}
	 var sqlstr=genesql();
	 
	xmlHttp = createRequest();
	xmlHttp.onreadystatechange=toQueryCallBack; // 设置回掉函数 
	xmlHttp.open("POST","boi_db.jsp",true);
 	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
 	var str="sqlstr="+sqlstr+"&querydate="+querydate;
  str=encodeURI(str,"UTF-8");  
	xmlHttp.send(str); 
}

//查询返回结果后的回调函数
function toQueryCallBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			var responseText=xmlHttp.responseText;
			alert(responseText);
			toQuery();
		}
	}
}
// 日历按钮点击后的回调函数，也就是修改日期后进行的动作
function calendarCallback()
{
   	toQuery();
}
</script>
<script language="JavaScript" type="text/javascript">
	function clearNoNum(obj)
	{
		if(isNaN(obj.value))
		{ 
	 		//先把非数字的都替换掉，除了数字和.
			obj.value = obj.value.replace(/[^\d.]/g,"");
			//必须保证第一个为数字而不是.
			obj.value = obj.value.replace(/^\./g,"");
			//保证只有出现一个.而没有多个.
			obj.value = obj.value.replace(/\.{2,}/g,".");
			//保证.只出现一次，而不能出现两次以上
			obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
		}
	}
	function saveExcel()
	{
	  var sql=document.form1.sql.value;
		form1.action="/hbbass/test/saveExcel.jsp?sql="+sql;
		form1.target="_top";
		form1.submit();
	}
	function updateRow(rownumber,querydate,kpicode,brandcode)
	{ 
		var obj1 = document.getElementById("charge_"+rownumber);
		var obj2 = document.getElementById("acccharge_"+rownumber);
   	var charge= obj1.value;
   	var act_charge = obj2.value;
  	xmlHttp = createRequest();
		xmlHttp.onreadystatechange=toUpdateCallBack; // 设置回掉函数 
		xmlHttp.open("POST","boi_db2.jsp",true);
 		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
 		var str="querydate="+querydate+"&kpicode="+kpicode+"&brandcode="+brandcode+"&charge="+charge+"&act_charge="+act_charge;
  	//alert(str);
  	str=encodeURI(str,"UTF-8");
  	loadmask.style.display="block";
		xmlHttp.send(str);
	}
	//更新单行后的回调函数
	function toUpdateCallBack()
	{
		if(xmlHttp.readyState == 4)
		{
			if(xmlHttp.status == 200)
			{
				var responseText=xmlHttp.responseText;
				alert(responseText);
				toQuery();
				loadmask.style.display="none";
			}
		}
	}
</script>

</head>
<%
   Calendar cal= GregorianCalendar.getInstance();
   cal.add(Calendar.DATE,-1);
   String modiYear=String.valueOf(cal.get(Calendar.YEAR));              //年
   String modiMonth=(cal.get(Calendar.MONTH)+1)>9?String.valueOf(cal.get(Calendar.MONTH)+1):"0"+String.valueOf(cal.get(Calendar.MONTH)+1);          //月
   String modiDate=(cal.get(Calendar.DATE))>9?String.valueOf(cal.get(Calendar.DATE)):"0"+String.valueOf(cal.get(Calendar.DATE)); 
  
   String today=modiYear+"-"+modiMonth+"-"+modiDate;
   String querydate=request.getParameter("querydate")==null?today:request.getParameter("querydate");
   
   String sql="select a.KPINAME,b.happdate,case  when b.happdate<(current date -1 day) then '0' else '1' end as flag,value(b.CHARGE,0) CHARGE,value(b.ACT_CHARGE,0) ACT_CHARGE,value(b.SIMPLE_CHARGE,0) SIMPLE_CHARGE,value(b.REAL_CHARGE,0) REAL_CHARGE,value(b.FINAL_CHARGE,0) FINAL_CHARGE,value(b.PRE_CHARGE,0) PRE_CHARGE,value(b.MON_CHARGE,0) MON_CHARGE, a.KPICODE, rtrim(a.BRANDCODE) BRANDCODE from BOI.MIS_DAILYRP_RESEND_CFG a left join BOI.MIS_DAILYRP_RESEND b "+
              " on rtrim(a.KPICODE)=rtrim(b.KPICODE) and rtrim(a.BRANDCODE)=rtrim(b.BRANDCODE) and b.happdate='"+querydate+"' order by a.KPICODE,a.BRANDCODE";
   //out.println(sql);
    String sql1  ="select a.KPINAME,b.happdate,value(b.CHARGE,0) CHARGE,value(b.SIMPLE_CHARGE,0) SIMPLE_CHARGE,value(b.REAL_CHARGE,0) REAL_CHARGE,value(b.ACT_CHARGE,0) ACT_CHARGE,value(b.PRE_CHARGE,0) PRE_CHARGE,value(b.FINAL_CHARGE,0) FINAL_CHARGE,value(b.MON_CHARGE,0) MON_CHARGE from BOI.MIS_DAILYRP_RESEND_CFG a left join BOI.MIS_DAILYRP_RESEND b "+
              " on rtrim(a.KPICODE)=rtrim(b.KPICODE) and rtrim(a.BRANDCODE)=rtrim(b.BRANDCODE) and b.happdate='"+querydate+"' order by a.KPICODE,a.BRANDCODE";
    Sqlca sqlca = null;
    try {
						sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
						sqlca.execute(sql);
%>
<body>
<form id="form1" name="form1" method="post" action="">
	<input type="hidden" name="sqlstr" value="">
	<input type="hidden" name="hidtoday" value="<%=today%>">
  <table id="searchCond" width="95%" align="center" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0"> 
    <tr>
      <td width="20%" align="right" class="dim_cell_title">时间</td>
      <td width="80%" class="dim_cell_content"><input type="text" name="querydate" id="querydate" value="<%=querydate%>" size="8" maxlength="8" readonly onchange="alert('dd')">
         <a  onClick="event.cancelBubble=true;" href="javascript:showCalendar('imageCalendar1',false,'querydate',null);"><img id=imageCalendar1 src="/hb-bass-navigation/hbapp/resources/images/menu/message.gif"  align=absMiddle border=0></a> 
      </td>
   <!--   <td width="13%" align="center" class="dim_cell_title"><input class="form_button"  type="button" name="querybtn" id="button" value="查询"  onclick="toQuery()"/></td> -->
    </tr>
  </table>
  <br/>
  <table  width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
    <tr heignt="30">
      <td align="right"> 
       	 <input class="form_button" name="confirmbtn" type="button" value="下载"  onclick="saveExcel()"/>&nbsp;
         <!--<input class="form_button" name="confirmbtn" type="button" value="全量更新"  onclick="toupdate()"/>//-->
         <input class="form_button" name="resetbtn" type="reset" value="取消"/>&nbsp;&nbsp;
      </td>
    </tr>
  </table>
 <table id="resultTable"  width="99%" align="center"  class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">  
  <thead id='resultHead'>
    <tr class="grid_title_blue">
      <td class="grid_title_cell"  align="center" width="18%">名称</td>
      <td class="grid_title_cell"  align="center" width="9%">数据日期</td>
      <td class="grid_title_cell"  align="center" width="9%">预设值</td>      
      <td class="grid_title_cell"  align="center" width="9%">简算值</td>
      <td class="grid_title_cell"  align="center" width="9%">真实值</td>
      <td class="grid_title_cell"  align="center" width="5%">修正值</td> 
      <td class="grid_title_cell"  align="center" width="9%">预上传值</td>
      <td class="grid_title_cell"  align="center" width="10%">最终上传值</td>
      <td class="grid_title_cell"  align="center" width="11%">当月累计值</td>
       <td class="grid_title_cell"  align="center" width="10%">操作</td>
      <td class="grid_title_cell"  align="center" style="display:none">指标代码</td>
      <td class="grid_title_cell"  align="center" style="display:none">品牌代码</td>
    </tr>
    </thead>
    <tbody id="resultTbody">
    <%    int i=1;
        	while(sqlca.next())
        	{
    %>
    <tr class="grid_row_blue"> 
      <td class="grid_row_cell_number" align="left"><%=sqlca.getString("KPINAME")%></td>
      <td class="grid_row_cell_number" align="right"><%=querydate%></td>
      <% if(sqlca.getString("flag").equals("1"))
         {
            if(i%4!=0)
            {
      %>
      <td align="right"><input class="input_text" onblur="changeValue(this.id)" name="charge_<%=i%>"    type="text" id="charge_<%=i%>"    value="<%=sqlca.getString("CHARGE")%>"     maxlength="13" size="13"  onkeyup="clearNoNum(this)"/></td>      
      <%  }
           else
           {
       %>
      <td align="right"><input class="input_text_h" onblur="changeValue(this.id)" name="charge_<%=i%>"    type="text" id="charge_<%=i%>"    value="<%=sqlca.getString("CHARGE")%>"     maxlength="13" size="13" readonly /></td>      

       <%    
           }	
         } else  { 
      %>
       <td align="right"><%=sqlca.getString("CHARGE")%></td>       
      <% 
        }
      %>
       <td align="right"><input class="input_text_h" name="simple_charge_<%=i%>"    type="text" id="simple_charge_<%=i%>"    value="<%=sqlca.getString("SIMPLE_CHARGE")%>"     maxlength="13" size="13" readonly /></td>
       <td align="right"><input class="input_text_h" name="real_charge_<%=i%>"    type="text" id="real_charge_<%=i%>"    value="<%=sqlca.getString("real_charge")%>"     maxlength="13" size="13" readonly /></td>
       <% if(sqlca.getString("flag").equals("1"))
         {
            if(i%4!=0)
            {
      %>   
      <td align="right"><input class="input_text" onblur="changeValue(this.id)" name="acccharge_<%=i%>" type="text" id="acccharge_<%=i%>" value="<%=sqlca.getString("ACT_CHARGE")%>" maxlength="13" size="13"  onkeyup="clearNoNum(this)" /></td>

      <%  }
          else
          {
       %>      
      <td align="right"><input class="input_text_h" onblur="changeValue(this.id)" name="acccharge_<%=i%>" type="text" id="acccharge_<%=i%>" value="<%=sqlca.getString("ACT_CHARGE")%>" maxlength="13" size="13" readonly /></td>

       <%    
          }
         }
         else  
         { 
      %>       
       <td align="right"><%=sqlca.getString("ACT_CHARGE")%></td>
      <% 
        }
      %>
       <td align="right"><input class="input_text_h" name="pre_charge_<%=i%>"    type="text" id="pre_charge_<%=i%>"    value="<%=sqlca.getString("pre_charge")%>"     maxlength="13" size="13" readonly /></td>
       <td align="right"><input class="input_text_h" name="final_charge_<%=i%>"    type="text" id="final_charge_<%=i%>"    value="<%=sqlca.getString("final_charge")%>"     maxlength="13" size="13" readonly /></td>
       <td align="right"><input class="input_text_h" name="mon_charge_<%=i%>"    type="text" id="mon_charge_<%=i%>"    value="<%=sqlca.getString("mon_charge")%>"     maxlength="13" size="13" readonly /></td>
       <td style="display:none" align="right"><input class="input_text_h"  name="kpicode_<%=i%>"    type="text" id="kpicode_<%=i%>"    value="<%=sqlca.getString("kpicode")%>"     maxlength="13" size="13" readonly /></td>
       <td style="display:none" align="right"><input class="input_text_h"  name="brandcode_<%=i%>"    type="text" id="brandcode_<%=i%>"    value="<%=sqlca.getString("brandcode")%>"     maxlength="13" size="13" readonly /></td>       
       <td>
  			<%
         if(i%4 != 0)
  				{
   			%>
        	<input class="form_button" name="confirmbtn" type="button" value="更新"  onclick="updateRow('<%=i%>','<%=querydate%>','<%=sqlca.getString("kpicode")%>','<%=sqlca.getString("brandcode")%>')"/>
        <%
					} 
         %>
  		</td>
      </tr>
     <%
        i++;
       }
       if(i!=41)
       out.println("<script language='javascript'>alert('数据输出行数不等于40,请核查！');</script>");
     %>
    </tbody>
  </table>
   <input type="hidden" name="sql" value="<%=sql1%>">
	<textarea name="downcontent"  cols="122" rows="12" style="display:none"></textarea>
</form>
<div id="loadmask" style="display:none">
	<div id="loadingmask" style="width:100%;height:200%;background:#c3daf9;position:absolute;z-index:20000;left:0;top:0;">&#160;</div>
	<div id="loading">
			<div class="loading-indicator">
				<img src="/hbbass/common2/image/grid-loading.gif" style="width:16px;height:16px;" align="absmiddle">
				&#160;加载中请稍候.....
			</div>
	</div>
</div>
</body>
<%
     }catch(Exception excep){
				excep.printStackTrace();
			}finally{
				if(null != sqlca)
				{
					sqlca.closeAll();
				}
			}
%>
</html>
