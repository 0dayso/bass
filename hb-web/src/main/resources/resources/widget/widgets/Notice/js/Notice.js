riot.tag2('notice', '<i class=" icon-volume-up icon-2x pull-left icon-muted notice-icon"></i> <span class="notice-title">{opts.title}</span> <label class="notice-text" riot-style="{opts.textStyle}" title="{opts.text}">{text}</label> <a href="{opts.href}" class="notice-moretitle" onclick="{opts.clickMore}" riot-style="{opts.moreTitleStyle}"> {opts.moreTitle} </a>', '', 'class="notice"', function(opts) {
   	var _this=this;
    _this.mixin(BoxCommpent);
    _this.initText=function(){
    	$.each(opts.text,function(k,v){
    		if(k==0){
    			_this.text=v.newstitle+ ':' + v.newsmsg+ '  发布时间:' + v.newsdate;
    		}
    	})
    	if(_this.text==null){
    		_this.text="暂无";
    	}
    }
    _this.initText();
	opts.clickMore=function(e){
			opts.listener.click.call(this,opts.title,opts.text,opts.moreTitle);
		}
	opts.href=opts.href||"javascript:void(0);";
	opts.moreTitle=opts.moreTitle||"更多";

}, '{ }');