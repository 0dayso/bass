<ReportList class="ReportList">
	<table class="table ">
		<tbody>
			<tr if={datas.length==0}><td>无数据</td></tr>
			<tr if={datas.length>0} each={item,idx in datas}>
				<td class="ReportList-img">
					<div class="ReportList-image"></div>
				</td>
				<td class="ReportList-context">
					   	<div class="media-body ReportList-text">
					   	  <div class="ReportList-text-head">
					   	  	<span class="ReportList-text-title" data-id={item.reportid} data-uri={item.uri} onclick={itemClick}>{item.name}</span>
					   	  	<span class="ReportList-text-views" >({item.num}人浏览)</span>
					   	  	<span class="ReportList-text-createdate">上线时间:{item.create_dt}</span>
					   	  </div>
					      <div class="ReportList-text-desc">{item.desc}</div>
					      <div class="ReportList-text-keywords">关键字:{item.keywords}</div>
					   	</div>
				</td>
			   	<td class="ReportList-favorite">
			   		<span class="ReportList-favorite-add" data-id={item.reportid} if={item.favsnum==0} onclick={addFavorite}><i class="icon-star" ></i>加入收藏</span>
			   		<span if={item.favsnum>0}>已收藏</span>
			   	</td>
		   	<tr>
	   	<tbody>
	</table>
	var _this=this;
	_this.datas=opts.datas||[];
	_this.mixin(BoxCommpent);
	_this.addFavorite=function(e){
		var a=e.currentTarget;
		_this.opts.addfavorite.call(this,$(e.currentTarget).attr("data-id"));
	}
	_this.itemClick=function(e){
		_this.opts.titleclick.call(this,e.currentTarget.innerText,$(e.currentTarget).attr("data-uri"));
	}
	_this.load=function(items){
		if(items){
			_this.datas=items;
		}
		_this.update();
	}
	_this.hide=function(){
		$(_this.root).hide();
	}
	_this.show=function(){
		$(_this.root).show();
	}
	_this.on('mount',function(){
	})
</ReportList>