//取有单位的数值之值,如从"12px"中取出"12"
function getLeft(mainStr,lngLen) {
	if (mainStr) {
		if(!lngLen)
		{
			var lngLen = mainStr.length-2;
		}
		else
		{
			lngLen = mainStr.length-lngLen;
		}
		return parseInt(mainStr.substring(0,lngLen));
	}
	else
	{
		return null
	}
}

function showTab(theNO,totalNO,targetIfra,urlStr) {
	//初始化

	if(totalNO>0)
	{
		for(i=1;i<=totalNO;i++)
		{
			if("tab_title_text_grey"!=document.getElementById("tdTitle"+i).className)
			{
				if(null!=document.getElementById("imgL"+i))
				{
					document.getElementById("imgL"+i).src = tabLeftOff;
				}
				if(null!=document.getElementById("imgR"+i))
				{
					document.getElementById("imgR"+i).src = tabRightOff;
				}
				if(null!=document.getElementById("tdTitle"+i))
				{
					document.getElementById("tdTitle"+i).className = tabTextClassOff;
				}
				if(null!=document.getElementById("table"+i))
				{
					document.getElementById("table"+i).style.display = "none";
				}
			}
		}
	}
	
	//选择TAB页

	document.getElementById("imgL"+theNO).src = tabLeftOn;
	document.getElementById("imgR"+theNO).src = tabRightOn;
	document.getElementById("tdTitle"+theNO).className = tabTextClassOn;
	
	if(targetIfra)
	{
		eval("parent."+targetIfra).location.href = urlStr;
	}
	else
	{
		document.getElementById("table"+theNO).style.display = "block";
	}
}

/********************TOP页面TAB标签代码 开始*************************/
function createTab() {
	//var tabHTML = ""
	var MT = null;
	var MTF = null;
	this.fixNo = 1;	//定义不能被关闭的菜单数量
	var tabInp = document.getElementById("tabStr");
	var cTab = this;
	this.tempTabStr = tabInp.value;
	this.openedID = 0;
	this.openedPath = "";
	var tabTd = document.getElementById("tabTD");

	//创建TAB标签页HTML代码
	this.createBody = function() {
		cTab.tabStr = tabInp.value;
		aTabStr = cTab.tabStr.split("|");
		cTab.tabLen = aTabStr.length;
		tabHTML = "<div style=\"position:relative;width:100%;height:28px;border:none;overflow-x:hidden;\">";
		tabHTML += "<div id=\"tabDIV\" style=\"position:absolute;height:28px;border:none;left:0px;top:0px;\">";
		tabHTML += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n";
		for(i=0;i<cTab.tabLen;i++)
		{
			tabAttriable = aTabStr[i].split(",");
			if(tabAttriable[0])
			{
				tabTitle = tabAttriable[0];
			}
			if(tabAttriable[1])
			{
				ifraName = tabAttriable[1];
			}
			if(tabAttriable[2])
			{
				tabLink = tabAttriable[2];
			}
			
			tabHTML += "<td><img src=\""+tabLeftOff+"\" name=\"imgL"+(i+1)+"\" id=\"imgL"+(i+1)+"\" border=\"0\" /></td>\n";
			tabHTML += "<td class=\""+tabTextClassOff+"\" nowrap=\"nowrap\" style=\"cursor: hand;\" onclick = \"theCreateTab.open("+(i+1)+","+cTab.tabLen+",'"+ifraName+"','"+tabLink+"');\" id=\"tdTitle"+(i+1)+"\" >\n";
			if(tabAttriable[3])
			{
				tabIcon = tabAttriable[3];
				tabHTML += "<img src=\""+path+"image/tabs/" + tabIcon + "\" border=\"0\" align=\"absmiddle\" style=\"margin-right:2px;\" />\n";
			}
			tabHTML += tabTitle + "</td>\n";

			if(i>=this.fixNo)
			{
				tabHTML += "<td class=\""+tabTextClassOff+"\" valign=\"top\" style=\"padding:8px 2px 0 px 0px;cursor:hand;\" id=\"tdCloseTab"+(i+1)+"\"><img src=\""+path+"image/tabs/icon_closetab.gif\" name=\"iconCloseTab"+(i+1)+"\" id=\"iconCloseTab"+(i+1)+"\" onclick=\"theCreateTab.subtract("+i+")\" border=\"0\" /></td>\n";
			}
			tabHTML += "<td style=\"padding-right:3px;\"><img src=\""+tabLeftOff+"\" name=\"imgR"+(i+1)+"\" id=\"imgR"+(i+1)+"\" border=\"0\" /></td>\n";
		}
		tabHTML += "</tr></table>";
		tabHTML += "</div></div>";
		tabTd.innerHTML = tabHTML;
		
		//显示隐藏左右滚动箭头
		cTab.cSIcon();
	}
	
	//TAB标签打开路径添加节点
	this.addPathNode = function(pathid) {
		if(cTab.openedPath=="")
		{
			cTab.openedPath = "" + pathid;
		}
		else
		{
			pathStr = cTab.openedPath.split(",");
			if(parseInt(pathid)!=parseInt(pathStr[pathStr.length-1]))
			{
				cTab.openedPath = cTab.openedPath + "," + pathid;
			}
		}
	}
	
	//TAB标签打开路径删除节点cTab.tabStr.split("|")
	this.delPathNode = function(pathid) {
		if(cTab.openedPath!="")
		{
			pathStr = cTab.openedPath.split(",");
			newPathStr = "";
			for(i=0;i<pathStr.length;i++)
			{
				if(parseInt(pathStr[i])!=parseInt(pathid))
				{
					thePathID = pathStr[i];
					if(parseInt(pathStr[i])>parseInt(pathid))
					{
						thePathID = parseInt(pathStr[i])-1;
					}
					
					if(i==0)
					{
						newPathStr = newPathStr + thePathID;
					}
					else
					{
						newPathStr = newPathStr + "," + thePathID;
					}
				}
			}
			cTab.openedPath = newPathStr;
		}
	}

	//创建TAB内嵌iframe页

	this.createIfra = function() {
		var ifraBody = parent.mainFrame.document.getElementsByTagName("body").item(0);
		ifraStr = cTab.tabStr.split("|");
		
		for(i=0;i<ifraStr.length;i++)
		{
			ifraStrs = ifraStr[i].split(",");
			var ifraDiv=document.createElement("div");
			ifraBody.insertAdjacentElement("beforeEnd",ifraDiv);
			ifraDiv.style.cssText = "position:static;width:100%;height:100%;display:none;";
			/*var ifraSelf=document.createElement("iframe");
			ifraDiv.insertAdjacentElement("beforeEnd",ifraSelf);
			ifraSelf.width="100%";
			ifraSelf.height="100%";
			ifraSelf.frameBorder=0;
			ifraSelf.border=0;
			ifraSelf.scrolling = "auto";
			ifraSelf.src = ifraStrs[2];*/
			
			var sHTML ='<iframe src="'+ifraStrs[2]+'" scrolling = "auto" width="100%" height="100%" frameborder="0" border="0"></iframe>';
			ifraDiv.innerHTML = sHTML;
		}
	}

	//添加一个新的iframe页

	this.addIfra = function(fStr) {
		var ifraBody = parent.mainFrame.document.getElementsByTagName("body").item(0);
		ifraStrs = fStr.split(",");
		var ifraDiv=document.createElement("div");
		ifraBody.insertAdjacentElement("beforeEnd",ifraDiv);
		ifraDiv.style.cssText = "position:static;width:100%;height:100%;display:none;";
		/*var ifraSelf=document.createElement("iframe");
		ifraDiv.insertAdjacentElement("beforeEnd",ifraSelf);
		ifraSelf.width="100%";
		ifraSelf.height="100%";
		ifraSelf.frameBorder=0;
		ifraSelf.border=0;
		ifraSelf.scrolling = "auto";
		ifraSelf.src = ifraStrs[2];*/
		
		var sHTML ='<iframe src="'+ifraStrs[2]+'" scrolling = "auto" width="100%" height="100%" frameborder="0" border="0"></iframe>';
		ifraDiv.innerHTML = sHTML;
	}

	//删除一个iframe页

	this.delIfra = function(fID) {
		var ifraDiv = parent.mainFrame.document.getElementsByTagName("div").item(fID);
		var ifraSelf = parent.mainFrame.document.getElementsByTagName("iframe").item(fID);
		ifraSelf.removeNode();
		ifraDiv.removeNode();
	}
	
	//初始化iframe页
	this.initIfra = function() {
		var ifraBody = parent.mainFrame.document.getElementsByTagName("body").item(0);
		ifraBody.innerHTML = "";
	}

	//切换TAB标签
	this.open = function(openID,totalNO,targetIfra,urlStr) {

		//储存目前被打开的标签ID
		cTab.openedID = openID;
		cTab.addPathNode(openID);
		document.getElementById("openTab").value = openID;

		//关闭所有标签

		if(totalNO>0)
		{
			for(i=1;i<=totalNO;i++)
			{
				if("tab_title_text_grey"!=document.getElementById("tdTitle"+i).className)
				{
					if(null!=document.getElementById("imgL"+i))
					{
						document.getElementById("imgL"+i).src = tabLeftOff;
					}
					if(null!=document.getElementById("imgR"+i))
					{
						document.getElementById("imgR"+i).src = tabRightOff;
					}
					if(null!=document.getElementById("tdTitle"+i))
					{
						document.getElementById("tdTitle"+i).className = tabTextClassOff;
					}
					if(null!=document.getElementById("tdCloseTab"+i))
					{
						
						var objclose = document.getElementById("tdCloseTab"+i);
						objclose.className = tabTextClassOff;
						objclose.style.padding = "8px 2px 0 px 0px ";
					}
					if(null!=document.getElementById("table"+i))
					{
						document.getElementById("table"+i).style.display = "none";
					}
				}

				if(targetIfra)
				{
					var divObjs = eval("parent."+targetIfra).document.getElementsByTagName("div");
					//alert(divObjs.length);alert(divObjs[i-1].innerHTML);
					divObjs[i-1].style.display="none";
				}
			}
		}
		
		//打开指定标签
		if(null!=document.getElementById("imgL"+openID))
		{
			document.getElementById("imgL"+openID).src = tabLeftOn;
		}
		if(null!=document.getElementById("imgR"+openID))
		{
			document.getElementById("imgR"+openID).src = tabRightOn;
		}
		if(null!=document.getElementById("tdTitle"+openID))
		{
			document.getElementById("tdTitle"+openID).className = tabTextClassOn;
		}
		if(null!=document.getElementById("tdCloseTab"+openID))
		{
			var objclose = document.getElementById("tdCloseTab"+openID);
			objclose.className = tabTextClassOn;
			objclose.style.padding = "4px 2px 0 px 0px ";
		}
		
		if(targetIfra)
		{
			var divObjs = eval("parent."+targetIfra).document.getElementsByTagName("div");
			divObjs[openID-1].style.display="block";
		}
		else
		{
			document.getElementById("table"+openID).style.display = "block";
		}
	}

	//增加一个TAB标签页

	this.add = function(newStr) {
		tabInp.value += "|"+newStr;
		cTab.createBody();
		cTab.addIfra(newStr);
		cTab.open(i,cTab.tabLen,ifraName,tabLink);
		var tabDiv = document.getElementById("tabDIV");
		if((tabDiv.offsetWidth-tabTd.offsetWidth)>0)
		{
			tabDiv.style.left = -(tabDiv.offsetWidth-tabTd.offsetWidth) + "px";
		}
	}
	
	//减少一个TAB标签页

	this.subtract = function(subtractID) {
		if(!subtractID)
		{
			subtractID=cTab.openedID-1;
		}
		theTabStr = cTab.tabStr.split("|");
		var inpStr = "";
		for(j=0;j<theTabStr.length;j++)
		{
			if(j!=subtractID)
			{
				inpStr += theTabStr[j];
				if(j!=(theTabStr.length-1))
				{
					if(j!=(theTabStr.length-2))
					{
						inpStr = inpStr + "|";
					}
					else
					{
						if(subtractID!=(theTabStr.length-1))
						{
							inpStr = inpStr + "|";
						}
					}
				}
			}

		}
		tabInp.value = inpStr;
		cTab.createBody();
		//alert(subtractID);
		cTab.delIfra(subtractID);
		
		cTab.delPathNode(subtractID+1);
		if(cTab.openedID>=(subtractID+1))
		{
			if(cTab.openedID==(subtractID+1)&&cTab.openedPath!="")
			{
				toOpenIDArr = cTab.openedPath.split(",");
				toOpenID = parseInt(toOpenIDArr[toOpenIDArr.length-1]);
				aTabStrNew = cTab.tabStr.split("|");
				tabAttriableNew = aTabStrNew[toOpenID-1].split(",");
				cTab.open(toOpenID,cTab.tabLen,tabAttriableNew[1],tabAttriableNew[2]);
			}
			else
			{
				aTabStrNew = cTab.tabStr.split("|");
				tabAttriableNew = aTabStrNew[cTab.openedID-2].split(",");
				cTab.open(cTab.openedID-1,cTab.tabLen,tabAttriableNew[1],tabAttriableNew[2]);
			}
		}
		else
		{
			aTabStrNew = cTab.tabStr.split("|");
			tabAttriableNew = aTabStrNew[cTab.openedID-1].split(",");
			cTab.open(cTab.openedID,cTab.tabLen,tabAttriableNew[1],tabAttriableNew[2]);
		}
	}

	//初始化TAB页

	this.init = function() {
		initID = parseInt(document.getElementById("openTab").value);
		cTab.createBody();
		cTab.initIfra();
		cTab.createIfra();
		initArtt = aTabStr[initID-1].split(",");
		initTarget = initArtt[1];
		initURL = initArtt[2];
		cTab.open(initID,cTab.tabLen,initTarget,initURL);
	}

	//显示-隐藏左右翻滚箭头
	this.cSIcon = function() {
		var tabDiv = document.getElementById("tabDIV");
		var iconSL = document.getElementById("iconScrollLeft");
		var iconSR = document.getElementById("iconScrollRight");
		iconSR.style.visibility = iconSL.style.visibility = (tabTd.offsetWidth<tabDiv.offsetWidth)?"visible":"hidden";
	}

	//显示关闭按纽
	this.showIcon = function(iconID) {
		if(document.getElementById("iconCloseTab"+iconID))
		{
			document.getElementById("iconCloseTab"+iconID).style.visibility = "visible";
		}
	}

	//隐藏关闭按纽
	this.hiddenIcon = function(iconID) {
		if(document.getElementById("iconCloseTab"+iconID))
		{
			document.getElementById("iconCloseTab"+iconID).style.visibility = "hidden";
		}
	}

	//向左移动TAB标签
	this.moveLeftF = function() {
		var tabDiv = document.getElementById("tabDIV");
		tabDivL = getLeft(tabDiv.style.left);
		if(tabDivL<0)
		{
			tabDiv.style.left = (tabDivL+6)+"px";
		}
	}
	this.moveLeft = function() {
		var tabDiv = document.getElementById("tabDIV");
		tabDivL = getLeft(tabDiv.style.left);
		if(tabDivL<0)
		{
			tabDiv.style.left = (tabDivL+2)+"px";
		}
	}	
	this.moveL = function () {
		if(MT)
		{
			clearInterval(MT);
		}
		if(null!=MTF) {
			clearInterval(MTF);
		}
		MT = setInterval("theCreateTab.moveLeft()",1)
	}
	this.moveLF = function () {
		if(MT)
		{
			clearInterval(MT);
		}
		if(null!=MTF) {
			clearInterval(MTF);
		}
		MTF = setInterval("theCreateTab.moveLeftF()",1)
	}

	//向右移动TAB标签
	this.moveRightF = function() {
		var tabDiv = document.getElementById("tabDIV");
		tabDivL = getLeft(tabDiv.style.left);
		if(Math.abs(tabDivL)<tabDiv.offsetWidth-tabTd.offsetWidth)
		{
			tabDiv.style.left = (tabDivL-6)+"px";
		}
	}
	this.moveRight = function() {
		var tabDiv = document.getElementById("tabDIV");
		tabDivL = getLeft(tabDiv.style.left);
		if(Math.abs(tabDivL)<tabDiv.offsetWidth-tabTd.offsetWidth)
		{
			tabDiv.style.left = (tabDivL-2)+"px";
		}
	}
	this.moveR = function () {
		if(MT)
		{
			clearInterval(MT);
		}
		if(null!=MTF) {
			clearInterval(MTF);
		}
		MT = setInterval("theCreateTab.moveRight()",1)
	}
	this.moveRF = function () {
		if(MT)
		{
			clearInterval(MT);
		}
		if(null!=MTF) {
			clearInterval(MTF);
		}
		MTF = setInterval("theCreateTab.moveRightF()",1)
	}

	//停止移动
	this.stopMove = function () {
		if(MT)
		{
			clearInterval(MT);
		}
		if(null!=MTF) {
			clearInterval(MTF);
		}
	}
}
/********************TOP页面TAB标签代码 结束*************************/