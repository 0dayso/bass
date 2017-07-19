function add(url_node,url_text,url_link)
{
   if(url_link!=''){
   		var obj=parent;
   		while(obj._tabPanel==undefined){
   			obj=obj.parent;
   		}
   	   	var content=obj._tabPanel;
		n = content.getComponent(url_node);
	 	if (!n) {
			n = content.add({
		       'id':url_node,
		       'title':url_text,
		        closable:true,  
		        margins:'0 4 4 0',
		        autoScroll:true,   
		       'html':'<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+url_link+'></iframe>'
		    });
	  	}
		content.setActiveTab(n);
   }
}

function fluctuating(options)
{
	add(options.date+options.area.split("@")[1]+options.zbname,options.area.split("@")[1]+options.zbname
	,'debtfluctuating.jsp?area='+options.area
	+"&zbcode="+options.zbcode
	+"&zbname="+options.zbname
	+"&date="+options.date
	+"&dtype="+options.dtype
	+"&tableName="+options.tableName
	+"&division="+options.division
	+"&condition="+options.condition
	);
}

function Threshold()
{
	this.path="";
	this.tongbiUp=0.05;
	this.huanbiUp=0.05;
	this.tongbiDown=-0.05;
	this.huanbiDown=-0.05;
	this.getTongbiImg=function(options){
		if(this.tongbiUp==undefined) return "";
		else
		{
			if(value>this.tongbiUp)return "<img src='"+this.path+"images/up.gif' border='0'></img>";
			else if(value<this.tongbiDown)return "<img src='"+this.path+"images/down.gif' border='0'></img>";
			else return "<img src='"+this.path+"images/right.gif' border='0'></img>";
		}
	}
	this.getHuanbiImg=function(options){
		if(this.huanbiUp==undefined) return "";
		else{
			var funcStr = "fluctuating({area:\""+options.area+"\""
			+",zbcode:\""+options.zbcode+"\""
			+",zbname:\""+options.zbname+"\""
			+",date:\""+options.date+"\""
			+",dtype:\""+options.dtype+"\""
			+",tableName:\""+options.tableName+"\""
			+",condition:\""+options.condition+"\""
			+",division:\""+options.division+"\""
			+"})";
			if(options.value>this.huanbiUp)return "<img src='"+this.path+"images/up.gif' border='0' style='cursor:hand;' title='��������' onclick='"+funcStr+"'></img>";
			else if(options.value<this.huanbiDown)return "<img src='"+this.path+"images/down.gif' style='cursor:hand;' border='0' title='��������' onclick='"+funcStr+"'></img>";			
			else return "<img src='"+this.path+"images/right.gif' border='0' title='��������' style='cursor:hand;' onclick="+funcStr+"></img>";
		}
	}
}

function _areaCode(datas,options){
	return datas[options.seq].split("@").length>1?datas[options.seq].split("@")[1]:"";
}

function renderChart(sParam)
{
	var ajax = new AIHBAjax.Request({
		url:"/hb-bass-navigation/hbbass/common2/fusionchartwrapper.jsp",
		param:sParam,
		loadmask:true,
		callback:function(foo){
			var data = foo.responseText;
			if(data=="")alert("û�����");
			else{
				chartxmls = data.split("@,");
				
				var chartrender = document.getElementById("chartrender");
				if(chartrender.childNodes.length==0){
					chartrender.innerHTML = "<div><span id='chartrender0'></span><br/><span seq=0><input type='button' value='��ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Pie3D.swf',this.parentNode.seq);\" class='form_button' />&nbsp;<input type='button' value='��״ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Column3D.swf',this.parentNode.seq);\" class='form_button' /></span></div><br/>" 
					for(k=1;k<chartxmls.length;k++)
						chartrender.innerHTML += "<div style=\"border-top:1px double #DDDDDD;\"></div><div><span id='chartrender"+k+"'></span><br><span seq="+k+"><input type='button' value='��ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Pie3D.swf',this.parentNode.seq);\" class='form_button' />&nbsp;<input type='button' value='��״ͼ' onClick=\"javaScript:chart('/hbbass/common2/Charts/FCF_Column3D.swf',this.parentNode.seq);\" class='form_button' /></span></div><br/>";
				}
				for(j=0;j<chartxmls.length;j++)chart("/hb-bass-navigation/hbbass/common2/Charts/FCF_Column3D.swf",j);
				if(chartrender.style.display=="none")hideTitle(document.getElementById('chart_div_img'),'chart_div');
			}
		}
	});
}

function chart(chartSWF,id)
{
	var chart = new FusionCharts(chartSWF, "ChartId", "880", "250");
 	chart.setDataXML(chartxmls[id]);
 	chart.addParam("wmode","transparent");
 	chart.render("chartrender");
}