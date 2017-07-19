<#assign c=JspTaglibs["http://java.sun.com/jsp/jstl/core"]>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>湖北经分</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
		<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset="utf-8"></script>
<script type="text/javascript">
(function($,window){
$(document).ready(function(){
	render();
});
var grid = null;
function render(){
	var sql = "select label,name,dbname,opertype,value(defval,'') defval,datasource,seq from fpf_irs_subject_dim where sid=${sid} order by seq";
	grid = new aihb.SimpleGrid({
		header:[
			{"name":"维度名称","dataIndex":"label","cellStyle":"grid_row_cell_text"}
			,{"name":"维度ID","dataIndex":"name","cellStyle":"grid_row_cell_text"}
			,{"name":"数据库字段","dataIndex":"dbname","cellStyle":"grid_row_cell_text"}
			,{"name":"数据库类型","dataIndex":"opertype","cellStyle":"grid_row_cell_text"}
			,{"name":"数据源","dataIndex":"datasource","cellStyle":"grid_row_cell_text"}
			,{"name":"排序","dataIndex":"seq"}
			,{"name":"操作","dataIndex":"defval","cellStyle":"grid_row_cell","cellFunc":"oper"}
		]
		,sql: sql
		,ds:"web"
		,isCached : false
	});
	grid.run();
}


function oper(val,options){
	var _obj=$C("div");
	var _aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("编辑"));
	_aEdit.record=options.record
	_aEdit.onclick=function(){
		add(this.record);
	};
	_obj.appendChild(_aEdit);
	_obj.appendChild($CT(" "));
	
	_aEdit=$C("a");
	_aEdit.href="javascript:void(0)";
	_aEdit.appendChild($CT("删除"));
	_aEdit.record=options.record
	_aEdit.onclick=function(){
		$.ajax({
			type: "post"
			,url: "${mvcPath}/report/${sid}/dim"
			,data: "_method=delete&name="+encodeURIComponent(this.record.name)
			,dataType : "json"
			,success: function(data){
     			alert( data.status );
     			if(data.status == "操作成功"){
     				location.reload();
	     		}
   			}
		});
	};
	_obj.appendChild(_aEdit);
	return _obj;
}
window.oper=oper;
var _cont = $C("div");

var _mask = aihb.Util.windowMask({content:_cont});

function initComp(defVal){
	if($("#ipt_name_select option").length==0){
		$.ajax({
   			type: "get"
			,url: "${mvcPath}/report/dim"
			,dataType : "json"
			,sync : true
			,success: function(data){
     			var _sel=document.getElementById("ipt_name_select");
     			var flag = true;
				for(var k=0;k<data.length;k++){
					_sel[k+1]=new Option(data[k].name,data[k].tagname);
					if(defVal&&defVal==_sel[k+1].value){
						_sel[k+1].selected=true;
						flag = false;
					}
				}
				_sel[0]=new Option("请选择","");
				if(flag) _sel[0].selected=true;
				_sel.style.display = "";
   			}
		});
	}else{
		$("#ipt_name_select").show();
		if(defVal && defVal.length>0){
			//var _sel=$("#ipt_name_select");
			var _sel = document.getElementById("ipt_name_select");
			for(var k=0;k<_sel.length;k++){
				if(defVal==_sel[k].value){
					_sel[k].selected=true;
					break;
				}
			}
		}
	}
}

function add(options){
	if(_cont.innerHTML.length==0){
		
		var _iPut={};
		
		_iPut=$C("select");
		_iPut.id="datasourceType";
		_cont.appendChild($CT("数据源类型："));
		_cont.appendChild(_iPut);
		
		_iPut.onchange=function(){
			$("#ipt_name_select").hide();
			switch (this.value) { 
					case "date": 
						$("#ipt_label").val("统计周期");
						$("#ipt_name").val("time");
						$("#ipt_datasource").val("comp:date");
						break; 
					case "month": 
						$("#ipt_label").val("统计周期");
						$("#ipt_name").val("time");
						$("#ipt_datasource").val("comp:month");
						break; 
					case "city": 
						$("#ipt_label").val("地市");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
						break; 
					case "county": 
						$("#ipt_label").val("县市");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "channel": 
						$("#ipt_label").val("渠道网点");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
						$("#ipt_opertype").val("like");
					break; 
					case "county_bureau": 
						$("#ipt_label").val("县市");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break;
					case "marketing_center": 
						$("#ipt_label").val("营销中心");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "town": 
						$("#ipt_label").val("乡镇");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "cell": 
						$("#ipt_label").val("基站");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "college": 
						$("#ipt_label").val("高校");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "entCounty": 
						$("#ipt_label").val("县市");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "custmgr": 
						$("#ipt_label").val("客户经理");
						$("#ipt_name").val(this.value);
						$("#ipt_datasource").val("comp:"+this.value);
					break; 
					case "select": 
						$("#ipt_label").val("");
						$("#ipt_name").val("");
						$("#ipt_datasource").val(this.value+":");
					break; 
					case "input": 
						$("#ipt_label").val("");
						$("#ipt_name").val("");
						$("#ipt_datasource").val(this.value+":");
						break; 
					case "comp":
						initComp();
						break;
				} 
		}
		var opts=[new Option("自定义输入框","input")
			,new Option("维表选择框","comp")
			,new Option("时间(日)","date")
			,new Option("时间(月)","month")
			,new Option("地市","city")
			,new Option("县市","county")
			,new Option("渠道网点","channel")
			,new Option("高校","college")
			,new Option("县市集团","entCounty")
			,new Option("客户经理","custmgr")
			,new Option("县市区域化","county_bureau")
			,new Option("营销中心","marketing_center")
			,new Option("乡镇","town")
			,new Option("基站","cell")
			,new Option("自定义选择框","select")
		];
		
		for(var i=0;i<opts.length;i++){
			_iPut[i]=opts[i];
		}
		
		_cont.appendChild($CT(" "));
		//维度选择框
		_iPut=$C("select");
		_iPut.id="ipt_name_select";
		_iPut.style.display="none";
		_iPut.onchange=function(){
			$("#ipt_label").val(this.options[this.selectedIndex].text);
			$("#ipt_name").val(this.value);
			$("#ipt_datasource").val("comp:"+this.value);
		}
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));

		_iPut=$C("input");
		_iPut.id="ipt_label";
		_iPut.type="text";
		_cont.appendChild($CT("维度名称："));
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));
		
		
		_iPut=$C("input");
		_iPut.id="ipt_name";
		_iPut.type="text";
		_cont.appendChild($CT("维度ID："));
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));
		
		_iPut=$C("textarea");
		_iPut.id="ipt_datasource";
		_iPut.cols=50;
		_iPut.rows=3;
		_cont.appendChild($CT("数据源："));
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));
		
		_iPut=$C("textarea");
		_iPut.id="ipt_dbname";
		_iPut.cols=40;
		_iPut.rows=2;
		_cont.appendChild($CT("数据库字段："));
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));
		
		
		_iPut=$C("select");
		_iPut.id="ipt_opertype";
		_cont.appendChild($CT("数据库类型："));
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));
		_iPut[0]=new Option("字符(varchar)","varchar");
		_iPut[1]=new Option("数字(int)","int");
		_iPut[2]=new Option("匹配(like)","like");
		_iPut[3]=new Option("区间(between)","between");
		_iPut[4]=new Option("区间(in)","in");
		_iPut[5]=new Option("范围(range)","range");
		_iPut[6]=new Option("分隔(split)","split");
		
		_iPut=$C("input");
		_iPut.id="ipt_seq";
		_iPut.type="text";
		if(grid!=null && grid.grid.data.length>0){
			_iPut.value=(parseInt(grid.grid.data[grid.grid.data.length-1].seq,10)/10 +1)*10;
		}else{
			_iPut.value="10";
		}
		_cont.appendChild($CT("排序："));
		_cont.appendChild(_iPut);
		_cont.appendChild($C("BR"));
		
		var iBtn=$C("input");
		iBtn.type="button";
		iBtn.className="form_button_short";
		iBtn.value="确定";
		
		iBtn.onclick=function(){
			$.ajax({
				type:"post"
				,url:"${mvcPath}/report/${sid}/dim"
				,data:"_method=put&name="+encodeURIComponent($("#ipt_name").val())+"&label="+encodeURIComponent($("#ipt_label").val())+"&dbname="+$("#ipt_dbname").val()+"&datasource="+encodeURIComponent($("#ipt_datasource").val())+"&seq="+$("#ipt_seq").val()+"&opertype="+$("#ipt_opertype").val()
				,dataType : "json"
				,success: function(data){
	     			alert( data.status );
	     			if(data.status == "操作成功"){
	     				location.reload();
		     		}
	   			}
			});
		}
		_cont.appendChild(iBtn);
	}
	if(options){
		$("#ipt_label").val(options.label||"");
		$("#ipt_name").val(options.name||"");
		$("#ipt_dbname").val(options.dbname||"");
		$("#ipt_opertype").val(options.opertype||"");
		$("#ipt_datasource").val(options.datasource||"");
		$("#ipt_seq").val(options.seq||"");
		var arr=options.datasource.split(":");
		var arr1=arr[1];
		var arr0=arr[0];
		$("#ipt_name_select").hide();
		if(arr0=="select"||arr0=="input"){
			$("#datasourceType").val(arr0);
		}else if(arr1=="city"||arr1=="county"||arr1=="date"||arr1=="month"){
			$("#datasourceType").val(arr1);
		}else if(arr0=="comp"){
			$("#datasourceType").val(arr0);
			initComp(arr1);
		}
	}
	_mask.show();
}
window.add = add;
})(jQuery,window);
</script>
</head>
<body>
<div style="text-align: right;padding: 3px 10px 5px 0px;">
<input type="button" class="form_button_short" value="新增" onClick="add()"></div>
<div id="grid" style="display:none;"></div>
</body>
</html>