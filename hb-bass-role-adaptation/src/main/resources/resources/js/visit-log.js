var mvcPath = $("#mvcPath").val();
var myview = $.extend({}, $.fn.datagrid.defaults.view, {
	onAfterRender: function(target) {
		$.fn.datagrid.defaults.view.onAfterRender.call(this, target);
		var opts = $(target).datagrid('options');
		var vc = $(target).datagrid('getPanel').children('div.datagrid-view');
		vc.children('div.datagrid-empty').remove();
		if(!$(target).datagrid('getRows').length) {
			var d = $('<div class="datagrid-empty"></div>').html(opts.emptyMsg || 'no records').appendTo(vc);
			d.css({
				position: 'absolute',
				left: 0,
				top: 50,
				width: '100%',
				textAlign: 'center'
			});
		}
	}
});
function getQueryData(){
	var data ={};
	
	var q_city = $("#cityList").combobox('getValue');
	if(q_city && q_city!='-1'){
		data.areaId = q_city;
	}
	
	var q_startDate = $("#q_startDate").datebox('getValue');
	if(q_startDate){
		data.startDate = q_startDate;
	}
	
	var q_endDate = $("#q_endDate").datebox('getValue');
	if(q_endDate){
		data.endDate = q_endDate;
	}
	return data
}
$(function(){
	$("#query").click(function(){
		var opts = $("#visitLogList").datagrid("options");
		opts.url = mvcPath+'/visit/log/visitLogList';
		var queryData = getQueryData();
		$('#visitLogList').datagrid({queryParams:queryData});
		//$('#reportMaintenance').datagrid('load');
	});
	$('#cityList').combobox({
		url: mvcPath+'/visit/log/cityList',
		width: 200,
		valueField: 'id',
		textField: 'name',
		value:'-1'
	});
	$("#q_endDate").datebox({  
	    onSelect : function(date){  
	    		var endDate = $(this).datebox('getValue');
	    		var startDate = $("#q_startDate").datebox('getValue');
	    		if(!startDate){
	    			$.messager.alert('选择结束日期','请先选择开始日期','error');
	    			$(this).datebox('setValue','');
	    			return;
	    		}
	    		var flag = startDate <= endDate;
	    		if(!flag){
        			$.messager.alert('选择结束日期','结束日期要大于等于开始日期','error');
        			$(this).datebox('setValue','');
	    			return;
        		}
	    }  
	});  
	$("#visitLogList").datagrid({
		url: '',   
		method:'post',
		view: myview,
		emptyMsg: '<span style="color:red;font-size:16px;">没有相关记录!<span>',
	    columns:[[    
	    	    {field:'areaName',title:'地市名称',width:100},
	        {field:'times',title:'访问人次',width:100},  
	        {field:'count',title:'人数',width:100}
	    ]],
	    fitColumns: true,
	    singleSelect:true
	});
});