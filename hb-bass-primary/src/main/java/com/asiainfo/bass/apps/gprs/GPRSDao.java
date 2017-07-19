package com.asiainfo.bass.apps.gprs;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;


@Repository
@SuppressWarnings({"rawtypes"})
public class GPRSDao {
	
	private static Logger LOG = Logger.getLogger(GPRSDao.class);
	
	@Autowired
	private DataSource dataSource;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceDw;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceNl;
	
	public String getMaxTime(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		Map map = jdbcTemplate.queryForMap("select max(time_id) time_id from NMK.GPRS_ASSESS_MONTHLY");
		return map.get("time_id").toString();
	}
	
	public String getChannelCode(String cityid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		Map map = jdbcTemplate.queryForMap("select area_code from mk.bt_area where CHAR(area_id) = '"+cityid+"'");
		return map.get("area_code").toString();
	}
	
	public String getNameByCode(String zb_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		Map map = jdbcTemplate.queryForMap("select distinct zb_name from NMK.GPRS_ASSESS_MONTHLY where zb_code='"+zb_code+"'");
		return map.get("zb_name").toString();
	}
	
	public List getImageList(String time, String zb_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select channel_code,area_name,case when zb_code='D00008' then decimal(value,16,2) else decimal(trim(char(decimal(value*100,4,2))),4,2) end value from nmk.GPRS_ASSESS_MONTHLY inner join mk.bt_area on channel_code=area_code where length(channel_code)=5 and time_id='"+time+"' and zb_code='"+zb_code+"' order by value desc");
	}
	
	public List getCityTree(String time) {
		String sql = "select pid, channel_code, area_name, ind1, ind2, ind3, ind4, ind5, num\n"
				+ "  from (select '1' pid,\n"
				+ "               channel_code,\n"
				+ "               b.area_name,\n"
				+ "               ind1,\n"
				+ "               ind2,\n"
				+ "               ind3,\n"
				+ "               ind4,\n"
				+ "               ind5,\n"
				+ "               row_number() over(order by ind5 desc) num\n"
				+ "          from (select channel_code,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in\n"
				+ "                                  ('D00001', 'D00002', 'D00003', 'D00004', 'D00005',\n"
				+ "                                   'D00006', 'D00007', 'D00008', 'D00009') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind1,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in\n"
				+ "                                  ('D00010', 'D00011', 'D00012', 'D00013', 'D00014',\n"
				+ "                                   'D00015', 'D00016') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind2,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in\n"
				+ "                                  ('D00017', 'D00018', 'D00019', 'D00020', 'D00021') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind3,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in ('D00022', 'D00023') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind4,\n"
				+ "                       sum(result) as ind5\n"
				+ "                  from nmk.gprs_assess_monthly\n"
				+ "                 where time_id = '"+time+"'\n"
				+ "                --and length(channel_code) = 5\n"
				+ "                 group by channel_code) a\n"
				+ "         inner join mk.bt_area b on a.channel_code = b.area_code\n"
				+ "\n"
				+ "        union all\n"
				+ "        select substr(channel_code, 1, 5) pid,\n"
				+ "               channel_code,\n"
				+ "               b.county_name area_name,\n"
				+ "               ind1,\n"
				+ "               ind2,\n"
				+ "               ind3,\n"
				+ "               ind4,\n"
				+ "               ind5,\n"
				+ "               row_number() over(order by ind5 desc) num\n"
				+ "          from (select channel_code,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in\n"
				+ "                                  ('D00001', 'D00002', 'D00003', 'D00004', 'D00005',\n"
				+ "                                   'D00006', 'D00007', 'D00008', 'D00009') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind1,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in\n"
				+ "                                  ('D00010', 'D00011', 'D00012', 'D00013', 'D00014',\n"
				+ "                                   'D00015', 'D00016') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind2,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in\n"
				+ "                                  ('D00017', 'D00018', 'D00019', 'D00020', 'D00021') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind3,\n"
				+ "                       sum(case\n"
				+ "                             when zb_code in ('D00022', 'D00023') then\n"
				+ "                              result\n"
				+ "                             else\n"
				+ "                              0\n"
				+ "                           end) as ind4,\n"
				+ "                       sum(result) as ind5\n"
				+ "                  from nmk.gprs_assess_monthly\n"
				+ "                 where time_id = '"+time+"'\n"
				+ "                --and length(channel_code) = 5\n"
				+ "                 group by channel_code) a\n"
				+ "         inner join mk.bt_area_all b on a.channel_code = b.county_code) a\n"
				+ " order by channel_code, pid";
		LOG.info(sql);
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList(sql);
	}

}
