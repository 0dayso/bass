<%@ page contentType="text/html; charset=gb2312"%>
<html>
<%
String reportid=request.getParameter("reportid");
String reportname=request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");
%>
<head>
  <title><%=reportname%></title>
	<link rel="stylesheet" type="text/css" href="/hbbass/js/ext202/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="/hbbass/js/ext202/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="/hbbass/js/ext202/ext-all.js"></script>
	<style type="text/css">
	</style>
	<script type="text/javascript">
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
  
  var contentPanel =new Ext.TabPanel({
      region:'center',
	    deferredRender:false,
	    enableTabScroll:true,
	    activeTab:0,
	    items:[
	    {
	    	  id:'index0',
	        title: '��ѯ��������',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/queryConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	       // autoLoad:{url:'/kpi/daily.jsp', scripts:true}, // ���ڶ�̬����ԭ�еĳ�����Ҫ������,����ʹ�� frame ����
	        border:true
	    },
	    {
	    	  id:'index1',
	        title: '��ѯ����',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame1" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/resultConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index2',
	        title: '��������',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame2" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/analyConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    }
	    ,
	    {
	    	  id:'index3',
	        title: '��ѯ����',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame3" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/queryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index4',
	        title: '��������',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame4" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/analyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    } 
	    ,
	    {
	    	  id:'index5',
	        title: '����ר���ѯ����',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame5" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelQueryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index6',
	        title: '����ר���������',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame6" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelAnalyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    } 
	    ,
	    {
	    	  id:'index7',
	        title: 'TDר���������',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame6" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/TDanalyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    } 
	    ]
	    
  });  
	</script>
</head>
<body>
</body>
</html>