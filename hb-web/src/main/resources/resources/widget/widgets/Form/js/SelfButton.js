riot.tag2('selfbutton', '<button type="button" class="btn btn-default navbar-btn buttonshow" onclick="{click}">{title}</button>', '', '', function(opts) {
    this.title=opts.title;
    this.click=function(e){
    	return this.opts.click.call(this);
    }
    this.getTitle=function(){
    	return this.title;
    }
    this.setTitle=function(title){
    	if(title){
    		this.title=title;
    		}
    	this.update();
    }
    this.hide=function(){
    	$(this.root).hide();
    }
}, '{ }');