riot.tag2('selfselect', '<span class="SelfSelect-name" if="{opts.name}">{opts.name}:</span> <select class="SelfSelect-select" onchange="{changeVal}" value="{nowPagenum}"> <option each="{obj,idx in opts.datas}" value="{obj.key}">{obj.value}</option> </select>', '', 'class="SelfSelect"', function(opts) {
	this.readonly=function(bool){
		if(typeof(bool) == "undefined"){
			bool=true;
		}
		if(bool){
			$("select",this.root).attr("readonly",true);
		}else{
			$("select",this.root).attr("readonly",false);
		}
	}
	this.getValue=function(){
		return $("select",this.root).val();
	}
	this.disabled=function(){
		$("select",this.root).attr("disabled",true);
	}
	this.enabled=function(){
		$("select",this.root).attr("disabled",false);
	}
	this.changeVal=function(e){
      this.opts.clickFunc.call(this,e.target.value);
      this.update();
   }
	this.on('mount',function(){
		if(opts.minwith){
			$(this.root).attr("min-width",opts.minwith);
		}else{
			$(this.root).attr("min-width","175px");
		}
		if(opts.width){
			$(this.root).css('width',opts.width);
		}
	})
}, '{ }');