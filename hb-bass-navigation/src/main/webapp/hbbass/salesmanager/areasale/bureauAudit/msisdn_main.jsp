<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<html>
	<head>
		<title>号头待审批</title>
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
	    <%
			User user = (User) request.getSession().getAttribute("user");
			
			String op1=null;
			String op2=null;
			/* if (user == null) {
				user = new User();
			} */

			Connection conn = null;

			try {
				//判断当前登陆人权限
				String auditSql = "SELECT op1,op2 FROM ACCHEADER_AUDIT WHERE cityid = '"
						+ user.getCityId().trim() + "'";

				conn = ConnectionManage.getInstance().getWEBConnection();
				PreparedStatement ps = conn.prepareStatement(auditSql);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					op1=rs.getString(1);
					op2=rs.getString(2);
				}

				

				rs.close();
				ps.close();

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (conn != null)
					ConnectionManage.getInstance().releaseConnection(conn);
			}
			
			//2013-06-04新增加载页面就把新增的号头自动插入到HEADBRAND_AUDIT 表里面的功能
			String sql="select  distinct substr(HEADNBR,1,3)  HEADNBR from NWH.DIM_NBRHEAD where id =5 "+
 							" except"+
							" select nbhead from  mk.dim_headbrand_all";
			String insSql="insert into HEADBRAND_AUDIT(ID,STAFF,CREATE_TIME,NBHEAD) values(?,?,current timestamp,?)";
			Connection webConn=null;
			try{
				conn=ConnectionManage.getInstance().getDWConnection();
				webConn=ConnectionManage.getInstance().getWEBConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				PreparedStatement ps1=null;
				PreparedStatement ps2=null;
				PreparedStatement st=null;
				ResultSet rs = ps.executeQuery();
				String head=null;
				while(rs.next()){
					head=rs.getString(1);
					st=webConn.prepareStatement("select count(1) from HEADBRAND_AUDIT where nbhead='"+head+"'");
					ResultSet r=st.executeQuery();
					int cnt=0;
					int _id=0;
					if(r.next()){
						cnt=r.getInt(1);
					}
					if(cnt>0){
						continue;
					}else{
						ps2=webConn.prepareStatement("select max(id) from HEADBRAND_AUDIT with ur");
						ResultSet rr=ps2.executeQuery();
						rr.next();
						if(rr.getString(1)!=null){
							_id=Integer.parseInt(rr.getString(1))+1;
						}
						ps1=webConn.prepareStatement(insSql);
						ps1.setInt(1,_id);
						ps1.setString(2,"SYSTEM");
						ps1.setString(3,head);
						ps1.execute();
					}
				}
				
				if(ps1!=null)ps1.close();
				if(ps2!=null)ps2.close();
				if(st!=null)st.close();
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
			}catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (conn != null)
					ConnectionManage.getInstance().releaseConnection(conn);
				
				if (webConn != null)
					ConnectionManage.getInstance().releaseConnection(webConn);
			}
		%>
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
				
				var ispStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'key'
					}, {
						name : 'value'
					}
					])
				});
				var netStore = new Ext.data.Store({ 
					url: "${mvcPath}/jsonData/query",
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'root'
					}, [ {
						name : 'key'
					}, {
						name : 'value'
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
						,{header:"审批状态",dataIndex:"audit_flag",id:"col",width:150}
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
					
				var toolBarRe = new Ext.Toolbar([
					{text:'编辑',
						iconCls:'add',
						handler:function(){
							var selections = gridB.getSelectionModel().getSelections();
							if(selections.length == ''){
								Ext.MessageBox.show({
									title : '信息',
									msg : '请选中记录后再进行编辑操作！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								return;
							}
							if(selections.length>1){
								Ext.MessageBox.show({
									title : '信息',
									msg : '只能选取一条记录进行编辑！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								return;
							}
							win.show();
							Ext.getCmp("_id").setValue(selections[0].get('id'));
							Ext.getCmp("_nbheader").setValue(selections[0].get('nbhead'));
							comboISP.clearValue();
			                comboNet.clearValue();
			                var isp="select value key,value from ACCHEADER_PROP where type=1";
			                var net="select value key,value from ACCHEADER_PROP where type=2";
			                ispStore.load({params:{sql:isp,ds:WEB_DS,start:0,limit:10000}});
			                netStore.load({params:{sql:net,ds:WEB_DS,start:0,limit:10000}});
						}},
						'-',
					{text:'审核通过',
					iconCls:'option',
					handler:function(){
						var u='<%=user.getId()%>';
						var op1='<%=op1%>';
						var op2='<%=op2%>';
						
						
						if(u!=op1&&u!=op2){
							Ext.MessageBox.show({
								title : '信息',
								msg : '你无权进行审批操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
					
						var selections = gridB.getSelectionModel().getSelections();

						if(selections.length == ''){
							Ext.MessageBox.show({
								title : '信息',
								msg : '请选中待审核列表记录后再进行审核通过操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						if(selections.length >1){
							Ext.MessageBox.show({
								title : '信息',
								msg : '只能选择一条记录进行操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						if(selections[0].get("audit_flag")=="待编辑"){
							Ext.MessageBox.show({
								title : '信息',
								msg : '该记录目前无法进行审批操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						
						Ext.Msg.confirm('信息', '确认通过号头信息？',function(btn){
							if(btn == 'yes'){
								var mask = new Ext.LoadMask(Ext.getBody(), {
									msg : '正在处理数据，请稍候！',
									removeMask : true
								});
								var record=selections[0];
								var flag=record.get('audit_flag');
								var sql="";
								if(flag.indexOf("一")>-1){
									if(u!=op1){
										Ext.MessageBox.show({
											title : '信息',
											msg : '您不具备一级审批权限！',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										return;
									}
									sql="update HEADBRAND_AUDIT set audit_flag='audit2' where id="+record.get('id');
								}else{
									if(u!=op2){
										Ext.MessageBox.show({
											title : '信息',
											msg : '您不具备二级审批权限！',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										return;
									}
									//11	'移动GSM'
									var isp="";
									if(record.get('head_id').indexOf("移动")>-1){
										isp="移动";
									}else if(record.get('head_id').indexOf("联通")>-1){
										isp="联通";
									}else if(record.get('head_id').indexOf("电信")>-1){
										isp="电信";
									}else{
										isp="未知";
									}
									sql="insert into mk.DIM_HEADBRAND_ALL values('";
									sql+=record.get('nbhead')+"',"+ispMapping[isp]+",'"+record.get('head_id')+record.get('brand_name')+"')";								
								}
								mask.show();
								
								Ext.Ajax.request({
									url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
									method:"post",
									params:{sql:sql,ds:flag.indexOf("一")>-1?"web":"dw"},
									success:function(response,options){
										var result=response.responseText;
										var msg="";
										if(result=="-1"){
											msg="操作失败";
											Ext.MessageBox.show({
												title : '信息',
												msg : msg,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
										}else{
											msg="操作成功";
											if(!(flag.indexOf("一")>-1)){
												var sql1="update HEADBRAND_AUDIT set audit_flag='success' where id="+record.get('id');
												Ext.Ajax.request({
													url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
													method:"post",
													params:{sql:sql1,ds:"web"},
													success:function(response,options){
														if(response.responseText=="-1"){
															msg="操作失败";
														}
														Ext.MessageBox.show({
															title : '信息',
															msg : msg,
															buttons : Ext.Msg.OK,
															icon : Ext.MessageBox.INFO
														});
													}
												});
											}else{
												Ext.MessageBox.show({
															title : '信息',
															msg : msg,
															buttons : Ext.Msg.OK,
															icon : Ext.MessageBox.INFO
												});
											}
										}
									
										
										mask.hide();
										//win.hide();
										query();
									}
								});
							}else{
								return;
							}
						});
						
					}},
					'-',
					{text:'审核不通过',
					iconCls:'remove',
					handler:function(){
						var u='<%=user.getId()%>';
						var op1='<%=op1%>';
						var op2='<%=op2%>';
						if(u!=op1&&u!=op2){
							Ext.MessageBox.show({
								title : '信息',
								msg : '你无权进行审批操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
					
						var selections = gridB.getSelectionModel().getSelections();
						if(selections.length == ''){
							Ext.MessageBox.show({
								title : '信息',
								msg : '请选中待审核列表记录后再进行审核通过操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						if(selections.length >1){
							Ext.MessageBox.show({
								title : '信息',
								msg : '只能选择一条记录进行操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						if(selections[0].get("audit_flag")=="待编辑"){
							Ext.MessageBox.show({
								title : '信息',
								msg : '该记录目前无法进行审批操作！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return;
						}
						
						Ext.Msg.confirm('信息', '确认驳回号头信息？',function(btn){
							if(btn == 'yes'){
								var mask = new Ext.LoadMask(Ext.getBody(), {
									msg : '正在处理数据，请稍候！',
									removeMask : true
								});
								var record=selections[0];
								var flag=record.get('audit_flag');
								var sql="";
								if(flag.indexOf("一")>0){
									if(u!=op1){
										Ext.MessageBox.show({
											title : '信息',
											msg : '您不具备一级审批权限！',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										return;
									}
									sql="update HEADBRAND_AUDIT set audit_flag='fail' where id="+record.get('id');
								}else{
									if(u!=op2){
										Ext.MessageBox.show({
											title : '信息',
											msg : '您不具备二级审批权限！',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										return;
									}
									sql="update HEADBRAND_AUDIT set audit_flag='audit1' where id="+record.get('id');							
								}
								mask.show();
								
								Ext.Ajax.request({
									url:"${mvcPath}/hbirs/action/filemanage?method=ddlForWxcs",
									method:"post",
									params:{sql:sql,ds:"web"},
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
										//win.hide();
										query();
									}
								});
							}else{
								return;
							}
						});
						
					}}
				]);
				
				
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
									items:[toolBarRe,gridB]
								}]
						}
					]
				});
				
				function query(){
					var sql="select id,NBHEAD,HEAD_ID,BRAND_NAME,staff,create_time,";
					sql+="(case when audit_flag='audit1' then '待一级审批' when audit_flag='audit2' then '待二级审批' when audit_flag='success' then '审批成功' when audit_flag='fail' then '审批驳回' else '待编辑' end) as audit_flag";
					sql+=" from HEADBRAND_AUDIT  order by id desc";
					bStore.baseParams['sql']=sql;
					bStore.baseParams['ds'] = WEB_DS;
					bStore.load({
						params:{start:0,limit:itemsPerPage}
					});
				}
				query();
				function save(){
					var _id=document.getElementById("_id").value;
					var _nbheader=document.getElementById("_nbheader").value;
					var _isp=document.getElementById("_isp").value;
					var _net=document.getElementById("_net").value;
					var _staff='<%=user.getId()%>';
					
					if(_id == '' || _id == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '序号为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(_nbheader == '' || _nbheader == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '号头为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(_nbheader.length>3){
						Ext.MessageBox.show({
							title : '信息',
							msg : '号头长度大于3！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(_isp == '' || _isp == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '运营商为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					if(_net == '' || _net == null){
						Ext.MessageBox.show({
							title : '信息',
							msg : '网络制式为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
						return;
					}
					Ext.Msg.confirm('信息', '确认保存号头信息？',function(btn){
						if(btn == 'yes'){
							var mask = new Ext.LoadMask(Ext.getBody(), {
								msg : '正在处理数据，请稍候！',
								removeMask : true
							});
							mask.show();
							var sql="update HEADBRAND_AUDIT set head_id='"+_isp+"',brand_name='"+_net+"',audit_flag='audit1' where id="+_id;
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
				
				//新增页面
				var comboISP=new Ext.form.ComboBox({
			                        fieldLabel: '*运营商',
			                        hiddenName:'_isp',
			                        hiddenId:'_isp',
			                        id:'comboIsp',
			                        store: ispStore,
			                        valueField:'key',
			                        displayField:'value',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        selectOnFocus:true,
			                        editable:false,
			                        width:200,
			                        allowBlank:false
			                    });
			     var comboNet=new Ext.form.ComboBox({
			                        fieldLabel: '*网络制式',
			                        hiddenName:'_net',
			                        hiddenId:'_net',
			                        id:'comboNet',
			                        store:netStore,
			                        valueField:'key',
			                        displayField:'value',
			                        typeAhead: true,
			                        mode: 'local',
			                        triggerAction: 'all',
			                        emptyText:'请选择',
			                        selectOnFocus:true,
			                        editable:false,
			                        width:200,
			                        allowBlank:false
			                    });
				var formAdd = new Ext.form.FormPanel({
					labelAlign:'right',
					defaultType:'textfield',
					labelWidth:'200',
					frame:'true',
					autoHeight:true,
					id:'headAdd',
					border:false,
					items:[
						new Ext.form.TextField({fieldLabel:'*序号',id:'_id',width:100,allowBlank:false,disabled:true}),
						new Ext.form.NumberField({fieldLabel:'*号头',id:'_nbheader',width:100,allowBlank:false,maxLength:3,emptyText:'长度小于4'}),
						comboISP,
						comboNet
					],
					buttons:[new Ext.Button({text:'保存',handler:function(){save();}}),
					new Ext.Button({text:'返回',handler:function(){win.hide();}})]
				});
				
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
		            title: '号头新增',
		            closable:true,
		            width:400,
		            height:200,
		            modal:true,
		            closeAction:'hide',
		            border:false,
		            plain:true,
		            layout: 'border',
		            items: [nav]
		        });
		        
		        
			});
		</script>
	</head>
	<body>
	</body>
</html>