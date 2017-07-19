riot.tag2('collecttable', '<table class="table table-bordered"> <thead class="CollectTable-thead"> <tr> <th class="CollectTable-thead-no">序号</th> <th class="CollectTable-thead-title">收藏标题</th> <th class="CollectTable-thead-type">收藏类型</th> <th class="CollectTable-thead-time">收藏时间</th> <th class="CollectTable-thead-dell">操作</th> </tr> </thead> <tbody class="CollectTable-tbody"> <tr each="{data,idx in datas}" class="CollectTable-tbody-single{idx%2}" onclick="{clickTr}"> <td class="CollectTable-tbody-no">{data.row_no}</td> <td class="CollectTable-tbody-title" data-uri="{data.resource_uri}" onclick="{clickItem}">{data.resource_name}</td> <td class="CollectTable-tbody-type">{data.resource_type}</td> <td class="CollectTable-tbody-time">{data.create_dt}</td> <td class="CollectTable-tbody-dell"><a data-id="{data.id}" onclick="{clickDell}">删除</a></td> </tr> </tbody> </table>', '', 'class="CollectTable"', function(opts) {
	var _this=this;
	_this.datas=opts.datas||[];
	_this.mixin(BoxCommpent);
	_this.clickTr=function(e){
		var clickTr=e.currentTarget;
		$(".clicked",_this.root).removeClass("clicked");
		$(clickTr).addClass("clicked");
	}
	_this.clickItem=function(e){
		_this.opts.clickitem.call(this,e.target.innerText,$(e.target).attr("data-uri"));
	}
	_this.clickDell=function(e){
		_this.opts.clickdell.call(this,$(e.target).attr("data-id"));
	}
	_this.load=function(items){
		if(items){
			_this.datas=items;
		}
		_this.update();
	}
	_this.on('mount',function(){
	});
}, '{ }');