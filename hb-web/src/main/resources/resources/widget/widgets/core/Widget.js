Widget = {
	regIdBuffer:{},
	regTypeBuffer:{},
	create:function(widgetType,opts){
		if(!widgetType||!opts)return;
		var widget;
		if(opts.appendTo){
			if(_.isObject(opts.appendTo)){
				widget=this.appendToMobj(widgetType,opts);
			}else{
				widget=this.appendToById(widgetType,opts);
			}
		}else if(opts.applyTo){
			var domElement=$(opts.applyTo);
			widget=riot.mount(domElement.get(0),widgetType,opts)[0];
		}else{
			widget=riot.mount($("<div></div>").get(0),widgetType,opts)[0];
		}
		this.register(widget,widgetType);
		return widget;
	},
	register:function(widget,widgetType){
		var wid = widget.wid;
		if(wid){
			this.regIdBuffer[wid]=widget;
		}
		if(!this.regTypeBuffer[widgetType]){
			this.regTypeBuffer[widgetType]=[];
		}
		this.regTypeBuffer[widgetType].push(widget);
	},
	destory:function(widOrTagType){
		var widget=this.find(widOrTagType);
		if(_.isArray(widget)){
			_.each(widget,function(element,index,list){
				element.unmount();
			});
			this.regTypeBuffer[widOrTagType]=null;
		}else if(!_.isEmpty(widget)){
			widget.unmount();
			this.regIdBuffer[widOrTagType]=null;
		}
	},
	find:function(widOrTagType){
		var widget=this.regIdBuffer[widOrTagType];
		if(!widget){
			widget=this.regTypeBuffer[widOrTagType];
		}
		return widget;
	},
	appendToById:function(widgetType,opts){
		var registedObj = this.find(opts.appendTo);
		if(_.isEmpty(registedObj)||_.isArray(registedObj)){
			widget = riot.mount($("<div></div>").get(0),widgetType,opts)[0];
			var domElement=$(opts.appendTo);
			domElement.append(widget,widget.root);
			return widget;
		}else{
			this.appendToMobj(widgetType,opts);
		}
	},
	appendToMobj:function(widgetType,opts){
		var container=opts.appendTo;
		var widget=riot.mount($("<div></div>").get(0),widgetType,opts)[0];
		if(_.isFunction(container.addItem)){
			container.addItem(widget);
		}
		return widget;
	}
}