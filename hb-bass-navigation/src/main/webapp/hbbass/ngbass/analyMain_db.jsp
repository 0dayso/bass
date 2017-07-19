<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page import="com.asiainfo.database.*" %>
<%@ page import = "bass.common.NgbassTools"%>
<%
  out.clear(); 
  String sql = request.getParameter("sql");
  sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
  
  String[] sql_dim_table_array = request.getParameter("sql_dim_table").split(",");
  
  String[] sql_value_name = request.getParameter("sql_value_name").split(",");
  
  String table_title=request.getParameter("table_title");
  table_title = new String(table_title.getBytes("ISO-8859-1"),"UTF-8");
  String[] table_title_array=table_title.split(",");
  System.out.println("===="+table_title_array.length);
  StringBuffer sb = new StringBuffer();
  int rowAllCount=0;  // 查询结果的行数
  
 bass.common.SQLSelect select = new bass.common.SQLSelect(); 
 java.util.List list = select.getTotalList(sql);
 rowAllCount=list.size();
 //汇总的值，结果行数一般比较少
 // 新生成的表id必须为 resultTable ，在下载函数中SaveAsExcel已写死  
  sb.append("<table id=\"resultTable\" align='center' width='"+table_title_array.length*9+"%' border=\"1\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse;display:block\" bordercolor=\"#537EE7\">");
	sb.append("<THEAD id='resultHead'>");	
	for(int titleLength=0;titleLength<table_title_array.length;titleLength++)
	{
	   
         sb.append("<td align='center' bgcolor='#D9ECF6' height='21' style='display:block' id='index"+titleLength+"'>");
				 sb.append("<A class='a2'  onclick=\"changeText('index"+titleLength+"');sortTable('resultTbody',"+titleLength+", true,0);freshImage();\" href=\"#\"  title=\"点击按此排序\">"+table_title_array[titleLength]+"</a>");
				 //sb.append(table_title_array[titleLength]);
				 sb.append("</td>");
	}
	sb.append("</THEAD>"); 
	sb.append("<TBODY id='resultTbody'>");
		// 开始输出数据
		if(rowAllCount>1)
		{
			for ( int i=0; i < rowAllCount-1; i ++ )
			{ 
			  	String[] data = (String[])list.get(i);
					if(i%2==0)
			      sb.append("<TR class='grid_row_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_blue'\">");
			    else
			  		sb.append("<TR class='grid_row_alt_blue'  onMouseOver=\"this.className='grid_row_over_blue'\" onMouseOut=\"this.className='grid_row_alt_blue'\">");
            for(int m=0;m<sql_dim_table_array.length;m++)
				  	{      System.out.println("1111"+data[m]+"----");
				  	       sb.append("<TD align='left'  flag='0'  height='21' id='index"+m+"'>"+NgbassTools.getDimName(sql_dim_table_array[m],data[m]==null?"合计":data[m].trim())+"</TD>");
				  	}
				  	 for(int n=sql_dim_table_array.length;n<sql_dim_table_array.length+sql_value_name.length;n++)
				  	{
				  	       sb.append("<TD align='right'  flag='0'  height='21' id='index"+n+"'>"+data[n]+"</TD>");
				  	}
			  		sb.append("</TR>");
		  	}	
	  	}	
		sb.append("</TBODY>");
	sb.append("<TFOOT>");
	if(rowAllCount>1)
		{
		       String[] data = (String[])list.get(rowAllCount-1);
		       sb.append("<TR bgcolor='#D9ECF6'>");
            for(int m=0;m<sql_dim_table_array.length;m++)
				  	{      System.out.println("22222"+data[m]+"----");
				  	       sb.append("<TD align='left'  flag='0'  height='21' id='index"+m+"'>"+NgbassTools.getDimName(sql_dim_table_array[m],data[m]==null?"合计":data[m].trim())+"</TD>");
				  	}
				  	 for(int n=sql_dim_table_array.length;n<sql_dim_table_array.length+sql_value_name.length;n++)
				  	{
				  	       sb.append("<TD align='right'  flag='0'  height='21' id='index"+n+"'>"+data[n]+"</TD>");
				  	}
			  		sb.append("</TR>");
		}
		
		sb.append("</TFOOT>");
		sb.append("</table>");
   out.print(sb.toString());
%>  