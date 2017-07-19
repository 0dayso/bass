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