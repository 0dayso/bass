riot.tag2('bulletinsimple', '<div class="panel panel-primary"> <div class="panel-heading bulletin-simple-title"> <span class="panel-title bulletin-simple-title-text">{opts.titleText}</span> <a if="{hasSubhead==\'true\'}" class="panel-title icon-double-angle-down bulletin-simple-title-func" onclick="{clickTitleFunc}"> {opts.funcTitle} </a> </div> <div class="bulletin-simple-context"> <ul class="nav nav-pills" each="{row,idx in datas}" if="{idx < lineNum}" onclick="{clickRow}"> <li if opts itemicon class="{itemIcon} bulletin-simple-li-icon"></li> <li class="bulletin-simple-li-text" title="{row.text}">{row.text}</li> </ul> </div> </div>', '', 'class="bulletin-simple"', function(opts) {


	this.datas=opts.datas;
	this.lineNum=opts.lineNum;
	this.itemIcon=opts.itemIcon||"icon-bar-chart";
	this.hasSubhead=opts.hasSubhead||"true";
	this.mixin(BoxCommpent);
	this.clickTitleFunc = function(e){
		if(!this.opts.funcClick)return;
		this.opts.funcClick.call(this,this.opts.funcTitle);
	}.bind(this)
	this.clickRow = function(e){
		if(!this.opts.rowClick)return;
		this.opts.rowClick.call(this,e.item.row);
	}.bind(this)
	this.load=function(items){
		if(items){
			this.datas=items;
		}else{
			this.datas=opts.datas;
		}
		this.update();
	}
	this.on('mount',function(){
		if(this.datas.length==0){
			$(this.root).hide();
		}
		if(opts.width){
			$(this.root).css('width',opts.width);
		}
		if(opts.titleColor){
			$(".bulletin-simple-title",this.root).css('background-color',opts.titleColor);
			$(".bulletin-simple-title",this.root).css('border-color',opts.titleColor);
		}
	})
}, '{ }');