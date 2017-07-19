<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="bass.common.SQLSelect"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%
try
{
	String method = request.getParameter("method");
	String userid = (String)session.getAttribute("loginname");
	if(userid==null||userid.length()==0)userid="default";
	if("editReader".equalsIgnoreCase(method)){
		String FilePath = application.getRealPath("/")+"\\hbbass\\debt\\debtmain.txt";
		log.info("File Path:"+FilePath);
		BufferedReader br = new BufferedReader(new FileReader(FilePath));
		StringBuffer sb = new StringBuffer();
		String line="";
		while((line=br.readLine())!=null){
			sb.append(line).append("\r\n");
		}
		br.close();
		log.info(sb);
		request.setAttribute("result",sb.toString());
		request.getRequestDispatcher("../common2/translateData.jsp").forward(request,response);
	}else if("editWriter".equalsIgnoreCase(method)){
		String FilePath = application.getRealPath("/")+"\\hbbass\\debt\\debtmain.txt";
		log.info("File Path:"+FilePath);
		String msg = request.getParameter("msg");
		if(msg!=null)msg=new String(msg.getBytes("iso-8859-1"),"utf-8");
		log.info(msg);
		BufferedWriter bw = new BufferedWriter(new FileWriter(FilePath));
		bw.write(msg);
		bw.close();
	}else if ("fluctuating".equalsIgnoreCase(method)){
		String zbcode = request.getParameter("zbcode");
		String current = request.getParameter("date");
		String area = request.getParameter("area");
		String division = request.getParameter("division");
		String dim = request.getParameter("dim");
		String mappingTagName = request.getParameter("mappingTagName");
		
		String bizType = request.getParameter("bizType");
		if(bizType!=null)bizType=new String(bizType.getBytes("iso-8859-1"),"utf-8");
		
		String condition = request.getParameter("condition");
		
		if(condition.length()>0)condition += " and ";
		
		if(area.length()==5)condition += " area_id='"+area+"'";
		else condition += " county_id='"+area+"'";
		
		String date = "";
		String date1 = "";
		if(current!=null && current.split("@").length>0){
			date = current.split("@")[0];
			date1 = current.split("@")[1];
		}
		String table=request.getParameter("tableName");
		String dtype=request.getParameter("dtype");
		String sql="";
		
		if("BIZ_TYPE".equalsIgnoreCase(dim)){
			String sql1 = "select '语音'" 
				+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_call_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_call_@zbtype@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
				+" union all "
				+"select '月租'"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_rent_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_rent_@zbtype@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
				+" union all "
				+"select '增值'"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_incre_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_incre_@zbtype@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
				+" union all "
				+"select '数据'"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_data_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_data_@zbtype@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
				+" union all "
				+"select 'SP'"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_sp_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_sp_@zbtype@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
				+" union all "
				+"select '其它'"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_other_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_other_@zbtype@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@";
			sql1=sql1.replaceAll("@condition@",condition).replaceAll("@zbtype@",dtype).replaceAll("@division@",division).replaceAll("@date@",date).replaceAll("@date1@",date1).replaceAll("@table@",table);
			
			sql = sql1;
		}else if("2".equalsIgnoreCase(dim)){
			if("数据".equalsIgnoreCase(bizType)){
				String sql1 = "select '短信'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_data_sms_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_data_sms_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
					+" union all "
					+"select '彩信'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_data_mms_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_data_mms_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
					+" union all "
					+"select 'GPRS'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_data_gprs_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_data_gprs_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
					+" union all "
					+"select 'WAP'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_data_wap_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_data_wap_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@";
				sql1=sql1.replaceAll("@condition@",condition).replaceAll("@zbtype@",dtype).replaceAll("@division@",division).replaceAll("@date@",date).replaceAll("@date1@",date1).replaceAll("@table@",table);
				
				sql = sql1;
			}else if("语音".equalsIgnoreCase(bizType)){
				String sql1 = "select '本地通话'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_call_local_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_call_local_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
					+" union all "
					+"select '省际漫游'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_call_roam_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_call_roam_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
					+" union all "
					+"select '国内长途费'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_call_home_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_call_home_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@"
					+" union all "
					+"select '国际长途费'"
					+",value(decimal(sum(case when etl_cycle_id=@date@ then debtcharge_call_inter_@zbtype@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then debtcharge_call_inter_@zbtype@ end))/@division@,0)"
					+" from @table@ where etl_cycle_id in (@date@,@date1@)  and @condition@";
				sql1=sql1.replaceAll("@condition@",condition).replaceAll("@zbtype@",dtype).replaceAll("@division@",division).replaceAll("@date@",date).replaceAll("@date1@",date1).replaceAll("@table@",table);
					
				sql = sql1;
			}
			
		}else if("zb_name".equalsIgnoreCase(dim)){
			String sql1 = "select '@area@'"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then @zbcode@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then @zbcode@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@) and @condition@";
			
			sql1=sql1.replaceAll("@condition@",condition).replaceAll("@zbcode@",zbcode).replaceAll("@division@",division).replaceAll("@date@",date).replaceAll("@date1@",date1).replaceAll("@table@",table);
			
			sql = sql1;
		}else {
			String sql1 = "select @dim@"
				+",value(decimal(sum(case when etl_cycle_id=@date@ then @zbcode@ end))/@division@,0),value(decimal(sum(case when etl_cycle_id=@date1@ then @zbcode@ end))/@division@,0)"
				+" from @table@ where etl_cycle_id in (@date@,@date1@) and @condition@ group by @dim@ order by 2 desc fetch first 20 rows only ";
			
			sql1=sql1.replaceAll("@dim@",dim).replaceAll("@condition@",condition).replaceAll("@zbcode@",zbcode).replaceAll("@division@",division).replaceAll("@date@",date).replaceAll("@date1@",date1).replaceAll("@table@",table);
			
			sql = sql1;
		}
		
		log.info(zbcode+" 波动分析：SQL="+sql);
		
		Map mapping = null;
		if(mappingTagName!=null&&mappingTagName.length()>0)
		{
			mapping = (Map)com.asiainfo.hbbass.component.dimension.BassDimCache.getInstance().get(mappingTagName);
		}
		StringBuffer sb =new StringBuffer();
		java.sql.Connection conn = null;
		try
		{		
			List list = new SQLSelect().getTotalList(sql+" with ur");
			
			for (int i = 0; i < list.size(); i++)
			{
				String[] lines = (String[])list.get(i);
				sb.append(lines[0]).append(",");
				if(mapping!=null && mapping.size()>0)
				{
					sb.append(mapping.get(lines[0])).append(",");
				}
				else
				{
					sb.append(lines[0]).append(",");
				}
				
				for (int j = 1; j < lines.length; j++)
				{
					sb.append(lines[j]).append(",");
				}
				double d1 = Double.parseDouble(lines[1]);
				double d2 = Double.parseDouble(lines[2]);
				double result = (d2==0)?0D:(d1/d2-1);
				sb.append(result+"|");
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			log.error(e.getMessage(),e);
		}
		finally
		{
			try{
				if(conn!=null)conn.close();
			}
			catch (SQLException e){
				e.printStackTrace();
			}
		}
		
		request.setAttribute("result",sb.toString());
		request.getRequestDispatcher("../common2/translateData.jsp").forward(request,response);
	}
}
catch(Exception e)
{
	e.printStackTrace();
	log.error(e.getMessage(),e);
	throw e;
}
%>
<%!
static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("DebtAction");
%>