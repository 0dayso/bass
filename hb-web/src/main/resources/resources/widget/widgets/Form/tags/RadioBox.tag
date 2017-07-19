<RadioBox class="RadioContent">
    <span  class="radioBoxOption" each={opts.data} >
        <i class="icon-circle-blank radioOption" value={value} onclick={click}/>
        <label onclick={click}>{text}</label>
    </span> 
  	this.mixin(BoxCommpent);
    this.addOptions=function(data){
        opts.data.push(data);
        this.update();
    }
    var _this=this;
    var checkedValue;
    this.selected=function(value){
        $("i",_this.root).each(function(k,v){
            if(value==v.value){
                v.className="radioOption icon-circle";
                checkedValue=v.value;
            }else{
                v.className="radioOption icon-circle-blank";
            }
        });
        _this.update();
    }
    this.click=function(e){
        _this.selected(e.item.value);
        if(!_this.opts.checked)return;
        _this.opts.checked.call(this,e.item.value);
    }
    this.setValue=function(value){
        if(value==null||!_.contains(_.pluck(opts.data,'value'),value))
            value=opts.data[0].value;
        _this.selected(value);
    }
    this.getValue=function(){
        return checkedValue;
    }
    this.on("mount",function(){
        _this.setValue(opts.defaultValue);
    })
</RadioBox>    