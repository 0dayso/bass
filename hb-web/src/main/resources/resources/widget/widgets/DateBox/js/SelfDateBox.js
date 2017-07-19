riot.tag2('selfdatebox', '<span class="SelfDateBox-name" if="{opts.name}">{opts.name} : </span> <div class="SelfDateBox-start-div"> <label class="SelfDateBox-start">{startvalue}</label> </div> <span class="SelfDateBox-split">~</span> <div class="SelfDateBox-end-div"> <label class="SelfDateBox-end">{endvalue}</label> </div> <div class="clear-float"></div>', '', 'class="SelfDateBox"', function(opts) {
	_self = this;
	this.mixin(BoxCommpent);
	this.getValue = function(){
		return {"startdate":_self.startvalue,"enddate":_self.endvalue};
	}
	this.getFormat = function(){
		return this.format;
	}
	this.getDate=function(format,days){
	   var now=new Date();
	   if(days>=1){
	   		now=new Date(now.getTime()-86400000*days);
	   		}
	   var yyyy=now.getFullYear(),mm=(now.getMonth()+1).toString(),dd=now.getDate().toString();
	   if(mm.length==1){
	   		mm='0'+mm;
	   		}
	   if(dd.length==1){
	   		dd='0'+dd;
	   		}
	   if(format=="yyyy"){
			return yyyy;
		}else if(format=="yyyy-mm"){
			return yyyy+"-"+mm;
		}else{
			return yyyy+'-'+mm+'-'+dd;
		}
  	}
	this.date = function(format,select){
		var start_select = function(value){
			_self.startvalue = value;
			if(select){
				select.call(_self,format,_self.getValue());
			}
		}
		var end_select = function(value){
			_self.endvalue = value;
			if(select){
				select.call(_self,format,_self.getValue());
			}
		}
		var dateStart = {
			JqElement:$(this.root).find(".SelfDateBox-start"),
			format:format,
			select:start_select
		}
		var dateEnd = {
			JqElement:$(this.root).find(".SelfDateBox-end"),
			format:format,
			select:end_select
		}
		DateBoxUtil.date(dateStart);
		DateBoxUtil.date(dateEnd);
	}
	this.startvalue=opts.defaultstartDate||this.getDate(opts.format,7);
	this.endvalue=opts.defaultendDate||this.getDate(opts.format);
	this.on("mount",function(){
		this.format = opts.format;
		this.date(opts.format,opts.select);
	});
}, '{ }');