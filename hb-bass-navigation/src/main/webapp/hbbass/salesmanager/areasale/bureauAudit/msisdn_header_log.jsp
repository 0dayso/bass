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
			var itemsPerPage = 10;
			var WEB_DS = "jdbc/WEBDB";
			var DW_DS = "jdbc/DWDB";
			var ispMapping={"移动":"11","联通":"21","电信":"22","未知":"99"};
			Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
			
			Ext.onReady(function() {
				Ext.QuickTips.init();
				
				var bStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'id'
					}, {
						name : 'nbhead'
					}, {
						name : 'head_id'
					}, {
						name : 'brand_name'
					}, {
						name : 'staff'
					}, {
						name : 'create_time'
					}, {
						name : 'audit_flag'
					}
					])
				});
				
				var smb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
					
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,smb
						,{header:"序号",dataIndex:"id"}
						,{header:"号头",dataIndex:"nbhead"}
						,{header:"运营商",dataIndex:"head_id"}
						,{header:"网络制式",dataIndex:"brand_name"}
						,{header:"提交人",dataIndex:"staff"}
						,{header:"提交时间",dataIndex:"create_time",width:180}
						,{header:"审批状态",dataIndex:"audit_flag",id:"col"}
						]);
						
				var gridB = new Ext.grid.GridPanel({
					id:'gridB',
					store:bStore,
					height:450,
					split: true,
					border:false,
					autoScroll: true,
					cm:cm,
					sm:smb,
					autoExpandColumn:'col',
					loadMask: true,
					tbar:new Ext.PagingToolbar({
						pageSize:itemsPerPage,
						store:bStore,
						beforePageText : '第',
						afterPageText : '页，共 {0}页',
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'无数据'
					})
				});
					
				var formQuery = new Ext.form.FormPanel({
					labelAlign:'right',
					labelWidth:150,
					frame:'true',
					layout:'form',
					autoScroll: true,
					autoHeight:true,
					split: true,
					id:'queryInfo',
					border:false,
					items:[{
						layout:'column',
						xtype:'fieldset',
						title:'号头审批日志查询条件',
						autoHeight:true,
						collapseMode: 'mini',
						collapsible: true,
						items:[{
							layout:'form',
							columnWidth:.3,
							items:[
								new Ext.form.TextField({fieldLabel:'号头',id:'nb_head'})
							]},
							{
							layout:'form',
							columnWidth:.3,
							items:[
				                new Ext.form.ComboBox({
				                		id:'comboStatus',
				                        fieldLabel: '状态',
				                        hiddenName:'status',
				                        hiddenId:'status',
				                        store: new Ext.data.SimpleStore({
				                            fields: ['abbr', 'state'],
				                            data : [['','请选择'],
				                            		['fail','审批驳回'],
				                            		['success','审批完成'],
				                            		['audit1','待一级审批'],
				                            		['audit2','待二级审批']]
				                        }),
				                        valueField:'abbr',
				                        displayField:'state',
				                        typeAhead: true,
				                        mode: 'local',
				                        triggerAction: 'all',
				                        selectOnFocus:true,
				                        emptyText:'请选择',
				                        width:140
				                    })
							]},
							{
							layout:'form',
							columnWidth:.2,
							items:[
								new Ext.Button({text:'查询',handler:function(){query();}}),
								new Ext.Button({text:'重置',handler:function(){clearBur();}})
							]}
						]}
					]
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
									title:'号头待审核信息查询',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									border:false,
									items:[formQuery,gridB]
								}]
						}
					]
				});
				
				function query(){
					var sql="select id,NBHEAD,HEAD_ID,BRAND_NAME,staff,create_time,";
					sql+="(case when audit_flag='audit1' then '待一级审批' when audit_flag='audit2' then '待二级审批' when audit_flag='fail' then '审批驳回' when audit_flag='success' then '审批完成' else '待编辑' end) as audit_flag";
					sql+=" from HEADBRAND_AUDIT where 1=1 ";
					
					var _nbhead=document.getElementById("nb_head").value;
					var _audit_flag = document.getElementById("status").value;
					if(""!=_nbhead&&_nbhead.length>0){
						sql+=" and NBHEAD like '%"+_nbhead+"%' ";
					}
					if(""!=_audit_flag && _audit_flag.length>0){
						sql+="  and audit_flag ='"+_audit_flag+"' ";
					}
					sql+=" order by id desc";
					bStore.baseParams['sql']=sql;
					bStore.baseParams['ds'] = WEB_DS;
					bStore.load({
						params:{start:0,limit:itemsPerPage}
					});
				}
				//query();
				function clearBur(){
					document.getElementById("nb_head").value = "";
					Ext.getCmp('comboStatus').setValue('');
				}
				
				
		        
		        
			});
		</script>
	</head>
	<body>
	</body>
</html>