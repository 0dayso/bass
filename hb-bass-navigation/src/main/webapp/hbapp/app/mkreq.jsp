<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<html>
	<head>
		<title>湖北移动经营分析系统-发起流程</title>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Cache-Control" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	</head>
	<body>
	<div class="divinnerfieldset">
	<fieldset>
	<legend><table><tr>
		<td  title="联动分析">联动分析</td>
	</tr></table></legend>
	<div id="dim_div">
	<table>
	<tr >
				<td >
					<a style="text-decoration: underline;" href="javascript:redirect('reqAdd')"><font color="blue"><b>联动分析</b></font></a>
					说明：主要对情报室发起分析的流程及反馈流程在运营监控及管理平台上进行统一电子化报送审批管理，对过程文档结果文档进行存档，通过短、彩信进行提醒，省市场部及地市市场部门均可对按照流程向情报室发起分析，根据分析管理流程进行审批，情报室完成相关分析后反馈给相关人员
				</td>
			</tr>
	</table>
	</div>
	</fieldset>
	<fieldset>
	<legend><table><tr>
		<td  title="情报收集">情报收集</td>
	</tr></table></legend>
	<div id="dim_div2">
	<table>
			<tr >
				<td>
					<a style="text-decoration: underline;"
						href="javascript:redirect('data')"><font color="blue">数据情报</b>
					</font>
					</a> 说明：数据情报用于收集竞争对手的关键指标信息
				</td>
			</tr>
			<tr >
				<td>
					<a style="text-decoration: underline;"
						href="javascript:redirect('fee')"><font color="blue">资费信息</b>
					</font>
					</a> 说明：资费信息指竞争对手的产品和资费信息，如产品价格体系、资费单价等，需要包含运营商、地域、资费营销案名称、资费明细等信息
				</td>
			</tr>
			<tr >
				<td>
					<a style="text-decoration: underline;"
						href="javascript:redirect('active')"><font color="blue">营销活动</b>
					</font>
					</a> 说明：营销活动指竞争对手开展的营销活动和促销活动等信息
				</td>
			</tr>
			<tr >
				<td>
					<a style="text-decoration: underline;"
						href="javascript:redirect('policy')"><font color="blue">渠道政策</b>
					</font>
					</a> 说明：渠道政策指竞争对手的入网政策、渠道酬金政策等信息
				</td>
			</tr>
			<tr >
				<td>
					<a style="text-decoration: underline;"
						href="javascript:redirect('others')"><font color="blue">其他</b>
					</font>
					</a> 说明：其他情报用于收集除数据情报、资费信息、营销活动、渠道政策之外的其他竞争情报
				</td>
			</tr>
		</table>
	</div>
	</fieldset>
	</div>
	<script type="text/javascript">
	<%User user = (User)session.getAttribute("user");%>
		function redirect(type){
			if(type=='reqAdd')
				tabAdd({title:'联动分析',url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=ReqAdd_mkreq"});
			if(type=='data')
				tabAdd({title:'数据情报',url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=DATA_INFO_mkreq"});
			if(type=='fee')
				tabAdd({title:'资费信息',url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=CHARGES_INFO_mkreq"});
			if(type=='active')
				tabAdd({title:'营销活动',url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=Mk_ACT_mkreq"});
			if(type=='policy')
				tabAdd({title:'渠道政策',url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=CHANNEL_PC_mkreq"});
			if(type=='others')
				tabAdd({title:'其他',url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=OTHERS_mkreq"});
		}
	</script>
	</body>
</html>