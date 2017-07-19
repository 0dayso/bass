BoxCommpent={
	init:function(){
		this.mixin(ComponentBase);
		this.on("mount updated",function(){
			this.setMaxWidth(this.opts.maxWidth);
			this.setMinWidth(this.opts.minWidth);
			this.setWidth(this.opts.width);
			this.setHeight(this.opts.height);
			this.setOffset(this.opts.x,this.opts.y);
		});
	},
	setMaxWidth:function(maxWidth){
		if(maxWidth)$(this.root).css("max-width",maxWidth);
	},
	setMinWidth:function(minWidth){
		if(minWidth)$(this.root).css("min-width",minWidth);
	},
	setWidth:function(width){
		this.width = width||$(this.root).width();
		$(this.root).width(width);
	},
	setHeight:function(height){
		this.height = height||$(this.root).height();
		$(this.root).height(height);
	},
	setOffset:function(x,y){
		if(!x&&!y)return;
		x=x||0;
		y=y||0;
		$(this.root).offset({left:x,top:y});
	}
}