/*********************    配置报表的公共JS   ********************************************/

/**
 * 处理{colPiece} {groupPiece} {orderPiece}的替换
 */
function genSqlPieces(sql){
	//debugger;
	if(/\{colPiece\}/.exec(sql)!=null||/\{groupPiece\}/.exec(sql)!=null||/\{orderPiece\}/.exec(sql)!=null){
		//时间分组
		var colPiece=($("aidim_time")||"").dbName +" time";
		var groupPiece=($("aidim_time")||"").dbName;
		var orderPiece=" order by 1";
		try{
			if($("aidim_time")==undefined || $("time_during").style.display=="none" || !$("timeDetail").checked){//地域分组
				colPiece="value((select alias_area_name from (select area_code alias_area_code,area_name alias_area_name from mk.bt_area) alias_t1 where alias_area_code="+$("aidim_city").dbName+"),case when grouping("+$("aidim_city").dbName+")=1 then '总计' else "+$("aidim_city").dbName+" end) city";
				groupPiece="rollup("+$("aidim_city").dbName+")";
				
				var bureauSuffix="";//判断地域们的时间周期
				if($("time")){
					
					var _date=new Date();
					_date.setDate(_date.getDate()-1);
					var _time=$("time").value;
					if(_time.length==6){
						bureauSuffix="_"+_time;
					}else if(_time.length==8 && (_date.format("yyyymm"))!=_time.substring(0,6)){
						bureauSuffix="_"+_time.substring(0,6);
					}
				}
				if($("aidim_college")){//高校归属的地域
					if($("city").value!="0" || ($("collegeDetail") && $("collegeDetail").checked)){
						colPiece+=",value((select alias_college_name from (select college_id alias_college_code,college_name alias_college_name from NWH.COLLEGE_INFO"+bureauSuffix+") alias_t2 where alias_college_code="+$("aidim_college").dbName+"),'') college";
						groupPiece=$("aidim_city").dbName+","+$("aidim_college").dbName;
					}
					
				}else if($("aidim_entCounty")){//集团归属的地域
					if($("city").value!="0" || ($("entCountyDetail") && $("entCountyDetail").checked)){
						colPiece+=",value((select alias_entCounty_name from (select country_id alias_entCounty_code,org_name alias_entCounty_name from NMK.DIM_ent_AREAORG) alias_t2 where alias_entCounty_code="+$("aidim_entCounty").dbName+"),'') entCounty";
						groupPiece=$("aidim_city").dbName+","+$("aidim_entCounty").dbName;
					}
					
				}else if($("aidim_cell")||$("aidim_town")||$("aidim_marketing_center")||$("aidim_county_bureau")){//通话归属的地域
					if(($("town")&& $("town").value!="") || ($("cellDetail") && $("cellDetail").checked)){//选择了细分基站或则乡镇不为空
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("aidim_county_bureau").dbName+"),'') county_bureau"
						+",value((select alias_marketing_center_name from (select id alias_marketing_center_code,name alias_marketing_center_name from nwh.bureau_tree"+bureauSuffix+" where level=3) alias_t2 where alias_marketing_center_code="+$("aidim_marketing_center").dbName+"),'') marketing_center"
						+",value((select alias_town_name from (select id alias_town_code,name alias_town_name from nwh.bureau_tree"+bureauSuffix+" where level=4) alias_t2 where alias_town_code="+$("aidim_town").dbName+"),'') town"
						+","+$("aidim_cell").dbName+" cell_code,value((select alias_cell_name from (select id alias_cell_code,name alias_cell_name from nwh.bureau_tree"+bureauSuffix+" where level=5) alias_t2 where alias_cell_code="+$("aidim_cell").dbName+"),'') cell"
						groupPiece=$("aidim_city").dbName+","+$("aidim_county_bureau").dbName+","+$("aidim_marketing_center").dbName+","+$("aidim_town").dbName+","+$("aidim_cell").dbName;
						orderPiece="order by 1,2,3,4,5";
					}else if(($("marketing_center") && $("marketing_center").value!="") || ($("townDetail") && $("townDetail").checked)){//选择了细分乡镇，或则营销中心不为空
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("aidim_county_bureau").dbName+"),'') county_bureau"
						+",value((select alias_marketing_center_name from (select id alias_marketing_center_code,name alias_marketing_center_name from nwh.bureau_tree"+bureauSuffix+" where level=3) alias_t2 where alias_marketing_center_code="+$("aidim_marketing_center").dbName+"),'') marketing_center"
						+",value((select alias_town_name from (select id alias_town_code,name alias_town_name from nwh.bureau_tree"+bureauSuffix+" where level=4) alias_t2 where alias_town_code="+$("aidim_town").dbName+"),'') town"
						groupPiece=$("aidim_city").dbName+","+$("aidim_county_bureau").dbName+","+$("aidim_marketing_center").dbName+","+$("aidim_town").dbName;
						orderPiece="order by 1,2,3,4";
					}else if($("county_bureau").value!="" || ($("mcDetail") && $("mcDetail").checked)){
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("aidim_county_bureau").dbName+"),'') county_bureau"
						+",value((select alias_marketing_center_name from (select id alias_marketing_center_code,name alias_marketing_center_name from nwh.bureau_tree"+bureauSuffix+" where level=3) alias_t2 where alias_marketing_center_code="+$("aidim_marketing_center").dbName+"),'') marketing_center"
						groupPiece=$("aidim_city").dbName+","+$("aidim_county_bureau").dbName+","+$("aidim_marketing_center").dbName;
						orderPiece="order by 1,2,3";
					}else if($("city").value!="0" || ($("countyDetail") && $("countyDetail").checked)){
						colPiece+=",value((select alias_county_name from (select id alias_county_code,name alias_county_name from nwh.bureau_tree"+bureauSuffix+" where level=2) alias_t2 where alias_county_code="+$("aidim_county_bureau").dbName+"),'') county_bureau";
						groupPiece=$("aidim_city").dbName+","+$("aidim_county_bureau").dbName;
						orderPiece="order by 1,2";
					}
				}else if($("aidim_county")){//入网点的地域
					if($("city").value!="0" || ($("countyDetail") && $("countyDetail").checked)){
						colPiece+=",value((select alias_county_name from (select county_code alias_county_code,county_name alias_county_name from mk.bt_area_all) alias_t2 where alias_county_code="+$("aidim_county").dbName+"),'') county";
						groupPiece=$("aidim_city").dbName+","+$("aidim_county").dbName;
					}
				}else if($("city").value!="0"){
					colPiece+="";
					groupPiece=$("aidim_city").dbName;
				}
			}
		}catch(e){debugger;}
		sql = pieceInterceptor(sql,colPiece,groupPiece,orderPiece);
	}
	return sql;
}

/*colPiece groupPiece 的处理*/
function pieceInterceptor(sql,colPiece,groupPiece,orderPiece){
	return sql.replace("{colPiece}",colPiece).replace("{groupPiece}",groupPiece).replace("{orderPiece}",orderPiece);
}

/**
 * 处理sql中的替换变量
 * 不处理{colPiece} {groupPiece} {orderPiece}
 * @param sql
 * @return
 */
function sqlReplace(sql){
	//处理本地参数{}
	var elems = document.getElementsByTagName("dim");
	for( var i=0; i < elems.length; i++ ){
		var elem=elems[i];
		var obj = undefined;
		try{
			eval("obj=document.forms[0]."+elem.name);
		}catch(e){debugger;}
		if(obj && ((obj.type!="checkbox"&&obj.value.length>0&&elem.name!="city") || (elem.name=="city"&&obj.value!="0") || obj.checked)){
			var pattern=new RegExp("{"+elem.name+"}","gi");
			sql=sql.replace(pattern,obj.value);
		}
	}
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

function chartIndicator(){
	var record = (grid.grid||grid).data[0];
	var res=$("chart_oper");
	res.length=0;
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
					var op=new Option(label,_header[i].dataIndex);
					op.title=label;
					res.add(op);
				}
			}
		}
	}
	res.onchange=function(){
		chart(this.value)
	}
	
	$("chart_div").style.display="";
	$("chart").innerHTML="";
}

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
		var chartType="/hb-bass-navigation/hbapp/resources/chart/Charts/FCF_Line.swf";
		var chartWidth="780";
		var chartHeight="200";
		if($("time_during").style.display=="none"){
			chartType="/hb-bass-navigation/hbapp/resources/chart/Charts/FCF_Pie2D.swf";
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

function swichDate(){
	/*if($("time_during").style.display=="none"){
		$("time_point").style.display="none";
		$("time_during").style.display="";
		$("timeDetail").parentNode.style.display="";
	}else{
		$("time_point").style.display="";
		$("time_during").style.display="none";
		$("timeDetail").parentNode.style.display="none";
	}*/
	if($("time_during").style.display=="none"){
		$("time_during").style.display="";
		$("timeDetail").parentNode.style.display="";
		$("time").style.width="78px"
	}else{
		$("time_during").style.display="none";
		$("timeDetail").parentNode.style.display="none";
		$("time").style.width="160px"
	}
}

function tip(){
	var param = aihb.Util.paramsObj();
	var sql = " select id,name,desc,kind,dy_uname from FPF_bir_subject_correlation"
	+" ,("
	+" select a.*"
	+" ,case when kind='动态' and a.status='开发' then value((select area_name from mk.bt_area where int(cityid)=area_id),'省公司')||username end dy_uname from FPF_IRS_SUBJECT a" 
	+" left join fpf_irs_package b on a.pid=b.id"
	+" left join FPF_USER_USER c on b.user_id=c.userid"
	+" where ((kind='配置' and a.status='在用') or kind='动态') "
	+" ) t "
	+" where SOURCE="+param.sid+" and target=id order by value desc fetch first 30 rows only with ur"
	
	var ajax = new aihb.Ajax({
		url : "/hb-bass-navigation/hbirs/action/jsondata"
		,parameters : "sql="+encodeURIComponent(sql)+"&ds=web"
		,callback : function(xmlrequest){
			var datas = eval(xmlrequest.responseText);
			for(var i=0;i<datas.length;i++){
				var obj=$C("div");
				obj.innerText=datas[i].name+(datas[i].dy_uname!=null?(" 『自定义』"):"");
				obj.title=(datas[i].dy_uname!=null?(" 归属『"+datas[i].dy_uname+"』："):"")+datas[i].desc;
				obj._id=datas[i].id;
				obj.kind=datas[i].kind;
				obj.style.cursor="hand";
				obj.onclick=function(){
					tabAdd({title:this.innerText,url: subjectUrl(this._id,this.kind)+"&promo=true"});
				}
				if(i>5){
					obj.style.display="none";
				}
				$("indi").appendChild(obj);
			}
			var sep = $C("div");
			sep.innerText="更多>>";
			sep.style.cursor="hand";
			sep.align="right";
			sep.onclick=function(){
				var objs = $("indi").getElementsByTagName("div");
				for(var j=0;j<objs.length;j++){
					objs[j].style.display="";
				}
			}
			$("indi").appendChild(sep);
		}
	});
	
	ajax.request();
}

function subjectUrl(id,kind){
	var _strUri=""
	
	if(kind=="动态"){
		_strUri="/hb-bass-navigation/hbirs/action/dynamicrpt?method=render";
	}else if(kind=="配置"){
		_strUri="/hb-bass-navigation/hbirs/action/confReport?method=render";
	}else if(kind=="下拉框"){
		_strUri="/hb-bass-navigation/hbapp/app/rptNavigation/main_dropdown.htm";
	}
	
	if(_strUri.indexOf("?")>0){
		_strUri += "&";
	}else{
		_strUri += "?";
	}
	_strUri+="sid="+id;
	
	return _strUri;
}

aihb.Util.addEventListener(window,"load",function(){
	var tipDiv=$C("div");
	tipDiv.id="tip";
	tipDiv.style.cssText="position:absolute;padding: 5 0 0 5 px;width: 190px;right: 20px;top: 180 px;z-index:30;background-color: #FFFFB5;border:1px solid #B3A894;filter:alpha(opacity=80);";
	var _b=$C("b");
	_b.appendChild($CT("你可能还关注以下应用："));
	tipDiv.appendChild(_b);
	
	var _span=$C("span");
	_span.title="关闭";
	_span.style.cursor="hand;"
	_span.appendChild($CT("×"));
	_span.onclick=function(){
		tipDiv.style.display="none";
	}
	tipDiv.appendChild(_span);
	
	var _div=$C("div");
	_div.id="indi";
	tipDiv.appendChild(_div);
	document.body.appendChild(tipDiv);
	tip();
});
