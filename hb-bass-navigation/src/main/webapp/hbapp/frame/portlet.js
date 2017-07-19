var _params = aihb.Util.paramsObj();
/*
 * 黑板报
 * @return
 */
function blackboard(){ 
	var sql=encodeURIComponent("select newsid id,char(date(newsdate)) date,newstitle title,newsmsg content from FPF_USER_NEWS order by newsdate desc fetch first 5 rows only with ur");
	var ajax=new aihb.Ajax({
		url:"/hb-bass-navigation/hbirs/action/jsondata"
		,parameters : "sql="+sql+"&ds=web"
		,callback:function(xmlresponse){
			var datas=[];
			try{
				eval("datas="+xmlresponse.responseText);
			}catch(e){debugger;}
			var _accordion=$("blackboard");
			for(var i=0;i<datas.length;i++){
				var data=datas[i];
				var _sect=$C("div");
				var _a=$C("a");
				_a.href="#";
				if(i==0)_sect.id="sec_first";
				_a.appendChild($CT(data.date+" "));
				_a.appendChild($CT(data.title));
				_sect.appendChild(_a);
				_sect.style.cssText="border-bottom:1px solid #bbbbbb;border-left:0px;border-right:0px;border-top:0px;";
				var _cont=$C("a");
				_cont.appendChild($CT(data.content));
				_cont.style.cssText="border-top:1px solid #bbbbbb;border-left:0px;border-right:0px;border-bottom:0px;";
				_cont.href="javascript:void(0)";
				_cont.nid=data.id
				_cont.ntitle=data.title;
				_cont.onclick=function(){
					tabAdd({url:"/newsshow.jsp?newsid="+this.nid,title:this.ntitle});
				}
				_accordion.appendChild(_sect);
				_accordion.appendChild(_cont);
			}
			jQuery("#blackboard").accordion({
				autoHeight: false
				,collapsible: true
				//,event: "mouseover"
				//,clearStyle:true
			});
			jQuery('#sec_first').click();
		}
	});

	ajax.request();
}
/**
 * 新上线
 * @return
 */
function newonline(){
	var sql=encodeURIComponent("select id,char(date(lastupd))||'   '||name label,name,kind from fpf_irs_subject where status='在用' order by lastupd desc fetch first 4 rows only with ur");
	var ajax=new aihb.Ajax({
		url:"/hb-bass-navigation/hbirs/action/jsondata"
		,parameters : "sql="+sql+"&ds=web"
		,callback:function(xmlresponse){
			var datas=[];
			try{
				eval("datas="+xmlresponse.responseText);
			}catch(e){debugger;}
			
			subjectList(datas,$("newonline"));
		}
	});

	ajax.request();
}

var threshold = new Threshold();
threshold.path="/hb-bass-navigation/hbapp/resources/image/default/";
/**
 * 我的定制
 * @return
 */
function mycustome(){
	jQuery("#mycustome").tabs({
		event: "mouseover"
	});

	//定制KPI
	function kpi(){
		var _header=[
			{"name":["指标名称"],"dataIndex":"name","cellStyle":"grid_row_cell_text"
				,cellFunc:function(val,options){
					var _span=$C("span");
					_span.title=options.record.instruction;
					_span.style.cursor="hand";
					_span.label=options.record.name;
					_span.param="appName="+options.record.appName+"&zbcode="+options.record.id+"&zbname="+(options.record.name)+"&area="+(_params.cityId||0)+"&percentType="+(options.record.formatType||"")+"&brand="
					_span.onclick=function(){
						tabAdd({url:"/hbapp/kpiportal/kpiview/kpiviewDetail.jsp?"+this.param,title:this.label});
					}
					_span.appendChild($CT(val));
					return _span;
				}
			}
			,{"name":["当前数值"],"dataIndex":"current","cellStyle":"grid_row_cell_number"
				,cellFunc:function(val,options){
					return options.record.formatType!="percent"?aihb.Util.numberFormat(val):aihb.Util.percentFormat(val);		
				}
			}
			,{"name":["环比增幅"],"dataIndex":"tongbi","cellStyle":"grid_row_cell_number"
				/**/,cellFunc: function (val,options){
					var str=aihb.Util.percentFormat(val);
					str+=threshold.getTongbiImg(val);
					return str;
				}
			}
		];
		var ajax = new aihb.Ajax({
			url : "/hb-bass-navigation/hbirs/action/kpi?method=customizeKpis&isLog=false"
			,loadmask : true
			,callback : function(xmlrequest){
				$("mykpi").style.display="";
				var res = {}
				try{
					eval("res="+xmlrequest.responseText);
				}catch(e){debugger;}
				var _grid = new aihb.Grid({
					container : $("mykpi")
					,data : res.data || res
					,limit : (res.data || res).length
					,header : _header
					,pageSize : (res.data || res).length
				});
				
				_grid.render();
				
			}
		});
		
		ajax.request();
	}
	
	kpi();
	
	//自定义报表
	function custRpt(){
		var ajax = new aihb.Ajax({
			url : "/hb-bass-navigation/hbirs/action/rptNavi?method=init&isLog=false"
			,callback : function(xmlrequest){
				var datas = eval(xmlrequest.responseText);
				
				for(var i=0;i<datas.length;i++){
					datas[i].kind="动态";
				}
				subjectList(datas,$("myrpt"));
			}
		});
		ajax.request();
	}
	custRpt();
	
}

function subjectList(datas,container){
	container.innerHTML="";
	var _ul=$C("ul");
	_ul.style.cssText="list-style:none;margin:0px;padding:0px;width:95%;font-size: 1em;font-weight: bold;"
	for(var i=0; i< datas.length;i++){
		var _li=$C("li");
		
		var _a = $C("a");
		_a.href="javascript:void(0)";
		_a.id= datas[i].id;
		_a.text=datas[i].name;
		var kind=datas[i].kind;
		if(kind=="配置"){
			_a.uri="../report/"+datas[i].id;
		}else if (kind=="动态"){
			_a.uri=aihb.URL+"/hb-bass-navigation/hbirs/action/dynamicrpt?method=render&sid="+datas[i].id+"&"+_params._oriUri;
		}
		
		_a.onclick=function(){
			tabAdd({id:this.id,title:this.text,url:this.uri});
		}
		_a.appendChild($CT(datas[i].label||datas[i].name));
		
		_li.style.cssText="border-bottom:1px solid #ccc;line-height:30px;";
		
		
		var _span=$C("span");
		_span.className="ui-icon ui-icon-triangle-1-e"
		_span.style.cssText="position: relative;top:7px;float:left;";
		_span.onmouseover=function(){this.className="ui-widget-content ui-icon ui-icon-triangle-1-e";}
		_span.onmouseout=function(){this.className="ui-icon ui-icon-triangle-1-e"}
		
		_li.appendChild(_span);
		_li.appendChild(_a);
		
		_ul.appendChild(_li);
		
	}
	container.appendChild(_ul);
}

aihb.Grid.prototype.getPaging=function(){
	return undefined;
}
/**
 * 点击排行
 * @return
 */
function pv(){
	jQuery("#pv").tabs({
		event: "mouseover"
	});
	
	function renderPvRank(sql,el){
		var ajax = new aihb.Ajax({
			url : "/hb-bass-navigation/hbirs/action/jsondata?method=query&isLog=false"
			,parameters : "sql="+encodeURIComponent(sql)+ "&ds=web"	
			,callback : function(xmlrequest){
				var datas = eval(xmlrequest.responseText);		
				try{
					eval("datas="+xmlrequest.responseText);
				}catch(e){debugger;}
				//debugger;
				var _elObj=$(el);
				_elObj.innerHTML="";
				var _ul=$C("ul");
				_ul.style.cssText="list-style:none;margin:0px;padding:0px;width:95%;font-size: 1em;"
				for(var i=0; i< datas.length;i++){
					var _li=$C("li");
					
					_li.style.cssText="z-index:2px;border-bottom:1px solid #ccc;line-height:28px;padding-left:5px;display:block;position: relative;float:left;width:99%;color:#366388;font-weight:700;";
					
					var imgOffset="-30";
					
					if(i<3){
						imgOffset="0";
					}
					
					var _span=$C("span");
					_span.style.cssText="position: relative;float:left;top:7px;height:13px;width:20px;color:#fff;background: url('../resources/image/default/bass_icon.gif') 0 "+imgOffset+"px no-repeat;"
					_li.appendChild(_span);
					
					var _text=$C("span");
					_text.style.cssText="font-size:11px;position: relative;top:-10px;float:top;left:2px;"
					_text.appendChild($CT((i<9?"0":"")+(i+1)));
					
					_span.appendChild(_text);
					
					_span=$C("span");
					_span.style.cssText="position: relative;left:8px;float:left;"
					_span.appendChild($CT(datas[i].name));
					_li.appendChild(_span);
					
					_span=$C("span");
					_span.style.cssText="position: relative;float:right;"
					_span.appendChild($CT(datas[i].cnt+" 次 "));
					_li.appendChild(_span);
					
					_ul.appendChild(_li);
					
				}
				_elObj.appendChild(_ul);
				
			}
		});
		ajax.request();
	}
	
	var sql1=" select name,sum(cnt) cnt from ("
		+" select value((select area_name from mk.bt_area d where d.area_id=t.area_id),'省公司') name,count(*) cnt   "
		+" from FPF_VISITLIST t inner join FPF_USER_GROUP_MAP a1 on t.loginname=a1.userid where replace(substr(char(create_dt),1,7),'-','')=replace(substr(char(current_date),1,7),'-','')"
		+" and a1.group_id<>'26020' and (track !='' or opername!='' or OPERTYPE!='')"
		+" group by area_id "
		+" union all"
		+" SELECT value((select area_name from mk.bt_area d where d.area_code=B.AREAID),'省公司') name ,COUNT(A.USENAME) cnt"
		+" FROM MD.LOG_INFO A, MD.LDCUSER B "
		+" WHERE B.USERNAME =A.USENAME AND substr(char(DATE(A.LOG_DATE)),1,7) = substr(char(current date),1,7) and usename not in ('sys','admin')"
		+" GROUP BY B.AREAID"
		+" ) t "
		+" group by name order by 2 desc with ur";
	
	renderPvRank(sql1,"pv_city")
	
	var sql2=" select county_name name,count(*) cnt   "
		+" from (select usename loginname,DATE(LOG_DATE) date from  MD.LOG_INFO"
		+" union all"
		+" select loginname,date(create_dt) date from FPF_VISITLIST inner join FPF_USER_GROUP_MAP on loginname=userid where (track !='' or opername!='' or OPERTYPE!='')) t,FPF_USER_USER u, mk.bt_area_all d where replace(substr(char(date),1,7),'-','')=replace(substr(char(current_date),1,7),'-','')"
		+" and group_id<>'26020' "
		+" and t.LOGINNAME=u.userid and  d.county_id=departmentid"
		+" group by county_name order by count(*) desc fetch first 10 rows only with ur";
	
	renderPvRank(sql2,"pv_county");
	
	var sql3=" select username||'『'||value((select area_name from mk.bt_area d where d.area_id=int(cityid)),'省公司')||'』' name,count(*)  cnt"
		+" from (select usename loginname,DATE(LOG_DATE) date from  MD.LOG_INFO"
		+" union all"
		+" select loginname,date(create_dt) date from FPF_VISITLIST inner join FPF_USER_GROUP_MAP on loginname=userid where (track !='' or opername!='' or OPERTYPE!='')) t,FPF_USER_USER u where replace(substr(char(date),1,7),'-','')=replace(substr(char(current_date),1,7),'-','')"
		+" and group_id<>'26020'"
		+" and t.LOGINNAME=u.userid"
		+" group by username,int(cityid) order by count(*) desc fetch first 10 rows only with ur";
	
	renderPvRank(sql3,"pv_user");
	
	/*
	var _col="case when posstr(track,'-')>0 then substr(track,1,posstr(track,'-')-1) else '运营管理监控' end";
	var _condi="";
	*/
	var _col="substr(track,1,posstr(track,'-')-1)";
	var _condi="and posstr(track,'-')>0";
	
	var sql4=" select name,cnt from ("
		+" select "+_col+" name,count(*) cnt"
		+" from FPF_VISITLIST inner join FPF_USER_GROUP_MAP on loginname=userid where substr(char(date(create_dt)),1,7) = substr(char(current date),1,7)"
		+" and group_id<>'26020' and (track !='' or opername!='' or OPERTYPE!='')"
		+ _condi
		+" and area_id is not null group by "+_col
		+" union all"
		+" select '地市集市' name,count(*) cnt FROM MD.LOG_INFO where usename not in ('sys','admin') and substr(char(DATE(LOG_DATE)),1,7) = substr(char(current date),1,7)"
		+" ) t order by 2 desc fetch first 10 rows only with ur";
	
	renderPvRank(sql4,"pv_cata");
}

function navigation(){
	var t=n=count=0;
	count = jQuery("#play_list a").size();
	jQuery("#play_list a:not(:first-child)").hide();
	
	jQuery("#play_text li:first-child").css({"background":"#fff",'color':'#000'});
	jQuery("#play_text li").click(function() {
		var i = jQuery(this).text() - 1;
		n = i;
		if (i >= count) return;
		jQuery("#play_list a").filter(":visible").fadeOut(500).parent().children().eq(i).fadeIn(500);
		jQuery(this).css({"background":"#fff",'color':'#000'}).siblings().css({"background":"#999",'color':'#fff'});
	});
	
	function showAuto(){
		n = n >= (count - 1) ? 0 : n + 1;
		jQuery("#play_text li").eq(n).trigger('click');
	}
	
	t = setInterval(function(){showAuto()}, 3000);
	jQuery("#play").hover(
		function(){
			clearInterval(t)
		}
		,function(){
			t = setInterval(function(){
					showAuto()
				}, 3000);
		}
	);
}

function weekVisit(){
	var sql = "select name,count(*) cnt from FPF_VISITLIST a,fpf_irs_subject b where opername = char(int(id)) and a.create_dt > current_timestamp - 7 days group by name order by count(*) desc fetch first 5 rows only with ur ";
	var _ajax = new aihb.Ajax({
		url: "/hbirs/action/jsondata?method=query"+"&"+_params._oriUri
		,parameters : "sql="+encodeURIComponent(sql)+"&ds=web"
		,callback:function(xhr){
			var data=null;
			try{
				eval("data="+xhr.responseText);
			}catch(e){debugger;}
			
			var chart = new FusionCharts("/hbapp/resources/chart/Charts/FCF_Bar2D.swf", "Chart", "330", "170");
			var xmlStr=aihb.FusionChartHelper.chartNormal(aihb.FusionChartHelper.dataTransfer(data,["name","cnt"]),{showNames:"0",showValues:"1",ignoreMinMax:true});
			
			chart.setDataXML(xmlStr);
			chart.addParam("wmode","transparent");
			chart.render("week");
		}
	});
	_ajax.request();
}