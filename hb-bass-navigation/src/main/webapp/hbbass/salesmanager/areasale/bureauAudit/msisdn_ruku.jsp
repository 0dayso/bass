<%@ page contentType="text/html; charset=utf-8"%>

<html>
	<head>
		<title>入库号头信息查看</title>
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
		<style type="text/css">
	        .add {
	            background-image:url(${mvcPath}/hbapp/resources/image/default/add.gif) !important;
	        }
	        .option {
	            background-image:url(${mvcPath}/hbapp/resources/image/default/plugin.gif) !important;
	        }
	        .remove {
	            background-image:url(${mvcPath}/hbapp/resources/image/default/delete.gif) !important;
	        }
	        .save {
	            background-image:url(${mvcPath}/hbapp/resources/image/default/save.gif) !important;
	        }
	    </style>
	    
		<script type="text/javascript">
			var itemsPerPage = 15;
			var WEB_DS = "jdbc/WEBDB";
			var DW_DS = "jdbc/DWDB";
			Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
			
			Ext.onReady(function() {
				Ext.QuickTips.init();
				
				var dataStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'nbhead'
					}, {
						name : 'head_id'
					}, {
						name : 'brand_name'
					}
					])
				});
				
					
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,{header:"号头",dataIndex:"nbhead",id:"col",width:20}
						,{header:"运营商",dataIndex:"head_id",width:150}
						,{header:"网络制式",dataIndex:"brand_name",width:150}
						]);
						
				var gridB = new Ext.grid.GridPanel({
					loadMask : {msg:'正在加载数据,请稍等......'}, 
					id:'gridB',
					store:dataStore,
					height:450,
					split: true,
					border:false,
					autoScroll: true,
					cm:cm,
					autoExpandColumn:'col',
					tbar:new Ext.PagingToolbar({
						pageSize:itemsPerPage,
						store:dataStore,
						beforePageText : '第',
						afterPageText : '页，共 {0}页',
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'无数据'
					})
				});
					
				
				
				
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
									title:'号头待审核信息',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									border:false,
									items:[gridB]
								}]
						}
					]
				});
				
				function query(){
					var sql1="select NBHEAD,";
					sql1+="(case when head_id=11 then '中国移动' when head_id=22 then '中国电信' when head_id=21 then '中国联通' when head_id=99 then '未知' end) as head_id";
					sql1+=",brand_name from mk.DIM_HEADBRAND_ALL  order by NBHEAD desc";
					dataStore.baseParams['sql']=sql1;
					dataStore.baseParams['ds'] = DW_DS;
					dataStore.load({
						params:{start:0,limit:itemsPerPage}
					});
				}
				query();
				
		        });
		</script>
	</head>
	<body>
	</body>
</html>