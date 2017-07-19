<%@ page contentType="text/html; charset=utf-8"%>
<html>
	<head>
		<title>高校基站维护</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
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
				var bureauTemp = '';
				var collegeCodeTemp = '';
				var collegeNameTemp = '';

				var opTypeStore = new Ext.data.JsonStore({ 
					url: "${mvcPath}/hbapp/college/optype.jsp",
					fields:['count','msg'],
					root:'Info'
				});
				
				var bureauStore = new Ext.data.JsonStore({ 
					url: "${mvcPath}/hbapp/college/bureauinfo.jsp",
					baseParams:{bureauTemp:encodeURI(bureauTemp),
						s_area_id:'1.2',
						s_zone_id:'1.2',
						s_town_id:'1.2',
						bureau_name:'1.2'},
					totalProperty:'Total',
					fields:['c1','c2','c3','c23','c4','c0_1','c0_2','c5','c6','c7','c8','c9','c10','c11','c12','c13','c14','c15','c16'],
					root:'Info'
				});
				
				var bStore = new Ext.data.JsonStore({ 
					url: "${mvcPath}/hbapp/college/college_re_info.jsp",
					baseParams:{collegeCode:'1.2.3'},
					totalProperty:'Total',
					fields:['bCode','bName','cCode','cName','status','opType','stDate','opUser'],
					root:'Info'
				});
			
				Ext.BLANK_IMAGE_URL = "${mvcPath}/hbapp/resources/js/ext/resources/images/default/s.gif";

				//全省高校树
				var treeGX = new Ext.tree.TreePanel({
					id: "tree-gx",
					title: "全省高校树",
					region: 'west',
					width:230,
					split: true,
					containerScroll: true,
					collapseMode: 'mini',
					collapsible: true,
					autoScroll: true,
					useArrows: true,
					animate: true,
					border: true,
					rootVisible: false,
					root: new Ext.tree.AsyncTreeNode({
						text: '湖北 [双击查看明细]',
				        draggable:false,
				        iconCls:'x-tree-node-icon3',
				        id:'-1'
					}),
					loader: new Ext.tree.TreeLoader({
						dataUrl:'${mvcPath}/hbirs/action/areaSaleManage?method=AreanodesByRegionId'
					}),
					listeners: {
						click: function(node, e) {
							var collegeCode = node.attributes.url;
							collegeCodeTemp = collegeCode;
							collegeNameTemp = node.attributes.text;
							if(collegeCode != null && collegeCode != '' && collegeCode.length > 6){
								/*cStore.load({
									params:{collegeCode:collegeCode},
									callback :function(){   
										document.getElementById("cName").value = cStore.getAt(0).data['cName'];	
										document.getElementById("cCode").value = cStore.getAt(0).data['cCode'];
										document.getElementById("cType").value = cStore.getAt(0).data['cType'];
										document.getElementById("cAdd").value = cStore.getAt(0).data['cAdd'];
									}
								});*/
								bStore.baseParams = {collegeCode:collegeCode};
								bStore.load({
									params:{start:0,limit:15},
									callback :function(){   
									}
								});
							}
						}
					}
				});
				
				//全省基站树
				var treeJZ = new Ext.tree.TreePanel({
					id: "tree-jz",
					title: "全省基站树",
					region: 'east',
					width:200,
					split: true,
					collapseMode: 'mini',
					collapsible: true,
					containerScroll: true,
					autoScroll: true,
					useArrows: true,
					animate: true,
					border: true,
					rootVisible: false,
					enableDD: true,
					root: new Ext.tree.AsyncTreeNode({
						text: '湖北 [双击查看明细]',
				        draggable:false,
				        iconCls:'x-tree-node-icon3',
				        id:'-1'
					}),
					loader: new Ext.tree.TreeLoader({
						dataUrl:'${mvcPath}/hbirs/action/areaSaleManage?method=nodesByRegionId'
					}),
					listeners: {
						click: function(node, e) {
							bureauTemp = node.attributes.url;
							//alert(document.getElementById("bShow").click());
						}
					}
				});
				
				var smc = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
				var smb = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
				
				var cm = new Ext.grid.ColumnModel([
						new Ext.grid.RowNumberer(),
						smc,
						{header:'高校编码',dataIndex:'cCode'},
						{header:'高校名称',dataIndex:'cName'},
						{header:'基站编码',dataIndex:'bCode'},
						{header:'基站名称',dataIndex:'bName'},
						{header:'状态',dataIndex:'status'},
						{header:'状态更新时间',dataIndex:'stDate',type:'date',dateFormat:'Y-m-dTH:i:s'},
						{header:'操作类型',dataIndex:'opType'},
						{id:'status',header:'操作人',dataIndex:'opUser'}
					]);
					
				var cmBr = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
						,smb
						,{header:"地市",dataIndex:"c1",width:50}
						,{header:"县域",dataIndex:"c2",width:50}
						,{header:"区域营销中心",dataIndex:"c3"}
						,{header:"区域营销中心代码",dataIndex:"c23"}
						,{header:"镇",dataIndex:"c4",width:50}
						,{header:"基站名称",dataIndex:"c0_2"}
						,{header:"基站编码",dataIndex:"c0_1"}
						,{header:"lac码十进制",dataIndex:"c5",width:80}
						,{header:"cell码十进制",dataIndex:"c6",width:80}
						,{header:"生效日期",dataIndex:"c7"}
						,{header:"覆盖类别",dataIndex:"c8",id:"c0_1"}]);
						/*,{header:"村村通小区",dataIndex:"c9"}
						,{header:"商业区",dataIndex:"c10"}
						,{header:"星级酒店",dataIndex:"c11"}
						,{header:"高级写字楼",dataIndex:"c12"}
						,{header:"居民小区",dataIndex:"c13"}
						,{header:"地形",dataIndex:"c14"}
						,{header:"营业厅名称",dataIndex:"c15"}
						,{header:"创建日期",dataIndex:"c16",id:"c16"}*/
						
				var gridC = new Ext.grid.GridPanel({
					id:'gridC',
					ds:bStore,
					height:470,
					split: true,
					border:false,
					autoScroll: true,
					cm:cm,
					sm:smc,
					autoExpandColumn:'status',
					loadMask: true,
					tbar:new Ext.PagingToolbar({
						pageSize:20,
						store:bStore,
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'没有记录'
					})
				});
					
				var gridB = new Ext.grid.GridPanel({
					id:'gridB',
					ds:bureauStore,
					cm:cmBr,
					sm:smb,
					border:false,
					split: true,
					height:370,
					autoScroll: true,
					autoExpandColumn:'c0_1',
					loadMask: true,
					tbar:new Ext.PagingToolbar({
						pageSize:9,
						store:bureauStore,
						displayInfo:true,
						displayMsg:'显示第{0}条到{1}条记录，一共{2}条记录',
						emptyMsg:'没有记录'
					})
				 });
					
				var toolBarRe = new Ext.Toolbar([{
					text:'删除',
					iconCls:'remove',
					handler:function(){
						var selections = gridC.getSelectionModel().getSelections();
						if(selections.length == ''){
							alert('请选中高校基站关系列表记录后再进行新增操作！');
							return;
						}
						for(var i = 0;i < selections.length;i++){
							var record = selections[i];
							if(record.get('status')!='已绑定'){
								alert('请确定选中高校基站关系列表记录状态为已绑定！');
								return;
							}
						}
						if(!confirm("确认删除高校与基站绑定？")){
							return;
						}
						
						var deleteCode = '';
						var cCodeTemp = '';
						for(var i = 0;i < selections.length;i++){
							var record = selections[i];
							cCodeTemp = record.get('cCode');
							if(i == 0){
								deleteCode += "'"+record.get('bCode')+"'";
							}else{
								deleteCode += ",'"+record.get('bCode')+"'";
							}
						}
						opTypeStore.reload({
							params:{optype:'delete',collegeCode:record.get('cCode'),bureauCode:'',deleteCode:deleteCode},
							callback :function(){
								var msg = opTypeStore.getAt(0).data['msg'];
								alert(msg);
								bStore.baseParams = {collegeCode:cCodeTemp};
								bStore.load({
									params:{start:0,limit:15},
									callback :function(){   
									}
								});
							}
						});
					}
				}]);
				
				var toolBarB = new Ext.Toolbar([{
					text:'新增',
					iconCls:'add',
					handler:function(){
						if(collegeCodeTemp == '' || collegeCodeTemp.length <= 6){
							alert('请选定全省高校树中高校后再进行新增操作！');
							return;
						}
						var selections = gridB.getSelectionModel().getSelections();
						if(selections.length == ''){
							alert('请选中基站列表记录后再进行新增操作！');
							return;
						}
						if(!confirm("确认新增高校与基站绑定？")){
							return;
						}
						var insertCode = '';
						for(var i = 0;i < selections.length;i++){
							var record = selections[i];
							if(i == 0){
								insertCode += "'"+record.get('c0_1')+"'";
							}else{
								insertCode += ",'"+record.get('c0_1')+"'";
							}
						}
						opTypeStore.reload({
							params:{optype:'insert',collegeCode:collegeCodeTemp,collegeName:encodeURI(collegeNameTemp),bureauCode:record.get('c0_1'),insertCode:insertCode},
							callback :function(){
								var msg = opTypeStore.getAt(0).data['msg'];
								alert(msg);
								queryBur();
								bStore.baseParams = {collegeCode:collegeCodeTemp};
								bStore.load({
									params:{start:0,limit:15},
									callback :function(){   
									}
								});
							}
						});
					}
				}]);
				
				/* var formPanel = new Ext.form.FormPanel({
					labelAlign:'right',
					frame:'true',
					autoScroll: true,
					labelWidth:200,
					autoHeight:true,
					id:'collegeInfo',
					items:[{
						layout:'column',
						xtype:'fieldset',
						title:'高校基本信息',
						autoHeight:true,
						collapseMode: 'mini',
						collapsible: true,
						items:[{
							layout:'form',
							columnWidth:.45,
							items:[
								new Ext.form.TextField({fieldLabel:'高校编码',id:'cCode',readOnly:true}),
								new Ext.form.TextField({fieldLabel:'学校类型',id:'cType',readOnly:true})
							]},
							{
							layout:'form',
							columnWidth:.55,
							items:[
								new Ext.form.TextField({fieldLabel:'高校名称',id:'cName',readOnly:true}),
								new Ext.form.TextField({fieldLabel:'地址',id:'cAdd',readOnly:true})
							]}
						]}
					]
				}); */
				
				
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
						title:'基站信息查询条件',
						autoHeight:true,
						collapseMode: 'mini',
						collapsible: true,
						items:[{
							layout:'form',
							columnWidth:.40,
							items:[
								new Ext.form.TextField({fieldLabel:'县(模糊)',id:'s_area_id'}),
								new Ext.form.TextField({fieldLabel:'镇(模糊)',id:'s_town_id'})
							]},
							{
							layout:'form',
							columnWidth:.50,
							items:[
								new Ext.form.TextField({fieldLabel:'区营销中心(模糊)',id:'s_zone_id'}),
								new Ext.form.TextField({fieldLabel:'基站名称',id:'bureau_name'})
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
						treeGX,
						{
							region: 'center',
							layout:"accordion",
							layoutConfig: {
							animate: true},
							split: true,
							items:[{
									region: 'north',
									iconCls:'option',
									title:'<b>删除高校与基站关联&nbsp;&nbsp;</b><br>（操作：点击<b>这里</b>打开删除操作页面，选中左则高校树中高校，勾选需要删除的记录，点击删除按钮。）',
									id:'cShow',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									collapsed: true,
									items:[toolBarRe,gridC]
								},
								{
									region: 'south',
									iconCls:'option',
									title:'<b>新增高校与基站关联&nbsp;&nbsp;</b><br>（操作：点击<b>这里</b>打开新增操作页面，选中左则高校树中高校，通过右则基站树和基站查询条件组合为过滤查询，勾选需要新增的基站记录，点击新增按钮。）',
									id:'bShow',
									split: true,
									collapseMode: 'mini',
									collapsible: true,
									collapsed: true,
									border:false,
									items:[formQuery,toolBarB,gridB]
								}]
						},
						treeJZ
					]
				});
				
				function queryBur(){
					var s_area_id = encodeURI(document.getElementById("s_area_id").value);
					var s_zone_id = encodeURI(document.getElementById("s_zone_id").value);
					var s_town_id = encodeURI(document.getElementById("s_town_id").value);
					var bureau_name = encodeURI(document.getElementById("bureau_name").value);
					
					bureauStore.baseParams = {bureauTemp:bureauTemp,s_area_id:s_area_id,s_zone_id:s_zone_id,s_town_id:s_town_id,bureau_name:bureau_name},
					bureauStore.load({
						params:{start:0,limit:9},
						callback :function(){
						}
					});
				}
				
				function clearBur(){
					document.getElementById("s_area_id").value = "";
					document.getElementById("s_zone_id").value = "";
					document.getElementById("s_town_id").value = "";
					document.getElementById("bureau_name").value = "";
				}
				
				function deleteCollege(){
					if(!confirm("确认提交删除高校与基站绑定关系？")){
						return;
					}
				}
				
				function addRel(){
					if(!confirm("确认提交新增高校与基站绑定关系？")){
						return;
					}
				}
				
			});
			
		</script>
	</head>
	<body>
	</body>
</html>