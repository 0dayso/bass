<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>高校信息查看</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript" 
			src="${mvcPath}/resources/js/default/des.js" charset=utf-8></script>
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

				var bStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'college_id'
					}, {
						name : 'college_name'
					}, {
						name : 'web_add'
					}, {
						name : 'college_type'
					}, {
						name : 'college_add'
					}, {
						name : 'short_number'
					}, {
						name : 'area_id'
					}, {
						name : 'manager'
					}, {
						name : 'students_num'
					}, {
						name : 'new_students'
					}, {
						name : 'state_date'
					}, {
						name : 'manager_nbr'
					}, {
						name : 'create_date'
					}, {
						name : 'operate_type'
					}, {
						name : 'status'
					}, {
						name : 'createuser'
					}
					])
				});
				var cityStore = new Ext.data.JsonStore({ 
					url:'${mvcPath}/hbirs/action/college?method=getCity'
					,fields:['value','text']
				});
				cityStore.load();
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,{header:"高校编码",dataIndex:"college_id"}
						,{header:"高校名称",dataIndex:"college_name"}
						,{header:"网址",dataIndex:"web_add"}
						,{header:"高校类型",dataIndex:"college_type"}
						,{header:"地址",dataIndex:"college_add"}
						,{header:"集团号",dataIndex:"short_number",width:50}
						,{header:"地市",dataIndex:"area_id",width:50}
						,{header:"联系人",dataIndex:"manager",width:50}
						,{header:"在校学生数",dataIndex:"students_num",width:50}
						,{header:"新生人数/年",dataIndex:"new_students",width:50}
						,{header:"状态更新时间",dataIndex:"state_date"}
						,{header:"联系人电话",dataIndex:"manager_nbr",width:50}
						,{header:"创建日期",dataIndex:"create_date"}
						,{header:"操作类型",dataIndex:"operate_type",width:50}
						,{header:"状态",dataIndex:"status"}
						,{header:"创建人",dataIndex:"createuser",id:"col"}]);
						
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
						title:'高校信息查询条件',
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
				                        width:140
				                    }),
				                new Ext.form.ComboBox({
				                		id:'comboStatus',
				                        fieldLabel: '状态',
				                        hiddenName:'status',
				                        hiddenId:'status',
				                        store: new Ext.data.SimpleStore({
				                            fields: ['abbr', 'state'],
				                            data : [['','请选择'],
				                            		['SUC','已生效'],
				                            		['IN_ADUIT_1','(新增)待一级审核'],
				                            		['IN_ADUIT_2','(新增)待二级审核'],
				                            		['IN_ADUIT_3','(新增)待三级审核'],
				                            		['UPD_ADUIT_0','(修改)一级审批不通过'],
				                            		['UPD_ADUIT_1','(修改)待一级审核'],
				                            		['UPD_ADUIT_2','(修改)待二级审核'],
				                            		['UPD_ADUIT_3','(修改)待三级审核'],
				                            		['OUT_ADUIT_0','(删除)一级审批不通过'],
				                            		['OUT_ADUIT_1','(删除)待一级审核'],
				                            		['OUT_ADUIT_2','(删除)待二级审核'],
				                            		['OUT_ADUIT_3','(删除)待三级审核']]
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
									title:'高校信息',
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
				
					var sql="select COLLEGE_ID, COLLEGE_NAME, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD, ";
					sql+="SHORT_NUMBER,AREA_ID, MANAGER, STUDENTS_NUM,NEW_STUDENTS,STATE_DATE, MANAGER_NBR, CREATE_DATE,";
					sql+="(case when OPERATE_TYPE = 'INSERT' then '新增' when OPERATE_TYPE = 'UPDATE' then '修改' ELSE '删除' END) as OPERATE_TYPE ,";
					sql+="(case when STATUS = 'OUT_ADUIT_0' then '(删除)一级审批不通过' when STATUS = 'UPD_ADUIT_0' then '(修改)一级审批不通过'  when STATUS = 'SUC' then '已生效' when STATUS = 'IN_ADUIT_1' then '（新增）待一级审核' when STATUS = 'IN_ADUIT_2' then '（新增）待二级审核' when STATUS = 'IN_ADUIT_3' then '（新增）待三级审核' when STATUS = 'OUT_ADUIT_1' then '（删除）待一级审核' when STATUS = 'OUT_ADUIT_2' then '（删除）待二级审核' when STATUS = 'OUT_ADUIT_3' then '（删除）待三级审核' when STATUS = 'UPD_ADUIT_1' then '（修改）待一级审核' when STATUS = 'UPD_ADUIT_2' then '（修改）待二级审核' when STATUS = 'UPD_ADUIT_3' then '（修改）待三级审核' ELSE '' END) as STATUS,";
					sql+="CREATEUSER,";
					sql+="(select cc.AREA_NAME from mk.bt_area cc where cc.AREA_CODE = bb.AREA_ID) from COLLEGE_INFO_PT bb where STATE=1 AND STATUS <> 'FAL'";
					if("HB.00"!='<%=userCityId%>'){
						if(""==cityStr && cityStr.length==0){
							cityStr='<%=userCityId%>';
							sql+=" and ucase(AREA_ID) like '%" + cityStr + "%' ";
						}
						if('<%=userCityId%>'!=cityStr){
							Ext.MessageBox.show({
										title : '信息',
										msg : '您无权限查询其他地市信息!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							
							return false;
						}else{
							sql+=" and ucase(AREA_ID) like '%" + cityStr + "%' ";
						}
					}else{
						if(""!= cityStr && cityStr.length>0){
							sql+=" and ucase(AREA_ID) like '%" + cityStr + "%' ";
						}
					}
					if(""!= areaStr && areaStr.length>0){
						sql+=" and ucase(COLLEGE_ADD) like '%" + areaStr + "%' ";
					}
					if(""!=opType && opType.length>0){
						sql+=" and ucase(OPERATE_TYPE) like '" + opType + "' ";
					}
					if(""!=status && status.length>0){
						sql+=" and ucase(STATUS) like '" + status + "' ";
					}
					if(""!=cName && cName.length>0){
						sql+=" and ucase(COLLEGE_NAME) like '%" + cName + "%' ";
					}
					if(""!=bName && bName.length>0){
						sql+="  and ucase(COLLEGE_ID) like '%"+bName.toUpperCase()+"%' ";
					}
					
					bStore.baseParams['sql']=strEncode(sql);
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
			});
			
		</script>
	</head>
	<body>
	</body>
</html>