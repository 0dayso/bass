/**/
window.onload=function(){
	var _div = $C("div");
	
	_div.appendChild($CT("您没有权限，点这里"))
	
	var a = $C("a");
	
	a.appendChild($CT("申请权限"));
	
	a.href="javascript:void(0)";
	
	a.onclick=function(){
		
		if(confirm("确认向您的工号管理员申请权限吗?")){
		
			var applyText = "";
			var noticeText = "已向您的工号管理员";
			
			for(var i=0;i<user.length;i++){
				if(user[i].kind=="user"){
					applyText += user[i].username+"["+user[i].userid+user[i].group_name+"]电话:"+user[i].mobilephone+",向您申请["+menu+"]访问权限，请审核后在经分前台添加";
				}else{
					noticeText += user[i].username+"("+user[i].mobilephone+")"
				}
			}
			
			noticeText +="发送审核短信，请等待";
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
