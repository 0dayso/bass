package com.asiainfo.bass.apps.financepush;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hbbass.component.msg.mail.SendMail;
import com.asiainfo.hbbass.component.msg.mms.SendMMSWrapper;

@Repository
public class FinanceReportService {
	
	private static Logger LOG = Logger.getLogger(FinanceReportService.class);
	
	@Autowired
	private FinanceReportDao financeReportDao;
	
	/**
	 * 自动发送邮件
	 * @param headerStr	表头
	 * @param sql		
	 * @param groupId	发送组
	 * @param fileName	文件名称
	 * @param ds		数据库名称
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	public boolean sendEmailList(String headerStr, String sql, String group, String fileName, String ds, String monthId){
		boolean flag = true;
		try {
			sql = charFilter(sql);
			LOG.debug(sql);

			Object result = null;

			if (sql == null || sql.length() == 0) {
				result = new ArrayList();
			} else {
				List<Map<String,Object>> data = financeReportDao.getList(sql, ds);
				if(data!=null && data.size()>0){
//					String host = "10.25.36.95";
					String host = "172.16.121.102";
					String from = "hbbass@hb.chinamobile.com";
					String username = "hbbass@hb.chinamobile.com";
					String pwd = "hbcmcc01";
					String[] cc = null;
					String[] tos = getTo(group,2);
					String[] bcc = null;
					String content = genContent(ds, fileName+monthId,headerStr,sql);
					LOG.info("发送邮件的内容================="+content);
//					String[] tos  = {"zhangwei26@asiainfo-linkage.com","13476080947@139.com","lizj2@asiainfo-linkage.com"};
					SendMail.send(host, from, username, pwd, fileName+monthId, content, tos, cc, bcc);
					String strTo = tos[0];
					for (int i = 1; i < tos.length; i++) {
						strTo += ";"+ tos[i];
					}
					LOG.info("邮件接收人================="+strTo);
					//邮件发送表中增加日志
					//financeReportDao.insertVISITLIST(strTo, fileName);
				}
			}

		} catch (Exception e) {
			flag = false;
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			throw new RuntimeException(e.getMessage());
		}
		return flag;
	}
	
	/**
	 * 自动发送彩信
	 * @param headerStr	表头
	 * @param sql		
	 * @param groupId	发送组
	 * @param fileName	文件名称
	 * @param ds		数据库名称
	 * @return
	 */
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	public boolean sendMMSList(String headerStr, String sql, String group, String fileName, String ds,String monthId){
		boolean flag = false;
		try {
			String[] tos = getTo(group,1);
			String sender = "";
			if(tos!=null && tos.length>0){
				for(int i=0;i<tos.length;i++){
					sender = tos[i] + ";" + sender;
				}
				if(sender.endsWith(";")){
					sender = sender.substring(0, sender.length() - 1);
				}
			}
			sql = charFilter(sql);
			LOG.debug(sql);

			Object result = null;

			if (sql == null || sql.length() == 0) {
				result = new ArrayList();
			} else {
				List<Map<String,Object>> data = financeReportDao.getList(sql, ds);
				if(data!=null && data.size()>0){
//					sender = "13476228880;13476080947;13476228880";
					String content = getMMSContent(ds,headerStr,sql);
					LOG.info("发送彩信内容==============="+content);
					LOG.info("彩信接收人==============="+sender);
					flag = SendMMSWrapper.send(sender, fileName+monthId, content);
					LOG.info("彩信发送结果==============="+flag);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
			throw new RuntimeException(e.getMessage());
		}
		return flag;
	}
	
	/**
	 * 得到发送信息
	 * @param to	发送组
	 * @param flag	1、手机号 2、邮箱
	 * @return 返回发送的数组
	 */
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	public String[] getTo(String group,int flag){
		String sql = "select mobilephone,email from FPF_USER_USER where username in (select user_name from nwh.proc_alarm where group_id = ?)";
		List list = financeReportDao.getListByGroupId(sql,"web",group);
		List result = new ArrayList();
		int index = 0;
		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);
			String mobilephone = map.get("mobilephone").toString();
			String email = map.get("email").toString();
			if(flag==1){
				if(!"".equals(mobilephone) && mobilephone!=null){
					result.add(mobilephone);
				}
			}else if(flag==2){
				if(!"".equals(email) && email!=null){
					result.add(email);
				}
			}
		}
		if(result!=null && result.size()>0){
			String[] tos = new String[result.size()];
			for(int i=0;i<result.size();i++){
				tos[i] = (String)result.get(i);
			}
			return tos;
		}
		return null;
	}
	
	/**
	 * 去掉sql后面的非法字符
	 * 
	 * @param sql
	 * @return
	 */
	protected String charFilter(String sql) {
		sql = sql.trim();
		if (sql.endsWith(";")) {
			sql = sql.substring(0, sql.length() - 1);
		}
		return sql;
	}
	
	/**
	 * 得到发送彩信的内容
	 * @param ds			数据库名称
	 * @param headerStr		表头
	 * @param sql		
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String getMMSContent(String ds, String headerStr, String sql) {
		JsonHelper jsonHelper = JsonHelper.getInstance();
		StringBuffer header = new StringBuffer();
		Map _header = (Map) jsonHelper.read(headerStr.toUpperCase());

		try {
			int headRows = 1;
			Iterator iterator = _header.entrySet().iterator();
			if (iterator.hasNext()) {
				Map.Entry entry = (Map.Entry) iterator.next();
				Object obj = entry.getValue();

				if (obj instanceof List) {
					headRows = ((ArrayList) obj).size();
				}
			}

			List result = null;
			result = new ArrayList();
			SqlRowSet rs = financeReportDao.getRowSet(sql, ds);
			SqlRowSetMetaData rsmd = rs.getMetaData();
			List columnNames = new ArrayList();// 记录列的别名索引，避免数据库取的字段多余header的值会报错
			int size = rsmd.getColumnCount();
			String[] line = null;
			for (int j = 0; j < headRows; j++) {
				line = new String[size];
				int excelHeaderCount = 0;
				for (int i = 0; i < size ; i++) {

					String columnName = rsmd.getColumnName(i + 1);
					
					if (headRows == 1) {
						String value = "";
						Object obj = _header.get(columnName);

						if (obj instanceof List) {
							value = (String) ((List) obj).get(0);
						} else if (obj instanceof String) {
							value = (String) obj;
						} else {
							value = columnName;
						}

						value = (value == null ? "" : value);
						line[i] = value;

					} else {
						List list = (List) _header.get(columnName);
						if (list == null) {
							continue;
						}

						Object obj1 = list.get(j);

						if (obj1 == null) {
							continue;
						}

						line[excelHeaderCount] = (String) list.get(j);
						excelHeaderCount++;

					}
					if (j == 0) {// 只是第一次记录一次
						columnNames.add(columnName);
					}
				}
				result.add(line);
			}
			if (result != null && result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					String[] lines = (String[]) result.get(i);
					for (int j = 0; j < lines.length; j++) {
						header.append(lines[j]).append("    ");
					}
					header.append("\n");
				}
			}
			while (rs.next()) {
				line = new String[size];
				for (int j = 0; j < columnNames.size(); j++) {
					String value = rs.getString((String) columnNames.get(j));
					value = (value == null ? "" : value);
					line[j] = value;
					header.append(line[j]).append("    ");
				}
				header.append("\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return header.toString();
	}
	
	/**
	 * 得到发送Email正文内容
	 * @param ds		数据库名称
	 * @param headerStr	表头
	 * @param sql
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String getEmailContent(String ds, String headerStr, String sql) {
		JsonHelper jsonHelper = JsonHelper.getInstance();
		StringBuffer header = new StringBuffer();
		Map _header = (Map) jsonHelper.read(headerStr.toUpperCase());

			int headRows = 1;
			Iterator iterator = _header.entrySet().iterator();
			if (iterator.hasNext()) {
				Map.Entry entry = (Map.Entry) iterator.next();
				Object obj = entry.getValue();

				if (obj instanceof List) {
					headRows = ((ArrayList) obj).size();
				}
			}

			List result = null;
			result = new ArrayList();
		try {
			SqlRowSet rs = financeReportDao.getRowSet(sql,ds);
			SqlRowSetMetaData rsmd = rs.getMetaData();
			List columnNames = new ArrayList();// 记录列的别名索引，避免数据库取的字段多余header的值会报错
			int size = rsmd.getColumnCount();
			String[] line = null;
			for (int j = 0; j < headRows; j++) {
				line = new String[size];
				int excelHeaderCount = 0;
				for (int i = 0; i < size; i++) {

					String columnName = rsmd.getColumnName(i + 1);
					
					if (headRows == 1) {
						String value = "";
						Object obj = _header.get(columnName);

						if (obj instanceof List) {
							value = (String) ((List) obj).get(0);
						} else if (obj instanceof String) {
							value = (String) obj;
						} else {
							value = columnName;
						}

						value = (value == null ? "" : value);
						line[i] = value;

					} else {
						List list = (List) _header.get(columnName);
						if (list == null) {
							continue;
						}

						Object obj1 = list.get(j);

						if (obj1 == null) {
							continue;
						}

						line[excelHeaderCount] = (String) list.get(j);
						excelHeaderCount++;

					}
					if (j == 0) {// 只是第一次记录一次
						columnNames.add(columnName);
					}
				}
				result.add(line);
			}
			if (result != null && result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					String[] lines = (String[]) result.get(i);
					header.append("<tr>");
					int maxRow = 1;
					for (int j = 0; j < lines.length; j++) {
						int rowspan = 1;// 所占行数
						int colspan = 1;// 所占列数
						// 如果lines[j]不是#CSPAN和#RSPAN则判断1：下面的所有列的的值是否是#RSPAN，如果是则rowspan++；2判断此值此行后面列的值是否是#CSPAN，如果是则colspan++
						if (!"#CSPAN".equals(lines[j])
								&& !"#RSPAN".equals(lines[j]) && lines[j]!=null) {
							for (int k = i; k < result.size() - 1; k++) {
								String[] newLines = (String[]) result
										.get(k + 1);
								if ("#RSPAN".equals(newLines[j])) {
									rowspan++;
								} else {
									break;
								}
							}
							// 每一行的最后一位不做判断
							for (int k = j; k < lines.length - 1; k++) {
								if ("#CSPAN".equals(lines[k + 1])) {
									colspan++;
								} else {
									break;
								}
							}
							header.append("<td align='center' rowspan='")
									.append(rowspan).append("' colspan='")
									.append(colspan).append("'>")
									.append(lines[j]).append("</td>");
						}
						if(maxRow<rowspan){
							maxRow = rowspan;
						}
					}
					header.append("</tr>");
				}
			}
			while (rs.next()) {
				line = new String[size];
				header.append("<tr>");
				for (int j = 0; j < columnNames.size(); j++) {
					String value = rs.getString((String) columnNames.get(j));
					value = (value == null ? "" : value);
					line[j] = value;
					header.append("<td align='right'>").append(line[j]).append("</td>");
				}
				header.append("</tr>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return header.toString();
	}
	
	/**
	 * 得到发送Email邮件内容
	 * @param ds		数据库名称
	 * @param fileName	文件名称
	 * @param headerStr	表头
	 * @param sql		
	 * @return
	 */
	public String genContent(String ds,String fileName,String headerStr,String sql) {
		
		Calendar c = GregorianCalendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String pushDate=sdf.format(c.getTime());
		StringBuilder content = new StringBuilder();
		content.append("<div id='content' style='font-size:12px;'>")
			.append("<DIV>您好！</DIV>")
			.append("<DIV>    此邮件为：")
			.append(fileName+"</DIV>")
			.append("<DIV>")
			.append("<table align='center' width='99%' border='1' cellpadding='0' cellspacing='0'>")
			.append(getEmailContent(ds,headerStr,sql))
			.append("</table>")
			.append("</DIV>")
			.append("<DIV style='color:red'><br>本邮件由系统自动发出，发件人不会阅读此邮件，请不要直接回复此邮件</DIV><br>")
			.append("<div>&nbsp;&nbsp;&nbsp;&nbsp;致<br>礼!<br>湖北移动经营分析系统<br>")
			.append(pushDate)
			.append("</div></div>");
		return content.toString().intern();
	}

	@SuppressWarnings("rawtypes")
	public String getHeader(String sid){
		String header = "{";
		List list = financeReportDao.getHeader(sid);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map) list.get(i);
				String dataIndex = ((String) map.get("data_index")).toUpperCase();
				String name = (String) map.get("name");
				String[] arrName = name.split(",");
				if (header.length() > 1) {
					header+=",";
				} 
				header+="\""+dataIndex+"\":[";
				for (int j = 0; j < arrName.length; j++) {
					header+="\""+arrName[j]+"\",";
				}
				header = header.substring(0, header.length()-1);
				header+="]";
			}
		}
		header+="}";
		return header;
	}
}
