<DefaultLayouter>
	<div class='float-left' each={opts.items}></div>
	<div class='clear-float'></div>
	
	this.mixin(Layouter);
	var _self=this;
	addItem(widget){ 
		if(!widget||!widget.root)return;
		var $clear = $(".clear-float",this.root);
		var $floatLeft = $("<div class='float-left'></div>");
		$floatLeft.append(widget.root);
		this.setInterval($floatLeft);
		$clear.before($floatLeft);
	}
	addItems(items){
		if(!_.isArray(items))return;
		$.each(items,function(i,item){
			_self.addItem(item);
		});
	}
	this.on('mount updated',function(){
		this.setInterval('.float-left');
		$('.float-left',this.root).each(function(i,domElement){
			$(domElement).append(_self.opts.items[i].root);
		});
	});
</DefaultLayouter>