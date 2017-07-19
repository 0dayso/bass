Container={
	init:function(){
		this.mixin(BoxCommpent);
		var layouterDefine=this.opts.layouter||{};
		layouterDefine.items=layouterDefine.items||this.opts.items||{};
		switch(layouterDefine.type){
			case "grid":
				this.layouter=Widget.create("gridlayouter",layouterDefine);
				break;
			default:
				this.layouter=Widget.create("defaultlayouter",layouterDefine);
				break;
		}
	},
	addItem:function(item){
		this.layouter.addItem(item);
	}
}