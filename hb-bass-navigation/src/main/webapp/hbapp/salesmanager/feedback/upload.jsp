<%@ page contentType="text/html; charset=gb2312"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>���ݵ���ҳ��</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
	<style>
	.feedback {
		position:absolute;
		left:20%;top:20%;
		width:600px;
		padding: 1 px 3 px 10 px 10 px;
		z-index:100;background-color: #EFF5FB;
		border:1px solid #c3daf9;
	}
	.form_button_short{
		BORDER-RIGHT: #7b9ebd 1px solid; 
		BORDER-TOP: #7b9ebd 1px solid; 
		BORDER-LEFT: #7b9ebd 1px solid;
		BORDER-BOTTOM: #7b9ebd 1px solid;
		PADDING: 2px ,2px; 
		FONT-SIZE: 12px; 
		FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#EFF5FB); 
		CURSOR: hand; 
		COLOR: black;
	 	width:40px;
	 	height:20px;
	}
	</style>
	<SCRIPT language=javascript>
	function check()
	{
		if(document.forms[0].querytime.value=="")
		{
			alert("��ѡ���������·�");
			return false;
		}
		if(document.forms[0].fileName.value=="")
		{
			alert("��ѡ���ϴ��ļ�");
			return false;
		}
	}
	</script>
  </head>
  
  <body>
    <br>    
    <div style="margin: 20 px;text-align: center;font-size: 22px;font-weight: bold;font-family: ����">�Ļ������������ݵ���</div>

  	<table align="center" width="83%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
	  <tr class="grid_title_blue" height="26">	  	
	    <td width="18%" class="grid_title_cell">��������</td>
	    <td width="62%" class="grid_title_cell">����</td>
	  </tr>
	 <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell_text"><a href='#' onclick='{document.getElementById("feedback_div").style.display="";}'>�Ļ������������ݵ���</a></td>
	    <td class="grid_row_cell_text">&nbsp;��������Ļ������������ݣ����ϸ��յ���ҳ���е�excelģ����д���ݡ�</td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell_text"><a href='/hbbass/common/FileDown.jsp?filename=iemisaleexample.xls'>���ݵ���ģ������</a></td>
	    <td class="grid_row_cell_text">&nbsp;�Ļ��������۵�������ģ�塣</td>
	  </tr>	  
	</table>
  </body>
  <div id="feedback_div" style="display:none;">
	<div style="width:100%;height:200%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>
	<div class="feedback">
		<div style="text-align: right"><img src='/hbbass/js/ext202/resources/images/default/qtip/close.gif' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display='none';}"></img></div>
		<form action="importAction.jsp" method="post" enctype="multipart/form-data" onsubmit="return check();">
		<table width="99%">
			<tr>
				<td align="left" width="150px">ѡ���������·ݣ�</td>
	 			<td colspan="2" height="30px">
	 				<input type="text" size="12" name="querytime" readonly/>
					<IMG src="/hbbass/images/icon_date.gif" align="absMiddle" style="cursor:hand" width="27" height="25" border="0" onclick="javascript: var t=document.all.item('querytime').value; var x=window.showModalDialog('/hbbass/channel/surrogateanalysis/monthCalendar.htm',null,'dialogLeft:'+window.event.screenX+'px;dialogTop:'+window.event.screenY+'px;dialogWidth:250px;dialogHeight:140px;resizable:no;status:no;scroll:no');if (x != null && x.length >0) document.all.item('querytime').value = x; if(x!=t&&x!=null) monthChanged();" width="20" align="absbottom">
					<font color="red">*(������д)</font>
				</td>
	 		</tr>
			<tr>
	 		<td style="font-size:13;" width="150px">�ϴ��ļ�(excel�ļ�)��</td>
	 		<td height="30 px"><input type="file" name="fileName" size="30"></td>
	 		<td align="right"><input type="submit" class="form_button" value="�ύ"></td>
	 		</tr>
	 		<tr>
	 			<td colspan="3" height="30px"></td>
	 		</tr>
	 	</table>
	 	</form>
	</div>
	</div>
</html>
