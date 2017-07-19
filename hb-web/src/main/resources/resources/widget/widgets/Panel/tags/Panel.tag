<Panel class="panel panel-info panel-fix-width">
    <div class="panel-heading panel-fix-head">
      	<h3 class="panel-title panel-fix-title">{opts.title}</h3>
    </div>
    <div class="panle-body panel-container"></div>
   	this.mixin(Container);
   	this.hide=function(){
   		$(this.root).hide();
   	}
   	this.on("mount",function(){
        $(".panle-body",this.root).append($(this.layouter.root));
    })
</Panel>