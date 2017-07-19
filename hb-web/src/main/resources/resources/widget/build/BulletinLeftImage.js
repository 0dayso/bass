riot.tag2('bulletinleftimage', '<div each="{data in opts.datas}" class="BulletinLeftImage"> <img class="imgTitle img-responsive" riot-src="{this.src}"></img> <div class="BulletinName"> <a onclick="{nameClick}" data-uri="{data.resource_uri}"> {data.resource_name} </a> </div> <div class="Bulletincollect">{data.num}人收藏</div> </div>', '', '', function(opts) {
	var _this=this;
	_this.mixin(BoxCommpent);
	_this.src = opts.src;
	_this.nameClick=function(e){
		_this.opts.nameClick.call(this,e.currentTarget.innerText,$(e.currentTarget).attr("data-uri"));
	}
}, '{ }');