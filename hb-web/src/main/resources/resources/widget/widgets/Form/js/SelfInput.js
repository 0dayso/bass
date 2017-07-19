riot.tag2('selfinput', '<span class="SelfInput-name">{opts.name}</span> <input class="SelfInput-input" type="text" placeholder="{opts.placeholder}">', '', 'class="SelfInput"', function(opts) {
	this.readonly=function(bool){
		if(typeof(bool) == "undefined"){
			bool=true;
		}
		if(bool){
			$(".SelfInput-input",this.root).attr("readonly",true);
		}else{
			$(".SelfInput-input",this.root).attr("readonly",false);
		}
	}
	this.getValue=function(){
		return $(".SelfInput-input",this.root).val();
	}
	this.disabled=function(){
		$(".SelfInput-input",this.root).attr("disabled",true);
	}
	this.enabled=function(){
		$(".SelfInput-input",this.root).attr("disabled",false);
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