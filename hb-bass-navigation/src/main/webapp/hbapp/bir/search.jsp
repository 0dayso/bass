<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<HTML>
<HEAD>
	<META http-equiv="Content-Type" content="text/html; charset=utf-8">
	<TITLE>湖北移动经营分析系统_信息检索</TITLE>
	<STYLE>
	body{font:12px arial;margin:0px;background:#fff}
	.btn{width:78px;height:28px;line-height:24px;font:14px arial}
	.hint{padding: 5px 0 0 15px;font-size:12px;font-family: 黑体;}
	</STYLE>
	<script type="text/javascript" src="../resources/js/default/default.js"></script>
	<script type="text/javascript" src="../resources/js/default/json2.js"></script>
	<script type="text/javascript" src="../resources/js/default/tabext.js" charset="utf-8"></script>
	<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/main.js"></script>
	<script type="text/javascript" src="../resources/js/default/autocomplete.js"></script>
	<link rel="stylesheet" type="text/css" href="../resources/css/default/default.css" />
	<script type="text/javascript"> 
	
	window.onload=function(){
		var _kw=decodeURI(aihb.Util.paramsObj().kw);
		if(_kw && _kw.length>0){
			document.forms[0].kw.value=_kw;
			_s();
		}
		
		var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=suggest"
			,parameters : "catacode="+encodeURIComponent("经分信息检索")
			,callback : function(xmlrequest){
				var _suggest = [];
				try{
					eval("_suggest="+xmlrequest.responseText)
				}catch(e){}
				var obj = actb($('kw'),_suggest);
			}
		});
		ajax.request();
		
	}
	function _key(){
		if(event.keyCode==13 && document.forms[0].kw.value.length>0){
			_s();
		};
	}
	var pattern=/武汉|荆州|襄阳|宜昌|黄冈|孝感|黄石|十堰|咸宁|荆门|鄂州|恩施|江汉|随州|天门|潜江/gi;
	function _s(){
		var _kw=document.forms[0].kw.value;
		var _rg=pattern.exec(_kw);
		var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=search"
			,parameters : "kw="+encodeURIComponent(document.forms[0].kw.value)+"&catacode="+encodeURIComponent("经分信息检索")
			,callback : function(xmlrequest){
				var res = {}
				try{
					eval("res="+xmlrequest.responseText);
				}catch(e){}
				var _grid = new aihb.Grid({
					container : $("res")
					,data : res.res 
					,pageSize : 10
				});
				_grid.segment=res.segment;
				_grid.render=function(){
					
					var _container=this.container; 
					_container.innerHTML="";
					
					var segment=this.segment;
					
					var datas=this.data;
					
					var rowseq = this.paging.pageSize*this.paging.currentPage-this.paging.start+1;
					for(var i=rowseq-this.paging.pageSize; i< (rowseq>datas.length?datas.length:rowseq)+(this.dataAmount?1:0); i++){
					
					//for(var i=0;i<datas.length;i++){
						var _div=$C("div");
						_div.id=datas[i].appname+datas[i].id;
						var _font1=$C("font");
						_font1.size="3";
						_font1.color="#2200CC";						
						
						var obj=$C("div");
						obj.innerHTML=(_rg!=null?"<font color='#c60a00'>"+_rg+"</font>":"")+segmentReplace(datas[i].name,segment);
						
						//obj.url="&appName="+datas[i].appname+"&zbcode="+datas[i].id+"&zbname="+datas[i].name+"&percentType="+datas[i].formattype;
						obj.url=datas[i].id;
						//if(_rg!=null){
						//	obj.url+="&area="+area[_rg];
						//}else{
						//	obj.url+="&area=0";
						//}
						obj.title=datas[i].desc;
						obj.text=datas[i].name;
						obj.style.cursor="pointer";
						obj._uri = "../kpiAna/"+datas[i].id;
						obj.onclick=function(){
							//tabAdd({url:"/hbapp/kpiportal/kpiview/kpiviewDetail.jsp?brand="+this.url ,title:this.text});
							window.parent.addTab(this.url,_trim(this.text),_trim(this._uri));
						}
						
						_font1.appendChild(obj);
						
						var _font2=$C("font");
						_font2.size="-1";
						_font2.innerHTML=segmentReplace(datas[i].desc,segment);		
						
						var _font3=$C("font");
						_font3.size="-1";
						_font3.color="#008000";
						//_font3.innerText="/hbapp/kpiportal/kpiview/kpiviewDetail.jsp?brand="+obj.url;			
						_font3.innerText="../kpiAna/"+obj.url;
						_div.appendChild($C("p"));
						_div.appendChild(_font1);
						_div.appendChild(_font2);
						_div.appendChild($C("br"));
						_div.appendChild(_font3);
						
						
						_container.appendChild(_div);
					}
						
					_container.appendChild(this.getPaging());
				}
				_grid.render();
				
				//前5个KPI的值直接显示数值
				var datas=res.res;
				var zbCodes="";
				
				var regCond="";
				if(_rg!=null){
					regCond="&area="+area[_rg];
				}
				
				//换一个实现方式，发一次请求即可
				var kpiObj=[];
				for(var i=0;i<(datas.length>5?5:datas.length);i++){
					kpiObj[i]={
						"appname":datas[i].appname
						,"zbcode":datas[i].id
					} 
				}
				
				var _ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/kpi?method=getKpis"
					,parameters : "kpis="+  JSON.stringify(kpiObj)
					,callback : function(xmlrequest){
						var kpis = {}
						try{
							eval("kpis="+xmlrequest.responseText);
						}catch(e){}
						
						for(var i=0;i<kpis.length;i++){
						
							if(kpis[i]){
								var _val=$C("div");
								_val.className="hint";
								
								function biValColor(obj){
									if(obj>=0.05)
										return "<font color='#008000'>"+aihb.Util.percentFormat(obj)+"</font>"
									else if(obj<=-0.05)	
										return "<font color='red'>"+aihb.Util.percentFormat(obj)+"</font>"
									else return aihb.Util.percentFormat(obj);
								}
								
								var _hstr=(_rg!=null?"<font color='#c60a00'>"+_rg+"</font>":"")+"当前值：<font size='2'>"
									+(kpis[i].formatType?aihb.Util.percentFormat(kpis[i].current):aihb.Util.numberFormat(kpis[i].current))
									+"</font>"
									+" 时间："+kpis[i].date
									+"<br>"
									+"环比增长："+biValColor(kpis[i].huanbi)
									+" 同比增长："+biValColor(kpis[i].tongbi)	
									+(kpis[i].progress!="--"?"<br>当前完成："+aihb.Util.percentFormat(kpis[i].progress)+" 目标值："+(kpis[i].formatType?aihb.Util.percentFormat(kpis[i].target):aihb.Util.numberFormat(kpis[i].target))
										:"");						
								_val.innerHTML=_hstr;
								$(kpis[i].appName+kpis[i].id).appendChild(_val);
							}
						}
					}
				});
				//_ajax.request();
			}
		});
		ajax.request();
		
		
		
		
		var ajax1 = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=search&type=subject"
			,parameters : "kw="+encodeURIComponent(document.forms[0].kw.value)+"&catacode="+encodeURIComponent("经分信息检索")
			,callback : function(xmlrequest){
				var res = {}
				try{
					eval("res="+xmlrequest.responseText);
				}catch(e){}
				
				var _grid = new aihb.Grid({
					container : $("sub")
					,data : res.res 
					,pageSize : 15
				});
				_grid.segment=res.segment;
				_grid.render=function(){
					
					var _container=this.container; 
					_container.innerHTML="";
					
					var segment=this.segment;
					
					var datas=this.data;
					
					var rowseq = this.paging.pageSize*this.paging.currentPage-this.paging.start+1;
					for(var i=rowseq-this.paging.pageSize; i< (rowseq>datas.length?datas.length:rowseq)+(this.dataAmount?1:0); i++){
					
						var _div=$C("div");
						_div.id=datas[i].id;
						var _font1=$C("font");
						_font1.size="3";
						_font1.color="#2200CC";						
						
						var obj=$C("div");
						obj.innerHTML=(_rg!=null?"<font color='#c60a00'>"+_rg+"</font>":"")+segmentReplace(datas[i].name,segment)+(datas[i].dy_uname!=null?("<font size=2 color=gray>  『"+datas[i].dy_uname+"』自定义报表 </font>"):"");
						
						//obj.url="&appName="+datas[i].appname+"&zbcode="+datas[i].id+"&zbname="+datas[i].name+"&percentType="+datas[i].formattype;
						if(_rg!=null){
							obj.url+="&area="+area[_rg];
						}else{
							obj.url+="&area=0";
						}
						obj.title=datas[i].desc;
						obj.text=datas[i].name ;
						obj.style.cursor="pointer";
						obj.kind=datas[i].kind;
						obj._id=datas[i].id;
						obj._uri = datas[i].uri;
						obj.onclick=function(){
							//checkRight(this._id,this.kind,this.innerText);
							window.parent.addTab(_trim(this._id),_trim(this.text),_trim(this._uri));
						}
						
						_font1.appendChild(obj);
						
						var _font2=$C("font");
						_font2.size="-1";
						_font2.innerHTML=segmentReplace(datas[i].desc,segment);		
						
						var _font3=$C("font");
						_font3.size="-1";
						_font3.color="#008000";
						//_font3.innerText=subjectUrl(datas[i].id,datas[i].kind);			
						//helei 2011-11-03改为前台路径
						_font3.innerText=datas[i].path;
						
						_div.appendChild($C("p"));
						_div.appendChild(_font1);
						_div.appendChild(_font2);
						_div.appendChild($C("br"));
						_div.appendChild(_font3);
						
						
						_container.appendChild(_div);
					}
						
					_container.appendChild(this.getPaging());
				}
				_grid.render();
				
			}
		});
		ajax1.request();
		
		//2013-05-29新增菜单搜索 by yulei3
		var ajax2 = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=search&type=menu"
			,parameters : "kw="+encodeURIComponent(document.forms[0].kw.value)+"&catacode="+encodeURIComponent("经分信息检索")
			,callback : function(xmlrequest){
				var res = {}
				try{
					eval("res="+xmlrequest.responseText);
				}catch(e){}
				
				var _grid = new aihb.Grid({
					container : $("menu")
					,data : res.res 
					,pageSize : 15
				});
				_grid.segment=res.segment;
				_grid.render=function(){
					
					var _container=this.container; 
					_container.innerHTML="";
					
					var segment=this.segment;
					
					var datas=this.data;
					
					var rowseq = this.paging.pageSize*this.paging.currentPage-this.paging.start+1;
					for(var i=rowseq-this.paging.pageSize; i< (rowseq>datas.length?datas.length:rowseq)+(this.dataAmount?1:0); i++){
					
						var _div=$C("div");
						
						_div.id=datas[i].menuitemid;
						var _font1=$C("font");
						_font1.size="3";
						_font1.color="#2200CC";						
						
						var obj=$C("div");
						obj.innerHTML=(_rg!=null?"<font color='#c60a00'>"+_rg+"</font>":"")+segmentReplace(datas[i].menuitemtitle,segment)+(datas[i].dy_uname!=null?("<font size=2 color=gray>  『"+datas[i].dy_uname+"』自定义报表 </font>"):"");
						
						obj.title=datas[i].menuitemtitle;
						obj.text=datas[i].menuitemtitle ;
						obj.style.cursor="pointer";
						obj.kind=datas[i].kind;
						obj._id=datas[i].menuitemid;
						obj._url = datas[i].url
						obj.onclick=function(){
							checkMenuRight(_trim(this._id),_trim(this.text),_trim(this._url));
						}
						
						_font1.appendChild(obj);
						
						var _font2=$C("font");
						_font2.size="-1";
						_font2.innerHTML=segmentReplace(datas[i].kind,segment);		
						
						var _font3=$C("font");
						_font3.size="-1";
						_font3.color="#008000";
						//_font3.innerText=subjectUrl(datas[i].id,datas[i].kind);			
						//helei 2011-11-03改为前台路径
						_font3.innerText=datas[i].url;
						
						_div.appendChild($C("p"));
						_div.appendChild(_font1);
						_div.appendChild(_font2);
						_div.appendChild($C("br"));
						_div.appendChild(_font3);
						
						
						_container.appendChild(_div);
					}
						
					_container.appendChild(this.getPaging());
				}
				_grid.render();
				
			}
		});
		ajax2.request();
		
	}
	function segmentReplace(source,segment){
		if(source && source.length>0){
			var patternStr="";
			var replaceStr="";
			for(var i=0;i<segment.length;i++){
				if(patternStr.length>0)
					patternStr+="|"
				patternStr+="("+segment[i]+")";
				
				replaceStr+="<font color='#c60a00'>$"+(i+1)+"</font>";
			}
			return source.replace(new RegExp(patternStr,"gi"),replaceStr);
		}else{
			return "";
		}
	}
	
	function _trim(str){
		return str.replace(/(^\s*)/g, "");
	}
	
	
	
	
	//打开报表
	function checkRight(id,kind,innerText){
		var ajax1 = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=checkSearch"
			,parameters : "id="+id+"&kind="+kind
			,callback : function(xmlrequest){
				var res = eval("("+xmlrequest.responseText+")");
				if(res.status==true){
					tabAdd({title:innerText,url: subjectUrl(id,kind) });
				}else{
					alert("没有访问此菜单的权限");
				}
			}
		});
		//ajax1.request();
	}
	
	//核查是否有打开菜单权限
	function checkMenuRight(id,title,url){
		var ajax1 = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=checkMenuRight"
			,parameters : "id="+id
			,callback : function(xmlrequest){
				var res = eval("("+xmlrequest.responseText+")");
				if(res.status==true){
					//tabAdd({title:title,url:url });
					//报表开发工具不拼接menuid，拼接会导致报表开发页面打不开
			   		if(url!=null && url.length >0 && url.indexOf('doota/')<0){
			   			if(url.indexOf('?')<0){
							url = url+'?menuid='+id;
						}else{
							url = url+'&menuid='+id;
						}
			   		}
					window.parent.addTab(id, title, url);
				}else{
					alert("没有访问此菜单的权限");
				}
			}
		});
		ajax1.request();
	}
	
	var area=[];
	area["恩施"]="HB.ES";
	area["鄂州"]="HB.EZ";
	area["黄冈"]="HB.HG";
	area["黄石"]="HB.HS";
	area["江汉"]="HB.JH";
	area["荆门"]="HB.JM";
	area["荆州"]="HB.JZ";
	area["十堰"]="HB.SY";
	area["随州"]="HB.SZ";
	area["武汉"]="HB.WH";
	area["襄樊"]="HB.XF";
	area["孝感"]="HB.XG";
	area["咸宁"]="HB.XN";
	area["宜昌"]="HB.YC";
	area["天门"]="HB.TM";
	area["潜江"]="HB.QJ";
	
function subjectUrl(id,kind){
	var _strUri=""
	
	if(kind=="动态"){
		_strUri="${mvcPath}/hbirs/action/dynamicrpt?method=render";
	}else if(kind=="配置"){
		//_strUri="/hbirs/action/confReport?method=render";
		//helei 2011-11-03 修改，原来的方式点查询报错
		_strUri="${mvcPath}/report/"+id;
	}else if(kind=="下拉框"){
		_strUri="${mvcPath}/hbapp/app/rptNavigation/main_dropdown.htm";
	}
	
	if(_strUri.indexOf("?")>0){
		_strUri += "&";
	}else{
		_strUri += "?";
	}
	_strUri+="sid="+id;
	
	return _strUri;
}

function urlTrace(id){
	
}
	
	</script>
</HEAD>
<BODY onkeypress="_key()" >
<div style='margin-bottom: 10px;margin-top: 5px;margin-left: 8px;'>
<FORM name="f" action="" style="margin: 0px;">
	<TABLE width="100%" align="center" cellpadding="0" cellspacing="0">
	<TR valign="bottom" style="padding:4px 5px 3px 8px;">
		<TD height="39">
			<IMG src="bir_s.gif" border="0" width="166" height="39" alt="经分信息检索">
		</TD>
		<TD width="100%">
			<INPUT name="kw" id="kw" size="46" maxlength="100" style="width:390px;line-height:16px;padding:3px;margin:0px;font:16px arial"> 
			<INPUT type="button" value="经分搜索" class="btn" onclick="_s()">
		</TD>
	</TR>
	</TABLE>
	</FORM>	
</div>

<div style="background-color: #F0F7F9;border-top:1px solid #6B90DA;width: 100%;padding-bottom: 5px;margin-bottom:5px; "></div>
<table width="98%">
<thead>
	<th><h3>KPI搜索结果</h3></th>
	<th><h3>报表搜索结果</h3></th>
	<th><h3>菜单搜索结果</h3></th>
</thead>
<tr valign="top">
<td id="res" width="33%"></td>
<td id="sub" width="33%"></td>
<td id="menu" width="33%"></td>
</tr>
</table>
</BODY>
</HTML>