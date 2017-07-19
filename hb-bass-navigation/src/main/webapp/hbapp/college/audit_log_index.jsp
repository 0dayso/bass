<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>高校基站审核日志</title>
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
			User user = (User) request.getSession().getAttribute("user");

		/* 	if (user == null) {
				user = new User();
			} */

			Connection conn = null;

			try {
				//判断当前登陆人权限
				String auditSql = "SELECT VALUE(AREA_CODE,'') FROM mk.bt_area AREA WHERE TRIM(CHAR(AREA.AREA_ID)) = '"
						+ user.getCityId().trim() + "'";

				conn = ConnectionManage.getInstance().getWEBConnection();
				PreparedStatement ps = conn.prepareStatement(auditSql);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					user.setRegionId(rs.getString(1));
				}

				if (user.getRegionId() == null || "".equals(user.getRegionId())||user.getRegionId().length() < 5) {
					user.setRegionId("HB.00");
				}

				rs.close();
				ps.close();

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (conn != null)
					ConnectionManage.getInstance().releaseConnection(conn);
			}
			String userCityId = user.getRegionId().substring(0, 5);
			
			
		%>
		<script type="text/javascript">
			
			Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
			Ext.onReady(function() {
			
				var bStore = new Ext.data.JsonStore({ 
					url: "${mvcPath}/hbapp/college/audit_log_info.jsp",
					baseParams:{cityStr:encodeURI(''),
						areaStr:encodeURI(''),
						opType:encodeURI(''),
						status:encodeURI(''),
						bName:encodeURI(''),
						cName:encodeURI('')},
					totalProperty:'Total',
					fields:['BUREAU_ID','BUREAU_NAME','COLLEGE','AREA_NAME','DEPT_NAME','COLLEGE_ID','CREATE_DATE','OPERATE_TYPE_STR','STATUS_STR','STATE_DATE','CREATEUSER','OPERATE_TYPE','STATUS'],
					root:'Info'
				});
				var cityStore = new Ext.data.JsonStore({ 
					url:'${mvcPath}/hbirs/action/college?method=getCity'
					,fields:['value','text']
				});
				cityStore.load();	
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,{header:"地市",dataIndex:"AREA_NAME"}
						,{header:"县域",dataIndex:"DEPT_NAME"}
						,{header:"基站编码",dataIndex:"BUREAU_ID"}
						,{header:"基站名称",dataIndex:"BUREAU_NAME"}
						,{header:"高校编码",dataIndex:"COLLEGE_ID"}
						,{header:"高校名称",dataIndex:"COLLEGE",width:150}
						,{header:"类型",dataIndex:"OPERATE_TYPE_STR"}
						,{header:"创建时间",dataIndex:"CREATE_DATE"}
						,{header:"动作",dataIndex:"STATUS_STR",width:150}
						,{header:"操作时间",dataIndex:"STATE_DATE"}
						,{header:"操作人",dataIndex:"CREATEUSER",id:"col"}]);
						
				var gridB = new Ext.grid.GridPanel({
					id:'gridC',
					ds:bStore,
					height:500,
					split: true,
					border:false,
					autoScroll: true,
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
								new Ext.form.TextField({fieldLabel:'县域',id:'areaStr'})
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
								new Ext.form.TextField({fieldLabel:'高校名称',id:'cName'}),
								new Ext.form.TextField({fieldLabel:'基站名称',id:'bName'})
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
									title:'高校与基站绑定审核日志信息',
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
					//document.getElementById("opType").value = "";
					//document.getElementById("status").value = "";
					document.getElementById("cName").value = "";
					document.getElementById("bName").value = "";
					
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
				
					bStore.baseParams={cityStr:encodeURI(cityStr),
						areaStr:encodeURI(areaStr),
						opType:encodeURI(opType),
						status:encodeURI(status),
						bName:encodeURI(bName),
						cName:encodeURI(cName)};
					bStore.load({
						params:{start:0,limit:10},
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