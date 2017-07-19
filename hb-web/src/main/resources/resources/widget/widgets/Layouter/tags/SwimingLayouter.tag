<SwimingLayouter>
	<div data-column-index={columnIndex} class="float-left" style="width:{column.width}" each={column,columnIndex in gridDefine}>
	</div>
	<div class="clear-float"></div>

	this.mixin(Layouter);
	var _self = this;

	function setIntervalEl(item){
		if(!item.opts.interval&&item.opts.interval!=0){
			item.opts.interval=opts.gridDefine[item.column].interval;
		}
		$(item.root).css("margin",item.opts.interval);
	}
	this.addItem=function(item){
		item.column = item.opts.column||0;
		var $columnDiv=$(this.root).find("[data-column-index='"+item.column+"']");
		if($columnDiv.length){	
			setIntervalEl(item);		
			$columnDiv.append(item.root);
		}
	}
	this.addItems=function(items){
		$.each(items,function(index,item){
			_self.addItem(item);
		});
	}
	this.on('mount updated',function(){
		this.setInterval(".float-left");
		this.addItems(opts.items);
	})
</SwimingLayouter>