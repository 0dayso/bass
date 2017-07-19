riot.tag2('toolbar', '', '', 'class="toolbar"', function(opts) {

	var items = [];
	for(var i=0;i<opts.items.length;i++){
		var mark = $("<label class='toolbar-mark'>|</label>");
		mark.root = mark;
		items.push(opts.items[i]);
		if(i<opts.items.length-1){items.push(mark);};
    }
    opts.items = items;
   	this.mixin(Container);
   	this.addMark = function(items){
        for(var i=0;i<items.length;i++){
            this.layouter.addItem(items[i]);
        }
   	}.bind(this)
   	this.on("updated",function(){
        $(this.layouter.root).appendTo(this.root);
    })
});    