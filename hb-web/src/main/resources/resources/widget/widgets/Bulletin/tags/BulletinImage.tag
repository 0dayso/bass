<BulletinImage>
	<div class='BulletinImage' each={data,idx in datas}>	
		<img  class='imgTitle img-responsive' src={data.resource_img?data.resource_img:imgCache[(idx+1)%4]}></img>
		<div class="BulletinImage-title" onclick={nameClick}  title={data.name} data-name="{data.name}" data-url="{data.uri}">
			<i class="icon-list-alt" ></i>&nbsp;{data.name}
		</div>
		<div class="BulletinImage-date" onclick={dateClick}  >
			<i class="icon-time"></i>&nbsp;{data.dt}
		</div>
	</div>
	this.datas=opts.datas||[];
	this.imgCache=["../../resources/widget/sass/image/bulletinimage/images1.png",
				   "../../resources/widget/sass/image/bulletinimage/images2.png",
				   "../../resources/widget/sass/image/bulletinimage/images3.png",
				   "../../resources/widget/sass/image/bulletinimage/images4.png"];
	this.mixin(BoxCommpent);
	nameClick(e){
		if(!this.opts.nameClick)return;
		this.opts.nameClick.call(this,$(e.currentTarget).attr("data-name"),$(e.currentTarget).attr("data-url"));
	}
	dateClick(e){
		if(!this.opts.dateClick)return;
		this.opts.dateClick.call(this,this.opts);
	}
</BulletinImage>