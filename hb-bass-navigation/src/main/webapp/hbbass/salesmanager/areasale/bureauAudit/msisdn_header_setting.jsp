<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<html>
	<head>
		<title>属性维护</title>
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
		<%
			User user = (User) request.getSession().getAttribute("user");
			String type=request.getParameter("type");
		%>
		<script type="text/javascript">
			var itemsPerPage = 10;
			var WEB_DS = "jdbc/WEBDB";
			var DW_DS = "jdbc/DWDB";
			var userId='<%=user.getId()%>';
			var type='<%=type%>';
			var label="1"==type?"*运营商":"*网络制式";
			var isAudit=false;
			var username=['zengguohua','zhaojing','admin'];
			for(var i=0;i<username.length;i++){
				if(userId==username[i]){
					isAudit=true;
					break;
				}
			}
			
			Ext.BLANK_IMAGE_URL = "${mvcPath}/hbapp/resources/js/ext/resources/images/default/s.gif";
			Ext.onReady(function() {
				Ext.QuickTips.init();
				
				var ispStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'id'
					}, {
						name : 'type'
					}, {
						name : 'value'
					}
					])
				});
				
				var smb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
					
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,smb
						,{header:"序号",dataIndex:"id",id:"col",width:50}
						,{header:"属性类型",dataIndex:"type",width:250}
						,{header:"属性值",dataIndex:"value",width:250}
						]);
						
				var gridB = new Ext.grid.GridPanel({
					id:'gridB',
					store:ispStore,
					height:450,
					split: true,
					border:false,
					autoScroll: true,
					cm:cm,
					sm:smb,
					//autoExpandColumn:'col',
					loadMask: true,
					tbar:new Ext.PagingToolbar({
						pageSize:itemsPerPage,
						store:ispStore,
						beforePageText : '第',
						afterPageText : '页，共 {0}页',
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'无数据'
					})
				});
				var toolBarRe = new Ext.Toolbar([
					{text:'新增',
					iconCls:'add',
					handler:function(){
						if(!isAudit){
							Ext.MessageBox.show({
								title : '信息',
								msg : '您不具备操作的权限！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						win.show();
						var sql="select max(id) from ACCHEADER_PROP with ur";
						var result="";
						Ext.Ajax.request({
							url:"${mvcPath}/hbirs/action/filemanage?method=checkForWxcs",
							method:"post",
							params:{sql:sql,ds:'web'},
							success:function(response,options){
								result=response.responseText;
								if(result==""||result==null||result=="null"){
									result="1";
								}else{
									result=Number(result)+1;
								}
								Ext.getCmp("prop_id").setValue(result);
								Ext.getCmp("comboType").setValue(type==""?"1":type);
								Ext.getCmp("prop_value").setValue('');
							}
						});
					}},
					'-',
					{text:'修改',
					iconCls:'option',
					handler:function(){doUpdate();}},
					'-',
					{text:'删除',
					iconCls:'remove',
					handler:function(){deleteProp();}}
				]);
			
				
				
				
				var formAdd = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					id:'propAdd',
					border:false,
					items:[
						new Ext.form.ComboBox({
			                        fieldLabel: '*类&nbsp;型',
			                        hiddenName:'cType',
			                        hiddenId:'cType',
			                        id:'comboType',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [
			                            		['1','运营商'],
			                            		['2','网络制式']
			                            		]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        disabled:true,
			                        selectOnFocus:true,
			                        width:150,
			                        allowBlank:false
			                    }),
						new Ext.form.TextField({fieldLabel:'*属性序号',id:'prop_id',width:300,allowBlank:false,disabled:true}),
						new Ext.form.TextField({fieldLabel:label,id:'prop_value',width:300,allowBlank:false})
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){saveProp();}}),
					new Ext.Button({text:'返回',handler:function(){win.hide();}})]
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
									title:'号头属性维护',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									border:false,
									items:[toolBarRe,gridB]
								}]
						}
					]
				});
				
				function query(){
					if(type==""||type=="null"){
						type="1";
					}
					var sql="select id,(case when type=1 then '运营商' when type=2 then '网络制式' end) as type,value from ACCHEADER_PROP where type="+type+" with ur order by id desc";
					ispStore.load({
						params:{sql:sql,ds:WEB_DS,start:0,limit:itemsPerPage}
					});
				}
				query();
				function saveProp(){
					var cType = document.getElementById("cType").value;
					var cId = document.getElementById("prop_id").value;
					var cValue = document.getElementById("prop_value").value;
				
					if(cType == '' || cType == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选择号头属性类型！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cValue == '' || cValue == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '属性值不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					Ext.Msg.confirm('信息', '确认保存号头属性信息？',function(btn){
						if(btn == 'yes'){
							var mask = new Ext.LoadMask(Ext.getBody(), {
								msg : '正在处理数据，请稍候！',
								removeMask : true
							});
							mask.show();
							var sql="insert into ACCHEADER_PROP values(";
							sql+=cId+","+cType+",'"+cValue+"')";
							
							Ext.Ajax.request({
								url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
								method:"post",
								params:{sql:sql,ds:'web'},
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
									query();
								}
							});
						}else{
							return;
						}
					});
				}
				
				
				
				
				
				
				function deleteProp(){
					if(!isAudit){
							Ext.MessageBox.show({
								title : '信息',
								msg : '您不具备操作的权限！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
					var selections = gridB.getSelectionModel().getSelections();
						if(selections.length == ''){
							Ext.MessageBox.show({
								title : '信息',
								msg : '请选中列表记录后再进行删除操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						
						Ext.Msg.confirm('信息', '确定要删除号头属性信息？', function(btn){
							if(btn=='yes'){
								var mask = new Ext.LoadMask(Ext.getBody(), {
									msg : '正在加载数据，请稍候！',
									removeMask : true
								});
								mask.show();
								var _ids = '';
								for(var i = 0;i < selections.length;i++){
									var record = selections[i];
									if(i == 0){
										_ids += record.get('id');
									}else{
										_ids += ","+record.get('id');
									}
								}
								var sql="delete from ACCHEADER_PROP where id in("+_ids+")";
								Ext.Ajax.request({
									url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
									method:"post",
									params:{sql:sql,ds:'web'},
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
										query();
									}
								});
							}else{
								return;
							}
						});
						
						
				}
				
				
				function doUpdate(){
					if(!isAudit){
							Ext.MessageBox.show({
								title : '信息',
								msg : '您不具备操作的权限！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
					var selections = gridB.getSelectionModel().getSelections();
					if(selections.length == ''){
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选中列表记录后再进行修改操作！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(selections.length > 1){
						//alert('只能选中一条高校列表记录进行修改操作！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '只能选中一条列表记录进行修改操作！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					var record = selections[0];
							
					winU.show();
					
					//Ext.getCmp("combouType").setValue(record.get('type'));
					if(record.get('type').replace(/(^\s*)|(\s*$)/g, "")=='运营商'){
						Ext.getCmp('combouType').setValue('1');
					}else{
						Ext.getCmp('combouType').setValue('2');
					}
					
					document.getElementById("uprop_id").value = record.get('id');
					document.getElementById("uprop_value").value = record.get('value');
					
				}
				function updateProp(){
					var cType = document.getElementById("uType").value;
					var cId = document.getElementById("uprop_id").value;
					var cValue = document.getElementById("uprop_value").value;
					
					var sql="update ACCHEADER_PROP set type="+cType+",value='"+cValue+"' where id="+cId;
					Ext.Ajax.request({
								url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
								method:"post",
								params:{sql:sql,ds:'web'},
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
									//mask.hide();
									winU.hide();
									query();
								}
							});
				}
				
		
		        // Panel for the west
		        var nav = new Ext.Panel({
		            region: 'center',
		            split: true,
		            width: 200,
		            collapsible: true,
		            border:false,
		            margins:'3 0 3 3',
		            cmargins:'3 3 3 3',
		            items:[formAdd]
		        });
		
		        var win = new Ext.Window({
		            title: '号头属性新增',
		            closable:true,
		            width:500,
		            height:180,
		            modal:true,
		            closeAction:'hide',
		            //border:false,
		            plain:true,
		            layout: 'border',
		            items: [nav]
		        });
				
				var formU = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					id:'collegeAdd',
					border:false,
					items:[
						new Ext.form.ComboBox({
			                        fieldLabel: '*类&nbsp;型',
			                        hiddenName:'uType',
			                        hiddenId:'uType',
			                        id:'combouType',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [
			                            		['1','运营商'],
			                            		['2','网络制式']
			                            		]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        selectOnFocus:true,
			                        width:150,
			                        allowBlank:false,
			                        disabled:true
			                    }),
						new Ext.form.TextField({fieldLabel:'*属性序号',id:'uprop_id',width:300,allowBlank:false,disabled:true}),
						new Ext.form.TextField({fieldLabel:'*属性值',id:'uprop_value',width:300,allowBlank:false})
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){updateProp();}}),
					new Ext.Button({text:'返回',handler:function(){winU.hide();}})]
				});
				
				// Panel for the west
		        var navU = new Ext.Panel({
		            region: 'center',
		            split: true,
		            width: 200,
		            collapsible: true,
		            border:false,
		            margins:'3 0 3 3',
		            cmargins:'3 3 3 3',
		            items:[formU]
		        });
		
		        var winU = new Ext.Window({
		            title: '号头属性修改',
		            closable:true,
		            width:500,
		            height:180,
		            modal:true,
		            closeAction:'hide',
		            //border:false,
		            plain:true,
		            layout: 'border',
		            items: [navU]
		        });
			});
		</script>
	</head>
	<body>
	</body>
</html>