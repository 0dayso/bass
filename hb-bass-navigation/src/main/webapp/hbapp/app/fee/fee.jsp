<%@ page contentType="text/html; charset=utf-8"%>

<html>
	<head>
		<title>fee维护</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<style type="text/css">
.add {
	background-image: url(${mvcPath}/hbapp/resources/image/default/add.gif) !important
		;
}

.option {
	background-image: url(${mvcPath}/hbapp/resources/image/default/plugin.gif)
		!important;
}

.remove {
	background-image: url(${mvcPath}/hbapp/resources/image/default/delete.gif)
		!important;
}

.save {
	background-image: url(${mvcPath}/hbapp/resources/image/default/save.gif)
		!important;
}
</style>
		
		<script type="text/javascript">
			var itemsPerPage = 14;
			var WEB_DS = "jdbc/WEBDB";
			var DW_DS = "jdbc/DWDB";
			Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
			Ext.onReady(function() {
				Ext.QuickTips.init();
				var bStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'echl_type'
					}, {
						name : 'fee_type'
					}, {
						name : 'order'
					}
					])
				});
				
				var smb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
					
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,smb
						,{header:"类型",dataIndex:"echl_type"}
						,{header:"套餐名称",dataIndex:"fee_type",width:400}
						,{header:"套餐编码",dataIndex:"order",id:"col"}
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
				var typeStore = new Ext.data.JsonStore({ 
					url:'/mvc/sqlQuery'
					,fields:['value','text']
				});
				typeStore.baseParams['ds'] = DW_DS;
				typeStore.baseParams['isCached'] = "false";
				typeStore.baseParams['sql'] = "select distinct echl_type value,echl_type text from NWH.ECHL_FEECHG_ORDER";
				typeStore.reload();
				var toolBarRe = new Ext.Toolbar([
					{text:'新增',
					iconCls:'add',
					handler:function(){
						feeStore.removeAll();
						win.show();
						
					}},
					'-',
					{text:'删除',
					iconCls:'remove',
					handler:function(){deleteFee();}}
				]);
				
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
						title:'查询条件',
						autoHeight:true,
						collapseMode: 'mini',
						collapsible: true,
						items:[{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.TextField({fieldLabel:'套餐名称',id:'cName'})
							]},
							{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.TextField({fieldLabel:'套餐编码',id:'bName'})
							]},
							{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.ComboBox({
			                        fieldLabel: '套餐类型',
			                        hiddenName:'feeType',
			                        hiddenId:'feeType',
			                        id:'comboQueryFeeType',
			                        store: typeStore,
			                        valueField:'value',
			                        displayField:'text',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        width:125,
			                        selectOnFocus:true
			                    })
							]},
							{
							layout:'form',
							columnWidth:.10,
							items:[
								new Ext.Button({text:'查询',handler:function(){queryBur();}}),
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
									title:'fee信息维护',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									border:false,
									items:[formQuery,toolBarRe,gridB]
								}]
						}
					]
				});
				
				
				
				function clearBur(){
					document.getElementById("cName").value = "";
					document.getElementById("bName").value = "";
					
					Ext.getCmp('comboQueryFeeType').setValue('');
				}
				
				function queryBur(){
					var cName = document.getElementById("cName").value;
					var bName = document.getElementById("bName").value;
					var type = document.getElementById("feeType").value;
					var sql="select * from NWH.ECHL_FEECHG_ORDER where 1=1 "
					if(""!= cName && cName.length>0){
						sql+=" and FEE_TYPE like '%" + cName + "%' ";
					}
					
					if(""!= bName && bName.length>0){
						sql+=" and ORDER like '%" + bName + "%' ";
					}
					
					if(""!= type && type.length>0){
						sql+=" and ECHL_TYPE ='" + type + "' ";
					}
					sql+=" with ur";
					bStore.baseParams['sql']=sql;
					bStore.baseParams['ds'] = DW_DS;
					bStore.load({
					params : {
						start : 0,
						limit : itemsPerPage
						},
					callback:function(){
						
					}
					});
					
				}
				
				function queryFee(){
					var feeId = document.getElementById("fee_id").value;
					var feeName = document.getElementById("fee_name").value;
					var sql="select fee_id,fee_name from nwh.fee where 1=1 ";
					if(""!=feeId){
						sql+=" and fee_id like '%"+feeId+"%'";
					}
					if(""!=feeName){
						sql+=" and fee_name like '%"+feeName+"%'";
					}
					feeStore.baseParams['sql']=sql;
					feeStore.baseParams['ds']=DW_DS;
					feeStore.load({
					params : {
						start : 0,
						limit : 12
						},
					callback:function(){
						
					}
					});
				}
								
				function deleteFee(){
					var selections = gridB.getSelectionModel().getSelections();
						if(selections.length == ''){
							//alert('请选中高校列表记录后再进行删除操作！');
							Ext.MessageBox.show({
								title : '信息',
								msg : '请选中记录后再进行删除操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
					Ext.Msg.confirm('信息', '确定要删除信息？', function(btn){
							if(btn=='yes'){
								var mask = new Ext.LoadMask(Ext.getBody(), {
									msg : '正在加载数据，请稍候！',
									removeMask : true
								});
								mask.show();
								var order = '';

								for(var i = 0;i < selections.length;i++){
									var record = selections[i];
									if(i == 0){
										order += "'"+record.get('order')+"'";
									}else{
										order += ",'"+record.get('order')+"'";
									}
								}
								var sql="delete from NWH.ECHL_FEECHG_ORDER where order in("+order+")";
								Ext.Ajax.request({
											url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
											method:"post",
											params:{sql:sql,ds:'dw'},
											success:function(response,options){
												var result=response.responseText;
												var msg="";
												if(result=="-1"){
													msg="操作失败";
												}else{
													msg="操作成功";
												}
											
												Ext.MessageBox.show({
													title : '信息',
													msg : msg,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
												mask.hide();
												queryBur();
											}
								});
							}else{
								return;
							}
						});
				}
				
				var feeStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'fee_id'
					}, {
						name : 'fee_name'
					}
					])
				});
				
				var feeCmb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
					
				var feeCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,feeCmb
						,{header:"产品编码",dataIndex:"fee_id",id:"col"}
						,{header:"产品名称",dataIndex:"fee_name",width:350}
						]);
				var fee_id=new Ext.form.TextField({fieldLabel:'产品编码',id:'fee_id'});
				var fee_name=new Ext.form.TextField({fieldLabel:'产品名称',id:'fee_name'});
				var btnQuery=new Ext.Button({text:'查询',handler:function(){queryFee();}});
				var feeGrid = new Ext.grid.GridPanel({
					id:'feeGrid',
					store:feeStore,
					height:450,
					split: true,
					border:false,
					autoScroll: true,
					cm:feeCm,
					sm:feeCmb,
					autoExpandColumn:'col',
					loadMask: true,
					tbar:['产品编码:',fee_id,'产品名称:',fee_name,btnQuery],
					bbar:new Ext.PagingToolbar({
						pageSize:12,
						store:feeStore,
						beforePageText : '第',
						afterPageText : '页，共 {0}页',
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'无数据'
					})
				});
		
		        var win = new Ext.Window({
		            title: 'fee新增',
		            closable:true,
		           	height : 400,
		            width:600,
		            modal:true,
		            closeAction:'hide',
		            border:false,
		            plain:true,
		            layout: 'fit',
		            items: [feeGrid],
		            buttons:[{
		            	text:"新增"
		            	,handler:function(){
		            		var selections = feeGrid.getSelectionModel().getSelections();
		            		if(selections.length==''){
		            			Ext.MessageBox.show({
									title : '信息',
									msg : '请选中记录后再进行新增操作！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								return;
		            		}
		            		Ext.Msg.confirm('信息', '确定添加信息？', function(btn){
								if(btn=='yes'){
									var mask = new Ext.LoadMask(Ext.getBody(), {
										msg : '正在处理数据，请稍候！',
										removeMask : true
									});
									mask.show();
									var _id = '';
	
									for(var i = 0;i < selections.length;i++){
										var record = selections[i];
										if(i == 0){
											_id += "'"+record.get('fee_id')+"'";
										}else{
											_id += ",'"+record.get('fee_id')+"'";
										}
									}
									var sql="insert into NWH.ECHL_FEECHG_ORDER(FEE_TYPE,ORDER) select fee_name,fee_id from nwh.fee where fee_id in(";
									sql+=_id+")";
									Ext.Ajax.request({
												url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
												method:"post",
												params:{sql:sql,ds:'dw'},
												success:function(response,options){
													var result=response.responseText;
													var msg="";
													if(result=="-1"){
														msg="操作失败";
													}else{
														msg="操作成功";
													}
												
													Ext.MessageBox.show({
														title : '信息',
														msg : msg,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});
													mask.hide();
													win.hide();
													queryBur();
												}
									});
								}else{
									return;
								}
							});
		            	}
		            },{
		            	text:'关闭'
		            	,handler:function(){
		            		win.hide();
		            	}
		            }]
		        });
				
				
				
		
		       
			});
		</script>
	</head>
	<body>
	</body>
</html>