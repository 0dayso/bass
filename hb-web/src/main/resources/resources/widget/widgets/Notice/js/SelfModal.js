riot.tag2('selfmodal', '<div data-id="modal" class="modal fade"> <div class="modal-dialog Modal-context"> <div class="modal-content"> <div class="modal-header Modal-head"> <button type="button" class="close" data-dismiss="modal"> <span aria-hidden="true">&times;</span><span class="sr-only">Close</span> </button> <h3 class="modal-title">近期公告:</h3> </div> <div class="modal-body Modal-bdy"> <ul class="Modal-bdy-ul"> <li class="Modal-bdy-ul-item" each="{data,idx in datas}"> <span class="Modal-bdy-ul-item-title">{data.newstitle}</span> <span class="Modal-bdy-ul-item-title">时间:{data.newsdate}</span> <div class="Modal-bdy-ul-item-context">{data.newsmsg}</div> </li> </ul> </div> <div class="modal-footer Modal-foot"> <button onclick="{close}" type="button" class="btn btn-default">确认</button> </div> </div> </div> </div>', '', '', function(opts) {
	_this=this;
	_this.datas=opts.datas||[];
	_this.mixin(BoxCommpent);
	_this.show=function(){
		if(_this.datas.length==0){
			return;
		}
		var h=document.documentElement.clientHeight*0.5;
		var w=document.documentElement.clientWidth*0.6;
		$(".Modal-bdy",_this.root).css("height",h);
		$(".Modal-context",_this.root).css("width",w);
		$("div[data-id='modal']",_this.root).modal({show : true});
	}
	_this.close=function(e){
		$("div[data-id='modal']",_this.root).modal('hide');
	}
}, '{ }');