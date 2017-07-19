<ReportTable class="ReportTable">
	<table class="table table-bordered">
	   <thead class="ReportTable-thead">
	      <tr>
	         <th class="ReportTable-thead-name">名称</th>
	         <th class="ReportTable-thead-desc">描述</th>
	         <th class="ReportTable-thead-date">更新时间</th>
	         <th class="ReportTable-thead-type">报表类型</th>
	         <th class="ReportTable-thead-dell">操作</th>
	      </tr>
	   </thead>
	   <tbody class="ReportTable-tbody"></tbody>
	</table>
	var _this=this;
	_this.datas=opts.datas;
	_this.mixin(BoxCommpent);
	_this.generateTD=function(){
		return $("<td></td>");
	}
	_this.expandAll=function(){
		$(".icon-plus-sign",_this.root).removeClass("icon-plus-sign").addClass("icon-minus-sign");
		$(".ReportTable-tr-level1",_this.root).show();
	}
	_this.unexpandAll=function(){
		$(".icon-minus-sign",_this.root).removeClass("icon-minus-sign").addClass("icon-plus-sign");
		$(".ReportTable-tr-level1",_this.root).hide();
	}
	_this.expandClick=function(e){
		var clickTr=e.target.parentElement.parentElement;
		var clickLevel=$(clickTr).attr("data-level");
		if(e.target.className=='icon-plus-sign'){
			$(".icon-minus-sign",_this.root).removeClass("icon-minus-sign").addClass("icon-plus-sign");
			$(e.target).removeClass("icon-plus-sign").addClass("icon-minus-sign");
			$(".ReportTable-tr-level1",_this.root).hide();
			$("tr[data-level^='"+clickLevel+"-']",_this.root).show();
		}else{
			$(e.target).removeClass("icon-minus-sign").addClass("icon-plus-sign");
			$("tr[data-level^='"+clickLevel+"-']",_this.root).hide();
		}
	}
	_this.dbClickParent=function(e){
		var dbClickTr=e.currentTarget;
		var expBtn=dbClickTr.firstChild.firstChild;
		var clickLevel=$(dbClickTr).attr("data-level");
		if(expBtn.className=='icon-plus-sign'){
			$(".icon-minus-sign",_this.root).removeClass("icon-minus-sign").addClass("icon-plus-sign");
			$(expBtn).removeClass("icon-plus-sign").addClass("icon-minus-sign");
			$(".ReportTable-tr-level1",_this.root).hide();
			$("tr[data-level^='"+clickLevel+"-']",_this.root).show();
		}else if(expBtn.className=='icon-minus-sign'){
			$(expBtn).removeClass("icon-minus-sign").addClass("icon-plus-sign");
			$("tr[data-level^='"+clickLevel+"-']",_this.root).hide();
		}
	}
	_this.clickTr=function(e){
		var clickTr=e.currentTarget;
		$(".clicked",_this.root).removeClass("clicked");
		$(clickTr).addClass("clicked");
	}
	_this.clickItem=function(e){
		_this.opts.click.call(this,$(e.target.parentElement).data("item"));
	}
	_this.addFavorite=function(e){
		_this.opts.addfavorite.call(this,$(e.target.parentElement.parentElement).data("item"));
	}
	_this.showReport=function(){
		$("tbody",_this.root).empty();
		$.each(_this.datas,function(key,value){
			var trParent=$("<tr></tr>");
			var clickBtn=$("<i class='icon-plus-sign'></i>");
			var span=$("<span>"+value.name+"(共"+value.num+"张)</span>");
			if(value.num>0){
				trParent.append(_this.generateTD().append(clickBtn).append(span));
			}else{
				trParent.append(_this.generateTD().append($("<i>&nbsp;&nbsp;&nbsp;</i>")).append(span));
			}
			trParent.append(_this.generateTD());
			trParent.append(_this.generateTD());
			trParent.append(_this.generateTD());
			trParent.append(_this.generateTD());
			$(clickBtn).click(_this.expandClick);
			$(trParent).dblclick(_this.dbClickParent);
			$(trParent).click(_this.clickTr);
			$(trParent).attr("data-level","level-"+key);
			$(trParent).addClass("ReportTable-tr-level0");
		   	$("tbody",_this.root).append(trParent);
			$.each(value.child,function(k,v){
				var trChild=$("<tr></tr>");
				trChild.append(_this.generateTD().text(v.rname).addClass("ReportTable-tr-level1-td").click(_this.clickItem));
				trChild.append(_this.generateTD().text(v.rdesc));
				trChild.append(_this.generateTD().text(v.lastupd));
				var cycle="";
				if(v.cycle=='day'){
					cycle="日报表";
				}else if(v.cycle=='month'){
					cycle="月报表";
				}
				trChild.append(_this.generateTD().text(cycle));
				var favsnumTD=_this.generateTD();
				if(parseFloat(v.favsnum)>0){
					favsnumTD.append("已收藏");
				}else{
					var favsnumBtn=$("<span class='ReportTable-tr-level1-favsnum-btn'>加入收藏</span>");
					$(favsnumBtn).click(_this.addFavorite);
					favsnumTD.append(favsnumBtn);
				}
				$(favsnumTD).addClass("ReportTable-tr-level1-align");
				trChild.append(favsnumTD);
				$(trChild).data("item",v);
				$(trChild).click(_this.clickTr);
				$(trChild).attr("data-level","level-"+key+"-"+k);
				if(k%2==0){
					$(trChild).addClass("ReportTable-tr-level1-single");
				}
				$(trChild).addClass("ReportTable-tr-level1");
		   		$("tbody",_this.root).append(trChild);
			})
		})
	}
	_this.load=function(items){
		if(items){
			_this.datas=items;
		}
		_this.showReport();
	}
	_this.hide=function(){
		$(_this.root).hide();
	}
	_this.show=function(){
		$(_this.root).show();
	}
	_this.on('mount',function(){
		_this.showReport();
	});
</ReportTable>