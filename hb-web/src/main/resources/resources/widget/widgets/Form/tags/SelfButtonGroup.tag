<SelfButtonGroup class="selfbuttongroup">
    var _this=this;
    var SSID=new Date().getTime()+"."+Math.floor(Math.random()*1000)+".";
    var itemdata;
    var isFirstHide=false;
    _this.datas=opts.datas;
    _this.generateSpan=function(){
    	return $("<span></span>");
    }
    _this.clickItem=function(e){
    	$(e.target.parentElement.children).removeClass("clicked")
    	$(e.target).addClass("clicked");
    	_this.itemdata=$(e.target).attr("data-value");
    	_this.opts.click.call(this,_this.itemdata);
    }
    _this.getValue=function(){
    	return _this.itemdata;
    }
    _this.hide=function(index){
    	if(typeof(index)=='undefined'){
    		$(_this.root).hide();
    	}else if(typeof(index)=='object'){
            $.each(index,function(k,v){
                 _this.hide(v);
            })

        }else{
            var ele=$("span[data-index='"+"span-"+SSID+index+"']");
    		if(index==0){
    			ele.next().hide();
    		}else{
    			ele.prev().hide();
    		}
			ele.hide();
    	}
    }
    _this.show=function(index){
    	if(typeof(index)=='undefined'){
    		$(_this.root).show();
    	}else if(typeof(index)=='object'){
            $.each(index,function(k,v){
                 _this.show(v);
            })

        }else{
            var ele=$("span[data-index='"+"span-"+SSID+index+"']");
            if(index<_this.datas.length-1){
    		  ele.prev().show();
            }
			ele.show();
    	}
    }
    _this.initBtn=function(){
    	if(opts.title){
    		var title=$("<span class='selfbuttongroup-title'>"+opts.title+":</span>");
    		$(_this.root).append(title);
    	}
    	$.each(_this.datas,function(k,v){
    		var split;
    		if(k>0){
    			if(opts.issplit){
    				split= _this.generateSpan().text("|").addClass("selfbuttongroup-split");
    			}else{
    				split=_this.generateSpan().addClass("selfbuttongroup-split");
    			}
    			$(split).attr("data-index","split-"+SSID+k);
    			if(_this.isFirstHide){
    				$(split).css("display","none");
    				_this.isFirstHide=false;
    			}
	    		$(_this.root).append(split);
    		}
    		var span=_this.generateSpan();
    		span.addClass("selfbuttongroup-item");
    		if(v.isdefault){
	    		span.addClass("clicked");
	    		_this.itemdata=v.value;
    		}
    		if(v.ishide){
    			if(k==0){
    				_this.isFirstHide=true;
    				$(span).css("display","none");
    			}else{
    				$(split).css("display","none");
    				$(span).css("display","none");
    				_this.isFirstHide=false;
    			}
    		}
    		$(span).attr("data-value",v.value);
    		$(span).attr("data-index","span-"+SSID+k);
    		$(span).text(v.name);
    		$(span).click(_this.clickItem);
    		$(_this.root).append(span);
    	})
    }
    _this.reSetitem=function(val,name,value){
        var ele=$("span[data-value='"+val+"']"); 
        ele.removeClass("clicked");
        ele.attr("data-value",value);
        ele.text(name);
    }
    _this.on('mount',function(){
		_this.initBtn();
    })
</SelfButtonGroup>