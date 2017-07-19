ComponentBase={
	init:function(){
		this.wid=this.opts.id;
	},
	reportView:function(opts){
		for(var key in opts){
			this.opts[key]=opts[key];
		}
		this.update();
	},
	destory:function(){
		this.unmount();
	}
	
}