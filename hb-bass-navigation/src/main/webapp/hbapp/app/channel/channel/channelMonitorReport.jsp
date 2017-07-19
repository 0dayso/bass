<%@page contentType="text/html; charset=utf-8"%>
<head>
	<title>经分集成BAM电子渠道健康度监控专题</title>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>

<body onload="myhideTitle()">
	<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'iframe1')" title="点击显示">
									<img flag='0' src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif"></img>
									&nbsp;短厅健康度：
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr>
								<td>
									<iframe id="iframe1" frameborder=0 width="99%" height=500 scrolling=no ></iframe>
								</td>
							</tr>
						</table>
					</legend>	
					<div id="grid1" style="display:none;"></div>
				</fieldset>
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'iframe2')" title="点击显示">
									<img flag='0' src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif"></img>
									&nbsp;网厅健康度：
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr>
								<td>
									<iframe id="iframe2" frameborder=0 width="99%" height=500 scrolling=no ></iframe>
								</td>
							</tr>
						</table>
					</legend>	
					<div id="grid2" style="display:none;"></div>
				</fieldset>
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'iframe3')" title="点击显示">
									<img flag='0' src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif"></img>
									&nbsp;自助终端健康度：
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr>
								<td>
									<iframe id="iframe3" frameborder=0 width="99%" height=500 scrolling=no ></iframe>
								</td>
							</tr>
						</table>
					</legend>	
					<div id="grid6" style="display:none;"></div>
				</fieldset>
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'iframe4')" title="点击显示">
									<img flag='0' src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif"></img>
									&nbsp;10086健康度：
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr>
								<td>
									<iframe id="iframe4" frameborder=0 width="99%" height=500 scrolling=no ></iframe>
								</td>
							</tr>
						</table>
					</legend>	
					<div id="grid3" style="display:none;"></div>
				</fieldset>
			</div>
</body>
<script>
function hideTitle(el,objId){
	var obj = document.getElementById(objId);
	if(el.flag ==0)
	{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif";
		el.flag = 1;
		el.title="点击隐藏";
		obj.style.display = "";
		if(objId=="iframe1"){
			obj.src="http://10.25.11.78:8885/smc_web/container/frame.jsp?groupId=11843&_page=view&_menu=N&_username=public&_password=public";
		}
		if(objId=="iframe2"){
			obj.src="http://10.25.11.78:8885/smc_web/container/frame.jsp?groupId=11905&_page=view&_menu=N&_scroll=N&_username=public&_password=public";
		}
		if(objId=="iframe3"){
			obj.src="http://10.25.11.78:8885/smc_web/container/frame.jsp?groupId=11841&_page=view&_menu=N&_username=public&_password=public";
		}
		if(objId=="iframe4"){
			obj.src="http://10.25.11.78:8885/smc_web/container/frame.jsp?groupId=11963&_page=view&_menu=N&_username=public&_password=public";
		}
	}
	else
	{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif";
		el.flag = 0;
		el.title="点击显示";
		obj.style.display = "none";			
	}
}
function myhideTitle(){
	var obj1= document.getElementById("iframe1");
	var obj2= document.getElementById("iframe2");
	var obj3= document.getElementById("iframe3");
	var obj4= document.getElementById("iframe4");
	obj1.style.display="none";
	obj2.style.display="none";
	obj3.style.display="none";
	obj4.style.display="none";
}
</script>