<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import = "org.jfree.ui.RectangleInsets,org.jfree.chart.JFreeChart,org.jfree.chart.labels.StandardCategoryItemLabelGenerator"%>
<%@ page import="org.jfree.chart.ChartFactory"%>                 
<%@ page import="org.jfree.chart.ChartUtilities"%> 
<%@ page import="org.jfree.data.category.DefaultCategoryDataset"%>  
<%@ page import="org.jfree.chart.renderer.category.LineAndShapeRenderer"%>  
<%@ page import="bass.common.SQLSelect,org.jfree.chart.plot.CategoryPlot,org.jfree.chart.plot.PlotOrientation"%>  

<%
	String phone = (String)request.getParameter("phone");
	
	String tablename = (String)request.getParameter("tablename");
	
	java.util.List list =  null;
	
	if("rival".equals(request.getParameter("rival")))
	{
		list = bass.LJXD.getRivalMOU(tablename,phone);
	}
	else
	{
		list = bass.LJXD.getMOU(tablename,phone);
	}
	

	String[] line = (String[])list.get(1);
	
	String[] meta = (String[])list.get(0);
	
	
	DefaultCategoryDataset dataset = new DefaultCategoryDataset();
	
	for(int i = 0; i < line.length;i++)
	{
		dataset.addValue(Integer.parseInt(line[i]==null?"0":line[i])/60, "话务量",meta[i]);
	}
	
	JFreeChart jfreechart = ChartFactory.createLineChart(phone+" 的话务量折线图", "月份", "话务量(分钟)",dataset, PlotOrientation.VERTICAL, false, true, false);
	
	CategoryPlot categoryplot = (CategoryPlot) jfreechart.getPlot();
	
	LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) categoryplot.getRenderer();
	lineandshaperenderer.setShapesVisible(true);
	lineandshaperenderer.setDrawOutlines(true);
	lineandshaperenderer.setUseFillPaint(true);
	lineandshaperenderer.setItemLabelsVisible(true);
	lineandshaperenderer.setItemLabelGenerator(new StandardCategoryItemLabelGenerator());
		
	java.io.OutputStream os = response.getOutputStream(); 
	response.setContentType("image/png"); 
	ChartUtilities.writeChartAsPNG(os, jfreechart, 640, 480); 
%>