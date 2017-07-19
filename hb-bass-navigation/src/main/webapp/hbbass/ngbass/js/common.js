	var desc = false;//全局变量
	//模糊查询输入框使用
	function checkBlur(evt) {
			var event = evt ? evt : window.event;
			var theSrc = event.target ? event.target : event.srcElement;
			if(theSrc.value == "") {
				theSrc.value="支持模糊查询";
				theSrc.style.color = "gray";
				theSrc.style.fontStyle = "italic";
			}
	}
	
	//模糊查询输入框使用
	function checkFocus(evt) {
			var event = evt ? evt : window.event;
			var theSrc = event.target ? event.target : event.srcElement;
			theSrc.value="";//清空文本
			theSrc.style.color = "black";
			theSrc.style.fontStyle = "normal";
	}
	
	//跨浏览器的注册事件监听的方法
	function catchEvent(eventObj, event, eventHandler) {
		if (eventObj.addEventListener) {
			eventObj.addEventListener(event, eventHandler,false);
		}
		 else if (eventObj.attachEvent) {
			event = "on" + event;
			eventObj.attachEvent(event, eventHandler);
		}
	}
	
	//计算并返回上月 格式yyyyMM ,如: 参数'200911'  返回'200910'
	function getLastMonth(_date) {
		var _month = _date.substr(4,2);
		if(_month == "01") {
			return (_date.substr(0,4)-1) + "12";
		} else {
			_month -= 1;
		 	_month = (_month < 10) ? ("0" + _month) : ("" + _month);//补0
			return _date.substr(0,4) + _month;
		}
	}
	//计算并返回昨天 格式yyyyMMdd,目前写的不够通用，没有多重格式，也不能带参数,计算的基数是今天,如果想得到制定日期的上一天就不行了
	//改正之后好了
	/*
		参考
		直接在构造器中把日期减1，遇到负数的时候，会自动回退   
      var   d   =   new   Date(2005,5,1);   
      alert(d)   
      var   dz=new   Date(d.getYear(),d.getMonth(),d.getDate()-1);   
      alert(dz)
	*/
	//dateStr : 与业务相关的日期字符串，格式为yyyyMMdd,如参数'20091112',返回'20091111'
	//本函数测试通过 - version 1.1 lastmodified 2009.12.21 增加小于10的判断
	function getLastDay(dateStr) {
	//需要注意的是月份要-1，外国的月份是从0-11,你给他12,他就到明年了
		var d = new Date(dateStr.substr(0,4),dateStr.substr(4,2)-1,dateStr.substr(6,2));   
  		//d.setTime(d.getTime()-(24*60*60*1000));   
		//var newDate = new Date(d.getFullYear(),d.getMonth(),d.getDate()-1);
		//var newDateStr =  newDate.getFullYear() + "" + (newDate.getMonth()+1) + "" + newDate.getDate();
		d.setDate(d.getDate() - 1);
		//number alert(typeof(d.getFullYear()));
		var monthStr = (d.getMonth() + 1) < 10 ? "0" + (d.getMonth() + 1) : (d.getMonth() + 1);
		var dateStr = d.getDate() < 10 ? "0" + d.getDate() : d.getDate();
		var newDateStr = d.getFullYear() + "" + monthStr + "" + dateStr;
		//alert(newDateStr);
		return newDateStr;
	}
	
	//返回 上月同期，算同比，环比时用到
	//dateStr : 与业务相关的日期字符串，格式为yyyyMMdd,如参数'20091031',返回'20090930'
	function getLastMonthSameDay(dateStrVal) {
	//需要注意的是月份要-1，外国的月份是从0-11,你给他12,他就到明年了
		var oriDate= new Date(dateStrVal.substr(0,4),dateStrVal.substr(4,2)-1,dateStrVal.substr(6,2)); //将提供的日期字符串构造出一个日期
		var resultDate = new Date(dateStrVal.substr(0,4),dateStrVal.substr(4,2)-1,dateStrVal.substr(6,2));
		resultDate.setMonth(resultDate.getMonth() - 1);
		if(resultDate.getMonth()==oriDate.getMonth()) {
				//真有问题的情况 结果月溢出导致两个月月份相同
				resultDate.setDate(0);//调整回去,至上月最后一天
		}
		if(getYearMonthDayNum(oriDate.getFullYear(),oriDate.getMonth() + 1) < getYearMonthDayNum(resultDate.getFullYear(),resultDate.getMonth() + 1)) {
			//本月天数大于上月,类似 20090331 -> 20090303  (正确应该20090228)
			//判断输入日期是否是本月最后一天
			if(getYearMonthDayNum(oriDate.getFullYear(),oriDate.getMonth() + 1) == oriDate.getDate()) {
				resultDate.setDate(getYearMonthDayNum(resultDate.getFullYear(),resultDate.getMonth() + 1));
			}
		}
		//格式化yyyyMMdd
		var monthStr = (resultDate.getMonth() + 1) < 10 ? "0" + (resultDate.getMonth() + 1) : (resultDate.getMonth() + 1);
		var dateStr = resultDate.getDate() < 10 ? "0" + resultDate.getDate() : resultDate.getDate();
		var resultStr =  resultDate.getFullYear()+ "" + monthStr + "" + dateStr;
		return resultStr;
	}	
	
	//一般用来算定基比
	/*
	dateObj : {
		queryTimeStr : yyyyMMdd格式,返回
		base : 基数	
	}
	目前的算法是返回base替换后的字符串
	2010.01.18 : 如果以指定的月份基数为月份，以查询日期所在的年份为年份构造出来的日期大于当前日期，则返回去年的指定月份
	*/
	function getSpecialDate(dateObj) {
		var _queryTime = dateObj.queryTimeStr;
		var _base = dateObj.base;
		var _now = new Date();
		if((_now.getFullYear() + "" + _now.getMonth()) < (_queryTime.substr(0,4) + _base)) {
			//用_now,不新创建对象了
			_now.setYear(_queryTime.substr(0,4)-1);
			_now.setMonth(_base - 1)//这里减1是因为月份是从0-11
			_now.setDate(_queryTime.substr(6,2) - 0);
			var rtMonth = ((_now.getMonth()+1) < 10) ? ("0" + (_now.getMonth()+1)) : ("" + (_now.getMonth()+1));//补0
			var rtDate = _now.getDate()< 10 ? "0" + _now.getDate() : _now.getDate();
			return _now.getFullYear() + "" + rtMonth + rtDate;
		} else {
			return _queryTime.substr(0,4) + _base + _queryTime.substr(6,2);
		}
		
	}
	
	/*
		供内部调用,返回指定年月的天数
		year : 4位年，可以是字符串
		month : 1-12,可以使字符串
	*/
	function getYearMonthDayNum(year,month){ 
		var dayNum = [31,28,31,30,31,30,31,31,30,31,30,31]; 
		if(new Date(year,1,29).getDate()==29)
			dayNum[1] = 29; 
    	return dayNum[month-1]; 
	}
	  
	
	//服务器排序,因为参数的原因在FF中得不到event对象，所以这个方法不跨浏览器
	/* 09.12.03 改进,可以不用传sortNum,如果没有sortNum,判断theSrc的父节点的cellIndex作为sortNum */
	function manageSort(sortNum) {
		var event = window.event;/*就算用户是点击的查询按钮而不是表头链接<a>来执行的doSubmit()，只要doSubmit()中调用本方法，
		event都可以获得，所不同的是event.tagName不一样，一个是A,一个是TD,所以可以利用这个来判断，从而兼容旧的版本
		*/
		var theSrc = event.target ? event.target : event.srcElement;
		/* 增加一种判断,即没有点按钮也没有点表头,是页面加载时的查询 */
		if(!theSrc)return "";
		if(theSrc.tagName == 'INPUT' && !sortNum) return "";//首先排除button的情况
		while(theSrc.tagName!="TD") theSrc=theSrc.parentElement;//和theSrc.parentNode似乎一样
		if(!sortNum)sortNum = theSrc.cellIndex + 1;
		var orderSql = " order by " + sortNum + (desc? " desc ":" asc ");
		//theSrc.innerText = theSrc.innerText.replace("↓","").replace("↑","") + (desc ? "↓" : "↑");//暂时不加箭头了
		//alert("theSrc.innerText : " + theSrc.innerText);
		desc = !desc;
		return orderSql;
	}
	//不太通用，不夸浏览器，只在IE上有效，因为FF中的evt传不过来了
	/* 
		objArr: 存放forms[0]中name的字符串数组
	*/
	function setDesable(objArr) {
		var event = window.event;
		var theSrc = event.target ? event.target : event.srcElement;
		if(theSrc.checked) {
			for(var i = 0; i < objArr.length;i++) {
			eval("document.forms[0]."+objArr[i]).selectedIndex = 0;	
			eval("document.forms[0]."+objArr[i]).disabled = true;
			}
		} else {
			for(var i = 0; i < objArr.length;i++) {
			eval("document.forms[0]."+objArr[i]).disabled = false;
			}
		}
		
	}
	function getXls(params) {
		
		//拼字符串,将对象转换成查询字符串
		var str = "";
		for(var name in params) {
			//测试有效alert(eval("params." + name));
			str += name + "=" + params[name];
			str += "&";
		}
		str = str.replace(/&$/,"");//剔除末尾&
		alert("finished str : " + str);
		//Ext 版本报错var xhr = createXhrObject();
		var xhr = createRequest();
		var url = "/hb-bass-navigation/hbbass/common2/getXls.jsp";
		var defaultPostHeader = 'application/x-www-form-urlencoded; charset=UTF-8';
		xhr.open("POST",url,true);
		xhr.setRequestHeader("Content-Type",defaultPostHeader);
		xhr.send(str);
	}
	
	//ext3的方法
	function createXhrObject() {
            var http;
            try {
                http = new XMLHttpRequest();                
            } catch(e) {
                for (var i = 0; i < activeX.length; ++i) {	            
                    try {
                        http = new ActiveXObject(activeX[i]);                        
                        break;
                    } catch(e) {}
                }
            } finally {
                return http;
            }
    }
    /* ================ 页面操作 =============== */
    
    	/*
		方法评分 : 4星级
		方法体会 : 面对困难，原来困难没有那么难。
		方法参数 : 
		targetEl : 目标节点
		insertType : 插入类型 String, "0"或者缺省是在目标位置后插入,"1"是在目标位置前插入
		cellInfos  : Array[cellInfo...]
			cellInfo : {
				cellText : 代建表格元素中的文本
				cellType : input标签的type,如text,checkbox等
				cellName : input 标签的name
				html : 单元格的一段html代码如果有cellType就不用了,同时cellName也在html中提供了，所以也不用了
			}
		update : 
			trCounts的算法 : 如果能整除，是不需要Math.floor()的
			html : 如果一个是一个控件，如日期控件，可能用input的type不能展示，则使用html定义一段html代码
	*/
	var COL_SIZE = 3;
	function dynamicAdd(obj) {
		if(obj.cellInfos.length < 1) {
			alert("待创建的表格行数小于1。有问题请联系管理员。");
		} 
		var trCounts = (obj.cellInfos.length % COL_SIZE == 0) ? (obj.cellInfos.length/COL_SIZE) : (Math.floor(obj.cellInfos.length/COL_SIZE)) + 1;
		var lastTr ; //此对象在trCounts > 1的时候有用，用来保持插入的顺序，不会使得第二批的tr插在第一批之前
		for(var i = 0 ; i < trCounts; i ++) {
			var _tr = document.createElement("tr");
			for(var j = i * COL_SIZE ; j < (i + 1) * COL_SIZE; j++) {
				if(j < obj.cellInfos.length) {
				
					var cellInfo = obj.cellInfos[j];
					//创建必要的元素
					var _td = document.createElement("td");
					var _td_info = document.createElement("td");
					_td_info.className = "alt";//加上一个样式，但是这样多少有点硬编码
					if(cellInfo.cellType) {
						var val = document.createElement(cellInfo.cellType);
						val.name = cellInfo.cellName;
						//加入到创建的TR中
						_td_info.appendChild(val); 
					} else _td_info.innerHTML = cellInfo.html;
					
					_td.innerText = cellInfo.cellText;
					//加入到创建的TR中
					_tr.appendChild(_td);
					_tr.appendChild(_td_info);
				}
			}
			//将创建的TR加入到目标位置前或者后
			var _insertType = obj.cellInfos.insertType;
			if(!_insertType || _insertType == "0") {
				if(i == 0)
					lastTr = obj.targetEl;
				insertAfter(_tr,lastTr);//在目标位置后加入
				lastTr = _tr;
			}
				
			else if(_insertType == "1") {
				var tbl = obj.targetEl.parentNode;
				while(tbl.tagName != "TBODY")
					tbl = tbl.parentNode;
				tbl.insertBefore(_tr,obj.targetEl);
			}
		}
	}
    
  /*
  	参数信息:
  		refEl : 基准对象(此对象同时也是定位tbody的依据)，用于定位要删除的节点
  		tbl :一般不写，如果指定，则不再以refEl为依据
  		type : 默认不写或者"0" : nextSibling; 1 : previousSibling 
  		telFunc : 用户定义的判断节点是否存在的方法,需要有返回值
  		alertFunc : 用户定义的找不到目标节点的方法(注意，目标节点不是基准对象)
  		errorFunc : 用户定义的删除节点失败的方法,暂时未实现
  		trCounts : 要删除的tr节点数量,不写默认是1个tr.加这个属性是为了防止一次将添加的多个tr组全部删除
  	经验积累 : 删除必须是直接的父节点才能删除其子节点,由于浏览器自动加上tbody的缘故，删除tr不再是table的事情，而是tbody
  	所以说下面的while判断不是必须的
  	obj.class = someVal ; 这句话会报错，可能因为class是保留字的原因吧
  	应改成className 
  	update :
  		trCounts : 不再从对象中获得，而是计算出来，传来的对象中只包含cellInfo的个数unitCounts;
  */
    function dynamicDelete(obj) {
    	var _tbl ;
    	if(obj.tbl)
    		_tbl = obj.tbl;
    	else {
    		_tbl = obj.refEl.parentNode;
    		while(_tbl.tagName != "TBODY") {
    			_tbl = _tbl.parentNode;
    		}
    	}
    	//判断
    	//不一定只删一次，所以用while
    	var removed = false;
    	var count = 0;
    	var trCounts = (obj.unitCounts % COL_SIZE == 0) ? (obj.unitCounts/COL_SIZE) : (Math.floor(obj.unitCounts/COL_SIZE)) + 1;
    	while(obj.telFunc() && count < (obj.unitCounts ? trCounts : 1)) {
    		count++;
    		removed = true;
    		var targetTr;
    		if(!obj.type || obj.type == "0") {
    			targetTr = obj.refEl.nextSibling;
   				while(targetTr.tagName != "TR") {
   					targetTr = targetTr.nextSibling;
   				}
   				_tbl.removeChild(targetTr);
    		} else if(obj.type == "1") {
    			targetTr = this.refEl.previousSibling;
   				while(targetTr.tagName != "TR") {
   					targetTr = targetTr.previousSibling;
   				}
   				_tbl.removeChild(targetTr);
    		}
    	} 
    	if(!removed)obj.alertFunc();
    }
   
    // from net 供其他方法调用
	function insertAfter(newEl, targetEl) {
        var parentEl = targetEl.parentNode;
        
        if(parentEl.lastChild == targetEl)
        {
            parentEl.appendChild(newEl);
        }else
        {
            parentEl.insertBefore(newEl,targetEl.nextSibling);
        }            
    }
    /* ================ mask 相关 ================= */
    // 获取宽度
	function getWidth()
	{
	    var strWidth,clientWidth,bodyWidth;
	    clientWidth = document.documentElement.clientWidth;
	    bodyWidth = document.body.clientWidth;
	    if(bodyWidth > clientWidth){
	        strWidth = bodyWidth + 20;
	    } else {
	        strWidth = clientWidth;
	    }
	    //alert("width : " + strWidth);
	    return strWidth;
	}
	//获取高度
	function getHeight()
	{
	    var strHeight,clientHeight,bodyHeight;
	    clientHeight = document.documentElement.clientHeight;
	    bodyHeight = document.body.clientHeight;
	    if(bodyHeight > clientHeight){
	        strHeight = bodyHeight + 30;
	    } else {
	        strHeight = clientHeight;
	    }
	    //alert("height : " + (strHeight+1000));
	    return strHeight+1000;
	}
	
	/* 如果obj为空，用默认的 
		idArr : ["遮罩divid","信息divid"]
		layout : {
			width : "宽度",提供则固定宽度
			height : 高度,
		}
	*/
	function maskScreen(obj) {
		var Msg,Bg,_document;
		_document = obj ? (obj.scope || document) : document; //不提供范围，默认用document,通常在 frame中使用时需要提供scope来遮罩外层
		if(obj && obj.idArr) {
			Msg = _document.getElementById(obj.idArr[0]);
			Bg = _document.getElementById(obj.idArr[1]);
		} else {
			Msg = _document.getElementById('maskMessage');
			Bg = _document.getElementById('maskScreen');
		}
		try {
			Bg.style.width = ((obj && obj.layout && obj.layout.width )? obj.layout.width : getWidth())+'px';
		    Bg.style.height = ((obj && obj.layout && obj.layout.height )? obj.layout.height : getHeight())+'px';
		    Msg.style.left=(document.body.clientWidth/2)-200+"px"; // alert(screen.height/2-240);
		    Msg.style.top=screen.height/2-240+"px";
		    Msg.style.display = 'block';
		    Bg.style.display = 'block';
		} catch (err) {
			// TODO: handle exception
		}
	 	/*Bg.style.width = ((obj && obj.layout && obj.layout.width )? obj.layout.width : getWidth())+'px';
	    Bg.style.height = ((obj && obj.layout && obj.layout.height )? obj.layout.height : getHeight())+'px';
	    Msg.style.left=(document.body.clientWidth/2)-200+"px"; // alert(screen.height/2-240);
	    Msg.style.top=screen.height/2-240+"px";
	    Msg.style.display = 'block';
	    Bg.style.display = 'block';*/
	}
	/* 如果obj为空，用默认的
		idArr : ["遮罩divid","信息divid"]
	 */
	function unMaskScreen(obj) {
		var Msg,Bg,_document;
		_document = obj ? (obj.scope || document) : document; //不提供范围，默认用document,通常在 frame中使用时需要提供scope来遮罩外层
		if(obj && obj.idArr) {
			Msg = _document.getElementById(obj.idArr[0]);
    		Bg = _document.getElementById(obj.idArr[1]);
		} else {
			Msg = _document.getElementById('maskMessage');
    		Bg = _document.getElementById('maskScreen');
		}
	    Msg.style.display = 'none';
	    Bg.style.display = 'none';
	}
    
    /*================ sql 相关 ===================*/
    function addRollUp(col) {
    	return " rollup(" + col + ")";
    } 
