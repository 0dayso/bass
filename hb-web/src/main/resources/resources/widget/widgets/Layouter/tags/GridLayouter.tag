<GridLayouter>
	<div data-row-index={rowindex} each={row,rowindex in opts.gridDefine}>
		<div data-column-index={columnIndex} class="float-left" style="width:{column.width}" 
			each={column,columnIndex in row}>
		</div>
		<div class="clear-float"></div>
	</div>

	this.mixin(Layouter);
	var _self = this;

	function setIntervalEl(item){
		var itemContainer = $("<div></div>");
		if(!item.opts.interval&&item.opts.interval!=0){
			item.opts.interval=opts.gridDefine[item.row][item.column].interval;
		}
		if(item.opts.interval||item.opts.interval==0){
			itemContainer.css("padding",item.opts.interval);
			itemContainer.append(item.root);
			return itemContainer;
		}else{
			return item.root;
		}
	}

	this.addItem=function(item){
		item.row = item.opts.row||0;
		item.column = item.opts.column||0;
		var $columnDiv=$("[data-row-index='"+item.row+"']",this.root).find("[data-column-index='"+item.column+"']");
		if($columnDiv.length){			
			$columnDiv.append(setIntervalEl(item));
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
</GridLayouter>