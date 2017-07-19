var marqueeContent=[];
function initNotice(userid)
{
	marqueeContent=[];
	/*ajaxGetListWrapper("select id,reusername,topic from KPIPORTAL_FEEDBACK where isRead='0' and userid='"+userid+"' and reuserid is not null with ur",undefined,returnValue,true);
	var list = returnValue.result;
	if(list.length>0)for(var i =0;i<list.length;i++)marqueeContent[i]="<img src='img/mymsg.gif' bordor=0/><a href='#' onclick='{setTimeout(\"initNotice()\",3000);parent.parent.topFrame.theCreateTab.add(\"�����,mainFrame,feedback.jsp?id="+list[i][0]+"\");}'><font size=2 color='blue'>["+list[i][1]+"]�ظ��������:<"+list[i][2]+"></font></a>"
	*/
	ajaxGetListWrapper("select NEWSID id,char(date(newsdate)) date,substr(newstitle,1,32) text from FPF_USER_NEWS where date(newsdate)>current_date -15 day order by newsdate desc with ur"
	,function(data,options){
		if(data.length>0){
			for(var i =0;i<data.length;i++)
				marqueeContent[marqueeContent.length]="<img src='../../resources/image/default/notice.gif' bordor=0/><a href='#' onclick='{parent.parent.topFrame.theCreateTab.add(\"ϵͳ����,mainFrame,/newsshow.jsp?newsid="+data[i].id+"\");}'><font size=2 color='blue'>("+data[i].date+")"+data[i].text+"</font></a>"
		}
		if(marqueeContent.length>0){
			document.getElementById("marqueeBox").innerHTML="<div>"+marqueeContent[0]+"</div>";
			initMarquee();
		}
	},undefined,false,"&ds=web");
}

var marqueeInterval=new Array(); 
var marqueeId=0; 
var marqueeDelay=3000; 
var marqueeHeight=20; 
function initMarquee() { 
	var str=marqueeContent[0]; 
	//document.write('<div id=marqueeBox style="overflow:hidden;height:'+marqueeHeight+'px" onmouseover="clearInterval(marqueeInterval[0])" onmouseout="marqueeInterval[0]=setInterval(\'startMarquee()\',marqueeDelay)"><div>'+str+'</div></div>'); 
	marqueeInterval[0]=setInterval("startMarquee()",marqueeDelay); 
} 
function startMarquee() { 
	marqueeId++; 
	if(marqueeId>=marqueeContent.length) marqueeId=0;
	var str=marqueeContent[marqueeId]; 
	if(marqueeBox.childNodes.length==1) { 
		var nextLine=document.createElement('DIV'); 
		nextLine.innerHTML=str; 
		marqueeBox.appendChild(nextLine); 
	} 
	else { 
		marqueeBox.childNodes[0].innerHTML=str; 
		marqueeBox.appendChild(marqueeBox.childNodes[0]); 
		marqueeBox.scrollTop=0; 
	} 
	clearInterval(marqueeInterval[1]); 
	marqueeInterval[1]=setInterval("scrollMarquee()",1); 
} 
function scrollMarquee() { 
	marqueeBox.scrollTop++; 
	if(marqueeBox.scrollTop%marqueeHeight==(marqueeHeight-1)){ 
		clearInterval(marqueeInterval[1]); 
	}
}