/**/
window.onload=function(){
	var _div = $C("div");
	
	_div.appendChild($CT("��û��Ȩ�ޣ�������"))
	
	var a = $C("a");
	
	a.appendChild($CT("����Ȩ��"));
	
	a.href="javascript:void(0)";
	
	a.onclick=function(){
		
		if(confirm("ȷ�������Ĺ��Ź���Ա����Ȩ����?")){
		
			var applyText = "";
			var noticeText = "�������Ĺ��Ź���Ա";
			
			for(var i=0;i<user.length;i++){
				if(user[i].kind=="user"){
					applyText += user[i].username+"["+user[i].userid+user[i].group_name+"]�绰:"+user[i].mobilephone+",��������["+menu+"]����Ȩ�ޣ�����˺��ھ���ǰ̨���";
				}else{
					noticeText += user[i].username+"("+user[i].mobilephone+")"
				}
			}
			
			noticeText +="������˶��ţ���ȴ�";
			for(var i=0;i<user.length;i++){
				if(user[i].kind=="mgr"){
					var ajax=new aihb.Ajax({
						url: "/hbirs/service/message"
						,parameters : "contacts="+user[i].mobilephone+"&content="+applyText
						,callback : function(xhr){
							_div.innerHTML="";
							_div.appendChild($CT(noticeText));
						}
					});
					ajax.request();
				}
			}
		}
	}
	
	_div.appendChild(a);
	document.body.appendChild(_div)
}
