<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<html>
	<head>
		<title>号头审批人维护</title>
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
		%>
		<script type="text/javascript">
			var itemsPerPage = 10;
			var WEB_DS = "jdbc/WEBDB";
			var DW_DS = "jdbc/DWDB";
			Ext.BLANK_IMAGE_URL = "${mvcPath}/hbapp/resources/js/ext/resources/images/default/s.gif";
			var userId='<%=user.getId()%>';
			var isAudit=false;
			var username=['zengguohua','zhaojing','admin'];
			for(var i=0;i<username.length;i++){
				if(userId==username[i]){
					isAudit=true;
					break;
				}
			}
			Ext.onReady(function() {
				Ext.QuickTips.init();
				var opStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'id'
					}, {
						name : 'op1'
					}, {
						name : 'op2'
					}, {
						name : 'cityid'
					}
					])
				});
				
				var smb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
					
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,smb
						,{header:"序号",dataIndex:"id",width:50,id:"col"}
						,{header:"一级审批人",dataIndex:"op1",width:250}
						,{header:"二级审批人",dataIndex:"op2",width:250}
						,{header:"地市",dataIndex:"cityid",width:250}
						]);
						
				var gridB = new Ext.grid.GridPanel({
					id:'gridB',
					store:opStore,
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
						store:opStore,
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
						var sql="select max(id) from ACCHEADER_AUDIT with ur";
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
								Ext.getCmp("c_id").setValue(result);
								Ext.getCmp("comboCity").setValue('');
								Ext.getCmp("comboOp1").setValue('');
								Ext.getCmp("comboOp2").setValue('');
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
					handler:function(){deleteAudit();}}
				]);
			
				var userStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'userid'
					}, {
						name : 'value'
					}
					])
				});
				var comboCity=new Ext.form.ComboBox({
			                        fieldLabel: '*地&nbsp;市',
			                        hiddenName:'cCity',
			                        hiddenId:'cCity',
			                        id:'comboCity',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [
			                            		['0','省公司'],
			                            		['11','武汉'],
			                            		['25','黄冈'],
			                            		['13','鄂州'],
			                            		['26','孝感'],
			                            		['14','宜昌'],
			                            		['19','咸宁'],
			                            		['17','襄樊'],
			                            		['20','荆州'],
			                            		['24','随州'],
			                            		['15','恩施'],
			                            		['18','江汉'],
			                            		['12','黄石'],
			                            		['16','十堰'],
			                            		['23','荆门'],
			                            		['28','天门'],
			                            		['27','潜江']]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        editable:false,
			                        selectOnFocus:true,
			                        width:150,
			                        allowBlank:false,
			                        listeners:{
			                        	select:function(combo,record,index){
			                        		var sql="select userid ,username||' <'||userid||'>'||' <'||mobilephone||'>' value from FPF_USER_USER where cityid='"+record.data.abbr+"' order by userid with ur"
			                        		comboAudit1.clearValue();
			                        		comboAudit2.clearValue();
			                        		userStore.load({params:{sql:sql,ds:WEB_DS,start:0,limit:10000}});
			                        	}
			                        }
			                    });
				var comboAudit1=new Ext.form.ComboBox({
			                        fieldLabel: '*一级审批人',
			                        hiddenName:'c_op1',
			                        hiddenId:'c_op1',
			                        id:'comboOp1',
			                        store: userStore,
			                        valueField:'userid',
			                        displayField:'value',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请先选择地市',
			                        selectOnFocus:true,
			                        editable:false,
			                        width:300,
			                        allowBlank:false
			                    });
			     var comboAudit2=new Ext.form.ComboBox({
			                        fieldLabel: '*二级审批人',
			                        hiddenName:'c_op2',
			                        hiddenId:'c_op2',
			                        id:'comboOp2',
			                        store:userStore,
			                        valueField:'userid',
			                        displayField:'value',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请先选择地市',
			                        selectOnFocus:true,
			                        editable:false,
			                        width:300,
			                        allowBlank:false
			                    });
				
				var formAdd = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					id:'auditAdd',
					border:false,
					items:[
						new Ext.form.TextField({fieldLabel:'*属性序号',id:'c_id',width:100,allowBlank:false,disabled:true}),
						comboCity,
						comboAudit1,
						comboAudit2
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){saveAudit();}}),
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
									title:'号头审批人维护',
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
					var sql="select id,value((select username||' ['||u.userid||']'||' ['||mobilephone||']' from FPF_USER_USER u where u.userid=op1),'') as op1,"
					sql+=" value((select username||' ['||u.userid||']'||' ['||mobilephone||']' from FPF_USER_USER u where u.userid=op2),'') as op2,";
					sql+=" (select value(area_name||','||trim(char(area_id)),'') from mk.bt_area cc where char(cc.AREA_ID) = a.cityid) as cityid";
					 sql+=" from ACCHEADER_AUDIT a order by id desc";
					opStore.load({
						params:{sql:sql,ds:WEB_DS,start:0,limit:itemsPerPage}
					});
				}
				query();
				function saveAudit(){
					var c_id = document.getElementById("c_id").value;
					var c_city=document.getElementById("cCity").value;
					var c_op1 = document.getElementById("c_op1").value;
					var c_op2 = document.getElementById("c_op2").value;
					
					if(c_city == '' || c_city == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '地市不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
				
					if(c_op1 == '' || c_op1 == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '一级审批人不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(c_op2 == '' || c_op2 == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '二级审批人不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					Ext.Msg.confirm('信息', '确认保存审批人信息？',function(btn){
						if(btn == 'yes'){
							var mask = new Ext.LoadMask(Ext.getBody(), {
								msg : '正在处理数据，请稍候！',
								removeMask : true
							});
							mask.show();
							var sql="insert into ACCHEADER_AUDIT values(";
							sql+=c_id+",'"+c_op1+"','"+c_op2+"','"+c_city+"')";
							
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
				
				
				
				
				
				
				function deleteAudit(){
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
						
						Ext.Msg.confirm('信息', '确定要删除审批人信息？', function(btn){
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
								var sql="delete from ACCHEADER_AUDIT where id in("+_ids+")";
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
					var c=record.get('cityid')+"";
					
					document.getElementById("u_id").value=record.get('id');
				}
				function updateAudit(){
					var c_id = document.getElementById("u_id").value;
					var c_city=document.getElementById("uCity").value;
					var c_op1 = document.getElementById("u_op1").value;
					var c_op2 = document.getElementById("u_op2").value;
					
					if(c_city == '' || c_city == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '地市不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
				
					if(c_op1 == '' || c_op1 == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '一级审批人不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(c_op2 == '' || c_op2 == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '二级审批人不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					
					Ext.Msg.confirm('信息', '确定要修改审批人信息？', function(btn){
							if(btn=='yes'){
								var mask = new Ext.LoadMask(Ext.getBody(), {
									msg : '正在加载数据，请稍候！',
									removeMask : true
								});
								mask.show();
								
								var sql="update ACCHEADER_AUDIT set cityid='"+c_city+"',op1='"+c_op1+"',op2='"+c_op2+"' where id="+c_id;
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
										winU.hide();
										query();
									}
								});
							}else{
								return;
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
		            title: '号头审批人新增',
		            closable:true,
		            width:500,
		            height:200,
		            modal:true,
		            closeAction:'hide',
		            border:false,
		            plain:true,
		            layout: 'border',
		            items: [nav]
		        });
				var comboCityU=new Ext.form.ComboBox({
			                        fieldLabel: '*地&nbsp;市',
			                        hiddenName:'uCity',
			                        hiddenId:'uCity',
			                        id:'comboUCity',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [
			                            		['0','省公司'],
			                            		['11','武汉'],
			                            		['25','黄冈'],
			                            		['13','鄂州'],
			                            		['26','孝感'],
			                            		['14','宜昌'],
			                            		['19','咸宁'],
			                            		['17','襄樊'],
			                            		['20','荆州'],
			                            		['24','随州'],
			                            		['15','恩施'],
			                            		['18','江汉'],
			                            		['12','黄石'],
			                            		['16','十堰'],
			                            		['23','荆门'],
			                            		['28','天门'],
			                            		['27','潜江']]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        editable:false,
			                        selectOnFocus:true,
			                        width:150,
			                        allowBlank:false,
			                        listeners:{
			                        	select:function(combo,record,index){
			                        		var sql="select userid ,username||' <'||userid||'>'||' <'||mobilephone||'>' value from FPF_USER_USER where cityid='"+record.data.abbr+"' order by userid with ur"
			                        		comboAudit1U.clearValue();
			                        		comboAudit2U.clearValue();
			                        		userStore.load({params:{sql:sql,ds:WEB_DS,start:0,limit:10000}});
			                        	}
			                        }
			                    });
				var comboAudit1U=new Ext.form.ComboBox({
			                        fieldLabel: '*一级审批人',
			                        hiddenName:'u_op1',
			                        hiddenId:'u_op1',
			                        id:'comboUOp1',
			                        store: userStore,
			                        valueField:'userid',
			                        displayField:'value',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请先选择地市',
			                        selectOnFocus:true,
			                        editable:false,
			                        width:300,
			                        allowBlank:false
			                    });
			     var comboAudit2U=new Ext.form.ComboBox({
			                        fieldLabel: '*二级审批人',
			                        hiddenName:'u_op2',
			                        hiddenId:'u_op2',
			                        id:'comboUOp2',
			                        store:userStore,
			                        valueField:'userid',
			                        displayField:'value',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请先选择地市',
			                        selectOnFocus:true,
			                        editable:false,
			                        width:300,
			                        allowBlank:false
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
						new Ext.form.TextField({fieldLabel:'*属性序号',id:'u_id',width:100,allowBlank:false,disabled:true}),
						comboCityU,
						comboAudit1U,
						comboAudit2U
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){updateAudit();}}),
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
		            title: '号头审批人修改',
		            closable:true,
		            width:500,
		            height:200,
		            modal:true,
		            closeAction:'hide',
		            border:false,
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