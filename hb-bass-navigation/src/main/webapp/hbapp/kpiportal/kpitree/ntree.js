var System = {};
System.UI = {} ;
System.UI.ntreeNode = SYSTEM_UI_NTREENODE;

var nodepath="";
//树结点类
function SYSTEM_UI_NTREENODE()
{
    indexCount++ ;
    classType = "SYSTEM_UI_NTREENODE";
    this.initialize.apply(this,arguments);
    
}
SYSTEM_UI_NTREENODE.prototype = {
    initialize:function(_parent,_text,_callback)//初始化类 _parent是父节点 _text是本节点的文本
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
        //添加完结点后重新计算连接线
        this.resizeBar();
    },
    initElement:function()//初始化元素
    {
        this.mainObj = $C("table");//节点主载体
        var otbody = $C("tbody");//tablebody
        var otr = $C("tr");//tr
        this.pikeTd = $C("td");//纵向连结线区域
        this.beforeLineTd = $C("td") ;//节点前置连接线区域
        this.infoTd = $C("td");//内容区域
        this.afterLineTd =$C("td") ;//节点和(p1/p2)后置连接线区域
        this.childTd = $C("td");
        this.infoField = $C("span");//内容区域
        this.expandObj = $C("img");//展开元素
        this.childField = $C("div");//子节点容器
        this.imgBar1 = this.createPike(1,1);//纵向连接线
        this.imgBar2 = this.createPike(8,2);//节点前置连接线
        this.imgBar3 = this.createPike(8,2);//节点后置连接线
        this.mainObj.appendChild(otbody);
        
        //this.table = $(sid) ;
        
        otbody.appendChild(otr);
        //列
        with(otr)
        {
            appendChild(this.pikeTd);
            appendChild(this.beforeLineTd) ;
            appendChild(this.infoTd);
            appendChild(this.afterLineTd)  ;
            appendChild(this.childTd);
        }
        //内容区域
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
    setElement:function()//设置元素属性
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
		
		//如果子节点的数量为0，则把展开＋号隐藏
		if(dirNum == 0){
			this.afterLineTd.style.display = "none" ;

		}	
        this.childField.style.display = this.imgBar3.style.display = "none";
    },
    initEvent:function(_callback)//初始化事件
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
						//清空子节点
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
					//显示选择dim对话框	
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
    text:function(_text)//修改本节点文本的方法
    {
        if(typeof(_text)=="string" && _text.trim())
            this.infoField.innerHTML = this._text = _text;
        return this._text;
    },
    resizeBar:function()//重新加载连结线长度
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
                aa.imgBar1.style.height = aa.pikeTd.offsetHeight + "px";//计算高度
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
    expand:function(value)//目录展开方法
    {
        if(typeof(value)=="boolean")
        {
            this._expand = value;
            this.imgBar3.style.display = this.childField.style.display = this._expand?"":"none";
            //this.expandObj.src = [paths,this._expand?"img/p2.gif":"img/p1.gif"].join('')
            this.expandObj.src = ["",this._expand?nodepath+"p2.gif":nodepath+"p1.gif"].join('')
            this.resizeBar();//重新画线
        }
        return this._expand;
    },
    addChild:function(_text,_callback)//添加子节点的方法 _text是子节点的文本
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

//树类
System.UI.ntree = SYSTEM_UI_NTREE;
function SYSTEM_UI_NTREE()
{
    this.className = "SYSTEM_UI_NTREE";
    this.initialize.apply(this,arguments);
}
SYSTEM_UI_NTREE.prototype = {

    initialize:function(_container,_rootText,_callback)//初始化树的方法 _container是树的HTML容器实例 _rootText是跟节点的文本;_callback是点击+的调用函数
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
    selectNode:function(node)//选中节点 将当前选中节点设置为node node是本树中树节点的实例
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
	if(options.node_id=="0")sTitle += "<td width=20 style='font-size: 16 px;font-family: 黑体;'><span id=\"citystr\">全省</span>收入</td>";
	sTitle += "<td>";
	for(var a =0; a < arr.length; a++)
	{
		
		if(arr[a] instanceof Array)
		{
			//sTitle +="<div style='padding : 2 px 0 px;'>"+arr[a][0]+"：<span id='s1"+arr[a][2]+"' title='点击切换' onclick='swich(\""+arr[a][2]+"\")' style='cursor:hand;'>"+percentFormat(arr[a][3])+"</span><span id='s2"+arr[a][2]+"' title='点击切换' onclick='swich(\""+arr[a][2]+"\")' style='display:none;cursor:hand;'>" +((arr[a][4]=="percent")?percentFormat(arr[a][1]):numberFormatDigit2(arr[a][1]))+"</span>"+((arr[a][2] in hasFluctuating)?threshold.getHuanbiImg(arr[a][3],arr[a][2],arr[a][0],"tongbi"):threshold.getTongbiImg(arr[a][3],arr[a][2],arr[a][0],"tongbi"))+"</div>";
			//年同比,无波动分析
			sTitle +="<div style='background-color: #F9FBFD;border:1px solid #EFF5FB;padding : 2 px;margin:0 px 0 px 2 px 0 px;'>"+arr[a][0].replace("(日)","")+":"+((arr[a][4]=="percent")?percentFormat(arr[a][1]):numberFormat(arr[a][1],0))
			+" 月同比:"+((parseFloat(arr[a][5])==0)?"--":("<a href='#' title='点击查看\"年同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+arr[a][2]+"\";valuetype=\"tongbi\";kpiTree();}'>"+percentFormat(arr[a][5])+"</a>"+((arr[a][2] in hasFluctuating)?threshold.getHuanbiImg(arr[a][5],arr[a][2],arr[a][0],"tongbi"):threshold.getTongbiImg(arr[a][5],arr[a][2],arr[a][0],"tongbi"))))
			+" 年同比:"+((parseFloat(arr[a][3])==0)?"--":("<a href='#' title='点击查看\"年同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+arr[a][2]+"\";valuetype=\"yeartongbi\";kpiTree();}'>"+percentFormat(arr[a][3])+"</a>"+(threshold.getTongbiImg(arr[a][3],arr[a][2],arr[a][0],"yeartongbi"))))+"</div>";
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
	var list = [["新<br>用<br>户"],["新<br>话<br>务"],["新<br>业<br>务"]];
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
	