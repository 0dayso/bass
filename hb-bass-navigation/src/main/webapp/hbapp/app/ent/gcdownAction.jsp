<%@page import="com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.io.File"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%!
static Logger LOG = Logger.getLogger("com.asiainfo.gcdownAction.jsp");
%>
<%
	String date = request.getParameter("date");
	String filename=request.getParameter("filename");
	String title= new String(request.getParameter("title"));
	String sql= new String(request.getParameter("sql"));	
	LOG.info("========="+sql);
	String realPath = application.getRealPath("/");
	LOG.info("realPaht"+realPath);
	LOG.info("area_id"+session.getAttribute("area_id"));
	String cityCode = (String)BassDimCache.getInstance().get("area_id").get((String)session.getAttribute("area_id"));
	String regionid= cityCode.replaceAll("HB.","");
	
	filename = date+"_"+filename+"_"+regionid;
	
	String path = "${mvcPath}/hbapp/app/ent/";
	File file = new File(realPath+path+"//"+filename+".csv");
	if(file.exists()){
		file.delete();
	}
	if(!file.exists()){
		LOG.info("文件不存在");
		File tmpFile = new File(realPath+path+"//"+filename+".tmp");
		if(!tmpFile.exists()){
			LOG.info("生成文件");
			Connection conn = ConnectionManage.getInstance().getDWConnection();
			BufferedWriter bw = null;
			try{
				
				bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tmpFile,true),"gbk"),1024*1024);
				bw.write(title);
				bw.write("\n");
				Statement stat = conn.createStatement();
				LOG.info("sql="+sql);
				ResultSet rs = stat.executeQuery(sql);
				ResultSetMetaData rsmd = rs.getMetaData();
				int size = rsmd.getColumnCount();
				StringBuffer sb = new StringBuffer(512);
				String value ="";
				while(rs.next()){
					value=rs.getString(1);
					if(value==null)value="";
					sb.append(value);
					for( int i=1;i<size;i++){
						value=rs.getString(i+1);
						if(value==null)value="";
						sb.append(",").append(value);
					}
					sb.append("\n");
					bw.write(sb.toString());
					if(sb.length()>0)sb.delete(0,sb.length());
				}
				bw.flush();
				bw.close();
				bw=null;
				LOG.info("文件生成成功"+tmpFile.getName());
				if(tmpFile.renameTo(file))
					LOG.info("文件改名成功:"+file.getName());
				else {
					LOG.warn("文件改名不成功:");
				}
			}
			catch(Exception e){
				e.printStackTrace();
				LOG.error(e.getMessage(),e);
				if(bw!=null){
					bw.close();
					bw=null;
				}
				LOG.error("报错，删除临时文件");
				tmpFile.delete();
				out.print("<script>alert('文件生成失败');window.history.go(-1);</script>");
				return;
			}finally{
				if(conn!=null){
					conn.close();
					conn=null;
				}
				tmpFile.delete();
			}
		}else if(tmpFile.exists())
		{
			out.print("<script>alert('文件正在生成中,可能需要一些时间,请稍候在来下载');window.history.go(-1);</script>");
			return;
		}
	}
	response.sendRedirect("${mvcPath}/hbapp/resources/old/commonFileDown.jsp?filepath="+path+"&filename="+filename+".csv");
%>
