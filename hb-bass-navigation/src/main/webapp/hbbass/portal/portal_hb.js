 // 点击左边树时，在中间窗体新增tab  ,是用于同一层次的页面，不适用于子帧更新父帧 
  function  openhtml(url_node,url_text,url_link)
 { 
   if(url_link!='')
   {
   	  
		 	 var n = contentPanel.getComponent(url_node);
		 	 if (!n) {
		 	 	    n = contentPanel.add({
		               'id':url_node,
		               'title':url_text,
		                closable:true,  //通过html载入目标页
		                margins:'0 4 4 0',
		                autoScroll:true,   
		               'html':'<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+url_link+'></iframe>'
		            });
		  	}
		    contentPanel.setActiveTab(n);		
   }
 	}  
 	
 	// 点击子帧页面中的链接，在父帧的中间区域显示页面内容
 
 function  openhtml_p(url_node,url_text,url_link)
 { 
 	 if(url_link.indexOf('/hbbass/cognosview')>-1)
 	 {
 	 	window.open(url_link,'','status=no,toolbar=no,menubar=no,location=no,channelmode=0,directories=0,resizable=no,titlebar=no');
 	 } 
   else if(url_link!='')
   {
   	    var contentPanel=parent.contentPanel;
		 	  n = contentPanel.getComponent(url_node);
		 	 if (!n) {
		 	 	    n = contentPanel.add({
		               'id':url_node,
		               'title':url_text,
		                closable:true,  //通过html载入目标页
		                margins:'0 4 4 0',
		                autoScroll:true,   
		               'html':'<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+url_link+'></iframe>'
		            });
		  	}
		    contentPanel.setActiveTab(n);		
   }
 	}  
 	
 function  openhtml_p2(url_node,url_text,url_link)
	 { 
	   if(url_link!='')
	   {
	   	    var contentPanel=parent.parent.contentPanel;
			 	  n = contentPanel.getComponent(url_node);
			 	 if (!n) {
			 	 	    n = contentPanel.add({
			               'id':url_node,
			               'title':url_text,
			                closable:true,  //通过html载入目标页
			                margins:'0 4 4 0',
			                autoScroll:true,   
			               'html':'<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+url_link+'></iframe>'
			            });
			  	}
			    contentPanel.setActiveTab(n);		
	   }
	 	}  
 	
 	// 弹出提示
function wsug(e, str){ 
	var oThis = arguments.callee;
	if(!str) {
		oThis.sug.style.visibility = 'hidden';
		document.onmousemove = null;
		return;
	}		
	if(!oThis.sug){
		var div = document.createElement('div'), css = 'top:0; left:0; position:absolute; z-index:100; visibility:hidden';
			div.style.cssText = css;
			div.setAttribute('style',css);
		var sug = document.createElement('div'), css= 'font:normal 14px/16px "宋体"; white-space:nowrap; color:#666; padding:3px; position:absolute; left:0; top:0; z-index:10; background:#f9fdfd; border:1px solid #0aa';
			sug.style.cssText = css;
			sug.setAttribute('style',css);
		var dr = document.createElement('div'), css = 'position:absolute; top:3px; left:3px; background:#333; filter:alpha(opacity=50); opacity:0.5; z-index:9';
			dr.style.cssText = css;
			dr.setAttribute('style',css);
		var ifr = document.createElement('iframe'), css='position:absolute; left:0; top:0; z-index:8; filter:alpha(opacity=0.5); opacity:0';
			ifr.style.cssText = css;
			ifr.setAttribute('style',css);
		div.appendChild(ifr);
		div.appendChild(dr);
		div.appendChild(sug);
		div.sug = sug;
		document.body.appendChild(div);
		oThis.sug = div;
		oThis.dr = dr;
		oThis.ifr = ifr;
		div = dr = ifr = sug = null;
	}
	var e = e || window.event, obj = oThis.sug, dr = oThis.dr, ifr = oThis.ifr;
	obj.sug.innerHTML = str;
	
	var w = obj.sug.offsetWidth, h = obj.sug.offsetHeight, dw = document.documentElement.clientWidth||document.body.clientWidth; dh = document.documentElement.clientHeight || document.body.clientHeight;
	var st = document.documentElement.scrollTop || document.body.scrollTop, sl = document.documentElement.scrollLeft || document.body.scrollLeft;
	var left = e.clientX +sl +17 + w < dw + sl && e.clientX + sl + 15 || e.clientX +sl-8 - w, top = e.clientY + st + 17;
	obj.style.left = left+ 10 + 'px';
	obj.style.top = top + 10 + 'px';
	dr.style.width = w + 'px';
	dr.style.height = h + 'px';
	ifr.style.width = w + 3 + 'px';
	ifr.style.height = h + 3 + 'px';
	obj.style.visibility = 'visible';
	document.onmousemove = function(e){
		var e = e || window.event, st = document.documentElement.scrollTop || document.body.scrollTop, sl = document.documentElement.scrollLeft || document.body.scrollLeft;
		var left = e.clientX +sl +17 + w < dw + sl && e.clientX + sl + 15 || e.clientX +sl-8 - w, top = e.clientY + st +17 + h < dh + st && e.clientY + st + 17 || e.clientY + st - 5 - h;
		obj.style.left = left + 'px';
		obj.style.top = top + 'px';
		
	}
}
