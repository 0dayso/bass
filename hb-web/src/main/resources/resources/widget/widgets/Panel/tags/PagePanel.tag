<PagePanel class="pagePanel">
	<div class="pagePanel-heading panel-fix-head">
      	<span class="float-left pagePanel-heading-left"></span>
      	<span class="float-right pagePanel-heading-right"></span>
  </div>
  <div class="pagePanel-body panel-container"></div>
  <div class="pagePanel-foot panel-container"></div>

   	this.headLeftItems = opts.headLeftItems;
    this.headRightItems = opts.headRightItems;
   	this.bodyItems = opts.bodyItems;
    this.footItems = opts.footItems;

   	this.on("mount",function(){
   		for(var i=0;i<this.headLeftItems.length;i++){
       	$(".pagePanel-heading-left",this.root).append($(this.headLeftItems[i].root));
      }
      for(var i=0;i<this.headRightItems.length;i++){
        $(".pagePanel-heading-right",this.root).append($(this.headRightItems[i].root));
      }
      for(var i=0;i<this.bodyItems.length;i++){
        $(".pagePanel-body",this.root).append($(this.bodyItems[i].root));
      }
      for(var i=0;i<this.footItems.length;i++){
        $(".pagePanel-foot",this.root).append($(this.footItems[i].root));
      }
    })
</PagePanel>