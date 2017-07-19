<Page class="page">
	 <span>{totalnum}条信息,{nowPagenum}/{totalPagenum}页</span>
   <span class="page-btn" onclick={clickPrev}>上一页</span>
   <span class="page-btn" onclick={clickNext}>下一页</span>
   <span class="page-btn">第
      <select onchange={changeVal} value={nowPagenum}>
        <option each={obj,idx in totalPages}  value ={idx+1}>{idx+1}</option>
      </select>
   页</span>
   var _this=this;
   _this.lineperpage=opts.lineperpage||6;
   if(typeof(opts.totalnum)=='undefined'){
      _this.totalnum=0;
   }else{
      _this.totalnum=opts.totalnum;
   }
   _this.nowPagenum=_this.totalnum==0?0:1;
   _this.totalPagenum=Math.ceil(_this.totalnum/_this.lineperpage);
   _this.initSelect=function(){
     _this.totalPages=[];
     for(i=0;i<_this.totalPagenum;i++){
        _this.totalPages[i]=i;
     }
   }
   _this.initSelect();
   _this.setTotalnum=function(total){
      if(typeof(total)=='undefined'){
        total=_this.totalnum;
      }
      _this.totalnum=total;
      _this.totalPagenum=Math.ceil(_this.totalnum/_this.lineperpage);
      _this.initSelect();
      _this.update();
   }
   _this.setLineperpage=function(linenum){
      if(typeof(linenum)=='undefined'){
        linenum=_this.lineperpage;
      }
      _this.lineperpage=linenum;
      _this.totalPagenum=Math.ceil(_this.totalnum/_this.lineperpage);
      _this.initSelect();
      _this.update();
   }
   _this.setNowpage=function(nowpage){
      if(typeof(nowpage)=='undefined'){
        nowpage=_this.nowPagenum;
      }
      _this.nowPagenum=nowpage;
      _this.update();
   }
   _this.clickPrev=function(e){
      if(_this.nowPagenum>1){
        _this.nowPagenum=parseFloat(_this.nowPagenum)-1;
        _this.update();
        _this.opts.click.call(this,_this.nowPagenum);
      }
   }
   _this.reload=function(){
      _this.nowPagenum=1;
      _this.update();
   }
   _this.clickNext=function(e){
      if(_this.nowPagenum<_this.totalPagenum){
        _this.nowPagenum=parseFloat(_this.nowPagenum)+1;
        _this.update();
        _this.opts.click.call(this,_this.nowPagenum);
      }
   }
   _this.changeVal=function(e){
      _this.nowPagenum=e.target.value;
      _this.update();
      _this.opts.click.call(this,_this.nowPagenum);
   }
   _this.getNowpage=function(){
      return _this.nowPagenum;
   }
  _this.hide=function(){
    $(_this.root).hide();
  }
  _this.show=function(){
    $(_this.root).show();
  }
   _this.on('mount',function(){
        if(opts.float){
          if(opts.float=='center'){
            $(_this.root).css("text-align",opts.float);
          }else{
            $(_this.root).css("float",opts.float);
          }
        }
   })
</Page>    