<html>
<head>
<title>format</title>
<meta http-equiv="Expires" content="-1"/>
<meta http-equiv="Cache-Control" content="NO-CACHE"/>
<meta http-equiv="Pragma" content="NO-CACHE"/>	  
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js" charset="utf-8"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js" charset="utf-8"></script>
<script>
function showAttri(){
	var _cellInput=window.parent.Range.c;
	if(_cellInput){
		$("d2").innerHTML="";
		var eDataIndex=$C("<input type='text'>");
		
		var obj=_cellInput;
		eDataIndex.value=obj.dataIndex||"";
		eDataIndex.onchange=function(){
			obj.dataIndex=this.value
		}
		
		$("d2").appendChild($CT("����"));
		$("d2").appendChild(eDataIndex);
		$("d2").appendChild($C("br"));
		
		var eCellFunc=$C("<select></select>");
		eCellFunc.id="elemCellFunc";
		eCellFunc[0]=new Option("��","");
		eCellFunc[1]=new Option("����","aihb.Util.numberFormat");
		eCellFunc[2]=new Option("�ٷֱ�","aihb.Util.percentFormat");
		
		if(obj.cellFunc==undefined)
			obj.cellFunc="aihb.Util.numberFormat";
		
		for(var k=0;k<eCellFunc.length;k++){
			if(eCellFunc[k].value==obj.cellFunc){
				eCellFunc[k].selected=true;
				break;
			}
		}
		eCellFunc.onchange=function(){
			obj.cellFunc=this.value
			/*obj.cellFunc=this.value=="undefined"?undefined:this.value
			if(this.value=="aihb.Util.numberFormat"||this.value=="aihb.Util.percentFormat"){
				$("elemCellStyle").value="grid_row_cell_number";
			}*/
		}
		
		$("d2").appendChild($CT("��ʽ����ʽ"));
		$("d2").appendChild(eCellFunc);
		$("d2").appendChild($C("br"));
		
		
		var eCellStyle=$C("<select></select>");
		eCellStyle.id="elemCellStyle";
		
		if(obj.cellStyle==undefined)
			obj.cellStyle="grid_row_cell_number";
		
		eCellStyle[0]=new Option("�м����","")
		eCellStyle[1]=new Option("�����Ҷ���","grid_row_cell_number")
		eCellStyle[2]=new Option("���������","grid_row_cell_text")
		eCellStyle[3]=new Option("�����������","grid_row_cell_long_text")
		
		for(var k=0;k<eCellStyle.length;k++){
			if(eCellStyle[k].value==obj.cellStyle){
				eCellStyle[k].selected=true;
				break;
			}
		}
		eCellStyle.onchange=function(){
			obj.cellStyle=this.value;
			/*obj.cellStyle=this.value=="undefined"?undefined:this.value
			if(this.value=="grid_row_cell_text"||this.value==""){
				$("elemCellFunc").value="";
			}else if(this.value=="grid_row_cell_number"){
				$("elemCellFunc").value="aihb.Util.numberFormat";
			}*/
		}
		
		$("d2").appendChild($CT("���뷽ʽ"));
		$("d2").appendChild(eCellStyle);
		$("d2").appendChild($C("br"));
		
		
		
		var eTitle=$C("<input type='text'>");
		eTitle.value=obj.title||"";
		eTitle.onchange=function(){
			obj.title=this.value
		}
		
		$("d2").appendChild($CT("ָ��˵��"));
		$("d2").appendChild(eTitle);
		$("d2").appendChild($C("br"));
		
		
		var eCellFunc=$C("<input type='text'>");
		eCellFunc.value=obj.cellFunc||"";
		eCellFunc.onchange=function(){
			obj.cellFunc=this.value
		}
		
		$("d2").appendChild($CT("�Զ��庯��"));
		$("d2").appendChild(eCellFunc);
		$("d2").appendChild($C("br"));
		
	}
}

window.onload=function(){
	showAttri();
}

function ai() {
	var ow = window.parent;
	if (ow) {
		ow.aj();
	}
}
</script>
<body>
<div id="d2"></div>
<input type="button" onClick="ai();" value="ȷ��"/>
</body>
</html>

