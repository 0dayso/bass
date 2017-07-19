 /*
 *时间日期控件
 */
DateBoxUtil = {
	initParam:function(option){
		var o = {};	
		o.autoclose = true;
		o.todayHighlight = true;
		o.todayBtn = 'linked';
		o.language = "zh-CN";
		o.weekStart = option.weekStart||'1';
		o.format = option.format||'yyyy-mm-dd';
		o.multidate = option.multidate||'0';
		o.multidateSeparator = option.separator||',';
		o.startView = option.startView||0;         
		switch(option.format){
				case 'yyyy':o.minViewMode = 2;break;
				case 'yyyy-mm':o.minViewMode = 1;break;
				default:o.minViewMode = 0;break;
		}
		option.JqElement.datepicker(o).on('changeDate', function(e) {
			var date = e.format(option);
			switch(option.JqElement.prop("tagName").toUpperCase()){
				case 'LABEL': option.JqElement.text(date);break;
				case 'BUTTON': option.JqElement.text(date);break;
				default: option.JqElement.val(date);break;
			}
			if(option.select)option.select.call(this,date);
		});
	},
	date:function(option){
		if(!option)return;
		if(!option.JqElement)return;

		this.initParam(option);
 	}
}

	