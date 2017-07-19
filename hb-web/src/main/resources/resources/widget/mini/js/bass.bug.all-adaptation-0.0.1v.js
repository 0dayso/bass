riot.tag2('bulletinimage', '<div class="BulletinImage"> <img class="imgTitle img-responsive" riot-src="{opts.src}"></img> <div onclick="{nameClick}" onmouseover="{imgMouseover}" onmouseleave="{imgMouseleave}"> <i class="icon-list-alt"></i>&nbsp;{opts.name} </div> <div onclick="{dateClick}" onmouseover="{imgMouseover}" onmouseleave="{imgMouseleave}"> <i class="icon-time"></i>&nbsp;{opts.date} </div> </div>', '', '', function(opts) {

	this.mixin(BoxCommpent);
	this.nameClick = function(e){
		if(!this.opts.nameClick)return;
		this.opts.nameClick.call(this,this.opts.name);
	}.bind(this)
	this.dateClick = function(e){
		if(!this.opts.dateClick)return;
		this.opts.dateClick.call(this,this.opts.date);
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
riot.tag2('bulletinmenu', '<div class="panel panel-primary"> <div class="panel-heading bulletin-menu-title"> <span class="panel-title bulletin-menu-title-text">{opts.titleText}</span> </a> </div> <div class="bulletin-menu-context"> </div> </div>', '', 'class="bulletin-menu"', function(opts) {

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

}, '{ }');
riot.tag2('bulletinnormal', '<div class="panel panel-primary"> <div class="panel-heading bulletin-normal-title"> <span class="panel-title bulletin-normal-title-text">{opts.titleText}</span> <a class="panel-title icon-double-angle-down bulletin-normal-title-func" onclick="{clickTitleFunc}"> {opts.funcTitle} </a> </div> <div class="bulletin-normal-context"> <ul class="nav nav-pills" each="{row in datas}" if="{row.num <= lineNum}" onclick="{clickRow}"> <li class="bulletin-normal-li-rownum"> <span class="label label-default">{row.num}</span> </li> <li class="bulletin-normal-li-text">{row.text}</li> <li class="bulletin-normal-li-remark">{row.remark}</li> </ul> </div> </div>', '', 'class="bulletin-normal"', function(opts) {
	this.datas=opts.datas;
	this.lineNum=opts.lineNum;
	this.mixin(BoxCommpent);
	this.clickTitleFunc = function(e){
		if(!this.opts.funcClick)return;
		this.opts.funcClick.call(this,this.opts.funcTitle);
	}.bind(this)
	this.clickRow = function(e){
		if(!this.opts.rowClick)return;
		this.opts.rowClick.call(this,e.item.row);
	}.bind(this)
	this.load=function(items){
		if(items){
			this.datas=items;
		}else{
			this.datas=opts.datas;
		}
		this.update();
	}
	this.on('mount',function(){
		if(opts.width){
			$(this.root).css('width',opts.width);
		}
		if(opts.titleColor){
			$(".bulletin-normal-title",this.root).css('background-color',opts.titleColor);
			$(".bulletin-normal-title",this.root).css('border-color',opts.titleColor);
		}
})
}, '{ }');
riot.tag2('bulletinsimple', '<div class="panel panel-primary"> <div class="panel-heading bulletin-simple-title"> <span class="panel-title bulletin-simple-title-text">{opts.titleText}</span> <a class="panel-title icon-double-angle-down bulletin-simple-title-func" onclick="{clickTitleFunc}"> {opts.funcTitle} </a> </div> <div class="bulletin-simple-context"> <ul class="nav nav-pills" each="{row in datas}" if="{row.num <= lineNum}" onclick="{clickRow}"> <li class="bulletin-simple-li-text">{row.text}</li> </ul> </div> </div>', '', 'class="bulletin-simple"', function(opts) {


	this.datas=opts.datas;
	this.lineNum=opts.lineNum;
	this.mixin(BoxCommpent);
	this.clickTitleFunc = function(e){
		if(!this.opts.funcClick)return;
		this.opts.funcClick.call(this,this.opts.funcTitle);
	}.bind(this)
	this.clickRow = function(e){
		if(!this.opts.rowClick)return;
		this.opts.rowClick.call(this,e.item.row);
	}.bind(this)
	this.load=function(items){
		if(items){
			this.datas=items;
		}else{
			this.datas=opts.datas;
		}
		this.update();
	}
	this.on('mount',function(){
		if(opts.width){
			$(this.root).css('width',opts.width);
		}
		if(opts.titleColor){
			$(".bulletin-simple-title",this.root).css('background-color',opts.titleColor);
			$(".bulletin-simple-title",this.root).css('border-color',opts.titleColor);
		}
	})
}, '{ }');
riot.tag2('combobox', '<label class="headCls" onclick="{datas.length > 0?clickHead:\'\'}"> <div class="headCls-text" data-dimvalue="{defaultDimvalue}" data-dimtype="{defaultDimtype}" title="{defaultDimname}"> {defaultDimname}</div> <div class="icon-caret-down"></div> <div class="clear-float"></div> </label> <div class="selectPosition"> <div class="selectPosition-block" data-level="level-1"> <div class="selectPosition-search" if="{datas.length > linenum}"> <input class="selectPosition-search-input" type="text"> <i class="icon-search selectPosition-search-btn" onclick="{searchclick}" data-dimtype="{datas[0].dimtype}"></i> </div> <div each="{obj,idx in datas}" class="selectPosition-item" if="{datas.length > 0&&idx <= linenum-1}"> <div class="selectPosition-item-text" data-dimvalue="{obj.dimvalue}" data-dimtype="{obj.dimtype}" title="{obj.dimname}" ondblclick="{isNormal?null:itemdbclick}" onclick="{isNormal?clickNormal:clickTree}">{obj.dimname}</div> </div> <div class="selectPosition-overflow" if="{datas.length > linenum}" onclick="{showMoredata}" data-dimtype="{obj.dimtype}">...</div> </div> <div class="clear-float"></div> </div>', '', 'class="Select"', function(opts) {
    var _this=this;
    var hasClicked=false;
    var isdbclick;
    var item={};
    var dataCache={};
    _this.isNormal=(opts.type=='tree'?'tree':'normal')=='normal';
    _this.linenum=opts.linenum||8;
    _this.datas=opts.data;
    _this.mixin(BoxCommpent);
    _this.setItem=function(element){
        item["dimvalue"]=$(element).attr("data-dimvalue");
        item["dimtype"]=$(element).attr("data-dimtype");
        item["dimname"]=$(element).text();
    }
    _this.setDefault=function(dimvalue,dimname,dimtype){
        _this.defaultDimvalue=dimvalue;
        _this.defaultDimname=dimname;
        _this.defaultDimtype=dimtype;
        var clicktmp=$(".selectPosition-item-text",$(".clickCls",_this.root));
        var tmp={};
        for(var i=clicktmp.length-1;i>=0;i--){
            tmp[i]=$(clicktmp[i]).attr("data-dimvalue");
        }
        item["treeInfo"]=tmp;
    }
    _this.initDefaultDimvalue=function(val){
        if(typeof(_this.datas) == "undefined"){
            _this.datas=[];
        }
        if(_this.datas.length>0){
            $.each(_this.datas,function(k,v){
                if(val){
                    if(val==v.dimvalue){
                        _this.setDefault(v.dimvalue,v.dimname,v.dimtype);
                        return false;
                    }
                }else{
                _this.setDefault(v.dimvalue,v.dimname,v.dimtype);
                return false;
                }
            });
        }else{
            _this.setDefault("","无数据","");
        }
        if(_this.datas.length>_this.linenum){
            dataCache[_this.datas[0].dimtype]=_this.datas;
            dataCache[_this.datas[0].dimtype+"_isSearch"]=false;
            dataCache[_this.datas[0].dimtype+"_linenum"]=_this.linenum;
        }

    }
    _this.initDefaultDimvalue(opts.defaultDimvalue);
    _this.setValue=function(val){
        _this.initDefaultDimvalue(val);
        _this.update();
    }
    _this.getDimData=function(item){
        return _this.opts.getDimData.call(this,item);
    }
    _this.getitembody=function(dimtype,dimvalue,dimname){
        var divitem=$('<div class="selectPosition-item"></div>');
        var divtext=$('<div class="selectPosition-item-text"></div>');
        divtext.attr("data-dimvalue",dimvalue);
        divtext.attr("data-dimtype",dimtype);
        divtext.attr("title",dimname);
        divtext.text(dimname);
        divtext.dblclick(_this.itemdbclick);
        divtext.click(_this.clickTree);
        divitem.append(divtext);
        return divitem;
    }
    _this.itemdbclick=function(e){
        isdbclick=true;
        _this.setDefault($(e.target).attr("data-dimvalue"),$(e.target).text(),$(e.target).attr("data-dimtype"));
       $(".selectPosition*",_this.root).hide();
        _this.setItem(e.target);
        _this.opts.dbclickFunc.call(this,item);
        _this.update();
    }
    _this.clickNormal=function(e){
        hasClicked=true;
        var targetItem=e.target.parentElement;
        var targetBlock=targetItem.parentElement;
        $(targetBlock).children().removeClass("clickCls");
        $(targetItem).addClass("clickCls");
        _this.setDefault($(e.target).attr("data-dimvalue"),$(e.target).text(),$(e.target).attr("data-dimtype"));
       $(".selectPosition*",_this.root).hide();
        _this.setItem(e.target);
        _this.opts.clickFunc.call(this,item);
    }
    _this.clickTree=function(e){
        hasClicked=true;
        var targetItem=e.target.parentElement;
        var targetBlock=targetItem.parentElement;
        $(targetBlock).children().removeClass("clickCls");
        $(targetItem).addClass("clickCls");
        isdbclick=false;
        _this.setItem(e.target);
        var height=$(e.target).height()+3;
        var width=$(e.target.parentElement.parentElement).width()+6;
        $(targetBlock).nextAll().each(function(k,v){
            if(v.className=="clear-float"){
                return;
            }else{
                $(v).remove();
            }
        })
        window.setTimeout(
            function(){
                if(isdbclick!=false)return;
                var extendDatas=_this.getDimData(item);
                if(extendDatas){
                    if(extendDatas.length>0){
                        var blockDiv=$('<div class="selectPosition-block"></div>');
                        $.each(extendDatas,function(k,v){
                            if(k>=_this.linenum){
                                return false;
                            }
                            blockDiv.append(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                        });
                        if(extendDatas.length>_this.linenum){
                            var searchDiv=$('<div class="selectPosition-search"></div>');
                            var searchInput=$('<input class="selectPosition-search-input" type="text">');
                            var searchBtn=$('<i class="icon-search selectPosition-search-btn"></i>');
                            var overflowDiv=$('<div class="selectPosition-overflow" if={idx == linenum-1}>...</div>');
                            searchBtn.attr("data-dimtype",extendDatas[0].dimtype);
                            searchBtn.click(_this.searchclick);
                            overflowDiv.attr("data-dimtype",extendDatas[0].dimtype);
                            overflowDiv.click(_this.showMoredata);
                            dataCache[extendDatas[0].dimtype]=extendDatas;
                            dataCache[extendDatas[0].dimtype+"_isSearch"]=false;
                            dataCache[extendDatas[0].dimtype+"_linenum"]=_this.linenum;
                            searchDiv.append(searchInput);
                            searchDiv.append(searchBtn);
                            blockDiv.prepend(searchDiv);
                            blockDiv.append(overflowDiv);
                        }
                        $(blockDiv).slideDown("fast");
                       $(".clear-float",$(".selectPosition",_this.root)).before(blockDiv);
                    }
                }
            }
        ,500);
    }
    _this.searchclick=function(e){
        var targetBlock=e.target.parentElement.parentElement;
        $(targetBlock).nextAll().each(function(k,v){
            if(v.className=="clear-float"){
                return;
            }else{
                $(v).remove();
            }
        })
        var searchLevel=$(e.target).attr("data-dimtype");
        var searchContext=$(e.target).prev().val();
        var lastEle;
        $(e.target.parentElement).nextAll().each(function(k,v){
            if(v.className=="selectPosition-overflow"){
                lastEle=v;
                return;
            }else{
                $(v).remove();
            }
        })
        if(searchContext){
                var searchResult=new Array();
                var i=0;
                $.each(dataCache[searchLevel],function(k,v){
                    if(v.dimname.indexOf(searchContext)>=0){
                        searchResult.push(v);
                        i++;
                    }
                })
                if(i==0){
                    $(lastEle).before($('<div><i class="noresult">无数据</i></div>'));
                    $(lastEle).hide();
                }else{
                    dataCache[dataCache[searchLevel][0].dimtype+"_isSearch"]=true;
                    dataCache[dataCache[searchLevel][0].dimtype+"_search"]=searchResult;
                    dataCache[dataCache[searchLevel][0].dimtype+"_linenum"]=_this.linenum;
                }
                if(i+1<=_this.linenum){
                    $(lastEle).hide();
                }
                $.each(searchResult,function(k,v){
                    if(k>=_this.linenum){
                       $(lastEle).show();
                       return false;
                    }
                    $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                })
        }else{
            dataCache[dataCache[searchLevel][0].dimtype+"_isSearch"]=false;
            dataCache[dataCache[searchLevel][0].dimtype+"_search"]="";
            dataCache[dataCache[searchLevel][0].dimtype+"_linenum"]=_this.linenum;
            $.each(dataCache[searchLevel],function(k,v){
                if(k>=_this.linenum){
                    $(lastEle).show();
                    return false;
                }
                $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
            })
        }
    }
    _this.load=function(items){
        hasClicked=false;
        if(typeof(items) == "undefined"){
            items=[];
        }
        if(items){
            this.datas=items;
        }else{
            this.datas=opts.data;
        }
        $(".selectPosition-block",this.root).each(function(k,v){
            if(k>0){
                $(v).remove();
            }
        })
        _this.initDefaultDimvalue();
        $(".selectPosition",_this.root).hide();
        this.update();
    }
    _this.getDimtype=function(){
        return _this.defaultDimtype;
    }
    _this.getDimvalue=function(){
        return _this.defaultDimvalue;
    }
    _this.getDimname=function(){
        return _this.defaultDimname;
    }
    _this.showMoredata=function(e){
        var tmpData;
        var lastEle=e.target;
        var showLevel=$(e.target).attr("data-dimtype");
        var isSearch=dataCache[showLevel+"_isSearch"];
        var lineNum=dataCache[showLevel+"_linenum"];
        var newLinenum=parseFloat(lineNum)+parseFloat(_this.linenum);
        if(isSearch){
            tmpData=dataCache[showLevel+"_search"];
            if(tmpData.length<=lineNum){
                $(lastEle).hide();
            }
            $.each(tmpData,function(k,v){
                    if(k<lineNum){
                        return;
                    }
                    if(k>=newLinenum){
                       $(lastEle).show();
                       return false;
                    }
                    $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                })
        }else{
            tmpData=dataCache[showLevel];
            $.each(tmpData,function(k,v){
                    if(k<lineNum){
                        return;
                    }
                    if(k>=newLinenum){
                       $(lastEle).show();
                       return false;
                    }
                    $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                })
        }
        dataCache[showLevel+"_linenum"]=newLinenum;
        if(tmpData.length<=newLinenum){
            $(lastEle).hide();
        }
    }
    _this.clickHead=function(e){
            if(!hasClicked){
                var firstBlock=$("div[data-level='level-1']",_this.root);
                var clickItem=$(".clickCls",firstBlock);
                $(".selectPosition-item-text",firstBlock).each(function(k,v){
                        if($(v).attr("data-dimvalue")==_this.defaultDimvalue){
                            $(v.parentElement).addClass("clickCls");
                            return false;
                        }
                });
                $(".selectPosition",_this.root).data("isHidden",true);
            }
            hasClicked=true;
            if( $(".selectPosition",_this.root).data("isHidden")){
                $(".selectPosition",_this.root).slideDown("fast");
                $(".selectPosition",_this.root).data("isHidden",false);
            }else{
                $(".selectPosition",_this.root).hide();
                $(".selectPosition",_this.root).data("isHidden",true);
            }
    }
    _this.on('mounted',function(){
    })
}, '{ }'); 
riot.tag2('datebox', '<label class="dateChoice">{this.value}</label>', '', '', function(opts) {

	_self = this;
	this.mixin(BoxCommpent);
	this.getValue = function(){
		return this.value;
	}
	this.getFormat = function(){
		return this.format;
	}
	this.getNowDate = function(format){
		var now = new Date();
		var year = now.getFullYear();
		var month = (now.getMonth()+1)<10?"0"+(now.getMonth()+1):(now.getMonth()+1);
		var date = now.getDate()<10?"0"+now.getDate():now.getDate();
		if(format=="yyyy"){
			return year;
		}else if(format=="yyyy-mm"){
			return year+"-"+month;
		}else{
			return year+"-"+month+"-"+date;
		}
	}

	this.date = function(format,select){
		var real_select = function(value){
			_self.value = value;
			if(select){
				select.call(_self,format,value);
			}
		}
		var dateObj = {
			JqElement:$(this.root).find(".dateChoice"),
			format:format,
			select:real_select
		}
		DateBoxUtil.date(dateObj);
	}

	this.switchType = function(format){
		var $label = $("<label class='dateChoice'></label>");
		_self.value = this.getNowDate(format);
		_self.format = format;
		$label.html(_self.value);
		$(this.root).empty();
		$(this.root).append($label);
		this.date(format,opts.select);
	}

	this.value=this.getNowDate(opts.format);
	this.on("mount",function(){
		this.format = opts.format;
		this.date(opts.format,opts.select);
	});
}, '{ }');
riot.tag2('defaultlayouter', '<div class="float-left" each="{opts.items}"></div> <div class="clear-float"></div>', '', '', function(opts) {

	this.mixin(Layouter);
	var _self=this;
	this.addItem = function(widget){
		if(!widget||!widget.root)return;
		var $clear = $(".clear-float",this.root);
		var $floatLeft = $("<div class='float-left'></div>");
		$floatLeft.append(widget.root);
		this.setInterval($floatLeft);
		$clear.before($floatLeft);
	}.bind(this)
	this.addItems = function(items){
		if(!_.isArray(items))return;
		$.each(items,function(i,item){
			_self.addItem(item);
		});
	}.bind(this)
	this.on('mount updated',function(){
		this.setInterval('.float-left');
		$('.float-left',this.root).each(function(i,domElement){
			$(domElement).append(_self.opts.items[i].root);
		});
	});
}, '{ }');
riot.tag2('gridlayouter', '<div data-row-index="{rowindex}" each="{row,rowindex in opts.gridDefine}"> <div data-column-index="{columnIndex}" class="float-left" riot-style="width:{column.width}" each="{column,columnIndex in row}"> </div> <div class="clear-float"></div> </div>', '', '', function(opts) {

	this.mixin(Layouter);
	var _self = this;

	function setIntervalEl(item){
		var itemContainer = $("<div></div>");
		if(!item.opts.interval&&item.opts.interval!=0){
			item.opts.interval=opts.gridDefine[item.row][item.column].interval;
		}
		if(item.opts.interval||item.opts.interval==0){
			itemContainer.css("padding",item.opts.interval);
			itemContainer.append(item.root);
			return itemContainer;
		}else{
			return item.root;
		}
	}

	this.addItem=function(item){
		item.row = item.opts.row||0;
		item.column = item.opts.column||0;
		var $columnDiv=$("[data-row-index='"+item.row+"']",this.root).find("[data-column-index='"+item.column+"']");
		if($columnDiv.length){
			$columnDiv.append(setIntervalEl(item));
		}
	}
	this.addItems=function(items){
		$.each(items,function(index,item){
			_self.addItem(item);
		});
	}
	this.on('mount updated',function(){
		this.setInterval(".float-left");
		this.addItems(opts.items);
	})
}, '{ }');
riot.tag2('kpitable', '<table class="table table-hover table-bordered kpitable"> <thead class="tableThead"> <tr class="tableTr"></tr> </thead> <tbody class="tableTbody"> </tbody> </table>', '', '', function(opts) {

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
				   "<td>"+(data.valueD.current||"--")+"</td>"+
				   "<td>"+(data.valueD.todayOnYesterday||"--")+"</td>"+
				   "<td>"+(data.valueD.monthOnMonth||"--")+"</td>"+
				   "<td>"+(data.valueAD.current||"--")+"</td>"+
				   "<td>"+(data.valueAD.yearOnYear||"--")+"</td>"+
				   "<td><span class='tableAnalysis'>分析<span>·<span class='tableCollect'>收藏</span></td>");
		if($parentTr){
			$parentTr.after($tr);
		}else{
			$(".tableTbody",_self.root).append($tr);
		}
	}

	this.analysis=function(e){
        if(!_self.opts.analysis)return;
        _self.opts.analysis.call(this,e.item.value);
    }

    this.collect=function(e){
        if(!_self.opts.collect)return;
        _self.opts.collect.call(this,e.item.value);
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
});
riot.tag2('notice', '<i class=" icon-volume-up icon-2x pull-left icon-muted notice-icon"></i> <span class="notice-title">{opts.title}</span> <label class="notice-text" riot-style="{opts.textStyle}">{opts.text}</label> <a href="{opts.href}" class="notice-moretitle" onclick="{opts.clickMore}" riot-style="{opts.moreTitleStyle}"> {opts.moreTitle} </a>', '', 'class="notice"', function(opts) {

    this.mixin(BoxCommpent);
	opts.clickMore=function(e){
			opts.listener.click.call(this,opts.title,opts.text,opts.moreTitle);
		}
	opts.href=opts.href||"javascript:void(0);";
	opts.moreTitle=opts.moreTitle||"更多";

}, '{ }');
riot.tag2('panel', '<div class="panel-heading panel-fix-head"> <h3 class="panel-title panel-fix-title">{opts.title}</h3> </div> <div class="panle-body panel-container"></div>', '', 'class="panel panel-info panel-fix-width"', function(opts) {
   	this.mixin(Container);
   	this.on("mount",function(){
        $(".panle-body",this.root).append($(this.layouter.root));
    })
}, '{ }');
riot.tag2('radiobox', '<span class="radioBoxOption" each="{opts.data}"> <i class="icon-circle-blank radioOption" value="{value}" onclick="{click}"></i> <label onclick="{click}">{text}</label> </span>', '', 'class="RadioContent"', function(opts) {
  	this.mixin(BoxCommpent);
    this.addOptions=function(data){
        opts.data.push(data);
        this.update();
    }
    var _this=this;
    var checkedValue;
    this.selected=function(value){
        $("i",_this.root).each(function(k,v){
            if(value==v.value){
                v.className="radioOption icon-circle";
                checkedValue=v.value;
            }else{
                v.className="radioOption icon-circle-blank";
            }
        });
        _this.update();
    }
    this.click=function(e){
        _this.selected(e.item.value);
        if(!_this.opts.checked)return;
        _this.opts.checked.call(this,e.item.value);
    }
    this.setValue=function(value){
        if(value==null||!_.contains(_.pluck(opts.data,'value'),value))
            value=opts.data[0].value;
        _this.selected(value);
    }
    this.on("mount",function(){
        _this.setValue(opts.defaultValue);
    })
}, '{ }');    
riot.tag2('selfbutton', '<button type="button" class="btn btn-default navbar-btn buttonshow" onclick="{click}">{opts.title}</button>', '', '', function(opts) {
    this.click=function(e){

    }
}, '{ }');
riot.tag2('selflabel', '<label id="{opts.id}" class="{opts.cls}">{opts.title}</label>', '', '', function(opts) {
}, '{ }');
riot.tag2('swiminglayouter', '<div data-column-index="{columnIndex}" class="float-left" riot-style="width:{column.width}" each="{column,columnIndex in gridDefine}"> </div> <div class="clear-float"></div>', '', '', function(opts) {

	this.mixin(Layouter);
	var _self = this;

	function setIntervalEl(item){
		if(!item.opts.interval&&item.opts.interval!=0){
			item.opts.interval=opts.gridDefine[item.column].interval;
		}
		$(item.root).css("margin",item.opts.interval);
	}
	this.addItem=function(item){
		item.column = item.opts.column||0;
		var $columnDiv=$(this.root).find("[data-column-index='"+item.column+"']");
		if($columnDiv.length){
			setIntervalEl(item);
			$columnDiv.append(item.root);
		}
	}
	this.addItems=function(items){
		$.each(items,function(index,item){
			_self.addItem(item);
		});
	}
	this.on('mount updated',function(){
		this.setInterval(".float-left");
		this.addItems(opts.items);
	})
}, '{ }');
riot.tag2('toolbar', '', '', 'class="toolbar"', function(opts) {

	var items = [];
	for(var i=0;i<opts.items.length;i++){
		var mark = $("<label class='mark'>|</label>");
		mark.root = mark;
		items.push(opts.items[i]);
		if(i<opts.items.length-1){items.push(mark);};
    }
    opts.items = items;
   	this.mixin(Container);
   	this.addMark = function(items){
        for(var i=0;i<items.length;i++){
            this.layouter.addItem(items[i]);
        }
   	}.bind(this)
   	this.on("updated",function(){
        $(this.layouter.root).appendTo(this.root);
    })
});    