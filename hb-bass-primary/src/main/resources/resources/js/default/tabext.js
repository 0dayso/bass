/*****************************************************************/
var tabName=[];
tabName["_tabs"]=addExt;
tabName["_tabPanel"]=addExt;
tabName["contentPanel"]=addExt;
tabName["topFrame"]=addOri;
/**
id:exttab的id,title:标签的名称,url:跳转的地址,order:遍历的顺序，用于多个tab嵌套使用的add控制用
*/
function tabAdd(options)
{
	if(!options.url||options.url.length==0)return;
	var obj=self;
	if(options.order)
	var _content=undefined;
	//debugger;
	if(options.order){//遍历的顺序是从下往上，还是从上往下
		var _fras=[];
		_fras.push(obj);
		while(obj!=top){
			obj=obj.parent;
			_fras.push(obj);
		}
		
		for(var j=_fras.length;j>0;j--){
			obj=_fras[j-1];
			for(var i in tabName){
				if(i in obj){
					eval("_content=obj."+i);
					break;
				}
			}
			if(_content)break;
		}
	}
	else{
		var _fras=[];
		_fras.push(obj);
		while(obj!=top){
			obj=obj.parent;
			_fras.push(obj);
		}
		
		for(var j=0;j<_fras.length;j++){
			obj=_fras[j];
			for(var i in tabName){
				if(i in obj){
					eval("_content=obj."+i);
					break;
				}
			}
			if(_content)break;
		}
		
		/*while(obj.parent && obj.parent!=top){
			for(var i in tabName){
				if(i in obj){
					eval("_content=obj."+i);
					break;
				}
			}
			if(_content)break;
			obj=obj.parent;
	 	}*/
	}
	if(options.title && options.title.length>0){
		if(_content){
			tabName[i]({content:_content,title:options.title,url:options.url,id:options.id?options.id:options.title});
		}else if(top.addTabMainFrame){
			top.addTabMainFrame({title:options.title,url:options.url,id:options.id?options.id:options.title})
		}else{
			var id = options.id + "";
			id = id.replace(/(^\s*)|(\s*$)/g, "");
			if(id != "undefined" && id.length>0){
				window.parent.addTab(id ,options.title, options.url);
			}else{
				window.open(options.url);
			}
		}
	}
}

function addExt(options){
	var n = options.content.getComponent(options.id);
 	if (!n) {
 		n = options.content.add({
	       'id':options.id,
	       'title':options.title,
	        closable:true,  
	        margins:'0 4 4 0',
	        autoScroll:true,   
	       'html':'<iframe scrolling="auto" frameborder="0" width="98%" height="100%" src='+options.url+'></iframe>'
	    });
  	}
	options.content.setActiveTab(n);
}

function addOri(options){
	options.content.theCreateTab.add("<b>"+options.title+"</b>,mainFrame,"+options.url);
}
