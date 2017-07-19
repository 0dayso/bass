var fs = require('fs');
/*
	关闭系统现行的所有NodeJs应用,目前仅支持windows
*/
module.exports.closeNodeProcess = function(){
	var exec = require('child_process').exec; 
	var cmdStr = "tskill node";
	exec(cmdStr, function(err,stdout,stderr){
	    if(err) {
	    	console.log('closeProcess ' + cmdStr + ' error:\r\n'+stderr);
	    }
	});
}
/*
	执行系统命令,并提供回调callback(stdout,stderr),目前仅支持windows
*/
module.exports.runSysProcess = function(cmdStr,callback){
	var exec = require('child_process').exec; 
	if(cmdStr){
		exec(cmdStr, function(err,stdout,stderr){
			if(callback){
				callback(stdout,stderr);
			}else{
				if(stderr){
					console.log(stderr);
				}else{
					console.log(stdout);
				}
			}
		});
	}
}
/*
	从根目录定位目录路径,支持url标准表示方法
*/
module.exports.getProjectPath = function(filePath){
	//处理路径问题
	var rootDir = __dirname.substr(0,__dirname.lastIndexOf("widget")+6);//根目录,widget
	var filePath = rootDir+filePath;
	//兼容windows的路径
	if(process.platform.indexOf("win")>=0){
		filePath = filePath.replace(/\//g,"\\");
	}
	return filePath
}
/*
	全部采用同步方式,在nodejs中加载文件,返回buffer缓冲器,encoding默认为二进制加载
*/
module.exports.loadFileSync = function(filePath,encoding){//widget是根路径
	filePath = module.exports.getProjectPath(filePath);
	if(!encoding){
		encoding = "binary";
	}
	var isFileExist = fs.existsSync(filePath);

	var resultBuffer;

	if(isFileExist){
		var content = fs.readFileSync(filePath, encoding);
		resultBuffer = new Buffer(content,encoding); 
	}else{
		resultBuffer = new Buffer(0); 
		console.log("未找到系统文件:"+filePath);
	}
	return resultBuffer;
}

module.exports.readDirDoSomething = function(path,callback,isDeep){
	var files = fs.readdirSync(path);
	files.forEach(function(file){
		fs.stat(path + '/' + file, function(err, stat){
			if(err){console.log(err); return;}
			if(stat.isDirectory()){
				if(callback){
					callback(path + '/' + file,'','');
				}
				if(isDeep){
					module.exports.readDirDoSomething(path + '/' + file,callback,isDeep);
				}
			}else{
				if(callback){
					callback('', file ,path + '/' + file);
				}
			}
		});
	});
}
