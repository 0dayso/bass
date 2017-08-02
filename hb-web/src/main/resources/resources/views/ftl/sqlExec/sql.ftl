<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>湖北移动经营分析系统</title>
    <script type="text/javascript" src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/lib/jqLoading/js/jquery-ui-jqLoding.js"></script>
	<link rel="stylesheet" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/default/easyui.css" type="text/css"></link>
	<link rel="stylesheet" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css" type="text/css"></link>
</head>
<body>
<div style="margin: 20px 0;"></div>
<table id="dataTable" class="easyui-datagrid" title="操作"
	style="width: auto; height: auto"
	data-options="fitColumns : true,striped:true,toolbar:'#search'">
</table>
<div region="center" border="false" border="false">
				<div id="newTab" class="easyui-tabs" fit="true" style="width:1274px;height:230px">
					<div title="SQL编辑" style="padding:10px;">
	                         <input class="easyui-textbox" name="description"  id="sqlStr" 
	                        style="margin-top: -35px;width:1240px;height:180px;font-family: monospace;font-size: 15px;" data-options="multiline:true,
	                        prompt: 'Please input SQL what you want to query...' " >
				</div>
			</div>
</div>
<div id="search" style="padding: 5px; height: auto">
	<div style="margin-bottom: 5px">
		<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="createTab()">新建SQL窗口</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-reload" onclick="reflashSql()"  plain="true">清空</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-play" onclick="doSql()"  plain="true">执行</a>
	</div>
</div>
<div style="margin:10px 0;"></div>
	<div class="easyui-layout" style="width:1274px;height:370px;">
		<div id ="result" data-options="region:'center'" style="padding: 10px; width: 430px" title="执行结果">
		 <div id="tableResult1" style="display:none;">
		 <div id="search" style="padding: 5px; height: auto">
	    <div style="margin-bottom: 5px">
		    <a href="#" class="easyui-linkbutton" iconCls="icon-redo" plain="true" onclick="exportCsv()">导出为csv文件</a>
	      </div>
         </div>
	   	    <table id="tableResult" ></table>
		 </div>
		 <div id="resultTal1" style="display:none;">
		    <table id="resultTal" style="margin: 10px;">
		        <tr><th style='width: 145px;'><span>执行时间</span></th>
				    <th style='width: 145px;'><span>操作人员</span></th>
				    <th style='width: 145px;'><span>操作类型</span></th>
				    <th style='width: 145px;'><span>状态</span></th>
				    <th style='width: 145px;'><span>备注</span></th></tr>
				   <tbody id='resultBody'>
				   </tbody>
			</table>
		</div>
		</div>
	</div>
</body>
</html>

<script type="text/javascript" >
$(function(){
	//关闭窗口
	$('#newTab').tabs({
		  onBeforeClose: function(title,index){
		   var target = this;
		     $.messager.confirm('确认','你确认想要关闭'+title,function(r){
			if (r){
					var opts = $(target).tabs('options');
					var bc = opts.onBeforeClose;
					opts.onBeforeClose = function(){};  //允许现在关闭
					$(target).tabs('close',index);
					opts.onBeforeClose = bc;  // 还原事件函数
				}
			});
			return false;	// 阻止关闭
		  }
		});
	
	//文本消除
	$.extend($.fn.textbox.methods, {
		addClearBtn: function(jq, iconCls){
			return jq.each(function(){
				var t = $(this);
				var opts = t.textbox('options');
				opts.icons = opts.icons || [];
				opts.icons.unshift({
					iconCls: iconCls,
					handler: function(e){
						$(e.data.target).textbox('clear').textbox('textbox').focus();
						$(this).css('visibility','hidden');
					}
				});
				t.textbox();
				if (!t.textbox('getText')){
					t.textbox('getIcon',0).css('visibility','hidden');
				}
				t.textbox('textbox').bind('keyup', function(){
					var icon = t.textbox('getIcon',0);
					if ($(this).val()){
						icon.css('visibility','visible');
					} else {
						icon.css('visibility','hidden');
					}
				});
			});
		}
	});


});

function createTab(){
		var content = "<input class='easyui-textbox' name='description' id='sqlStr' style='margin-top: -35px;width:1250px;height:180px;' data-options='multiline:true'>";
		$('#newTab').tabs('add',{
			title:'新建SQL窗口',
			content:content,
			prompt:'Please input SQL what you want to query...',
			closable:true
		});
}

function reflashSql(){
	location.reload(); 
}

function strToDate(str) {
	var date = new Date(str);
	var Y = date.getFullYear() + '-';
	var M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
	var D = date.getDate() + ' ';
	var h = date.getHours() + ':';
	var m = date.getMinutes() + ':';
	var s = date.getSeconds();
	var time = Y + M + D + h + m + s;
	return time;
}


function doSql(){
	var pp = $('#newTab').tabs('getSelected');    
	var tab = pp.panel('options').tab;   
	var sqlStr;
	if(tab[0].textContent=="SQL编辑"){
		sqlStr= pp[0].childNodes[1].value;
	}else{
		sqlStr= pp[0].childNodes[0].value;
	}
	$.messager.confirm('操作提示', '确认执行当前语句?', function(o) {
		if(o){
	if(sqlStr.indexOf("select")>-1 ||sqlStr.indexOf("SELECT")>-1){
		doSomething(sqlStr);
	}else{
		   if(sqlStr.indexOf("where")<-1 || sqlStr.indexOf("WHERE")<-1){
				$.messager.confirm('操作提示', '当前操作不含条件,确认执行?', function(ok) {
					if(ok){
						doSomething(sqlStr);
					 }else{
						 return false;
					  }
					 });
	       }else{
	    	   doSomething(sqlStr);
	        }
	      }
		}
	});
}
	

	
function doSomething(sqlStr){
	$("body").jqLoading();
	$.ajax({
		type : "POST",
		url : '/hb-bass-navigation/doSql/excute',
		data : {
			sqlStr:sqlStr
		},
		dataType : 'json',
		success : function(data) {
			var logHtml = "";
			var clms= [];
			var columns =[];
			if(typeof(data.select)!="undefined"){
				if( $("#resultTal1").css("display","block") ){
					$("#resultTal1").css("display","none");
				}
				$("#tableResult1").css("display","block");
				var loglist=data.select.rows;
				 var tatal=loglist[0];
				 for(var prop in tatal){
					 if (tatal.hasOwnProperty(prop)) {   
				        clms.push({field:prop,title:prop,width:150});
					     }
					 }
				 columns.push(clms);
				 $('#tableResult').datagrid({  
					    queryParams: {
					    	sqlStr:sqlStr
						},
					    url:'/hb-bass-navigation/doSql/query',    
					    columns: columns,
					    pagination:true
					});
			}else{
				if( $("#tableResult1").css("display","block") ){
					$("#tableResult1").css("display","none");
				     }
				   $("#resultTal1").css("display","block");
				var loglist=data;
			    loglist.time=strToDate(loglist.time);
			    logHtml+="<tr><td style='width: 145px;'><span>"+loglist.time+"</span></td><td style='width: 145px;'><span>" + loglist.user + "</span></td><td style='width: 145px;'><span>" + loglist.oper + "</span></td>";
				logHtml+="<td style='width: 145px;'><span>" + loglist.status + "</span></td><td style='width: 145px;'><span>" + loglist.remark + "</span></td></tr>"
				$("#resultBody").html(logHtml);
			}
			$("body").jqLoading("destroy");
		},
		error : function(result) {
		}
	});
}

function exportCsv(){
	var pp = $('#newTab').tabs('getSelected');    
	var tab = pp.panel('options').tab;   
	var sqlStr;
	if(tab[0].textContent=="SQL编辑"){
		sqlStr= pp[0].childNodes[1].value;
	}else{
		sqlStr= pp[0].childNodes[0].value;
	}
	$.ajax({
		type : "GET",
		url : '/hb-bass-navigation/doSql/export',
		data : {
			sqlStr:sqlStr
		},
		success : function(result) {
			if(result){
			alert("导出数据成功!");
			}
		},
		error : function(result) {
			alert("导出数据失败!")
			
		}
	});
	
	
}
</script>
