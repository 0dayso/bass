riot.tag2('notice', '<i class=" icon-volume-up icon-2x pull-left icon-muted notice-icon"></i> <span class="notice-title">{opts.title}</span> <label class="notice-text" riot-style="{opts.textStyle}" title="{opts.text}">{opts.text}</label> <a href="{opts.href}" class="notice-moretitle" onclick="{opts.clickMore}" riot-style="{opts.moreTitleStyle}"> {opts.moreTitle} </a>', '', 'class="notice"', function(opts) {

    this.mixin(BoxCommpent);
	opts.clickMore=function(e){
			opts.listener.click.call(this,opts.title,opts.text,opts.moreTitle);
		}
	opts.href=opts.href||"javascript:void(0);";
	opts.moreTitle=opts.moreTitle||"更多";

}, '{ }');