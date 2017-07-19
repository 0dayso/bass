<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>终端营销资源导入</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
		<link rel="stylesheet" type="text/css" href="css/manage.css" />
	</head>
	<body>
<table class="tablelist">
   <thead>
	 <tr>
		<th style="width:245px">资费ID</th>
		<th style="width:65px">资费类型</th>
		<th style="width:65px">资费状态</th>
		<th>资费名称</th>
		<th >操作</th>
	</tr>
  </thead>
  <tbody>
  </tbody>
</table>
<div class="rightinfo">
     <div class="tools">
    	<ul class="toolbar">
		<!--<li onclick="manage.load()"><span><img src="images/timg.jpg" style="width:25px;height:25px" /></span>刷新</li>-->
        <li class="click" onclick="manage.showWindow(2)"><span><img src="images/t01.png" /></span>添加</li>
        </ul>
     </div>
     <div class="tip"></div>
 </div>
	</body>
</html>
<script type="text/javascript">
Ext.onReady(function() {
manage={
	createRow:function(FEE_ID,FEE_TYPE,FEE_STATS,FEE_NAME,rowNum){
		if(FEE_TYPE==0||FEE_TYPE=='0'){
				FEE_TYPE="套餐";
		}
		if(FEE_TYPE==1||FEE_TYPE=='1'){
				FEE_TYPE="流量";
		}
		if(FEE_STATS==0||FEE_STATS=='0'){
				FEE_STATS="有效";
		}
		if(FEE_STATS==1||FEE_STATS=='1'){
				FEE_STATS="无效";
		}
		return "<tr><td>"+FEE_ID+"</td><td>"+FEE_TYPE+"</td><td>"+FEE_STATS+"</td><td>"+FEE_NAME+"</td><td><a href='#' class='tablelink' onclick='manage.showWindow(3,this)'>修改</a>&nbsp;&nbsp;<a href='#' class='tablelink' onclick='manage.deleteRow(this)'> 删除</a></td></tr>";
	},
	init:function(){
		 $(".click").click(function(){
			$(".tip").fadeIn(200);
		 });
		 $(".tiptop a").click(function(){
		    $(".tip").fadeOut(200);
         });
		$(".sure").click(function(){
		    $(".tip").fadeOut(100);
		});
	    $(".cancel").click(function(){
		    $(".tip").fadeOut(100);
		});
	},
	load:function(){
		readData("select * from IMEI_ACT_FEE_CFG order by CREATE_TIME asc");
	},
	deleteRow:function(touch_obj){
		var click_fee_id=touch_obj.parentElement.parentElement.cells[0].innerHTML;
		this.showWindow(1,click_fee_id);
	},
	insertFee:function(FEE_ID,FEE_TYPE,FEE_STATS,FEE_NAME){
		var _this=this;
		sendRequest("insert into  IMEI_ACT_FEE_CFG(FEE_ID,FEE_TYPE,FEE_STATS,FEE_NAME,CREATE_TIME) values('"+FEE_ID+"','"+FEE_TYPE+"','"+FEE_STATS+"','"+FEE_NAME+"',current timestamp)",2);

	},
	showWindow:function(type,params){
		var infoWin=$(".tip")
		var	_this=this;
		if(type==1){
			infoWin.html("");
			infoWin.append("<div class='tiptop'><img src='images/t03.png' /><span>确定要删除该营销资源配置?</span><a></a></div><div class='tipinfo'><input name='' type='button'  class='sure' value='确定' />&nbsp;<input name='' type='button'  class='cancel' value='取消' /></div>");
			infoWin.css({width:"456px",height:"120px"});
			infoWin.fadeIn(200);
			_this.init();
			var _this=this;
			$(".sure").click(function(){
						 sendRequest("delete from IMEI_ACT_FEE_CFG where FEE_ID='"+params+"'",2);
				
			});
		}else if(type==2){
			infoWin.html("");
			infoWin.append("<div class='tiptop'><img src='images/t01.png' /><span>营销资源的新增</span><a></a></div><div class='tipinfo'><span><img src='images/ticon.png' /></span><div class='tipright'><div style='margin-left:1px'><label>资费&nbsp;&nbsp;&nbsp;ID:</label><input type='text' /></div><div><label>资费类型:</label><select id='select_type'><option value=0>套餐</option><option value=1>流量</option></select></div><div><label>资费状态:</label><select id='select_stats'><option value=0>有效</option><option value=1>无效</option></select></div><div><label>资费名称:</label><textArea type='text' /></textArea></div></div></div><div class='tipbtn'><input name='' type='button'  class='sure' value='确定' />&nbsp;<input name='' type='button'  class='cancel' value='取消' /></div>");
			infoWin.css({width:"455px",height:"360px"});
			infoWin.fadeIn(200);
			_this.init();
			$(".sure").click(function(){
				    //check
					var inputs=$("input");
					var FEE_ID=inputs[0].value;
					var FEE_TYPE=document.getElementById("select_type").value;
					var FEE_STATS=document.getElementById("select_stats").value;
					var FEE_NAME=$("textArea").val();
					var reg = new RegExp('^<([^>\s]+)[^>]*>(.*?<\/\\1>)?$');
					if(FEE_ID!=null&&FEE_ID.length>32){
							alert("输入的资费ID长度不能超过32位");
							return;
					}
					if(FEE_TYPE!=null&&FEE_TYPE.length>2){
							alert("输入的资费类型长度不能超过2位");
							return;
					}
					if(FEE_STATS!=null&&FEE_STATS.length>2){
							alert("输入的资费状态长度不能超过2位");
							return;
					}
				  if(FEE_NAME!=null&&FEE_NAME.length>256){
							alert("输入的资费名称长度不能超过256位");
							return;
					}
					if(FEE_ID==null||FEE_ID=='underfined'||FEE_ID==''){
							alert("请填写资费ID");
							return;
					}
					if(reg.test(FEE_NAME)){
							alert("输入的资费名称含有特殊字符,请重新输入");
							return;
					}
					
					

					_this.insertFee(FEE_ID,FEE_TYPE,FEE_STATS,FEE_NAME);
				
					
			});
		  }else if(type==3){
			var click_fee_id=params.parentElement.parentElement.cells[0].innerHTML;
			infoWin.html("");
			infoWin.append("<div class='tiptop'><img src='images/t02.png' /><span>"+click_fee_id+"营销资源的修改</span><a></a></div><div class='tipinfo'><span><img src='images/t02.png' /></span><div class='tipright'><div style='margin-left:1px'><label>资费&nbsp;&nbsp;&nbsp;ID:</label><input type='text' disabled='disabled' /></div><div><label>资费类型:</label><select id='select_type'><option value=0>套餐</option><option value=1>流量</option></select></div><div><label>资费状态:</label><select id='select_stats'><option value=0>有效</option><option value=1>无效</option></select></div><div><label>资费名称:</label><textArea type='text' /></textArea></div></div></div><div class='tipbtn'><input name='' type='button'  class='sure' value='更新' />&nbsp;<input name='' type='button'  class='cancel' value='取消' /></div>");
			infoWin.css({width:"455px",height:"360px"});
			infoWin.fadeIn(200);
		    _this.init();
		   var FEE_TYPE=params.parentElement.parentElement.cells[1].innerHTML;
       var FEE_STATS=params.parentElement.parentElement.cells[2].innerHTML;
		   var select_stats=document.getElementById("select_stats");
		   var select_type=document.getElementById("select_type");
		  	if(FEE_TYPE=='套餐'){
				FEE_TYPE=0;
				select_type[0].selected='true';
			}
			if(FEE_TYPE=='流量'){
				FEE_TYPE=1;
				//select_type[1].selected=true;
				$("select_type option").eq(1).selected=true;
			}
			if(FEE_STATS=='有效'){
				 FEE_STATS=0;
				select_type[0].selected='true';
			}
			if(FEE_STATS=='无效'){
					FEE_STATS=1;
				select_type[1].selected='true';
			}
		   var FEE_NAME=params.parentElement.parentElement.cells[3].innerHTML;
		   var inputs=$("input");
		   inputs[0].value=click_fee_id;
		   var _this=this;
		   $("textArea").html(FEE_NAME);
		   	$(".sure").click(function(){
				    FEE_TYPE=document.getElementById("select_type").value;
					  FEE_STATS=document.getElementById("select_stats").value;
						 sendRequest("update IMEI_ACT_FEE_CFG set CREATE_TIME=current timestamp,FEE_TYPE='"+FEE_TYPE+"',FEE_STATS='"+FEE_STATS+"',FEE_NAME='"+$("textArea").val()+"'  where FEE_ID='"+click_fee_id+"'",2);
					
			});
		}
	 }

}

//loadinit
readData("select * from IMEI_ACT_FEE_CFG order by CREATE_TIME asc");
function sendRequest(sql,type) {  
Ext.Ajax.request({
	url : '${mvcPath}/jsonData/query',
	success:function(obj) {
			if(obj.responseText=="-1"&&obj.status==200){
					alert("插入重复资费!");
				return;
			}
			if(obj.responseText==""&&obj.status==200){
					readData("select * from IMEI_ACT_FEE_CFG order by CREATE_TIME asc");
			}
	},
	failure : function(obj) {
						    alert("操作失败");
				},
	params : {'sql': strEncode(sql),'ds'  : 'WEBDB','start' : 0,'limit' : 99}
	});		
}

function readData(sql) {  	
	Ext.Ajax.request({
	url : '${mvcPath}/jsonData/query',
	success:function(obj) {
			eval("var fees="+obj.responseText+";");
			$(".tablelist tbody").html("");
					for(var i=0;i<fees.root.length;i++){
					var row=manage.createRow(fees.root[i].fee_id,fees.root[i].fee_type,fees.root[i].fee_stats,fees.root[i].fee_name,i);
							$(".tablelist tbody").append(row);
					}
					 manage.init();
	},
	failure : function(obj) {
						    alert("获取数据失败!");
				},
	params : {'sql': strEncode(sql),'ds'  : 'WEBDB','start' : 0,'limit' : 99}
	});		
}




});
</script>
