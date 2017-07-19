<BulletinLeftImage>
	<div each={data in datas} class='BulletinLeftImage'>	
		<img  class='imgTitle img-responsive' src={data.resource_img?data.resource_img:this.src}></img>
		<div class='BulletinName'>
			<a onclick="{nameClick}" data-uri="{data.resource_uri}">
				{data.resource_name}
			</a>
		</div>
		<div class='Bulletincollect'>{data.num}人收藏</div>
	</div>
	var _this=this;
	_this.datas=opts.datas||[];
	_this.mixin(BoxCommpent);
	_this.src = opts.src;
	_this.nameClick=function(e){
		_this.opts.nameClick.call(this,e.currentTarget.innerText,$(e.currentTarget).attr("data-uri"));
	}
	_this.on('mount',function(){
		if(_this.datas.length==0){
			$(_this.root).hide();
		}
	})
</BulletinLeftImage>