var sysUtils = require("../nodeUtils/sysUtils.js");

function compileAllTags(){
	var path = ".";
	sysUtils.readDirDoSomething(path,function(dirName,fileName,fullFileName){
		var command = "riot "+dirName+" "+dirName+"/../js";
		if(dirName.indexOf("tags")>=0)sysUtils.runSysProcess(command);
	},true);
}

function compileDirTags(dirName){
	if(!dirName) return;
	var tagPath = "./"+dirName+"/tags",jsPath = "./"+dirName+"/js";
	sysUtils.runSysProcess("riot "+tagPath+" "+jsPath);
}

function compileTagFiles(tagFiles){
	if(!tagFiles || !tagFiles.length)return;
	var path = ".";
	sysUtils.readDirDoSomething(path,function(dirName,fileName,fullFileName){
		var command = "riot "+fullFileName+" "+fullFileName+"/../../js";
		if(tagFiles.indexOf(fileName)>=0)sysUtils.runSysProcess(command);
	},true);
}

module.exports.compileAllTagForBuild=function(){
	var path = ".";
	sysUtils.readDirDoSomething(path,function(dirName,fileName,fullFileName){
		if(dirName=="build"){
			return;
		}
		var command = "riot "+dirName+" ./build";
		if(dirName.indexOf("tags")>=0)sysUtils.runSysProcess(command);
	},true);
}

compileDirTags("Form");

// compileDirTags("DateBox");
// compileDirTags("Bulletin");
// compileDirTags("ComboBox");
// compileDirTags("Layouter");
// compileDirTags("Notice");
// compileDirTags("Panel");
// compileDirTags("RadioBox");
// compileDirTags("ToolBar");
// compileDirTags("Form");
// compileDirTags("Table");
