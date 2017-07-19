package com.asiainfo.quartz;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.SendSmsWrapper;
import com.asiainfo.bass.components.models.Util;
import com.asiainfo.bass.components.models.ZIPUtil;
import com.asiainfo.util.DateUtil;

/**
 * SP调度每个月的3号
 * 
 * @author LiZhijian
 * @date 2011-08-05 步骤：1. 通过ftp工具或者命令行进入210服务器 /data/yanht/目录下 2.
 *       分别进入spzxf和spdebt目录下载最新数据月的文件 3. 将下载下来的文件分别打包 4. 将打包好的文件上传到115 的ftp服务器
 */
//@Component
@SuppressWarnings({"rawtypes","unused"})
public class SpSelfConsumeJob{
	private static Logger LOG = Logger.getLogger(SpSelfConsumeJob.class);

	private static String developerPhone = "18207144852";
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw);
	}

	@Autowired
	private SendSmsWrapper sendSmsWrapper;

	//@Scheduled(cron="0 16 * * * ?")
	public void execute() throws Exception {
		LOG.info("sp打包调度开始");
		FtpHelper ftp = new FtpHelper("pt:PTmm210*@10.25.124.210:21");
		FtpHelper ftp1 = new FtpHelper();// 115
		String month = Util.getTime(-2, "月");//前两个月
		String msg = "";
		boolean hasDoneZxf = false;
		boolean dataReadyZxf = false;
		boolean hasDoneDebt = false;
		boolean dataReadyDebt = false;
		try {
			// 处理自消费的逻辑
			ftp.connect();
			String remotePath = "/data/yanht/spzxf/" + month;
			LOG.info("remotePath=" + remotePath);
			List fileList = ftp.listFiles(remotePath);
			String fileName = "sp自消费情况分析" + month;
			hasDoneZxf = checkHasdone(fileName);
			// 判断自消费数据是否生成好，文件数是否正确
			dataReadyZxf = checkDataReady(fileList, 43);
			if (!hasDoneZxf && dataReadyZxf) {
				String userpath = System.getProperty("user.dir") + "/";
				String path = "";
				File file = null;
				// 防止文件没有生成时ftp字段断开;
				ftp.disconnect();
				ftp.connect();
				for (int i = 0; i < fileList.size(); i++) {
					file = new File(fileList.get(i).toString());
					path = remotePath + "/" + file.getName();
					LOG.info("filepath:" + path);
					ftp.down(path, new File(userpath + "spzxf/" + file.getName()));
					path = "";
				}
				LOG.info("sp自消费下载成功");
				ZIPUtil zu = ZIPUtil.getInstance();
				zu.CreateZipFile(userpath + "spzxf", userpath + "sp自消费情况分析" + month + ".zip");
				LOG.info("sp自消费打包成功");
				ftp1.connect();
				ftp1.upload("sp/spzxf/" + "sp自消费情况分析" + month + ".zip", new File(userpath + "sp自消费情况分析" + month + ".zip"));
				LOG.info("sp自消费上传115ftp服务器成功...");
				File localDir = new File(userpath + "spzxf");
				File[] tmpFiles = localDir.listFiles();
				if (tmpFiles != null) {
					LOG.info("删除本地文件:" + tmpFiles.length);
					for (int i = 0; i < tmpFiles.length; i++) {
						File tmpFile = tmpFiles[i];
						tmpFile.delete();
						LOG.info("delete file:" + tmpFile.getName());
					}
				}
				finishJob(fileName);
				msg = month + "sp自消费打包调度成功";
				sendSmsWrapper.send(developerPhone, msg);
			}

			// 处理欠费的逻辑
			remotePath = "/data/yanht/spdebt/" + month;
			fileList = ftp.listFiles(remotePath);
			fileName = "sp欠费情况分析" + month;
			hasDoneDebt = checkHasdone(fileName);
			dataReadyDebt = checkDataReady(fileList, 16);
			if (!hasDoneDebt && dataReadyDebt) {
				String userpath = System.getProperty("user.dir") + "/";
				String path = "";
				File file = null;
				// 防止文件没有生成时ftp字段断开;
				ftp.disconnect();
				ftp.connect();
				for (int i = 0; i < fileList.size(); i++) {
					file = new File(fileList.get(i).toString());
					path = remotePath + "/" + file.getName();
					LOG.info("filepath:" + path);
					ftp.down(path, new File(userpath + "spdebt/" + file.getName()));
					path = "";
				}
				LOG.info("sp欠费下载成功");
				ZIPUtil zu = ZIPUtil.getInstance();
				zu.CreateZipFile(userpath + "spdebt", userpath + "sp欠费情况分析" + month + ".zip");
				LOG.info("sp欠费打包成功");
				ftp1.disconnect();
				ftp1.connect();
				ftp1.upload("sp/spdebt/" + "sp欠费情况分析" + month + ".zip", new File(userpath + "sp欠费情况分析" + month + ".zip"));
				LOG.info("sp欠费上传115ftp服务器成功...");
				LOG.info("删除本地文件...");
				File localDir = new File(userpath + "spdebt");
				File[] tmpFiles = localDir.listFiles();
				if (tmpFiles != null) {
					LOG.info("删除本地文件:" + tmpFiles.length);
					for (int i = 0; i < tmpFiles.length; i++) {
						File tmpFile = tmpFiles[i];
						tmpFile.delete();
						LOG.info("delete file:" + tmpFile.getName());
					}
				}
				finishJob(fileName);
				msg = month + "sp欠费打包调度成功";
				sendSmsWrapper.send(developerPhone, msg);
			}
		} catch (Exception e) {
			msg = month + "sp打包调度失败";
			sendSmsWrapper.send(developerPhone, msg);
			e.printStackTrace();
		} finally {
			try {
				ftp.disconnect();
				ftp1.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		LOG.info("sp打包调度结束");
	}

	/**
	 * 检查数据是否生成好，文件数是否正确
	 * 
	 * @param fileList
	 * @param targetFileCount
	 * @return
	 */
	private boolean checkDataReady(List fileList, int targetFileCount) {
		if (fileList != null && fileList.size() == targetFileCount) {
			return true;
		} else {
			return false;
		}
	}
	
	private boolean checkHasdone(String fileName) {
		String sql = "select * from FPF_QUARTZ_JOB_STATUS where file_name='" + fileName + "' and status='完成'";
		List list = jdbcTemplate.queryForList(sql);
		if (list != null && list.size() > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	private void finishJob(String fileName) {
		String sql = "insert into FPF_QUARTZ_JOB_STATUS(job_name,job_class,file_name,status,create_time) values(" 
				+ "'" + this.getClass().getName() + "'"
				+ ",'" + this.getClass().getName() + "'"
				+ ",'" + fileName + "'"
				+ ",'完成'"
				+ ",'"+DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss")+"'"
				+ ")";
		jdbcTemplate.update(sql);
	}
}
