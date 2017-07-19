//;(function() {

	//简单工厂模式,管理和组织组件
	var widget = function (options){
		this.options = options ;
		this.widgets = [];
		init = function (){
			if (Object.prototype.toString.call(this.options) === '[object Array]'){
				for (x in this.options){
					var _widget = initWidget(this.options[x]);
					if (_widget !== null){
						this.widgets.push(_widget);
					}
				}
			}else if (Object.prototype.toString.call(this.options) === '[object Object]'){
				this.widgets.push(initWidget(this.options));
				var _widget = initWidget(this.options);
					if (_widget !== null){
						this.widgets.push(_widget);
					}
			}
			return this.widgets;
		};
		initWidget = function(cfg){
			var _widget =null;
			if (cfg && cfg.id && cfg.widgetType){
				var _type = cfg.widgetType.toUpperCase();
				switch (_type) {
					case 'TEXT' : 
						_widget = new widgetFrom_text(cfg);
					break;
				}
			}
			return _widget;
		};
		return this;
	};
	var s = widget([{id:1,widgetType:'text'},{name:3}]).init();
	console.log(s.length);
	//widget({id:1}).init();
//})();

