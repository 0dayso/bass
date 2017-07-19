var System = {};
System.UI = {} ;
System.UI.ntreeNode = SYSTEM_UI_NTREENODE;

var nodepath="";
//�������
function SYSTEM_UI_NTREENODE()
{
    indexCount++ ;
    classType = "SYSTEM_UI_NTREENODE";
    this.initialize.apply(this,arguments);
    
}
SYSTEM_UI_NTREENODE.prototype = {
    initialize:function(_parent,_text,_callback)//��ʼ���� _parent�Ǹ��ڵ� _text�Ǳ��ڵ���ı�
    {	
        this.top = _parent.top;
        this.parent = _parent;
        this._text = _text;
        this._expand = false;
        this.children = [];
        this.initElement();
        this.setElement();
        this.initEvent(_callback);
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
            src = nodepath+"p1.gif";
        }
       	
		this.infoField._instance = this;
		
		//����ӽڵ������Ϊ0�����չ����������
		if(dirNum == 0){
			this.afterLineTd.style.display = "none" ;

		}	
        this.childField.style.display = this.imgBar3.style.display = "none";
    },
    initEvent:function(_callback)//��ʼ���¼�
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
					_callback();
					
					//if(expandClick)expandClick();
					//return ;	
        		}
        	}
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
            this.expandObj.src = ["",this._expand?nodepath+"p2.gif":nodepath+"p1.gif"].join('')
            this.resizeBar();//���»���
        }
        return this._expand;
    },
    addChild:function(_text,_callback)//����ӽڵ�ķ��� _text���ӽڵ���ı�
    {
        new System.UI.ntreeNode(this,_text,_callback);
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

    initialize:function(_container,_rootText,_callback)//��ʼ�����ķ��� _container������HTML����ʵ�� _rootText�Ǹ��ڵ���ı�;_callback�ǵ��+�ĵ��ú���
    {
        this.parent = this;
        this.top = this;
        this.childField = this.container = _container;
        this.childField.className = "ntree";
        this.children = [];
        this.rootNode = new System.UI.ntreeNode(this,_rootText,_callback);
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
function createTable(sid,name,dim)
{
	var table = '<div id="'+sid+'" class="box" '+(dim.length>0?'style="width :'+dim+' px;"':'')+'><div class="inner"><div id='+sid+'t1f1 ></div></div></div>';
	return table ;
}

function initTable(name){
	indexCount = 0 ;
     var table = '<div id="0" class="box"><div class="inner"><div id=0t1f1 ></div></div></div>';
		 return table ;
}


/*****************************     
							query   
							
							
							*********************************/

function fillData(options){
	var arr = options.data;
	
	var sTitle='<table style="margin: 0 px;padding: 0 px;" cellspacing="0" cellpadding="0" border="0"><tr>';
	if(options.node_id=="0")sTitle += "<td width=20 style='font-size: 16 px;font-family: ����;'><span id=\"citystr\">ȫʡ</span>����</td>";
	sTitle += "<td>";
	for(var a =0; a < arr.length; a++)
	{
		
		if(arr[a] instanceof Array)
		{
			//sTitle +="<div style='padding : 2 px 0 px;'>"+arr[a][0]+"��<span id='s1"+arr[a][2]+"' title='����л�' onclick='swich(\""+arr[a][2]+"\")' style='cursor:hand;'>"+percentFormat(arr[a][3])+"</span><span id='s2"+arr[a][2]+"' title='����л�' onclick='swich(\""+arr[a][2]+"\")' style='display:none;cursor:hand;'>" +((arr[a][4]=="percent")?percentFormat(arr[a][1]):numberFormatDigit2(arr[a][1]))+"</span>"+((arr[a][2] in hasFluctuating)?threshold.getHuanbiImg(arr[a][3],arr[a][2],arr[a][0],"tongbi"):threshold.getTongbiImg(arr[a][3],arr[a][2],arr[a][0],"tongbi"))+"</div>";
			//��ͬ��,�޲�������
			sTitle +="<div style='background-color: #F9FBFD;border:1px solid #EFF5FB;padding : 2 px;margin:0 px 0 px 2 px 0 px;'>"+arr[a][0].replace("(��)","")+":"+((arr[a][4]=="percent")?percentFormat(arr[a][1]):numberFormat(arr[a][1],0))
			+" ��ͬ��:"+((parseFloat(arr[a][5])==0)?"--":("<a href='#' title='����鿴\"��ͬ������\"ͼ��' onclick='{chartswf=\"2\";chartCurZbcode=\""+arr[a][2]+"\";valuetype=\"tongbi\";kpiTree();}'>"+percentFormat(arr[a][5])+"</a>"+((arr[a][2] in hasFluctuating)?threshold.getHuanbiImg(arr[a][5],arr[a][2],arr[a][0],"tongbi"):threshold.getTongbiImg(arr[a][5],arr[a][2],arr[a][0],"tongbi"))))
			+" ��ͬ��:"+((parseFloat(arr[a][3])==0)?"--":("<a href='#' title='����鿴\"��ͬ������\"ͼ��' onclick='{chartswf=\"2\";chartCurZbcode=\""+arr[a][2]+"\";valuetype=\"yeartongbi\";kpiTree();}'>"+percentFormat(arr[a][3])+"</a>"+(threshold.getTongbiImg(arr[a][3],arr[a][2],arr[a][0],"yeartongbi"))))+"</div>";
		}
		else sTitle +="<div style='font-size: 18 px;text-align : center;font-weight : bold;'>"+arr[a]+"</div>";
	}
	sTitle += "</td></tr></table>"
	document.getElementById(options.node_id+"t1f1").innerHTML = sTitle;
}

function kpiTree()
{
	var sArea = "";
	var sDate = document.forms[0].date.value;
	try{
		if(document.forms[0].county!=undefined&&document.forms[0].county.value!="")
			sArea = document.forms[0].county.value;
		else sArea = document.forms[0].city.value;
		if(sArea=="0")sArea="HB";
	}
	catch(e){}
	renderChart({
		url: "../action.jsp?appName=ChannelD&method=chartkpiview",
		loadmask : false,
		param: "area="+sArea+"&date="+sDate+"&link=true"+"&zbcode="+(chartCurZbcode||"default")+"&valuetype="+(valuetype||""),
		width : "880",
		height : "300",
		chartid : "chartrender",
		chartSWF : ChartSwf["2"]
	});
}

function linkCity(id)
{
	document.forms[0].city.value=id;
	areacombo(1);
	search();
}

function swich(id)
{
	var s1 = document.getElementById("s1"+id);
	var s2 = document.getElementById("s2"+id);
	if(s1.style.display=="")
	{
		s1.style.display="none";
		s2.style.display="";
	}
	else
	{
		s2.style.display="none";
		s1.style.display="";
	}
}

/******************

				tip


********************************************************/
var funcarr = [];
funcarr["0"]=function(){
	dirNum=1;
	var list = [["��<br>��<br>��"],["��<br>��<br>��"],["��<br>ҵ<br>��"]];
	renderTable(list);
};

funcarr["1"]=function(){
	var list = [];
	dirNum=0;
	submitWrapper("user");
};

funcarr["2"]=function(){
	var list = [];
	dirNum=0;
	submitWrapper("traffic");
};

funcarr["3"]=function(){
	var list = [];
	dirNum=0;
	submitWrapper("income");
};
	
	function renderTable(arr){
		
		if(aa.selectedNode)
		{
			var pnode_id = aa.selectedNode.infoField.childNodes[0].id ;
			
			for(var i = 0 ; i<arr.length ;i++) {
				if(pnode_id == "0"){
	  			node_id = (i+1) + "" ;
	  			}else{
	  				node_id = pnode_id + (i+1) ;
	  			}
	  			var condition = "";
	  			
	  			if(node_id.length>1)condition="420";
	  			
	  			var table = createTable(node_id,arr[i][1],condition);
	      		
				aa.selectedNode.addChild(table,funcarr[node_id]);
	
				fillData({node_id:node_id,data:arr[i]}) ;
			}
			aa.selectedNode.expand(true) ;
			tipObj.style.visibility= "hidden";
		}
		else
		{
			fillData({node_id:"0",data:arr[0]}) ;
		}
	}
	