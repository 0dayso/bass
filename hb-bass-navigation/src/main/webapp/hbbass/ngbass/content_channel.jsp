<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<html>
   
<% 
String reportid=request.getParameter("reportid");
//String reportname=request.getParameter("reportname");
//reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");

Object[] data = this.getData(request);
if(data[0] == null)
    out.print("�޼�¼!");
String reportname = (String)data[1];
Integer type = ((Integer)data[0]);
log.debug("reportname : " + reportname + " ::: type : " + type);
%>
<%-- 
	copied from content.jsp ,��ͬ����ת������ר�õĲ�ѯ�ͷ���ҳ��
--%>
<head>
  <title><%=reportname%></title>
	<link rel="stylesheet" type="text/css" href="/hbbass/js/ext202/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="/hbbass/js/ext202/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="/hbbass/js/ext202/ext-all.js"></script>
	<style type="text/css">
	</style>
	<script type="text/javascript">
		<%
		if(type == null)
		    out.print("alert('�޼�¼!')");
		%>
		Ext.BLANK_IMAGE_URL = '/hbbass/js/ext202/resources/images/default/s.gif';
		Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
       var viewport = new Ext.Viewport({
            layout:'border',
            items:[
                   contentPanel
             ]
        });
       
    });
  
  var items = getItems();
  var contentPanel =new Ext.TabPanel({
      region:'center',
	    deferredRender:false,
	    enableTabScroll:true,
	    activeTab:0,
	    /*
	    items:[
	    {
	    	  id:'index1',
	        title: '��ѯ����',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame3" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/queryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index2',
	        title: '��������',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame4" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/analyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    } 
	    ]
	    */
	    items : items
  }); 
  function getItems() {
	    	
	    	var type = <%= type%>;
	    	var itemsArr = new Array();
	    	switch(type) {
	    	case 1 : {
		    	itemsArr[0] = {
			    	id:'index1',
			        title: '����ר���ѯ����',
			        closable:false,
			        autoScroll:true,
			        'html':'<iframe id="indexFrame3" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelQueryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
			        border:true
		    	} ;break;
	    	}
	    		case 2 : {
		    		itemsArr[0] = {
		    	  id:'index2',
		     	  title: '����ר���������',
		          closable:false,
		          autoScroll:true,
		          'html':'<iframe id="indexFrame4" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelAnalyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
		          border:true
		   		};break;
	    		}
	   		   case 3 : {
		   		   itemsArr[0] =  {
			    	id:'index1',
			        title: '����ר���ѯ����',
			        closable:false,
			        autoScroll:true,
			        'html':'<iframe id="indexFrame3" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelQueryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
			        border:true
		    	};
			    	itemsArr[1] = {
		    	  id:'index2',
		     	  title: '����ר���������',
		          closable:false,
		          autoScroll:true,
		          'html':'<iframe id="indexFrame4" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelAnalyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
		          border:true
		   		};
		   		break;
	   		   }
	    	
	   			default : break;
	    	}
	    	return itemsArr;
	    	alert("itemsArr : " + itemsArr);
  } 
	</script>
</head>
<body>
</body>
<%!
//0 ���߶�����; 1 ��ѯ 2 ���� 3 ��ѯ + ����;	
	public static final int QUERY = 1;
	public static final int NONE = 0;
	public static final int ANALYSIS = 2;
	public static final int BOTH = 3;
//һ���жϵ�ǰӦ���ǲ�ѯ���Ƿ����ķ���,��Ҫ���ݿ�����
	//temp : reportid=105&reportname=�ͻ���������KPI
	private static final Logger log = Logger.getLogger("contentPageForNgbass");
	//Ϊ�˲����������ݿ�ֱ�ȡ�ñ������ƺ�����,������ķ���ֵ����,int -> Object[]
	private Object[] getData (HttpServletRequest request) {
    	Connection conn = null;
    	Statement st = null;
    	ResultSet rs = null;
    	Object[] data = new Object[2];
    	int type = 0;
    	try{
	    	String reportId = request.getParameter("reportid");
	    	//String reportName = request.getParameter("reportname");
	    	//log.debug("\nreportId : " + reportId + "\nreportNameBeforeConvert : " + reportName );
	    	//reportName = new String(reportName.getBytes("iso-8859-1"),"gb2312");
	    	//log.debug("\nreportNameAfterConvert : " + reportName);
	    	String sql = " select REPORT_SQL, REPORTANALYQUERY, REPORT_NAME from NGBASS_REPORT where id = " + reportId;
	    	log.debug("\nsql : " + sql);
	    	
    	    conn = ConnectionManage.getInstance().getDWConnection();
    		st = conn.createStatement();		
    		rs = st.executeQuery(sql);
    		if(rs.next()) {
    		    if(rs.getString(1) != null && rs.getString(1).length() > 0) {
    		        if(rs.getString(2) != null && rs.getString(2).trim().length() > 0)
    		            type = this.BOTH;
    		        else
 				   		type = this.QUERY;
    		    } else if(rs.getString(2) != null && rs.getString(2).trim().length() > 0)
    		        type = this.ANALYSIS;
    		    else
    		        type = this.NONE;
    		    data[0] = Integer.valueOf(type);
    		    data[1] = rs.getString(3);
    		} else {
    		    log.warn("�޼�¼!");
    		}
    		log.debug("selected type : " + type);
    		
    		return data;
    	} catch(Exception e) {
    	    e.printStackTrace();
    	    log.error("���ִ��� : " + e.getMessage());
    	} finally {
    		ConnectionManage.getInstance().releaseConnection(conn);
    	}
    	return data;
	}
%>
</html>