package com.asiainfo.quartz;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.apps.controllers.RptNaviController;
import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.ZIPUtil;
import com.asiainfo.util.DateUtil;

/**
 * 
 * @author yulei
 * @date 2013-1-5
 * @desc 优化packdownjob的写入csv方式，之前的方式容易内存溢出
 * 改用export的方式导出,需要服务器装备db2客户端
 * @desc 2013-7-24 yulei 添加数据库口令解密后动态传入的方式
 * @desc 2013-08-05 yulei 添加12580任务
 */
//@Component
@SuppressWarnings({"rawtypes","unused"})
public class ScoreDefaultJob {
	
	private static Logger LOG = Logger.getLogger(ScoreDefaultJob.class);
	
	private static final String db2LoadPath=System.getProperty("user.dir")+File.separator;
	
	private FtpHelper ftp=new FtpHelper();

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private RptNaviController rptNaviController;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw, false);
	}
	
//	//@Scheduled(cron="0 28 * * * ?")
//	public void xiaoqu(){
//		String month = DateUtil.getLastMonth();
//		String fileName = month + "价值小区报表";
//		String filePath = "/xiaoqu/";
//		String sql = 
//				"SELECT row_number() over() col_alias_0," +
//						" time_id col_alias_1," + 
//						" (select n.area_name" + 
//						"    from NMK.REP_AREA_REGION n" + 
//						"   where n.AREA_CODE = a.dim6) col_alias_2," + 
//						" value((select alias_county_name" + 
//						"   from (select id alias_county_code, name alias_county_name" + 
//						"     from nwh.bureau_tree_"+month+") alias_t2" + 
//						"  where alias_county_code = dim5)," + 
//						"       '') county," + 
//						" value((select alias_county_name" + 
//						"   from (select id alias_county_code, name alias_county_name" + 
//						"     from nwh.bureau_tree_"+month+") alias_t2" + 
//						"  where alias_county_code = dim1)," + 
//						"       '') county_bureau," + 
//						" dim2 col_alias_3," + 
//						" dim3 col_alias_4," + 
//						" ind1 col_alias_5," + 
//						" ind2 col_alias_6," + 
//						" ind3 col_alias_7," + 
//						" ind4 col_alias_8" + 
//						"  from report_total a" + 
//						" WHERE report_code = 'GsmCellSumRep'" + 
//						"   and time_id = "+month+"";
//		String[] procs = {"GsmCellSumRep"};
//		defaultJob("wbdb", filePath, sql, procs, fileName);
//	}
	
	//@Scheduled(cron="0 32 * * * ?")
	public void exceptioncomuser(){
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(new Date());
		calendar.add(Calendar.MONTH, -4);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		String month = sdf.format(calendar.getTime());
		
		String fileName = month + "代理商终端沉默串码清单";
		String filePath = "/exceptioncomuser/";
		String sql = " SELECT (SELECT n.area_name FROM NMK.REP_AREA_REGION n WHERE n.AREA_CODE = city_code) col_alias_0 ," +
				" CASE WHEN IS_ONLYSALE = 0 THEN '合约机' ELSE '裸机'  END col_alias_1 ,int(DATE(RECTIMESTAMPSALE)) / 100 col_alias_2 ," +
				" ACC_NBR col_alias_3 ,CUST_NAME col_alias_4 ,TERMINAL_TYPE col_alias_5 ,VALUE(RES_TYPE_NAME, RES_TYPE_ID) col_alias_6 ," +
				" INV_ID col_alias_7 ,OWNER_TYPE_NAME col_alias_8 ,VALUE(PRODID_NAME, PRODID) col_alias_9 ," +
				" VALUE(PRIVID_NAME, PRIVID) col_alias_10 ,VALUE(BD_PRIVID_NAME, '无') col_alias_11 ," +
				" DATE(BD_PRIVID_EFFDATE) col_alias_12 ,DATE(BD_PRIVID_EXPDATE) col_alias_13 ,DATE(RECTIMESTAMPSALE) col_alias_14 ," +
				" RECOPID col_alias_15 ,RECORGID col_alias_16 ,VALUE(CHANNEL_NAME, RECORGID) col_alias_17 ,'代理渠道' col_alias_18 ," +
				" EFF_DATE col_alias_19 ,STATE_NAME col_alias_20 ,'普通' col_alias_21 ,VALUE(BRAND_NAME, NBILLING_TID) col_alias_22 ," +
				" SUM_DEBT_CHARGE col_alias_23 ,CASE WHEN is_silence_one = 1 THEN '是' ELSE '否'  END col_alias_24 ," +
				" CASE WHEN is_silence_three = 1 THEN '是' ELSE '否'  END col_alias_25" +
				" FROM NMK.TERMINAL_EXPETIONCOMUSER_CM_" + month + "  where 1 = 1  ORDER BY city_code, acc_nbr";
		String[] procs = {"terminal_expetioncomuser_m"};
		
		defaultJob2("dwdb", filePath, sql, procs, fileName);
	}
	
	
	//@Scheduled(cron="0 20 * * * ?")
	public void realname(){
		String month = DateUtil.getLastMonth();
		String fileName = month + "入疆入藏漫游号码清单";
		String filePath = "/realname/";
		String sql = "select AREA_CODE, ACC_NBR, ETL_CYCLE_ID, ROAM_MONTH, ROAM_PROV_ID, SF_SM, CUST_NAME, ID_NAME, CERT_NO, HOUSEADDR, CERT_NUM, USER_GRADE, EFF_DATE, CHANNEL_CODE, CHANNEL_NAME, CHL_TYPE  from NMK.MINGAN_AREA_ROAM_NUM where ETL_CYCLE_ID="+month+"";
		String[] procs = {"MinGanAreaRoam"};
		String countSql = "select count(1) from NMK.MINGAN_AREA_ROAM_NUM where ETL_CYCLE_ID="+month+"";
		defaultJob("wbdb", filePath, sql, procs, fileName, countSql);
	}
	
	//@Scheduled(cron="0 14 * * * ?")
	public void debt(){
		String month = DateUtil.getLastMonth();
		String fileName = month + "集团统付账户欠费报表提取";
		String filePath = "/debt/";
		String sql = "select AREA_NAME,COUNTY_NAME,MBUSER_ID,ACC_NBR,CUST_NAME,ACCT_ID,ACCT_MIN_CYCLE_ID,MAX_CYCLE_ID,DEBT_MONTH,DEBT_SECTION,THIRD_SUM_DEBT_CHARGE,HZ_CHARGE,VIRTUALCODE,GROUPNAME,PROD_ID,PROD_NAME,STAFF_NAME,PAYCYCLE,OVER_CYCLE_CHARGE from NWH.REPORT_GROUP_DEBT_"+month+"";
		String[] procs = {"GroupDebtData"};
		String countSql = "select count(1) from NWH.REPORT_GROUP_DEBT_"+month+"";
		defaultJob("wbdb", filePath, sql, procs, fileName, countSql);
	}
	
//	//@Scheduled(cron = "0 0/5 8-23 * * ?")
	//@Scheduled(cron="0 35 * * * ?")
	public void termimalPackage(){
		String month = DateUtil.getLastMonth();
		String fileName = month + "终端通信行为异常明细清单";
		String filePath = "/termimalPackage/";
		String sql = "SELECT (SELECT n.area_name          FROM NMK.REP_AREA_REGION n         WHERE n.AREA_CODE = city_code) col_alias_0      ,ACC_NBR col_alias_1      ,TERMINAL_TYPE col_alias_2      ,VALUE(RES_TYPE_NAME, RES_TYPE_ID) col_alias_3      ,INV_ID col_alias_4      ,OWNER_TYPE_NAME col_alias_5      ,VALUE(PRODID_NAME, PRODID) col_alias_6      ,VALUE(PRIVID_NAME, PRIVID) col_alias_7      ,VALUE(BD_PRIVID_NAME, '无') col_alias_8      ,DATE(RECTIMESTAMPSALE) col_alias_9      ,RECOPID col_alias_10      ,RECORGID col_alias_11      ,VALUE(CHANNEL_NAME, RECORGID) col_alias_12      ,EFF_DATE col_alias_13      ,STATE_NAME col_alias_14      ,VALUE(BRAND_NAME, NBILLING_TID) col_alias_15      ,SUM_CALL_DURA col_alias_16      ,SUM_CALL_TIMES col_alias_17      ,SMMS_TIMES col_alias_18      ,SUM_INFO_LEN col_alias_19      ,BILL_CHARGE col_alias_20      ,IF_DEBT_CHARGE col_alias_21      ,IF_SUM_DEBT_CHARGE col_alias_22      ,IF_CALL col_alias_23      ,IF_IMEI_ACTIVE col_alias_24      ,DEBT_CHARGE col_alias_25      ,SUM_DEBT_CHARGE col_alias_26  FROM nmk.terminal_expetioncomuser_"+month+"";
		String[] procs = {"terminal_expetioncomuser_m"};
		defaultJob2("dwdb", filePath, sql, procs, fileName);
	}
	
	//@Scheduled(cron="0 40 * * * ?")
	public void broadbandPackage(){
		String month = DateUtil.getLastMonth();
		String fileName = month + "宽带优惠与信控时间不一致明细清单";
		String filePath = "/broadbandPackage/";
		String sql = "SELECT (SELECT n.area_name FROM NMK.REP_AREA_REGION n WHERE n.AREA_CODE = city_code) col_alias_0,REG_ORG_ID col_alias_1      ,value(channel_name,'未知') col_alias_2      ,prod_name col_alias_3      ,acc_nbr col_alias_4      ,PRODNAME col_alias_5      ,band col_alias_6      ,state_name col_alias_7      ,DATE(applydate) col_alias_8      ,applyoperid col_alias_9      ,staff_name col_alias_10      ,DATE(prodid_exp_date) col_alias_11      ,DATE(ABATE_DATE) col_alias_12      ,same_date_flag col_alias_13      ,differ_days col_alias_14      ,SERV_NAME col_alias_15  FROM nmk.yxkd_differtimeuser_"+month+"";
		String[] procs = {"yxkd_expetionstateuser_m"};
		defaultJob2("dwdb", filePath, sql, procs, fileName);
	}
	
	//@Scheduled(cron="0 45 * * * ?")
	public void arrears(){
		String month = DateUtil.getLastMonth();
		String fileName = month + "欠费超3个月的明细清单";
		String filePath = "/termimalPackage/";
		String sql = "SELECT VALUE((SELECT n.area_name FROM NMK.REP_AREA_REGION n WHERE n.AREA_CODE = SUBSTR(city_id, 1, 5)),'湖北') col_alias_0,       USER_TYPE col_alias_1,       USER_KIND col_alias_2,       MCUST_NAME col_alias_3,       ACCT_ID col_alias_4,       ACC_NBR col_alias_5,       CUST_NAME col_alias_6,       STATE_NAME col_alias_7,       DATE(EXP_DATE) col_alias_8,       DATE(EFF_DATE) col_alias_9,       VALUE(NET_AGE, 0) col_alias_10,       PAY_TYPE col_alias_11,       VALUE(NBILLING_NAME, '未知') col_alias_12,       CREDIT_CHARGE col_alias_13,       CREDITLEVEL_NAME col_alias_14,       BASECREDIT col_alias_15,       MIN_CYCLE_ID col_alias_16,       MAX_CYCLE_ID col_alias_17,       DEBT_CYCLE_NUM col_alias_18,       SUM_DEBT_CHARGE col_alias_19,       CUR_BALANCE col_alias_20,       BD_FEE_ID col_alias_21,       BD_FEE_NAME col_alias_22,       DEBT_CHARGE col_alias_23,       YZ_BILL_CHARGE col_alias_24,       BDTH_BILL_CHARGE col_alias_25,       GNMY_BILL_CHARGE col_alias_26,       GJMY_BILL_CHARGE col_alias_27,       GNCT_BILL_CHARGE col_alias_28,       GJCT_BILL_CHARGE col_alias_29,       IP_BILL_CHARGE col_alias_30,       SMS_BILL_CHARGE col_alias_31,       MMS_BILL_CHARGE col_alias_32,       NET_BILL_CHARGE col_alias_33,       OTHER_BILL_CHARGE col_alias_34,       BD_BILL_CHARGE col_alias_35,       DISCT_BILL_CHARGE col_alias_36  FROM NMK.THREEMONTHDEBT_EXPETIONUSER_"+month+" ";
		String[] procs = {"debt_expetionuser_m"};
		defaultJob2("dwdb", filePath, sql, procs, fileName);
	}
	
	//@Scheduled(cron="0 50 * * * ?")
	public void stop(){
		String month = DateUtil.getLastMonth();
		String fileName = month + "全月停机明细清单的数据";
		String filePath = "/stop/";
		String sql = "SELECT VALUE((SELECT n.area_name FROM NMK.REP_AREA_REGION n WHERE n.AREA_CODE = SUBSTR(city_id, 1, 5)),'湖北') col_alias_0, USER_TYPE col_alias_1, USER_KIND col_alias_2, MCUST_NAME col_alias_3, ACCT_ID col_alias_4, ACC_NBR col_alias_5, CUST_NAME col_alias_6, DATE(EXP_DATE) col_alias_7, EXP_DAY_NUM col_alias_8, DATE(EFF_DATE) col_alias_9, VALUE(NET_AGE, 0) col_alias_10, PAY_TYPE col_alias_11, VALUE(NBILLING_NAME, '未知') col_alias_12, CREDIT_CHARGE col_alias_13, CREDITLEVEL_NAME col_alias_14, BASECREDIT col_alias_15, MIN_CYCLE_ID col_alias_16, MAX_CYCLE_ID col_alias_17, SUM_DEBT_CHARGE col_alias_18, CUR_BALANCE col_alias_19, BD_FEE_ID col_alias_20, BD_FEE_NAME col_alias_21, SUM_CALL_DURA col_alias_22, GPRS_DURA col_alias_23, WLAN_TOTALBYTE col_alias_24, MSMS_TIMES col_alias_25, DEBT_CHARGE col_alias_26, YZ_BILL_CHARGE col_alias_27, BDTH_BILL_CHARGE col_alias_28, GNMY_BILL_CHARGE col_alias_29, GJMY_BILL_CHARGE col_alias_30, GNCT_BILL_CHARGE col_alias_31, GJCT_BILL_CHARGE col_alias_32, IP_BILL_CHARGE col_alias_33, SMS_BILL_CHARGE col_alias_34, MMS_BILL_CHARGE col_alias_35, NET_BILL_CHARGE col_alias_36, OTHER_BILL_CHARGE col_alias_37, BD_BILL_CHARGE col_alias_38, DISCT_BILL_CHARGE col_alias_39  FROM NMK.STOPDEBT_EXPETIONUSER_"+month+"";
		String[] procs = {"debt_expetionuser_m"};
		defaultJob2("dwdb", filePath, sql, procs, fileName);
	}
	
	private void defaultJob(String ds, String filePath, String sql, String[] procs, String fileName, String countSql){
		LOG.info("开始根据SQL调度生成文件:" + fileName);
		boolean hasDone = false;
		boolean dataReady = false;
		hasDone = checkHasdone("", "", fileName);
		if (!hasDone) {
			for (int i = 0; i < procs.length; i++) {
				if (isDone(procs[i]) == false) {
					dataReady = false;
					break;
				} else {
					dataReady = true;
				}
			}
			int count = 0;
			count = getCount(ds,countSql);
			if(count>0){
				if (dataReady) {
					LOG.info("=======开始根据sql生成bat文件=======");
					File file=null;
					String[] title=null;
					if(fileName.indexOf("139")>0){
						title=new String[]{"客户号码","品牌","现有积分"};
					}else if(fileName.indexOf("小区")>-1){
						title = new String[]{"序号" ,"统计时间" ,"地区" ,"县域" ,"小区名称" ,"LAC" ,"CI" ,"语音业务量（分钟）" ,"语音收入(元)" ,"数据业务量（MB）" ,"数据收入(元)"};
					}else if(fileName.indexOf("_400&114明细")>-1){
						title = new String[]{"其他号码","地市","用户号码"};
					}else if(fileName.indexOf("TD智能机渗透率")>-1){
						title=new String[]{"分母手机号","分母集团级别","分子手机号","分子集团级别"};
					}else if(fileName.indexOf("流量套餐普及率")>-1){
						title=new String[]{"分母手机号","分母集团级别","分子手机号","分子集团级别"};
					}else if(fileName.indexOf("通信助手减免两个月用户")>-1){
						title=new String[]{"手机号"};
					}else if(fileName.indexOf("通信助手1元包用户")>-1){
						title=new String[]{"手机号"};
					}else if(fileName.indexOf("省内移动用户拨打114、携程、艺龙等目标用户号码")>-1){
						title=new String[]{"地市","省内移动用户拨打114、携程、艺龙等目标用户号码"};
					}else if(fileName.indexOf("2G高流量客户主要集中的集团客户")>-1){
						title=new String[]{"2G高流量用户手机号码" ,"地市ID" ,"集团客户编码" ,"集团客户名称" ,"客户经理" ,"集团客户级别" ,"打标成员数量" ,"是否智能" ,"是否TD" ,"操作系统" ,"终端品牌" ,"终端机型" ,"是否WCDMA" ,"机龄(天)" ,"ARPU(元)" ,"MOU(分钟)" ,"流量(M)" ,"2G流量" ,"TD覆盖区域内的2G流量" ,"捆绑类型(1话费2终端3礼品)" ,"捆绑到期时间"};
					}else if(fileName.indexOf("2G高流量&TD终端&疑似锁网客户")>-1){
						title=new String[]{"2G高流量用户手机号码" ,"地市ID" ,"是否智能" ,"是否TD" ,"操作系统" ,"终端品牌" ,"终端机型" ,"是否WCDMA" ,"机龄(天)" ,"ARPU(元)" ,"MOU(分钟)" ,"流量(M)" ,"2G流量" ,"TD覆盖区域内的2G流量" ,"捆绑类型(1话费2终端3礼品)" ,"捆绑到期时间"};
					}else if(fileName.indexOf("2G高流量&非TD终端&机龄>=12月的客户")>-1){
						title=new String[]{"2G高流量用户手机号码" ,"地市ID" ,"是否智能" ,"是否TD" ,"操作系统" ,"终端品牌" ,"终端机型" ,"是否WCDMA" ,"机龄(天)" ,"ARPU(元)" ,"MOU(分钟)" ,"流量(M)" ,"2G流量" ,"TD覆盖区域内的2G流量" ,"捆绑类型(1话费2终端3礼品)" ,"捆绑到期时间"};
					}else if(fileName.indexOf("TD终端用户活跃度较高但TD信号弱覆盖的区域")>-1){
						title=new String[]{"地市","小区","T网覆盖级别","LAC","CELL","TD终端客户数","TD终端客户G网流量"};
					}else if(fileName.indexOf("TD终端用户活跃度较高但TD信号弱覆盖的区域")>-1){
						title=new String[]{"地市","小区","T网覆盖级别","LAC","CELL","TD终端客户数","TD终端客户G网流量"};
					}else if(fileName.indexOf("入疆入藏漫游号码清单")>-1){
						title=new String[]{"手机号码","漫游年月","连续漫游月数","漫游敏感地区","是否实名","姓名","证件类型","证件ID","证件地址","一证多号数","客户星级","入网时间","入网网点ID","入网网点名称","入网网点类型"};
					}else if(fileName.indexOf("集团统付账户欠费报表提取")>-1){
						title=new String[]{"地市", "区县", "用户id（出账）", "手机号码（出账）", "用户姓名", "统付的账户", "最小欠费周期", "最大欠费周期", "欠费账龄", "欠费区间", "欠费金额（元）", "坏账金额（元）", "集团id", "集团名称", "产品ID", "产品名称","客户经理 ","缴费周期","超出缴费周期的欠费"};
					}else{
						title=new String[]{"客户号码","地市","品牌","现有积分"};
					}
					try{
						file = new File(db2LoadPath+System.currentTimeMillis()+".bat"); // 创建脚本文件
						file.createNewFile();
						java.io.FileWriter fileWriter = new java.io.FileWriter(file); 
						fileWriter.write(appendFileContent(ds,fileName,sql)); // 写内容
						fileWriter.close();
						
						if(isWindows()){
							Runtime.getRuntime().exec("db2cmd "+file.getAbsolutePath());
							LOG.info("==="+fileName+"文件生成的时间为:"+DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
						}else{
							Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","sh "+file.getAbsolutePath()});
							LOG.info("==="+fileName+"文件生成的时间为:"+DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
						}
						
						Thread.sleep(1000*30);
						
						ftpScore(filePath, new File(db2LoadPath+fileName+".csv"),title);
						
						finishJob("", "", fileName);
					}catch(Exception ex){
						ex.printStackTrace();
						LOG.info(fileName+"数据生成出错",ex);
					}finally{
						if(file.exists())file.delete();
					}
					
				}
				
			}
		}
	}
	
	private void defaultJob2(String ds, String filePath, String sql,
			String[] procs, String fileName) {
		LOG.info("开始根据SQL调度生成文件:" + fileName);
		boolean hasDone = false;
		boolean dataReady = false;
		int count = 0;
		hasDone = checkHasdone("", "", fileName);
		if (!hasDone) {
			for (int i = 0; i < procs.length; i++) {
				if (isDone(procs[i]) == false) {
					dataReady = false;
					break;
				} else {
					dataReady = true;
				}
			}
			if (dataReady) {
				LOG.info("=======开始根据sql生成bat文件=======");
				File file = null;
				String[] title = null;
				try {
					file = new File(db2LoadPath + System.currentTimeMillis()
							+ ".bat"); // 创建脚本文件
					file.createNewFile();
					java.io.FileWriter fileWriter = new java.io.FileWriter(file);
					fileWriter.write(appendFileContent(ds, fileName, sql)); // 写内容
					fileWriter.close();

					if (isWindows()) {
						Runtime.getRuntime().exec(
								"db2cmd " + file.getAbsolutePath());
						LOG.info("==="
								+ fileName
								+ "文件生成的时间为:"
								+ DateUtil
										.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
					} else {
						Runtime.getRuntime().exec(
								new String[] { "/bin/sh", "-c",
										"sh " + file.getAbsolutePath() });
						LOG.info("==="
								+ fileName
								+ "文件生成的时间为:"
								+ DateUtil
										.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
					}

					Thread.sleep(1000 * 30);

					ftpScore(filePath,
							new File(db2LoadPath + fileName + ".csv"), title);

					finishJob("", "", fileName);
				} catch (Exception ex) {
					ex.printStackTrace();
					LOG.info(fileName + "数据生成出错", ex);
				} finally {
					if (file.exists())
						file.delete();
				}

			}

		}
	}
	
	private void ftpScore(String filePath, File file,String[] title){
		
		LOG.info("=======开始判断数据导出文件是否生成完毕=========");
		String zipFilePath=db2LoadPath+file.getName().substring(0,file.getName().indexOf("."))+".zip";
		long fileLength=-1l;

		while(true){
			if(file.exists()){
				if(fileLength==file.length()){
					LOG.info("======="+file.getName()+"文件生成完毕=========");
					File zipFile=null;
						try{
							LOG.info("=======开始打包"+file.getName()+"导出文件为zip=========");
							
							ZIPUtil zu=ZIPUtil.getInstance();
							
							zu.CreateZipFile(file.getAbsolutePath(), zipFilePath);
							
							LOG.info("=======打包"+file.getName()+"导出文件为zip完成=========");
							
							LOG.info("=======开始上传"+zipFilePath+"文件至ftp115服务器=========");
							
							ftp.connect();
							
							zipFile=new File(zipFilePath); 
							if(filePath.indexOf("#")>-1){
								String[] filePaths = filePath.split("#");
								for(int i=0;i<filePaths.length;i++){
									ftp.upload(filePaths[i]+zipFile.getName(), zipFile);
									if(file.exists())file.delete();
									
									if(zipFile.exists())zipFile.delete();
								}
							}else{
								ftp.upload(filePath+zipFile.getName(), zipFile);
								if(file.exists())file.delete();
								
								if(zipFile.exists())zipFile.delete();
							}
							
							
							break;
						}catch(Exception ex){
							ex.printStackTrace();
							LOG.info("上传过程出差",ex);
						}finally{
							try{
								ftp.disconnect();
							}catch(IOException ex){
								ex.printStackTrace();
								LOG.info("上传过程出差",ex);
							}
						}
					
					
				}else{
					fileLength=file.length();
					LOG.info("=======积分文件正在导出数据，请稍后=========");
				}
			}else{
				LOG.info("=======积分导出还未生成，请检查=========");
				throw new RuntimeException("未生成"+file.getName()+"文件请查看日志!");
			}
			
			try{
				Thread.sleep(1000*30);
			}catch(InterruptedException ex){
				ex.printStackTrace();
				LOG.info("线程睡眠过程出差",ex);
			}
		}
	}
	
	/**
	 * 判断当前系统
	 * @return
	 */
	private boolean isWindows(){
		String osName=System.getProperty("os.name");
		
		if(osName.indexOf("Window")>-1){
			return true;
		}
		return false;
	}
	/**
	 * 检查后台数据是否完成
	 * 
	 * @param progname
	 * @return
	 */
	protected boolean isDone(String progname) {
		int date = 0;
		int today = Integer.parseInt(DateUtil.getCurrentDate("yyyyMM"));
		boolean flag = false;
		try {
			date = jdbcTemplateDw.queryForObject("select etl_cycle_id from nwh.dp_etl_com where etl_progname =? and etl_state=3 with ur", new Object[] { progname },Integer.class);
			if (today == date) {
				flag = true;
				LOG.info("程序：" + progname + "数据库完成的批次号为:" + date + " 当前日期为:" + today + "，后台数据生成完毕");
			} else{
				LOG.info("程序：" + progname + "数据库完成的批次号为:" + date + " 当前日期为:" + today + "，后台程序还没跑完");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	protected boolean isDone1(String progname) {
		int date = 0;
		int today = Integer.parseInt(DateUtil.getCurrentDate("yyyyMM"));
		boolean flag = false;
		try {
			date = jdbcTemplateDw.queryForObject("select substr(etl_cycle_id,1,6) from nwh.dp_etl_com where etl_progname =? and etl_state=3 with ur", new Object[] { progname },Integer.class);
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
	
	/**
	 * 检查调度是否已经成功完成过此任务
	 * 
	 * @param prognames
	 * @param mid
	 * @param fileName
	 * @return
	 */
	private boolean checkHasdone(String prognames, String mid, String fileName) {
		String sql = "select count(1) from FPF_QUARTZ_JOB_STATUS where file_name='" + fileName + "' and status='完成'";
		int i = jdbcTemplate.queryForObject(sql,Integer.class);
		if (i>0) {
			LOG.info("====="+fileName+"的任务已经完成=====");
			return true;
		} else {
			LOG.info("====="+fileName+"的任务未完成=====");
			return false;
		}
	}
	
	private int getCount(String ds, String sql){
		int count = 0;
		if(ds.equals("dwdb")){
			LOG.info("sql:"+sql);
			List list = jdbcTemplateDw.queryForList(sql);
			count = list.size();
		}else if(ds.equals("wbdb")){
			count = jdbcTemplate.queryForObject(sql,Integer.class);
		}
		LOG.info("打包下载记录数====================="+count);
		return count;
	}
	
	/**
	 * 拼接bat文件内容
	 * @param fileName
	 * @return fileContent
	 */
	private String appendFileContent(String ds, String fileName, String sql){
		StringBuffer sb=new StringBuffer();
		String dbPwd="";
		if(ds.equals("dwdb")){
			sb.append("db2 connect to dwdb user pt using Ptmm221*\r\n");
		}else{
			sb.append("db2 connect to wbdb user pt using Ptmm217*\r\n");
		}
		sb.append("db2 connect to ").append(ds).append(" user pt using ").append(dbPwd).append(" \r\n");
		sb.append("db2 \"export to ").append(db2LoadPath).append(fileName+".csv of del ")
		.append(sql).append("\" \r\n")
		.append("db2 disconnect all \r\n").append("exit \r\n");
		LOG.info("139导出命令============"+sb);
		return sb.toString();
	}
	/**
	 * 
	 * @param file
	 * @param title
	 * @return 添加标题的csv文件
	 */
	private File appendTitle(File file,String[] title){
		String fileName=file.getName().substring(0,file.getName().indexOf("."))+"_title.csv";
		
		File rtnFile=new File(db2LoadPath+fileName);
		try{
			BufferedReader br=new BufferedReader(new FileReader(file));
			
			FileWriter fw=new FileWriter(rtnFile);
			if(title.length>0){
				for(int i=0;i<title.length;i++){
					if(i==0){
						fw.write("\""+title[i]);
						fw.write("\"");
					}else{
						fw.write(",\""+title[i]);
						fw.write("\"");
					}
				}
				fw.write("\n");
				
				String str=null;
				while((str=br.readLine())!=null){
					fw.write(str);
					fw.write("\n");
				}
				fw.flush();
				
				fw.close();
				br.close();
			}
		}catch(Exception ex){
			LOG.info("数据定时候任务添加标题失败",ex);
		}
		return rtnFile;
	}
}
