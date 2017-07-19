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
			WritableSheet sheet = workbook.createSheet("�������������嵥", 0);                       
			                                                                                        
			//һЩ��ʱ����������д��excel��                                                         
			Label l=null;                                                                
			jxl.write.Number n=null;                                                              
			jxl.write.DateTime d=null;
	                                                                                        
			//Ԥ�����һЩ����͸�ʽ��ͬһ��Excel����ò�Ҫ��̫���ʽ                               
			 WritableFont headerFont = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD,  
			    false, jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLUE);                        
			 WritableCellFormat headerFormat = new WritableCellFormat (headerFont);                 
			                                                                                        
			 WritableFont titleFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD,
			     false, jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);                        
			 WritableCellFormat titleFormat = new WritableCellFormat (titleFont);                   
			                                                                                        
			 WritableFont detFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD,  
			    false, jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);                       
			 WritableCellFormat detFormat = new WritableCellFormat (detFont);                       
			                                                                                        
			 NumberFormat nf=new NumberFormat("0.00"); //����Number�ĸ�ʽ                        
			 WritableCellFormat priceFormat = new WritableCellFormat (detFont, nf);                 
			                                                                                        
			 DateFormat df=new DateFormat("yyyy-MM-dd");//�������ڵ�   
			 WritableCellFormat dateFormat = new WritableCellFormat (detFont, df);
			                                                                                        
			 //ʣ�µ����飬��������������ݺ͸�ʽ����һЩ��Ԫ���ټӵ�sheet��
			 //l=new Label(0, 0, "���ڲ��Ե�Excel�ļ�", headerFormat);
			 //sheet.addCell(l);
			                                                                                        
			 //add Title
			 int column=0;
			 l=new Label(column++, 0, "�������ֺ���", titleFormat);                                         
			 sheet.addCell(l);                                                   
			 l=new Label(column++, 0, "�ƶ�����", titleFormat);                                         
			 sheet.addCell(l);                                                     
			 l=new Label(column++, 0, "�ͻ���������", dateFormat);                                         
			 sheet.addCell(l);                                                                      
			 l=new Label(column++, 0, "�ͻ�����ID", priceFormat);                                         
			 sheet.addCell(l);                                                                      
			 l=new Label(column++, 0, "�ͻ������������", priceFormat);                                         
			 sheet.addCell(l);
			 l=new Label(column++, 0, "��������", priceFormat);                                         
			 sheet.addCell(l);
			 l=new Label(column++, 0, "�߷�ʱ��", priceFormat);                                         
			 sheet.addCell(l);
			 l=new Label(column++, 0, "¼��ʱ��", priceFormat);                                         
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
			
			//�����еĿ��                                                                         
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
	String title = "�������������嵥";
	System.out.println("--title="+title);
	String sql = request.getParameter("sql");
	//System.out.println("---sql="+sql);
	sql = java.net.URLDecoder.decode(sql,"UTF-8");
	System.out.println("---sql11="+sql);
	OutputStream os = response.getOutputStream();
	response.reset();//��������
	response.setContentType("aplication/vnd.ms-excel");
	response.addHeader("Content-Disposition","inline; filename=" + new String(title.getBytes("GB2312"),"ISO8859_1") + ".xls");  //�����ı���ת��                                                                
	SaveExcel saveExcel = new SaveExcel();
	saveExcel.SaveExcel(sql,os);	
%>