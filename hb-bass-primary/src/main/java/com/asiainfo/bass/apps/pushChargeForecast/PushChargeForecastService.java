package com.asiainfo.bass.apps.pushChargeForecast;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.hbbass.app.action.OperMonitorAction;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.msg.mail.SendMail;

@Repository
@SuppressWarnings("rawtypes")
public class PushChargeForecastService {

	private static Logger LOG = Logger.getLogger(PushChargeForecastService.class);
	
	@Autowired
	private PushChargeForecastDao pushChargeForecastDao;
	
	public void send(String time ,String sender){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_YEAR, -1);
		String today = sdf.format(cal.getTime());
		if(!"".equals(time) && time!=null){
			today = time;
		}
		String content = getContent(today);
		String[] to = { "zhaojing@hb.chinamobile.com", "zhangtao2@hb.chinamobile.com", "maojingjing@hb.chinamobile.com", "xiatian@hb.chinamobile.com", "gaowen@hb.chinamobile.com", "guoxiaodong@hb.chinamobile.com", "wanchun@hb.chinamobile.com", "15926450672@139.com","13627225151@139.com","13607153889@139.com" };
		if(!"".equals(sender) && sender!=null){
			to = sender.split(",");
		}
		LOG.info("邮件发送内容======"+content);
		String host = "172.16.121.102";
		String from = "hbbass@hb.chinamobile.com";
		String username = "hbbass@hb.chinamobile.com";
		String pwd = "hbcmcc01";
		String[] cc = null;
		String[] bcc = null;
		SendMail.send(host, from, username, pwd, "经分系统"+today.substring(0,6)+"月收入预测", content, to, cc, bcc);
//		SendMailWrapper.send(to,  "经分系统"+today.substring(0,6)+"月收入预测", content);
		LOG.info("收入预测邮件发送完成====="+content);
		
		String strTo = to[0];
		for (int i = 1; i < to.length; i++) {
			strTo += ";"+ to[i];
		}
		pushChargeForecastDao.insertVISITLIST(strTo, today);
		LOG.info("邮件发送完毕======");
	}
	
	public String getContent(String today){
		String result = "";
		String sql = "select 1 from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id='"+today+"' with ur";
		@SuppressWarnings("unused")
		List list = pushChargeForecastDao.getList(sql);
		StringBuffer content = new StringBuffer();
		content.append("<DIV>&nbsp;&nbsp;&nbsp;&nbsp;")
			   .append(today.substring(0,6))
			   .append("月全省预测收入：<FONT color=red>@charge@</FONT>(万元)</DIV>")
			   .append("<br><table width='230px' style='font-size:12px;' cellspacing='0' cellpadding='0' border='0'>")
			   .append("	<tr bgcolor='yellow' align='right'><td>地市</td><td>")
			   .append(today.substring(0,6))
			   .append("预测收入</td><td>上月收入</td></tr>")
			   .append(" @cityData@ ")
			   .append("</table>");
		String[] sqls = OperMonitorAction.chargeForecastSQL();
		DecimalFormat df = new DecimalFormat("###,###.00");
		String sql2= sqls[1];
//		List list2 = pushChargeForecastDao.getList(sql2);
		
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
		try {
			List list2 = (List)sqlQuery.querys(sql2);
			StringBuilder cityData = new StringBuilder();
			for (int i = 0; i < list2.size(); i++) {
				String[] data = (String[])list2.get(i);
				
				cityData.append("	<tr align='right'><td>")
				.append(data[0])
				.append("</td><td >")
				.append(df.format(Double.valueOf(data[1])))
				.append("</td><td >")
				.append(df.format(Double.valueOf(data[2])))
				.append("</td></tr>");
				
			}
			
			result = content.toString();
			
			result = result.replaceAll("@cityData@",cityData.toString());
			
			String sql3 = sqls[2] + " with ur";
			LOG.info("收入预测SQL====="+sql3);
			List list1 = (List)sqlQuery.querys(sql3);
			
			result = result.replaceAll("@charge@", df.format(Double.valueOf(((String[])list1.get(0))[1])));
			LOG.info("收入预测conten====="+content);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public boolean check(String time){
		boolean flag = false;
		String title = "经分系统"+time.substring(0,6)+"月收入预测";
		List list = pushChargeForecastDao.getVISITLIST(title);
		if(list.size()>0 && list!=null){
			flag = true;
		}
		return flag;
	}
}
