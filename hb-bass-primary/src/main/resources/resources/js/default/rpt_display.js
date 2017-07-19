(function($,window){
function naviTree(_table,datas){
	_table.empty();
	
	var _head=$("<thead/>");
	var _tr = $("<tr/>",{"class":"grid_title_blue",height:26});
	_table.append(_head);
	_head.append(_tr);
	
	var _td1 = $("<td/>",{width:"50","class":"grid_title_cell",text:"序号"});
	var _td2 = $("<td/>",{width:"250","class":"grid_title_cell",text:"报表名称"});
	var _td3 = $("<td/>",{"class":"grid_title_cell",text:"报表描述"});
	var _td4 = $("<td/>",{width:"60","class":"grid_title_cell",text:"访问情况"});
	_tr.append(_td1).append(_td2).append(_td3).append(_td4);
	
	function genCell(options){
		var aData=options.row;
		var _tbody=options.container;
		_tr = $("<tr/>",{"class":"grid_row_alt_blue",height:26});
		_td1 = $("<td/>",{"class":"grid_row_cell"});
		_td2 = $("<td/>",{"class":"grid_row_cell_text"});
		_td3 = $("<td/>",{"class":"grid_row_cell_text",text:(aData.desc||"")});
		
		if(options.seq){//是直接挂在根目录下面的
			_td1.text(options.seq);
		}else{//不是直接挂在根目录下面的
			var _img=$("<img/>",{height:18,width:18,src:aihb.contextPath+"/resources/image/default/"+(options.isBottom?"joinbottom.gif":"join.gif")});
			_td2.append(_img);
			//_td2.append($CT("  "));
		}
		
		var _a = $("<a/>",{
			href:"javascript:void(0)"
			,kind:(aData.kind || aData.type) //为type的是package
			,sid : aData.id
			,text : aData.name
			,click : function(){
				var _strUri="";
				if($(this).attr("kind")=="手工"){
					_strUri=this.uri;
				}else if($(this).attr("kind")=="动态"){
					//_strUri="/hbirs/action/dynamicrpt?method=render&sid="+this.sid;
					_strUri="http://10.25.124.110:8080/pst/kpi/report/"+aData.id;
				}else if($(this).attr("kind")=="配置"){		
					if(aData.id==9581){
						_strUri="/mvc/menu/98090792";
					}else if(aData.id==9579){
						_strUri="/mvc/menu/98090786";
					}else if(aData.id==9582){
						_strUri="/mvc/menu/98090793";
					}else if(aData.id==9578){
						_strUri="/mvc/menu/98090785";
					}else if(aData.id==9580){
						_strUri="/mvc/menu/98090787";	
					}else{
						_strUri="/hb-bass-navigation/report/"+aData.id;
					}
				}
				tabAdd({title:this.innerText,url:_strUri, id:aData.id});
			}
		});
		
		if(aData.kind=="手工"){
			_a.attr("uri",aData.uri);
		}
		
		_td2.append(_a);
		
		_tr.append(_td1).append(_td2).append(_td3);
		
		_td4 = $("<td/>",{id:"td_"+aData.id,"class":"grid_row_cell"});
		_tr.append(_td4);
		
		var _hiddenDiv=$("<div/>",{id:"hd_"+aData.id,"class":"selectarea"}).css("display","none");
		
		var _text=$("<span/>",{id:"te_"+aData.id,text:"0"});
		_td4.append(_text);
		_td3.append(_hiddenDiv);
		_tbody.append(_tr);
	}
	
	var _tbody = $("<tbody/>");
	for(var i=0; datas && i< datas.length;i++){
		if(datas[i].subjects){
			var _span=$("<span/>",{id:"list"+i});
			var packageObj=$("<td/>",{"class":"grid_row_cell_text",colSpan:2});
			
			var _icon = $("<img/>",{
				src : aihb.contextPath+"/resources/image/default/row-collapse.gif"
				,click: function(){
					var _this=this;
					$("#"+$(_this).attr("cid")).children("tr").slideToggle(100);
				}
				,cid:"list"+i
				}).toggle(
					function(){
						$(this).attr("src",aihb.contextPath+"/resources/image/default/row-expand.gif")
					}
					,function(){
						$(this).attr("src",aihb.contextPath+"/resources/image/default/row-collapse.gif")
					}
					
				).css("cursor","hand");
			
			packageObj.append(_icon).append($("<span/>",{text:" "+datas[i].name}).css("fontWeight","bold"));
			
			var _cSbjs=datas[i].subjects;
			
			for(var j=0;j<_cSbjs.length;j++){
				genCell({row : _cSbjs[j],container : _span, isBottom : (j+1==_cSbjs.length)});
			}
			var packageDown=$("<td/>",{"class":"grid_row_cell_text",align:"center"});
			if(datas[i].type=="下拉框"){
//				packageDown.append(
//					$("<img/>",{src:aihb.contextPath+"/resources/image/default/zip_icon.png",title:"整套报表打包下载",mid:datas[i].id,style:"cursor:hand"})
//					.click(function(){
////						alert("请留意浏览器状态栏下载进度，勿重复点击下载按钮");
//						aihb.AjaxHelper.down({
//							url : aihb.contextPath+"/rptNavi/"+$(this).attr("mid")+"/down"
//						});
//					})
//				);
				_span.children("tr").hide();
				_icon.click();
			}
			var _tr=$("<tr/>",{"class":"grid_row_alt_blue",height:26})
				.append( $("<td/>",{"class":"grid_row_cell",text:(i+1)}).css("fontWeight","bold") )
				.append(packageObj)
				.append(packageDown);
			_tbody.append(_tr);
			_tbody.append(_span);
			_span.children("tr").hide();
		}else{
			genCell({row : datas[i],container : _tbody,seq : (i+1)});
		}
	}
	
	_table.append(_tbody);
}

function naviTreeForTerminal(_table,datas){
	_table.empty();
	
	var _head=$("<thead/>");
	var _tr = $("<tr/>",{height:26});
	_table.append(_head);
	_head.append(_tr);
	
	var _td2 = $("<td/>",{width:"250","class":"grid_title_cell",text:"报表名称"});
	_tr.append(_td2);
	
	function genCell(options){
		var aData=options.row;
		var _tbody=options.container;
		_tr = $("<tr/>",{height:26});
		_td2 = $("<td/>",{"class":"grid_row_cell_text"});
		
		
		var _img=$("<img/>",{height:18,width:18,src:aihb.contextPath+"/resources/image/default/"+(options.isBottom?"joinbottom.gif":"join.gif")});
		_td2.append(_img);

		
		var _a = $("<a/>",{
			href:"javascript:void(0)"
			,kind:(aData.type) //为type的是package
			,sid : aData.id
			,text : aData.name
			,click : function(){
				var _strUri="";
				if($(this).attr("kind")=="url"){
					_strUri=this.sid;
				}else if($(this).attr("kind")=="report"){
					_strUri=aihb.contextPath+"/report/"+this.sid;
				}
				var url = _strUri;
				jQuery("#show2 >iframe").attr("src",url);
				jQuery("#show1").hide();
				jQuery("#show2").show();
				jQuery("#apDiv888").show();
				
			}
		});
		
		if(aData.kind=="手工"){
			_a.attr("uri",aData.uri);
		}
		
		_td2.append(_a);
		
		_tr.append(_td2);
		_tbody.append(_tr);
	}
	
	var _tbody = $("<tbody/>");
	for(var i=0; datas && i< datas.length;i++){
		if(datas[i].subjects){
			var _span=$("<span/>",{id:"list"+i});
			var packageObj=$("<td/>",{"class":"grid_row_cell_text",colSpan:1});
			
			var _icon = $("<img/>",{
				src : aihb.contextPath+"/resources/image/default/row-collapse.gif"
				,click: function(){
					var _this=this;
					$("#"+$(_this).attr("cid")).children("tr").slideToggle(100);
				}
				,cid:"list"+i
				}).toggle(
					function(){
						$(this).attr("src",aihb.contextPath+"/resources/image/default/row-expand.gif")
					}
					,function(){
						$(this).attr("src",aihb.contextPath+"/resources/image/default/row-collapse.gif")
					}
					
				).css("cursor","hand");
			
			packageObj.append(_icon).append($("<span/>",{text:" "+datas[i].name}).css("fontWeight","bold"));
			
			var _cSbjs=datas[i].subjects;
			
			for(var j=0;j<_cSbjs.length;j++){
				genCell({row : _cSbjs[j],container : _span, isBottom : (j+1==_cSbjs.length)});
			}
			if(datas[i].type=="下拉框"){
				_span.children("tr").hide();
				_icon.click();
			}
			var _tr=$("<tr/>",{height:26})
				.append(packageObj);
			_tbody.append(_tr);
			_tbody.append(_span);
			_span.children("tr").hide();
		}
	}
	
	_table.append(_tbody);
}


function naviFlat(table,datas){
	table.empty();
	
	var tbody=$("<tbody/>");
	var trHead=$("<tr/>");
	var trBody=$("<tr/>");
	
	var COLOR=["#B32017","#F1CC01","#019FC4","#94AA2E","#A7415F"];
	
	table.append(tbody);
	tbody.append(trHead).append(trBody);
	
	for(var i=0; datas && i< datas.length;i++){
		if(datas[i].subjects){//没子报表的不能用
			var td=$("<td/>",{
				align:"center"
				,text: datas[i].name
				,style:"background:"+COLOR[i%5]+";color:#fff;height:30px;font-size:14px;width:200px"}
			);
			trHead.append(td);
			
			var subs=datas[i].subjects;
			td=$("<td/>",{vAlign:"top"});
			
			for(var j=0;j<subs.length;j++){
				
				var div=$("<div/>",{text:subs[j].name
					,title:subs[j].desc
					,kind : (subs[j].kind || subs[j].type)
					,sid : subs[j].id
					,click : function(){
						var _strUri="";
						if($(this).attr("kind")=="手工"){
							_strUri=this.uri;
						}else if($(this).attr("kind")=="动态"){
							_strUri="/hbirs/action/dynamicrpt?method=render&sid="+$(this).attr("id");
						}else if($(this).attr("kind")=="配置"){
							_strUri=aihb.contextPath+"/report/"+$(this).attr("id");
						}
						var rid = $(this).attr("id");
						tabAdd({title:this.innerText,url:_strUri, id: rid});
					}
					,mouseover : function(){
						$(this).css("color","red");
					}
					,mouseout : function(){
						$(this).css("color","");
					}
				}).css("cursor","hand");
				
				if(subs[j].kind=="手工"){
					div.uri=subs[j].uri;
				}
				
				td.append(div);
			}
			trBody.append(td);
		}
	}
}
window.naviTree=naviTree;
window.naviFlat=naviFlat;
window.naviTreeForTerminal=naviTreeForTerminal;
})(jQuery,window);