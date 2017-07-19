<%@ page contentType="text/html; charset=utf-8"%>
<html>
	<head>
		<title>号头审批日志查看</title>
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
			
			Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
			
			Ext.onReady(function() {
				Ext.QuickTips.init();
				//D:\workspace\bass\WebRoot\hbbass\salesmanager\areasale\bureauAudit\msisdn_header_log.jsp
				Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

		        var ly_7 = new Ext.Viewport({
						     layout:'border',
						     items:[_tab]
		        });
			});
			
			var _tab=new Ext.TabPanel({
					region:'center',
				   deferredRender:false,
				   enableTabScroll:true,
				   activeTab:0,
					items:[
						{
							title:"号头审批日志查看", tabTip:"号头审批日志查看", 
							html:"<iframe src='msisdn_header_log.jsp' width='100%' height='100%' frameborder='0' scrolling='auto' id='index1'></iframe>",
							id:"tab1",
							closable:false,
							autoScroll:true
							,iconCls:'save'
						 },
						 {
							title:"入库号头信息查看", tabTip:"入库号头信息查看", 
							html:"<iframe src='msisdn_ruku.jsp' width='100%' height='100%' frameborder='0' scrolling='auto' id='index2'></iframe>",
							id:"tab2",
							closable:false,
							autoScroll:true
							,iconCls:'save'
						 }
					]
					
				});
		</script>
	</head>
	<body>
	</body>
</html>