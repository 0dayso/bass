riot.tag2('selfbutton', '<button type="button" class="btn btn-default navbar-btn buttonshow" onclick="{click}">{opts.title}</button>', '', '', function(opts) {
    this.click=function(e){
    	return this.opts.click.call(this);
    }
    this.hide=function(){
    	$(this.root).hide();
    }
}, '{ }');