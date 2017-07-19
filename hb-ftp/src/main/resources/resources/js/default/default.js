/*  
 * ReportMeta使用的js
 * @author Mei Kefu
 */
/*----------------------------------  基础方法  ----------------------------------------*/
var $ = function(_id){return document.getElementById(_id);}
var $C = function(_tag){return document.createElement(_tag);}
var $CT = function(_text){return document.createTextNode(_text);}
String.prototype.trim = function(value,icase){return this.replace(/(^\s+)|(\s+$)/g,"");}
Array.prototype.indexOf = function(value){for(var i=0,l=this.length;i<l;i++)if(this[i]==value)return i;return -1;}
Array.prototype.Remove = function(value){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){return this.splice(i,1);}}
Array.prototype.Replace = function(value,source){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){this[i]=source;break;}}
Array.prototype.ReplaceAll = function(value,source){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){this[i]=source;}}
Array.prototype.Clear = function(){this.splice(0,this.length);}
Date.prototype.format = function (fs) {
	if (fs==undefined) {
		fs="yyyyMMdd";
	}
	var _month = (this.getMonth() + 1);
	if(_month<10)_month="0"+_month;
	var _date = this.getDate();
	if(_date<10)_date="0"+_date;
	
	var _hour = this.getHours();
	if(_hour<10)_hour="0"+_hour;
	
	var _mi=this.getMinutes();
	if(_mi<10)_mi="0"+_mi;
	
	var _ss=this.getSeconds();
	if(_ss<10)_ss="0"+_ss;
	
	
	fs = fs.replace("yyyy", this.getFullYear());
	fs = fs.replace(/mm/i, _month);
	fs = fs.replace("dd", _date);
	fs = fs.replace("hh", _hour);
	fs = fs.replace("mi", _mi);
	fs = fs.replace("ss", _ss);
	return fs;
};

if(typeof asiainfo == "undefined") var asiainfo = {};
if(typeof asiainfo.hbbass == "undefined") asiainfo.hbbass = {};
var aihb = asiainfo.hbbass;
aihb.URL="";
aihb.contextPath="/mvc";
/*----------------------------------  Ajax包转  ----------------------------------------*/
if(typeof aihb.Ajax == "undefined") aihb.Ajax = {};
aihb.Ajax = function() {this.initialize.apply(this,arguments);}

aihb.Ajax.prototype = {

	initialize : function (options) {
		this.options = {
			method : "post"
			,url : ""
			,parameters : ""
			,asynchronous : true
			,callback : function(xmlrequest){}
			,loadmask : false
			//,contentType:"application/x-www-form-urlencoded"
			//,encoding:"UTF-8"
		};
		for (var key in options || {}) {
			this.options[key] = options[key];
		}
		if (typeof this.options.parameters != "string") {
			var _parameters = "";
			for (var key in this.options.parameters || {}) {
				_parameters += "&" + key + "=" + encodeURIComponent(this.options.parameters[key]);
			}
			this.options.parameters = _parameters;
		}
		
		this.xmlrequest= this.create();
	},
	
	create : function() {
		var xmlrequest = false;
		if (window.ActiveXObject) {
			try {xmlrequest = new ActiveXObject("Msxml2.XMLHTTP");}
			catch (e) {
				try {xmlrequest = new ActiveXObject("Microsoft.XMLHTTP");}
				catch (e) {debugger;}
			}
		} else {xmlrequest = new XMLHttpRequest();}
		return xmlrequest;
	},
	
	request : function () {
		var xmlrequest = this.xmlrequest;
		var options = this.options;
		var respondToReadyState = this.respondToReadyState;
		
		try {
			if (options.loadmask && $("loadmask")){
				$("loadmask").style.display = "block";
			}
			xmlrequest.open(options.method.toUpperCase(), aihb.URL+options.url, options.asynchronous);
			
			if (!options.asynchronous) {
				respondToReadyState(xmlrequest,options);
			} else {
				xmlrequest.onreadystatechange = function(){
						respondToReadyState(xmlrequest,options)
					};
			}
			xmlrequest.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
			xmlrequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
			xmlrequest.setRequestHeader("Request-Type", "ajax");
			xmlrequest.send(this.options.parameters);
		}
		catch (e) {debugger;}
	},
	
	respondToReadyState : function(xmlrequest,options){
		var readyState = xmlrequest.readyState;
		if (readyState == 4) {
			if (xmlrequest.status == 200) {
				options.callback(xmlrequest);
				if (options.loadmask && $("loadmask")) $("loadmask").style.display = "none";
			}
		}
	}
};

/*----------------------------------  Grid表格包转  ----------------------------------------*/
if(typeof aihb.Grid == "undefined") aihb.Grid = {};
aihb.Grid = function() {this.initialize.apply(this,arguments);}

aihb.Grid.prototype = {
	
	initialize : function (options) {
		this.header = options.header||[];
		this.data = options.data||[];
		this.dataAmount=options.dataAmount;
		this.paging = {
			pageSize : options.pageSize || 30 
			,currentPage :  1
			,start : options.start || 1
			//,limit : options.limit || 510
			,total : options.total || this.data.length//导致必须在data初始化下面
		}
		this.paging.limit=options.limit?(options.limit%this.paging.pageSize==0?options.limit:(options.limit/this.paging.pageSize+1)*this.paging.pageSize):510//limit必须是pageSize的整数倍
		/*if(this.paging.start!=1){
			this.paging.currentPage = parseInt(this.paging.start/this.paging.pageSize,10) + 1;
		}*/
		this.container = (typeof options.container == "string")?$(options.container):options.container;
		this.colWidth = [];//列的数量用于table width判断
		this.needWidth=false;
		//this.calColWidth();不再这里判断，在header中判断
		this.wrapper=options.wrapper||{};
	},
	
	render : function() {
		
		/*if(this.container.childNodes[0])
			this.container.childNodes[0].parentNode.removeChild(this.container.childNodes[0])
		*/
		this.container.innerHTML="";
		/* 用这个,表格的border比较粗 不知道怎么搞
		var _table = $C("table");
		//_table.id="_t1";
		_table.width = "99%";
		_table.className = "grid-tab-blue";
		_table.cellspacing="1";
		_table.cellpadding="0";
		_table.border="0";
		_table.align="center";
		_table.appendChild(this.getHeader());
		_table.appendChild(this.getBody());
		this.container.appendChild(_table);*/
		
		
		/*var tableHtml = '<table width="99%" class=grid-tab-blue align=center border=0 cellspacing="1" cellpadding="0" ></table>';
		this.container.innerHTML=tableHtml;
		var _table = this.container.childNodes[0];
		*/
		//var _table =$C('<table width="99%" class=grid-tab-blue align=center border=0 cellspacing="1" cellpadding="0" ></table>');
		var _table =$C('table');
		this.container.appendChild(_table);
		_table.className = "grid-tab-blue";
		_table.style.width = "90%";
		_table.style.textAlign = "center";
		_table.style.borderColor = 0;
		_table.appendChild(this.getHeader());
		_table.appendChild(this.getBody());
		
		if(this.needWidth)
			_table.width=this.colWidth["_tableWidth"];
		//alert(_table.outerHTML)
		if(this.getPaging())
			this.container.appendChild(this.getPaging());
	},
	
	getBody : function  () {
		var _tbody = $C("tbody");
		var data = this.data;
		var _header = this.header;
		//debugger
		var rowseq = this.paging.pageSize*this.paging.currentPage-this.paging.start+1;
		//i<= 是为了取合计值
		for(var i=rowseq-this.paging.pageSize; i< (rowseq>data.length?data.length:rowseq)+(this.dataAmount?1:0); i++){
			//取合计值
			var aRow=null;
			if(i==data.length && this.dataAmount)
				aRow=this.dataAmount;
			/*else if(i==data.length && aRow.length==0)
				continue;*/
			else 
				aRow=data[i] || {};
				
			var _tr = $C("tr");
			_tbody.appendChild( _tr );
			
			if( i%2 == 0 ) {
				_tr.className="grid_row_blue";
				_tr.onmouseover=function(){this.className='grid_row_over_blue';}
				_tr.onmouseout=function(){this.className='grid_row_blue';}
			} else {
				_tr.className="grid_row_alt_blue";
				_tr.onmouseover=function(){this.className='grid_row_over_blue';}
				_tr.onmouseout=function(){this.className='grid_row_alt_blue';}
			}
			
			for(var j=0; j< _header.length; j++){
				
				if( _header[j].dataIndex in aRow){//如果索引不存在就不画td
					var _td = $C("td");
					_tr.appendChild(_td);
					var cellNode = "";//执行的字符串
					
					if( _header[j].cellFunc && ( typeof _header[j].cellFunc == "function" || (typeof _header[j].cellFunc == "string" && _header[j].cellFunc.trim().length>0) ) ){
						cellNode = _header[j].cellFunc+"(aRow."+_header[j].dataIndex+",{record : aRow , data : data , rowIndex : "+i+" , columnIndex : "+j+"})";
						if(!_header[j].cellStyle)_header[j].cellStyle="grid_row_cell_number"
					}else{
						cellNode = "aRow."+_header[j].dataIndex;
					}
					_td.className= _header[j].cellStyle || "grid_row_cell";
					//_td.appendChild( $CT(eval(cellNode))); // 2010-4-15修复cellFunc的Bug
					var _rest=null;//运行的结果
					try{
						eval("_rest="+cellNode);
					}catch(e){
						//这个判断没有意义 if( _header[j].cellFunc && _header[j].cellFunc.trim().length>0)
						_rest="cellFunc的方法不对nested exception is:"+e.message;
					}
					if ( _rest != null && typeof _rest == "object" ){//cellFunc运算后返回的对象
						_td.appendChild( _rest);
					}else if (typeof _rest == "string"){//直接是字符串或者HTML
						var _tdWrapper=$C("span");
						_tdWrapper.innerHTML=_rest;
						_td.appendChild( _tdWrapper);
					}else{//有可能是数字
						_td.appendChild( $CT(_rest));
					}
				}else if(_header[j].display && _header[j].display=="show"){
					var _td = $C("td");
					_tr.appendChild(_td);
					var cellNode = "";
					if( _header[j].cellFunc ){
						cellNode = _header[j].cellFunc+"('',{record : aRow , data : data , rowIndex : "+i+" , columnIndex : "+j+"})";
					}
					_td.className= _header[j].cellStyle || "grid_row_cell";
					//_td.appendChild( $CT(eval(cellNode)));
					var _rest="";
					eval("_rest="+cellNode);
					if (typeof _rest == "object" && _rest != null){
						_td.appendChild( _rest);
					}else{
						_td.innerHTML=eval(cellNode);
					}
				}
			}
		}
		return _tbody;
	},
	/**
	 *表头的拦截器，增加表头的功能
	 * elementTd:该单元格的TD对象，headData：表头对象header[i]，headerRowIndex:复合表头行数
	 */
	headerInterceptor: function(elementTd,headData,headerRowIndex){
	},
	
	getHeader : function(event){
		var _grid = this;
		var _tr = $C("tr");
		_tr.className="grid_title_blue";
		var _thead = $C("thead");
		//_thead.appendChild(_tr);
		
		var _header = this.header;
		var data = this.dataAmount || this.data[0] || {};//取一行数据
		
		var _colWidth=this.colWidth;
		var isArray=typeof _header[0].name != "string";
		var _headerName= (isArray)?_header[0].name:[_header[0].name];
		var _headerMatrix=aihb.Util.headerMatrix(_header);
		
		//专门处理隐藏列 ?需要判断来减去col和row的值
		function displayProcess(matrix,row,col,data){
			
			if(!(_header[col].dataIndex in data)){
				matrix[row][col].display=false;
				var offsetCol=1;
				while(col>offsetCol){//处理隐藏列是，减小span.col的值
					if(matrix[row][col].span==undefined && matrix[row][col-offsetCol].span){
						matrix[row][col-offsetCol].span.col--;
						break;
					}
					offsetCol++;
				}
			}
		}
		//遍历matrix 处理隐藏列问题
		for(var i=0; i<_headerMatrix.length; i++ ){
			for(var j=0;j<_headerMatrix[i].length;j++){
				displayProcess(_headerMatrix,i,j,data);
			}
		}
		
		//还要判断表格的宽度，
		this.calColWidth(_headerMatrix);
		
		for(var j=0;j<_headerName.length;j++){
			var _mTr=$C("tr");
			_mTr.className="grid_title_blue";
			_thead.appendChild(_mTr);
			for(var i=0; i<_header.length; i++ ){
				var _element=_headerMatrix[j][i];
				if(_element.span && _element.display){
					var _td = $C("td");
					_mTr.appendChild(_td);
					_td.className = "grid_title_cell";
					//_td.innerText=_element.text;
					_td.colSpan=_element.span.col;
					_td.rowSpan=_element.span.row;
					
					if(this.needWidth && _element.span.col==1){//根据表头的文字部分再判断一套width那个大取那个
						_td.width=_colWidth[_header[i].dataIndex];
					}
					
					_grid.order=_grid.order||"asc";//给grid增加了一个order字段
					var _a = $C("a");
					_a.innerText=_element.text;
					try{
						if(event&&event.srcElement&&event.srcElement.id&&event.srcElement.id==_header[i].dataIndex){
							if(_grid.order=="asc"){
								_a.innerText+="↑";
							}else{
								_a.innerText+="↓";
							}
						}
					}catch(e){debugger;}
					
					_a.id=_header[i].dataIndex;
					
					_a.title=_header[i].title || "点击排列";
					_a.href="javascript:void(0)";
					_a.onclick=function(){
						_grid.order=(_grid.order=="desc"?"asc":"desc");
						var _dataIndex=this.id;
						if($("loadmask")) $("loadmask").style.display = "block";
						try{
							_grid.data.sort(function(_left,_right){
								var va1=eval("_right."+_dataIndex);
								var va2=eval("_left."+_dataIndex);
								if(!isNaN(va1-va2)){//数值
									return (_grid.order=="desc"?1:-1)*(va1-va2);
								}else{//字符串
									if(_grid.order=="desc"){
										return va2.localeCompare(va1);
									}else{
										return va1.localeCompare(va2);
									}
								}
							});
						}catch(e){
							_grid.data.sort();//不是数字的时候按照ascii排序
						}
						if($("loadmask")) $("loadmask").style.display = "none";
						_grid.render();
					}
					
					_td.appendChild(_a);
					
					this.headerInterceptor(_td,_header[i],j);
				}
			}
		
		}
		return _thead;
	},
	
	calColWidth : function(headerMatrix){//根据表头和文字和数据的长度来判断
		if(!("_tableWidth" in this.colWidth)){
			var data = this.data[0] || this.dataAmount || {};//取一行数据
			var _tableWidth=0;
			var _header=this.header;
			for(var i=0; i<_header.length; i++ ){
				
				//得到_headerText的值
				var _element=headerMatrix[headerMatrix.length-1][i];
				var _headerTextLength=0;
				
				if(_element.text=="#rspan"){//是#rspan
				//debugger;
					var _temCout=headerMatrix.length-1;
					while((--_temCout)>=0){
						if(headerMatrix[_temCout][i].text.match("span")==null){
							_headerTextLength=parseInt(headerMatrix[_temCout][i].text.length/headerMatrix.length+0.99);//当_element.span.row>1 文字的长度应该除以row的大小
							break;
						}
					}
				}else if(_element.span && _element.span.col==1){//不是垮列的
					_headerTextLength=_element.text.length;
				}
				
				if(_header[i].dataIndex in data){//没用索引就不画TD
					var _width=0;
					if(_headerTextLength>6){//计算表头文字
						_width=(_headerTextLength-6)*12.2;
					}
					if(data[_header[i].dataIndex] && !aihb.Util.isNumber(data[_header[i].dataIndex])&& data[_header[i].dataIndex].length>6){//通过第一行数据来计算
						_width=_width>55?_width:55;//和数据比较那个大取那个
					}
					
					this.colWidth[_header[i].dataIndex]=(_width>70?70:_width)+90;
					_tableWidth+=this.colWidth[_header[i].dataIndex];
				}
			}
			this.colWidth["_tableWidth"]=_tableWidth;
		}
		if(document.body.clientWidth-30<_tableWidth)
			this.needWidth=true;
	},
	
	getPaging : function(){
		var _grid = this;
		//_grid.paging.total=_grid.data.length;
		var _div = $C("div");
		_div.className="pagination";
		
		var _wrapper=this.wrapper;
		
		var swichPage=function(){
			var _pageNum=parseInt(this.pageNum,10);
			
			//debugger;
			//首先计算是否在一个组里面，
			//是 between 最大 最大
			//否 直接查询
			var _a=_grid.paging.limit/_grid.paging.pageSize;//计算多少页一组
			var _b = parseInt((_grid.paging.currentPage-1)/_a,10)*_a;
			//alert(_b + " "+_pageNum+" "+ (_b+_a));
			if( _b <_pageNum && _pageNum <= _b+_a){
				_grid.paging.currentPage=_pageNum;
				_grid.render();
			}else if(_wrapper){
				_wrapper.currentPage=_pageNum;
				_grid.paging.start=(parseInt((_pageNum-1)/_a,10)*_a)*_grid.paging.pageSize+1;
				_wrapper.request({start:_grid.paging.start});
			}
		}
		
		var _elem ={};
		if(_grid.paging.currentPage > 1){
			_elem = $C("a");
			_elem.pageNum=(_grid.paging.currentPage-1);
			_elem.href="javascript:void(0)";
			_elem.onclick=swichPage
		}else {
			_elem = $C("span");
			_elem.className="disabled";
		}
		_elem.innerText="上一页";
		_div.appendChild(_elem);
		
		for(var i=0; i < _grid.paging.total/_grid.paging.pageSize; i++){
			if(i<2||i>_grid.paging.total/_grid.paging.pageSize-2 || (_grid.paging.currentPage>=i && _grid.paging.currentPage<=i+2)){
				if(_grid.paging.currentPage!=(i+1)){
					_elem = $C("a");
					_elem.href="javascript:void(0)";
					_elem.pageNum=i+1;
					_elem.onclick=swichPage
				}else {
					_elem = $C("span");
					_elem.className="current";
				}
				_elem.innerText=i+1;
			}else if(_elem.innerText!="..."){
				_elem = $C("span");
				_elem.innerText="..."
			}
			_div.appendChild(_elem);
		}
		
		if(_grid.paging.currentPage < _grid.paging.total/_grid.paging.pageSize){
			_elem = $C("a");
			_elem.pageNum=_grid.paging.currentPage+1;
			_elem.href="javascript:void(0)";
			_elem.onclick=swichPage
		}else {
			_elem = $C("span");
			_elem.className="disabled";
		}
		_elem.innerText="下一页";
		_div.appendChild(_elem);
		_elem=$C("span");
		_elem.innerText=" 共 "+_grid.paging.total+" 条记录，每页显示 "+_grid.paging.pageSize+" 条";
		_div.appendChild(_elem);
		
		return _div;
	}
}
/*----------------------------------  Grid的包装类 ----------------------------------------*/

/**
这个类是分块查询的Grid实现
*/
if(typeof aihb.AjaxGrid == "undefined") aihb.AjaxGrid = {};
aihb.AjaxGrid = function() {this.initialize.apply(this,arguments);}

aihb.AjaxGrid.prototype = {
	
	initialize : function(options){
		var obj=this;
		var _sql = strEncode(options.sql);
		var _header = options.header;
		this.start=1;
		this.limit=510;
		this.currentPage=1;
		
		var _url = "/hbirs/action/jsondata?method=query&qType=limit";
		if(options.url){
			_url = options.url;
		}
		
		//加入日志记录
		var _params = aihb.Util.paramsObj();
		
		var ajax = new aihb.Ajax({
			url : _url
			,parameters : "start="+obj.start+"&limit="+obj.limit+"&sql="+_sql+"&"+_params._oriUri + (options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
			,loadmask : true
			,callback : function(xmlrequest){
				var _elObj=$(options.el||"grid");
				_elObj.style.display="";
				var res = null;
				try{
					eval("res="+xmlrequest.responseText);	
				}catch(e){
					res = null;
					debugger;
				}
				
				if(res!=null){
					var _grid = new aihb.Grid({
						container : _elObj
						,data : res.data || res
						,dataAmount : res.dataAmount
						,total :  res.total
						,start :  res.start
						,header : _header
						,wrapper : obj
						,limit : obj.limit
						,pageSize : options.pageSize
					});
					obj.grid=_grid;
					_grid.paging.currentPage=obj.currentPage;
					_grid.render();
				}else{
					var prompt=$C("span");
					prompt.style.color="red";
					prompt.appendChild($CT("无记录!请选择正确的条件"));
					while(_elObj.hasChildNodes())
				    {
						_elObj.removeChild(_elObj.firstChild);
				    }
					_elObj.appendChild(prompt);
				}
			}
		});
		
		this.ajax=ajax;
	},
	
	run : function (){
		this.ajax.request();
	},
	
	request : function(options){
		//2010-4-14更新BUG
		this.ajax.options.parameters=this.ajax.options.parameters.replace(/start=[0-9]+/,"start="+options.start);
		this.ajax.request();	
	}
}


if(typeof aihb.SimpleGrid == "undefined") aihb.SimpleGrid = {};
aihb.SimpleGrid = function() {this.initialize.apply(this,arguments);}

aihb.SimpleGrid.prototype = {
	
	initialize : function(options){
		var obj=this;
		var _sql = options.sql;
		var _header = options.header;
		//this.limit=510;
		
		//加入日志记录
		var _params = aihb.Util.paramsObj();
		
		var ajax = new aihb.Ajax({
			url : "/hb-bass-navigation/hbirs/action/jsondata?method=query"
			,parameters : "sql="+strEncode(_sql)+"&"+_params._oriUri + (options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
			,loadmask : true
			,callback : function(xmlrequest){
				var _elObj=$(options.el||"grid");
				_elObj.style.display="";
				var res = null;
				try{
					eval("res="+xmlrequest.responseText);
				}catch(e){
					res = null;
					debugger;
				}
				if(res != null){
					var _grid = new aihb.Grid({
						container : _elObj
						,data : res.data || res
						,limit : (res.data || res).length
						,dataAmount : res.dataAmount
						,total :  res.total
						,start :  res.start
						,header : _header
						,pageSize : options.pageSize
					});
					obj.grid=_grid;
					_grid.render();
					if(options.callback)options.callback();
				}else{
					var prompt=$C("span");
					prompt.style.color="red";
					prompt.appendChild($CT("无记录!请选择正确的条件"));
					while(_elObj.hasChildNodes())
				    {
						_elObj.removeChild(_elObj.firstChild);
				    }
					_elObj.appendChild(prompt);
				}
			}
		});
		
		this.ajax=ajax;
	},
	run : function (){
		this.ajax.request();
	}
}

/**
只查询出前500条数据，其他的部分不管，然后提示一共有多少条
 */
if(typeof aihb.PieceGrid == "undefined") aihb.PieceGrid = {};
aihb.PieceGrid = function() {this.initialize.apply(this,arguments);}
aihb.PieceGrid.prototype = {
		initialize : function(options){
			var obj=this;
			var _sql = options.sql;
			var _header = options.header;
			var _rows = options.rows||500;
			
			//加入日志记录
			var _params = aihb.Util.paramsObj();
			
			var ajax = new aihb.Ajax({
				url : "/hb-bass-navigation/hbirs/action/jsondata?method=query&qType=piece"
				,parameters : "sql="+strEncode(_sql)+"&rows="+_rows+"&"+_params._oriUri + (options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
				,loadmask : true
				,callback : function(xmlrequest){
					var _elObj=$(options.el||"grid");
					_elObj.innerHTML="";
					_elObj.style.display="";
					var res = null;
					try{
						eval("res="+xmlrequest.responseText);
					}catch(e){
						res = null;
						debugger;
					}
					if(res != null){
						
						var _gridDiv=$C("div");
						if(res.total>res.data.length){
							var tipDiv=$C("div");
							tipDiv.style.textAlign="center";
							tipDiv.appendChild($CT("符合条件的数据有"));
							var text=$C("span");
							text.style.color="red";
							text.appendChild($CT(res.total))
							tipDiv.appendChild(text);
							tipDiv.appendChild($CT("条,为了提高系统查询速度,目前只显示前"+res.data.length+"条"));
							
							_elObj.appendChild(tipDiv);
						}
						_elObj.appendChild(_gridDiv);
						
						var _grid = new aihb.Grid({
							container : _gridDiv
							,data : res.data
							,total :  (res.data || res).length
							,header : _header
							,pageSize : options.pageSize
						});
						obj.grid=_grid;
						_grid.render();
						if(options.callback)options.callback();
					}else{
						var prompt=$C("span");
						prompt.style.color="red";
						prompt.appendChild($CT("无记录!请选择正确的条件"));
						while(_elObj.hasChildNodes())
					    {
							_elObj.removeChild(_elObj.firstChild);
					    }
						_elObj.appendChild(prompt);
					}
				}
			});
			
			this.ajax=ajax;
		},
		run : function (){
			this.ajax.request();
		}
	}

/*----------------------------------  组件方法  ----------------------------------------*/
aihb.AjaxHelper={
	/*
	 {dataIndex:[names]} 
	*/
	transHeader : function(header,isOri){//把Grid用到header对象转成字符串，传给服务端
		if (typeof header == "string") {
			return header;
		}else if(header == undefined){
			return "";
		}else{
			var headObject={};//对象
			for(var i=0;i<header.length;i++){
				var _header=header[i];
				headObject[_header.dataIndex.toUpperCase()]=[];
				var nameList = headObject[_header.dataIndex.toUpperCase()];
				if(typeof _header.name == "string"){//字符串不处理
					//_headerStr+="\""+header.dataIndex.toLowerCase()+"\":\""+encodeURIComponent(encodeURIComponent(header.name))+"\"";
					nameList.push(_header.name);
				}else if (typeof _header.name == "object"){//复合表头处理，处理#rspan和#cspan替换成中文
					for(var j=0;j<_header.name.length;j++){
						var _colName=_header.name[j];
						if(!isOri){
							if(_header.name[j]=="#rspan"){
								var _ind=j;
								while(_colName=="#rspan"&&_ind>=1){
									_ind--;
									_colName=_header.name[_ind]
								}
							}else if(_header.name[j]=="#cspan"){
								var _ind=i;
								while(_colName=="#cspan"&&_ind>=1){
									_ind--;
									_colName=header[_ind].name[j];
								}
							}
						}
						nameList.push(_colName);
					}
				}
			}
			var _headerStr="{";
			//把对象转成字符串，可以使用Json2.js，先自行实现
			for(var idx in headObject){
				if(_headerStr.length>1){
					_headerStr+=",";
				}
				_headerStr+="\""+idx+"\":[";
				
				var nameList=headObject[idx];
				
				for(var j=0;j<nameList.length;j++){
					_headerStr+="\""+nameList[j]+"\",";
				}
				_headerStr=_headerStr.substring(0,_headerStr.length-1);
				_headerStr+="]";
			}
			_headerStr+="}";
			return _headerStr;
		}
	},
	
	down : function( options ){//form:表单, sql：sql语句,header:表头,fileName:下载的文件名,url:请求下载的地址,ds:数据源,useExcel:是否下载excel
		var _form=options.form || document.forms[0];
		
		if (!_form) {
			alert("没有表单");
			return;
		}
		
		function setFormField(form, name,value) {
			if(value){
				var fields = form.getElementsByTagName("input");
				var field = undefined;
				for (var i = 0; i < fields.length; i++) {
					var f = fields[i];
					if (f.name == name) {
						field=f;
						break;
					}
				}
				if (!field) {
					field = $C("input");
					field.type = "hidden";
					field.name = name;
					form.appendChild(field);
				}
				field.value = value;
			}
		};
		//需要增加header SQL fileName 三个隐藏的input
		if(options.sql!=undefined)
			setFormField(_form,"sql",strEncode(options.sql));
		
		if(options.header!=undefined)
			setFormField(_form,"header",this.transHeader(options.header,(options.useExcel=="true" || options.useExcel==true)));
		
		if(options.ds!=undefined)
			setFormField(_form,"ds",options.ds);
			
		setFormField(_form,"fileName",options.fileName || document.title );
		
		var _url = options.url || "/hbirs/action/jsondata?method=down";
		
		if(options.useExcel=="true" || options.useExcel==true){//是否使用Excel 下载
			if(_url.indexOf("?")>0){
				_url += "&";
			}else{
				_url += "?";
			}
			_url += "fileKind=excel";
		}
		
		//加入日志记录
		var _params = aihb.Util.paramsObj();
		if(_params._oriUri.length>0){
			if(_url.indexOf("?")>0){
				_url += "&";
			}else{
				_url += "?";
			}
			_url +=_params._oriUri;
		}
		_form.action = aihb.URL+_url;
		_form.method="POST";
		_form.target = "_top";
		_form.submit();
	},
	
	parseCondition : function(){
		var _condition = "";
		var elems = document.getElementsByTagName("dim");
		for( var i=0; i < elems.length; i++ ){
			var elem=elems[i];
			var obj = undefined;
			eval("obj=document.forms[0]."+elem.name);
			if(obj && elem.dbName && ((obj.type!="checkbox"&&obj.value.length>0&&elem.name!="city") || (elem.name=="city"&&obj.value!="0") || obj.checked)){
				_condition +=" and " + elem.dbName;
				if(elem.name=="time"&& $("time_during") && $("time_during").style.display!="none"){//判断是时间段还是时间点
					_condition +=" between "
					var isVarchar=( !elem.operType || elem.operType=="" || elem.operType=="varchar" );
					if(isVarchar){
						_condition +="'"
					}
					_condition +=$("time_from").value
					if(isVarchar){
						_condition +="'";
					}
					_condition +=" and ";
					if(isVarchar){
						_condition +="'";
					}
					_condition +=$("time").value
					if(isVarchar){
						_condition +="'";
					}
					continue;
				}
				
				if(elem.operType=="int"){
					_condition+="="+obj.value;
				}else if(elem.operType=="like"){
					_condition+=" like '%"+obj.value+"%'";
				}else if(elem.operType=="in"){
					_condition+=" in ("+obj.value+")";
				}else if(elem.operType=="between" && $("from_"+elem.name).value!=""){
					_condition+=" between "+$("from_"+elem.name).value+" and "+obj.value;
				}else if(elem.operType=="range"){
					_condition+=$("range_"+elem.name).value+" "+obj.value;
				}else if(elem.operType=="split"){
					var arr=obj.value.split("_");
					_condition+=" between "+arr[0]+" and "+arr[1];
				}else{
					_condition+="='"+obj.value+"'";
				}
			}
		}
		return _condition;
	},
	
	log : function(options){
		var _params=options.params;
		if(_params.match(/funccode/gi)){
			var ajax = new aihb.Ajax({
				url : "/hb-bass-navigation/hbirs/action/log"
				,parameters : _params
				,loadmask : false
				,callback : function(xmlrequest){}
			});
			ajax.request();
		}
	}
}

/*----------------------------------  表单操作  ----------------------------------------*/
aihb.FormHelper = {
	fillElementSelect : function(options) {
		var data = options.data||[];
		var element = options.element||{};
		var defaultValue = options.defaultValue||"";
		element.disabled = true;
		/**/
		if(options.isHoldFirst){//不删除第一个
			element.length=1;
			for (var i =0;i < data.length; i++){
				element[i+1] = new Option(data[i].value,data[i].key);
				if(element[i+1].value==defaultValue)element[i].selected = true;
			}
		} else {
			element.length=0;
			for (var i =0;i < data.length; i++){
				element[i] = new Option(data[i].value,data[i].key);
				if(element[i].value==defaultValue)element[i].selected = true;
			}
		}
		element.disabled = false;
	},
	
	fillSelectWrapper : function(options){
		//加入日志记录,是否需要改变method来记录日志
		var _params = aihb.Util.paramsObj();
		var ajax = new aihb.Ajax({
			url : "/hb-bass-navigation/hbirs/action/jsondata"
			,parameters : "sql="+strEncode(options.sql)+(options.ds?"&ds="+options.ds:"")+"&"+_params._oriUri + (options.isCached!=undefined?"&isCached="+options.isCached:"")
			,callback : function(xmlrequest){
				var list = eval(xmlrequest.responseText);
				aihb.FormHelper.fillElementSelect({
					data : list
					,isHoldFirst : options.isHoldFirst
					,element : options.element
				});
				
				if(options.callback)
					options.callback();
			}
		});
		
		ajax.request();
	},
	/**
		联动的通用方法
		@param selects: 所有参加联动的HTMLSelect标签的数组引用,顺序插入
		@param sqls: 所有参加联动的sql字符串数组,顺序插入(sql语句中的value通过字符串'#{value}'代替)
		@param i: 联动的级别,顺序从1开始
	*/
	comboLink : function (options){
		var _options = {
			datas : []
			,elements : []
			,level : 1
		};
		for (var key in options || {}) {
			_options[key] = options[key];
		}
		
		if(_options.level > _options.elements.length)return;
		
		var value = _options.elements[_options.level-1].value;
		if(value==""||value=="0"){// 如果传递的值为第一项“全省”或“全部” 下级级联选择框内容直接置为第一项“全部” ，不再提交数据库查询
	  		_options.elements[_options.level].length=1;
			//_options.elements[i].disabled = false;
	  	}else{
	  		var _value= _options.datas[_options.level-1];
	  		var _isHold = false;
	  		if(_value.length>7 && _value.substring(0,7)=="select "){
	  			_value = _value.replace("#{value}",_options.elements[_options.level-1].value);
	  			_isHold=true;
	  		} else {
	  			_value = _options.elements[_options.level-1].value;
	  		}
	  		
	  		this.fillSelectWrapper({element: _options.elements[_options.level],isHoldFirst:_isHold,sql:_value,ds: _options.ds});
		}
		
		if(_options.level < _options.datas.length)
			aihb.FormHelper.comboLink({
				datas : _options.datas
				,elements : _options.elements
				,level : parseInt(_options.level,10)+1
			});
	}
}

function areacombo( level , sync ) {
	var _elements = [];
	var sqls = [];
	
	_elements.push(document.forms[0].city);
	
	//区域化的联动，增加时间参数
	var bureauSuffix="";
	if($("time")){
		var _time=$("time").value;
		if(_time.length==6){
			bureauSuffix="_"+_time;
		}else if(_time.length==8 && (new Date().format("yyyymm"))!=_time.substring(0,6)){
			bureauSuffix="_"+_time.substring(0,6);
		}
	}
	
	if(document.forms[0].county){
		_elements.push(document.forms[0].county);
		sqls.push("county");
	}else if(document.forms[0].college){
		_elements.push(document.forms[0].college);
		sqls.push("select college_id key,college_name value from nwh.college_info"+bureauSuffix+" where area_id='#{value}' order by college_name with ur");
	}else if(document.forms[0].county_bureau){
		_elements.push(document.forms[0].county_bureau);
		sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where area_code= '#{value}' and level=2 order by 1 with ur");
	}else if(document.forms[0].entCounty){
		_elements.push(document.forms[0].entCounty);
		sqls.push("select country_id key,org_name value from NMK.DIM_ent_AREAORG where country_id like '#{value}%' order by seq with ur");
	}else if(document.forms[0].ent_grid_main){
		_elements.push(document.forms[0].ent_grid_main);
		sqls.push("select grid_id key,grid_name value from nmk.grid_tree_info where parentgrid_id = '#{value}' order by 1 with ur");
	}
	
	if(document.forms[0].office){
		_elements.push(document.forms[0].office);
		sqls.push("select site_id key,site_name value from nmk.RES_SITE where substr(site_id,1,8)='#{value}' order by site_name with ur");
	}else if(document.forms[0].marketing_center){
		_elements.push(document.forms[0].marketing_center);
		sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where pid= '#{value}' order by 1 with ur");
	}else if(document.forms[0].ent_grid_sub){
		_elements.push(document.forms[0].ent_grid_sub);
		sqls.push("select grid_id key,grid_name value from nmk.grid_tree_info where parentgrid_id = '#{value}' order by 1 with ur");
	}
	
	if(document.forms[0].custmgr){
		_elements.push(document.forms[0].custmgr);
		sqls.push("select staff_id key,staff_id||staff_name value from NMK.DIM_ENT_STAFF_D where org_id='#{value}' order by 1 with ur");
	}else if(document.forms[0].town!= undefined){
		_elements.push(document.forms[0].town);
		//sqls.push("select region_id key,region_name value from kpi_bureau_cfg where parent_id= '#{value}' order by 1 with ur");
		sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where pid= '#{value}' order by 1 with ur");
	}else if(document.forms[0].ent_grid_micro){
		_elements.push(document.forms[0].ent_grid_micro);
		sqls.push("select grid_id key,grid_name value from nmk.grid_tree_info where parentgrid_id = '#{value}' order by 1 with ur");
	}
	
	if(document.forms[0].cell){
		_elements.push(document.forms[0].cell);
		sqls.push("select bureau_id key,bureau_name name from nwh.dim_bureau_cfg"+bureauSuffix+" where town_code='#{value}' order by 1 with ur");
		//sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where pid= '#{value}' order by 1 with ur");
	}
	
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : strEncode(sqls)
		,level : level
	});
}

/*----------------------------------  工具方法  ----------------------------------------*/
aihb.Util = {
	loadResource : function(uri,type){
		var _res=null;
		if(type=="css"){
			_res=$C("link");
			_res.type="text/css";
			_res.rel="stylesheet";
			_res.href = uri;
		}else{
			_res=$C("script");
			_res.type = "text/javascript";
			_res.src = uri;
		}
		var container = document.getElementsByTagName("head")[0] || document.body;
		container.appendChild(_res);
		
		/*if (script.readyState){ //IE
			script.onreadystatechange = function(){
				if (script.readyState == "loaded" || script.readyState == "complete"){
					script.onreadystatechange = null;
					callback && callback();
				}
			}
		}else{ //Others
			script.onload = function(){
				callback && callback();
			}
		}*/
	},
	
	headerMatrix : function(_header){//把header 转成一个二维数组(矩阵),{span:{row:0,col:0},display:true,text:""}
		/** 多表头**/
		//把header 转成一个二维数组(矩阵),{span:{row:0,col:0},display:true,text:""}
		var _headerMatrix=[];
		var isArray=typeof _header[0].name != "string";
		var _headerName= (isArray)?_header[0].name:[_header[0].name];
		for(var j=0;j<_headerName.length;j++){
			//_headerName=_header[j].name;
			_headerMatrix[j]=[];
			for(var i=0; i<_header.length; i++ ){
				var _tempHname=(isArray)?_header[i].name[j]:_header[i].name;
				_headerMatrix[j][i]={display:true,text:_tempHname,dataIndex : _header[i].dataIndex ,cellFunc:  _header[i].cellFunc, cellStyle :  _header[i].cellStyle,title: _header[i].title };
				if(_tempHname.match("span")==null){
					_headerMatrix[j][i].span={row:1,col:1};
				}
			}
		}
		
		//专门处理跨行垮列
		function spanProcess(matrix,row,col){
			if(matrix[row][col].text=="#rspan"){
				var _tmpCout=row;
				while( (--_tmpCout)>=0){
					if(matrix[_tmpCout][col].span){
						matrix[_tmpCout][col].span.row++;//上一级的count+1
						matrix[row][col].span=undefined;//本元素置为空
						break;
					}
				}
			}else{
				var _tmpCout=col;
				while((--_tmpCout)>=0){
					if(matrix[row][_tmpCout].span){
						matrix[row][_tmpCout].span.col++;//上一级的count+1
						matrix[row][col].span=undefined;//本元素置为空
						break;
					}
				}
			}
		}
		for(var i=0; i<_headerMatrix.length; i++ ){//遍历matrix 处理span的问题
			for(var j=0;j<_headerMatrix[i].length;j++){
				if(_headerMatrix[i][j].text.match("#")!=null){
					spanProcess(_headerMatrix,i,j);
				}
			}
		}
		return _headerMatrix;
	},
	numberFormat : function( value ) {
		value +="";
		if(value!="null" && value.trim().length>0){
			var digit = 2;
			if(arguments.length>1 && this.isNumber(arguments[2]))digit=arguments[2];
			
			var negative = false;
			if(value.indexOf("-")==0){negative=true;value=value.substring(1,value.length);}
			var ary = value.split(".");
			var post="";
			if(ary.length==2){
				post = ary[1];
				if(ary[1].length>digit){
				  	var nextnum = parseInt(ary[1].substring(digit,digit+1),10);
				  	var curnum = parseInt(ary[1].substring(0,digit),10);
				  	if(nextnum>=5)curnum = curnum+1;
				  	
				  	if(curnum<10)post="0"+curnum;
				  	else post = curnum + "";
				  	
				  	if(post.length> digit){
				  		post=post.substring(1,digit+1);
				  		per = parseInt(ary[0],10)+(ary[0].substring(0,1)=="-"?-1:1);
				  		ary[0]=per+"";
				  	}
				} else if (ary[1].length<digit) {
					for(var a = 0; a < digit- ary[1].length;a++)post+="0";
				}
			}
			var i = ary[0].length;
			var abc = "";
			while(i > 3){
				abc = ary[0].substring(i-3,i) + ","+abc;
				i-=3;
			}
			abc = ary[0].substring(0,i) + ","+abc;
			var result = abc.substring(0,abc.length-1);
			if(post.length>0)result += "."+ post; 
			return negative?"-"+result:result;
		}else{
			return "--";
		}
	},
	
	percentFormat :  function ( value ) {
		value +="";
		if(value!="null" && value.trim().length>0 && value!="--"){
			var formatDigit = [];
			formatDigit["100"]="%";
			formatDigit["1000"]="‰";
			var constant=100;
			if(arguments.length>1 && arguments[2]==1000)constant=1000;
			if(value=="")return value;
			var digit=2;
			var ary = ((parseFloat(value)*constant)+"") .split(".");
			var post="";
			if(ary.length==2){
				post = ary[1];
				if(ary[1].length>digit){
					var nextnum = parseInt(ary[1].substring(digit,digit+1),10);
					var curnum = parseInt(ary[1].substring(0,digit),10);
					if(nextnum>=5)curnum = curnum+1;
					
					if(curnum<10)post="0"+curnum;
					else post = curnum + "";
					
					if(post.length> digit){
						post=post.substring(1,digit+1);
						per = parseInt(ary[0],10)+(ary[0].substring(0,1)=="-"?-1:1);
						ary[0]=per+"";
					}
				}else if (ary[1].length<digit){
					for(var a = 0; a < digit- ary[1].length; a++ )post+="0";
				}
			}
			result = ary[0];
			if(post.length>0)result += "."+ post;
			return result +formatDigit[""+constant] ;
		}else{
			return "--";
		}
	},
	
	fuzzFormat : function( value ){
		var _res=String(value);
		if(/[0-9]{11}/.test(value)){//手机号码
			_res= value.substring(0,3)+"****"+value.substring(7,11);
		}else if(/[\W]{2,4}/.test(value)){
			_res= value.substring(0,1)+"**";
		}
		return _res;
	},
	
	isNumber : function ( value ){
		var patrn=/^(\+|-)?([0-9]\d*)(\.\d*[0-9])?$/;
		if (!patrn.exec(value)) return false;
		return true;
	},
	
	paramsObj : function(){
		var _uri = window.location+"";
		var _paramStr = "";
		var _encoderOriUri="";
		if(_uri.indexOf("?")>0){
			_uri = _uri.substring(_uri.indexOf("?")+1,_uri.length);
			var _arr = _uri.split("&");
			for(var i=0;i<_arr.length;i++){
				var _arr2=_arr[i].split("=");
				if(_encoderOriUri.length>0)_encoderOriUri+="&";
				_encoderOriUri +=_arr2[0]+"="+encodeURIComponent(_arr2[1]);
				if(_paramStr.length>0)_paramStr+=",";
				_paramStr += '"'+_arr2[0]+'":"'+_arr2[1]+'"';
			}
		}else{
			_uri="";
		}
		var _objParams={};
		eval('_objParams={\"_oriUri\":\"'+_uri+'\",\"_encoderOriUri\":\"'+_encoderOriUri+'\"'+(_paramStr.length>0?','+_paramStr:'')+'}');
		return _objParams;
	},
	
	loadmask : function(){
		var _loadmask=$C("div");
		_loadmask.id="loadmask";
		_loadmask.style.display="none";
		var str='<div class="loadingmask">&#160;</div>'
				+'<div class="loading">'
					+'<div class="loading-indicator">'
						+'<span class="image"></span>&#160;加载中请稍候.....'
					+'</div>'
				+'</div>';
		_loadmask.innerHTML=str;
		if(document.body){
			document.body.appendChild(_loadmask);
		}else{
			this.addEventListener(window,"load",function(){
				document.body.appendChild(_loadmask);
			});
		}
	},
	
	windowMask : function(options){
		var _container =$C("div");
		_container.innerHTML='<div style="width:100%;height:120%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>'
		_container.style.display="none";
		var _content=$C("div");
		_content.style.cssText="position:absolute;left:20%;top:20%;padding: 3 px 10 px 5 px 10 px;z-index:100;background-color: #EFF5FB;border:1px solid #c3daf9;";
		var _close=$C("div");
		_close.style.cssText="text-align:right;margin-bottom:2px;";
		_close.innerHTML='<img src=\'/hbapp/resources/image/default/tab-close.gif\' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display=\'none\';}"></img>';
		_content.appendChild(_close);
		_content.appendChild(options.content);
		
		_container.appendChild(_content);
		
		this.addEventListener(window,"load",function(){
			document.body.appendChild(_container);
		});
		options.content.parentMask=_container;
		return _container;
	},
	
	watermark : function(){
		
		function addWaterMark(){
			var _waterMark=$C("div");
			_waterMark.id="waterMark";
			_waterMark.style.filter="alpha(opacity=8)";
			_waterMark.style.backgroundImage="url('/hb-bass-navigation/hbirs/action/watermark')";
			_waterMark.style.height=document.body.scrollHeight>document.body.clientHeight?document.body.scrollHeight:document.body.clientHeight;
			_waterMark.style.width=document.body.scrollWidth;
			_waterMark.style.position="absolute";
			_waterMark.style.zIndex="-99999";
			_waterMark.style.margin="0";
			_waterMark.style.left="0";
			_waterMark.style.top="0";
			document.body.appendChild(_waterMark);
		}
		if($("waterMark")){
			var _waterMark=$("waterMark");
			_waterMark.style.height=document.body.scrollHeight>document.body.clientHeight?document.body.scrollHeight:document.body.clientHeight;
			_waterMark.style.width=document.body.scrollWidth;
		}
		this.addEventListener(window,"load",function(){
			addWaterMark();
			//document.body.style.backgroundImage="url('/hb-bass-navigation/hbirs/action/watermark')";
		});
	},
	
	calDate : function(date){//计算同比环比的日期
		if(date==undefined){
			date=(new Date()).format();
		}
		var dates = ["0","0","0"];
		if (date.length == 8) {
			var cal = new Date(date.substring(0, 4),date.substring(4, 6)-1,date.substring(6, 8));
			var nYear = cal.getFullYear();
			var nDate = cal.getDate();
			var nMonth = cal.getMonth()+1;
			cal.setDate(cal.getDate()-1);
			dates[0] = cal.format();
			
			if(!(nDate==29 && nMonth==2)){
				cal.setDate(cal.getDate()+1);
			}
			cal.setYear(cal.getYear()-1);
			dates[2] = cal.format();
			
			if(((nYear-1) % 4 == 0 && (nYear-1) % 100 != 0 || (nYear-1) % 400 == 0) && nMonth==2 && nDate==28){
				dates[2] = (nYear-1)+"0229";
			}

			cal = new Date(date.substring(0, 4),date.substring(4, 6)-1,date.substring(6, 8));
			if (nDate == 30
					&& (nMonth == 4 || nMonth == 6 || nMonth == 9 || nMonth == 11)) {
				cal.setMonth(cal.getMonth()-1);
				cal.setDate(cal.getDate()+1);
				dates[1] = cal.format();
			} else if (nMonth == 2
					&& ((nDate == 29) || ((!(nYear % 4 == 0 && nYear % 100 != 0 || nYear % 400 == 0)))
							&& nDate == 28)) {
				dates[1] = date.substring(0, 4) + "0131";
			} else if(nMonth == 3 && nDate>28) {
				if((nYear % 4 == 0 && nYear % 100 != 0 || nYear % 400 == 0)&& nDate!=28){
					dates[1] = nYear + "0229";
				}else{
					dates[1] = nYear + "0228";
				}
			} else if(nDate == 31 && nMonth == 1){
				dates[1] = (nYear-1) + "1231";
			} else if(nDate == 31 && (nMonth != 8 || nMonth != 1 || nMonth != 3 )){
				cal.setDate(cal.getDate()-1);
				cal.setMonth(cal.getMonth()-1);
				dates[1] = cal.format();
			} else {
				cal.setMonth(cal.getMonth()-1);
				dates[1] = cal.format();
			}
		} else if(date.length == 6){
			var cal = new Date(date.substring(0, 4),date.substring(4, 6)-1,1);
			cal.setMonth(cal.getMonth()-1);
			dates[0] = cal.format();

			cal.setMonth(cal.getMonth()+1);
			cal.setYear(cal.getYear()-1);
			dates[1] = cal.format();
			dates[2] = "0";
		}
		return dates;
	},
	
	addEventListener : function(target,method,advice){
		if(target.addEventListener){
			target.addEventListener(method,advice,false);
		}else if(target.attachEvent){
			target.attachEvent("on"+method,advice);
		}
	}
}

aihb.Inject={
	before : function(target,advice){
		var ori=target;
		target=function(){
			advice();
			ori.apply(this,arguments);
		}
		return target;
	},
	after : function(target,advice){
		var ori=target;
		target=function(){
			ori.apply(this,arguments);
			advice();
		}
		return target;
	}
}

/*--------------------  BassDimHelper生成  ----------------------------------*/
aihb.BassDimHelper = {
	renderArea : function(options){
		if(options.el){
			var _element=(typeof options.el == "string")?_element=$(options.el):options.el;
			var _params = aihb.Util.paramsObj();
			_element.innerHTML=this.areaCodeHtml(options.name||"city",_params.cityId,"areacombo(1)");
		}
	},
	areaCodeHtml : function(name, defaultValue, onChange, isAllArea){
		var htmlcode = "";
		defaultValue = defaultValue||"0";
		htmlcode+="<select name='"+name+"' class='form_select'";

		if (onChange && onChange.length > 0)
			htmlcode+=" onchange=\""+onChange+"\"";

		htmlcode+=(">");

		if ("0"!=defaultValue)
			defaultValue = aihb.Constants.getArea(defaultValue).cityCode;
		
		if ("0"!=defaultValue && !isAllArea) {
			htmlcode+=("<option value='")+(defaultValue)+("'>")+(aihb.Constants.getArea(defaultValue).cityName)+("</option>");
		} else {
			var areaArr=aihb.Constants.area
			for (var i=0;i<areaArr.length;i++){
				
				htmlcode+=("<option value='")+(areaArr[i].cityCode=="HB"?"0":areaArr[i].cityCode)+("'");
				
				if (defaultValue==areaArr[i].cityCode)
					htmlcode+=(" selected='selected'");
				
				htmlcode+=(">")+(areaArr[i].cityName)+("</option>");
				
			}
		}

		htmlcode+=("</select>");

		//htmlcode.append("<script type='text/javascript' defer='defer'>").append(onChange).append("</script>");
		if ("0"!=defaultValue && !isAllArea){
			aihb.Util.addEventListener(window,"load",function(){
				areacombo(1);
			});
		}
		return htmlcode;
	}
}

/*--------------------  FusionChart 的xml生成  ----------------------------------*/
aihb.FusionChartHelper = {
	/*
	 * 把json格式转成fusionChart的格式
	 * data： SQLQuery返回的json对象
	 * idxSeq：对象索引的序列
	 */
	dataTransfer : function(data,idxSeq){
		var list=[];
		for(var i=0;i<data.length;i++){
			list[i]=[];
			for(var j=0;j<idxSeq.length;j++){
				list[i][j]=data[i][idxSeq[j]];
			}
		}
		return list;
	},
	
	initOptions : function(options){
		var _options = {
			caption : "",
			showNames :"1",
			showValues : "0",
			numDivLines : "3",
			colorStyle:"default",
			decimalPrecision:"0",//小数点的位数
			valueType : "",//百分比的形式需要乘100
			trendlinesDisplayValue:"",
			trendlinesValue:"",
			dySeriesName : "",//Y轴的名称
			rotateNames:"0",
			fontSize:"12",
			ignoreMinMax:false,//是否忽略最大最小的刻度问题
			setElement : []
		};
		for (var key in options || {}) {
			_options[key] = options[key];
		}
		return _options;
	},
	
	chartNormal : function(list,_options){
			options=this.initOptions(_options);
			var xmlStr="";
			xmlStr+="<graph baseFontSize='"+options.fontSize+"' caption='"+ options.caption
				+ "' formatNumberScale='0'"
				+ " numdivlines='" + options.numDivLines+"'"
				+ " showNames='"+ options.showNames+"'"
				+ " rotateNames='"+options.rotateNames+"'"
				+ " showValues='"+options.showValues+"'";
				
			if("percent"==options.valueType){
				xmlStr+=" numberSuffix='%25' decimalPrecision='2' ";
			}else{
				xmlStr+=" decimalPrecision='"+options.decimalPrecision+"' ";
			}
			
			var piece = "";
			var maxValue=-999999;
			var minValue=9999999999;
			for (var i = 0; i < list.length; i++){
				var lines = list[i];
				if(lines && lines.length>2&&options.setElement.length>0){ //处理element
					piece+="<set ";
					for (var j = 0; j < lines.length; j++) {
						
						if("value"==options.setElement[j]){
							piece+="value='";
							
							var num = 0;
							if(lines[j]!="" && aihb.Util.isNumber(lines[j])){
								if("percent"==options.valueType){
									num = parseFloat(lines[j])*100;
								}else{
									num = parseFloat(lines[j]);
								}
							}
							minValue = minValue<num?minValue:num;
							maxValue = maxValue>num?maxValue:num;
							piece+=num;
							piece+="' ";
						}else if("defaultColor"==options.setElement[j]){
							piece+= " color='"+ this.COLOR_STYLE[options.colorStyle][parseInt(i%14,10)] +"' ";
							//piece+= " color='"+ "AFD8F8" +"' ";
						}else if ("except"==options.setElement[j]){
							
						}
						else{
							var strValue=lines[j];
							if(aihb.Util.isNumber(strValue)){
								var num = parseFloat(strValue);
								minValue = minValue<num?minValue:num;
								maxValue = maxValue>num?maxValue:num;
							}
							piece+=options.setElement[j]+"='"+lines[j]+"' ";
						}
					}
					piece+="/>";
				} else {
					piece+="<set name='"+lines[0]+"' value='";
					var num = 0;
					if(lines[1]!="" && aihb.Util.isNumber(lines[1])){
						if("percent"==options.valueType){
							num = parseFloat(lines[1])*100;
						}else{
							num = parseFloat(lines[1]);
						}
					}
					minValue = minValue<num?minValue:num;
					maxValue = maxValue>num?maxValue:num;
					piece+=num;
					piece+="' color='"+this.COLOR_STYLE[options.colorStyle][parseInt(i%14,10)]+"'/>";
				}
			}
			
			if(options.trendlinesValue!="" && options.trendlinesValue.length>0){
				if(options.trendlinesDisplayValue==""||options.trendlinesDisplayValue.length==0)
					options.trendlinesDisplayValue="目标";
				var num=parseFloat(options.trendlinesValue);
				minValue = minValue<num?minValue:num;
				maxValue = maxValue>num?maxValue:num;
				piece+="<trendlines><line startvalue='"+options.trendlinesValue+"' displayValue='"+options.trendlinesDisplayValue+" "+options.trendlinesValue+"%' color='FF8000' thickness='2' isTrendZone='0' showOnTop='1'/></trendlines>";			
			}
			
			if(!options.ignoreMinMax){
				var formatMinValue = this.processMin(minValue);
				var formatMaxValue = this.processMax(maxValue);
				
				xmlStr+=" yaxisminvalue='"+formatMinValue+"' yaxismaxvalue='"+formatMaxValue+"'";
			}
			
			xmlStr+=" >"+piece+"</graph>";
			
			return xmlStr;
	},
	
	processMin : function(minValue){
		var sMinValue = minValue+"";
		var formatMinValue = sMinValue;
		if (minValue>=10){
			formatMinValue = (parseInt(sMinValue.substring(0,2),10)-1)+"";
			var digit = sMinValue.indexOf(".");
			if(digit==-1)digit=sMinValue.length;
			for (var j = 0; j < digit-2; j++)
			{
				formatMinValue+="0";
			}
		}else if(minValue>1){
			formatMinValue = (parseInt(sMinValue.substring(0,1),10)-1)+"";
		}else if(minValue<1 && minValue>=0){
			formatMinValue = "0";
		}else if(minValue <0){
			formatMinValue="-"+this.processMax(-1*minValue);
		}
		
		return formatMinValue;
	},
	
	processMax : function(maxValue){
		var sMaxValue = maxValue+"";
		var formatMaxValue = sMaxValue;
		if (maxValue>=10){
			formatMaxValue = (parseInt(sMaxValue.substring(0,2),10)+1)+"";
			var digit = sMaxValue.indexOf(".");
			if(digit==-1)digit=sMaxValue.length;
			for (var j = 0; j < digit-2; j++)
			{
				formatMaxValue+="0";
			}
		}else if(maxValue>0){
			formatMaxValue = (parseInt(sMaxValue.substring(0,1),10)+1)+"";
		}else if(maxValue<=0){
			formatMaxValue="0.01";
		}
		return formatMaxValue;
	},
	COLOR_STYLE : {
		"default" : ["AFD8F8","F6BD0F","8BBA00","FF8E46","008E8E","D64646","8E468E","588526","B3AA00","008ED6","DDDDDD"
							,"9D080D","F6BD0F","C9198D","BDF60F","BA8B00","8EFF46","8E008E","46D646","468E8E","EEEEEE"]
		,"order" : ["008ED6","008ED6","008ED6","DDDDDD","DDDDDD","DDDDDD","DDDDDD","DDDDDD","DDDDDD"
						,"DDDDDD","DDDDDD","D64646","D64646","D64646"]
	}
};

/*--------------------  FusionChart 的xml生成  ----------------------------------*/
aihb.Constants = {
	
	getArea : function(key){
	//debugger;
		var areas = this.area;
		var res = undefined;
		for(var i=0;!res && i<areas.length;i++){
			var area = areas[i];
			for(var j in area){
				if(area[j]==key){
					res=area;
					break;
				}
			}
		}
		return res;
	},
	
	area: [
		{cityId:"0",cityName:"全省",cityCode:"HB",regionCode:"27"}
		,{cityId:"11",cityName:"武汉",cityCode:"HB.WH",regionCode:"270"}
		,{cityId:"15",cityName:"恩施",cityCode:"HB.ES",regionCode:"718"}
		,{cityId:"17",cityName:"襄樊",cityCode:"HB.XF",regionCode:"710"}
		,{cityId:"23",cityName:"荆门",cityCode:"HB.JM",regionCode:"724"}
		,{cityId:"26",cityName:"孝感",cityCode:"HB.XG",regionCode:"712"}
		,{cityId:"12",cityName:"黄石",cityCode:"HB.HS",regionCode:"714"}
		,{cityId:"14",cityName:"宜昌",cityCode:"HB.YC",regionCode:"717"}
		,{cityId:"18",cityName:"江汉",cityCode:"HB.JH",regionCode:"728"}
		,{cityId:"20",cityName:"荆州",cityCode:"HB.JZ",regionCode:"716"}
		,{cityId:"25",cityName:"黄冈",cityCode:"HB.HG",regionCode:"713"}
		,{cityId:"13",cityName:"鄂州",cityCode:"HB.EZ",regionCode:"711"}
		,{cityId:"16",cityName:"十堰",cityCode:"HB.SY",regionCode:"719"}
		,{cityId:"19",cityName:"咸宁",cityCode:"HB.XN",regionCode:"715"}
		,{cityId:"24",cityName:"随州",cityCode:"HB.SZ",regionCode:"722"}
		,{cityId:"27",cityName:"潜江",cityCode:"HB.QJ",regionCode:"728"}
		,{cityId:"28",cityName:"天门",cityCode:"HB.TM",regionCode:"728"}]
}




function strEncode(data) {
	var operOption = "X";
	return defalutStrEnc(data, operOption);
}
function defalutStrEnc(data, firstKey) {
	//var now1=new Date();
	var leng = data.length;
	var encData = "";
	var firstKeyBt, secondKeyBt, thirdKeyBt, firstLength, secondLength, thirdLength;
	if (firstKey != null && firstKey != "") {
		firstKeyBt = getKeyBytes(firstKey);
		firstLength = firstKeyBt.length;
	}
	if (leng > 0) {
		if (leng < 4) {
			var bt = strToBt(data);
			var encByte;
			if (firstKey != null && firstKey != "") {
				var tempBt;
				var x = 0;
				tempBt = bt;
				for (x = 0; x < firstLength; x++) {
					tempBt = enc(tempBt, firstKeyBt[x]);
				}
				encByte = tempBt;
			}
			encData = bt64ToHex(encByte);
		} else {
			var iterator = leng / 4;
			var remainder = leng % 4;
			var i = 0;
			for (i = 0; i < iterator; i++) {
				var tempData = data.substring(i * 4 + 0, i * 4 + 4);
				var tempByte = strToBt(tempData);
				var encByte;
				if (firstKey != null && firstKey != "") {
					var tempBt;
					var x;
					tempBt = tempByte;
					for (x = 0; x < firstLength; x++) {
						tempBt = enc(tempBt, firstKeyBt[x]);
					}
					encByte = tempBt;
				}
				encData += bt64ToHex(encByte);
			}
			if (remainder > 0) {
				var remainderData = data.substring(iterator * 4 + 0, leng);
				var tempByte = strToBt(remainderData);
				var encByte;
				if (firstKey != null && firstKey != "") {
					var tempBt;
					var x;
					tempBt = tempByte;
					for (x = 0; x < firstLength; x++) {
						tempBt = enc(tempBt, firstKeyBt[x]);
					}
					encByte = tempBt;
				}
				encData += bt64ToHex(encByte);
			}
		}
	}
	//var now2=new Date();
	//alert(now2-now1);
	return encData;
}
function getKeyBytes(key) {
	var keyBytes = new Array();
	var leng = key.length;
	var iterator = parseInt(leng / 4);
	var remainder = leng % 4;
	var i = 0;
	for (i = 0; i < iterator; i++) {
		keyBytes[i] = strToBt(key.substring(i * 4 + 0, i * 4 + 4));
	}
	if (remainder > 0) {
		keyBytes[i] = strToBt(key.substring(i * 4 + 0, leng));
	}
	return keyBytes;
}
/*

* chang the string(it's length <= 4) into the bit array

* 

* return bit array(it's length = 64)

*/
function strToBt(str) {
	var leng = str.length;
	var bt = new Array(64);
	if (leng < 4) {
		var i = 0, j = 0, p = 0, q = 0;
		for (i = 0; i < leng; i++) {
			var k = str.charCodeAt(i);
			for (j = 0; j < 16; j++) {
				var pow = 1, m = 0;
				for (m = 15; m > j; m--) {
					pow *= 2;
				}
				bt[16 * i + j] = (k / pow) % 2;
			}
		}
		for (p = leng; p < 4; p++) {
			var k = 0;
			for (q = 0; q < 16; q++) {
				var pow = 1, m = 0;
				for (m = 15; m > q; m--) {
					pow *= 2;
				}
				bt[16 * p + q] = (k / pow) % 2;
			}
		}
	} else {
		for (i = 0; i < 4; i++) {
			var k = str.charCodeAt(i);
			for (j = 0; j < 16; j++) {
				var pow = 1;
				for (m = 15; m > j; m--) {
					pow *= 2;
				}
				bt[16 * i + j] = (k / pow) % 2;
			}
		}
	}
	return bt;
}
/*

* chang the bit(it's length = 4) into the hex

* 

* return hex

*/
function bt4ToHex(binary) {
	var hex;
	switch (binary) {
	  case "0000":
		hex = "0";
		break;
	  case "0001":
		hex = "1";
		break;
	  case "0010":
		hex = "2";
		break;
	  case "0011":
		hex = "3";
		break;
	  case "0100":
		hex = "4";
		break;
	  case "0101":
		hex = "5";
		break;
	  case "0110":
		hex = "6";
		break;
	  case "0111":
		hex = "7";
		break;
	  case "1000":
		hex = "8";
		break;
	  case "1001":
		hex = "9";
		break;
	  case "1010":
		hex = "A";
		break;
	  case "1011":
		hex = "B";
		break;
	  case "1100":
		hex = "C";
		break;
	  case "1101":
		hex = "D";
		break;
	  case "1110":
		hex = "E";
		break;
	  case "1111":
		hex = "F";
		break;
	}
	return hex;
}
/*

* chang the hex into the bit(it's length = 4)

* 

* return the bit(it's length = 4)

*/
function hexToBt4(hex) {
	var binary;
	switch (hex) {
	  case "0":
		binary = "0000";
		break;
	  case "1":
		binary = "0001";
		break;
	  case "2":
		binary = "0010";
		break;
	  case "3":
		binary = "0011";
		break;
	  case "4":
		binary = "0100";
		break;
	  case "5":
		binary = "0101";
		break;
	  case "6":
		binary = "0110";
		break;
	  case "7":
		binary = "0111";
		break;
	  case "8":
		binary = "1000";
		break;
	  case "9":
		binary = "1001";
		break;
	  case "A":
		binary = "1010";
		break;
	  case "B":
		binary = "1011";
		break;
	  case "C":
		binary = "1100";
		break;
	  case "D":
		binary = "1101";
		break;
	  case "E":
		binary = "1110";
		break;
	  case "F":
		binary = "1111";
		break;
	}
	return binary;
}
/*

* chang the bit(it's length = 64) into the string

* 

* return string

*/
function byteToString(byteData) {
	var str = "";
	for (i = 0; i < 4; i++) {
		var count = 0;
		for (j = 0; j < 16; j++) {
			var pow = 1;
			for (m = 15; m > j; m--) {
				pow *= 2;
			}
			count += byteData[16 * i + j] * pow;
		}
		if (count != 0) {
			str += String.fromCharCode(count);
		}
	}
	return str;
}
function bt64ToHex(byteData) {
	var hex = "";
	for (i = 0; i < 16; i++) {
		var bt = "";
		for (j = 0; j < 4; j++) {
			bt += byteData[i * 4 + j];
		}
		hex += bt4ToHex(bt);
	}
	return hex;
}
function hexToBt64(hex) {
	var binary = "";
	for (i = 0; i < 16; i++) {
		binary += hexToBt4(hex.substring(i, i + 1));
	}
	return binary;
}
function enc(dataByte, keyByte) {
	return xor(dataByte, keyByte);
}
function xor(byteOne, byteTwo) {
	var xorByte = new Array(byteOne.length);
	for (i = 0; i < byteOne.length; i++) {
		if (byteTwo[i]) {
			xorByte[i] = byteOne[i] ^ byteTwo[i];
		} else {
			xorByte[i] = byteOne[i] ^ 0;
		}
	}
	return xorByte;
}


//end-------------------------------------------------------------------------------------------------------------