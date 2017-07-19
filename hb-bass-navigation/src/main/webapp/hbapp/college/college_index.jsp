<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.*"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>高校信息维护</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript" 
			src="${mvcPath}/resources/js/default/des.js" charset=utf-8></script>
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

			Connection conn = null;
			String userCityId="HB.00";
			try {
				//判断当前登陆人权限
				String auditSql = "SELECT region_id from FPF_USER_USER where userid='"+session.getAttribute("loginname")+"'";

				conn = ConnectionManage.getInstance().getWEBConnection();
				PreparedStatement ps = conn.prepareStatement(auditSql);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					String region_id=rs.getString(1);
					if(null!=region_id&&!"".equals(region_id)){
						userCityId=region_id.equals("HB")?"HB.00":region_id;
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
				var userCityId = '<%=userCityId%>';
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
				
				var smb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
					
				var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,smb
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
				var cCodeStore = new Ext.data.Store({ 
					reader : new Ext.data.JsonReader({
					
						root : 'root'
					}, [ {
						name : 'collegeCode'
					}]),
					url: "${mvcPath}/hbirs/action/college?method=queryCollegeCode"
				});
				var cityStore = new Ext.data.JsonStore({ 
					url:'${mvcPath}/hbirs/action/college?method=getCity'
					,fields:['value','text']
				});
				cityStore.load();
				var toolBarRe = new Ext.Toolbar([
					{text:'新增',
					iconCls:'add',
					handler:function(){
						if(userCityId=="HB.00"){
							Ext.MessageBox.show({
										title : '信息',
										msg : '省级操作员不能新增高校信息!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return false;
						}
						win.show();
						Ext.getCmp('comboUserCityId').setValue(userCityId);
						var sql="select max(COLLEGE_ID) from COLLEGE_INFO_PT where STATUS <> 'FAL' AND STATE = 1 AND AREA_ID = '"+userCityId+"' with ur";
						cCodeStore.load({
							params:{sql:strEncode(sql),ds:DW_DS,areaCode:userCityId},
							callback :function(){
								document.getElementById("cCode").value = cCodeStore.getAt(0).data['collegeCode'];		
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
					handler:function(){deleteCollege();}}
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
				
				
				
				var formAdd = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					id:'collegeAdd',
					border:false,
					items:[
						new Ext.form.ComboBox({
			                        fieldLabel: '*地&nbsp;市',
			                        hiddenName:'cArea',
			                        hiddenId:'cArea',
			                        id:'comboUserCityId',
			                        store: cityStore,
			                        valueField:'value',
			                        displayField:'text',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        selectOnFocus:true,
			                        readOnly:true,
			                        width:150,
			                        allowBlank:false,
			                        disabled :true,
			                        listeners: {
			                        	select:function(comboBox){
			                        		//document.getElementById("cCode").value = comboBox.getValue()+".C";
			                        		cCodeStore.load({
												params:{areaCode:comboBox.getValue()},
												callback :function(){
													document.getElementById("cCode").value = cCodeStore.getAt(0).data['collegeCode'];		
												}
											});
			                        	}
			                        }
			                    }),
						new Ext.form.TextField({fieldLabel:'*高校名称',id:'cCollegeName',width:300,allowBlank:false}),
						new Ext.form.TextField({fieldLabel:'*高校编码',id:'cCode',width:300,allowBlank:false,maxLength:11,minLength:11,disabled :true}),
						new Ext.form.TextField({fieldLabel:'网&nbsp;址',id:'cWeb',width:300,vtype:'url'}),
						new Ext.form.ComboBox({
			                        fieldLabel: '*高校类型',
			                        hiddenName:'cType',
			                        hiddenId:'cType',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [['本科','本科'],
			                            		['部署高校','部署高校'],
			                            		['二级学院','二级学院'],
			                            		['高职','高职'],
			                            		['高职高专','高职高专'],
			                            		['省属重点','省属重点'],
			                            		['中职中专','中职中专'],
			                            		['其他','其他']]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        selectOnFocus:true,
			                        readOnly:true,
			                        width:150,
			                        allowBlank:false
			                    }),
						new Ext.form.TextField({fieldLabel:'地&nbsp;址',id:'cAdd',width:300}),
						new Ext.form.TextField({fieldLabel:'在校学生数',id:'cStus',width:300,vtype:'alphanum'}),
						new Ext.form.TextField({fieldLabel:'新生人数/年',id:'cStusNew',width:300,vtype:'alphanum'}),
						new Ext.form.TextField({fieldLabel:'联系人',id:'cMan',width:300}),
						new Ext.form.TextField({fieldLabel:'联系人电话',id:'cManNbr',width:300}),
						new Ext.form.TextField({fieldLabel:'集团号',id:'cShortNum',width:300})
						
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){saveCollege();}}),
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
									title:'高校信息维护',
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
					var status = Ext.getCmp('comboStatus').getValue();
					var cName = document.getElementById("cName").value;
					var bName = document.getElementById("bName").value;
					
					var sql="select COLLEGE_ID, COLLEGE_NAME, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD, ";
					sql+="SHORT_NUMBER,AREA_ID, MANAGER, STUDENTS_NUM,NEW_STUDENTS,STATE_DATE, MANAGER_NBR, CREATE_DATE,";
					sql+="(case when OPERATE_TYPE = 'INSERT' then '新增' when OPERATE_TYPE = 'UPDATE' then '修改' ELSE '删除' END) as OPERATE_TYPE ,";
					sql+="(case when STATUS = 'OUT_ADUIT_0' then '(删除)一级审批不通过' when STATUS = 'UPD_ADUIT_0' then '(修改)一级审批不通过' when STATUS = 'SUC' then '已生效' when STATUS = 'IN_ADUIT_1' then '（新增）待一级审核' when STATUS = 'IN_ADUIT_2' then '（新增）待二级审核' when STATUS = 'IN_ADUIT_3' then '（新增）待三级审核' when STATUS = 'OUT_ADUIT_1' then '（删除）待一级审核' when STATUS = 'OUT_ADUIT_2' then '（删除）待二级审核' when STATUS = 'OUT_ADUIT_3' then '（删除）待三级审核' when STATUS = 'UPD_ADUIT_1' then '（修改）待一级审核' when STATUS = 'UPD_ADUIT_2' then '（修改）待二级审核' when STATUS = 'UPD_ADUIT_3' then '（修改）待三级审核' ELSE '' END) as STATUS,";
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
				
				function saveCollege(){
					var cArea = document.getElementById("cArea").value;
					var cCollegeName = document.getElementById("cCollegeName").value;
					var cCode = document.getElementById("cCode").value;
					var cWeb = document.getElementById("cWeb").value;
					var cType = document.getElementById("cType").value;
					var cAdd = document.getElementById("cAdd").value;
					var cStus = document.getElementById("cStus").value;
					var cStusNew = document.getElementById("cStusNew").value;
					var cMan = document.getElementById("cMan").value;
					var cManNbr = document.getElementById("cManNbr").value;
					var cShortNum = document.getElementById("cShortNum").value;
				
					if(cArea == '' || cArea == null || cArea == 'HB.00'){
						//alert('请选择高校所属地市！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选择高校所属地市！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cCollegeName == '' || cCollegeName == null){
						//alert('请输入高校名称！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请输入高校名称！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cCode == '' || cCode == null || cCode.length != 11){
						//alert('请填写正确的高校编码！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请填写正确的高校编码！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cType == '' || cType == null){
						//alert('请选择高校类型！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选择高校类型！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cStus == '' || cStus == null){
						cStus = 0;
					}
					if(cStusNew == '' || cStusNew == null){
						cStusNew = 0;
					}
					//if(!confirm("确认保存新增高校信息？")){
					//	return;
					//}
					Ext.Msg.confirm('信息', '确认保存新增高校信息？',function(btn){
						if(btn == 'yes'){
							var mask = new Ext.LoadMask(Ext.getBody(), {
								msg : '正在处理数据，请稍候！',
								removeMask : true
							});
							mask.show();
							var paramsInsert = "'"+cArea+"','"+cCollegeName+"','"+cCode+"','"+cWeb+"','"+cType+"','"+cAdd+"',"+cStus
							+","+cStusNew+",'"+cMan+"','"+cManNbr+"','"+cShortNum+"'";
							cInsertStore.load({
							params:{optype:'insert',paramsInsert:encodeURI(paramsInsert)},
							callback :function(){
								var msg = cInsertStore.getAt(0).data['msg'];
								var count = cInsertStore.getAt(0).data['count'];
								Ext.MessageBox.show({
									title : '信息',
									msg : msg,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
								mask.hide();
							}
						});
						}else{
							return;
						}
					});
				}
				
				
				function updateCollege(){
					var cArea = document.getElementById("cAreaU").value;
					var cCollegeName = document.getElementById("cCollegeNameU").value;
					var cCode = document.getElementById("cCodeU").value;
					var cWeb = document.getElementById("cWebU").value;
					var cType = document.getElementById("cTypeU").value;
					var cAdd = document.getElementById("cAddU").value;
					var cStus = document.getElementById("cStusU").value;
					var cStusNew = document.getElementById("cStusNewU").value;
					var cMan = document.getElementById("cManU").value;
					var cManNbr = document.getElementById("cManNbrU").value;
					var cShortNum = document.getElementById("cShortNumU").value;
				
					if(cArea == '' || cArea == null){
						//alert('请选择高校所属地市！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选择高校所属地市！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cCollegeName == '' || cCollegeName == null){
						//alert('请输入高校名称！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请输入高校名称！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cCode == '' || cCode == null || cCode.length != 11){
						//alert('请填写正确的高校编码！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请填写正确的高校编码！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cType == '' || cType == null){
						//alert('请选择高校类型！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选择高校类型！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(cStus == '' || cStus == null){
						cStus = 0;
					}
					if(cStusNew == '' || cStusNew == null){
						cStusNew = 0;
					}
					//if(!confirm("确认保存修改高校信息？")){
					//	return;
					//}
					Ext.Msg.confirm('信息', '确认保存修改高校信息？', function(btn) {
					
						if(btn=='yes'){
							var mask = new Ext.LoadMask(Ext.getBody(), {
								msg : '正在加载数据，请稍候！',
								removeMask : true
							});
							mask.show();
							var paramsUpdate = "COLLEGE_NAME='"+cCollegeName+"',WEB_ADD='"+cWeb+"',COLLEGE_TYPE='"+cType
							+"',COLLEGE_ADD='"+cAdd+"',STUDENTS_NUM="+cStus
							+",NEW_STUDENTS="+cStusNew+",MANAGER='"+cMan+"',MANAGER_NBR='"+cManNbr+"',SHORT_NUMBER='"+cShortNum+"'";
						
							cInsertStore.load({
								params:{optype:'update',paramsUpdate:encodeURI(paramsUpdate),collegeCode:encodeURI(cCode)},
								callback :function(){
									var msg = cInsertStore.getAt(0).data['msg'];
									var count = cInsertStore.getAt(0).data['count'];		
									Ext.MessageBox.show({
										title : '信息',
										msg : msg,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});
									mask.hide();
								}
							});
						}else{
							return;
						}
					});
					
				}
				
				var cInsertStore = new Ext.data.JsonStore({ 
					url: "${mvcPath}/hbirs/action/college?method=serviceDB",
					fields:['count','msg'],
					root:'Info'
				});
				
				function deleteCollege(){
					var selections = gridB.getSelectionModel().getSelections();
						if(selections.length == ''){
							//alert('请选中高校列表记录后再进行删除操作！');
							Ext.MessageBox.show({
								title : '信息',
								msg : '请选中高校列表记录后再进行删除操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						for(var i = 0;i < selections.length;i++){
							var record = selections[i];
							var status=record.get('status');
						
							if(status!='已生效'&&status!='(删除)一级审批不通过'&&status!='(修改)一级审批不通过'){
								//alert('请确定选中高校列表记录状态为已生效！');
								Ext.MessageBox.show({
									title : '信息',
									msg : '请确定选中高校列表记录状态为已生效或审批不通过！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								return;
							}
						}
						//if(!confirm("确认删除高校信息？")){
						//	return;
						//}
						Ext.Msg.confirm('信息', '确定要删除高校信息？', function(btn){
							if(btn=='yes'){
								var mask = new Ext.LoadMask(Ext.getBody(), {
									msg : '正在加载数据，请稍候！',
									removeMask : true
								});
								mask.show();
								var deleteCode = '';
								var collegeName='';
								for(var i = 0;i < selections.length;i++){
									var record = selections[i];
									if(i == 0){
										deleteCode += "'"+record.get('college_id')+"'";
										collegeName +="'"+record.get('college_name')+"'";
									}else{
										deleteCode += ",'"+record.get('college_id')+"'";
										collegeName +=",'"+record.get('college_name')+"'";
									}
								}
								cInsertStore.reload({
									params:{optype:'delete',deleteCode:deleteCode,collegeName:collegeName},
									callback :function(){
										var msg = cInsertStore.getAt(0).data['msg'];
										var count = cInsertStore.getAt(0).data['count'];
										Ext.MessageBox.show({
											title : '信息',
											msg : msg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn:function(btn){
												if(count == '0'){
													queryBur();
												}
											}
										});
										mask.hide();
									}
								});
							}else{
								return;
							}
						});
						
						
				}
				
				
				function doUpdate(){
					var selections = gridB.getSelectionModel().getSelections();
					if(selections.length == ''){
						//alert('请选中高校列表记录后再进行修改操作！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '请选中高校列表记录后再进行修改操作！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(selections.length > 1){
						//alert('只能选中一条高校列表记录进行修改操作！');
						Ext.MessageBox.show({
							title : '信息',
							msg : '只能选中一条高校列表记录进行修改操作！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					for(var i = 0;i < selections.length;i++){
						var record = selections[i];
						var status=record.get('status');
						
						if(status!='已生效'&&status!='(删除)一级审批不通过'&&status!='(修改)一级审批不通过'){
							//alert('请确定选中高校列表记录状态为已生效！');
							Ext.MessageBox.show({
								title : '信息',
								msg : '请确定选中高校列表记录状态为已生效或审批不通过！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
					}
					var record = selections[0];
							
					winU.show();
					
					//document.getElementById("cAreaU").value = record.get('AREA_ID');
					document.getElementById("cCollegeNameU").value = record.get('college_name');
					document.getElementById("cCodeU").value = record.get('college_id');
					document.getElementById("cWebU").value = record.get('web_add');
					//document.getElementById("cTypeU").value = record.get('COLLEGE_TYPE');
					document.getElementById("cAddU").value = record.get('college_add');
					document.getElementById("cStusU").value = record.get('students_num');
					document.getElementById("cStusNewU").value = record.get('new_students');
					document.getElementById("cManU").value = record.get('manager');
					document.getElementById("cManNbrU").value = record.get('manager_nbr');
					document.getElementById("cShortNumU").value = record.get('short_number');
					
					if(record.get('college_type')==null || record.get('college_type') =='null' || record.get('college_type') =='[Null]'){
						Ext.getCmp('comboCtypeU').setValue('其他');
					}else{
						Ext.getCmp('comboCtypeU').setValue(record.get('college_type'));
					}
					Ext.getCmp('comboCareaU').setValue(record.get('area_id'));
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
		            title: '高校信息新增',
		            closable:true,
		            width:500,
		            height:380,
		            modal:true,
		            closeAction:'hide',
		            //border:false,
		            plain:true,
		            layout: 'border',
		            items: [nav]
		        });
				var formAddu = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					border:false,
					items:[
						new Ext.form.TextField({fieldLabel:'集团号',id:'cShortNum',width:300})
					]
				});
				
				var formAddU = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					border:false,
					items:[
						new Ext.form.ComboBox({
									id:'comboCareaU',
			                        fieldLabel: '*地&nbsp;市',
			                        hiddenName:'cAreaU',
			                        hiddenId:'cAreaU',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [['HB.WH','武汉'],
			                            		['HB.HG','黄冈'],
			                            		['HB.EZ','鄂州'],
			                            		['HB.XG','孝感'],
			                            		['HB.YC','宜昌'],
			                            		['HB.XN','咸宁'],
			                            		['HB.XF','襄阳'],
			                            		['HB.JZ','荆州'],
			                            		['HB.SZ','随州'],
			                            		['HB.ES','恩施'],
			                            		['HB.JH','江汉'],
			                            		['HB.HS','黄石'],
			                            		['HB.SY','十堰'],
			                            		['HB.JM','荆门']]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        selectOnFocus:true,
			                        readOnly:true,
			                        width:150,
			                        allowBlank:false,
			                        disabled :true
			                    }),
						new Ext.form.TextField({fieldLabel:'*高校名称',id:'cCollegeNameU',width:300,allowBlank:false}),
						new Ext.form.TextField({fieldLabel:'*高校编码',id:'cCodeU',width:300,allowBlank:false,maxLength:11,minLength:11,disabled:true}),
						new Ext.form.TextField({fieldLabel:'网&nbsp;址',id:'cWebU',width:300,vtype:'url'}),
						new Ext.form.ComboBox({
									id:'comboCtypeU',
			                        fieldLabel: '*高校类型',
			                        hiddenName:'cTypeU',
			                        hiddenId:'cTypeU',
			                        store: new Ext.data.SimpleStore({
			                            fields: ['abbr', 'state'],
			                            data : [['本科','本科'],
			                            		['部署高校','部署高校'],
			                            		['二级学院','二级学院'],
			                            		['高职','高职'],
			                            		['高职高专','高职高专'],
			                            		['省属重点','省属重点'],
			                            		['中职中专','中职中专'],
			                            		['其他','其他']]
			                        }),
			                        valueField:'abbr',
			                        displayField:'state',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        selectOnFocus:true,
			                        width:150,
			                        allowBlank:false
			                    }),
						new Ext.form.TextField({fieldLabel:'地&nbsp;址',id:'cAddU',width:300}),
						new Ext.form.TextField({fieldLabel:'在校学生数',id:'cStusU',width:300,vtype:'alphanum'}),
						new Ext.form.TextField({fieldLabel:'新生人数/年',id:'cStusNewU',width:300,vtype:'alphanum'}),
						new Ext.form.TextField({fieldLabel:'联系人',id:'cManU',width:300}),
						new Ext.form.TextField({fieldLabel:'联系人电话',id:'cManNbrU',width:300}),
						new Ext.form.TextField({fieldLabel:'集团号',id:'cShortNumU',width:300})
						
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){updateCollege();}}),
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
		            items:[formAddU]
		        });
		
		        var winU = new Ext.Window({
		            title: '高校信息修改',
		            closable:true,
		            width:500,
		            height:380,
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