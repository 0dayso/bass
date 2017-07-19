cP=false;
var fonts='|宋体:宋体|黑体:黑体|隶书:隶书,monospace|楷体_gb2312:楷体_GB2312,monospace|幼圆:幼圆,monospace|Arial|Times New Roman|Courier New|Georgia|Trebuchet|Verdana'.split("|");
var dp=new Array(6,7,8,9,10,11,12,14,18,24,36);
var bK=new Array('合并单元格','拆分单元格');
var cg=null;
var bk='A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'.split(",");
function Z(i){
	i--;
	if(i<0)return "";
	if(i<26)return bk[i];
	return bk[parseInt(i/26)-1]+bk[i%26];
	
};
function ak(){
	cg=new Object();
	var t=$("xBody").childNodes[0];
	var lr=t.rows.length;
	var lc=t.rows[0].cells.length;
	for(var c=0;c<lc;c++){
		var kc=Z(c);
		cg[kc]=new Array();
		for(var r=0;r<lr;r++){
			cg[kc][r]={
				dZ:kc+String[r],rowSpan:1,colSpan:1
			};
			
		}
	}for(var r=0;r<lr;r++){
		var lc=t.rows[r].cells.length;
		for(var c=0;c<lc;c++){
			var e=t.rows[r].cells[c];
			var colSpan=Number(e.getAttribute("colSpan"));
			var rowSpan=Number(e.getAttribute("rowSpan"));
			var w=ah(c,r);
			var kc=Z(w.col);
			cg[kc][w.eM].colSpan=colSpan;
			cg[kc][w.eM].rowSpan=rowSpan;
			for(var i=0;i<rowSpan;i++){
				for(var j=0;j<colSpan;j++){
					if(i>0||j>0){
						var kc=Z(ah(c,r).col+j);
						if(i>0&&j>0){
							cg[kc][w.eM+i].colSpan=0;
							cg[kc][w.eM+i].rowSpan=0;
							
						}if(i==0&&j>0){
							cg[kc][w.eM+i].colSpan=0;
							if(rowSpan>1){
								cg[kc][w.eM+i].rowSpan=0;
								cg[kc][w.eM+i].colSpan=0;
								
							}
						}if(i>0&&j==0){
							cg[kc][w.eM+i].rowSpan=0;
							if(colSpan>1||rowSpan>1)cg[kc][w.eM+i].colSpan=0;
							
						}
					}
				}
			}
		}
	}
};
function ah(ci,ri){
	var t=$("xBody").childNodes[0];
	var lr=t.rows.length;
	var lc=t.rows[0].cells.length;
	var ii=-1;
	var s="";
	for(var c=0;c<lc;c++){
		var kc=Z(c);
		if(cg[kc][ri].colSpan>0)ii++;
		s+=cg[kc][ri].colSpan+",";
		if(ii>=ci){
			return {
				eM:ri,col:c
			};
			
		}
	}alert("程序错误BUG，请反馈给我们:"+ri+","+ii+">"+ci+"\n"+s);
	return {
		eM:0,col:0
	};
	
};
function ab(e){
	var r=e.parentNode.rowIndex;
	var c=e.cellIndex;
	var w=ah(c,r);
	return Z(w.col);
	
};
function ac(r,c){
	var i=-1;
	var ci=-1;
	for(var k in cg){
		i++;
		var kc=Z(i);
		if(cg[kc][r].colSpan>0)ci++;
		if(i>=c)break;
		
	}if(ci>0)return ci;
	
};
function U(){
	
};
function ax(e,t){
	var s="";
	var i=0;
	var h=4;
	var w=0;
	var ih=20;
	var f;
	var bf;
	var A;
	if(t==0){
		w=160;
		for(i=0;i<fonts.length;i++){
			f=fonts[i].split(":")[0];
			var dg=f;
			if(fonts[i].indexOf(":")>-1)dg=fonts[i].split(":")[1];
			h+=20;
			if(f==""){
				f="[无]";
				
			}s+='<span style="line-height:100%;cursor:hand;height:'+ih+'px;font-family:'+dg+';" onclick="aV(\''+dg+'\',\'fontFamily\');" class="tbmenu" onmouseover="this.className=\'tbmenuover\';" onmouseout="this.className=\'tbmenu\';">'+f+'</span><br>';
			
		}
	}if(t==1){
		w=70;
		for(i=0;i<dp.length;i++){
			h+=dp[i]*1.5+3;
			s+='<span style="line-height:100%;cursor:hand;height:'+(dp[i]*1.5+3)+'px;font-family:Arial;font-size:'+dp[i]+'pt;" onclick="aV(\''+dp[i]+'pt\',\'fontSize\');" class="tbmenu" onmouseover="this.className=\'tbmenuover\';" onmouseout="this.className=\'tbmenu\';">'+dp[i]+'</span><br>';
			
		}
	}if(t==2||t==3){
		var f="color";
		if(t==3)f="backgroundColor";
		w=300;
		h=220;
		s+='<iframe src="colorpad.htm?'+f+'" width=100% height=100%></iframe>';
		
	}if(t==4){
		s="<table CELLPADDING=0 CELLSPACING=0 border=0>";
		for(i=0;i<8;i++){
			if(i%4==0)s+="<tr>";
			s+='<td onclick="aV('+i+',\'|\');" onmouseover="this.style.borderColor=\'#FFFFFF\';" onmouseout="this.style.borderColor=\'#C3D9FF\';"  style="cursor:hand;font-size:10px;border:1px solid #C3D9FF;width:22px;height:22px;background-image:url(images/xcellbtn.gif);background-position:'+(-18*i-252)+'px;">&nbsp;</td>';
			if(i%4==3)s+="</tr>";
			
		}s+="</table>";
		w=90;
		h=50;
		
	}if(t==5){
		s="<table CELLPADDING=0 CELLSPACING=0 border=0>";
		for(i=0;i<6;i++){
			if(i%3==0)s+="<tr>";
			s+='<td onclick="aV('+i+',\'^\');" onmouseover="this.style.borderColor=\'#FFFFFF\';" onmouseout="this.style.borderColor=\'#C3D9FF\';"  style="cursor:hand;font-size:10px;border:1px solid #C3D9FF;width:22px;height:22px;background-image:url(images/xcellbtn.gif);background-position:'+(-18*i-126)+'px;">&nbsp;</td>';
			if(i%3==2)s+="</tr>";
			
		}s+="</table>";
		w=70;
		h=50;
		
	}if(t==6){
		f="&nbsp;<font size=-4 color=#555555>";
		var cK=$("bj").innerText;
		bf=new Array('插入行:在'+cK+'上面:insertRow:-1','追加行:在最下面:insertRow:1','插入列:在'+cK+'左边:al:-1','追加列:在最右边:al:1');
		w=130;
		for(i=0;i<bf.length;i++){
			h+=20;
			A=bf[i].split(":");
			s+='<span style="line-height:100%;cursor:hand;height:'+ih+'px;font-family:Arial;" onclick="'+A[2]+'(\''+A[3]+'\')" class="tbmenu" onmouseover="this.className=\'tbmenuover\';" onmouseout="this.className=\'tbmenu\';">'+A[0]+f+A[1]+'</font></span><br>';
			
		}
	}if(t==7){
		f="&nbsp;<font size=-4 color=#555555>";
		var eP="";
		var cK="";
		if(Range.c){
			eP="第"+Range.c.parentNode.rowIndex+"行";
			cK="第"+ab(Range.c)+"列";
			if(Range.S.ri1!=Range.S.ri2)eP="第"+Range.S.ri1+"到"+Range.S.ri2+"行";
			var cD=ah(Range.S.cD,Range.S.ri1).col;
			var cE=ah(Range.S.cE,Range.S.ri2).col;
			if(cD!=cE)cK="第"+Z(cD)+"到"+Z(cE)+"列";
			
		}bf=new Array('删除行:'+eP+':deleteRow:','删除列:'+cK+':Q:','删除内容::deleteContent:','删除格式::deleteFormate:');
		w=130;
		for(i=0;i<bf.length;i++){
			h+=20;
			var A=bf[i].split(":");
			s+='<span style="line-height:100%;cursor:hand;height:'+ih+'px;font-family:Arial;" onclick="'+A[2]+'(\''+A[3]+'\')" class="tbmenu" onmouseover="this.className=\'tbmenuover\';" onmouseout="this.className=\'tbmenu\';">'+A[0]+f+A[1]+'</font></span><br>';
			
		}
	}if(t==8){
		w=420;
		h=380;
		s+='<iframe src="format.htm" width=100% height=100%></iframe>';
		
	}if(t==9){
		w=420;
		h=280;
		s+='<iframe src="laputa.asp?wci=levitation&page=xcell.pagesetup" width=100% height=100%></iframe>';
		alert("配合 PAZU 可以设置纸张大小、方向、边距、指定打印机等等\n更多功能请登录http://www.laputac.com看实际应用");
		return ;
		
	}var p=ae(e);
	$("PopMenu").style.width=w+"px";
	$("PopMenu").style.height=h+"px";
	$("PopMenu").style.left=p.x+"px";
	$("PopMenu").style.top=p.y+e.offsetHeight+5+"px";
	$("PopMenu").innerHTML=s;
	$("PopMenu").style.display="block";
	
};
Range={
	c1:null,c2:null,c:null,m:false,S:{
		ri1:0,cD:0,ri2:0,cE:0
	},hide:function (){
		$("CellRang").style.display='none';
		
	},dF:function (){
		$("bi").style.display='none';
		$("CellEdt").style.display='none';
		
	},reset:function (e){
		e=Range.cC(e);
		if(e){
			Range.m=false;
			Range.dF();
			Range.c=e;
			Range.c1=e;
			Range.add(e);
			
		}
	},cC:function (e){
		if(e){
			var ci=e.cellIndex;
			var ri=e.parentNode.rowIndex;
			if(ci>0&&ri>0)return e;
			if(ci<1)ci=1;
			if(ri<1)ri=1;
			e=$('XBody').childNodes[0].rows[ri];
			
		}if(e)e=e.cells[ci];
		return e;
		
	},add:function (e){
		e=Range.cC(e);
		if(e){
			Range.c2=e;
			Range.eV(e);
			Range.show();
			
		}
	},eV:function (e){
		if(Number(e.getAttribute("colSpan"))>1||Number(e.getAttribute("rowSpan"))>1){
			if(!Range.m)Range.m=true;
			
		}
	},eY:function (e){
		if(!Range.c)return ;
		var s=e.value.fy();
		if(s.substring(0,1)=="="){
			Range.c.setAttribute("x:fmla",s);
			if(e.id=='bi')bu.value=s;
			
		}else {
			try{
				Range.c.removeAttribute("x:fmla");
				
			}catch(ex){
				
			}Range.c.innerText=e.value;
			if(e.id=='bi')bu.value=e.value;
			
		}
	},cY:function (){
		fe=false;
		if(!Range.c)return ;
		var e=$("bi");
		if(e.style.display=="none"){
			e.style.display="block";
			var fA=Range.c.getAttribute("x:fmla");
			if(!fA)fA=Range.c.innerText;
			e.value=fA;
			e.focus();
			Range.hide();
			
		}
	},fa:function (){
		if(!Range.c1)return ;
		var e=Range.c1;
		var p1=ae(e);
		var p2=ae(Range.c2);
		var x=p1.x;
		var y=p1.y;
		var w=e.offsetWidth;
		var h=e.offsetHeight;
		var ri=e.parentNode.rowIndex;
		var ci=e.cellIndex;
		if(e==Range.c2){
			Range.hide();
			
		}else {
			if(p2.x<p1.x){
				x=p2.x;
				w=Range.c2.offsetWidth;
				ci=Range.c2.cellIndex;
				
			}if(p2.y<p1.y){
				y=p2.y;
				h=Range.c2.offsetHeight;
				ri=Range.c2.parentNode.rowIndex;
				
			}
		}Range.c=$("xBody").childNodes[0].rows[ri].cells[ci];
		$("CellEdt").style.top=(y-$("xBody").scrollTop)+"px";
		$("CellEdt").style.left=(x-$("xBody").scrollLeft)+"px";
		$("CellEdt").style.width=Range.c.offsetWidth+"px";
		$("CellEdt").style.height=Range.c.offsetHeight+"px";
		$("CellEdt").style.display="block";
		$("CellEdt").childNodes[0].style.display="none";
		bi.className=Range.c.className;
		bi.style.cssText=Range.c.style.cssText+";overflow:hidden;width:100%;height:100%;border:0px;display:none;";
		Range.c.ondblclick=Range.cY;
		var fA=Range.c.getAttribute("x:fmla");
		if(!fA)fA=Range.c.innerText;
		bu.value=fA;
		$("bj").innerHTML=ab(Range.c)+(Range.S.ri1);
		aE();
		
	},show:function (){
		if(!Range.c1)return ;
		$("CellRang").style.display='block';
		if(Range.m){
			$("cr").innerText=bK[1];
			
		}else {
			$("cr").innerText=bK[0];
			
		}var p1=ae(Range.c1);
		var p2=ae(Range.c2);
		if(fe){
			var fW=document.body.offsetWidth-bT-p2.x+$("xBody").scrollLeft;
			if(fW>=0&&fW<=Range.c2.offsetWidth){
				$("xBody").scrollLeft+=Range.c2.offsetWidth;
				
			}else {
				fW=p2.x-$("xBody").scrollLeft-bw;
				if(fW<=0&&fW+Range.c2.offsetWidth>=0){
					$("xBody").scrollLeft-=Range.c2.offsetWidth;
					
				}
			}fW=document.body.offsetHeight-bv-bS-p2.y+$("xBody").scrollTop;
			if(fW>=0&&fW<=Range.c2.offsetHeight){
				$("xBody").scrollTop+=Range.c2.offsetHeight;
				
			}else {
				fW=p2.y-$("xBody").scrollTop-bG-bm;
				if(fW<=0&&fW+Range.c2.offsetHeight>=0){
					$("xBody").scrollTop-=Range.c2.offsetHeight;
					
				}
			}
		}if(p1.x>p2.x){
			var x=p1.x;
			p1.x=p2.x;
			p2.x=x;
			x=Range.c1.offsetWidth;
			Range.S.cD=Range.c2.cellIndex;
			Range.S.cE=Range.c1.cellIndex;
			
		}else {
			x=Range.c2.offsetWidth;
			Range.S.cD=Range.c1.cellIndex;
			Range.S.cE=Range.c2.cellIndex;
			
		}if(p1.y>p2.y){
			var y=p1.y;
			p1.y=p2.y;
			p2.y=y;
			y=Range.c1.offsetHeight;
			Range.S.ri1=Range.c2.parentNode.rowIndex;
			Range.S.ri2=Range.c1.parentNode.rowIndex;
			
		}else {
			y=Range.c2.offsetHeight;
			Range.S.ri1=Range.c1.parentNode.rowIndex;
			Range.S.ri2=Range.c2.parentNode.rowIndex;
			
		}var t=p1.y-$("xBody").scrollTop;
		var l=p1.x-$("xBody").scrollLeft;
		var w=p2.x-p1.x+x;
		var h=p2.y-p1.y+y;
		$("CellEdt").style.top=t+"px";
		$("CellEdt").style.left=l+"px";
		$("CellRang").style.top=t+"px";
		$("CellRang").style.left=l+"px";
		$("CellRang").style.width=w+"px";
		$("CellRang").style.height=h+"px";
		$("bj").innerHTML=(Range.S.ri2-Range.S.ri1+1)+"R x "+(Range.S.cE-Range.S.cD+1)+"C";
		
	},mm:function (ev){
		if(!fe)return ;
		ev=ev||window.event;
		var mousePos=as(ev);
		var p2=ae(Range.c2);
		p2.x=p2.x-$("xBody").scrollLeft;
		p2.y=p2.y-$("xBody").scrollTop;
		var ci=Range.c2.cellIndex;
		var ri=Range.c2.parentNode.rowIndex;
		var rs=$("xBody").childNodes[0].childNodes[0].childNodes;
		if(p2.x>mousePos.x){
			ci--;
			if(ci<0)ci=0;
			
		}if(p2.y>mousePos.y){
			ri--;
			if(ri<0)ri=0;
			
		}if(mousePos.y>p2.y+Range.c2.offsetHeight){
			ri++;
			if(ri>=rs.length)ri=rs.length-1;
			
		}if(mousePos.x>p2.x+Range.c2.offsetWidth){
			ci++;
			if(ci>=rs[ri].childNodes.length)ci=rs[ri].childNodes.length-1;
			
		}Range.add(rs[ri].childNodes[ci]);
		
	},dB:function (w){
		var ri=Range.c.parentNode.rowIndex;
		var ci=Range.c.cellIndex;
		var t=Range.c.parentNode.parentNode;
		switch(w){
			case "LF":if(ci>0){
				ci--;
				
			}break;
			case "UP":if(ri>0){
				ri--;
				
			}break;
			case "RT":if(ci<Range.c.parentNode.childNodes.length-1){
				ci++;
				
			}break;
			case "DN":if(ri<t.childNodes.length-1){
				ri++;
				
			}break;
			case "":
		}Range.reset(t.childNodes[ri].childNodes[ci]);
		fe=true;
		Range.show();
		fe=false;
		Range.fa();
		
	}
};
function aE(){
	var s=Range.c.className;
	if(s.indexOf("fb ")>-1)$("bZ").style.backgroundColor="#eeeeee";
	else $("bZ").style.backgroundColor="";
	if(s.indexOf("fi ")>-1)$("cb").style.backgroundColor="#eeeeee";
	else $("cb").style.backgroundColor="";
	if(s.indexOf("fu ")>-1)$("cd").style.backgroundColor="#eeeeee";
	else $("cd").style.backgroundColor="";
	if(s.indexOf("np ")>-1)$("NotPrt").style.backgroundColor="#eeeeee";
	else $("NotPrt").style.backgroundColor="";
	
};
function bb(eS){
	var pc="pazu://";
	var fL;
	if(!eS||eS=="")eS="template/blanktpl.xml";
	if(eS.substring(0,7).toLowerCase()==pc){
		fL=bX.eE(pazu.bx('readtpl("'+eS.split(pc)[1]+'")'));
		
	}else {
		var l=bg.dy();
		if(l){
			l.open("GET",eS,false);
			l.send(null);
			fL=l.responseXML;
			
		}
	}try{
		return fL.getElementsByTagName("TABLE")[0];
		
	}catch(ex){
		
	}
};
document.onselectstart=function (ev){
	ev=ev||window.event;
	var e=ev.srcElement?ev.srcElement:ev.target;
	if(e.id=='bi'||e.id=="bu"){
		return true;
		
	}return false;
	
};
function am(ev){
	ev=ev||window.event;
	var e=ev.srcElement?ev.srcElement:ev.target;
	var dK=false;
	if(e.id=='bi'||e.id=="bu"){
		dK=true;
		
	}switch(ev.keyCode){
		case 13:if(!ev.altKey){
			Range.dB("DN");
			
		}else {
			if(dK){
				e.value+="\r\n";
				
			}
		}break;
		case 37:if(dK)return ;
		Range.dB("LF");
		break;
		case 38:if(dK)return ;
		Range.dB("UP");
		break;
		case 39:if(dK)return ;
		Range.dB("RT");
		break;
		case 40:if(dK)return ;
		Range.dB("DN");
		break;
		default:if(dK)return ;
		Range.cY();
		
	}
};
var bD="bd";
var bG=80;
var bv=0;
var bm=20;
var bs=20;
var bq=80;
var bw=30;
var bF=0;
var bE=265;
var bT=20;
var bS=20;
var bQ=10;
var bp=0.8;
var eo=0;
var bl=new Array(200,200,200,200,200);
var cW=null;
var mouseOffset=null;
var function_c=null;
var function_r=null;
document.onmousedown=aq;
document.onmousemove=at;
document.onmouseup=au;
document.onkeydown=am;
var ee=0;
window.onresize=aB;
var lf;
var ft;
var fC=0;
function ag(){
	return fC++;
	
};
function bd(){
	aD();
	$("cr").innerText=bK[0];
	function_c=$("CR__").onmouseover;
	function_r=$("RR__").onmouseover;
	af();
	var fH=document.body.clientHeight;
	var fJ=document.body.clientWidth;
	var s='<div id="xHBar" style="position:absolute;z-index:200;BACKGROUND-COLOR:#FFFFFF;left:0px;top:0px;width:100%;height:'+bG+'px">'+document.body.innerHTML+'</div>';
	s+='<div id="xFBar" style="position:absolute;z-index:200;BACKGROUND-COLOR:#FFFFFF;left:0px;top:'+(fH-bv)+'px;width:100%;height:'+bv+'px"></div>';
	s+='<div class="xgh"   style="absolute;z-index:200;width:'+bw+'px;height:'+(bm)+'px;left:0px;top:'+bG+'px;"></div>';
	s+='<div id="PopMenu" style="display:none;position:absolute;border:2px outset;background-color:#C3D9FF;width:200px; left:165px; top:161px;overflow:hidden;z-index:1000"></div>';
	lf=(bw+eo);
	ft=(bm+bG+eo);
	var ht=(fH-bG-bm-bv);
	var fG=(fJ-bw);
	s+='<div id="xHead" class="xgh" style="absolute;z-index:99;width:'+fG+'px;height:'+bm+'px;left:'+lf+'px;top:'+bG+'px"><div style="margin-left:-1px;width:'+(26*26*2000)+';height:100%"></div></div>';
	s+='<div id="xFCol" class="xgh" style="absolute;z-index:99;width:'+bw+'px;height:'+ht+'px;top:'+ft+'px;left:0px"><div style="margin-top:-1px;width:100%"></div></div>';
	s+='<div id="xBody" onscroll="aJ();" class="xgrd" style="position:absolute;overflow:auto;top:'+ft+'px;left:'+lf+'px;height:'+ht+'px;width:'+fG+'px;"></div>';
	s+='<div id="CellRang" onmousemove="Range.mm();" ondblclick="Range.cY();" style="position:absolute;BACKGROUND-COLOR:#116AFF;FILTER:Alpha(Opacity=20);opacity:0.2;width:0px;height:0px;"></div>';
	s+='<div id="CellEdt" ondblclick="Range.cY();" style="display:none;position:absolute;BORDER: #3E3EFF 2px solid;"><textarea id="bi" style="overflow:hidden;width:100%;height:100%;border:0px;display:none;" onkeyup="Range.eY(this);"></textarea></div>';
	document.body.innerHTML=s;
	an(bo.fN);
	
};
function an(eS){
	var html=bb(eS);
	if(!html)html="";
	else html=html.xml;
	if(html==""){
		alert("对不起,表格格式有误.不能打开.");
		return ;
		
	}try{
		var nd=document.body.firstChild;
		while(nd){
			var dd=nd;
			nd=nd.nextSibling;
			if(dd.id){
				var s=dd.id.substring(0,3);
				if(s=="CR_"||s=="RR_"){
					document.body.removeChild(dd);
					
				}
			}
		}
	}catch(ex){
		
	}$("xBody").innerHTML=html;
	var i=0;
	var sr='';
	var lfz=1;
	var cs=$("xBody").childNodes[0].rows[0].cells;
	for(i=0;i<cs.length;i++){
		lfz+=cs[i].offsetWidth;
		sr+=N(cs[i].offsetWidth,bm,bG,lfz+lf,Z(i),"C",i);
		
	}$("xHead").childNodes[0].innerHTML=sr;
	sr='';
	var fw=ft;
	var rs=$("xBody").childNodes[0].rows;
	for(i=0;i<rs.length;i++){
		fw+=rs[i].offsetHeight;
		sr+=N(bw,rs[i].offsetHeight,fw,0,i,"R",i);
		
	}$("xFCol").childNodes[0].innerHTML=sr;
	ak();
	Range.hide();
	Range.dF();
	
};
function N(w,h,t,l,fA,R,i){
	var id=ag();
	var s='<div id="'+R+'H_'+id+'" class="xgh'+R+'" style="width:'+w+'px;height:'+h+'px">'+fA+'</div>';
	if(i==0)return s;
	var dv=document.createElement("div");
	dv.className="rszr"+R;
	dv.setAttribute("idx",String(i));
	dv.id=R+'R_'+id;
	document.body.appendChild(dv);
	dv.style.top=t+'px';
	dv.style.left=l+'px';
	if(R=="R"){
		dv.style.width=bw+'px';
		dv.onmouseover=function_r;
		
	}else {
		dv.style.height=bm+'px';
		dv.onmouseover=function_c;
		
	}return s;
	
};
var fe=false;
function aq(ev){
	ev=ev||window.event;
	var e=ev.srcElement?ev.srcElement:ev.target;
	var pe=e.parentNode;
	while(pe){
		if(pe.id=='xBody'){
			if(event.button==1)fe=true;
			Range.reset(e);
			return ;
			
		}pe=pe.parentNode;
		
	}if(e.id=='CellEdt'){
		if(event.button==1)fe=true;
		Range.reset(Range.c1);
		return ;
		
	}if(fe)return ;
	if(e.id.substring(0,3)=="CH_"){
		if(ev.button==1){
			aL($("CR_"+e.id.split("_")[1]).getAttribute("idx"),true);
			
		}return ;
		
	}if(e.id.substring(0,3)=="RH_"){
		if(ev.button==1){
			aM($("RR_"+e.id.split("_")[1]).getAttribute("idx"),true);
			
		}return ;
		
	}
};
function aB(){
	var fH=document.body.clientHeight;
	var fJ=document.body.clientWidth;
	if(fH<200)fH=200;
	var w=(fJ-bw);
	var h=(fH-bG-bm-bv);
	$("xHead").style.width=w+"px";
	$("xFCol").style.height=h+"px";
	$("xBody").style.width=w+"px";
	$("xBody").style.height=h+"px";
	$("xFBar").style.top=fH-bv+"px";
	
};
function af(){
	try{
		var cZ=document.createElement("DIV");
		cZ.id="asdf";
		cZ.style.width=100;
		cZ.style.height=100;
		cZ.style.overflow="scroll";
		cZ.style.position="absolute";
		cZ.style.visibility="hidden";
		cZ.style.top="0";
		cZ.style.left="0";
		document.body.appendChild(cZ);
		bT=$('asdf').offsetWidth-$('asdf').clientWidth;
		bS=$('asdf').offsetHeight-$('asdf').clientHeight;
		document.body.removeChild(cZ);
		delete cZ;
		
	}catch(ex){
		
	}
};
function ad(target,ev){
	ev=ev||window.event;
	var cU=ae(target);
	var mousePos=as(ev);
	return {
		x:mousePos.x-cU.x,y:mousePos.y-cU.y
	};
	
};
function ae(e){
	var left=0;
	var top=0;
	while(e.offsetParent){
		left+=e.offsetLeft;
		top+=e.offsetTop;
		e=e.offsetParent;
		
	}left+=e.offsetLeft;
	top+=e.offsetTop;
	return {
		x:left,y:top
	};
	
};
function at(ev){
	ev=ev||window.event;
	var e=ev.srcElement?ev.srcElement:ev.target;
	if(fe){
		var pe=e.parentNode;
		while(pe){
			if(pe.id=='xBody'){
				Range.add(e);
				break;
				
			}pe=pe.parentNode;
			
		}
	}var mousePos=as(ev);
	if(cW){
		cW.style.position='absolute';
		if(ee==1){
			var cH=$("CH_"+cW.id.split("_")[1]);
			var x=ae(cH).x;
			var fQ=mousePos.x-mouseOffset.x;
			if(fQ<x)fQ=x;
			if(fQ>document.body.clientWidth-10)fQ=document.body.clientWidth-10;
			cW.style.left=fQ;
			cH.style.width=fQ-x;
			aC();
			
		}if(ee==2){
			cW.style.top=mousePos.y-mouseOffset.y;
			var eN=$("RH_"+cW.id.split("_")[1]);
			var y=ae(eN).y;
			var fX=mousePos.y-mouseOffset.y;
			if(fX>document.body.clientHeight-bv-10)fX=document.body.clientHeight-bv-10;
			if(fX<y)fX=y;
			cW.style.top=fX;
			if(fX-y<1)eN.style.display="none";
			else eN.style.display="block";
			eN.style.height=fX-y;
			aC();
			
		}return false;
		
	}if(fe)return ;
	if(e.id.substring(0,3)=="CH_"){
		if(ev.button==1){
			aL($("CR_"+e.id.split("_")[1]).getAttribute("idx"));
			
		}return ;
		
	}if(e.id.substring(0,3)=="RH_"){
		if(ev.button==1){
			aM($("RR_"+e.id.split("_")[1]).getAttribute("idx"));
			
		}return ;
		
	}
};
function as(ev){
	if(ev.pageX||ev.pageY){
		return {
			x:ev.pageX,y:ev.pageY
		};
		
	}return {
		x:ev.clientX+document.body.scrollLeft-document.body.clientLeft,y:ev.clientY+document.body.scrollTop-document.body.clientTop
	};
	
};
function ao(item,md){
	if(!item)return ;
	ee=md;
	item.onmousedown=function (ev){
		cW=this;
		fd=ae(this);
		mouseOffset=ad(this,ev);
		return false;
		
	}
};
function aL(i,dS){
	var t=$("xBody").childNodes[0].childNodes[0];
	var rs=t.childNodes;
	if(dS){
		Range.reset(rs[0].childNodes[i]);
		
	}Range.add(rs[rs.length-1].childNodes[i]);
	Range.fa();
	
};
function aM(i,dS){
	var t=$("xBody").childNodes[0].childNodes[0];
	var rs=t.childNodes;
	if(dS){
		Range.reset(rs[i].childNodes[0]);
		
	}Range.add(rs[i].childNodes[rs[i].childNodes.length-1]);
	Range.fa();
	
};
function au(ev){
	ev=ev||window.event;
	var e=ev.srcElement?ev.srcElement:ev.target;
	aj(e);
	if(e.id=='bi'||e.id=='bu')return ;
	if(cW){
		try{
			if(ee==1){
				aF();
				aJ();
				
			}if(ee==2){
				aG();
				
			}
		}catch(ex){
			
		}cW=null;
		ee=0;
		
	}Range.fa();
	fe=false;
	
};
function aj(e){
	$("PopMenu").style.display="none";
	
};
function aC(w){
	var ns;
	var e;
	if(ee==1||w==1){
		ns=$("xHead").childNodes[0].childNodes;
		for(var i=1;i<ns.length;i++){
			var l=ae(ns[i]).x+ns[i].offsetWidth;
			e=$("CR_"+ns[i].id.split("_")[1]);
			e.style.left=l;
			e.setAttribute("idx",String(i));
			
		}
	}if(ee==2||w==2){
		ns=$("xFCol").childNodes[0].childNodes;
		for(var i=1;i<ns.length;i++){
			var t=ae(ns[i]).y+ns[i].offsetHeight-1;
			var e=$("RR_"+ns[i].id.split("_")[1]);
			e.style.top=t;
			e.setAttribute("idx",String(i));
			
		}
	}
};
function aG(){
	var i=cW.getAttribute("idx");
	var t=$("xBody").childNodes[0];
	var r=t.rows[i];
	var h=$("RH_"+cW.id.split("_")[1]).offsetHeight;
	if(h==0)r.style.display="none";
	else r.style.display="block";
	r.style.height=h+"px";
	var ii=i;
	var i1=Range.S.ri1;
	var i2=Range.S.ri2;
	if(i>=i1&&i<=i2&&i2-i1>0&&h>0){
		for(i=i1;i<=i2;i++){
			if(t.rows[i].offsetHeight!=0){
				t.rows[i].style.height=h+"px";
				$("xFCol").childNodes[0].childNodes[i].style.height=h+"px";
				
			}
		}
	}aJ();
	
};
function aF(){
	var i=cW.getAttribute("idx");
	var t=$("xBody").childNodes[0];
	var c=t.rows[0].cells[i];
	var w=t.offsetWidth;
	var l=c.offsetWidth;
	var bc=$("CH_"+cW.id.split("_")[1]).offsetWidth;
	var rs=t.rows;
	var ln=rs.length;
	if(bc==0){
		for(var j=0;j<ln;j++){
			if(j==0){
				rs[j].cells[i].style.width="0";
				
			}if(!document.all)rs[j].cells[i].style.display='none';
			
		}
	}else {
		for(var j=0;j<ln;j++){
			if(j==0){
				rs[j].cells[i].style.width=bc+"px";
				
			}rs[j].cells[i].style.display='';
			
		}var i1=Range.S.cD;
		var i2=Range.S.cE;
		var ii=i;
		if(i>=i1&&i<=i2&&i2-i1>0){
			for(i=i1;i<=i2;i++){
				for(var j=0;j<ln;j++){
					if(j==0&&i!=ii){
						if(rs[j].cells[i].offsetWidth!=0){
							w-=rs[j].cells[i].offsetWidth-bc;
							rs[j].cells[i].style.width=bc+"px";
							$("xHead").childNodes[0].childNodes[i].style.width=bc+"px";
							
						}
					}
				}
			}
		}
	}t.style.width=(w-l)+"px";
	aC(1);
	
};
function aJ(){
	var t=$("xBody").scrollTop;
	var l=$("xBody").scrollLeft;
	$("xFCol").childNodes[0].style.marginTop=((t*-1)+1)+"px";
	$("xHead").childNodes[0].style.marginLeft=((l*-1)+1)+"px";
	ee=2;
	aC();
	ee=1;
	aC();
	Range.show();
	
};
function al(w){
	var fI="";
	var t=$("xBody").childNodes[0];
	t.style.width=t.offsetWidth+bq+"px";
	var ci;
	var rs=t.rows;
	if(w=="1"){
		fI="afterEnd";
		ci=rs[0].cells.length-1;
		for(var i=0;i<rs.length;i++){
			var td=document.createElement("td");
			if(i==0){
				td.style.width=bq+"px";
				
			}rs[i].cells[rs[i].cells.length-1].insertAdjacentElement(fI,td);
			
		}
	}else {
		if(Range.c==null)return ;
		fI="beforeBegin";
		ci=ah(Range.c.cellIndex,Range.c.parentNode.rowIndex).col;
		var kc;
		for(var i=0;i<rs.length;i++){
			var c=ac(i,ci);
			kc=Z(ci);
			var ii=cg[kc][i].colSpan;
			var jj=cg[kc][i].rowSpan;
			if(ii>0){
				for(var j=0;j<jj;j++){
					var td=document.createElement("td");
					if(i==0){
						td.style.width=bq+"px";
						
					}rs[i+j].cells[ac(i+j,ci)].insertAdjacentElement(fI,td);
					
				}
			}if(ii==0){
				for(var j=ci;j>0;j--){
					kc=Z(j);
					if(cg[kc][i].colSpan>0){
						var e=t.rows[i].cells[ac(i,j)];
						if(e){
							if(Number(e.getAttribute("colSpan"))>1){
								e.setAttribute("colSpan",Number(e.getAttribute("colSpan"))+1);
								break;
								
							}
						}
					}
				}
			}
		}
	}ak();
	s=N(bq,bm,bG,0,0,"C",i);
	$("xHead").childNodes[0].childNodes[ci].insertAdjacentHTML(fI,s);
	for(i=ci;i<rs[0].childNodes.length;i++){
		$("xHead").childNodes[0].childNodes[i].innerText=Z(i);
		
	}aJ();
	
};
function deleteRow(){
	var S=Range.S;
	var t=$("xBody").childNodes[0];
	var ri1=S.ri1;
	var ri2=S.ri2;
	for(var ri=ri2;ri>=ri1;ri--){
		if(t.rows.length<3)break;
		T(ri,t);
		
	}Range.reset(t.rows[ri1-1].cells[1]);
	for(var i=ri1-1;i<t.rows.length;i++){
		$("xFCol").childNodes[0].childNodes[i].innerText=i;
		
	}ak();
	aJ();
	
};
function T(ri,t){
	var lc=t.rows[0].cells.length;
	for(var c=0;c<lc;c++){
		var kc=Z(c);
		var ii=cg[kc][ri].colSpan;
		if(ii==0){
			for(var r=ri;r>0;r--){
				if(cg[kc][r].colSpan>0){
					var e=t.rows[r].cells[ac(r,c)];
					if(e){
						if(Number(e.getAttribute("rowSpan"))>1){
							e.setAttribute("rowSpan",Number(e.getAttribute("rowSpan"))-1);
							
						}
					}
				}
			}
		}
	}var ox=new Object();
	for(var c=0;c<t.rows[ri].cells.length;c++){
		var e=t.rows[ri].cells[c];
		var rowSpan=Number(e.getAttribute("rowSpan"));
		var colSpan=Number(e.getAttribute("colSpan"));
		if(rowSpan>1||colSpan>1)ox[ah(c,ri).col]={
			rs:rowSpan,cs:colSpan
		};
		
	}t.deleteRow(ri);
	for(var c in ox){
		var td=document.createElement("td");
		td.setAttribute("colSpan",ox[c].cs);
		td.setAttribute("rowSpan",ox[c].rs-1);
		try{
			cg[Z(c)][ri+1].colSpan=ox[c].cs;
			cg[Z(c)][ri+1].rowSpan=ox[c].rs-1;
			if(ox[c].rs>1)t.rows[ri].cells[ac(ri+1,c)-1].insertAdjacentElement("afterEnd",td);
			
		}catch(ex){
			
		}
	}ak();
	var dv=$("xFCol").childNodes[0].childNodes[ri];
	var id=dv.id;
	dv.outerHTML="";
	$("RR_"+id.split("_")[1]).outerHTML="";
	
};
function insertRow(w){
	var fI="";
	var t=$("xBody").childNodes[0];
	var tr=document.createElement("tr");
	tr.style.height=bs;
	if(w=="1"){
		for(var i=0;i<t.rows[0].cells.length;i++){
			var td=document.createElement("td");
			tr.appendChild(td);
			
		}fI="afterEnd";
		t.rows[t.rows.length-1].insertAdjacentElement(fI,tr);
		ri=t.rows.length-2;
		
	}else {
		if(Range.c==null)return ;
		fI="beforeBegin";
		var ri=Range.c.parentNode.rowIndex;
		if(ri<0)return ;
		var oR=t.rows[ri];
		for(var i=0;i<oR.cells.length;i++){
			var td=document.createElement("td");
			var colSpan=Number(oR.cells[i].getAttribute("colSpan"));
			if(colSpan>1)td.setAttribute("colSpan",colSpan);
			tr.appendChild(td);
			
		}var lc=t.rows[0].cells.length;
		for(var c=0;c<lc;c++){
			var kc=Z(c);
			var ii=cg[kc][ri].colSpan;
			if(ii==0){
				for(var r=ri;r>0;r--){
					if(cg[kc][r].colSpan>0){
						var e=t.rows[r].cells[ac(r,c)];
						if(e){
							if(Number(e.getAttribute("rowSpan"))>1){
								e.setAttribute("rowSpan",Number(e.getAttribute("rowSpan"))+1);
								
							}
						}
					}
				}
			}
		}oR.insertAdjacentElement(fI,tr);
		
	}ak();
	var k=ri;
	var s=N(bw,bs,0,0,k+1,"R",k);
	$("xFCol").childNodes[0].childNodes[k].insertAdjacentHTML(fI,s);
	$("xBody").scrollTop+=bs;
	for(i=k;i<t.rows.length;i++){
		$("xFCol").childNodes[0].childNodes[i].innerText=i;
		
	}aJ();
	
};
function aO(e,t,r,c,S){
	var x=cg[Z(c)][r];
	if(x.colSpan<1)return ;
	var cD=0;
	var cE=0;
	cE=ah(S.cE,S.ri2).col;
	var ri2=S.ri2+cg[Z(cE)][S.ri2].rowSpan-1;
	cE+=cg[Z(cE)][S.ri2].colSpan-1;
	cD=ah(S.cD,S.ri1).col;
	var s="";
	if(!e)return ;
	s=e.className;
	var re1=r;
	var re2=e.parentNode.rowIndex+Number(e.getAttribute("rowSpan"))-1;
	var ce1=c;
	var ce2=c+x.colSpan-1;
	if(t==0){
		if(re2==ri2&&ce2==cE){
			s=aR(s);
			s+="s3 ";
			
		}else {
			if(ce2==cE){
				s=aS(s);
				
			}if(re2==ri2){
				s=aP(s);
				
			}
		}if(ce1==cD)aQ(e);
		if(re1==S.ri1)aT(e);
		
	}if(t==1){
		s=aR(s);
		if(ce1==cD)aQ(e,true);
		if(re1==S.ri1)aT(e,true);
		
	}if(t==2){
		if(s.indexOf("s3 ")>-1)return ;
		if(ce1<cE&&re1<ri2){
			s=aR(s);
			s+="s3 ";
			
		}else {
			if(ce1==cE&&re1<ri2){
				s=aP(s);
				
			}if(ce1<cE&&re1==ri2){
				s=aS(s);
				
			}
		}
	}if(t==3){
		s=aR(s);
		s+="s3 ";
		if(ce1==cD)aQ(e);
		if(re1==S.ri1)aT(e);
		
	}if(t==4){
		if(re1==S.ri1)aT(e);
		
	}if(t==5){
		if(re2==ri2){
			s=aP(s);
			
		}
	}if(t==6){
		if(ce1==cD)aQ(e);
		
	}if(t==7){
		if(ce2==cE){
			s=aS(s);
			
		}
	}e.className=s;
	
};
function aP(s){
	if(s.indexOf("s2 ")>-1||s.indexOf("s3 ")>-1)return s;
	if(s.indexOf("s1 ")>-1)s=s.replace("s1 ","s3 ");
	else s+="s2 ";
	return s;
	
};
function aS(s){
	if(s.indexOf("s1 ")>-1||s.indexOf("s3 ")>-1)return s;
	if(s.indexOf("s2 ")>-1)s=s.replace("s2 ","s3 ");
	else s+="s1 ";
	return s;
	
};
function aR(s){
	return s.replace("s0 ","").replace("s1 ","").replace("s2 ","").replace("s3 ","");
	
};
function aT(e,dI){
	if(!e)return ;
	var r=e.parentNode.rowIndex;
	var c=e.cellIndex;
	c=ah(c,r).col;
	r=r-1;
	var cs=$("xBody").childNodes[0].rows[r].cells;
	var ic=Number(e.getAttribute("colSpan"));
	for(var i=0;i<ic;i++){
		var el=cs[ac(r,c+i)];
		if(el){
			var s=el.className;
			if(dI){
				if(s.indexOf("s3 ")>-1)s=s.replace("s3 ","s1 ");
				s=s.replace("s2 ","");
				
			}else {
				if(s.indexOf("s1 ")>-1){
					s=s.replace("s1 ","s3 ");
					
				}else {
					if(s.indexOf("s3 ")>-1||s.indexOf("s2 ")>-1){
						
					}else {
						s+="s2 ";
						
					}
				}
			}el.className=s;
			
		}
	}
};
function aQ(e,dI){
	if(!e)return ;
	var rs=$("xBody").childNodes[0].rows;
	var ir=Number(e.getAttribute("rowSpan"));
	var r=e.parentNode.rowIndex;
	var c=ah(e.cellIndex,r).col;
	for(var i=0;i<ir;i++){
		var ci=c-1;
		if(ci!=0)ci=ac(r+i,c-1);
		var e1=rs[r+i].cells[ci];
		if(e1){
			var s=e1.className;
			if(dI){
				if(s.indexOf("s3 ")>-1)s=s.replace("s3 ","s2 ");
				s=s.replace("s1 ","");
				
			}else {
				if(s.indexOf("s2 ")>-1){
					s=s.replace("s2 ","s3 ");
					
				}else {
					if(s.indexOf("s1 ")>-1||s.indexOf("s3 ")>-1){
						
					}else {
						s+="s1 ";
						
					}
				}
			}e1.className=s;
			
		}
	}
};
function aN(e,v){
	var s=e.className;
	var io=Y(s);
	var ni=io;
	switch(v){
		case 0:if(io==1||io==2)ni=0;
		if(io==4||io==5)ni=3;
		if(io==7||io==8)ni=6;
		break;
		case 1:if(io==1||io==0)ni=2;
		if(io==3||io==4)ni=5;
		if(io==6||io==7)ni=8;
		break;
		case 2:if(io==0||io==2)ni=1;
		if(io==3||io==5)ni=4;
		if(io==6||io==8)ni=7;
		break;
		case 3:if(io==0||io==6)ni=3;
		if(io==1||io==7)ni=4;
		if(io==2||io==8)ni=5;
		break;
		case 4:if(io==3||io==6)ni=0;
		if(io==4||io==7)ni=1;
		if(io==5||io==8)ni=2;
		break;
		case 5:if(io==0||io==3)ni=6;
		if(io==1||io==4)ni=7;
		if(io==2||io==5)ni=8;
		break;
		
	}s=s.replace("a"+String(io)+" ","");
	if(ni>0)s+="a"+String(ni)+" ";
	e.className=s;
	
};
function Y(s){
	for(var i=0;i<9;i++){
		if(s.indexOf("a"+String(i)+" ")>-1){
			return i;
			
		}
	}return 0;
	
};
function aU(e,dk){
	var f=dk;
	var cn='mso-number-format:';
	var s=e.style.cssText.fy();
	if(f!=""){
		f=cn+f;
		
	}if(s==""){
		if(f!="")e.style.cssText=f;
		
	}else {
		var p1=s.toLowerCase().indexOf(cn);
		var p2=s.length;
		if(p1==-1){
			e.style.cssText=f+";"+s;
			
		}else {
			var c=0;
			for(var i=p1;i<p2;i++){
				if(s.substring(p1+i,p1+i+1)=="'")c++;
				if(c==2){
					p2=p1+i+1;
					break;
					
				}
			}e.style.cssText=f+";"+(s.substring(0,p1)+s.substring(p2,s.length));
			
		}
	}
};
function aV(v,n,x){
	var S=Range.S;
	var t=$("xBody").childNodes[0];
	var fF=null;
	var cD=0;
	var cE=0;
	cE=ah(S.cE,S.ri2).col;
	cD=ah(S.cD,S.ri1).col;
	var ri2=S.ri2+cg[Z(cE)][S.ri2].rowSpan-1;
	for(var r=S.ri1;r<=ri2;r++){
		for(var c=cD;c<=cE;c++){
			var e=t.rows[r].cells[ac(r,c)];
			if(e&&cg[Z(c)][r].colSpan>0){
				if(n=="#"){
					aU(e,v);
					
				}else {
					if(x){
						if(v==""){
							e.removeAttribute(n);
							
						}else {
							e.setAttribute(n,v);
							
						}
					}else {
						if(n==""||!n){
							var ss=e.className;
							var fE=v+" ";
							if(fE=="fb "||fE=="fu "||fE=="fi "||fE=="np "){
								if(fF==null){
									if(ss.indexOf(fE)>-1){
										fF="";
										
									}else {
										fF=fE;
										
									}
								}ss=ss.replace(fE,"");
								ss+=fF;
								
							}else {
								ss=ss.replace(v,"");
								ss+=v;
								
							}if(ss.fy()=="")ss="";
							e.className=ss;
							
						}else {
							if(n=="|"){
								aO(e,v,r,c,S);
								
							}else {
								if(n=="^"){
									aN(e,v);
									
								}else {
									e.style[n]=v;
									
								}
							}
						}
					}
				}
			}
		}
	}aE();
	
};
function aY(f){
	if(f.toLowerCase()=="general")f="";
	aV(f,"#",true);
	aj();
	
};
function split(){
	var S=Range.S;
	var t=$("xBody").childNodes[0];
	var cD=0;
	var cE=0;
	cE=ah(S.cE,S.ri2).col;
	cD=ah(S.cD,S.ri1).col;
	for(var r=S.ri1;r<=S.ri2;r++){
		for(var c=cD;c<=cE;c++){
			var cc=ac(r,c);
			if(cc){
				var e=t.rows[r].cells(cc);
				if(e){
					var ic=Number(e.getAttribute("colSpan"));
					var ir=Number(e.getAttribute("rowSpan"));
					for(var i=1;i<=ir;i++){
						if(i==1){
							for(var j=1;j<=ic;j++){
								if(j>1)t.rows[r].insertCell(ac(r,c)+1);
								
							}
						}if(i>1){
							for(var j=1;j<=ic;j++){
								t.rows[r+i-1].insertCell(ac(r+i-1,c)+1);
								
							}
						}
					}e.setAttribute("colSpan",1);
					e.setAttribute("rowSpan",1);
					if(ic>1||ir>1){
						ak();
						Range.fa();
						return ;
						
					}
				}
			}
		}
	}ak();
	Range.fa();
	
};
function ar(){
	if(Range.m){
		split();
		return ;
		
	}var S=Range.S;
	if(S.ri1==S.ri2&&S.cD==S.cE)return ;
	var cD=0;
	var cE=0;
	cE=ah(S.cE,S.ri2).col;
	cD=ah(S.cD,S.ri1).col;
	var rs=S.ri2-S.ri1+1;
	var cs=cE-cD+1;
	for(var r=S.ri2;r>=S.ri1;r--){
		for(var c=cE;c>=cD;c--){
			if(c>cD||r>S.ri1){
				try{
					var cc=ac(r,c);
					if(cc)$("xBody").childNodes[0].rows[r].deleteCell(cc);
					
				}catch(ex){
					
				}
			}
		}
	}if(rs>1)Range.c.setAttribute("rowSpan",rs);
	if(cs>1)Range.c.setAttribute("colSpan",cs);
	$("xBody").innerHTML=$("xBody").innerHTML;
	Range.reset($("xBody").childNodes[0].rows[S.ri1].cells[S.cD]);
	Range.fa();
	ak();
	
};
function Q(){
	var S=Range.S;
	var cD=ah(S.cD,S.ri1).col;
	var cE=ah(S.cE,S.ri2).col;
	for(var c=cE;c>=cD;c--){
		var t=$("xBody").childNodes[0];
		var cs=t.rows[0].cells;
		var w=cs[c].offsetWidth;
		if(cs.length<3)break;
		for(var r=0;r<t.rows.length;r++){
			var kc=Z(c);
			var x=cg[kc][r];
			if(x.colSpan==1){
				t.rows[r].deleteCell(ac(r,c));
				
			}if(x.colSpan>1){
				t.rows[r].cells[ac(r,c)].setAttribute("colSpan",x.colSpan-1);
				
			}if(x.colSpan==0){
				for(var i=c;i>=0;i--){
					x=cg[Z(i)][r];
					if(x.colSpan>1){
						var e=t.rows[r].cells[ac(r,i)];
						e.setAttribute("colSpan",x.colSpan-1);
						r=r+x.rowSpan-1;
						
					}
				}
			}
		}ak();
		t.style.width=t.offsetWidth-w;
		var dv=$("xHead").childNodes[0].childNodes[c];
		var id=dv.id;
		dv.outerHTML="";
		$("CR_"+id.split("_")[1]).outerHTML="";
		
	}Range.reset(t.rows[1].cells[c-1]);
	for(var i=c-1;i<cs.length;i++){
		try{
			$("xHead").childNodes[0].childNodes[i].innerText=Z(i);
			
		}catch(ex){
			
		}
	}ak();
	aJ();
	
};
function aX(s){
	$("xBody").childNodes[0].setAttribute("pagesetup",s);
	aj();
	
};
function exp(){
	alert("可以导出为:\n1.XML格式\n2.EXCEL格式\n3.HTML格式\n导出是客户端完成的，不需要通过服务器转换\n更多功能请登录http://www.laputac.com看实际应用");
	
};
function K(){
	var PR=$("xBody").childNodes[0].getAttribute("eD");
	if(!PR)return "";
	var P=eval("P__="+PR);
	if(!P.fs)return "";
	return P.fs;
	
};
function M(){
	cf.eF("xcell.exp");
	
};
function av(dW){
	if(confirm("新建或者打开表格前请先保存，\n\r如果你还没有保存数据，请点击[取消]进行数据保存后再新建，\n\r如果你已经保存了数据请点击[确定]。")){
		var s;
		if(dW){
			aZ();
			return ;
			F
		}an(s);
		
	}
};
function aZ(){
	alert("更多功能请登录http://www.laputac.com看实际应用");
	
};
function ba(){
	alert("可以导出为:\n1.XML格式\n2.EXCEL格式\n3.HTML格式\n导出是客户端完成的，不需要通过服务器转换\n更多功能请登录http://www.laputac.com看实际应用");
	
};
function save(eD){
	$("xBody").childNodes[0].setAttribute("eD",eD);
	var fv=V();
	fv=fv.aA('"','""');
	fv=fv.aA("\r\n"," ");
	fv=fv.aA("\r"," ");
	fv=fv.aA("\n"," ");
	var Pp=eval("Pp_="+eD);
	var ok=bX.eE(pazu.bx('savetpl("'+Pp.ec+'","'+Pp.fs+'","'+Pp.title+'","'+Pp.fz+'","'+Pp.version+'","'+fv+'","'+Pp.fB+'","'+Pp.eO+'")'),true);
	if(ok)alert("表格被成功保存到数据库.");
	
};
function aw(){
	av(true);
	
};
function aD(){
	var rule=G(".tblGenFixed TD");
	rule.style.borderRightColor="#ccc";
	rule.style.borderBottomColor="#ccc";
	var rule=G(".tblGenFixed .s1");
	rule.style.borderBottomColor="#ccc";
	var rule=G(".tblGenFixed .s2");
	rule.style.borderRightColor="#ccc";
	
};
function L(s){
	if(!Range.c)return ;
	try{
		Range.c.removeAttribute("x:fmla");
		
	}catch(ex){
		
	}Range.c.innerText=s;
	
};
function ay(){
	var ps=eval("ps_="+$("xBody").childNodes[0].getAttribute("pagesetup"));
	alert("配合 PAZU 可以实现即见即所得\n更多功能请登录http://www.laputac.com看实际应用");
	
};
var dR=false;
function az(){
	if(!dR)return ;
	try{
		fM.dA().location.reload();
		
	}catch(ex){
		
	}
}