/*
js前台测试,启动简单web服务,用于在浏览器里观察行为
nodejs下可直接执行
*/
var types = {
  "css": "text/css",
  "gif": "image/gif",
  "html": "text/html",
  "ico": "image/x-icon",
  "jpeg": "image/jpeg",
  "jpg": "image/jpeg",
  "js": "text/javascript",
  "json": "application/json",
  "pdf": "application/pdf",
  "png": "image/png",
  "svg": "image/svg+xml",
  "swf": "application/x-shockwave-flash",
  "tiff": "image/tiff",
  "txt": "text/plain",
  "wav": "audio/x-wav",
  "wma": "audio/x-ms-wma",
  "wmv": "video/x-ms-wmv",
  "woff":"image/jpeg",
  "eot":"image/jpeg"

};

var sysUtils = require("../../nodeUtils/sysUtils.js");
module.exports.start = function(initHtml,initScript,resource){
	if(!initHtml){
		initHtml = "传入的html为空";
	}
	if(!initScript){
		initScript = "";
	}
	var html = "<!doctype html>"+"\r\n";
		html +="<html>"+"\r\n";
		html +="	<head>"+"\r\n";
		html +="		<meta charset='utf-8'/>"+"\r\n";
		html +="		<meta http-equiv='Content-Type' content='text/html'>"+"\r\n";
		html +="		<title>test in browseEvirnoment</title>"+"\r\n";
		html +="		<link rel='stylesheet' type='text/css' href='/resource/bootstrap/css/bootstrap.min.css' />"+"\r\n";
		html +="		<link rel='stylesheet' type='text/css' href='/resource/Font-Awesome-3.2.1/css/font-awesome.min.css' />"+"\r\n";
		html +="		<link rel='stylesheet' type='text/css' href='/sass/target.css' />"+"\r\n";
		//设定最后一个widget为根目录,测试都使用根目录的url写法,jquery-2.1.1不支持IE9及以下...
		html +="		<script type='text/javascript' src='/resource/jquery/js/jquery-1.11.3.min.js'></script>"+"\r\n";

		//引入underscore
		html +="		<script type='text/javascript' src='/resource/underscore/js/underscore-min-1.8.3.js'></script>"+"\r\n";
		//引入riot
		html +="		<script type='text/javascript' src='/resource/riot/js/riot.js'></script>"+"\r\n";
		//引入boottrap
		html +="		<script type='text/javascript' src='/resource/bootstrap/js/bootstrap.js'></script>"+"\r\n";
		//引入lib js文件
		html +="		<script type='text/javascript' src='/widgets/core/BoxCommpent.js'></script>"+"\r\n";
		html +="		<script type='text/javascript' src='/widgets/core/ComponentBase.js'></script>"+"\r\n";
		html +="		<script type='text/javascript' src='/widgets/core/Container.js'></script>"+"\r\n";
		html +="		<script type='text/javascript' src='/widgets/core/Layouter.js'></script>"+"\r\n";
		html +="		<script type='text/javascript' src='/widgets/core/Widget.js'></script>"+"\r\n";	
		html +="	    "+resource+"\r\n";
		html +="		<script>"+"\r\n";
		html +="			$(function(){"+"\r\n";
		html += 				initScript+"\r\n";
		html +="			});"+"\r\n";
		html +="		</script>"+"\r\n";
		html +="	</head>"+"\r\n";
		html +="	<body>"+"\r\n";
		html +=" 		"+initHtml+"\r\n";
		html +="	</body>"+"\r\n";
		html +="</html>";

	var http = require("http");
	http.createServer(function(req,res){	//建立服务
		var url=require('url');
		var path=require('path');
		var pathname = url.parse(req.url).pathname;
		//默认跟路径为测试路径,其他为请求资源的路径,直接使用流输出文件
		if(pathname == '/' || pathname == '\\'){
			res.writeHead(200,{'Content-type':'text/html;charset=utf-8'});
			res.end(html);
		}else{
			var fileExt = path.extname(pathname);//文件尾缀
			fileExt = fileExt ? fileExt.slice(1) : 'unknown';

			var contentType = types[fileExt] || "text/plain";
			var resType = "";//response 读取缓冲的类型
			if(contentType.indexOf("text")>=0){
				resType = "utf-8";
			}else{
				resType = "binary";
			}
			var resultBuffer = sysUtils.loadFileSync(pathname,resType);

			if(resultBuffer.length == 0){
				res.writeHead(404, {'Content-Type': 'text/plain'});
		        res.write("This request URL " + pathname + " was not found on this server.");
            	res.end();
			}else{
				res.writeHead(200, { 
					'Content-Type': contentType
				});
				res.end(resultBuffer,resType);
			}
		}
	}).listen(5656,'127.0.0.1');	//创建监听
	console.log("server is running at http://localhost:5656/");	
}

module.exports.shutdown = function(){
	sysUtils.closeNodeProcess();
}

module.exports.setUpOrDown = function(initHtml,initScript,resource){
	var cmdStr = "netstat -aon|findstr 5656";
	var callback = function(stdout,stderr){
		if(stdout&&stdout.trim()&&stdout.indexOf("LISTENING")>=0){
			module.exports.shutdown();
		}else{
			module.exports.start(initHtml,initScript,resource);
		}
	};
	sysUtils.runSysProcess(cmdStr,callback);
}


