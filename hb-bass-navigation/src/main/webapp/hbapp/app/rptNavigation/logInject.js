if(typeof todown != "undefined"){
	todown=aihb.Inject.before(todown,function(){
		var _params=aihb.Util.paramsObj();
		
		aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=down"});
	});
}

if(typeof toQuery != "undefined"){
toQuery=aihb.Inject.before(toQuery,function(){
	var _params=aihb.Util.paramsObj();
	aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=query"});
});
}

if(typeof toDownSingle != "undefined"){
	toDownSingle=aihb.Inject.before(toDownSingle,function(){
		var _params=aihb.Util.paramsObj();
		aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=down"});
	});
}

if(typeof SaveAsExcel != "undefined"){
	SaveAsExcel=aihb.Inject.before(SaveAsExcel,function(){
		var _params=aihb.Util.paramsObj();
		aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=down"});
	});
}
if(typeof query != "undefined"){
	query=aihb.Inject.before(query,function(){
		var _params=aihb.Util.paramsObj();
		aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=query"});
	});
}

if(typeof clickSubmit != "undefined"){
	clickSubmit=aihb.Inject.before(clickSubmit,function(){
		var _params=aihb.Util.paramsObj();
		aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=query"});
	});
}
if(typeof down != "undefined"){
	down=aihb.Inject.before(down,function(){
		var _params=aihb.Util.paramsObj();
		aihb.AjaxHelper.log({params: _params._oriUri+"&opertype=down"});
	});
}
