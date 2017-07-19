/**
 *  ����jquery��д
 */
(function($,window){

$.ajaxSetup({beforeSend:function(xhr){xhr.setRequestHeader("Request-Type", "ajax");},error:function(xhr, textStatus, errorThrown){debugger;$("#loadmask").hide();}});
$.fn.extend({isNotNull:function(){return !this.length==0}});
String.prototype.trim = function(value,icase){return this.replace(/(^\s+)|(\s+$)/g,"");}
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
window.aihb=aihb;
aihb.contextPath="/mvc";

/*----------------------------------  Ajax��װ   ** ����ϵͳʹ�ã��µ�ֱ��ʹ��jQuery.ajax----------------------------------------*/
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

/*----------------------------------  Grid����ת  ----------------------------------------*/
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
			,total : options.total || this.data.length//���±�����data��ʼ������
		}
		this.paging.limit=options.limit?(options.limit%this.paging.pageSize==0?options.limit:(options.limit/this.paging.pageSize+1)*this.paging.pageSize):510//limit������pageSize������
		/*if(this.paging.start!=1){
			this.paging.currentPage = parseInt(this.paging.start/this.paging.pageSize,10) + 1;
		}*/
		this.container = (typeof options.container == "string")?$("#"+options.container):options.container;
		this.colWidth = [];//�е���������table width�ж�
		this.needWidth=false;
		//this.calColWidth();���������жϣ���header���ж�
		this.wrapper=options.wrapper||{};
	},
	
	render : function() {
		$("#loadmask").show();
		/*if(this.container.childNodes[0])
			this.container.childNodes[0].parentNode.removeChild(this.container.childNodes[0])
		*/
		this.container.empty();
		this.container.hide();
		/* �����,����border�Ƚϴ� ��֪����ô��
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
		var _table =$('<table width="99%" class=grid-tab-blue align=center border=0 cellspacing="1" cellpadding="0" ></table>');
		this.container.append(_table);
		
		_table.append(this.getHeader());
		_table.append(this.getBody());
		
		if(this.needWidth)
			_table.attr("width",this.colWidth["_tableWidth"]);
		//alert(_table.outerHTML)
		//if(this.getPaging())
			this.container.append(this.getPaging());
		$("#loadmask").hide();
		this.container.fadeIn(200);
	},
	
	getBody : function  () {
		var _tbody = $("<tbody/>");
		var data = this.data;
		var _header = this.header;
		//debugger
		var rowseq = this.paging.pageSize*this.paging.currentPage-this.paging.start+1;
		//i<= ��Ϊ��ȡ�ϼ�ֵ
		for(var i=rowseq-this.paging.pageSize; i< (rowseq>data.length?data.length:rowseq)+(this.dataAmount?1:0); i++){
			//ȡ�ϼ�ֵ
			var aRow=null;
			if(i==data.length && this.dataAmount)
				aRow=this.dataAmount;
			/*else if(i==data.length && aRow.length==0)
				continue;*/
			else 
				aRow=data[i] || {};
				
			var _tr = $("<tr/>");
			_tbody.append( _tr );
			
			_tr.addClass(i%2 == 0?"grid_row_blue":"grid_row_alt_blue")
			.mouseover(function(){$(this).addClass("grid_row_over_blue");})
			.mouseout(function(){$(this).removeClass("grid_row_over_blue");});
			
			for(var j=0; j< _header.length; j++){
				
				if( _header[j].dataIndex in aRow){//���������ھͲ���td
					var _td = $("<td/>");
					_tr.append(_td);
					var cellNode = "";//ִ�е��ַ�
					
					if( _header[j].cellFunc && ( typeof _header[j].cellFunc == "function" || (typeof _header[j].cellFunc == "string" && _header[j].cellFunc.trim().length>0) ) ){
						cellNode = _header[j].cellFunc+"(aRow."+_header[j].dataIndex+",{record : aRow , data : data , rowIndex : "+i+" , columnIndex : "+j+"})";
						if(!_header[j].cellStyle)_header[j].cellStyle="grid_row_cell_number"
					}else{
						cellNode = "aRow."+_header[j].dataIndex;
					}
					_td.addClass( _header[j].cellStyle || "grid_row_cell" );
					//_td.appendChild( $CT(eval(cellNode))); // 2010-4-15�޸�cellFunc��Bug
					var _rest=null;//���еĽ��
					try{
						eval("_rest="+cellNode);
					}catch(e){
						//����ж�û������ if( _header[j].cellFunc && _header[j].cellFunc.trim().length>0)
						_rest="cellFunc�ķ�������nested exception is:"+e.message;
					}
					if ( _rest != null && typeof _rest == "object" ){//cellFunc����󷵻صĶ���
						_td.append( _rest);
					}else /*if (typeof _rest == "string")*/{//ֱ�����ַ����HTML
						_td.text(_rest);
					/*}else{//�п���������
						_td.appendChild( $CT(_rest));*/
					}
				}else if(_header[j].display && _header[j].display=="show"){
					var _td = $("<td/>");
					_tr.append(_td);
					var cellNode = "";
					if( _header[j].cellFunc ){
						cellNode = _header[j].cellFunc+"('',{record : aRow , data : data , rowIndex : "+i+" , columnIndex : "+j+"})";
					}
					_td.addClass( _header[j].cellStyle || "grid_row_cell");
					//_td.appendChild( $CT(eval(cellNode)));
					var _rest="";
					eval("_rest="+cellNode);
					if (typeof _rest == "object" && _rest != null){
						_td.append( _rest);
					}else{
						_td.text(eval(cellNode));
					}
				}
			}
		}
		return _tbody;
	},
	/**
	 *��ͷ�������������ӱ�ͷ�Ĺ���
	 * elementTd:�õ�Ԫ���TD����headData����ͷ����header[i]��headerRowIndex:���ϱ�ͷ����
	 */
	headerInterceptor: function(elementTd,headData,headerRowIndex){
	},
	
	getHeader : function(){
		var _grid = this;
		//var _tr = $("<tr/>");
		//_tr.addClass("grid_title_blue");
		var _thead = $("<thead/>");
		//_thead.appendChild(_tr);
		
		var _header = this.header;
		var data = this.dataAmount || this.data[0] || {};//ȡһ�����
		
		var _colWidth=this.colWidth;
		var isArray=typeof _header[0].name != "string";
		var _headerName= (isArray)?_header[0].name:[_header[0].name];
		var _headerMatrix=aihb.Util.headerMatrix(_header);
		
		//ר�Ŵ��������� ?��Ҫ�ж�����ȥcol��row��ֵ
		function displayProcess(matrix,row,col,data){
			
			if(!(_header[col].dataIndex in data)){
				matrix[row][col].display=false;
				var offsetCol=1;
				while(col>offsetCol){//�����������ǣ���Сspan.col��ֵ
					if(matrix[row][col].span==undefined && matrix[row][col-offsetCol].span){
						matrix[row][col-offsetCol].span.col--;
						break;
					}
					offsetCol++;
				}
			}
		}
		//����matrix ��������������
		for(var i=0; i<_headerMatrix.length; i++ ){
			for(var j=0;j<_headerMatrix[i].length;j++){
				displayProcess(_headerMatrix,i,j,data);
			}
		}
		
		//��Ҫ�жϱ��Ŀ�ȣ�
		this.calColWidth(_headerMatrix);
		for(var j=0;j<_headerName.length;j++){
			var _mTr=$("<tr/>");
			_mTr.addClass("grid_title_blue");
			_thead.append(_mTr);
			for(var i=0; i<_header.length; i++ ){
				var _element=_headerMatrix[j][i];
				if(_element.span && _element.display){
					var _td = $("<td/>");
					_mTr.append(_td);
					_td.addClass( "grid_title_cell");
					//_td.innerText=_element.text;
					_td.attr("colSpan",_element.span.col);
					_td.attr("rowSpan",_element.span.row);
					
					if(this.needWidth && _element.span.col==1){//��ݱ�ͷ�����ֲ������ж�һ��width�Ǹ���ȡ�Ǹ�
						_td.attr("width",_colWidth[_header[i].dataIndex]);
					}

					var order = "1";
					if(i==0&&j==0){
						order = _grid.order||"2";
					}
					_grid.order=_grid.order||"asc";//��grid������һ��order�ֶ�
					var _a = $("<a/>",{
						text:_element.text
						,id : _header[i].dataIndex
						,title : _header[i].title || "�������"
						,href:"javascript:void(0)"
						,click : function(){
							_grid.order=(_grid.order=="desc"?"asc":"desc");
							var _dataIndex=this.id;
							$("#loadmask").show();
							try{
								_grid.data.sort(function(_left,_right){
									var va1=eval("_right."+_dataIndex);
									var va2=eval("_left."+_dataIndex);
									//���Ӳ���ȫʡ�����������Ĺ���
									if(_right.city=='�ܼ�'||_right.city=='�ϼ�'||_right.city=='ȫʡ'||_right.city=='���� '){
										return 1;
									}else if(_left.city=='�ܼ�'||_left.city=='�ϼ�'||_left.city=='ȫʡ'||_left.city=='���� '){
										return 1;
									}
									if(!isNaN(va1-va2)){//��ֵ
										return (_grid.order=="desc"?1:-1)*(va1-va2);
									}else{//�ַ�
										if(_grid.order=="desc"){
											return va2.localeCompare(va1);
										}else{
											return va1.localeCompare(va2);
										}
									}
								});
							}catch(e){
								alert("ascii����");
								_grid.data.sort();//�������ֵ�ʱ����ascii����
							}
							_grid.render();
						}
					});
					try{
						if(event&&event.srcElement&&event.srcElement.id&&event.srcElement.id==_header[i].dataIndex){
							if(_grid.order=="asc"){
								_a.text(_a.text()+"��");
							}else{
								_a.text(_a.text()+"��");
							}
						}else if(order=="2" && i==0 && j==0){
							_a.text(_a.text()+"��");
						}
					}catch(e){console.log(e)}
					
					
					_td.append(_a);
					
					this.headerInterceptor(_td,_header[i],j);
				}
			}
		}
		return _thead;
	},
	
	calColWidth : function(headerMatrix){//��ݱ�ͷ�����ֺ���ݵĳ������ж�
		if(!("_tableWidth" in this.colWidth)){
			var data = this.data[0] || this.dataAmount || {};//ȡһ�����
			var _tableWidth=0;
			var _header=this.header;
			for(var i=0; i<_header.length; i++ ){
				
				//�õ�_headerText��ֵ
				var _element=headerMatrix[headerMatrix.length-1][i];
				var _headerTextLength=0;
				
				if(_element.text=="#rspan"){//��#rspan
				//debugger;
					var _temCout=headerMatrix.length-1;
					while((--_temCout)>=0){
						if(headerMatrix[_temCout][i].text.match("span")==null){
							_headerTextLength=parseInt(headerMatrix[_temCout][i].text.length/headerMatrix.length+0.99);//��_element.span.row>1 ���ֵĳ���Ӧ�ó���row�Ĵ�С
							break;
						}
					}
				}else if(_element.span && _element.span.col==1){//���ǿ��е�
					_headerTextLength=_element.text.length;
				}
				
				if(_header[i].dataIndex in data){//û������Ͳ���TD
					var _width=0;
					if(_headerTextLength>6){//�����ͷ����
						_width=(_headerTextLength-6)*12.2;
					}
					if(data[_header[i].dataIndex] && !aihb.Util.isNumber(data[_header[i].dataIndex])&& data[_header[i].dataIndex].length>6){//ͨ���һ�����������
						_width=_width>55?_width:55;//����ݱȽ��Ǹ���ȡ�Ǹ�
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
		var _wrapper=this.wrapper;
		var swichPage=function(){
			var _pageNum=parseInt($(this).attr("pageNum"),10);
			
			//debugger;
			//���ȼ����Ƿ���һ�������棬
			//�� between ��� ���
			//�� ֱ�Ӳ�ѯ
			var _a=_grid.paging.limit/_grid.paging.pageSize;//�������ҳһ��
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
		
		return aihb.Util.paging({
			currentPage: _grid.paging.currentPage
			,totalEl: _grid.paging.total
			,pageSize: _grid.paging.pageSize
			,createAElement :function(page,text){
				return $("<a>",{
					pageNum: page
					,text:text
					,href :"javascript:void(0)"
					,click:swichPage
				});
			}
		});
		
		/*
		var _elem ={};
		if(_grid.paging.currentPage > 1){
			_elem = $("<a>",{
				pageNum:_grid.paging.currentPage-1
				,href :"javascript:void(0)"
				,click:swichPage
			});
		}else {
			_elem = $("<span>",{"class":"disabled"});
		}
		_elem.html("��һҳ");
		_div.append(_elem);
		
		for(var i=0; i < _grid.paging.total/_grid.paging.pageSize; i++){
			if(i<2||i>_grid.paging.total/_grid.paging.pageSize-2 || (_grid.paging.currentPage>=i && _grid.paging.currentPage<=i+2)){
				if(_grid.paging.currentPage!=(i+1)){
					_elem = $("<a>",{
						pageNum:i+1
						,href :"javascript:void(0)"
						,click:swichPage
					});
				}else {
					_elem = $("<span>",{"class":"current"});
				}
				_elem.html(i+1);
			}else if(_elem.html()!="..."){
				_elem = $("<span>").html("...");
			}
			_div.append(_elem);
		}
		
		if(_grid.paging.currentPage < _grid.paging.total/_grid.paging.pageSize){
			_elem = $("<a>",{
				pageNum:_grid.paging.currentPage+1
				,href :"javascript:void(0)"
				,click:swichPage
			});
		}else {
			_elem = $("<span>",{"class":"disabled"});
		}
		_elem.html("��һҳ");
		_div.append(_elem);
		_elem=$("<span>").html(" �� "+_grid.paging.total+" ����¼��ÿҳ��ʾ "+_grid.paging.pageSize+" ��");
		_div.append(_elem);
		
		return _div;*/
	}
}

/*----------------------------------  Grid�İ�װ�� ----------------------------------------*/

/**
������Ƿֿ��ѯ��Gridʵ��
*/
if(typeof aihb.AjaxGrid == "undefined") aihb.AjaxGrid = {};
aihb.AjaxGrid = function() {this.initialize.apply(this,arguments);}

aihb.AjaxGrid.prototype = {
	
	initialize : function(options){
		var obj=this;
		var _sql = options.sql;
		_sql = strEncode(_sql);
		var _header = options.header;
		this.start=1;
		this.limit=options.limit||510;
		this.currentPage=1;
		
		this.ajax={
			url: aihb.contextPath+"/sqlQuery"
			,data : "qType=limit&start="+obj.start+"&limit="+obj.limit+"&sql="+encodeURIComponent(_sql) + (options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
			,type : "post"
			,dataType : "json"
			,success:function(res){
				var _elObj=$("#"+(options.el||"grid"));
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
						,pageSize : options.pageSize||30
					});
					obj.grid=_grid;
					_grid.paging.currentPage=obj.currentPage;
					_grid.render();
					if(options.callback)options.callback();
				}else{
					_elObj.append($("<span>").css({color:"red"}).html("�޼�¼!��ѡ����ȷ������"));
				}
			}
		};
	},
	
	run : function (){
		$("#loadmask").show();
		$.ajax(this.ajax);
	},
	
	request : function(options){
		//2010-4-14����BUG
		this.ajax.data=this.ajax.data.replace(/start=[0-9]+/,"start="+options.start);
		$("#loadmask").show();
		$.ajax(this.ajax);	
	}
}


if(typeof aihb.SimpleGrid == "undefined") aihb.SimpleGrid = {};
aihb.SimpleGrid = function() {this.initialize.apply(this,arguments);}

aihb.SimpleGrid.prototype = {
	
	initialize : function(options){
		var obj=this;
		var _sql = options.sql;
		_sql = strEncode(_sql);
		var _header = options.header;
		//this.limit=510;
		
		this.ajax = {
			url: aihb.contextPath+"/sqlQuery"
			,data : "sql="+encodeURIComponent(_sql) + (options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
			,type : "post"
			,dataType : "json"
			,success:function(res){
				var _elObj=$("#"+(options.el||"grid"));
				if(res != null){
					var _grid = new aihb.Grid({
						container : _elObj
						,data : res.data || res
						,limit : (res.data || res).length
						,dataAmount : res.dataAmount
						,total :  res.total
						,start :  res.start
						,header : _header
						,pageSize : options.pageSize||30
					});
					obj.grid=_grid;
					_grid.render();
					if(options.callback)options.callback();
				}else{
					_elObj.append($("<span>").css({color:"red"}).html("�޼�¼!��ѡ����ȷ������"));
				}
			}
		};
	},
	run : function (){
		$("#loadmask").show();
		$.ajax(this.ajax);
	}
}

/**
ֻ��ѯ��ǰ500����ݣ�����Ĳ��ֲ��ܣ�Ȼ����ʾһ���ж�����
 */
if(typeof aihb.PieceGrid == "undefined") aihb.PieceGrid = {};
aihb.PieceGrid = function() {this.initialize.apply(this,arguments);}
aihb.PieceGrid.prototype = {
		initialize : function(options){
			var obj=this;
			var _sql = options.sql;
			_sql = strEncode(_sql);
			var _header = options.header;
			var _rows = options.rows||500;
			
			this.ajax = {
				url: aihb.contextPath+"/sqlQuery"
				,data : "sql="+encodeURIComponent(_sql)+"&qType=piece&rows="+_rows+ (options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
				,type : "post"
				,dataType : "json"
				,success:function(res){
					var _elObj=$("#"+(options.el||"grid"));
					_elObj.empty().css("display","block");
					if(res != null){
						var _gridDiv=$("<div>");
						if(res.total>res.data.length){
							var tipDiv=$("<div>").css({textAlign:"center"}).append($("<span>").html("��������������"));
							tipDiv.append($("<span>").css({color:"red"}).html(res.total));
							tipDiv.append($("<span>").html("��,Ϊ�����ϵͳ��ѯ�ٶ�,Ŀǰֻ��ʾǰ"+res.data.length+"��"));
							
							_elObj.append(tipDiv);
						}
						_elObj.append(_gridDiv);
						
						var _grid = new aihb.Grid({
							container : _gridDiv
							,data : res.data
							,total :  (res.data || res).length
							,header : _header
							,pageSize : options.pageSize||30
						});
						obj.grid=_grid;
						_grid.render();
						if(options.callback)options.callback();
					}else{
						_elObj.append($("<span>").css({color:"red"}).html("�޼�¼!��ѡ����ȷ������"));
					}
				}
			};
		},
		run : function (){
			$("#loadmask").show();
			$.ajax(this.ajax);
		}
	}

/*----------------------------------  �������  ----------------------------------------*/
aihb.AjaxHelper={
	/*
	 {dataIndex:[names]} 
	*/
	transHeader : function(header,isOri){//��Grid�õ�header����ת���ַ���������
		if (typeof header == "string") {
			return header;
		}else if(header == undefined){
			return "";
		}else{
			var headObject={};//����
			for(var i=0;i<header.length;i++){
				var _header=header[i];
				headObject[_header.dataIndex.toLowerCase()]=[];
				var nameList = headObject[_header.dataIndex.toLowerCase()];
				if(typeof _header.name == "string"){//�ַ�����
					//_headerStr+="\""+header.dataIndex.toLowerCase()+"\":\""+encodeURIComponent(encodeURIComponent(header.name))+"\"";
					nameList.push(_header.name);
				}else if (typeof _header.name == "object"){//���ϱ�ͷ���?����#rspan��#cspan�滻������
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
			//�Ѷ���ת���ַ�����ʹ��Json2.js��������ʵ��
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
	
	down : function( options ){//form:�?, sql��sql���,header:��ͷ,fileName:���ص��ļ���,url:�������صĵ�ַ,ds:���Դ,useExcel:�Ƿ�����excel
		var _form=options.form || document.forms[0];
		
		if (!_form) {
			alert("û�б?");
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
					field = $("<input>",{name:name, type:'hidden'});
					$(form).append(field);
				}
				$(field).val( value);
			}
		};
		//��Ҫ����header SQL fileName ������ص�input
		if(options.sql!=undefined)
			var _sql = options.sql;
			_sql = _sql = strEncode(_sql);
			setFormField(_form,"sql",_sql);
		
		if(options.header!=undefined)
			setFormField(_form,"header",this.transHeader(options.header,(options.useExcel=="true" || options.useExcel==true)));
		
		if(options.ds!=undefined)
			setFormField(_form,"ds",options.ds);
			
		setFormField(_form,"fileName",options.fileName || document.title );
		
		var _url = options.url || aihb.contextPath+"/sqlQuery/down";
		
		if(options.useExcel=="true" || options.useExcel==true){//�Ƿ�ʹ��Excel ����
			if(_url.indexOf("?")>0){
				_url += "&";
			}else{
				_url += "?";
			}
			_url += "fileKind=excel";
		}
		
		$(_form).attr("action",_url);
		$(_form).attr("method","POST");
		//$(_form).attr("target","_top"); //����������Ҫ�����֤��target=_top ����ֱ���������iframe��ܣ�ֱ��ת��URL���������ҳ�棬����ע�͵���
		_form.submit();
	},
	
	parseCondition : function(){
		var _condition = "";
		
		$("dim").each(function(){
			var obj = undefined;
			eval("obj=document.forms[0]."+$(this).attr("name"))
			
			if(obj && $(this).attr("dbName") && ((obj.type!="checkbox"&&obj.value&&obj.value.length>0&&$(this).attr("name")!="city") || ($(this).attr("name")=="city"&&obj.value!="0") || obj.checked)){
				_condition +=" and " + $(this).attr("dbName");
				
				if($(this).attr("name")=="time" &&  $("#time_during").css("display")!="none"){//�ж���ʱ��λ���ʱ���
					_condition +=" between "
					var isVarchar=( $(this).attr("operType")=="" || $(this).attr("operType")=="varchar" );
					if(isVarchar)_condition +="'"
					_condition +=$("#time_from").val()
					if(isVarchar)_condition +="'";
					_condition +=" and ";
					if(isVarchar)_condition +="'";
					_condition +=$("#time").val()
					if(isVarchar)_condition +="'";
					
				}else if($(this).attr("operType")=="int"){
					_condition+="="+obj.value;
				}else if($(this).attr("operType")=="like"){
					_condition+=" like '%"+obj.value+"%'";
				}else if($(this).attr("operType")=="in"){
					_condition+=" in ("+obj.value+")";
				}else if($(this).attr("operType")=="between" && $("#from_"+$(this).attr("name")).val()!=""){
					_condition+=" between "+$("#from_"+$(this).attr("name")).val()+" and "+obj.value;
				}else if($(this).attr("operType")=="range"){
					_condition+=$("#range_"+$(this).attr("name")).val()+" "+obj.value;
				}else if($(this).attr("operType")=="split"){
					var arr=obj.value.split("_");
					_condition+=" between "+arr[0]+" and "+arr[1];
				}else{
					_condition+="='"+obj.value+"'";
				}
			}
		});
		return _condition;
	}
}

/*----------------------------------  �?����  ----------------------------------------*/
aihb.FormHelper = {
	fillElementSelect : function(options) {
		var data = options.data||[];
		var element = options.element||{};
		var defaultValue = options.defaultValue||"";
		element.disabled = true;
		/**/
		if(options.isHoldFirst){//��ɾ���һ��
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
		
		$.ajax({
			url: aihb.contextPath+"/sqlQuery"
			,data : "sql="+encodeURIComponent(options.sql)+(options.ds?"&ds="+options.ds:"") + (options.isCached!=undefined?"&isCached="+options.isCached:"")
			,type : "post"
			,dataType : "json"
			,async : !options.sync
			,success:function(data){
				aihb.FormHelper.fillElementSelect({
					data : data
					,isHoldFirst : options.isHoldFirst
					,element : options.element
				});
				
				if(options.callback)
					options.callback();
				}
		});
	},
	/**
		������ͨ�÷���
		@param selects: ���вμ�������HTMLSelect��ǩ����������,˳�����
		@param sqls: ���вμ�������sql�ַ�����,˳�����(sql����е�valueͨ���ַ�'#{value}'����)
		@param i: �����ļ���,˳���1��ʼ
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
		if(value==""||value=="0"){// ���ݵ�ֵΪ��һ�ȫʡ����ȫ���� �¼�����ѡ�������ֱ����Ϊ��һ�ȫ���� �������ύ��ݿ��ѯ
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
	  		
	  		this.fillSelectWrapper({element: _options.elements[_options.level],isHoldFirst:_isHold,sql:_value,ds: _options.ds,sync:_options.sync});
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
	
	//���򻯵�����������ʱ�����
	var bureauSuffix="";
	if($("#time") && $("#time").val()!=null){
		var _time=$("#time").val();
		if(_time.length==6){
			bureauSuffix="_"+_time;
		}else if(_time.length==8 && (new Date().format("yyyymm"))!=_time.substring(0,6)){
			bureauSuffix="_"+_time.substring(0,6);
		}
	}
	
	if(document.forms[0].county){
		_elements.push(document.forms[0].county);
		sqls.push("select county_code key, county_name value from mk.bt_area_all where area_code='#{value}' order by 1");
	}else if(document.forms[0].college){
		_elements.push(document.forms[0].college);
		sqls.push("select college_id key,college_name value from nwh.college_info"+bureauSuffix+" where area_id='#{value}' order by college_name");
	}else if(document.forms[0].county_bureau){
		_elements.push(document.forms[0].county_bureau);
		sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where area_code= '#{value}' and level=2 order by 1");
	}else if(document.forms[0].entCounty){
		_elements.push(document.forms[0].entCounty);
		sqls.push("select country_id key,org_name value from NMK.DIM_ent_AREAORG where country_id like '#{value}%' order by seq");
	}else if(document.forms[0].ent_grid_main){
		_elements.push(document.forms[0].ent_grid_main);
		sqls.push("select grid_id key,grid_name value from nmk.grid_tree_info where parentgrid_id = '#{value}' order by 1");
	}
	
	if(document.forms[0].office){
		_elements.push(document.forms[0].office);
		sqls.push("select site_id key,site_name value from nmk.RES_SITE where substr(site_id,1,8)='#{value}' order by site_name");
	}else if(document.forms[0].marketing_center){
		_elements.push(document.forms[0].marketing_center);
		sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where pid= '#{value}' order by 1");
	}else if(document.forms[0].ent_grid_sub){
		_elements.push(document.forms[0].ent_grid_sub);
		sqls.push("select grid_id key,grid_name value from nmk.grid_tree_info where parentgrid_id = '#{value}' order by 1");
	}
	
	if(document.forms[0].custmgr){
		_elements.push(document.forms[0].custmgr);
		sqls.push("select staff_id key,staff_id||staff_name value from NMK.DIM_ENT_STAFF_D where org_id='#{value}' order by 1");
	}else if(document.forms[0].town!= undefined){
		_elements.push(document.forms[0].town);
		//sqls.push("select region_id key,region_name value from kpi_bureau_cfg where parent_id= '#{value}' order by 1 with ur");
		sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where pid= '#{value}' order by 1");
	}else if(document.forms[0].ent_grid_micro){
		_elements.push(document.forms[0].ent_grid_micro);
		sqls.push("select grid_id key,grid_name value from nmk.grid_tree_info where parentgrid_id = '#{value}' order by 1");
	}
	
	if(document.forms[0].cell){
		_elements.push(document.forms[0].cell);
		sqls.push("select bureau_id key,bureau_name name from nwh.dim_bureau_cfg"+bureauSuffix+" where town_code='#{value}' order by 1");
		//sqls.push("select id key,name value from nwh.bureau_tree"+bureauSuffix+" where pid= '#{value}' order by 1 with ur");
	}
	
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
		,sync  : sync  
	});
}
window.areacombo=areacombo;

/*----------------------------------  ���߷���  ----------------------------------------*/
aihb.Util = {

	paging : function (options){
		var _div = $("<div>",{"class":"pagination"});
		var currentPage=options.currentPage||1;
		var totalEl=options.totalEl||0;
		var pageSize=options.pageSize||30;
		
		var createAElement = options.createAElement;
		
		var _elem ={};
		if(currentPage > 1){
			_elem = createAElement(currentPage-1,"��һҳ");
		}else {
			_elem = $("<span>",{"class":"disabled",text:"��һҳ"});
		}
		//_elem.html("��һҳ");
		_div.append(_elem);
		
		for(var i=0; i < totalEl/pageSize; i++){
			if(i<2||i>totalEl/pageSize-2 || (currentPage>=i && currentPage<=i+2)){
				if(currentPage!=(i+1)){
					_elem = createAElement((i+1),(i+1));
				}else {
					_elem = $("<span>",{"class":"current",text:i+1});
				}
				//_elem.html(i+1);
			}else if(_elem.html()!="..."){
				_elem = $("<span>",{text:"..."});
			}
			_div.append(_elem);
		}
		
		if(currentPage < totalEl/pageSize){
			_elem = createAElement(currentPage+1,"��һҳ");
		}else {
			_elem = $("<span>",{"class":"disabled",text:"��һҳ"});
		}
		_div.append(_elem);
		_elem=$("<span>",{text:" �� "+totalEl+" ����¼��ÿҳ��ʾ "+pageSize+" ��"});
		_div.append(_elem);
		
		return _div;
	},
	loadResource : function(uri,type){
		var _res=null;
		if(type=="css"){
			_res=$("<link/>",{type:"text/css",rel:"stylesheet",href:uri});
		}else{
			_res=$("<script/>",{type:"text/javascript",src:uri});
		}
		var container = document.getElementsByTagName("head")[0] || document.body;
		$(container).append(_res);
		
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
	
	headerMatrix : function(_header){//��header ת��һ����ά����(����),{span:{row:0,col:0},display:true,text:""}
		/** ���ͷ**/
		//��header ת��һ����ά����(����),{span:{row:0,col:0},display:true,text:""}
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
		
		//ר�Ŵ�����п���
		function spanProcess(matrix,row,col){
			if(matrix[row][col].text=="#rspan"){
				var _tmpCout=row;
				while( (--_tmpCout)>=0){
					if(matrix[_tmpCout][col].span){
						matrix[_tmpCout][col].span.row++;//��һ����count+1
						matrix[row][col].span=undefined;//��Ԫ����Ϊ��
						break;
					}
				}
			}else{
				var _tmpCout=col;
				while((--_tmpCout)>=0){
					if(matrix[row][_tmpCout].span){
						matrix[row][_tmpCout].span.col++;//��һ����count+1
						matrix[row][col].span=undefined;//��Ԫ����Ϊ��
						break;
					}
				}
			}
		}
		for(var i=0; i<_headerMatrix.length; i++ ){//����matrix ����span������
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
			formatDigit["1000"]="��";
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
		if(/[0-9]{11}/.test(value)){//�ֻ����
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
	
	loadmask : function(){
		var _loadmask=$("<div>",{id:"loadmask",style:"display:none"});
		var str='<div class="loadingmask">&#160;</div>'
				+'<div class="loading">'
					+'<div class="loading-indicator">'
						+'<span class="image"></span>&#160;���������Ժ�.....'
					+'</div>'
				+'</div>';
		_loadmask.html(str)
		if(document.body){
			_loadmask.prependTo($(document.body));
		}else{
			this.addEventListener(window,"load",function(){
				_loadmask.prependTo($(document.body));
			});
		}
	},
	
	windowMask : function(options){
		var _container =$("<div>");
		_container.html('<div style="width:100%;height:100%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>');
		_container.hide();
		var _content=$("<div>",{style:"position:absolute;left:20%;top:20%;padding: 3 px 10 px 5 px 10 px;z-index:100;background-color: #EFF5FB;border:1px solid #c3daf9;"});
		
		var _close=$("<div>",{style:"text-align:right;margin-bottom:2px;"});
		
		_close.html('<img src=\''+aihb.contextPath+'/resources/image/default/tab-close.gif\' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display=\'none\';}"></img>');
		_content.append(_close);
		_content.append(options.content);
		
		_container.append(_content);
		
		this.addEventListener(window,"load",function(){
			$(document.body).append(_container);
		});
		options.content.parentMask=_container;
		return _container;
	},
	
	watermark : function(){
		
		function addWaterMark(){
			var _waterMark=$("<div>",{id:"waterMark",style:"filter:alpha(opacity=8);opacity:0.08"})
			.css({
				backgroundImage:"url('"+aihb.contextPath+"/watermark')"
				,height:document.body.scrollHeight>document.body.clientHeight?document.body.scrollHeight:document.body.clientHeight
				,width:document.body.scrollWidth
				,position:"absolute"
				,zIndex:"-99999"
				,margin:"0"
				,left:0
				,top:0
			})
			.appendTo($(document.body));
		}
		/*
		if($("#waterMark")){
			var _waterMark=$("#waterMark");
			_waterMark.css("height",document.body.scrollHeight>document.body.clientHeight?document.body.scrollHeight:document.body.clientHeight);
			_waterMark.css("width",document.body.scrollWidth);
		}*/
		
		this.addEventListener(window,"load",function(){
			addWaterMark();
			//document.body.style.backgroundImage="url('/hb-bass-navigation/hbirs/action/watermark')";
		});
	},
	
	calDate : function(date){//����ͬ�Ȼ��ȵ�����
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

/*--------------------  BassDimHelper���  ----------------------------------*/
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

/*--------------------  FusionChart ��xml���  ----------------------------------*/
aihb.FusionChartHelper = {
	/*
	 * ��json��ʽת��fusionChart�ĸ�ʽ
	 * data�� SQLQuery���ص�json����
	 * idxSeq���������������
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
			decimalPrecision:"0",//С����λ��
			valueType : "",//�ٷֱȵ���ʽ��Ҫ��100
			trendlinesDisplayValue:"",
			trendlinesValue:"",
			dySeriesName : "",//Y������
			rotateNames:"0",
			fontSize:"12",
			ignoreMinMax:false,//�Ƿ���������С�Ŀ̶�����
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
				if(lines && lines.length>2&&options.setElement.length>0){ //����element
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
					options.trendlinesDisplayValue="Ŀ��";
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

/*--------------------  FusionChart ��xml���  ----------------------------------*/
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
		{cityId:"0",cityName:"ȫʡ",cityCode:"HB",regionCode:"27"}
		,{cityId:"11",cityName:"�人",cityCode:"HB.WH",regionCode:"270"}
		,{cityId:"15",cityName:"��ʩ",cityCode:"HB.ES",regionCode:"718"}
		,{cityId:"17",cityName:"�差",cityCode:"HB.XF",regionCode:"710"}
		,{cityId:"23",cityName:"����",cityCode:"HB.JM",regionCode:"724"}
		,{cityId:"26",cityName:"Т��",cityCode:"HB.XG",regionCode:"712"}
		,{cityId:"12",cityName:"��ʯ",cityCode:"HB.HS",regionCode:"714"}
		,{cityId:"14",cityName:"�˲�",cityCode:"HB.YC",regionCode:"717"}
		,{cityId:"18",cityName:"����",cityCode:"HB.JH",regionCode:"728"}
		,{cityId:"20",cityName:"����",cityCode:"HB.JZ",regionCode:"716"}
		,{cityId:"25",cityName:"�Ƹ�",cityCode:"HB.HG",regionCode:"713"}
		,{cityId:"13",cityName:"����",cityCode:"HB.EZ",regionCode:"711"}
		,{cityId:"16",cityName:"ʮ��",cityCode:"HB.SY",regionCode:"719"}
		,{cityId:"19",cityName:"����",cityCode:"HB.XN",regionCode:"715"}
		,{cityId:"24",cityName:"����",cityCode:"HB.SZ",regionCode:"722"}
		,{cityId:"27",cityName:"Ǳ��",cityCode:"HB.QJ",regionCode:"728"}
		,{cityId:"28",cityName:"����",cityCode:"HB.TM",regionCode:"728"}]
}


function timelineTip(data){
	var timelineValue = "";
	var run = "";
	var value = "";
	var cycle = "";
	var userId = "";
	var begintime = "";
	var endtime = "";
	var status = "";
	var creater = "";
	var runtime = "";
	var fenfaList = "";
	var check = "";
	if(data != null && data.timeline != null){
		timelineValue = data.timeline;
	}
	if(data != null && data.run != null){
		run = data.run;
		if(run=='1'){
			value = data.value;
			cycle = data.cycle;
			userId = data.userId;
			begintime = data.begintime.replace('.',':');
			endtime = data.endtime.replace('.',':');
			status = data.status;
			creater = data.creater;
			runtime = data.runtime;

		}
		check = data.check;
		fenfaList = data.fenfaList;
	}

	if(run=='1' && check=='2'){
		var tl = $("<div>");
		var tl_hold=$("<div>",{id:"tl_hold","class":"tl_banner",style:"cursor:pointer;line-height:26px;height:26px;position:absolute;right:0;top:0;filter:alpha(opacity=93);opacity: 0.93;width:180px;text-align:center;font-size:12px;",text:"�����ŵ"});
		tl_hold.append($("<c/>",{text:"��",style:"position:absolute;right:3;top:-3;font-size:10px;",title:"�رմ���"}).click(function(){
			tl.fadeOut(200);
		}));
	
		var tl_hold1=$("<div>",{id:"tl_hold1","class":"tl_banner",style:"cursor:pointer;font-size:12px;",text:"������Ϣ"});
		var tl_slide=$("<ul>",{id:"tl_slide","class":"tl_banner",style:"cursor:pointer;width:180px;float:left;"})
		tl_slide
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"Ԥ�Ƹ���ʱ��:"})).append($("<span>",{text:timelineValue,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"����:"})).append($("<span>",{text:value,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"���:"})).append($("<span>",{text:cycle,style:"color:#FF5500;text-align:left"}))
		)
		var tl_hold2=$("<div>",{id:"tl_hold2","class":"tl_banner",style:"cursor:pointer;font-size:12px;",text:"�������",title:"���չʾ"});
		tl_hold2.toggle(function () {
			tl_slide1[0].style.display = "";
	        $(this).attr('title','�������');
	    },function(){
	        tl_slide1[0].style.display = "none";
	         $(this).attr('title','���չʾ');
	    });
	
		
		var tl_slide1=$("<ul>",{id:"tl_slide","class":"tl_banner",style:"display:none;cursor:pointer;width:180px;right:0;"})
		tl_slide1
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"����״̬:"})).append($("<span>",{text:status,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"���?����:"})).append($("<span>",{text:userId,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"��������:"})).append($("<span>",{text:creater,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"���п�ʼʱ��:"})).append($("<span>",{text:begintime,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"�������ʱ��:"})).append($("<span>",{text:endtime,style:"color:#FF5500;text-align:left"}))
		)
		.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
				.append($("<span>",{text:"ƽ������ʱ��:"})).append($("<span>",{text:runtime,style:"color:#FF5500;text-align:left"}))
		)
		var tl_hold3=$("<div>",{id:"tl_hold2","class":"tl_banner",style:"cursor:pointer;font-size:12px;",text:"�ַ����",title:"���չʾ"});
		tl_hold3.toggle(function () {
			tl_slide2[0].style.display = "";
	        $(this).attr('title','�������');
	    },function(){
	        tl_slide2[0].style.display = "none";
	        $(this).attr('title','���չʾ');
	    });
		var tl_slide2=$("<ul>",{id:"tl_slide","class":"tl_banner",style:"display:none;cursor:pointer;width:180px;right:0;"})
		var length=fenfaList.length;
		if(length>0){
			for(var i=0;i<length;i++){
				var map = fenfaList[i];
				var intercode = map.intercode;
				var datecycle = map.datecycle;
				var exportstate = map.exportstate;
				var webstate = map.webstate;
				var exportrows = map.exportrows;
				var webloadrows= map.webloadrows;
				var web_time = map.web_time;
				tl_slide2
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"�ַ��ӿں�:"})).append($("<span>",{text:intercode,style:"color:#FF5500;text-align:left"}))
					)
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"�ַ����:"})).append($("<span>",{text:datecycle,style:"color:#FF5500;text-align:left"}))
				)
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"����״̬:"})).append($("<span>",{text:exportstate,style:"color:#FF5500;text-align:left"}))
				)
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"����״̬:"})).append($("<span>",{text:webstate,style:"color:#FF5500;text-align:left"}))
				)
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"��������:"})).append($("<span>",{text:exportrows,style:"color:#FF5500;text-align:left"}))
				)
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"��������:"})).append($("<span>",{text:webloadrows,style:"color:#FF5500;text-align:left"}))
				)
				.append(
					$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;text-align:left"})
						.append($("<span>",{text:"����ʱ��:"})).append($("<span>",{text:web_time,style:"color:#FF5500;text-align:left"}))
				)
			}
		}
		tl_hold.append(tl_hold1).append(tl_slide).append(tl_hold2).append(tl_slide1).append(tl_hold3).append(tl_slide2);
		tl.append(tl_hold).appendTo($(document.body));
	}else{
		var tl = $("<div>");
		
		var tl_hold=$("<div>",{id:"tl_hold","class":"tl_banner",style:"cursor:pointer;line-height:26px;height:26px;position:absolute;right:0;top:0;filter:alpha(opacity=93);opacity: 0.93;width:180px;text-align:center;font-size:12px;",text:"�����ŵ"});
		
		tl_hold.append($("<c/>",{text:"��",style:"position:absolute;right:3;top:-3;font-size:10px;",title:"�رմ���"}).click(function(){
			tl.fadeOut(200);
		}));
		
		var tl_slide=$("<ul>",{id:"tl_slide","class":"tl_banner",style:"cursor:pointer;width:180px;position:absolute;right:0;top:22px;filter:alpha(opacity=93);opacity: 0.93;"})
		tl_slide.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;"})
				.append($("<span>",{text:"Ԥ�Ƹ���ʱ��:"})).append($("<span>",{text:timelineValue,style:"color:#FF5500"}))
		)
	//	.append(
	//		$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;"})
	//			.append($("<span>",{text:"�����⣬�벦��\"�������ר��\""}))
	//	)
		
		tl.append(tl_hold).append(tl_slide).appendTo($(document.body));
	}
	
}

window.timelineTip=timelineTip;

//dialog�Ի���
if(typeof aihb.Dialog == "undefined") aihb.Dialog = {};
aihb.Dialog = function() {this.initialize.apply(this,arguments);}

aihb.Dialog.prototype = {
	initialize : function(options){
		this.uiDialog=$("<div/>",{"class":"dialog",id:"dialog_"+options.el}).appendTo(document.body)
		var container=$("<div/>").addClass("container");
		var tit = options.title;
		var title=$("<div/>",{text:tit}).addClass("titlebar").appendTo(container);
		var self = this;
		var close=$("<a/>",{title:"����ر�",text:"��",href:"javascript:void(0)",style:"position:absolute;right:10;top:0;font-weight:700;"})
			.click(function(){self.close();})
			.appendTo(title);
		
		
		var _element=(typeof options.el == "string")?_element=$("#"+options.el):options.el;
		
		container.append(_element);
		
		var hei = options.height;
		var wid = options.width;
		var _table = $('<table width="'+wid+'" height="'+hei+'" border="0" cellpadding="0" cellspacing="0"></table>')
		.append(
			$("<tr/>")
				.append($("<td/>",{rowspan:3}).append($("<em/>").addClass("trans left")))	
				.append($("<td/>").addClass("trans hori"))
				.append($("<td/>",{rowspan:3}).append($("<em/>").addClass("trans right")))
		)
		.append(
			$("<tr/>").append($("<td/>",{style:"border:1px solid #A0A0A0;"}).append(container))	
		)
		.append(
			$("<tr/>").append($("<td/>").addClass("trans hori"))
		)
		.appendTo(this.uiDialog);
		
		
		var mouseOverEl = options.mouseOverEl;
		if(mouseOverEl){
			var cst=null;
			mouseOverEl.mouseover(function(){
				var cX=event.clientX;
				var cY=event.clientY;
				cst=setTimeout(function(){
					var _hiddenDiv=self.uiDialog;
					if(_hiddenDiv.css("display")=="none"){
						_hiddenDiv.css("left",cX+document.body.scrollLeft- document.body.clientLeft - 130);
						
						var _newtop=cY+document.body.scrollTop- document.body.clientTop;
						if(_newtop+200>document.body.scrollHeight)_newtop-=60;
						_hiddenDiv.css("top", _newtop);
						self.open();
					}
				},800);
			});
			
			mouseOverEl.mouseout(function(){
				clearTimeout(cst);
			});
		};
		
	}
	,open:function(element){
		this.uiDialog.show(200);
	}
	
	,close:function(){
		this.uiDialog.hide(200);
	}
};

Date.prototype.format =function(formatstr){
var result = "";
var _year=this.getFullYear()+"";
var _month=(this.getMonth()+1)+"";
_month = (_month.length==1?"0":"")+_month;
var _date = this.getDate()+"";
_date = (_date.length==1?"0":"")+_date;
_hour = this.getHours()>9?this.getHours().toString():'0' + this.getHours();    
    _minute = this.getMinutes()>9?this.getMinutes().toString():'0' + this.getMinutes();  
    _second = this.getSeconds()>9?this.getSeconds().toString():'0' + this.getSeconds(); 
var format = arguments[0]||"yyyymmdd";
 format=format.toLowerCase();
  
switch (format) {
        case "yyyy-mm-dd" :
                result = _year + "-" + _month + "-" + _date;
                break;
        case "y-m-d" :
                result = _year + "-" + _month + "-" + _date;
                break;
        case "yyyy-mm":
                result =  _year + "-" + _month;
                break;
        case "dd/mm/yyyy":
                result = _date+ "/" + _month + "/" + _year;
                break;
        case "mm/dd/yyyy":
                result = _month +"/" +  _date + "/" + _year;
                break;
        case "mm/dd/yyyy hh:mm:ss":
                result = _month +"/" +  _date + "/" + _year +" "+_hour+":"+_minute+":"+_second;
                break;
        case "yyyy-mm-dd hh:mm:ss":
                result = _year +"-"+ _month +"-" + _date + " " +_hour+":"+_minute+":"+_second;
                break;
        case "yyyymm":
                result =  _year+ _month  ;
                break;
        case "yyyymmddhhmmss":
                result =  _year+ _month +_hour + _minute + _second ;
                break;
        case "yymm":
                result = _year.substr(2,2)+_month;
                break;
        case "yyyymmdd":
               result = _year + _month + _date ;
               break;
        default :
              var str=format;
              var strs=[];tf=null; op='';offtype='';offnum='';
              if(format.indexOf('yyyy-mm-dd')!=-1){offtype='d';tf='yyyy-mm-dd'; format=format.substr(10);  }
              else if (format.indexOf('yyyy-mm')!=-1){offtype='m';tf='yyyy-mm';format=format.substr(7); };
              if(format.indexOf('-')!=-1){op='-'; strs=format.split('-')}
              else if(format.indexOf('+')!=-1){op='+'; strs=format.split('+')};
              if(!tf) tf=strs[0]; 
              if(tf=='yyyymm') offtype='m' 
              else if(tf=='yyyymmdd') offtype='d'
              else if(tf=='yymm') offtype='m'
              else if(tf=='yy-mm') offtype='m';
              
              offnum=strs[1]||strs[0];
                
              return this.DateAdd(offtype.trim(),parseInt(op.trim()+offnum.trim())).format(tf.trim())
              
                //result = _year + _month + _date ;
        }
   return result;
};


})(jQuery,window);


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