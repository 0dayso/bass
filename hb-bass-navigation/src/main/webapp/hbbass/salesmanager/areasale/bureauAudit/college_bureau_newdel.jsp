<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
String userid = (String)session.getAttribute("loginname");
Connection conn = null;
String region = null;
boolean isProvince = false;
String provinceOperatorCN = null;
String operatorCN = null;
boolean hasRight = false;
boolean _aduitFlag = true ;
Date currentDate = new Date();
String formatString = "yyyy-MM-dd";
SimpleDateFormat df = new SimpleDateFormat(formatString);
String defaultDate =  df.format(currentDate);
try{
	conn = ConnectionManage.getInstance().getWEBConnection();
	String sql = "select cityid , cityname , operator , operator2 from FPF_AUDIT_FLOW where operator='"+userid+"' or operator2='"+userid+"'";
	PreparedStatement ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		hasRight = true;
		System.out.println("有高校基站配置权限！");
	}
	rs.close();
	ps.close();
}catch ( SQLException e){
	e.printStackTrace();
}finally{
	if(conn!=null)
		conn.close();
}
%>	
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>高校新增、删除基站</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript">
Ext.BLANK_IMAGE_URL = '/hbapp/resources/js/ext/resources/images/default/s.gif';
Ext.onReady(function(){
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	var viewport = new Ext.Viewport({
	    layout:'border',
	    items:[{
			region:'west',
			id:'west-panel',
			title:'高校基站树',
			split:true,
			width: 200,
			minSize: 175,
			maxSize: 400,
			collapsible: true,
			autoScroll : true,
			margins:'3 0 0 5',
			layoutConfig:{
			    animate:true
			},
			items: [{
			    contentEl: 'west',
			    border:false,
			    iconCls:'nav'
			}]
        },
        {
            region:'center',
            split:true,
            //title:'Navigation',
            autoScroll : true,
            //width: 200,
            //minSize: 175,
            //maxSize: 400,
            //collapsible: true,
            margins:'3 3 0 0',
            items: [{
                contentEl: 'center',
                border:false,
                iconCls:'nav'
            }]
        }]
	});
	
		
	var Tree = Ext.tree;
    
    var tree = new Tree.TreePanel({
        el:'tree-div',
        useArrows:true,
        autoScroll:true,
        animate:true,
        //enableDD:true,
        border:false,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
            dataurl:'${mvcPath}/hbirs/action/areaSaleManage?method=collegeNodes'
        })
    });
	
	var _uriParams=aihb.Util.paramsObj();
    var root = new Tree.AsyncTreeNode({
        text: '湖北 [双击查看明细]',
        draggable:false,
        iconCls:'x-tree-node-icon3',
        id:'-1'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
	
	tree.on("click",function(node,event){
		//if(node.leaf)
		//alert(node.attributes.url);
		var whereContent = node.attributes.url;
		document.getElementById("collegeId").value=node.attributes.id;
		//if(whereContent){
			var url1 = "/hbbass/salesmanager/areasale/bureauAudit/college_tree_detail.jsp?whereContent="+node.attributes.id;
			document.getElementById("detailframe1").src = url1;
			var url2 = "/hbbass/salesmanager/areasale/bureauAudit/cell_tree_for_college.htm?whereContent="+node.attributes.id;
			document.getElementById("detailframe2").src = url2;	
		//}
		//window.open(url,'_detail','');
	});
	
});

	function onAdd() {
		var ids = self.detailframe2.self.detailframe.checkId();
		var collegeId = document.getElementById("collegeId").value;
		alert("您选择的基站已添加，将变成待审核状态！");
		var _ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=collegeAddBureau",
			parameters : "bureauIds=" + ids + "&collegeId=" + collegeId,
			callback : function(xmlrequest) {
				var url1 = "/hbbass/salesmanager/areasale/bureauAudit/college_tree_detail.jsp?whereContent=" + collegeId;
				document.getElementById("detailframe1").src = url1;
				var url2 = "/hbbass/salesmanager/areasale/bureauAudit/cell_tree_for_college.htm?whereContent=" + collegeId;
				document.getElementById("detailframe2").src = url2;
			}
		});
		_ajax.request();
	}

	function onDel() {
		var ids = self.detailframe1.checkId();
		var collegeId = document.getElementById("collegeId").value
		alert("您选择的基站已删除，将变成待审核状态！");
		var _ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/areaSaleManage?method=collegeDelBureau",
			parameters : "bureauIds=" + ids + "&collegeId=" + collegeId,
			callback : function(xmlrequest) {
				var url1 = "/hbbass/salesmanager/areasale/bureauAudit/college_tree_detail.jsp?whereContent=" + collegeId;
				document.getElementById("detailframe1").src = url1;
				var url2 = "/hbbass/salesmanager/areasale/bureauAudit/cell_tree_for_college.htm?whereContent=" + collegeId;
				document.getElementById("detailframe2").src = url2;
			}
		});
		_ajax.request();
	}
</script>
	</head>
	<body>
		<div id="west">
			<div id="tree-div" style="height: 100%; width: 100%;"></div>
		</div>
		<div id="center">
			<input type="hidden" id="collegeId">
			<div><iframe name="detailframe1" id="detailframe1" src="/hbbass/salesmanager/areasale/bureauAudit/college_tree_detail.jsp" width="100%" height="300"></iframe></div>
			<div style="font-size: 12px;text-align: center;" >
			<%if(hasRight == true) {
			%>
			<a href="javascript:onAdd();" >增加</a><img src="${mvcPath}/hbapp/resources/image/arrow_up.gif" style="vertical-align: middle;"></img>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:onDel();" >删除</a><img src="${mvcPath}/hbapp/resources/image/arrow_down.gif" style="vertical-align: middle;"></img>
			<%
			}
			%>
			<%if(hasRight == false) {
			%>
			<a href="javascript:alert('您没有操作此功能的权限');">增加</a><img src="${mvcPath}/hbapp/resources/image/arrow_up.gif" style="vertical-align: middle;"></img>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:alert('您没有操作此功能的权限');">删除</a><img src="${mvcPath}/hbapp/resources/image/arrow_down.gif" style="vertical-align: middle;"></img>
			<%
			}
			%>
			</div>
			<div><iframe name="detailframe2" id="detailframe2" src="/hbbass/salesmanager/areasale/bureauAudit/cell_tree_for_college.htm" width="100%" height="300"></iframe></div>
		</div>
		<div id="bottom">
			
		</div>
	</body>
</html>
