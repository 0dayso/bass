package com.asiainfo.quartz;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.ZIPUtil;
import com.asiainfo.util.DateUtil;

/**
 * 集团客户欠费下载清单
 * @since 2012-10-24
 * @author yulei
 *
 *@version 1.1 
 *2013-3-19修改导出表名
 *
 *@version 1.2
 *2013-06-20修改动态配置地市
 */

//@Component
public class GroupBusinessTask {

	private static Map<String,String> areaMap=new HashMap<String,String>();
	/*static{
	
		areaMap.put("HB.WH", "武汉");
		areaMap.put("HB.EZ", "鄂州");
		areaMap.put("HB.XG", "孝感");
		areaMap.put("HB.ES", "恩施");
		areaMap.put("HB.HS", "黄石");
		areaMap.put("HB.YC", "宜昌");
		areaMap.put("HB.XF", "襄阳");
		areaMap.put("HB.JH", "江汉");
		areaMap.put("HB.XN", "咸宁");
		areaMap.put("HB.JZ", "荆州");
		areaMap.put("HB.JM", "荆门");
		areaMap.put("HB.SZ", "随州");
		areaMap.put("HB.HG", "黄冈");
		areaMap.put("HB.SY", "十堰");
		
	}*/
	private static Logger LOG = Logger.getLogger(GroupBusinessTask.class);
	
	private static final String db2LoadPath=System.getProperty("user.dir")+File.separator;
	
	private static long fileLength=0l;

	private JdbcTemplate jdbcTemplate;
	
	private FtpHelper ftp=new FtpHelper();
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}
	
	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw, false);
	}
	
	/**
	 * 集团业务每个月详单的导出工作
	 * 每月12号后台开始跑数据
	 *13号-28号 每天凌晨2点调度任务
	 * @Scheduled(cron="0/15 * * * * ?")
	 * @Scheduled(cron="0 0 2 12-27 * ?")
	 */
	//@Scheduled(cron="0 25 * * * ?")
	public void executeExport(){
		LOG.info("======开始集团业务的导出任务======");
		initCityMap();
		
		String fileName="GroupBusiness"+DateUtil.getLastMonth();
		
		LOG.info("======开始检查"+DateUtil.getLastMonth()+"集团业务任务是否完成======");
		boolean isDone=checkDone(fileName);
		boolean dataDone=false;
		LOG.info("======"+DateUtil.getLastMonth()+"集团业务任务状态为:"+(isDone==true?"已经完成":"未完成"));
		if(!isDone){
			
			dataDone=dataDone("ENT_GROUP_DEBT_DETAIL");
			if(dataDone){
				try{
					for(Iterator<Map.Entry<String,String>> it=areaMap.entrySet().iterator();it.hasNext();){
						Map.Entry<String,String> entry = (Map.Entry<String,String>) it.next();

						LOG.info("=========开始捞"+entry.getValue()+"的数据:"+DateUtil.getLastMonth());
						File file = new File(db2LoadPath+fileName+System.currentTimeMillis()+".bat"); // 创建脚本文件
						file.createNewFile();
						java.io.FileWriter fileWriter = new java.io.FileWriter(file);
						fileWriter.write(appendFileContent(fileName+entry.getKey(),entry.getValue())); // 写内容
						fileWriter.close();
						
						if(isWindows()){
							Runtime.getRuntime().exec("db2cmd "+file.getAbsolutePath());
							fileLength=System.currentTimeMillis();
							LOG.info("==="+entry.getValue()+"地市文件生成的时间为:"+DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
						}else{
							Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","sh "+file.getAbsolutePath()});
							fileLength=System.currentTimeMillis();
							LOG.info("==="+entry.getValue()+"地市文件生成的时间为:"+DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
						}
						
						//睡眠5秒，防止new file得到不存在的文件
						Thread.sleep(1000*5);
						
						ftpGroupBusiness(new File(db2LoadPath+fileName+entry.getKey()+".csv"),entry.getValue());
						
						if(file.exists())file.delete();
					
					}
					
					finishJob(fileName);
				}catch(Exception ex){
					ex.printStackTrace();
					LOG.info("=========捞数据过程中发生错误，请检查日志==========");
				}
			
			}
		}

		
	}
	
	/**
	 *因导出大概需要半个小时到1个小时的时间，需要判断导出文件是否导出完毕才能上传至ftp服务器
	 *通过判断文件大小来确定导出是否完成
	 */
	public void ftpGroupBusiness(File file,String areaName){
		
		LOG.info("=======开始判断集团导出文件是否生成完毕=========");
		String zipFilePath=db2LoadPath+"集团欠费清单"+DateUtil.getLastMonth()+"_"+areaName+".zip";

		while(true){
			if(file.exists()){
				LOG.info("=======集团导出文件存在:"+file.getAbsolutePath());
				LOG.info("=======集团导出文件当前大小:"+file.length()+"字节");
				if(fileLength==file.length()){
					LOG.info("=======集团导出文件生成完毕=========");
					File zipFile=null;
					File titleFile=null;
						try{
							LOG.info("=======开始打包集团导出文件为zip=========");
							
							ZIPUtil zu=ZIPUtil.getInstance();
							
							titleFile=appendTitle(file);
							
							zu.CreateZipFile(titleFile.getAbsolutePath(), zipFilePath);
							
							LOG.info("=======打包集团导出文件为zip完成=========");
							
							LOG.info("=======开始上传"+zipFilePath+"文件至ftp115服务器=========");
							ftp.connect();
							
							zipFile=new File(zipFilePath); 
							
							ftp.upload("/group/"+"集团欠费清单"+DateUtil.getLastMonth()+"_"+areaName+".zip", zipFile);
							
							if(file.exists())file.delete();
							
							if(zipFile.exists())zipFile.delete();
							
							if(titleFile.exists())titleFile.delete();
							
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
					LOG.info("=======集团导出文件正在导出数据，请稍后=========");
				}
			}else{
				LOG.info("=======集团导出还未生成，请检查=========");
				throw new RuntimeException("未生成GroupBusiness"+DateUtil.getLastMonth()+".csv文件请查看日志!");
			}
			
			try{
				Thread.sleep(1000*3);
			}catch(InterruptedException ex){
				ex.printStackTrace();
				LOG.info("线程睡眠过程出差",ex);
			}
		}
	}
	
	private boolean checkDone(String fileName){
		
		String sql = "select count(1) from FPF_QUARTZ_JOB_STATUS where file_name='" + fileName + "' and status='完成'";
		
		int result=jdbcTemplate.queryForObject(sql,Integer.class);
		
		if(result>0){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 设置此任务为完成状态
	 * @param prognames
	 * @param mid
	 * @param fileName
	 */
	private void finishJob(String fileName){
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
	
	private boolean isWindows(){
		String osName=System.getProperty("os.name");
		
		if(osName.indexOf("Window")>-1){
			return true;
		}
		return false;
	}
	
	private String appendFileContent(String fileName,String areaCode){
		StringBuffer sql=new StringBuffer("db2 connect to dwdb user pt using Ptmm221* \r\n");
		
		sql.append("db2 \"export to ").append(db2LoadPath).append(fileName+".csv of del ")
		.append("select area_name v1,groupname v2,groupcode v3,custgrade v4,staff_name v5,")
		.append("case when prod_code = 'WXCS' then '无线城市' ")
		.append("when prod_code = 'IMS'        then  'IMS' ")
		.append("when prod_code = 'YKT'        then  '一卡通' ")
		.append("when prod_code = 'YJT'        then  '宜居通' ")
		.append("when prod_code = 'QQT'        then  '亲情通' ")
		.append("when prod_code = 'SBT'        then  '社保通' ")
		.append("when prod_code = 'SXT'        then  '商信通' ")
		.append("when prod_code = 'QXT'        then  '企信通' ")
		.append("when prod_code = 'GJMP'       then  '集团签名' ")
		.append("when prod_code = 'QYYX'       then  '企业邮箱' ")
		.append("when prod_code = 'WXWZ'       then  '企业建站' ")
		.append("when prod_code = 'IDC'        then  '主机托管(新增业务)IDC' ")
		.append("when prod_code = 'PUSHMAIL'   then  '手机邮箱' ")
		.append("when prod_code = 'BLACKBERRY' then  'BLACKBERRY' ")
		.append("when prod_code = 'CRM_ZSK'    then  '掌上客' ")
		.append("when prod_code = 'HLZX'       then  '互联网直连' ")
		.append("when prod_code = 'VPN'        then  '数据专线' ")
		.append("when prod_code = 'PBX'        then  'PBX' ")
		.append("when prod_code = 'M2M_CARD'   then  'M2M(行业应用卡)' ")
		.append("when prod_code = 'GPRS_VPN'   then  'M2M(GPRS-VPN)' ")
		.append("when prod_code = 'YDGJ'       then  '移动管家' ")
		.append("when prod_code = 'INFO_SMS'   then  '效能快信' ")
		.append("when prod_code = 'TXGJ'       then  '集团通讯管家' ")
		.append("when prod_code = 'XXT'        then  '校信通' ")
		.append("when prod_code = 'PP_SE'      then  '企业随E行' ")
		.append("when prod_code = 'DL100'      then  '动力100' ")
		.append("when prod_code = 'BDCAR'      then  '车务通' ")
		.append("when prod_code = 'WXSH'       then  '无线商话' ")
		.append("when prod_code = 'SHGJ'       then  '商户管家' ")
		.append("when prod_code = 'JQT'        then  '集群通' ")
		.append("when prod_code = 'YD400'      then  '移动400' ")
		.append("when prod_code = 'CRING'      then  '集团彩铃' ")
		.append("when prod_code = 'ACB'        then  '爱车宝' end v6,acct_id v7,min_cycle_id v8,sum(a.bill_charge1) v9, ")
		.append("sum(a.bill_charge2) v10,sum(a.bill_charge3) v11, ")
		//.append("sum(a.bill_charge4) v12,sum(a.bill_charge5) v13 from nmk.detail_result a ")
		.append("sum(a.bill_charge4) v12,sum(a.bill_charge5) v13 from nmk.ent_group_debt_detail a ")
		.append("where cycle_id = "+DateUtil.getLastMonth()).append(" and area_name='").append(areaCode+"' ")
		.append(" group by area_name,groupname,groupcode,custgrade,staff_name,prod_code,acct_id,min_cycle_id with ur\" \r\n");
		
		sql.append("db2 disconnect all \r\n").append("exit \r\n");
		
		
		
		
		return sql.toString();
	}
	
	private boolean dataDone(String progname) {
		int today=Integer.parseInt(DateUtil.getCurrentDate("yyyyMM"));
		int date=0;
		boolean flag = false;
		try {
			date = jdbcTemplateDw.queryForObject("select etl_cycle_id from nwh.dp_etl_com where upper(etl_progname) =? and etl_state=3 with ur",new Object[] { progname },Integer.class);
			
			if (today==date) {
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
	 * 
	 * @param 生成完毕的csv-file
	 * @return 一个添加列名的新csv
	 */
	private File appendTitle(File file){
		String fileName=file.getName().substring(0,file.getName().indexOf("csv")-1)+"_title.csv";
		
		File rtnFile=new File(db2LoadPath+fileName);
		try{
			BufferedReader br=new BufferedReader(new FileReader(file));
			
			FileWriter fw=new FileWriter(rtnFile);
			
			fw.write("\"地市\",\"集团名称\",\"集团编码\",\"集团类型(A/B/C)\",\"客户经理\",\"集团产品名称\",\"账号编码\",\"最早欠费月\",\"当月非统付欠费(元)\",\"当年累计非统付欠费(元)\",\"当月统付欠费(元)\",\"当年累计统付欠费(元)\",\"当年以前产生的累计历史欠费\"\n");
			
			String str=null;
			while((str=br.readLine())!=null){
				fw.write(str);
				fw.write("\n");
			}
			fw.flush();
			
			fw.close();
			br.close();
		}catch(Exception ex){
			LOG.info("集团欠费清单定时候任务添加标题失败",ex);
		}
		return rtnFile;
	}
	
	/**
	 * 2013-06-20新增动态初始地市数据
	 */
	private void initCityMap(){
		if(areaMap.size()>0)return;
		
		List<Map<String,Object>> list = jdbcTemplate.queryForList("select area_code,area_name from mk.bt_area");
		
		for(int i=0;i<list.size();i++){
			areaMap.put(list.get(i).get("area_code").toString(), list.get(i).get("area_name").toString());
		}
	}
	
}
