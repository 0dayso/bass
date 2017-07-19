package com.asiainfo.hbbass.kpiportal.customize;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.msg.mms.SendMMSWrapper;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * 
 * @author Mei Kefu
 * @date 2010-4-21
 */
public class KPIAuditJob {

	private int id = 0;

	private String name = "";

	@SuppressWarnings("unused")
	private String desc = "";

	@SuppressWarnings("unused")
	private String userId;

	private String contacts = "";

	private String date = "";

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private List<KPIAudit> kpiAudits = new ArrayList();

	private Logger LOG = Logger.getLogger(KPIAuditJob.class);

	public KPIAuditJob(int id) {
		this.id = id;
		init();
	}

	public void push() {
		try {
			String content = format();
			if (content.length() > 0) {
				String dateStr = "";
				if (date.length() == 8) {
					Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date.substring(6, 8)));
					SimpleDateFormat sdf = new SimpleDateFormat("M月dd日，E");
					dateStr = sdf.format(c.getTime());
				} else {
					dateStr = date.substring(0, 4) + "年，" + Integer.parseInt(date.substring(4, 6)) + "月";
				}

				String subject = "[" + name + "] " + dateStr;
				LOG.info(contacts + " " + subject + " " + content + "更多信息敬请关注经分前台。");

				hist(id, content);
				if (SendMMSWrapper.send(contacts, subject, content + "更多信息敬请关注经分前台。")) {
					release("成功");
				} else {
					release("失败");
				}
				/*
				 * String result="KPI告警["+name+"]统计周期["+date+"]"+content;
				 * if(content.length()>70){//大于70使用彩信发送
				 * result="统计周期["+date+"]"+content; String subject
				 * ="KPI告警["+name+"]";
				 * LOG.info(contacts+" "+subject+" "+result);
				 * SendMMSWrapper.send(contacts,subject ,result); }else{
				 * LOG.info(contacts+" "+result); SendSMSWrapper.send(contacts,
				 * result); }
				 */

			} else {
				release("未发送");
			}
		} catch (Exception e) {
			e.printStackTrace();
			release("失败");
		}
	}

	protected void hist(int id, String content) {
		Connection conn = null;

		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			String sql = "insert into kpi_audit_hist(gid,content) values (?,?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.setString(2, content);
			ps.execute();
			conn.commit();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}

	protected void release(String status) {
		Connection conn = null;

		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			String sql = "update kpi_audit_job set exec_time=current_timestamp,status=? where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ps.setInt(2, id);
			ps.execute();

			conn.commit();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}

	@SuppressWarnings("rawtypes")
	protected void init() {
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);

		try {
			List list = (List) sqlQuery.querys("select * from kpi_audit_job where id=" + id + " with ur");
			if (list.size() > 0) {
				Map auditJob = (Map) list.get(0);
				contacts = (String) auditJob.get("contacts");
				name = (String) auditJob.get("name");
				desc = (String) auditJob.get("desc");
				userId = (String) auditJob.get("user_id");
				// String auditGroup
				List auditList = (List) sqlQuery.querys("select * from kpi_audit where pid=" + id + " order by sort with ur");

				for (int i = 0; i < auditList.size(); i++) {
					Map map = (Map) auditList.get(i);

					String zbCode = (String) map.get("zb_code");
					String appName = (String) map.get("app_name");
					String areaCode = (String) map.get("area_code");
					String exp = (String) map.get("exp");

					KPIEntity kpiEntity = KPIPortalService.getKPI(appName, null, zbCode);
					if (kpiEntity != null && date.length() == 0) {
						date = kpiEntity.getDate();
					}
					KPIAudit kpiAudit = new KPIAudit(kpiEntity, exp);

					kpiAudit.setAreaCode(areaCode);

					kpiAudits.add(kpiAudit);
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sqlQuery.release();
		}

	}

	public String format() {
		String result = "";
		for (int i = 0; i < kpiAudits.size(); i++) {
			KPIAudit audit = kpiAudits.get(i);
			String text = audit.format();

			if (text.length() > 0) {
				result += text + "\n\n";
			}
		}

		return result;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		String date = "20101120";
		Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date.substring(6, 8)));
		SimpleDateFormat sdf = new SimpleDateFormat("M月dd日，E");
		System.out.println(sdf.format(c.getTime()));

	}

}
