/*********************    配置报表的公共JS   ********************************************/
(function($,window){
/**
 * 处理{colPiece} {groupPiece} {orderPiece}的替换
 */
function genSqlPieces(sql){
	//debugger;
	if(/\{colPiece\}/.exec(sql)!=null||/\{groupPiece\}/.exec(sql)!=null||/\{orderPiece\}/.exec(sql)!=null){
		//时间分组
		var colPiece=($("#aidim_time")||"").attr("dbName") +" time";
		var groupPiece=($("#aidim_time")||"").attr("dbName");
		var orderPiece=" order by 1";
		try{
			if( !$("#aidim_time").isNotNull() || $("#time_during").css("display")=="none" || !$("#timeDetail").attr("checked")){//地域分组
				var cityDbName=$("#aidim_city").attr("dbName");
				
				colPiece="(select value(max(number),99999) from NMK.REP_AREA_REGION where area_code="+cityDbName+") city_order, value((select alias_area_name from (select area_code alias_area_code,area_name alias_area_name from mk.bt_area) alias_t1 where alias_area_code="+cityDbName+"),case when grouping("+cityDbName+")=1 then '总计' else "+cityDbName+" end) city";
				groupPiece="rollup("+cityDbName+")";
				
				var bureauSuffix="";//判断地域们的时间周期
				if($("#time").isNotNull()){
					
					var _date=new Date();
					_date.setDate(_date.getDate()-1);
					var _time=$("#time").val();
					if(_time.length==6){
						bureauSuffix="_"+_time;
					}else if(_time.length==8 && (_date.format("yyyyMM"))!=_time.substring(0,6)){
						bureauSuffix="_"+_time.substring(0,6);
					}
				}
				if($("#aidim_college").isNotNull()){//高校归属的地域
					if($("#city").val()!="0" || ($("#collegeDetail") && $("#collegeDetail").attr("checked"))){
						colPiece+=",value((select alias_college_name from (select college_id alias_college_code,college_name alias_college_name from NWH.COLLEGE_INFO"+bureauSuffix+" where state=1 ) alias_t2 where alias_college_code="+$("#aidim_college").attr("dbName")+"),'') college";
						groupPiece=cityDbName+","+$("#aidim_college").attr("dbName");
					}
					
				}else if($("#aidim_entCounty").isNotNull()){//集团归属的地域
					if($("#city").val()!="0" ||  $("#entCountyDetail").attr("checked") ){
						colPiece+=",value((select alias_entCounty_name from (select country_id alias_entCounty_code,org_name alias_entCounty_name from NMK.DIM_ent_AREAORG) alias_t2 where alias_entCounty_code="+$("#aidim_entCounty").attr("dbName")+"),'') entCounty";
						groupPiece=cityDbName+","+$("#aidim_entCounty").attr("dbName");
					}
					
				}else if($("#aidim_cell").isNotNull()||$("#aidim_town").isNotNull()||$("#aidim_marketing_center").isNotNull()||$("#aidim_county_bureau").isNotNull()){//通话归属的地域
					if( ($("#town").isNotNull() && $("#town").val()!="") || $("#cellDetail").attr("checked")){//选择了细分基站或则乡镇不为空
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("#aidim_county_bureau").attr("dbName")+"),'') county_bureau"
						+",value((select alias_marketing_center_name from (select id alias_marketing_center_code,name alias_marketing_center_name from nwh.bureau_tree"+bureauSuffix+" where level=3) alias_t2 where alias_marketing_center_code="+$("#aidim_marketing_center").attr("dbName")+"),'') marketing_center"
						+",value((select alias_town_name from (select id alias_town_code,name alias_town_name from nwh.bureau_tree"+bureauSuffix+" where level=4) alias_t2 where alias_town_code="+$("#aidim_town").attr("dbName")+"),'') town"
						+","+$("#aidim_cell").attr("dbName")+" cell_code,value((select alias_cell_name from (select id alias_cell_code,name alias_cell_name from nwh.bureau_tree"+bureauSuffix+" where level=5) alias_t2 where alias_cell_code="+$("#aidim_cell").attr("dbName")+"),'') cell"
						groupPiece=cityDbName+","+$("#aidim_county_bureau").attr("dbName")+","+$("#aidim_marketing_center").attr("dbName")+","+$("#aidim_town").attr("dbName")+","+$("#aidim_cell").attr("dbName");
						orderPiece="order by 1,2,3,4,5";
					}else if( ($("#marketing_center").isNotNull() && $("#marketing_center").val()!="") || $("#townDetail").attr("checked")){//选择了细分乡镇，或则营销中心不为空
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("#aidim_county_bureau").attr("dbName")+"),'') county_bureau"
						+",value((select alias_marketing_center_name from (select id alias_marketing_center_code,name alias_marketing_center_name from nwh.bureau_tree"+bureauSuffix+" where level=3) alias_t2 where alias_marketing_center_code="+$("#aidim_marketing_center").attr("dbName")+"),'') marketing_center"
						+",value((select alias_town_name from (select id alias_town_code,name alias_town_name from nwh.bureau_tree"+bureauSuffix+" where level=4) alias_t2 where alias_town_code="+$("#aidim_town").attr("dbName")+"),'') town"
						groupPiece=cityDbName+","+$("#aidim_county_bureau").attr("dbName")+","+$("#aidim_marketing_center").attr("dbName")+","+$("#aidim_town").attr("dbName");
						orderPiece="order by 1,2,3,4";
					}else if(($("#county_bureau").isNotNull() && $("#county_bureau").val()!="") || $("#mcDetail").attr("checked")){
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("#aidim_county_bureau").attr("dbName")+"),'') county_bureau"
						+",value((select alias_marketing_center_name from (select id alias_marketing_center_code,name alias_marketing_center_name from nwh.bureau_tree"+bureauSuffix+" where level=3) alias_t2 where alias_marketing_center_code="+$("#aidim_marketing_center").attr("dbName")+"),'') marketing_center"
						groupPiece=cityDbName+","+$("#aidim_county_bureau").attr("dbName")+","+$("#aidim_marketing_center").attr("dbName");
						orderPiece="order by 1,2,3";
					}else if($("#city").val()!="0" || $("#countyDetail").attr("checked")){
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("#aidim_county_bureau").attr("dbName")+"),'') county_bureau";
						groupPiece=cityDbName+","+$("#aidim_county_bureau").attr("dbName");
						orderPiece="order by 1,2";
					}
				}else if($("#aidim_channel").isNotNull() || $("#aidim_county").isNotNull() ){//入网点的地域
					if(($("#aidim_county").isNotNull() && $("#aidim_county").val()!="") || $("#channelDetail").attr("checked")){
						colPiece+=",value((select alias_county_name from (select county_code alias_county_code,county_name alias_county_name from mk.bt_area_all) alias_t2 where alias_county_code="+$("#aidim_county").attr("dbName")+"),'') county"
						+",value((select alias_channel_name from (select site_id alias_channel_code,site_name alias_channel_name from nwh.res_site) alias_t2 where alias_channel_code="+$("#aidim_channel").attr("dbName")+"),'') channel";
						groupPiece=cityDbName+","+$("#aidim_county").attr("dbName")+","+$("#aidim_channel").attr("dbName");
					}else if($("#city").val()!="0" || $("#countyDetail").attr("checked")){
						colPiece+=",value((select alias_county_name from (select county_code alias_county_code,county_name alias_county_name from mk.bt_area_all) alias_t2 where alias_county_code="+$("#aidim_county").attr("dbName")+"),'') county";
						groupPiece=cityDbName+","+$("#aidim_county").attr("dbName");
					}
				}else if($("#city").val()!="0"){
					colPiece+="";
					groupPiece=cityDbName;
				}
			}
		}catch(e){debugger;}
		sql = window.pieceInterceptor(sql,colPiece,groupPiece,orderPiece);
	}
	return sql;
}
window.genSqlPieces=genSqlPieces;
/*colPiece groupPiece 的处理*/
function pieceInterceptor(sql,colPiece,groupPiece,orderPiece){
	return sql.replace("{colPiece}",colPiece).replace("{groupPiece}",groupPiece).replace("{orderPiece}",orderPiece);
}
window.pieceInterceptor=pieceInterceptor;
/**
 * 处理sql中的替换变量
 * 不处理{colPiece} {groupPiece} {orderPiece}
 * @param sql
 * @return
 */
function sqlReplace(sql){
	//处理本地参数{}
	function _rep(obj,tagName){
		if(obj && ((obj.type!="checkbox"&&obj.value&&obj.value.length>0&&tagName!="city") || (tagName=="city"&&obj.value!="0") || obj.checked)){
			var pattern=new RegExp("{"+tagName+"}","gi");
			sql=sql.replace(pattern,obj.value);
		}
	}
	
	var elems = $("dim").each(function(){
		var obj = undefined;
		var tagName=$(this).attr("name");
		eval("obj=document.forms[0]."+tagName);
		_rep(obj,tagName);

		if($(this).attr("operType")=="between"){//bwteen 类型需要from
			obj = undefined;
			eval("obj=document.forms[0].from_"+$(this).attr("name"));
			_rep(obj,"from_"+$(this).attr("name"));
		}
	});
	//debugger;
	//处理传递的参数$P{}
	var matches = sql.match(/\$P\{[^\$P\{]*\}/g);
	if(matches&&matches.length>0){
		var _params = aihb.Util.paramsObj();
		for(var i=0; i<matches.length;i++){
			var paramName=matches[i].replace(/^\$P\{|\}$/g,"");
			if(_params[paramName]){
				var pattern=new RegExp("\\$P\\{"+paramName+"\\}","g");
				sql=sql.replace(pattern,_params[paramName]);
			}else{
				alert(paramName+" 不存在传递参数中");
			}
		}
	}
	//处理使用js的方法的字符串$F{} 放在最后因为可以处理前面两次参数替换的值
	var matches = sql.match(/\$F\{[^\$F\{]*\}/g);
	for(var i=0; matches && i<matches.length;i++){
		try{
			var mat=eval(matches[i].replace(/^\$F\{|\}$/g,""))
			sql=sql.replace(matches[i],mat);
		}catch(e){debugger;}
	}
	return sql;
}
window.sqlReplace=sqlReplace;
function chartIndicator(){
	var record = (grid.grid||grid).data[0];
	var res=$("#chart_oper");
	res.empty();
	if(record){
		for(var i=1;i<_header.length;i++){
			if(_header[i].dataIndex in record){
				var isPass=false;//判断是否是预定的地域维度和时间，就不显示
				for(var j=0;j<GROUP_CONSTANT.length;j++){
					if(_header[i].dataIndex==GROUP_CONSTANT[j]){
						isPass=true;
					}
				}
				if(!isPass){
					var label=_header[i].name[_header[i].name.length-1];
					var _offset=1;
					while(label=="#rspan" && _header[i].name.length>_offset){
						_offset++;
						label=_header[i].name[_header[i].name.length-_offset];
					}
					//var op=new Option(label,_header[i].dataIndex);
					//op.title=label;
					var op= $("<option/>",{text:label,title:label,value:_header[i].dataIndex})
					res.append(op);
				}
			}
		}
	}
	res.change(function(){
		chart($(this).val());
	});
	
	$("#chart_div").fadeIn();
	$("#chart").html("");
}
window.chartIndicator=chartIndicator;

function swichDate(){
	if($("#time_during").css("display")=="none"){
		$("#timeDetail").parent().fadeIn(500);
		$("#time_during").fadeIn(500);
		$("#time").css("width","78px");
	}else{
		$("#time").css("width","160px");
		$("#timeDetail").parent().fadeOut(200);
		$("#time_during").fadeOut(200);
	}
}
window.swichDate=swichDate;

var GROUP_CONSTANT=["cell","town","marketing_center","custmgr","county_bureau","entCounty","college","county","city","time"];//默认为groupby字段的，以seq小为优先

function chart(dataIndex){
	
	var groupCol=null;//拿record的第一列 //2010-11-15 这个很难判断，就先写死判断地域维度和时间维度
	var recordDatas=(grid.grid||grid).data
	for(var i=0;i<_header.length;i++){
		for(var j=0;j<GROUP_CONSTANT.length;j++){
			if(_header[i].dataIndex in recordDatas[0] && _header[i].dataIndex==GROUP_CONSTANT[j]){
				groupCol=_header[i].dataIndex;
				break;
			}
		}
	}
	if(groupCol==null){//没有命中约定的地域就取第一个
		for(var i=0;i<_header.length;i++){
			if(_header[i].dataIndex in recordDatas[0]){
				groupCol=_header[i].dataIndex;
				break;
			}
		}
	}
	
	if(dataIndex && groupCol!=null){
		var chartType=aihb.contextPath+"/resources/chart/Charts/FCF_Line.swf";
		var chartWidth="780";
		var chartHeight="200";
		if($("#time_during").css("display")=="none"){
			chartType=aihb.contextPath+"/resources/chart/Charts/FCF_Pie2D.swf";
		}
		//grid的data转换成fusionChart的格式,//2010-8-25这个方法应该去掉，在调用的地方实现gridDataTransfer : function(data,keyIdx,valIdx){
		var list=[];
		var _key=null;
		
		for(var i=0;i<recordDatas.length;i++){
			_key=recordDatas[i][groupCol]
			if(_key!="总计" && _key!="合计" && _key!="全省"){
				list.push([_key,recordDatas[i][dataIndex]]);
			}
		}
		
		var chart = new FusionCharts(chartType, "Chart", chartWidth, chartHeight);
		chart.setDataXML(aihb.FusionChartHelper.chartNormal(list));
		chart.addParam("wmode","transparent");
		chart.render("chart");
	}
}

function tip(){
	var datas = null;
	try{
		var datas = _corReport;
	}catch(e){debugger;}
	if(datas!=null){
		for(var i=0;i<datas.length;i++){
			var obj=$("<div>",{
				text:datas[i].name+(datas[i].dy_uname!=null?(" 『自定义』"):"")
				,title:(datas[i].dy_uname!=null?(" 归属『"+datas[i].dy_uname+"』："):"")+datas[i].desc
				,_id:datas[i].id
				,kind:datas[i].kind
				,style:"cursor:hand"
				,click:function(){
					var _url = subjectUrl(this._id,this.kind);
				    tabAdd({title:this.innerText,url: _url+(_url.indexOf("?")>0?"&":"?")+"promo=true"});
//					tabAdd({title:$(this).text(),url: subjectUrl($(this).attr("_id"),$(this).attr("kind"))+"&promo=true"});
				}
			});
			if(i>5)obj.hide();
			$("#indi").append(obj);
		}
		var sep = $("<div>",{
			text:"更多>>"
			,style:"cursor:hand;align:right"
			,click:function(){
				var objs = $("#indi > div").each(function(){
					$(this).fadeIn(200);
				});
			}
		});
		$("#indi").append(sep);
	}
}

function subjectUrl(id,kind){
	var _strUri="";
	if(kind=="动态"){
		_strUri="/hbirs/action/dynamicrpt?method=render&sid="+id;
	}else if(kind=="配置"){
		_strUri=aihb.contextPath+"/report/"+id;
	}
	return _strUri;
}

aihb.Util.addEventListener(window,"load",function(){
	var tipDiv=$("<div>",{id:"tip"
		,style:"position:absolute;padding: 5 0 0 5 px;width: 190px;right: 20px;top: 180 px;z-index:30;background-color: #FFFFB5;border:1px solid #B3A894;filter:alpha(opacity=80)"
	}).appendTo($(document.body));
	
	tipDiv.append($("<b>").html("你可能还关注以下应用："));
	
	tipDiv.append($("<span>",{title:"关闭",style:"cursor:hand;",onclick:function(){tipDiv.fadeOut();}}).html("×"));
	
	tipDiv.append($("<div>",{id:"indi"}));
	tip();
});

})(jQuery,window);


