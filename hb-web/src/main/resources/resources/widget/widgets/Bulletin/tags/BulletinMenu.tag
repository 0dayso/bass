<BulletinMenu class="bulletin-menu">
	<div class="panel panel-primary">
		<div class="panel-heading bulletin-menu-title">
	      <span class="panel-title bulletin-menu-title-text">{opts.titleText}</span>
		  </a>
		</div>
   		<div class="bulletin-menu-context">
		</div>
	</div>

this.mixin(BoxCommpent);
this.opts.dataList = opts.dataList;
this.showLevel = opts.showLevel||1;
this.opts.fnDblClick = opts.fnDblClick;
this.menuId = '';
this.clickTag = 1;

this.setRow = function(row,menuLevel){	
	var ui_padding='';
	var menuElement = $("<ul class='nav nav-pills' ><li class='bulletin-menu-li-text'>"+row.menuName+"</li></ul>");
	var clickElement = $("<i class='icon-angle-down icon-large' style='float: right;padding-right: 10px;'></i>");
	
	$('.bulletin-menu-context',this.root).append(menuElement,menuElement.root);

	if(menuLevel>0){
		ui_padding=menuElement.css('padding-left');
		menuElement.css('padding-left',(26+15*menuLevel)+'px');
	}
	if(row.hasChild != null && row.hasChild == 'Y'){
		menuElement.append(clickElement,clickElement.root);
	}
	return menuElement;
}
this.initData = function(dataList,menuLevel){
	var levelClear = false;
	if(!menuLevel){
		menuLevel = 0;
	}
	var childrenElementArr = [];
	for(var i =0;i<dataList.length;i++){
		var menuElement = this.setRow(dataList[i],menuLevel);
		if(menuLevel>0){
			var name = dataList[i].menuName;
			menuElement.css('display','none');
			childrenElementArr.push(menuElement);
		}
		if(dataList[i].hasChild != null && dataList[i].hasChild == 'Y' && dataList[i].children){
			var _childrenElementArr  = this.initData(dataList[i].children,menuLevel+1);
			var clickElement = $(menuElement.children(':last')[0]);
			if(_childrenElementArr.length>0){
				childrenElementArr.push(_childrenElementArr);
			}	
		}
			this.initFunction(menuElement,'click',this.fnClick,{'childrenElementArr':_childrenElementArr,'self':this,'eventElement':menuElement,'menuId':dataList[i].menuId});
			this.initFunction(menuElement,'dblclick',this.fnDblClick,{'menuId':dataList[i].menuId,'self':this,'eventElement':menuElement});
	}
	return childrenElementArr;
}
this.fnClick = function(e){
	var _self = e.self;
	var eventElement = e.eventElement;
	$('.bulletin-menu-context ul',_self.root).removeClass('bulletin-menu-ul-background-color');
	eventElement.addClass('bulletin-menu-ul-background-color');
	_self.menuId = e.menuId;
	setTimeout(function(){
		if(_self.clickTag!=2){
			if(e.childrenElementArr!=null&&e.childrenElementArr.length > 0){
				_self.initClickHideOrShow(e);
			}
		    			
		}
	},200);
}
this.fnDblClick = function(e){
	var _self = e.self;
	var eventElement = e.eventElement;

	$('.bulletin-menu-context ul',_self.root).removeClass('bulletin-menu-ul-background-color');
	eventElement.addClass('bulletin-menu-ul-background-color');
	_self.menuId = e.menuId;

	_self.clickTag = 2;
	if(_self.opts.fnDblClick){
		_self.opts.fnDblClick.call(_self,e.menuId);
	}
	setTimeout(function(){
			_self.clickTag = 1;
	},200);
}

this.initClickHideOrShow = function(e){
	var _self = e.self;
	var childrenElementArr = e.childrenElementArr;
	var eventElement = e.eventElement;
	var parentState = e.parentState;
	var showLevel = e.showLevel;
	if(!showLevel){
		showLevel = 0;
	}
	if(!parentState){
		parentState =  eventElement.css('display');
		var smallImgElement = $(eventElement.children(':last')[0]);
		var smallImgState = smallImgElement.attr('class');
		if(smallImgState == 'icon-angle-down icon-large'){
			smallImgElement.attr('class','icon-angle-up icon-large');
		}else{
			smallImgElement.attr('class','icon-angle-down icon-large');
		}
	}

	for(var i =0;i<childrenElementArr.length;i++){
		var childrenElement = childrenElementArr[i];
		if(_.isArray(childrenElement)){
			$(childrenElementArr[i-1].children(':last')[0]).attr('class','icon-angle-down icon-large');
			_self.initClickHideOrShow({'childrenElementArr':childrenElement,'self':_self,'parentState':childrenElementArr[i-1].css('display'),'showLevel':showLevel+1});			
		}else{
			if(childrenElement.css('display') == 'none' && parentState != 'none'){
				if(showLevel==this.showLevel){
					continue;
				}
				childrenElement.show();
			}else{
				childrenElement.hide();
			}
		}
		
	}
}

this.initFunction = function(jObj,enventType,fn,data){
	if(!jObj||!enventType||!fn)return;
	jObj.on(enventType,data,function(e){fn(e.data);});
}

this.updateTable = function(opts){
	this.reportView(opts);
}

this.getMenuId = function(){
	return this.menuId;
}

this.on("mount updated",function(){
	this.initData(this.opts.dataList);
	if(opts.width){
		$(this.root).css('width',opts.width);
	}
	this.menuId = opts.dataList[0].menuId;
	$('.bulletin-menu-context ul:first-child',this.root).addClass('bulletin-menu-ul-background-color');
	if(opts.titleColor){
		$(".bulletin-menu-title",this.root).css('background-color',opts.titleColor);
		$(".bulletin-menu-title",this.root).css('border-color',opts.titleColor);
		$(".icon-angle-down",this.root).css('color',opts.titleColor);
	}
});

</BulletinMenu>