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