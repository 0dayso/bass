<ComboBox class='ComboBox'>
   <label  class="headCls" onclick="{datas.length > 0?clickHead:''}">
    <div class="headCls-text" data-dimvalue={defaultDimvalue} data-dimtype={defaultDimtype} title={defaultDimname}>
        {defaultDimname}</div>
    <div class="icon-caret-down"></div>
    <div class="clear-float"></div>
   </label>
   <div class="selectPosition">
        <div class="selectPosition-block" data-level="level-1">
            <div class="selectPosition-search" if={datas.length > linenum}> 
                <input class="selectPosition-search-input" type="text">
                <i class="icon-search selectPosition-search-btn" onclick={searchclick} data-dimtype={datas[0].dimtype}></i>
            </div>
            <div each={obj,idx in datas} class="selectPosition-item"  if={datas.length > 0&&idx <= linenum-1}>
                <div class="selectPosition-item-text" data-dimvalue={obj.dimvalue} data-dimtype={obj.dimtype} title={obj.dimname}
                    ondblclick={isNormal?null:itemdbclick} 
                    onclick={isNormal?clickNormal:clickTree}>{obj.dimname}</div>
            </div>
            <div class="selectPosition-overflow" if={datas.length > linenum} onclick="{showMoredata}" data-dimtype={obj.dimtype}>...</div>
        </div>
        <div class="clear-float"></div>
   </div>
    var _this=this;
    var hasClicked=false;
    var isdbclick;
    var item={};
    var dataCache={};
    _this.isNormal=(opts.type=='tree'?'tree':'normal')=='normal';
    _this.linenum=opts.linenum||8;
    _this.datas=opts.data;
    _this.mixin(BoxCommpent);
    _this.setItem=function(element){
        item["dimvalue"]=$(element).attr("data-dimvalue");
        item["dimtype"]=$(element).attr("data-dimtype");
        item["dimname"]=$(element).text();
    }
    _this.setDefault=function(dimvalue,dimname,dimtype){
        _this.defaultDimvalue=dimvalue;
        _this.defaultDimname=dimname;
        _this.defaultDimtype=dimtype;
        var clicktmp=$(".selectPosition-item-text",$(".clickCls",_this.root));
        var tmp={};
        for(var i=clicktmp.length-1;i>=0;i--){
            tmp[i]=$(clicktmp[i]).attr("data-dimvalue");
        }
        item["treeInfo"]=tmp;
    }
    _this.initDefaultDimvalue=function(val){
        if(typeof(_this.datas) == "undefined"){
            _this.datas=[];
        }
        if(_this.datas.length>0){
            $.each(_this.datas,function(k,v){
                if(val){
                    if(val==v.dimvalue){
                        _this.setDefault(v.dimvalue,v.dimname,v.dimtype);
                        return false;
                    }
                }else{
                _this.setDefault(v.dimvalue,v.dimname,v.dimtype);
                return false;
                }
            });
        }else{
            _this.setDefault("","无数据","");
        }
        if(_this.datas.length>_this.linenum){
            dataCache[_this.datas[0].dimtype]=_this.datas;
            dataCache[_this.datas[0].dimtype+"_isSearch"]=false;
            dataCache[_this.datas[0].dimtype+"_linenum"]=_this.linenum;
        }

    }
    _this.initDefaultDimvalue(opts.defaultDimvalue);
    _this.setValue=function(val){
        _this.initDefaultDimvalue(val);
        _this.update();
    }
    _this.getDimData=function(item){
        return _this.opts.getDimData.call(this,item);
    }
    _this.getitembody=function(dimtype,dimvalue,dimname){
        var divitem=$('<div class="selectPosition-item"></div>');
        var divtext=$('<div class="selectPosition-item-text"></div>');
        divtext.attr("data-dimvalue",dimvalue);
        divtext.attr("data-dimtype",dimtype);
        divtext.attr("title",dimname);
        divtext.text(dimname);
        divtext.dblclick(_this.itemdbclick);
        divtext.click(_this.clickTree);
        divitem.append(divtext);
        return divitem;
    }
    _this.itemdbclick=function(e){
        isdbclick=true;
        _this.setDefault($(e.target).attr("data-dimvalue"),$(e.target).text(),$(e.target).attr("data-dimtype"));
       $(".selectPosition*",_this.root).hide();
        _this.setItem(e.target);
        _this.opts.dbclickFunc.call(this,item);
        _this.update();
    }  
    _this.clickNormal=function(e){
        hasClicked=true;
        var targetItem=e.target.parentElement;
        var targetBlock=targetItem.parentElement;
        $(targetBlock).children().removeClass("clickCls");
        $(targetItem).addClass("clickCls");
        _this.setDefault($(e.target).attr("data-dimvalue"),$(e.target).text(),$(e.target).attr("data-dimtype"));
       $(".selectPosition*",_this.root).hide();
        _this.setItem(e.target);
        _this.opts.clickFunc.call(this,item);
    }
    _this.clickTree=function(e){
        hasClicked=true;
        var targetItem=e.target.parentElement;
        var targetBlock=targetItem.parentElement;
        $(targetBlock).children().removeClass("clickCls");
        $(targetItem).addClass("clickCls");
        isdbclick=false;
        _this.setItem(e.target);
        var height=$(e.target).height()+3;
        var width=$(e.target.parentElement.parentElement).width()+6;
        $(targetBlock).nextAll().each(function(k,v){
            if(v.className=="clear-float"){
                return;
            }else{
                $(v).remove();
            }
        })
        window.setTimeout(
            function(){
                if(isdbclick!=false)return;
                var extendDatas=_this.getDimData(item);
                if(extendDatas){
                    if(extendDatas.length>0){
                        var blockDiv=$('<div class="selectPosition-block"></div>');
                        $.each(extendDatas,function(k,v){
                            if(k>=_this.linenum){
                                return false;
                            }
                            blockDiv.append(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                        });  
                        if(extendDatas.length>_this.linenum){
                            var searchDiv=$('<div class="selectPosition-search"></div>');
                            var searchInput=$('<input class="selectPosition-search-input" type="text">');
                            var searchBtn=$('<i class="icon-search selectPosition-search-btn"></i>');
                            var overflowDiv=$('<div class="selectPosition-overflow" if={idx == linenum-1}>...</div>');
                            searchBtn.attr("data-dimtype",extendDatas[0].dimtype);
                            searchBtn.click(_this.searchclick);
                            overflowDiv.attr("data-dimtype",extendDatas[0].dimtype);
                            overflowDiv.click(_this.showMoredata);
                            dataCache[extendDatas[0].dimtype]=extendDatas;
                            dataCache[extendDatas[0].dimtype+"_isSearch"]=false;
                            dataCache[extendDatas[0].dimtype+"_linenum"]=_this.linenum;
                            searchDiv.append(searchInput);
                            searchDiv.append(searchBtn);
                            blockDiv.prepend(searchDiv);
                            blockDiv.append(overflowDiv);
                        }
                        $(blockDiv).slideDown("fast");
                       $(".clear-float",$(".selectPosition",_this.root)).before(blockDiv);
                    }
                }
            }
        ,500);
    }
    _this.searchclick=function(e){
        var targetBlock=e.target.parentElement.parentElement;
        $(targetBlock).nextAll().each(function(k,v){
            if(v.className=="clear-float"){
                return;
            }else{
                $(v).remove();
            }
        })
        var searchLevel=$(e.target).attr("data-dimtype");
        var searchContext=$(e.target).prev().val();
        var lastEle;
        $(e.target.parentElement).nextAll().each(function(k,v){
            if(v.className=="selectPosition-overflow"){
                lastEle=v;
                return;
            }else{
                $(v).remove();
            }
        })
        if(searchContext){
                var searchResult=new Array();
                var i=0;
                $.each(dataCache[searchLevel],function(k,v){
                    if(v.dimname.indexOf(searchContext)>=0){
                        searchResult.push(v);
                        i++;
                    }
                })
                if(i==0){
                    $(lastEle).before($('<div><i class="noresult">无数据</i></div>'));
                    $(lastEle).hide();
                }else{
                    dataCache[dataCache[searchLevel][0].dimtype+"_isSearch"]=true;
                    dataCache[dataCache[searchLevel][0].dimtype+"_search"]=searchResult;
                    dataCache[dataCache[searchLevel][0].dimtype+"_linenum"]=_this.linenum;
                }
                if(i+1<=_this.linenum){
                    $(lastEle).hide();
                }
                $.each(searchResult,function(k,v){
                    if(k>=_this.linenum){
                       $(lastEle).show();
                       return false;
                    }
                    $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                })
        }else{
            dataCache[dataCache[searchLevel][0].dimtype+"_isSearch"]=false;
            dataCache[dataCache[searchLevel][0].dimtype+"_search"]="";
            dataCache[dataCache[searchLevel][0].dimtype+"_linenum"]=_this.linenum;
            $.each(dataCache[searchLevel],function(k,v){
                if(k>=_this.linenum){
                    $(lastEle).show();
                    return false;
                }
                $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
            })
        }
    }
    _this.load=function(items){
        hasClicked=false;
        if(typeof(items) == "undefined"){
            items=[];
        }
        if(items){
            this.datas=items;
        }else{
            this.datas=opts.data;
        }
        $(".selectPosition-block",this.root).each(function(k,v){
            if(k>0){
                $(v).remove();
            }
        })
        _this.initDefaultDimvalue();
        $(".selectPosition",_this.root).hide();
        this.update();
    }
    _this.getDimtype=function(){
        return _this.defaultDimtype;
    }
    _this.getDimvalue=function(){
        return _this.defaultDimvalue;
    }
    _this.getDimname=function(){
        return _this.defaultDimname;
    }
    _this.showMoredata=function(e){
        var tmpData;
        var lastEle=e.target;
        var showLevel=$(e.target).attr("data-dimtype");
        var isSearch=dataCache[showLevel+"_isSearch"];
        var lineNum=dataCache[showLevel+"_linenum"];
        var newLinenum=parseFloat(lineNum)+parseFloat(_this.linenum);
        if(isSearch){
            tmpData=dataCache[showLevel+"_search"];
            if(tmpData.length<=lineNum){
                $(lastEle).hide();
            }
            $.each(tmpData,function(k,v){
                    if(k<lineNum){
                        return;
                    }
                    if(k>=newLinenum){
                       $(lastEle).show();
                       return false;
                    }
                    $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                })
        }else{
            tmpData=dataCache[showLevel];
            $.each(tmpData,function(k,v){
                    if(k<lineNum){
                        return;
                    }
                    if(k>=newLinenum){
                       $(lastEle).show();
                       return false;
                    }
                    $(lastEle).before(_this.getitembody(v.dimtype,v.dimvalue,v.dimname));
                })
        }
        dataCache[showLevel+"_linenum"]=newLinenum;
        if(tmpData.length<=newLinenum){
            $(lastEle).hide();
        }
    }
    _this.clickHead=function(e){
            if(!hasClicked){
                var firstBlock=$("div[data-level='level-1']",_this.root); 
                var clickItem=$(".clickCls",firstBlock); 
                $(".selectPosition-item-text",firstBlock).each(function(k,v){
                        if($(v).attr("data-dimvalue")==_this.defaultDimvalue){
                            $(v.parentElement).addClass("clickCls");
                            return false;
                        }
                });
                $(".selectPosition",_this.root).data("isHidden",true);
            }
            hasClicked=true;
            if( $(".selectPosition",_this.root).data("isHidden")){
                $(".selectPosition",_this.root).slideDown("fast");
                $(".selectPosition",_this.root).data("isHidden",false);
            }else{
                $(".selectPosition",_this.root).hide();
                $(".selectPosition",_this.root).data("isHidden",true);
            }
    }
    _this.on('mounted',function(){
    })
</ComboBox> 