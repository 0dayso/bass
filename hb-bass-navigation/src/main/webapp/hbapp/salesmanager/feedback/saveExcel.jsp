<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*,java.io.*,java.io.File.*"%>
<%@ page import="jxl.*,jxl.write.*,java.format.*"%>
<%@ page import="com.asiainfo.database.*" %>
<%
final class SaveExcel
{
	public SaveExcel()
	{
			
	}
	public void SaveExcel(String sql,OutputStream os)
	{
		Sqlca sqlca = null;
		try
		 {
			if(sql == null || "".equals(sql))
			{
				return;
			}
		  sqlca = new Sqlca(new ConnectionEx("JDBC_MPM"));
			sqlca.execute(sql);			
                                       
			WritableWorkbook workbook = Workbook.createWorkbook(os);
			WritableSheet sheet = workbook.createSheet("回流反馈数据清单", 0);                       
			                                                                                        
			//一些临时变量，用于写到excel中                                                         
			Label l=null;                                                                
			jxl.write.Number n=null;                                                              
			jxl.write.DateTime d=null;
	                                                                                        
			//预定义的一些字体和格式，同一个Excel中最好不要有太多格式                               
			 WritableFont headerFont = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD,  
			    false, jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLUE);                        
			 WritableCellFormat headerFormat = new WritableCellFormat (headerFont);                 
			                                                                                        
			 WritableFont titleFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD,
			     false, jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);                        
			 WritableCellFormat titleFormat = new WritableCellFormat (titleFont);                   
			                                                                                        
			 WritableFont detFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD,  
			    false, jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);                       
			 WritableCellFormat detFormat = new WritableCellFormat (detFont);                       
			                                                                                        
			 NumberFormat nf=new NumberFormat("0.00"); //用于Number的格式                        
			 WritableCellFormat priceFormat = new WritableCellFormat (detFont, nf);                 
			                                                                                        
			 DateFormat df=new DateFormat("yyyy-MM-dd");//用于日期的   
			 WritableCellFormat dateFormat = new WritableCellFormat (detFont, df);
			                                                                                        
			 //剩下的事情，就是用上面的内容和格式创建一些单元格，再加到sheet中
			 //l=new Label(0, 0, "用于测试的Excel文件", headerFormat);
			 //sheet.addCell(l);
			                                                                                        
			 //add Title
			 int column=0;
			 l=new Label(column++, 0, "竞争对手号码", titleFormat);                                         
			 sheet.addCell(l);                                                   
			 l=new Label(column++, 0, "移动号码", titleFormat);                                         
			 sheet.addCell(l);                                                     
			 l=new Label(column++, 0, "客户经理名称", dateFormat);                                         
			 sheet.addCell(l);                                                                      
			 l=new Label(column++, 0, "客户经理ID", priceFormat);                                         
			 sheet.addCell(l);                                                                      
			 l=new Label(column++, 0, "客户经理归属县域", priceFormat);                                         
			 sheet.addCell(l);
			 l=new Label(column++, 0, "回流策略", priceFormat);                                         
			 sheet.addCell(l);
			 l=new Label(column++, 0, "策反时间", priceFormat);                                         
			 sheet.addCell(l);
			 l=new Label(column++, 0, "录入时间", priceFormat);                                         
			 sheet.addCell(l);			 

			 //add detail
			 int i=1;
			 while(sqlca.next())
			 {
				 for(int col=0;col<8;col++)
				 {					 
					 l=new Label(col, i,sqlca.getString(col+1), detFormat);
					 
					 sheet.addCell(l);
				 }
				 i++;
			 }
			
			//设置列的宽度                                                                         
 			column=0; 
			sheet.setColumnView(column++, 10);                                                     
 			sheet.setColumnView(column++, 10);                                                     
 			sheet.setColumnView(column++, 10);                                                     
 			sheet.setColumnView(column++, 10);
 			sheet.setColumnView(column++, 10);                                                     
 			sheet.setColumnView(column++, 20);
 			sheet.setColumnView(column++, 10);                                                     
 			sheet.setColumnView(column++, 10);  
 
			 workbook.write();                                                                      
			 workbook.close();
		 }
		 catch (Exception ex)
		 {
			System.out.println(ex.getMessage()); 
		 }
	}	
}

%>
<%
	String title = "回流反馈数据清单";
	System.out.println("--title="+title);
	String sql = request.getParameter("sql");
	//System.out.println("---sql="+sql);
	sql = java.net.URLDecoder.decode(sql,"UTF-8");
	System.out.println("---sql11="+sql);
	OutputStream os = response.getOutputStream();
	response.reset();//清空输出流
	response.setContentType("aplication/vnd.ms-excel");
	response.addHeader("Content-Disposition","inline; filename=" + new String(title.getBytes("GB2312"),"ISO8859_1") + ".xls");  //有中文必须转码                                                                
	SaveExcel saveExcel = new SaveExcel();
	saveExcel.SaveExcel(sql,os);	
%>