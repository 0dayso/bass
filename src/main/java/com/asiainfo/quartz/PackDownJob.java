package com.asiainfo.quartz;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.apps.controllers.RptNaviController;
import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.SendSmsWrapper;
import com.asiainfo.bass.components.models.Util;
import com.asiainfo.util.DateUtil;

/**
 * 打包下载的调度工作类
 * 
 * @author LiZhijian
 * @date 2011-11-28
 */
//@Component
@SuppressWarnings("unused")
public class PackDownJob {

	private static Logger LOG = Logger.getLogger(PackDownJob.class);

	//private static String developerPhone = "13476228880";

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw, false);
	}

//	@Autowired
//	private FileManage fileManage;

	@Autowired
	private RptNaviController rptNaviController;

	private FtpHelper ftp = new FtpHelper();

	// 这里的fileName不需要后缀,应为fileManage会自动加后缀
	//@Scheduled(cron="0 5 * * * ?")
	public void MkBaseFirstBatch() {
		String fileName = Util.getTime(-1, "月") + "市场基础报表（一）";
		down("SN_Market_Report1_1", "1776", fileName);
	}

	//@Scheduled(cron="0 10 * * * ?")
	public void MkBaseSecBatch() {
		String fileName = Util.getTime(-1, "月") + "市场基础报表（二）";
		down("SN_Market_Report1_2", "1777", fileName);
	}

	//@Scheduled(cron="0 15 * * * ?")
	public void MkBase2012Batch() {
		String fileName = Util.getTime(-1, "月") + "市场基础报表（2012）";
		down("SN_MarketRep_2012", "1945", fileName);
	}

//	//@Scheduled(cron="0 15 * * * ?")
//	public void DataBizFirstBatch() {
//		String fileName = Util.getTime(-1, "月") + "数据业务报表（一）";
//		down("SNDATA_REPORT", "1691", fileName);
//	}

	//@Scheduled(cron="0 20 * * * ?")
	public void DataBizSecBatch() {
		String fileName = Util.getTime(-1, "月") + "数据业务报表（二）";
		down("SNDATA_REPORT", "1692", fileName);
	}
	
//	public void MonthMarketBatch() {
//		String fileName = Util.getTime(-1, "月") + "月度市场情况报表";
//		down("ReportMonth_New_M", "98090587", fileName);
//	}
	
//	//@Scheduled(cron="0 30 * * * ?")
//	public void score139() {
//		String month = Util.getTime(-1, "月");
//		String fileName =  month + "之139邮箱用户积分";
//		String sql = "select t1.acc_nbr 客户号码,( CASE WHEN t3.brand='BrandGotone' THEN '全球通' WHEN t3.brand ='BrandMzone' THEN '动感地带' ELSE '神州行' END ) 品牌,balance 现有积分 from ( select SERV_ID,acc_nbr,BRAND,balance, exchange_SCORE from NMK.GMI_SERV_SCORE_"+month+"NEW where BRAND in ('BrandGotone','BrandMzone','BrandSzx') and balance>=100 and AREA_ID LIKE 'HB%')t1 inner join ( select distinct subsoid from nmk.mbuser_order_"+month+" a where a.spid='917270' and a.orderstate not in ('0','3','4'))t2 on t1.serv_id=t2.subsoid left join nwh.serv_"+month+"_M t3 on t1.serv_id=t3.serv_id with ur";
//		String[] procs = {"Gmi_ServScore","MSeUser"};
//		downAccordSQL(sql, procs, fileName);
//	}
//	
//	//@Scheduled(cron="0 35 * * * ?")
//	public void jiFen1() {
//		String month = Util.getTime(-1, "月");
//		String fileName =  month + "之参加过2011年积分成就梦想的用户";
//		String sql = "select ACC_NBR, (select n.area_name from NMK.REP_AREA_REGION n where n.area_code =suBstr(area_id,1,5)),(CASE WHEN brand ='BrandGotone' THEN '全球通' WHEN brand='BrandMzone' THEN '动感地带' ELSE '神州行' END),balance  FROM NMK.DW_JF_MX_"+month+" where state_tid ='US10' AND TYPE=1 WITH UR ";
//		String[] procs = {"DwJfcjmx"};
//		downAccordSQL(sql, procs, fileName);
//	}
//	
//	//@Scheduled(cron="0 36 * * * ?")
//	public void jiFen2() {
//		String month = Util.getTime(-1, "月");
//		String fileName =  month + "之兑换过积分或查询过积分的用户";
//		String sql = "select ACC_NBR, (select n.area_name from NMK.REP_AREA_REGION n where n.area_code =suBstr(area_id,1,5)),(CASE WHEN brand ='BrandGotone' THEN '全球通' WHEN brand='BrandMzone' THEN '动感地带' ELSE '神州行' END),balance  FROM NMK.DW_JF_MX_"+month+" where state_tid ='US10' AND TYPE=2 WITH UR ";
//		String[] procs = {"DwJfcjmx"};
//		downAccordSQL(sql, procs, fileName);
//	}
//	
//	//@Scheduled(cron="0 37 * * * ?")
//	public void jiFen3() {
//		String month = Util.getTime(-1, "月");
//		String fileName =  month + "之积分为100-500分的用户";
//		String sql = "select ACC_NBR, (select n.area_name from NMK.REP_AREA_REGION n where n.area_code =suBstr(area_id,1,5)),(CASE WHEN brand ='BrandGotone' THEN '全球通' WHEN brand='BrandMzone' THEN '动感地带' ELSE '神州行' END),balance  FROM NMK.DW_JF_MX_"+month+" where state_tid ='US10' AND TYPE=3 AND balance<=500 WITH UR ";
//		String[] procs = {"DwJfcjmx"};
//		downAccordSQL(sql, procs, fileName);
//	}
//	
//	//@Scheduled(cron="0 38 * * * ?")
//	public void jiFen4() {
//		String month = Util.getTime(-1, "月");
//		String fileName =  month + "之积分为501-2000分的用户";
//		String sql = "select ACC_NBR, (select n.area_name from NMK.REP_AREA_REGION n where n.area_code =suBstr(area_id,1,5)),(CASE WHEN brand ='BrandGotone' THEN '全球通' WHEN brand='BrandMzone' THEN '动感地带' ELSE '神州行' END),balance  FROM NMK.DW_JF_MX_"+month+" where state_tid ='US10' AND TYPE=3 AND balance>=501 AND balance<=2000 WITH UR ";
//		String[] procs = {"DwJfcjmx"};
//		downAccordSQL(sql, procs, fileName);
//	}
//	
//	//@Scheduled(cron="0 39 * * * ?")
//	public void jiFen5() {
//		String month = Util.getTime(-1, "月");
//		String fileName =  month + "之积分为2001分以上的用户";
//		String sql = "select ACC_NBR, (select n.area_name from NMK.REP_AREA_REGION n where n.area_code =suBstr(area_id,1,5)),(CASE WHEN brand ='BrandGotone' THEN '全球通' WHEN brand='BrandMzone' THEN '动感地带' ELSE '神州行' END),balance  FROM NMK.DW_JF_MX_"+month+" where state_tid ='US10' AND TYPE=3 AND balance>=2001 WITH UR ";
//		String[] procs = {"DwJfcjmx"};
//		downAccordSQL(sql, procs, fileName);
//	}
//
//	/**
//	 * 根据SQL生成数据
//	 * @param sql
//	 * @param procs
//	 * @param fileName
//	 */
//	private void downAccordSQL(String sql, String[] procs, String fileName) {
//		LOG.info("开始根据SQL调度生成文件:" + fileName);
//		boolean hasDone = false;
//		boolean dataReady = false;
//		hasDone = checkHasdone("", "", fileName);
//		if (!hasDone) {
//			for (int i = 0; i < procs.length; i++) {
//				if (isDone(procs[i]) == false) {
//					dataReady = false;
//					break;
//				} else {
//					dataReady = true;
//				}
//			}
//			if (dataReady) {
//				// 后台完成后进行打包，根据程序名判断mid
//				String msg = "";
//				String fileKind = "csv";
//				Map headMap = new HashMap();
//				File tempFile = tempFile = fileManage.executeNotDelete(jdbcTemplateDw, sql, fileName, headMap, fileKind, fileName);
//				
//				//add by yulei 2012-12-25新增打包zip功能需求R1212247 start
//				ZIPUtil zu=ZIPUtil.getInstance();
//				
//				String zipFilePath=System.getProperty("user.dir") + File.separator+fileName+".zip";
//				
//				zu.CreateZipFile(tempFile.getAbsolutePath(), zipFilePath);
//				
//				// 上传文件到ftp
//				File zipFile=null;
//				try {
//					ftp.connect();
//					String uploadFileName = "/jiFen/"+fileName+".zip";
////					if ("excel".equalsIgnoreCase(fileKind)) {
////						if (fileName.indexOf("积分") > 0) {
////							uploadFileName = "/jiFen/" + fileName + ".xls";
////						}
////					} else if ("csv".equalsIgnoreCase(fileKind)) {
////						if (fileName.indexOf("积分") > 0) {
////							uploadFileName = "/jiFen/" + fileName + ".csv";
////						}
////					}
////					ftp.upload(uploadFileName, tempFile);
//					zipFile=new File(zipFilePath);
//					ftp.upload(uploadFileName, zipFile);
//					finishJob("", "", fileName);
//				} catch (Exception e) {
//					msg = fileName + "调度失败";
//					sendSmsWrapper.send(developerPhone, msg);
//					e.printStackTrace();
//				} finally {
//					tempFile.delete();
//					zipFile.delete();
//					//add by yulei 2012-12-25新增打包zip功能需求R1212247 end
//					try {
//						ftp.disconnect();
//					} catch (IOException e) {
//						e.printStackTrace();
//					}
//				}
//				if (msg.equals("")) {
//					msg = fileName + "调度成功";
//					sendSmsWrapper.send(developerPhone, msg);
//				}
//			}
//		}
//		LOG.info("结束根据SQL调度生成文件:" + fileName);
//	}

	@SuppressWarnings("null")
	public void down(String prognames, String mid, String fileName) {
		LOG.info(fileName + "触发调度打包");
		boolean hasDone = false;
		boolean dataReady = false;
		hasDone = false;
		File tempFile = null;
		String msg = "";
		try {
			hasDone = checkHasdone(prognames, mid, fileName);
			if (!hasDone) {
				dataReady = isDone(prognames);
				if (dataReady) {
					LOG.info("开始执行打包:" + fileName);
					// 后台完成后进行打包，根据程序名判断mid
					if(prognames.equals("terminal_expetioncomuser_m")){
						//导出csv文件
						rptNaviController.downReport(mid, fileName, Util.getTime(-1, "月"));
						LOG.info("生成文件的文件名："+tempFile.getName());
					} else if(prognames.equals("yxkd_expetionstateuser_m")){
						rptNaviController.downReport(mid, fileName, Util.getTime(-1, "月"));
					} else if(prognames.equals("debt_expetionuser_m")){
						rptNaviController.downReport(mid, fileName, Util.getTime(-1, "月"));
					} else {
						tempFile = rptNaviController.down(mid, fileName);
						// 上传文件到ftp
				 
						ftp.connect();
						if (prognames.equals("SNDATA_REPORT")) {
							ftp.upload("/dataBiz/" + fileName + ".xls", tempFile);
						} else if (prognames.equals("ReportMonth_New_M")) {
							ftp.upload("/monthMarket/" + fileName + ".xls", tempFile);
						} else if (prognames.equals("ReportMonth_New_M")) {
							ftp.upload("/monthMarket/" + fileName + ".xls", tempFile);
						} else {
							ftp.upload("/marketBase/" + fileName + ".xls", tempFile);
						}
					}
					finishJob(prognames, mid, fileName);
					if (msg.equals("")) {
						msg += "菜单ID" + mid + "下的报表" + fileName + "打包成功";
						//sendSmsWrapper.send(developerPhone, msg);
					}
					LOG.info("结束执行打包:" + fileName);
				}
			}
		} catch (Exception e) {
			msg += "菜单ID" + mid + "下的报表" + fileName + "打包失败";
			 
			//sendSmsWrapper.send(developerPhone, msg);
			LOG.error(e.getMessage(), e);
		} finally {
			if (tempFile != null) {
				tempFile.delete();
			}
			try {
				ftp.disconnect();
			} catch (IOException e) {
				LOG.error(e.getMessage(), e);
			}
		}
		LOG.info(fileName + "调度打包运行完毕");
	}

	/**
	 * 检查调度是否已经成功完成过此任务
	 * 
	 * @param prognames
	 * @param mid
	 * @param fileName
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	private boolean checkHasdone(String prognames, String mid, String fileName) {
		String sql = "select * from FPF_QUARTZ_JOB_STATUS where file_name='" + fileName + "' and status='完成'";
		List list = jdbcTemplate.queryForList(sql);
		if (list != null && list.size() > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * 检查调度是否已经成功完成过此任务
	 * 
	 * @param prognames
	 * @param mid
	 * @param fileName
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	private boolean checkHasdone(String fileName) {
		String sql = "select * from FPF_QUARTZ_JOB_STATUS where file_name='" + fileName + "' and status='完成'";
		List list = jdbcTemplate.queryForList(sql);
		if (list != null && list.size() > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * 检查数据是否生成好
	 * 
	 * @param fileList
	 * @param targetFileCount
	 * @return
	 */
	private boolean checkDataReady(String url, String filename) {
		//getSaveDir()目录绝对路径
		File dir = new File(url) ;
		LOG.info("文件路径");
		//绝对路径下的名称
		File fl = new File( dir+File.separator+filename );	
		//是否是文件并且是否存在该文件,如果都是，则
		if (fl.isFile() && fl.exists()) {  
			return true;
		}else{
			return false;
		}
		
	}
	

	/**
	 * 检查后台数据是否完成
	 * 
	 * @param progname
	 * @return
	 */
	protected boolean isDone(String progname) {
		int date = 0;
		int today = Integer.parseInt(Util.getTime(0, "月"));
		boolean flag = false;
		try {
			date = jdbcTemplateDw.queryForObject("select etl_cycle_id from nwh.dp_etl_com where etl_progname =? and etl_state=3 with ur",Integer.class, new Object[] { progname });
			if (today == date) {
				flag = true;
				LOG.info("程序：" + progname + "数据库完成的批次号为:" + date + " 当前日期为:" + today + "，后台数据生成完毕");
			}else{
				LOG.info("程序：" + progname + "数据库完成的批次号为:" + date + " 当前日期为:" + today + "，后台程序还没跑完");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	/**
	 * 设置此任务为完成状态
	 * @param prognames
	 * @param mid
	 * @param fileName
	 */
	private void finishJob(String prognames, String mid, String fileName) throws Exception{
		String sql = "insert into FPF_QUARTZ_JOB_STATUS(job_name,job_class,file_name,status,create_time) values(" 
				+ "'" + this.getClass().getName() + "'"
				+ ",'" + this.getClass().getName() + "'"
				+ ",'" + fileName + "'"
				+ ",'完成'"
				+ ",'"+DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss")+"'"
				+ ")";
		jdbcTemplate.update(sql);
		LOG.info("设置" + fileName + "任务为完成状态");
	}

	public static void main(String[] args) {
	}

}
