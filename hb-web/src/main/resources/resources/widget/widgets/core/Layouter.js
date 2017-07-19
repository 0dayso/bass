Layouter={
	init:function(){
		this.mixin(BoxCommpent);
		this.items=this.opts.items;
	},
	setInterval:function(selector){
		if(!this.opts.interval)this.opts.interval=0;
		$(selector,this.root).css("padding",this.opts.interval);
	},
	layout:function(items){
		this.reportView({items:items});
	},
	layoutTo:function(domElement){
		$(domElement).append(this.root);
	}
}