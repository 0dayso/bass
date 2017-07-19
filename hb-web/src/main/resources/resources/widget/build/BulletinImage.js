riot.tag2('bulletinimage', '<div class="BulletinImage"> <img class="imgTitle img-responsive" riot-src="{opts.src}"></img> <div onclick="{nameClick}" onmouseover="{imgMouseover}" title="{opts.name}" onmouseleave="{imgMouseleave}"> <i class="icon-list-alt"></i>&nbsp;{opts.name} </div> <div onclick="{dateClick}" onmouseover="{imgMouseover}" onmouseleave="{imgMouseleave}"> <i class="icon-time"></i>&nbsp;{opts.date} </div> </div>', '', '', function(opts) {

	this.mixin(BoxCommpent);
	this.nameClick = function(e){
		if(!this.opts.nameClick)return;
		this.opts.nameClick.call(this,this.opts);
	}.bind(this)
	this.dateClick = function(e){
		if(!this.opts.dateClick)return;
		this.opts.dateClick.call(this,this.opts);
	}.bind(this)
	this.imgMouseover = function(e){
		var imgElement = $(e.currentTarget).children()[0]; 
		$(imgElement).addClass('icon-large');
	}.bind(this)
	this.imgMouseleave = function(e){
		var imgElement = $(e.currentTarget).children()[0]; 
		$(imgElement).removeClass('icon-large');
	}.bind(this)
}, '{ }');