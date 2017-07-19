<%@ page contentType="text/html; charset=utf-8"%>
<html>
	<head>
		<title>预警阀值及人员信息导入日志</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
			
			
			Ext.onReady(function() {
				var bStore = new Ext.data.JsonStore({ 
					url: "${mvcPath}/hbapp/app/warning/warningUserBaseInfo.jsp",
					baseParams:{cityStr:encodeURI(''),
						areaStr:encodeURI('')},
					totalProperty:'Total',
					fields:['level','cityName','countyName','channelName' ,'redWarnVal' ,'redUserName' ,'redUserPhone' ,'orangeWarnVal' ,'orangeUserName' ,'orangeUserPhone' ,'blueWarnVal' ,'blueUserName' ,'blueUserPhone','createUser','createDate'],
					root:'Info'
				});
				
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,{header:"等级",dataIndex:"level",width:40}
						,{header:"地市",dataIndex:"cityName",width:40}
						,{header:"区县",dataIndex:"countyName",width:80}
						,{header:"渠道编码",dataIndex:"channelName",width:200}
						,{header:"红色预警阀值",dataIndex:"redWarnVal",width:80}
						,{header:"联系人姓名",dataIndex:"redUserName",width:80}
						,{header:"联系人电话",dataIndex:"redUserPhone",width:80}
						,{header:"橙色预警阀值",dataIndex:"orangeWarnVal",width:80}
						,{header:"联系人姓名",dataIndex:"orangeUserName",width:80}
						,{header:"联系人电话",dataIndex:"orangeUserPhone",width:80}
						,{header:"蓝色预警阀值",dataIndex:"blueWarnVal",width:80}
						,{header:"联系人姓名",dataIndex:"blueUserName",width:80}
						,{header:"联系人电话",dataIndex:"blueUserPhone",width:80}
						,{header:"操作时间",dataIndex:"createUser",width:80}
						,{header:"操作人",dataIndex:"createDate",id:"col"}]);
						
				var gridB = new Ext.grid.GridPanel({
					id:'gridC',
					ds:bStore,
					height:500,
					split: true,
					border:false,
					cm:cm,
					autoExpandColumn:'col',
					loadMask: true,
					tbar:new Ext.PagingToolbar({
						pageSize:20,
						store:bStore,
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'没有记录'
					})
				});
				
				var dataOpType = [['INSERT','新增'],['DELETE','删除']];
				
				var storeOpType = new Ext.data.SimpleStore({
					fields:['value','text'],
					data:dataOpType			
				});
				
				var comOpType = new Ext.form.ComboBox({
					store:storeOpType,
					emptyText:'请选择',
					mode:'local',
					triggerAction:'query',
					valueField:'value',
					displayField:'text'
				});
				
				var formQuery = new Ext.form.FormPanel({
					labelAlign:'right',
					labelWidth:150,
					frame:'true',
					autoScroll: true,
					autoHeight:true,
					split: true,
					id:'queryInfo',
					border:false,
					items:[{
						layout:'column',
						xtype:'fieldset',
						title:'审核日志信息查询条件',
						autoHeight:true,
						collapseMode: 'mini',
						collapsible: true,
						items:[{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.TextField({fieldLabel:'地市',id:'cityStr'})
							]},
						{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.TextField({fieldLabel:'县域',id:'areaStr'})
							]
						},
							{
							layout:'form',
							columnWidth:.1,
							items:[
								new Ext.Button({text:'查询',handler:function(){queryBur();}})
							]},
							{
							layout:'form',
							columnWidth:.10,
							items:[
								new Ext.Button({text:'重置',handler:function(){clearBur();}})
							]}
						]}
					]
				});
				
				new Ext.form.TextField({fieldLabel:'地市',id:'cityStr'}),
								new Ext.form.TextField({fieldLabel:'县域',id:'areaStr'})
								new Ext.Button({text:'查询',handler:function(){queryBur();}}),
								new Ext.Button({text:'重置',handler:function(){clearBur();}})
				
				//页面视图
				var viewportCt = new Ext.Viewport({
					layout: 'border',
					items:[
						{
							region: 'center',
							layout:"accordion",
							layoutConfig: {animate: true},
							split: true,
							items:[
								{
									region: 'south',
									title:'预警阀值和人员导入日志信息',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									border:false,
									items:[formQuery,gridB]
								}]
						}
					]
				});
				
				function clearBur(){
					document.getElementById("cityStr").value = "";
					document.getElementById("areaStr").value = "";
					//获取combo中数据的方法
					//Ext.getCmp('comboOptype').setValue('');
					//Ext.getCmp('comboStatus').setValue('');
				}
				
				function queryBur(){
					var cityStr = document.getElementById("cityStr").value;
					var areaStr = document.getElementById("areaStr").value;
					bStore.baseParams={cityStr:encodeURI(cityStr),
						areaStr:encodeURI(areaStr)};
					bStore.load({
						params:{start:0,limit:20},
						callback :function(){
						}
					});
				}
			});
		</script>
	</head>
	<body>
	</body>
</html>