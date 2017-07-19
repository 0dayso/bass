var _params = aihb.Util.paramsObj();

function naviFlat(container,datas){

	var table=container;
	var tbody=$C("tbody");
	var trHead=$C("tr");
	var trBody=$C("tr");
	
	var COLOR=["#B32017","#F1CC01","#019FC4","#94AA2E","#A7415F"];
	
	table.appendChild(tbody);
	tbody.appendChild(trHead);
	tbody.appendChild(trBody);
	for(var i=0; datas && i< datas.length;i++){
		if(datas[i].subjects){//û�ӱ���Ĳ�����
			var td=$C("td");
			td.width="200px";
			td.align="center";
			td.style.cssText="background:"+COLOR[i%5]+";color:#fff;height:30px;font-size:14px;";
			td.appendChild($CT(datas[i].name))
			trHead.appendChild(td);
			
			var subs=datas[i].subjects;
			td=$C("td");
			td.vAlign="top";
			
			for(var j=0;j<subs.length;j++){
				
				var div=$C("div");
				div.appendChild($CT(subs[j].name))
				div.title=subs[j].desc;
				div.style.cursor="hand";
				
				div.kind=subs[j].kind || subs[j].type;//Ϊtype����package
		
				if(subs[j].type && subs[j].type=="������"){//��package�������subject
					div.logParams="pid="+subs[j].id+"&"+_params._encoderOriUri.replace(/&pid=[0-9]+/,"");
				}else if(subs[j].kind=="�ֹ�"){
					div.uri=subs[j].uri;
					div.logParams="sid="+subs[j].id+"&"+_params._encoderOriUri;
				}else{
					div.logParams="sid="+subs[j].id+"&"+_params._oriUri;
				}
				
				div.onmouseover=function(){
					this.style.color="red";
				}
				if(subs[j].status!="����"){
					div.onmouseout=function(){
						this.style.color="";
					}
					
					div.onclick=function(){
						var _strUri=""
						if(this.kind=="�ֹ�"){
							_strUri=this.uri;
						}else if(this.kind=="��̬"){
							_strUri="/hb-bass-navigation/hbirs/action/dynamicrpt?method=render";
						}else if(this.kind=="����"){
							_strUri="/hb-bass-navigation/hbirs/action/confReport?method=render";
						}else if(this.kind=="������"){
							_strUri="/hb-bass-navigation/hbapp/app/rptNavigation/main_dropdown.htm";
						}
						
						if(_strUri.indexOf("?")>0){
							_strUri += "&";
						}else{
							_strUri += "?";
						}
						_strUri+=this.logParams;
						tabAdd({title:this.innerText,url:_strUri});
						if(this.uri!=undefined){
							aihb.AjaxHelper.log({params: this.logParams+"&opertype=query"});
						}
					}
				}else{
					div.style.color="#ccc";
					div.onmouseout=function(){
						this.style.color="#ccc";
					}
					div.onclick=function(){
						alert("�����С�����");
					}
				}
				td.appendChild(div);
			}	
			trBody.appendChild(td);
		}
	}
}

function naviTree(container,datas){
	var _table = container;
	for(var i=_table.childNodes.length-1;i>=0;i--){
		if(_table.childNodes[i])
			_table.childNodes[i].parentNode.removeChild(_table.childNodes[i]);
	}
	
	var _head=$C("thead");
	var _tr = $C("tr");
	_table.appendChild(_head);
	_head.appendChild(_tr);
	_tr.className="grid_title_blue";
	_tr.height=26;
	
	var _td1 = $C("td");
	var _td2 = $C("td");
	var _td3 = $C("td");
	
	_td1.width="50";
	_td1.className="grid_title_cell"
	_td1.innerText="���";
	
	_td2.width="250";
	_td2.className="grid_title_cell"
	_td2.innerText="�������";
	
	_td3.className="grid_title_cell"
	_td3.innerText="��������";
	
	_tr.appendChild(_td1);
	_tr.appendChild(_td2);
	_tr.appendChild(_td3);
	
	var _td4 = $C("td");
	_td4.width="60";
	_td4.className="grid_title_cell"
	_td4.innerText="�������";
	_tr.appendChild(_td4);
	
	function genCell(options){
		var aData=options.row;
		var _tbody=options.container;
		_tr = $C("tr");
		_tr.className="grid_row_alt_blue";
		_tr.height=26;
		_td1 = $C("td");
		_td2 = $C("td");
		_td3 = $C("td");
		_td1.className="grid_row_cell";
		
		if(options.seq){
			_td1.innerText=options.seq;
		}else{
			var _img=$C("img");_img.height=18;_img.width=18;
			_img.src="../../resources/image/default/"+(options.isBottom?"joinbottom.gif":"join.gif")
			_td2.appendChild(_img);
			_td2.appendChild($CT("  "));
		}
		_td2.className="grid_row_cell_text";
		var _a = $C("a");
		_a.href="javascript:void(0)";
		var name = aData.name;
		_a.kind=aData.kind || aData.type;//Ϊtype����package
		
		if(aData.type && aData.type=="������"){//��package�������subject
			_a.logParams="pid="+aData.id+"&"+_params._encoderOriUri.replace(/&pid=[0-9]+/,"");
		}else if(aData.kind=="�ֹ�"){
			_a.uri=aData.uri;
			_a.logParams="sid="+aData.id+"&"+_params._encoderOriUri;
		}else{
			_a.logParams="sid="+aData.id+"&"+_params._oriUri;
		}
		_a.onclick=function(){
			var _strUri=""
			if(this.kind=="�ֹ�"){
				_strUri=this.uri;
			}else if(this.kind=="��̬"){
				_strUri="/hb-bass-navigation/hbirs/action/dynamicrpt?method=render";
			}else if(this.kind=="����"){
				_strUri="/hb-bass-navigation/hbirs/action/confReport?method=render";
			}else if(this.kind=="������"){
				_strUri="/hb-bass-navigation/hbapp/app/rptNavigation/main_dropdown.htm";
			}
			
			if(_strUri.indexOf("?")>0){
				_strUri += "&";
			}else{
				_strUri += "?";
			}
			_strUri+=this.logParams;
			tabAdd({title:this.innerText,url:_strUri});
			if(this.uri!=undefined){
				aihb.AjaxHelper.log({params: this.logParams+"&opertype=query"});
			}
		}
		
		_a.innerText=name;
		_td2.appendChild(_a);
		
		_td3.className="grid_row_cell_text";
		if(aData.desc)
			_td3.innerText=aData.desc;
		else
			_td3.innerText="";
		
		_tr.appendChild(_td1);
		_tr.appendChild(_td2);
		_tr.appendChild(_td3);
		
		_td4 = $C("td");
		_td4.id="td_"+aData.id;
		_td4.className="grid_row_cell";
		_tr.appendChild(_td4);
		
		var _hiddenDiv=$C("div");
		_hiddenDiv.id="hd_"+aData.id;
		_hiddenDiv.className="selectarea";
		_hiddenDiv.style.display="none";
		
		var _text=$C("span");
		_text.id="te_"+aData.id;
		_text.innerText="0";
		_td4.appendChild(_text);
		_td3.appendChild(_hiddenDiv);
		_tbody.appendChild(_tr);
	}
	
	//debugger;
	var _tbody = $C("tbody");
	for(var i=0; datas && i< datas.length;i++){
		if(datas[i].subjects){
			var _tr=$C("tr");
			var _td=$C("td");
			_tr.className="grid_row_alt_blue";
			_tr.height=26;
			_td.className="grid_row_cell";
			_td.style.fontWeight="bold";
			_td.innerText=(i+1);
			_tr.appendChild(_td);
			
			_td=$C("td");
			_td.className="grid_row_cell_text";
			_td.style.fontWeight="bold";
			_td.innerText=datas[i].name;
			_td.colSpan=3;
			_tr.appendChild(_td);
			_tbody.appendChild(_tr);
			
			var _cSbjs=datas[i].subjects;
			for(var j=0;j<_cSbjs.length;j++){
				genCell({row : _cSbjs[j],container : _tbody, isBottom : (j+1==_cSbjs.length)});
			}
		}else{
			genCell({row : datas[i],container : _tbody,seq : (i+1)});
		}
	}
	_table.appendChild(_tbody);
}
