<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%
   String userID = (String)session.getAttribute("loginname"); 
   Connection conn = null;
   PreparedStatement ps = null;
   ResultSet rs = null;
   String _where = " 1=2 " ;
   try{
       conn = ConnectionManage.getInstance().getWEBConnection();
	   String v_sql = "select cityid,cityname,operator,operator2 from FPF_AUDIT_FLOW where operator='"+userID+"' or operator2= '"+userID+"'";
	   ps = conn.prepareStatement(v_sql);
	   rs = ps.executeQuery();
	   
	   if (rs.next()){
	       if (rs.getString("operator").equals(userID)){
		       _where = " status = 'waitaudit1' ";
			   if (rs.getString("cityid").equals("0")){
			   _where = " status = 'waitaudit3' ";
			   }
		   }else if (rs.getString("operator2").equals(userID)){
		       _where = " status = 'waitaudit2' ";
		   }
	   }
	   
	   if (!_where.equals(" status = 'waitaudit3' ") && !_where.equals(" 1=2 ") ){
	      v_sql = "select 'HB.'||areacode areacode from FPF_USER_USER a,AREA b where char(b.area_id)=a.cityid and userid='"+userID+"'"; 
		  ps = conn.prepareStatement(v_sql);
	      rs = ps.executeQuery();
		  if (rs.next()){
		       _where += " and Area_Code='"+rs.getString("areacode") + "'" ;
		  }
	   }
   
   }catch (SQLException e){
	e.printStackTrace();
   }finally{
    if (rs != null)
	   rs.close();
	if (ps != null)
        ps.close();	
	if(conn!=null)
		conn.close();
    }
%>

<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>层级关系信息变更审核</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript" src="../../../js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/json2.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">

      var _header=[
	{"name":["地市编码"],"dataIndex":"area_code"}
	,{"name":["地市名称"],"dataIndex":"area_name"}
    ,{"name":["操作类型"],"dataIndex":"optype"}	
	,{"name":["待审核状态"],"dataIndex":"status"}
	,{"name":["数量"],"dataIndex":"num"}
      ]; 
		   function genSQL(){
		      var _sql = "select * from (";
			     _sql += " select area_id,(select ITEMID from mk.dim_areacity where area_id=char(REGION)) AREA_CODE,(SELECT ITEMNAME FROM "; _sql += " mk.dim_areacity WHERE AREA_ID=CHAR(REGION)) AREA_NAME,status,";
			     _sql += " count(*) num,'LAC' OPTYPE from BUREAU_LAC_CHANGE_INFO where status<>'succ' and status<>'fail' ";
                 _sql += " group by area_id,status " ;
				 _sql += " union ";
				 _sql += " select AREA_ID,(select ITEMID from mk.dim_areacity where area_id=char(REGION)) AREA_CODE,(SELECT ITEMNAME FROM "; _sql += " mk.dim_areacity WHERE AREA_ID=CHAR(REGION)) AREA_NAME,";
                 _sql += " STATUS,COUNT(*) NUM,'BUREAU' OPTYPE from BUREAU_CELL_NEWDEL_INFO ";
                 _sql += " where status<>'succ' and status<>'fail' group by area_id,status";
				 _sql += " union ";
				 _sql += "select area_id,(select ITEMID from mk.dim_areacity where area_id=char(REGION)) AREA_CODE,(SELECT ITEMNAME FROM "; _sql += " mk.dim_areacity WHERE AREA_ID=CHAR(REGION)) AREA_NAME,status,count(*) ";
				 _sql += "num,'BCHANG' OPTYPE from BUREAU_CELL_CHANGE_INFO where status<>'succ' and status<>'fail' group by area_id,status";
				 _sql += " union ";
				 _sql += " select (select char(REGION) from mk.dim_areacity WHERE ITEMID=AREA_CODE) AREA_ID,AREA_CODE,(SELECT ITEMNAME FROM ";_sql += " mk.dim_areacity WHERE ITEMID=AREA_CODE) AREA_NAME,status,count(*) ";
                 _sql += " num,'CENGJI' OPTYPE from BUREAU_TREE_NEWDEL_INFO where status<>'succ' and status<>'fail' group by ";
				 _sql += " AREA_CODE,status ";
				 _sql += " union ";
				 _sql += " select (select char(REGION) from mk.dim_areacity WHERE ITEMID=AREA_CODE) AREA_ID,AREA_CODE,(SELECT ITEMNAME FROM ";_sql += " mk.dim_areacity WHERE ITEMID=AREA_CODE) AREA_NAME,STATUS,count(*) num,";
                 _sql +=" 'CENGJICHANGE' OPTYPE from BUREAU_TREE_CHANGE_INFO where status<>'succ' and status<>'fail' group by ";
				 _sql +=" AREA_CODE,status";
				 _sql += ") f where " + "<%=_where%>";
				 return _sql ;
				 
		   };
		   
		   var contextPath = window.location['pathname'].split('/')[1];
		   Ext.BLANK_IMAGE_URL = '/hbapp/resources/js/ext/resources/images/default/s.gif';
		   Ext.onReady(function(){
		    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
		    Ext.MessageBox.buttonText.ok='确定';
		    Ext.MessageBox.buttonText.yes='确定';
		    Ext.MessageBox.buttonText.no='取消';
            Ext.MessageBox.buttonText.cancel="取消";
            //Ext.Msg.alert('',genSQL());
		    var ds=new Ext.data.Store({
                    proxy: new Ext.data.HttpProxy({url:"${mvcPath}/hbirs/action/jsondata?method=query&sql="+genSQL()+"&isCached=false&qType=limit&start=1&limit=2000"}),
                    reader: new Ext.data.JsonReader({
                        root: 'data',
                        totalProperty:'total'
                   },[ 'area_id','area_code','area_name','num','status','optype']
                    ) 
               });
			   
			   
		    ds.load();
		    //
  //function getOptype(value, cellmeta, record, rowIndex, columnIndex, store){
  function getOptype(value){
	      var str = value ;
        if (value == null || value == ''){
            str = '未知操作';
          }else if (value == 'LAC'){
		     str = 'lac码变更审核';
		  }else if (value == 'BUREAU'){
		     str = '基站新增、删除信息审核';
		  }else if (value == 'BCHANG'){
		     str = '基站信息变更审核';
		  }else if (value == 'CENGJI'){
		     str = '层级关系审核';
		  }else if (value == 'CENGJICHANGE'){
		     str = '层级关系变更审核';
		  }else{
		     str = '未知操作';
		  }
		  
      return str;
};
  function getStatus(value, cellmeta, record, rowIndex, columnIndex, store){
	      var str = value ;
        if (value == null || value == ''){
            str = '未知操作';
          }else if (value == 'waitaudit1'){
		     str = '一级审核';
		  }else if (value == 'waitaudit2'){
		     str = '二级审核';
		  }else if (value == 'waitaudit3'){
		     str = '三级审核';
		  }else{
		     str = '未知操作';
		  }
		  
      return str;
};
		    
			var smck_gd = new Ext.grid.CheckboxSelectionModel();

			var gd_1 = new Ext.grid.GridPanel({
         region:'center',
         //el: 'grid',
         id : 'gd_1',
	     ds: ds,
	     sm: smck_gd,	     
	     columns:[
	     smck_gd,
	     {header:"地市编码",width:90,sortable:true,dataIndex:"area_code"},
         {header:"地市名称",width:120,sortable:true,dataIndex:"area_name"},
		{header:"操作类型",width:160,sortable:true,dataIndex:"optype",renderer:getOptype},
		{header:"待审核状态",width:120,sortable:true,dataIndex:"status",renderer:getStatus},
		{header:"数量",width:80,sortable:true,dataIndex:"num"}
	     ],
	     //tbar : [fd_addbtn,fd_delbtn,fd_addbtnA,'-',fd_down],
	     bbar : ['->',
	     new Ext.PagingToolbar({id:'pagingtoolbar',pageSize: 200, store: ds,displayInfo: true,loadMask: true,
                                 displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
                                 emptyMsg: "没有记录",width:400 })
	     ],
	     loadMask: true,		     
	     border:false,
	     bodyStyle:'Height:100%;',
	     bodyStyle:'width:90%;',
	     autoWidth:true
	     }); 
			
		var f_gd_1_celldblclick = function(grid, rowIndex, columnIndex, e) {
        var r = grid.getStore().getAt(rowIndex);  // Get the Record
        var formname='';
         if(r.get('optype')=='LAC')formname='lac_change.jsp'
        else if(r.get('optype')=='BUREAU')formname='bureau_newdel.jsp'
        else if(r.get('optype')=='BCHANG')formname='bureau_change.jsp'
        else if(r.get('optype')=='CENGJI')formname='bureau_tree_newdel.jsp';	
		else if(r.get('optype')=='CENGJICHANGE')formname='bureau_tree_change.jsp';
		else
		    return ;
        //Asiainfo.addTabSheet(r.get('optype')+r.get('status'),'审核:'+r.get('optype'),'../hbbass/salesmanager/areasale/bureauAudit/'+formname); 
        tabAdd({title:'审核:'+getOptype(r.get('optype')),url:"/hbbass/salesmanager/areasale/bureauAudit/"+formname});     
} ; 

gd_1.on("celldblclick",f_gd_1_celldblclick);
	
		 	var ly_1 = new Ext.Viewport({
	     layout:'border',
	     items:[gd_1]
        }); 
			});
		</script>
    </head>
	<body>
	</body>
</html>