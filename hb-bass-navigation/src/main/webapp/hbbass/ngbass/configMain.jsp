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
	        title: '查询条件配置',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/queryConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	       // autoLoad:{url:'/kpi/daily.jsp', scripts:true}, // 由于动态加载原有的程序都需要作调整,所以使用 frame 加载
	        border:true
	    },
	    {
	    	  id:'index1',
	        title: '查询配置',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame1" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/resultConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index2',
	        title: '分析配置',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame2" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/analyConfig.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    }
	    ,
	    {
	    	  id:'index3',
	        title: '查询测试',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame3" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/queryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index4',
	        title: '分析测试',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame4" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/analyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    } 
	    ,
	    {
	    	  id:'index5',
	        title: '渠道专题查询测试',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame5" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelQueryMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    },
	    {
	    	  id:'index6',
	        title: '渠道专题分析测试',
	        closable:false,
	        autoScroll:true,
	        'html':'<iframe id="indexFrame6" scrolling="auto" frameborder="0" width="100%" height="98%" src="/hbbass/ngbass/channelAnalyMain.jsp?pid=<%=reportid%>&reportname=<%=reportname%>"></iframe>',
	        border:true
	    } 
	    ,
	    {
	    	  id:'index7',
	        title: 'TD专题分析测试',
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