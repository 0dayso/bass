var sysUtils = require("./sysUtils.js");
/*
	载入测试对象类型,传入文件名称,默认的
*/
module.exports.loadJSObjectType = function(name,path){
	if(!path){
		path = "/widgets/";
	}
	var filePath=path + name + ".js";
	var objectBuf = sysUtils.loadFileSync(filePath,'utf-8');
	var object;
	if(objectBuf.length == 0){
		object = new Object();
		console.log("载入对象失败");
	}else{
		object = eval("("+objectBuf.toString()+")"); 
	}
	return object;
}
/*
	将depends指定的依赖对象全部导入上下文中
*/
module.exports.loadJSObject = function(name,$,_,depends,path){
	//后台模拟方法
	$.prototype.bind = function(){};
	$.proxy = function(){};
	
	//依次载入父类型函数对象到上下文环境中,
	var env_type = "";
	var current_type;
	if(depends){
		for(var i=0;i<depends.length;i++){
			current_type = module.exports.loadJSObjectType(depends[i],path);
			eval(depends[i] + "= current_type");
		}
	}
	var objectType = module.exports.loadJSObjectType(name,path);
	return objectType;
}


