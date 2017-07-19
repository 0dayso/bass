riot.tag2('bulletinnormal', '<div class="panel panel-primary"> <div class="panel-heading bulletin-normal-title"> <span class="panel-title bulletin-normal-title-text">{opts.titleText}</span> <a if="{opts.funcTitle}" class="panel-title icon-double-angle-down bulletin-normal-title-func" onclick="{clickTitleFunc}"> {opts.funcTitle} </a> </div> <div class="bulletin-normal-context"> <ul class="nav nav-pills" each="{row,idx in datas}" if="{idx < lineNum}" onclick="{clickRow}"> <li class="bulletin-normal-li-rownum"> <span class="label label-default">{row.num}</span> </li> <li class="bulletin-normal-li-text" title="{row.text}">{row.text}</li> <li if="{this.isRemark}" class="bulletin-normal-li-remark">{row.remark}</li> </ul> </div> </div>', '', 'class="bulletin-normal"', function(opts) {
	this.isRemark = opts.isRemark==null||opts.isRemark==undefined?true:opts.isRemark;
	this.datas=opts.datas;
	this.lineNum=opts.lineNum;
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
	this.setMinHeight = function(value){
		$('.bulletin-normal-context',this.root).css('min-height',value);
	}
	this.on('mount',function(){
		if(opts.width){
			$(this.root).css('width',opts.width);
		}
		if(opts.titleColor){
			$(".bulletin-normal-title",this.root).css('background-color',opts.titleColor);
			$(".bulletin-normal-title",this.root).css('border-color',opts.titleColor);
		}
})
}, '{ }');