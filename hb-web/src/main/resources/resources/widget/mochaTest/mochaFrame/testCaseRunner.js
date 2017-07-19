/*
js后台测试
运行mochaTestCase下指定的测试案例
nodejs下可直接执行
params
pattern:需要运行测试案例的匹配模式,根据it中的第一个参数info来匹配,如果不传入pattern,则测试所有案例
*/
var sysUtils = require("../../nodeUtils/sysUtils.js");

module.exports.runCase = function(pattern){
	//将测试目录指向mochaTestCase目录下
	var testDir = sysUtils.getProjectPath("/mochaTest/mochaCase");

	//默认mocha执行在./test/*的测试案例,recursive执行新的执行测试用例路径
	var cmdStr = "mocha --recursive "+testDir;
	if(pattern){
		cmdStr += ' --grep '+pattern;
	}
	console.log(cmdStr);
	var exec = require('child_process').exec; 
	exec(cmdStr, function(err,stdout,stderr){
		if(err){
			console.log(err);
		}
		if(stdout){
			console.log(stdout);
		}
	 });
}




