<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.io.File"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page	import="org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="jxl.Cell"%>
<%@page import="jxl.CellType"%>
<%@page import="jxl.DateCell"%>
<%@page import="jxl.Sheet"%>
<%@page import="jxl.Workbook"%>
<%@page import="jxl.read.biff.BiffException"%>
<%@page import="bass.common2.ConnectionManage,bass.database.report.ReportBean"%>
<jsp:directive.page import="java.text.SimpleDateFormat" />
<link rel="stylesheet" type="text/css" href="/hbbass/js/ext202/resources/css/ext-all.css"/>
<script type="text/javascript">
function del(querytime)
{
	xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
	//xmlHttp.onreadystatechange=delBack; // 设置回掉函数
	xmlHttp.open("POST","/hbbass/channel/surrogateanalysis/importcancel_db.jsp",false);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	var str="actiontype=delete&querytime="+querytime;
	xmlHttp.send(str);
	alert(xmlHttp.responseText);
}
</script>

<%
	String loginname=(String)session.getAttribute("loginname");
	String area_id=(String)session.getAttribute("area_id");
	
	Map map = processRequest(request, out);
	String fileName = map== null?"":(String) map.get("fileName");
	
	System.out.println("param = " +fileName);
  
	if (fileName != null && fileName.length() > 0)
	{
		//System.out.println(application.getRealPath("/")+"hbbass/salesmanager/feedback/fileupload/"+fileName);
		/**/
		int count = importGroup(application.getRealPath("/") + "/hbbass/salesmanager/feedback/fileupload/" + fileName,loginname,area_id);
		
		//int count = 100;
		if (count > minCount)		
		{
			out.println("<script type='text/javascript'>alert('成功导入:"+ count + "条反馈记录，请到回流反馈号码查询页面中查询');</script>");
			/*
			out.println("<script type='text/javascript'>");			
			out.println("if(confirm('成功录入:"+ count + "条记录，确认保存？')){");
			out.println("alert('保存成功！');}");			
			out.println("else{");
			out.println("del('"+queryTime+"');}");
			*/
			out.println("</script>");
		}
		else if(count == -2)
			out.println("<script type='text/javascript'>alert('上传文件的移动号码中在反馈表中已存在，请核对后再重新上传');</script>");
		else if(count == -3)
			out.println("<script type='text/javascript'>alert('上传文件的移动号码中有重复号码，请核对后再重新上传');</script>");
		else
			out.println("<script type='text/javascript'>alert('操作失败,可能是格式不对或者条数太少');</script>");
	}	
	out.println("<script type='text/javascript'>history.go(-1);</script>");
%>
<%!
	static Logger LOG = Logger.getLogger("UploadFileAction");

	static int minCount = 0;

	Map processRequest(HttpServletRequest request,javax.servlet.jsp.JspWriter out) throws Exception
	{
		int MAX_SIZE = 10;
		ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory(
				1024 * 1024, new File(request.getSession().getServletContext()
						.getRealPath("/")
						+ "/hbbass/salesmanager/feedback/fileupload/temp")));
		sfu.setSizeMax(MAX_SIZE * 1024 * 1024);

		List fileList = null;
		try
		{
			fileList = sfu.parseRequest(request);
		} catch (SizeLimitExceededException e)// 处理文件尺寸过大异常
		{
			out.println("<script type='text/javascript'>alert('文件尺寸超过规定大小:"
					+ MAX_SIZE + "M');history.go(-1);</script>");
			return null;
		} catch (FileUploadException e)
		{
			LOG.error(e.getMessage(), e);
			throw e;
		}

		Map map = new HashMap();
		String fileName = null;
		String timeId = null;

		FileItem fileItem = null;
		for (int a = 0; a < fileList.size(); a++)
		{
			fileItem = (FileItem) fileList.get(a);
			
			// 忽略简单form字段而不是上传域的文件域(<input type="text" />等)
			if (fileItem == null || fileItem.isFormField())
			{
				continue;
			}
			
			if (fileItem.getName().length() == 0)
				continue;
			
			fileName = fileItem.getName();
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			
			if(fileItem.getContentType()!= null && fileItem.getContentType().indexOf("excel") < 0)
			{
				out.println("<script type='text/javascript'>alert('只能上传正确格式的EXCEL文件');history.go(-1);</script>");
				return null;
			}
			
			long size = fileItem.getSize();
			
			if (size == 0)
			{
				out.println("<script type='text/javascript'>alert('不允许上传空文件');history.go(-1);</script>");
				return null;
			}

			if (fileName.length() > 0 && fileName != null)
			{				
				String upfilepath = request.getSession().getServletContext()
						.getRealPath("/")
						+ "/hbbass/salesmanager/feedback/fileupload/";

				File f = new File(upfilepath + fileName);

				while (f.exists())
				{
					String dup = fileName.substring(0, fileName
							.lastIndexOf("."))
							+ "_dup"
							+ fileName.substring(fileName.lastIndexOf("."));
					f = new java.io.File(upfilepath + dup);
					LOG.info(fileName + "存在重复文件名,系统自动重命名");
					//out.println("<script type='text/javascript'>alert('"+ fileName + "存在重复文件名,系统自动重命名');</script>");
					fileName = dup;
				}
				fileItem.write(f);
				LOG.info("文件上传成功. 已保存为:" + fileName + " &nbsp;&nbsp;文件大小: "	+ size + "字节<p />");
				//out.println("<script type='text/javascript'>alert('文件上传成功. 已保存为:"+ fileName +",文件大小: " + size + "字节');</script>");
			}
		}
		map.put("fileName", fileName);
		return map;
	}

	static int importGroup(String filename,String loginname,String area_id) throws SQLException
	{
		/**/
		HashMap cityCodeMap = new HashMap();
		cityCodeMap.put("0","0");
		try{
			Connection cityConn=ConnectionManage.getInstance().getWEBConnection();
			PreparedStatement pst=cityConn.prepareStatement("select area_id,area_code from mk.bt_area");
			java.sql.ResultSet cityRs=pst.executeQuery();
			while(cityRs.next()){
				cityCodeMap.put(cityRs.getString(1),cityRs.getString(2));
			}
			
			cityRs.close();
			pst.close();
			cityConn.close();
		}catch(Exception ex){ex.printStackTrace();}
		
		
		ExcelReader excelReader = new ExcelReader();

		excelReader.openWorkbook(filename);
				
		List list = excelReader.sheetDataList();
		excelReader.closeWorkbook();

		int res = 0;
		if (list.size() > 0)
		{
			String[] lines = null;
			String[] lines1 = null;

			Connection conn = null;
			try
			{
				conn = ConnectionManage.getInstance().getConnection("java:comp/env/jdbc/JDBC_HB");
				conn.setAutoCommit(false);

				//Statement stat = conn.createStatement();				
				
				System.out.println("size = "+list.size());
				/*
				try
				{
					ps1.execute();
				}
				catch (SQLException e)
				{
					LOG.error("删除失败", e);
				}
				ps1.close();
				*/
				//String sqlexit=" select opp_nbr from COMPETE_OPPSTATE where opp_nbr='"+opp_nbr+"' or acc_nbr='"+acc_nbr+"' with ur";
				//System.out.println("------------"+sqlexit);
				ReportBean rb = new ReportBean();
				//判断是否有重复号码
				String nbrStr = "";
				/*
				rb.execute(sqlexit);
				int num = rb.getRowCount();			
				if(num > 0)
				{					
				}
				*/
				for (int i = 1; i < list.size(); i++)
				{
					lines1 = (String[]) list.get(i);
					if(i == 1) nbrStr += "'"+lines1[1].trim()+"'";
					else
					{
						if(nbrStr.indexOf(lines1[1].trim()) > 0)
						{
							System.out.println("------上传文件中有重复号码！");
							return -3;
						}
						else
						{
							nbrStr += ",'"+lines1[1].trim()+"'";
						}
					}
				}
				String sqlexit = "select opp_nbr from COMPETE_OPPSTATE where acc_nbr in ("+nbrStr+") with ur";
				System.out.println(sqlexit);
				rb.execute(sqlexit);
				int num = rb.getRowCount();			
				if(num > 0)
				{
					System.out.println("上传文件中跟后台表中有"+num+"个重复号码！");
					return -2;
				}
				//System.out.println("======query ok======");
				String sql = "insert into COMPETE_OPPSTATE(opp_nbr,acc_nbr,name,manager_id,area,police,date,state,insertdate,insertman,city_id) values(?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement ps = conn.prepareCall(sql);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				String currntTime = sdf.format(Calendar.getInstance().getTime());				
				//System.out.println("======"+currntTime+"======");
				for (int i = 1; i < list.size(); i++)
				{
					lines = (String[]) list.get(i);
					//System.out.println("------"+currntTime+","+loginname+","+cityCodeMap.get(area_id)+"------");
					ps.setString(1, lines[0].trim());
					ps.setString(2, lines[1].trim());
					ps.setString(3, lines[2].trim());
					ps.setString(4, lines[3].trim());
					ps.setString(5, lines[4].trim());
					ps.setString(6, lines[5].trim());
					ps.setString(7, lines[6].trim());
					ps.setString(8, "1");
					ps.setString(9, currntTime);
					ps.setString(10,loginname);
					ps.setString(11,(String)cityCodeMap.get(area_id));
					//System.out.println("======"+currntTime+","+loginname+","+cityCodeMap.get(area_id)+"======");
					try
					{
						ps.execute();
						res++;
					}catch (SQLException e1)
					{
						LOG.error("文件中第:" + i + "操作不成功",e1);
					}
				}

				ps.close();
				if (res < minCount)
					conn.rollback();
				else
					conn.commit();
			} catch (SQLException e)
			{
				conn.rollback();
				LOG.error(e.getMessage(), e);
				e.printStackTrace();
				return -1;
			} finally
			{
				if (conn != null)
				{
					conn.setAutoCommit(true);
					conn.close();
				}
			}

		}

		System.out.println(filename + ",执行成功:" + res + "条");
		return res;
	}

	static class ExcelReader
	{
		private Workbook workbook;

		public void ExcelReader()
		{
		}

		public void openWorkbook(String strPath)
		{
			try
			{
				this.workbook = Workbook.getWorkbook(new File(strPath));
				//System.out.println("===文件删除前===");
				System.out.println(new File(strPath).delete());
				//new File(strPath).deleteOnExit();
				//System.out.println("===文件删除后===");
			} catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		public List sheetDataList()
		{
			return sheetDataList(0);
		}

		public List sheetDataList(int sheetNum)
		{
			List list = null;

			if (this.workbook != null)
			{
				Sheet sheet = this.workbook.getSheet(sheetNum);
				list = new ArrayList();
				int columnsCount = sheet.getColumns();

				String[] lines = (String[]) null;
				for (int i = 0; i < sheet.getRows(); ++i)
				{
					lines = new String[columnsCount];
					Cell[] cells = sheet.getRow(i);
					
					for (int j = 0; j < columnsCount; ++j)
					{
						//lines[j] = cells[j].getContents();
						if (cells[j].getType() == CellType.DATE)
						{
							DateCell dateCell = (DateCell) cells[j];
							Date date = dateCell.getDate();
							lines[j] = new SimpleDateFormat("yyyy-MM-dd").format(date).toString();
						} else
						{							
							lines[j] = cells[j].getContents();
						}
						//System.out.println("lines["+j+"] = "+lines[j]);
					}
					list.add(lines);
				}
			}
			return list;
		}

		public void closeWorkbook()
		{
			if (this.workbook != null)
				this.workbook.close();
		}

	}%>
