/**

*/
var http = require('http');
var url = require("url");
var querystring = require('querystring');
var fs = require('fs');

var KpiMockData ={
	'K10001' : fs.readFileSync('kpidata/K10001',encoding='utf8'),
	'K10002' : fs.readFileSync('kpidata/K10002',encoding='utf8'),
	'K10003' : fs.readFileSync('kpidata/K10003',encoding='utf8')
};

var sqlQueryMockData = {
	'root':[{"AREA_CODE":"HB.WH","AREA_NAME":"武汉"},{"AREA_CODE":"HB.ES","AREA_NAME":"恩施"},{"AREA_CODE":"HB.XF","AREA_NAME":"襄樊"},{"AREA_CODE":"HB.JM","AREA_NAME":"荆门"},{"AREA_CODE":"HB.XG","AREA_NAME":"孝感"},{"AREA_CODE":"HB.HS","AREA_NAME":"黄石"},{"AREA_CODE":"HB.YC","AREA_NAME":"宜昌"},{"AREA_CODE":"HB.JH","AREA_NAME":"江汉"},{"AREA_CODE":"HB.JZ","AREA_NAME":"荆州"},{"AREA_CODE":"HB.HG","AREA_NAME":"黄冈"},{"AREA_CODE":"HB.EZ","AREA_NAME":"鄂州"},{"AREA_CODE":"HB.SY","AREA_NAME":"十堰"},{"AREA_CODE":"HB.XN","AREA_NAME":"咸宁"},{"AREA_CODE":"HB.SZ","AREA_NAME":"随州"}],
	'fields':[{"name":"AREA_CODE","type":"string"},{"name":"AREA_NAME","type":"string"}],
	'columnModel':[{"dataIndex":"AREA_CODE","type":"string","header":"AREA_CODE"},{"dataIndex":"AREA_NAME","type":"string","header":"AREA_NAME"}],
	'count':14,'message':null,'errorMsg':null
};

http.createServer(function(request, response) {
	var urlParse = url.parse(request.url);
	var pathname = urlParse.pathname;
	var query = urlParse.query;
	var jsonQry = querystring.parse(query);
	//console.log('urlParse='+urlParse+',pathname='+pathname+',query='+query);
	//console.log(jsonQry);

	if (/\/DateServer(\/)+api/.test(pathname)){
		//console.log('api环境!');
		var _paths = pathname.split('/');
		var _ids = _paths[_paths.length - 1];
		//console.log(_ids);
		if (/\/kpi/.test(pathname)){
			//console.log('kpi环境!');
			response.writeHead(200, {"Content-Type": "application/json;charset=UTF-8",});
			var trendReg = /\/trendData/;
			var isTrend = trendReg.test(pathname);
			//console.log(isTrend);
			var _arrayId = _ids.split(",");
			var res ;
			if (isTrend){
				//趋势
			}else {
				if (_arrayId.length > 1 ){
					var res = "[";
					for(var i=0,len = _arrayId.length;i<len;i++){
						var arr = KpiMockData[_arrayId[i]]||[];
						res = res.concat(arr);
					}
					res += "]";
				}else{
					res = KpiMockData[_arrayId[0]]||[];
				}
			}
			response.write(jsonp(query,res));
		}else if (/\/sql/.test(pathname)){
			//console.log('sql环境!');
			if ("areaSql"==_ids){
				response.writeHead(200, {
				"Content-Type": "application/json;charset=UTF-8",
				"Access-Control-Allow-Origin": "*",
				"Access-Control-Allow-Headers": "Content-Type",
				"Access-Control-Allow-Methods":"PUT,POST,GET,DELETE,OPTIONS",
				"X-Powered-By":' 3.2.1'
				});
				response.write(JSON.stringify(sqlQueryMockData));
			}
		}
	}else{
		response.write('{}');
	}
	response.end();
}).listen(18080);

function jsonp(query,oriStr){
	if(query!=null && query.indexOf('jsoncallback=')>-1){
		var callback = query.substring(query.indexOf('jsoncallback=')+13,query.indexOf('&'));
		return callback+'('+oriStr+')';
	}
	return oriStr;
}