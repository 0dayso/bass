<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>高校审核日志</title>
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
		<%

			Connection conn = null;
			String userCityId="HB.00";
			try {
				//判断当前登陆人权限
				String auditSql = "SELECT OPT_REGION from FPF_USER_USER where userid='"+session.getAttribute("loginname")+"'";

				conn = ConnectionManage.getInstance().getWEBConnection();
				PreparedStatement ps = conn.prepareStatement(auditSql);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					String region_id=rs.getString(1);
					System.out.println(region_id);
					if(null!=region_id&&!"".equals(region_id)){
						userCityId=region_id.equals("HB")?"HB.00":region_id;
						if(userCityId.length()>5){
							userCityId= userCityId.substring(0, 5);
						}
					}
				}
				rs.close();
				ps.close();

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (conn != null)
					ConnectionManage.getInstance().releaseConnection(conn);
			}
			
			
			
		%>
		<script type="text/javascript">
			var itemsPerPage = 10;
			var WEB_DS = "jdbc/WEBDB";
			var DW_DS = "jdbc/DWDB";
			Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
			
			Ext.onReady(function() {
				Ext.QuickTips.init();
				var bStore = new Ext.data.JsonStore({ 
					//url: "${mvcPath}/hbapp/college/college_audit_log_info.jsp",
					url: "${mvcPath}/hbirs/action/college?method=queryForLog",
					baseParams:{cityStr:encodeURI(''),
						areaStr:encodeURI(''),
						opType:encodeURI(''),
						status:encodeURI(''),
						bName:encodeURI(''),
						cName:encodeURI('')},
					totalProperty:'Total',
					fields:['COLLEGE_ID','COLLEGE_NAME','WEB_ADD','COLLEGE_TYPE','COLLEGE_ADD','SHORT_NUMBER','AREA_ID',
					'MANAGER','STUDENTS_NUM','NEW_STUDENTS','STATE_DATE','MANAGER_NBR','CREATE_DATE','OPERATE_TYPE_STR','STATUS_STR','CREATEUSER','STATUS','OPERATE_TYPE','AREA_ID_STR'],
					root:'Info'
				});
				var cityStore = new Ext.data.JsonStore({ 
					url:'${mvcPath}/hbirs/action/college?method=getCity'
					,fields:['value','text']
				});
				cityStore.load();
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,{header:"高校编码",dataIndex:"COLLEGE_ID"}
						,{header:"高校名称",dataIndex:"COLLEGE_NAME"}
						,{header:"网址",dataIndex:"WEB_ADD"}
						,{header:"高校类型",dataIndex:"COLLEGE_TYPE"}
						,{header:"地址",dataIndex:"COLLEGE_ADD"}
						,{header:"集团号",dataIndex:"SHORT_NUMBER",width:50}
						,{header:"地市",dataIndex:"AREA_ID_STR",width:50}
						,{header:"联系人",dataIndex:"MANAGER",width:50}
						,{header:"在校学生数",dataIndex:"STUDENTS_NUM",width:50}
						,{header:"新生人数/年",dataIndex:"NEW_STUDENTS",width:50}
						,{header:"状态更新时间",dataIndex:"STATE_DATE"}
						,{header:"联系人电话",dataIndex:"MANAGER_NBR",width:50}
						,{header:"创建日期",dataIndex:"CREATE_DATE"}
						,{header:"操作类型",dataIndex:"OPERATE_TYPE_STR",width:50}
						,{header:"动作",dataIndex:"STATUS_STR",width:150}
						,{header:"操作人",dataIndex:"CREATEUSER",id:"col"}]);
						
				var gridB = new Ext.grid.GridPanel({
					id:'gridB',
					store:bStore,
					height:450,
					split: true,
					border:false,
					autoScroll: true,
					cm:cm,
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
					autoScroll: true,
					autoHeight:true,
					split: true,
					id:'queryInfo',
					border:false,
					items:[{
						layout:'column',
						xtype:'fieldset',
						title:'高校审核日志信息查询条件',
						autoHeight:true,
						collapseMode: 'mini',
						collapsible: true,
						items:[{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.TextField({fieldLabel:'高校名称',id:'cName'}),
								new Ext.form.TextField({fieldLabel:'高校编码',id:'bName'})
							]},
							{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.ComboBox({
										id:'comboOptype',
				                        fieldLabel: '操作类型',
				                        hiddenName:'opType',
				                        hiddenId:'opType',
				                        store: new Ext.data.SimpleStore({
				                            fields: ['abbr', 'state'],
				                            data : [['','请选择'],
				                            		['INSERT','新增'],
				                            		['UPDATE','修改'],
				                            		['DELETE','删除']]
				                        }),
				                        valueField:'abbr',
				                        displayField:'state',
				                        typeAhead: true,
				                        mode: 'local',
				                        triggerAction: 'all',
				                        selectOnFocus:true,
				                        emptyText:'请选择',
				                        width:160
				                    }),
				                new Ext.form.ComboBox({
				                		id:'comboStatus',
				                        fieldLabel: '状态',
				                        hiddenName:'status',
				                        hiddenId:'status',
				                        store: new Ext.data.SimpleStore({
				                            fields: ['abbr', 'state'],
				                            data : [['','请选择'],
				                            		['IN_NEW','（新增）创建'],
				                            		['IN_ADUIT_1','（新增）一级审核通过'],
				                            		['IN_ADUIT_2','（新增）二级审核通过'],
				                            		['IN_ADUIT_3','（新增）三级审核通过'],
				                            		['IN_ADUIT_1_N','（新增）一级审核不通过'],
				                            		['IN_ADUIT_2_N','（新增）二级审核不通过'],
				                            		['IN_ADUIT_3_N','（新增）三级审核不通过'],
				                            		['UPD_NEW','（修改）创建'],
				                            		['UPD_ADUIT_1','（修改）一级审核通过'],
				                            		['UPD_ADUIT_2','（修改）二级审核通过'],
				                            		['UPD_ADUIT_3','（修改）三级审核通过'],
				                            		['UPD_ADUIT_1_N','（修改）一级审核不通过'],
				                            		['UPD_ADUIT_2_N','（修改）二级审核不通过'],
				                            		['UPD_ADUIT_3_N','（修改）三级审核不通过'],
				                            		['OUT_NEW','（删除）创建'],
				                            		['OUT_ADUIT_1','（删除）一级审核通过'],
				                            		['OUT_ADUIT_2','（删除）二级审核通过'],
				                            		['OUT_ADUIT_3','（删除）三级审核通过'],
				                            		['OUT_ADUIT_1_N','（删除）一级审核不通过'],
				                            		['OUT_ADUIT_2_N','（删除）二级审核不通过'],
				                            		['OUT_ADUIT_3_N','（删除）三级审核不通过']]
				                        }),
				                        valueField:'abbr',
				                        displayField:'state',
				                        typeAhead: true,
				                        mode: 'local',
				                        triggerAction: 'all',
				                        selectOnFocus:true,
				                        emptyText:'请选择',
				                        width:160
				                    })
							]},
							{
							layout:'form',
							columnWidth:.30,
							items:[
								new Ext.form.ComboBox({
			                        fieldLabel: '地市',
			                        hiddenName:'cityStr',
			                        hiddenId:'cityStr',
			                        id:'comboQueryCityId',
			                        store: cityStore,
			                        valueField:'value',
			                        displayField:'text',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        width:125,
			                        selectOnFocus:true
			                    }),
								new Ext.form.TextField({fieldLabel:'地址',id:'areaStr'})
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
									title:'高校审核日志信息',
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
					//document.getElementById("cityStr").value = "";
					document.getElementById("areaStr").value = "";
					//document.getElementById("opType").value = "";
					//document.getElementById("status").value = "";
					document.getElementById("cName").value = "";
					document.getElementById("bName").value = "";
					Ext.getCmp('comboQueryCityId').setValue('');
					Ext.getCmp('comboOptype').setValue('');
					Ext.getCmp('comboStatus').setValue('');
				}
				
				function queryBur(){
					var cityStr = document.getElementById("cityStr").value;
					var areaStr = document.getElementById("areaStr").value;
					var opType = document.getElementById("opType").value;
					var status = document.getElementById("status").value;
					var cName = document.getElementById("cName").value;
					var bName = document.getElementById("bName").value;
					
					if("HB.00"!='<%=userCityId%>'){
						if(""==cityStr && cityStr.length==0){
							cityStr='<%=userCityId%>';
						}
						if('<%=userCityId%>'!=cityStr){
							Ext.MessageBox.show({
										title : '信息',
										msg : '您无权限查询其他地市信息!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							
							return false;
						}
					}
				
					bStore.baseParams={cityStr:encodeURI(cityStr),
						areaStr:encodeURI(areaStr),
						opType:encodeURI(opType),
						status:encodeURI(status),
						bName:encodeURI(bName),
						cName:encodeURI(cName)};
					bStore.load({
						params:{start:0,limit:itemsPerPage},
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