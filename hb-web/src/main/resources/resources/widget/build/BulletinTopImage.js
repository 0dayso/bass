riot.tag2('bulletintopimage', '<div each="{data,idx in _this.datas}" class="BulletinTopImage-item"> <div class="imgTitle"> <img class="imgTitle-mark" riot-src="{getSrc(data.newflag,data.hotflag)}"></img> <img class="imgTitle-context" riot-src="{data.resource_img?data.resource_img:this.src}"></img> </div> <div class="BulletinName"> <a data-uri="{data.resource_uri}" onclick="{nameClick}"> {data.resource_name} </a> </div> <div class="Bulletin_name" title="{data.resource_desc}">{data.resource_desc}&nbsp;</div> <div class="Bulletin_collect"> <button if="{data.ismycollect==0}" data-rid="{data.resource_id}" class="btn btn-default bulletinTopImage_noCollect" onclick="{clickCollectFunc}">加入收藏</button> <button if="{data.ismycollect>0}" data-rowid="{data.rowid}" class="btn btn-default bulletinTopImage_collect">已收藏</button> </div> </div> <div class="clear-float"></div>', '', 'class="BulletinTopImage"', function(opts) {
	_this = this;
	_this.mixin(BoxCommpent);
	_this.datas = opts.datas;
	_this.src = opts.src;
	_this.getSrc=function(newflag,hotflag){
		var targetSrc="";
		if(newflag=='new'){
			targetSrc="../../resources/widget/sass/image/applist/app_new.jpg";
		}
		if(hotflag=='hot'){
			targetSrc="../../resources/widget/sass/image/applist/app_hot.jpg";
		}
		return targetSrc;
	}
	_this.load = function(newDatas){
		if(newDatas){
			_this.datas = newDatas;
		}
		_this.update();
	}
	this.clickCollectFunc = function(e){
		if(!this.opts.collectClick)return;
		var rid=$(e.target).attr("data-rid");
		_this.opts.collectClick.call(this,rid);
	}.bind(this)
	_this.nameClick=function(e){
		if(!_this.opts.nameClick)return;
		_this.opts.nameClick.call(this,e.currentTarget.innerText,$(e.currentTarget).attr("data-uri"));
	}
}, '{ }');