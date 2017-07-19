// JavaScript Document
//������չ����
var $C = function(_tag){return document.createElement(_tag);}
var $ = function(_id){return document.getElementById(_id);}
String.prototype.trim = function(value,icase){return this.replace(/(^\s+)|(\s+$)/g,"");}
Array.prototype.indexOf = function(value){for(var i=0,l=this.length;i<l;i++)if(this[i]==value)return i;return -1;}
Array.prototype.Remove = function(value){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){return this.splice(i,1);}}
Array.prototype.Replace = function(value,source){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){this[i]=source;break;}}
Array.prototype.ReplaceAll = function(value,source){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){this[i]=source;}}
Array.prototype.Clear = function(){this.splice(0,this.length);}

var System = {};
System.UI = {} ;
System.UI.ntreeNode = SYSTEM_UI_NTREENODE;

//�������
function SYSTEM_UI_NTREENODE()
{
    indexCount++ ;
    classType = "SYSTEM_UI_NTREENODE";
    this.initialize.apply(this,arguments);
    
}
SYSTEM_UI_NTREENODE.prototype = {
    initialize:function(_parent,_text)//��ʼ���� _parent�Ǹ��ڵ� _text�Ǳ��ڵ���ı�
    {	
        this.top = _parent.top;
        this.parent = _parent;
        this._text = _text;
        this._expand = false;
        this.children = [];
        this.initElement();
        this.setElement();
        this.initEvent();
        this.text(_text);

        this.parent.children.push(this);
        //�����������¼���������
        this.resizeBar();
    },
    initElement:function()//��ʼ��Ԫ��
    {
        this.mainObj = $C("table");//�ڵ�������
        var otbody = $C("tbody");//tablebody
        var otr = $C("tr");//tr
        this.pikeTd = $C("td");//��������������
        this.beforeLineTd = $C("td") ;//�ڵ�ǰ������������
        this.infoTd = $C("td");//��������
        this.afterLineTd =$C("td") ;//�ڵ��(p1/p2)��������������
        this.childTd = $C("td");
        this.infoField = $C("span");//��������
        this.expandObj = $C("img");//չ��Ԫ��
        this.childField = $C("div");//�ӽڵ�����
        this.imgBar1 = this.createPike(1,1);//����������
        this.imgBar2 = this.createPike(8,2);//�ڵ�ǰ��������
        this.imgBar3 = this.createPike(8,2);//�ڵ����������
        this.mainObj.appendChild(otbody);
        
        //this.table = $(sid) ;
        
        otbody.appendChild(otr);
        //��
        with(otr)
        {
            appendChild(this.pikeTd);
            appendChild(this.beforeLineTd) ;
            appendChild(this.infoTd);
            appendChild(this.afterLineTd)  ;
            appendChild(this.childTd);
        }
        //��������
        this.infoTd.appendChild(this.infoField);
        if(indexCount != 1)
        	this.beforeLineTd.appendChild(this.imgBar2) ;
        with(this.afterLineTd){
        	appendChild(this.expandObj) ;
        	appendChild(this.imgBar3) ;
        }
        this.childTd.appendChild(this.childField);
        if(indexCount != 1)
        	this.pikeTd.appendChild(this.imgBar1);
        
        this.parent.childField.appendChild(this.mainObj);
    },
    setElement:function()//����Ԫ������
    {
        with(this.mainObj)
        {
            border = cellPadding = 0;
            cellSpacing = 0 ; 
            bgColor = "#FFFFFF";
        }
        this.pikeTd.vAlign = "middle";

        with(this.expandObj)
        {
            className = "expandObj";
            align = "absmiddle";
            //src = paths + "img/p1.gif";
            src = "img/p1.gif";
        }
       	
		this.infoField._instance = this;
		
		//����ӽڵ������Ϊ0�����չ����������
		if(dirNum == 0){
			this.afterLineTd.style.display = "none" ;

		}	
        this.childField.style.display = this.imgBar3.style.display = "none";
    },
    initEvent:function()//��ʼ���¼�
    {
        var self = this;
        
        this.expandObj.onclick = function()
        {	
			 self.top.selectNode(self);

			 var tid = aa.selectedNode.infoField.childNodes[0].id ;
			 //if(tid == "21" || tid == "23")
			 {
				if(self.imgBar3.style.display == "none"){
					if(aa.selectedNode.childField.innerHTML != ""){ 
						//����ӽڵ�
						aa.selectedNode.childField.innerHTML = "" ;
						aa.selectedNode.children = [] ;
					}
					var oNode = aa.selectedNode;
					var sCond = "";
					while(oNode.infoField)
					{
						sCond += " and "+oNode.infoField.childNodes[0].dim;	
						oNode = oNode.parent;
					}
					condition=sCond;
					//��ʾѡ��dim�Ի���	
					showTip() ; 
					//return ;	
        		}
        	}
            /*if(self.childField.innerHTML == ""){
            	var dirNameArray ;
            	var len ;
            	var pdim = aa.selectedNode.infoField.childNodes[0].dim  ;//selected node's dim
				dirNameArray = queryDirNumWithDim(tid,pdim) ;
				  //���ڵ�ID
        		var pnode_id = aa.selectedNode.infoField.childNodes[0].id ;
        		for(var i = 0 ; i<dirNameArray.length ;i++) {
					if(pnode_id == "0"){
				  		node_id = (i+1)+"" ;
					}else{
				  		node_id = pnode_id + (i+1) ;
					}
					aa.selectedNode.infoField.document.getElementById("getName").id = "getName"+j ;
				  	
					var table = createTable(node_id,dirNameArray[i],pdim) ;
					len = queryDirNumWithDim(node_id,pdim).length ;
					dirNum = len ;
					aa.selectedNode.addChild(table) ;

					fillData_compare(node_id,pdim,date,cityId,warningStyle,warningValue) ;
					j++ ;
        	 	}
            }*/
            self.expand(!self.expand());
        }

    },
    createPike:function(w,h)
    {
        var oImg = $C("img");
        with(oImg)
        {
            className = "exprline1";
            style.overflow = "hidden";
            style.width = style.height = "2px";
            width = height = 2;
            align = "absmiddle";
            //src = paths + "";
            if(typeof(w)=="number")style.width = w + "px";
            if(typeof(h)=="number")style.height= h + "px";
        }
        return oImg;
    },
    text:function(_text)//�޸ı��ڵ��ı��ķ���
    {
        if(typeof(_text)=="string" && _text.trim())
            this.infoField.innerHTML = this._text = _text;
        return this._text;
    },
    resizeBar:function()//���¼��������߳���
    {
        if(this.children.length>0)
        {
            var aa = null;
            if(this.children.length==1)
            {
                with(this.children[0])
                {
                    imgBar1.style.height = "2px";
                    pikeTd.vAlign = "middle";
                    
                }
                if(this.parent && typeof this.parent.resizeBar == "function")
                	this.parent.resizeBar();
                return ;
            }
            for(var i=0,l=this.children.length;i<l;i++)
            {
                var aa = this.children[i];
                aa.imgBar1.style.height = aa.imgBar1.style.width = "2px";
                aa.pikeTd.vAlign = "middle";
                aa.imgBar1.style.height = aa.pikeTd.offsetHeight + "px";//����߶�
            }
            var tempint = 0;
            aa = this.children[0];
            tempint = aa.pikeTd.offsetHeight;
            aa.imgBar1.style.height = [(tempint>>1) + (tempint&1) + 1,"px"].join('');
            aa.pikeTd.vAlign = "bottom";
            
            aa = this.children[this.children.length-1];
            tempint = aa.pikeTd.offsetHeight;
            aa.imgBar1.style.height = [(tempint>>1) + (tempint&1),"px"].join('');
            aa.pikeTd.vAlign = "top";
        }
        
        if(this.parent && typeof this.parent.resizeBar == "function")this.parent.resizeBar();
    },
    expand:function(value)//Ŀ¼չ������
    {
        if(typeof(value)=="boolean")
        {
            this._expand = value;
            this.imgBar3.style.display = this.childField.style.display = this._expand?"":"none";
            //this.expandObj.src = [paths,this._expand?"img/p2.gif":"img/p1.gif"].join('')
            this.expandObj.src = ["",this._expand?"img/p2.gif":"img/p1.gif"].join('')
            this.resizeBar();//���»���
        }
        return this._expand;
    },
    addChild:function(_text)//����ӽڵ�ķ��� _text���ӽڵ���ı�
    {
        new System.UI.ntreeNode(this,_text);
    },

    displayExpand:function(value)
	{
        if(typeof(value)=="boolean")
		{
			this._displayExpand = value;
            this.imgBar2.style.display = this.expandObj.style.display = this._displayExpand?"":"none";
		}
		return this._displayExpand;
	}
}

//����
System.UI.ntree = SYSTEM_UI_NTREE;
function SYSTEM_UI_NTREE()
{
    this.className = "SYSTEM_UI_NTREE";
    this.initialize.apply(this,arguments);
}
SYSTEM_UI_NTREE.prototype = {

    initialize:function(_container,_rootText)//��ʼ�����ķ��� _container������HTML����ʵ�� _rootText�Ǹ��ڵ���ı�
    {
        this.parent = this;
        this.top = this;
        this.childField = this.container = _container;
        this.childField.className = "ntree";
        this.children = [];
        this.rootNode = new System.UI.ntreeNode(this,_rootText);
        this.selectedNode = this.rootNode;
        this.selectNode();
    },
    selectNode:function(node)//ѡ�нڵ� ����ǰѡ�нڵ�����Ϊnode node�Ǳ��������ڵ��ʵ��
    {
        this.selectedNode = node;
    },
    resizeBar:function(){}
}


/************************       
							creatTable    
							
							
							*****************************/
function createTable(sid,name,dim){

      table = ""
		  + "<table id='"+sid+"' name="+name+" dim="+dim+" border='0' cellspacing='0' cellpadding='0' style='margin:5 px 0 px;'>"
		  + "	<tr>"
		  + "		<td>"
		  + "		<table background='./img/imc_11.gif' border='0' cellpadding='0' cellspacing='0' width='150'>"
		  + "			<tr>"
		  + "				<td height='22' width='2'></td>"
		  + "				<td id='getName' style='font-weight:bold;font-size: 12px; color: rgb(215, 227, 244); padding-top: 6px;' align='center' width='110'>"
		  + 				name+"</td>"
		  + "				<td style='padding-top: 6px;' align='left' valign='top' width='2'>"
		  + "				</td>"
		  + "			</tr>"
		  + "		</table>"
		  + "		<table background='./img/imm_04.png' border='0' cellpadding='0' cellspacing='0' height='3' width='150'>"
		  + "			<tr>"
		  + "				<td height='3'></td>"
		  + "			</tr>"
		  + "		</table>"
		  + "		<table border='0' cellpadding='0' cellspacing='0' width='150'>"
		  + "			<tr>"
		  + "				<td align='center' valign='top'>"
		  + "				<table  background='./img/imc_13.gif' border='0' cellpadding='0' cellspacing='0' width='150'>"
		  + "					<tr>"
		  + "						<td style='font-weight:bold;font-size: 12px; color: rgb(88, 118, 160);' align='left' height='20'>&nbsp; "
		  + "						<span id="+sid+"t1f1 ></span></td>"
		  + "                       <td ><img id="+sid+"pt1  src='images/right.gif' border='0'></img></td>"
		  + "                       <td width='3%'></td>"
		  + "					</tr>"
		  + "					<tr style='display:none'>"
		  + "						<td style='font-weight:bold;font-size: 12px; color: rgb(88, 118, 160);' align='left' height='20'>&nbsp; "
		  + "						<span id="+sid+"t1f2 ></span></td>"
		  + "                       <td id="+sid+"pt2 ></td>"
		  + "                       <td width='3%'></td>"
		  + "					</tr>"
		  + "					<tr style='display:none'>"
		  + "						<td style='font-weight:bold;font-size: 12px; color: rgb(88, 118, 160);' align='left' height='20'>&nbsp; "
		  + "						<span id="+sid+"t1f3 ></span></td>"
		  + "                       <td id="+sid+"pt3 ></td>"
		  + "                       <td width='3%'></td>"
		  + "					</tr>"		  
		  + "					<tr>"
		  + "						<td colspan='3' background='./img/imc_18.gif'>"
		  + "						<div title='�鿴��ϸ' style='padding: 0px; font-size: 12px; margin-left: 3px; margin-right: 3px; margin-top: 0px; text-align: left;'>"
		  + "							<img style='cursor:hand;' onclick='showBox(this)' src='./img/imc_22.gif'></div>"
		  + "						</td>"
		  + "					</tr>"
		  + "					<tr style='display:none'>"
		  + "						<td colspan='3' background='./img/imc_18.gif'>"
		  + "						<div style='padding: 0px; font-size: 12px; margin-left: 3px; margin-right: 3px; margin-top: 0px; text-align: left;'>"
		  + "							<img style='cursor:hand;' onclick='hiddenBox(this)' src='./img/imc_23.gif'></div>"
		  + "						</td>"
		  + "					</tr>"
		  + "				</table>"
		  + "				</td>"
		  + "				<tr><td background='./img/imc_18.gif'><img src='./img/imc_20.gif'></td></tr>"
		  + "			</tr>"
		  + "			</td>"
		  + "			</tr>"
		  + "		</table>"
		  + "		</td>"
		  + "	</tr>"
		  + "</table>";
    return table ;
}
	
function initTable(name){
	indexCount = 0 ;
 	table = ""
		  + "<table id='0' name='"+name+"' border='0' dim='1=1' cellspacing='0' cellpadding='0'>"
		  + "	<tr>"
		  + "		<td>"
		  + "		<table background='./img/imc_11.gif' border='0' cellpadding='0' cellspacing='0' width='150'>"
		  + "			<tr>"
		  + "				<td height='22' width='2'></td>"
		  + "				<td id='getName' style='font-weight:bold;font-size: 12px; color: rgb(215, 227, 244); padding-top: 6px;' align='center' width='150'>"
		  + "				"+name+"</td>"
		  + "				<td style='padding-top: 6px;' align='left' valign='top' width='2'>"
		  + "				</td>"
		  + "			</tr>"
		  + "		</table>"
		  + "		<table background='./img/imm_04.png' border='0' cellpadding='0' cellspacing='0' height='3' width='150'>"
		  + "			<tr>"
		  + "				<td height='3'></td>"
		  + "			</tr>"
		  + "		</table>"
		  + "		<table border='0' cellpadding='0' cellspacing='0' width='150'>"
		  + "			<tr>"
		  + "				<td align='center' valign='top'>"
		  + "				<table  background='./img/imc_13.gif' border='0' cellpadding='0' cellspacing='0' width='150'>"
		  + "					<tr>"
		  + "						<td style='font-weight:bold; font-size: 12px; color: rgb(88, 118, 160);' align='left' height='20'>&nbsp;"
		  + "						<span id='0t1f1'></span></td>"
		  + "                       <td ><img id='0pt1' src='images/right.gif' border='0'></img></td>"
		  + "					</tr>"
		  + "					<tr style='display:none'>"
		  + "						<td style='font-weight:bold;font-size: 12px; color: rgb(88, 118, 160);' align='left' height='20'>&nbsp; "
		  + "						<span id='0t1f2'></span></td>"
		  + "                       <td id='0pt2'></td>"
		  + "                       <td></td>"
		  + "					</tr>"
		  + "					<tr style='display:none'>"
		  + "						<td style='font-weight:bold;font-size: 12px; color: rgb(88, 118, 160);' align='left' height='20'>&nbsp; "
		  + "						<span id='0t1f3'></span></td>"
		  + "                       <td id='0pt3'></td>"
		  + "                       <td></td>"
		  + "					</tr>"
		  + "					<tr>"
		  + "						<td colspan='3' background='./img/imc_18.gif'>"
		  + "						<div title='�鿴��ϸ' style='padding: 0px; font-size: 12px; margin-left: 3px; margin-right: 3px; margin-top: 0px; text-align: left;'>"
		  + "							<img style='cursor:hand;' onclick='showBox(this)' src='./img/imc_22.gif'></div>"
		  + "						</td>"
		  + "					</tr>"
		  + "					<tr style='display:none'>"
		  + "						<td colspan='3' background='./img/imc_18.gif'>"
		  + "						<div style='padding: 0px; font-size: 12px; margin-left: 3px; margin-right: 3px; margin-top: 0px; text-align: left;'>"
		  + "							<img style='cursor:hand;' onclick='hiddenBox(this)' src='./img/imc_23.gif'></div>"
		  + "						</td>"
		  + "					</tr>"
		  + "				</table>"
		  + "				</td>"
		  + "				<tr><td background='./img/imc_18.gif'><img src='./img/imc_20.gif'></td></tr>"
		  + "			</tr>"
		  + "			</td>"
		  + "			</tr>"
		  + "		</table>"
		  + "		</td>"
		  + "	</tr>"
		  + "</table>";
     return table ;
}


/*****************************     
							query   
							
							
							*********************************/
var oPopup = window.createPopup();
function tip (sTitle)
{
  var oPopupBody = oPopup.document.body;
  oPopupBody.style.cssText = "margin:3px;padding:3px;overflow:hidden ;font-size:12 px;font-weight: bold;background-color: #EFF5FB;border:1px solid #c3daf9;filter:alpha(opacity=80);"; 
  oPopupBody.innerHTML = sTitle;
  oPopup.show(10, 10, 200, 80, event.srcElement);   
}

function fillData(options){
	var arr = options.data;
	
	var prefix="";
	var curValueName="";
	if(sDate.length==8)
	{
		curValueName ="����:";
		if(curCompareName=="����")prefix="ǰ��:";
		else if(curCompareName=="ͬ��")prefix="����:";
		else if(curCompareName=="��ͬ��")prefix="ȥ��:";
	}
	else if(sDate.length==6)
	{
		curValueName ="����:";
		if(curCompareName=="����")prefix="����:";
		else if(curCompareName=="ͬ��")prefix="ȥ��:";
	}
	
	var sTitle = "<div style='font-size:13 px;height:21 px'>"+arr[1]+"</div><div style='height:18 px'>"+curValueName+cellformat[0](arr[2])+"</div><div style='height:18 px'>"+prefix+cellformat[1](arr[3]);
	sTitle+="</div><div style='height:18 px'>"+curCompareName+":"+cellformat[2](arr[4])+"</div>";
	//document.getElementById(options.node_id+"t1f3").title =sTitle;
	var obj = document.getElementById(options.node_id+"t1f1");
	obj.onmousemove=function(){tip(sTitle);};
	
	document.getElementById(options.node_id+"t1f1").innerText = curCompareName+":"+cellformat[2](arr[4]) ;
	
	document.getElementById(options.node_id+"t1f2").innerText = "����:"+cellformat[0](arr[2]);
	document.getElementById(options.node_id+"t1f3").innerText = "ǰ��:"+cellformat[0](arr[3]);
	
	if(arr[4]>0.05)document.getElementById(options.node_id+"pt1").src="images/up.gif";
	else if(arr[4]<-0.05)document.getElementById(options.node_id+"pt1").src="images/down.gif";			
}


/******************

				tip


********************************************************/
function showTip() {
		//����onClick����
		changeOnClickFunction() ;
		
		document.getElementById("tip").style.display = "" ;
  		var content = "<div class='selectarea'>"
+"	<div class='close'><img src='/hbbass/common2/image/tab-close.gif' onclick='remove();'></img></div>"
+"	<div>��ѡ�����ά��</div>"
+"	<div><input type='radio' value='substr(channel_code,1,5)' name='R1' onclick=getOption(this.value,'city');>���С�</div>"
+"	<div><input type='radio' value='channel_code' name='R1'   onclick=getOption(this.value,'county'); >����</div>           ";

	for (var j=0; j< curConfDim.length;j++)
	{
		var arr = curConfDim[j].split(",");
		content +="	<div><input type='radio' value='"+arr[0]+"'  name='R1' onclick=getOption(this.value,'"+arr[1]+"'); >"+arr[2]+"</div>";
	}
	content +="</div>";
	drawTip("tip",content);
}
	
	function renderTable(arr){
		
		if(aa.selectedNode)
		{
			//�ָ�onClick����
    		recoverOnClickFunction();
    
			//dim = selectDim() ;
			var pnode_id = aa.selectedNode.infoField.childNodes[0].id ;
			
			for(var i = 0 ; i<arr.length-1 ;i++) {
				if(pnode_id == "0"){
	  			node_id = (i+1) + "" ;
	  			}else{
	  				node_id = pnode_id + (i+1) ;
	  			}
	  			
	  			var condition = "";
	  			if(curDim=="brand_id")condition=curDim+"="+arr[i][0];
	  			else condition=curDim+"='"+arr[i][0]+"' ";
	  			
	  			var table = createTable(node_id,arr[i][1],condition);
	      		
				aa.selectedNode.addChild(table) ;
	
				fillData({node_id:node_id,data:arr[i]}) ;
			}
			aa.selectedNode.expand(true) ;
	
			hideTip() ;
		}
		else
		{
			fillData({node_id:"0",data:arr[0]}) ;
		}
	}
	//�����������
	function drawTip(tipName,tipContent){
  		var mousex = event.clientX;
  		var mousey = event.clientY;
  		var pagexoff = document.body.scrollLeft;
  		var pageyoff = document.body.scrollTop;
  		tipObj = document.getElementById(tipName);
  		if(tipObj){
    		document.getElementById(tipName).innerHTML = tipContent;
    		tipObj.style.left = (mousex+pagexoff) + 5;
 			tipObj.style.top = (mousey+pageyoff) - 60;
    		tipObj.style.visibility = 'visible';
 		}
 	}
 	
 	function hideTip(){
  		if(tipObj){
    		tipObj.style.visibility= "hidden";
  		}
	}
	function remove(){
		recoverOnClickFunction() ;
		document.getElementById("tip").style.display = "none" ;
		aa.selectedNode.expand(false) ;
	}

	function changeOnClickFunction(){
		os = document.getElementsByTagName("img") ;
		for(var i=0 ;i <os.length; i++){
			onclicks[i] = os[i].onclick ;
			os[i].onclick=function(){
				alert("����ѡ���ѯ�Ƕ�") ;
			}
		}
	}
	function recoverOnClickFunction(){
		for(var i=0 ;i <os.length-2; i++){
			os[i].onclick= onclicks[i] ;
    	}
	}