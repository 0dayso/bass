package com.asiainfo.quartz;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.SendSmsWrapper;
import com.asiainfo.bass.components.models.Util;
import com.asiainfo.hbbass.component.msg.mail.SendMailWrapper;
import com.asiainfo.util.DateUtil;

//@Component
@SuppressWarnings({"rawtypes"})
public class MonthCityUserJob
{
  private static Logger LOG = Logger.getLogger(MonthCityUserJob.class);
  private static String developerPhone = "13476228880";
  private JdbcTemplate jdbcTemplate;
  private JdbcTemplate jdbcTemplateDw;

  @Autowired
  private SendSmsWrapper sendSmsWrapper;

  @Autowired
  public void setDataSource(DataSource dataSource)
  {
    this.jdbcTemplate = new JdbcTemplate(dataSource);
  }

  @Autowired
  public void setDataSourceDw(DataSource dataSourceDw)
  {
    this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw);
  }

  private List getResultData(String sql)
  {
    List list = this.jdbcTemplateDw.queryForList(sql);
    return list;
  }

  public String dynamicPiece(List list)
  {
    StringBuilder full = new StringBuilder();
    String width = "30%";
    full.append("<br><table width='" + width + "' style='font-size:12px;' cellspacing='1' cellpadding='0' border='0' bgcolor='#bbbbbb'>");
    StringBuilder piece = new StringBuilder();
    for (int i = 0; i < list.size(); ++i) {
      Map map = (Map)list.get(i);
      piece.append("\t<tr bgcolor='#FFFFFF' align='right'>");
      for (int j = 0; j < map.size(); ++j)
        if (j == 0)
          piece.append("<td>").append((String)map.get("channel_name")).append("</td>");
        else if (j == 1)
          piece.append("<td>").append((String)map.get("value")).append("</td>");


      piece.append("</tr>");
    }
    full.append(piece);
    full.append("</table>");
    return full.toString();
  }

  private boolean checkDataReady(List list)
  {
    int i = this.jdbcTemplate.queryForObject("select count(1) from nmk.cmcc_area",Integer.class);

    return ((list != null) && (list.size() == i));
  }

  private boolean checkHasdone(String fileName)
  {
    String sql = "select * from FPF_QUARTZ_JOB_STATUS where file_name='" + fileName + "' and status='完成'";
    List list = this.jdbcTemplate.queryForList(sql);

    return ((list != null) && (list.size() > 0));
  }

  private void finishJob(String fileName)
  {
    String sql = "insert into FPF_QUARTZ_JOB_STATUS(job_name,job_class,file_name,status,create_time) values('" + super.getClass().getName() + "'" + ",'" + super.getClass().getName() + "'" + ",'" + fileName + "'" + ",'完成'" + ",'" + DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss") + "'" + ")";
    this.jdbcTemplate.update(sql);
  }

  //@Scheduled(cron="0 6 * * * ?")
  public void execute() {
    LOG.info("分地市月到达用户数调度开始");
    boolean hasDone = false;
    boolean dataReady = false;
    String msg = "";
    String month = Util.getTime(-1, "月");
    String fileName = "分地市月到达用户数推送" + month;
    String sql = "select channel_name,char(bigint(value)) value from kpi_total_monthly where time_id='" + month + "' and zb_code='K20009' and length(channel_code)<=5 order by CHANNEL_CODE";
    String[] to = { "jizhigang@hb.chinamobile.com", "13419699009@139.com", "zhangtao2@hb.chinamobile.com", "15802750920@139.com" };

    String subject = "分地市月到达用户数";
    try {
      hasDone = checkHasdone(fileName);
      LOG.info(fileName+"===="+hasDone);
      if (!(hasDone)) {
        List list = getResultData(sql);
        LOG.info(fileName+"===="+list.size());
        dataReady = checkDataReady(list);
        if (dataReady) {
          LOG.info(fileName+"1===="+dataReady);
          String result = dynamicPiece(list);
          LOG.info("要发送的内容为：" + result);
          SendMailWrapper.send(to, subject, result);
          finishJob(fileName);
          msg = "分地市月到达用户数推送" + month + "成功";
          this.sendSmsWrapper.send(developerPhone, msg);
        }
      }
    } catch (Exception e) {
      msg = "分地市月到达用户数推送" + month + "出现异常";
      this.sendSmsWrapper.send(developerPhone, msg);
      LOG.info(e.getStackTrace().toString());
    }
    LOG.info("分地市月到达用户数调度结束");
  }
}