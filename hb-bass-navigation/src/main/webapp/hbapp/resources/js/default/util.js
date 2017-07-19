/*
	author  :	higherzl
	edition :	v0.1
	date    :	2010-07-14
	dependency: default.js (means you should include default.js before this one)
*/
/* tooltip show ; length : the min length of the strings that would become tooltips */
function trimShow(length) {
	return function (crtVal,options) {
		if(!crtVal)return ""; //返回空字符串就是一种处理,如果return ;，页面上就是undefined
		var span = $C("span") ;
		crtVal = crtVal.trim();
		;
		if(crtVal.length > length) {
			span.appendChild($CT(crtVal.substr(0,length) + "..."));
			span.onmouseover=function() {tooltip.show(crtVal);}
			span.onmouseout=tooltip.hide;
			return span;
		} else {
			span.appendChild($CT(crtVal)); //不加不行
		}
		return span;
	}
}

/* function : crate jquery's accordion 
	config : {
		renderTo : "someId"
		catalogs , [
			{
				cataInfo : {catalogName : "",href : "不指定,默认是#", } 
				,cataData : is the structure of createTblOptions() function's param  ...
			}
		]
	}
 */
function createQueryOptions(config) {
	var accordion = $C("div"); //jquery 指定
	accordion.style.margin = "5px";
	accordion.id = "accordion";
	for(var prop in config.catalogs) {
		if(config.catalogs.hasOwnProperty(prop)) {
			var crtCl = config.catalogs[prop];
			var h3 = $C("h3"); //jquery 指定
			var _link = $C("a"); //jquery 指定
			_link.href = crtCl.cataInfo.href || "#";
			_link.appendChild($CT(crtCl.cataInfo.catalogName));
			h3.appendChild(_link);
			accordion.appendChild(h3);
		
			var _contentDiv = $C("div");  //jquery 指定
			_contentDiv.appendChild(createTblOptions(crtCl.cataData));
			accordion.appendChild(_contentDiv);
		}
	}
	$(config.renderTo).appendChild(accordion);
	$(config.renderTo).innerHTML += '<table align="center" width="99%">' + 
	'<tr class="dim_row_submit">' + 
		'<td align="right" bgcolor="">'  +
		'<input type="button" class="form_button" value="查询" onClick="query()">&nbsp;' +
		'<input type="button" class="form_button" value="下载" onclick="down()">&nbsp;' +
	'</td></tr></table>'; // 查询下载的table ,这也是我觉得写死的地方
}

/*
config : {
	labelsPerRow : 3
	,data : [{label : "someText", elements :[{}or "" or obj]]
	,tableProps : {
		align : "center"
		className : 
		name : 
		id : ...
	}
	,rowClass : ""
	,labelClass : ""
	,felClass : ""
}
*/
function createTblOptions(config) {
	if(!config.tableProps)
		config.tableProps = {align : 'center',width : '99%',className : 'grid-tab-blue',cellspacing : '1',cellpadding : '0',border : '0'} //使用默认
	//新添加form ,为了兼容之前代码，此处如果不提供fmProps则不会自动添加 
	var fm ,table;
	if(config.fmProps) {
		fm = $C("form");
		for(prop in config.fmProps) {
			fm[prop] = config.fmProps[prop];
		}
	}
	
	table = $C("table");
	if(fm)
		fm.appendChild(table);
	
	//table.align="center" ;table.width='99%' ;table.className='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'
	for(var prop in config.tableProps) {
		if(prop == "cssText")
			table.style.cssText = config.tableProps[prop]; //加入cssText成为可能
		else
			table[prop] = config.tableProps[prop]; //copy properties
	}
	var labelsPerRow = config.labelsPerRow || 3;
	var labelLength = config.data.length;
	for(var _rowIndex = 0 ; _rowIndex < labelLength/labelsPerRow ; _rowIndex ++) {
		var _row = table.insertRow();
		_row.className = config.rowClass || "dim_row";
		for(var _cellIndex = 0 ; _cellIndex < labelsPerRow ; _cellIndex ++) {
			////debugger;
			var crtIndx = _rowIndex * labelsPerRow + _cellIndex;
			var crtElement = config.data[crtIndx] || {};
			var _cell = _row.insertCell();
			//debugger;
			_cell.className = config.labelClass || "dim_cell_title";
			_cell.appendChild($CT(crtElement.label || ""));
			
			_cell = _row.insertCell();
			_cell.className = config.felClass || "dim_cell_content";
			
			if(crtElement.elements) {
				if(Object.prototype.toString.apply(crtElement.elements) !== '[object Array]') //目前判断是否是对象或者数组的比较简单有效的方法,如果是数组,则是[object Array],但需要注意undefined也是对象!
					bi.copyToForm(_cell, crtElement.elements);
				else {
					for(var prop in crtElement.elements) {
						if(crtElement.elements.hasOwnProperty(prop)) {
							bi.copyToForm(_cell, crtElement.elements[prop]);
						}
					}
				}
			}
		}
	}
	return fm || table;
}
		
void function(w,d,undefined) {
	var bi = {},ui = {},util = {};
	//expose vars 
	w.bi = bi;w.biutil = util;w.BIUI = ui;
	bi.copyToForm = function (_cell, crtEl) {
		if(typeof crtEl === "string") // e.g: "<input type='button' value='someVal'>"
			_cell.innerHTML += crtEl; //_cell.appendChild($C(crtEl)); //使用innerHTML方式可以添加"<input>"这样的字符串
		else if("form" === crtEl.elType) 
			_cell.appendChild(crtEl); //eg : var crtEl = $C("input"); crtEl.elType = "form"; crtEl.style.width="30px" ; 
		else {
			//common one
			var fmEl = $C(crtEl.formType || "input"); //eg: {formType : "textarea", name : "someName" } or {type : "text", name "someName"}
			for(var prop in crtEl) {
				fmEl.setAttribute(prop,crtEl[prop]); // 双保险!
				fmEl[prop] = crtEl[prop]; // IE对这种方式支持的更好,但无论如何都不能赋name onclick等
			}
			_cell.appendChild(fmEl);
		}
	}
	
	bi.genSQLConditions = function (form) {
		var pt = "a";
		var st = "b";
		var condition = "";
		var form = form || document.forms[0];
		var elements = form.elements;
		for(var i = 0 ; i < elements.length ; i++) {
			var crtEl = elements[i];
			if(crtEl.condi && crtEl.value && crtEl.value != 0) { // 这个判断条件非常重要
				////debugger;
				var condi = crtEl.condi;
				if(condi.match(/^\sand/)) {
				//终于实现了
					if(!condi.match(/@e/)) { //简单表达式
						//简单表达式,值在本dom对象中,直接替换
						if(crtEl.type == "checkbox" || crtEl.type == "radio") {
							if(!crtEl.checked)
								continue;
						}
						condition += condi.replace("@val",crtEl.value).replace("@pt",pt).replace("@st",st);
					} else {
						////debugger;
						//如"<input type='hidden' condi=\" and @pt.someCol in ('@val')@erange=samelevel@etype=checkbox@erule=checked\" />"
						condi.match(/@erange=(\w+)/);
						var erange = RegExp.$1 || "samelevel"; //一级筛选，范围
						condi.match(/@etype=(\w+)/);
						var etype = RegExp.$1 || "checkbox"; //二级筛选, 类型
						condi.match(/@erule=([\w_&\d=']+)/);
						var erule = RegExp.$1 || "checked"; //三级筛选,
						//alert(erule);
						var objs = [];
						if("samelevel" == erange ) {
							var nodes = crtEl.parentNode.childNodes;
							for(var prop in nodes) {
								if(etype == nodes[prop].type) {
									var erules = erule.split("&");
									var  rightOne = true;
									for(var k = 0 ; k < erules.length ; k++) {
										if(!eval("nodes[prop]." + erules[k])) 
											rightOne = false;	
									}
									if(rightOne)
										objs.push(nodes[prop]);
								}
							}
						}
						if(objs.length == 0)
							continue;
						//赋值
						for(var j = 0 ; j < objs.length ; j++) {
							objs[j] = objs[j].value; //替换数组,(重用数组)
						}
						if(condi.match(/'@val'/))
							condition += condi.replace("@pt",pt).replace("@st",st).replace("@val",objs.join("','")).replace(/@e[\w\W]+$/,"");
						else
							condition += condi.replace("@pt",pt).replace("@st",st).replace("@val",objs.toString()).replace(/@e[\w\W]+$/,"");
					}
					
				} else if(typeof condi == "function") {
					//debugger;
					//目前自定义方法不行
				} else if(condi ==("@value")) { //直接拿到value的情况,目前没用到,因为这种情况简单表达式可以解决
					condition += crtEl.value ;
				}
				
			} else continue;
				
		}
		return condition;
	}
	/* 在不改动柯夫代码的前提下增加condi功能 */
	util.genArea = function(name, defaultValue, onChange,condi){
		var str = aihb.BassDimHelper.areaCodeHtml(name, defaultValue, onChange); 
		if(condi) 
			return str.replace(/(<select)\s+/,"$1 " + condi+ " ");
		return str;
	}
	
	
	/* 右下脚弹出窗口开始  */
	// 
	function Popup() {
		var divTop,divLeft,divWidth,divHeight,docHeight,docWidth,objTimer,i = 0;
		var self = this;
		var ids = {
			pop_tomin : "pop_tomin"
			,pop_close1 : "pop_close1"
			,pop_tomax : "pop_tomax"
			,pop_close2 : "pop_close2"
			,noticeDiv : "noticeDiv"
		};
		var innerhtml = '<DIV id="loft_win" style="Z-INDEX:99999; LEFT: 0px; VISIBILITY: hidden;WIDTH: 250px; POSITION: absolute; TOP: 0px; HEIGHT: 150px;">' + 
		'<TABLE cellSpacing=0 cellPadding=0 width="100%" bgcolor="#FFFFFF" border=0>' + 
			'<TR>' + 
				'<td width="100%" valign="top" align="center">' + 
					'<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">' + 
						'<tr>' + 
							'<td width="120" class="loft_win_head">湖北经分温馨提示</td>' + 
							'<td width="26" class="loft_win_head"> </td>' + 
							'<td align="right" class="loft_win_head">' + 
								'<span id="' + ids.pop_tomin + '" style="CURSOR: pointer;font-size:12px;font-weight:bold;margin-right:4px;" title=最小化>- </span><span id="' + ids.pop_close1 + '" style="CURSOR: pointer;font-size:12px;font-weight:bold;margin-right:4px;" title=关闭>×</span>' + 
							'</td>' + 
						'</tr>' + 
					'</table>' + 
				'</td>' + 
			'</TR>' + 
			'<TR>' + 
				'<TD height="130" align="center" valign="middle" colSpan=3>' + 
					'<div id="contentDiv">' + 
						'<table width="100%" height="100%" cellpadding="0" cellspacing="0">' + 
							'<tr>' + 
								'<td align="center" height="100%">' + 
									'<div id="' + ids.noticeDiv + '">' + 
									'</div>' + 
								'</td>' + 
							'</tr>' + 
						'</table>' + 
					'</div>' + 
				'</TD>' + 
			'</TR>' + 
		'</TABLE>' + 
	'</DIV>' + 
	'<DIV id="loft_win_min" style="Z-INDEX:99999; LEFT: 0px; VISIBILITY: hidden;WIDTH: 250px; POSITION: absolute; TOP: 0px;">' + 
		'<TABLE cellSpacing=0 cellPadding=0 width="100%" bgcolor="#FFFFFF" border=0>' + 
			'<TR>' + 
				'<td width="100%" valign="top" align="center">' + 
					'<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">' + 
						'<tr>' + 
							'<td width="120" class="loft_win_head">湖北经分温馨提示</td>' + 
							'<td width="26" class="loft_win_head"> </td>' + 
							'<td align="right" class="loft_win_head">' + 
								'<span title="还原" id="' + ids.pop_tomax + '"  style="CURSOR: pointer;font-size:12px;font-weight:bold;margin-right:4px;">□</span><span id="' + ids.pop_close2 + '" title=关闭 style="CURSOR: pointer;font-size:12px;font-weight:bold;margin-right:4px;">×</span>' + 
							'</td>' + 
						'</tr>' + 
					'</table>' + 
				'</td>' + 
			'</TR>' + 
		'</TABLE>' + 
	'</DIV>';

		self.init = function(panel) {
			window.onresize = self.resizeDiv;
			window.onerror = function(){};
			var outterDiv = document.createElement("div");
			outterDiv.innerHTML = innerhtml;
			document.body.appendChild(outterDiv);
			//register handlers
			document.getElementById(ids.pop_tomin).onclick = self.minDiv;
			document.getElementById(ids.pop_close1).onclick = self.closeDiv;
			document.getElementById(ids.pop_tomax).onclick = self.maxDiv;
			document.getElementById(ids.pop_close2).onclick = self.closeDiv;
			document.getElementById(ids.noticeDiv).appendChild(panel);
		} ;
		self.showNotice = function() {
			try {
				divTop = parseInt(document.getElementById("loft_win").style.top,10);
				divLeft = parseInt(document.getElementById("loft_win").style.left,10);
				divHeight = parseInt(document.getElementById("loft_win").offsetHeight,10);
				divWidth = parseInt(document.getElementById("loft_win").offsetWidth,10);
				docWidth = document.body.clientWidth;
				docHeight = document.body.clientHeight;
				document.getElementById("loft_win").style.top = parseInt(document.body.scrollTop,10) + docHeight + 10;// divHeight
				document.getElementById("loft_win").style.left = parseInt(document.body.scrollLeft,10) + docWidth - divWidth;
				document.getElementById("loft_win").style.visibility="visible";
				objTimer = window.setInterval(self.moveDiv,10);
			}
			catch(e){debugger;}
		} ;
		//初始化位置
		self.resizeDiv = function() {
			i+=1;
			//if(i>300) closeDiv() //想不用自动消失由用户来自己关闭所以屏蔽这句
			try
			{
				divHeight = parseInt(document.getElementById("loft_win").offsetHeight,10);
				divWidth = parseInt(document.getElementById("loft_win").offsetWidth,10);
				docWidth = document.body.clientWidth;
				docHeight = document.body.clientHeight;
				document.getElementById("loft_win").style.top = docHeight - divHeight + parseInt(document.body.scrollTop,10);
				document.getElementById("loft_win").style.left = docWidth - divWidth + parseInt(document.body.scrollLeft,10);
			}
			catch(e){debugger;}
		};
		//最小化
		self.minsizeDiv = function () {
			i+=1
			//if(i>300) closeDiv() //想不用自动消失由用户来自己关闭所以屏蔽这句
			try
			{
				divHeight = parseInt(document.getElementById("loft_win_min").offsetHeight,10);
				divWidth = parseInt(document.getElementById("loft_win_min").offsetWidth,10);
				docWidth = document.body.clientWidth;
				docHeight = document.body.clientHeight;
				document.getElementById("loft_win_min").style.top = docHeight - divHeight + parseInt(document.body.scrollTop,10);
				document.getElementById("loft_win_min").style.left = docWidth - divWidth + parseInt(document.body.scrollLeft,10);
			}
			catch(e){debugger;}
		}
		
		//移动
		self.moveDiv = function () {
			try
			{
				if(parseInt(document.getElementById("loft_win").style.top,10) <= (docHeight - divHeight + parseInt(document.body.scrollTop,10)))
				{
					window.clearInterval(objTimer);
					objTimer = window.setInterval(self.resizeDiv,1);
				}
				divTop = parseInt(document.getElementById("loft_win").style.top,10);
				document.getElementById("loft_win").style.top = divTop -1;
			}
				catch(e){debugger;}
		}
		
		self.minDiv = function(){
			self.closeDiv();
			document.getElementById('loft_win_min').style.visibility='visible';
			objTimer = window.setInterval(self.minsizeDiv,1);
		}
		
		self.maxDiv = function () {
			document.getElementById('loft_win_min').style.visibility='hidden';
			document.getElementById('loft_win').style.visibility='visible';
			objTimer = window.setInterval(self.resizeDiv,1);
			//resizeDiv()
			self.showNotice();
		}
		
		self.closeDiv = function () {
			document.getElementById('loft_win').style.visibility='hidden';
			document.getElementById('loft_win_min').style.visibility='hidden';
			if(objTimer) window.clearInterval(objTimer);
		}
	}
	/* popup done */
	ui.Popup = Popup;
	
}(window,document)