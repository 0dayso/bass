<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  	����ϸҳ��ͨ��MBUSER_ID����
  090831:����jsȫ�ֱ���queryTime,������������queryTime����
  ���Ľ���Ȧ������ʾ�ķ�ʽ��,��������֤���ܡ�
  090901:���������⡣�ڸ�Դ������������60000��ʹ������һ��ҳ����������������֮ǰδ�����ġ�
  ͨ������hbcommon.js�ķ�����������⡣
  ֮�����ԭ���ģ�ֻ��Ӳ���order by���������м���,ԭ������
  --%>
    <title>��У��������-�ƶ���У�û���Ϣ</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="default.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
  </head>
  <script type="text/javascript">
 	queryTime = "";//�վɶ���һ��ȫ�ֱ���
 	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_text";
	cellfunc[0] = function (datas,options) {
		var parts = datas[options.seq].split("@parts@");
		return parts[0];
	}
	
	cellfunc[4] = function(datas,options) {
		var parts = datas[0].split("@parts@");
		//������ʹ����bigint��charת���������rtrim������������ˡ�alert(parts);
		return "<a href='#' title='����鿴��ϸ' onclick='add(\"" + "�������ֽ���Ȧ" + datas[0] + "\",\"" + "�������ֽ���Ȧ" + "-" + parts[0] +"\",\"usergroup.jsp?queryTime=" + queryTime + "&mbuser_id=" + parts[1] + "\")'>" + datas[options.seq] + "</a>";
	}
	function doSubmit2() {
		queryTime = document.forms[0].date.value;
		//alert("queryTime : " + queryTime);
		var condition = " where 1= 1 ";
		var rgroup_num = document.forms[0].counts.value;//�Ѿ���֤���ˣ����������ֵ���ԺϷ�
		condition += " and rgroup_num >= " + rgroup_num;
		//alert(rgroup_num + "///������ע��");
		//alert(document.forms[0].city.value);
		if(document.forms[0].city.value !="0")	condition += " and a.area_id='" + document.forms[0].city.value + "'";
		if(document.forms[0].college_name_given.value != "֧��ģ����ѯ") condition += " and info.college_name like'%" + document.forms[0].college_name_given.value + "%'";
		if(document.forms[0].brand.value != "all") {
			if("qqt" == document.forms[0].brand.value)
				condition += " and brand_id in (1,2,3)";
			else if("mzone" == document.forms[0].brand.value)
				condition += " and brand_id=8";
			else
				condition += " and brand_id in (4,5,6,7)";
		}
		condition += " and a.college_id=info.college_id ";
		//alert(condition);
		//condition += " and dim_brand.db_tid=a.brand_id ";
		//alert(condition);
		//ȡ���û�����
		//--dim_brand.prod_tname--
		var sql = "select rtrim(char(bigint(a.acc_nbr))) || '@parts@' || rtrim(char(bigint(a.mbuser_id))),info.college_name ,case when STATE_TID = 'US364' then 'Ƿ��ͣ��' when STATE_TID='US10' then '����' else 'δ֪' end,case when brand_id in (1,2,3) then 'ȫ��ͨ' when brand_id = 8 then '���еش�' else 'ʡ���û�' end,case when rgroup_num is null then 0 else rgroup_num end from nmk.College_Mbuser_" + queryTime + " a, nwh.college_info info " +  condition;
		var countSql = "select count(*) from nmk.College_Mbuser_" + queryTime + " a, nwh.college_info info "  + condition;
		document.forms[0].sql.value = sql + " with ur";//���sql��ȫ��ġ��������п��ܻ������
		ajaxSubmitWrapper(sql+ " fetch first 1000 rows only with ur",countSql);
	}

function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();

	//������������
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}
	
  </script>
  <script type="text/javascript" defer="defer">
	function checkBlur() {
		var oInput = document.getElementById("college_name_given");
		if(oInput.value == "") {
			oInput.value="֧��ģ����ѯ";
			oInput.style.color = "gray";
			oInput.style.fontStyle = "italic";
		}
	}
	function checkFocus() {
		//alert("checkfocus");
		var oInput = document.getElementById("college_name_given");
		oInput.value="";//����ı�
		oInput.style.color = "black";
		oInput.style.fontStyle = "normal";
		
	}
	function checkBlurNum() {
		var oNumValue = document.forms[0].counts.value;
		//alert("blured");
		var patten=/^[0-9]{1,2}$/;//���ҽ���1-2��������ɡ�
		 if(oNumValue.match(patten) == null) {
		 	alert('����Ȧ��������ȷ����������д��');
		 	document.forms[0].counts.value=5;//�ָ�Ĭ��ֵ
		 	document.forms[0].counts.focus();
		 }
	}
  </script>
  <body>
  <form action="" method="post">
	  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="a.acc_nbr">
		<input type="hidden" name="title" value="">
	</div>
	
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="�������">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;��ѯ��������
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
					<td class="dim_cell_title">ͳ���·�
					</td>
						<td class="dim_cell_content">
							<%=QueryTools2.getDateYMHtml("date",12)%>
						</td>
							
						
						<td class="dim_cell_title">����</td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%>
						</td>
						<td class="dim_cell_title">��У����</td>
						<td class="dim_cell_content"><input type="text" name="college_name_given" id=""college_name_given"" value="֧��ģ����ѯ" style="color:gray; font-style: italic;" onblur="checkBlur()" onfocus="checkFocus()"></td>
					</tr>
					
						<tr class="dim_row">
					<td class="dim_cell_title">Ʒ��
					</td>
						<td class="dim_cell_content">
							<select id="brand" name="brand">
								<option selected="selected" value="all">ȫ��</option>
								<option value="mzone">���еش�</option>
								<option value="snpp">ʡ��Ʒ��</option>
								<option value="qqt">ȫ��ͨ</option>
							</select>
						</td>
						<td class="dim_cell_title">����Ȧ����>=</td>
						<td class="dim_cell_content" colspan="3">
							<%-- 
							<select id="counts" name="counts">
								<option selected="selected" value="4">4</option>
								<option value="5">5</option>
								<option value="3">3</option>
								<option value="2">2</option>
								<option value="1">1</option>
							</select>
							--%>
							<input type="text" name="counts" id="counts" value="5" title="��д����Ȧ����" onblur="checkBlurNum()"/>
						</td>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="��ѯ" onclick="doSubmit2()">&nbsp;
							<input type="button" class="form_button" value="����" onclick="toDown()"/>&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
	
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="�������">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;����չ������
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
				<%-- �˴��п�����ʾ�п������أ���ȫȡ����fecth first n rows ��n��ֵ --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 <%-- ��ͷ�仯���� --%>
				  	<td width="" class="grid_title_cell">�ƶ�����</td>
				  	<%-- 
				  	��ʱȡ���û����� <td width="" class="grid_title_cell">�û�����</td>
				  	--%>
				 	<td width="" class="grid_title_cell">��У����</td>
				 	<td width="" class="grid_title_cell">�û�״̬</td>
				 	<td width="" class="grid_title_cell">Ʒ��</td>
				 	<td width="" class="grid_title_cell">��������Ȧ����</td>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
