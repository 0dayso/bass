package com.asiainfo.quartz;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.Util;

/**
 * 
 * @author zhangwei
 * @date 2015-01-25
 *	@see 自动统计报表点击率
 */
//@Component
public class RateJob {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}
	
	private static Logger LOG = Logger.getLogger(RateJob.class);

	//每天22点执行
	//@Scheduled(cron="0 0 22 * * ?")
//	//@Scheduled(cron="0 25 16 * * ?")
	public void defaultFunction() {

		// 得到所有在用报表
		String getReportSql = "select id from FPF_IRS_SUBJECT where status='在用'";
		List<Map<String, Object>> list = jdbcTemplate.queryForList(getReportSql);
		LOG.info("在用报表数："+list.size());
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> resultMap = (Map<String, Object>) list
						.get(i);
				int id = (Integer) resultMap.get("ID");
				String newSql = "select count(1) count\n" + "  from FPF_VISITLIST\n"
						+ " where uri like '%" + id + "%'\n"
						+ " and substr(char(create_dt),1,7)=substr(char(current date -1 month),1,7)\n"
						+ " group by track, track_mid";
				String reportSql = "select name from FPF_IRS_SUBJECT where id="
						+ id + "";
				List<Map<String, Object>> result = jdbcTemplate.queryForList(newSql);
				List<Map<String, Object>> reportResult = jdbcTemplate.queryForList(reportSql);
				if(result!=null && result.size()>0){
					Map<String, Object> resultmap =  (Map<String, Object>) result.get(0);
					Map<String, Object> reportResultmap =  (Map<String, Object>) reportResult.get(0);
					int count = (Integer) resultmap.get("COUNT");
					String name = String.valueOf(reportResultmap.get("NAME"));
					//LOG.info("报表点击数："+count);
					// 每张报表的点击率插入表中
					jdbcTemplate.update("insert into fpf_ratejob(TIME_ID, ID, NAME, COUNT) values("+Util.getTime(0, "日")+", " + id
							+ ",'" + name + "'," + count + ") ");
				}
			}
		}
	}
}
