<KpiTable>
	<table class="table table-hover table-bordered kpitable">
		<thead class="tableThead">
			<tr class="tableTr"></tr>
		</thead>
		<tbody class="tableTbody">
		</tbody>
	</table>

	this.mixin(BoxCommpent);
	var dayHead = "<th></th><th>日</th><th>较昨日</th><th>较上月同期</th><th>日累计</th><th>较去年同期</th><th>操作</th>";
	var monthHead = "<th></th><th>月</th><th>较上月</th><th>较去年同期</th><th>月累计</th><th>较去年同期</th><th>操作</th>";
	var _self = this;
	function showHead(cycle){
		$(".tableTr",_self.root).empty();
		if(cycle == "yyyymmdd"||cycle == "yyyy-mm-dd"){
			$(".tableTr",_self.root).append(dayHead);
		}else{
			$(".tableTr",_self.root).append(monthHead);
		}
	}

	function indentNode(content,level){
		for(var i=0;i<level;i++){
			content = "&nbsp;"+content;
		}
		return content;
	}

	_self.analysis=function(e){
        if(!_self.opts.analysis)return;
        _self.opts.analysis.call(this,$(e.target.parentElement.parentElement).data("data"));
    }

    _self.collect=function(e){
        if(!_self.opts.collect)return;
        _self.opts.collect.call(this,$(e.target.parentElement.parentElement).data("data"));
    }
    
	function addKpiRow(data,dimType,dimValue,dimName,level,type,$parentTr){
		var $tr = $("<tr class='tableTr'></tr>");
		$tr.data("data",data);
		$tr.data("menuId",data.menuId);

		$tr.data("isDimShow",false);
		$tr.data("level",level+1);
		$tr.data("type",type);
		$tr.data("dimType",dimType);
		$tr.data("dimValue",dimValue);

		if(!data.valueD)data.valueD={};
		if(!data.valueAD)data.valueAD={};

		$tr.dblclick({target:$tr},dimAnalysis);

		$tr.append("<td>"+indentNode(data.menuName||dimName,level)+"</td>"+
				   "<td class='kpitable-td'>"+(data.valueD.current||"--")+"</td>"+
				   "<td class='kpitable-td'>"+(data.valueD.todayOnYesterday||"--")+"</td>"+
				   "<td class='kpitable-td'>"+(data.valueD.monthOnMonth||"--")+"</td>"+
				   "<td class='kpitable-td'>"+(data.valueAD.current||"--")+"</td>"+
				   "<td class='kpitable-td'>"+(data.valueAD.yearOnYear||"--")+"</td>");
		var td=$("<td class='kpitable-td-dell'></td>");
		var spanAnal=$("<span class='tableAnalysis'>分析</span>");
		//var spanColl=$("<span class='tableCollect' >.收藏</span>");
		$(spanAnal).click(_self.analysis);
		//$(spanColl).click(_self.collect);
		td.append(spanAnal);
		//td.append(spanColl);
		$tr.append(td);

		if($parentTr){
			$parentTr.after($tr);
		}else{
			$(".tableTbody",_self.root).append($tr);
		}
	}


	function dimAnalysis(e){
		var $target = e.data.target;
		var level = $target.data("level");
		var isDimShow = $target.data("isDimShow");
		$target.data("isDimShow",!isDimShow);
		if(isDimShow){
			$target.nextAll().each(function(i){
				if($(this).data("type")=="dim"&&$(this).data("level")>level){
					$(this).hide();
				}else{
					return false;
				}
			});
		}else if($target.data("isload")){
			$target.nextAll().each(function(i){
				if($(this).data("type")=="dim"&&$(this).data("level")==(level+1)){
					$(this).show();
				}else if($(this).data("type")=="dim"&&$(this).data("level")>(level+1)){
					return true;
				}else{
					return false;
				}
			});
		}else{
			var menuId = $target.data("menuId");
			var dimType = $target.data("dimType");
			var dimValue = $target.data("dimValue");
			var rowType = $target.data("type");

			var kpiData;
			if(rowType == "menu"){
				kpiData = $target.data("data");
			}else{
				if(_self.opts.callback.getKpiDimData){
					kpiData = _self.opts.callback.getKpiDimData.call(_self,menuId,dimType,dimValue);
				}
			}
			if(!kpiData)return;

			$target.data("isload",true);

			var value_d_children = (kpiData.valueD||{}).children||{};
			var value_ad_children = (kpiData.valueAD||{}).children||{};
			var childrenLen = (value_d_children.length||value_ad_children.length)||0;

			for(var i=childrenLen-1;i>=0;i--){
				var valueD = value_d_children[i]||{};
				var valueAD = value_ad_children[i]||{};

				var child_dimType = valueD.dimType||valueAD.dimType;
				var child_dimValue = valueD.dimValue||valueAD.dimValue;
				var child_dimName = valueD.dimName||valueAD.dimName;

				var data = {
					menuId:menuId,
					valueD:valueD,
					valueAD:valueAD
				}
				if(dimType==child_dimType&&dimValue==child_dimValue){
					return;
				}
				addKpiRow(data,child_dimType,child_dimValue,child_dimName,level,'dim',$target);
			}
		}
	}

	function showKpiData(data,dimType,dimValue,dimName){
		$(".tableTbody",_self.root).empty();
		addKpiRow(data,dimType,dimValue,dimName,0,'menu');
		if(data.children){
			for(var i=0;i<data.children.length;i++){
				addKpiRow(data.children[i],dimType,dimValue,dimName,1,'menu');
			}
		}
	}

	this.showKpi=function(data,cycle,dimType,dimValue,dimName){
		showHead(cycle||'yyyymmdd');
		showKpiData(data,dimType,dimValue,dimName);
	}

	this.on("mount",function(){
		opts.callback = opts.callback||{};
		this.showKpi(opts.data,opts.cycle,opts.dimType,opts.dimValue,opts.dimName);
	})
</KpiTable>