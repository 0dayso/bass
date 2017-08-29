package com.asiainfo.quartz;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.component.msg.mail.SendMailWrapper;
import com.asiainfo.util.DateUtil;

/**
 * 
 * @author yulei3
 * @date 2013-04-15
 *	@see 收入监控数据自动发送需求
 */
//@Component
public class SendMailJob {
	
	private static Logger LOG = Logger.getLogger(SendMailJob.class);
	
	private JdbcTemplate jdbcTemplate;
	
	private FtpHelper ftp=null;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	//每天8点至22点执行，每隔5分钟扫描一次
	//@Scheduled(cron="0 0/5 8-22 * * ?")
	public void defaultFunction(){
		
		//每行结果集是否发送标志
		boolean rowFlag=true;
		
		//发送邮件的日志
		String msg=null;
		
		//1132,截取头3位，如果精确到分钟的话，怕漏发
		Integer.parseInt(DateUtil.getCurrentDate("HHmm").substring(0,3));
		
		String sql="select * from FPF_SENDMAILJOB where status!='1'";
		
		List<Map<String,Object>> list=jdbcTemplate.queryForList(sql);
		
		LOG.info("====this time the job 's size is:"+list.size()+"=====");
		
		Map<String,Object> resultMap=null;
		for(int i=0;i<list.size();i++){
			rowFlag=true;
			
			msg="发送成功";
			
			resultMap=list.get(i);
			
//			String pushTime=(String)resultMap.get("pushtime");
			
			//11:32:00-----113200-----113
//			pushTime=pushTime.replaceAll(":", "").substring(0,3);
			
//			if(compareTime==Integer.parseInt(pushTime)){
				String[] to=null;
				
				String tempMail=(String)resultMap.get("mail");
				
				if(null==tempMail || tempMail.length()==0){
					LOG.info("收件人为空,此次不发送,请核实.");
					msg="收件人为空,此次不发送,请核实.";
					LOG.info("id="+(Long)resultMap.get("id")+",msg="+msg);
					updateStatus("2",msg,(Long)resultMap.get("id"));
					continue;
				}
				
				List<String> mailToList=new ArrayList<String>();
				
				for(int j=0;j<tempMail.split(";").length;j++){
					if(isMail(tempMail.split(";")[j])){
						mailToList.add(tempMail.split(";")[j]);
					}
				}
				
				if(mailToList.size()==0){
					LOG.info("收件人邮箱未通过验证,此次不发送,请核实.");
					msg="收件人邮箱未通过验证,此次不发送,请核实.";
					LOG.info("id="+(Long)resultMap.get("id")+",msg="+msg);
					updateStatus("2",msg,(Long)resultMap.get("id"));
					continue;
				}else{
					to=mailToList.toArray(new String[]{});
				}
				
				String subject=(String)resultMap.get("subject");
				String content=(String)resultMap.get("content");
				String fileServer=String.valueOf(resultMap.get("fileserver"));
				String attachments=String.valueOf(resultMap.get("attachment"));
				//xtb:xtb@10.25.5.50:21
				
				//判断是否包含附件及附件所在ip
				if(null!=attachments&&attachments.length()>0&&null!=fileServer&&fileServer.length()>0){
					String[] filePath=new String[attachments.split(";").length];
					for(int k=0;k<attachments.split(";").length;k++){	
						filePath[k]=attachments.split(";")[k];
						try{
							if(fileServer.equals("10.25.124.115")){
								ftp = new FtpHelper();
							}else{
								ftp=new FtpHelper("bass:bass@111w@"+fileServer+":21");
							}
							
							ftp.connect();
							
							ftp.down(filePath[k], new File(filePath[k]));
							
						}catch(Exception ex){
							LOG.warn("ftp下载文件过程异常",ex);
							rowFlag=false;
							msg="ftp下载文件过程异常";
						}finally{
							try{
								ftp.disconnect();
							}catch(IOException ex){
								LOG.warn("ftp断开异常",ex);
								//msg=ex.getMessage();
							}
						}
						
						//如果下载文件出错，则跳出迭代，此次不发送，待下次补发
						if(!rowFlag){
							break;
						}
					}
					
					if(rowFlag){
						try{
							SendMailWrapper.send(to, subject, content, filePath);
						}catch(Exception ex){
							LOG.warn("邮件发送失败",ex);
							msg="邮件发送失败";
						}
						LOG.info("id="+(Long)resultMap.get("id")+",msg="+msg);
						updateStatus(msg.equals("发送成功")?"1":"2",msg,(Long)resultMap.get("id"));
					}else{
						LOG.info("id="+(Long)resultMap.get("id")+",msg="+msg);
						updateStatus("2",msg,(Long)resultMap.get("id"));
					}
				}else{
					//不带附件的邮件发送
					try{
						SendMailWrapper.send(to, subject, content);
					}catch(Exception ex){
						LOG.warn("邮件发送失败", ex);
						msg="邮件发送失败";
					}
					LOG.info("id="+(Long)resultMap.get("id")+",msg="+msg);
					updateStatus(msg.equals("发送成功")?"1":"2",msg,(Long)resultMap.get("id"));
					
				}
//			}else{
//				continue;
//			}
		}
	}
	/**
	 * @see 判断邮件格式是否正确
	 * @param mail
	 * @return true/false
	 */
	public boolean isMail(String mail){
		String check = "^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]{2}|net|com|gov|mil|org|edu|int)$";
	    Pattern regex = Pattern.compile(check);
	    Matcher matcher = regex.matcher(mail);
		return matcher.matches();
	}
	
	/**
	 * @see 更新SENDMAILJOB状态、日志
	 * @param status
	 * @param msg
	 * @param id
	 */
	public void updateStatus(String status,String msg,Long id){
		LOG.info("id="+id+",msg="+msg);
		try{
			jdbcTemplate.update("update FPF_SENDMAILJOB set status=?,SENDDATE=current timestamp,SENDINFO=? where id=?",new Object[]{status,msg,id});
		}catch(Exception ex){
			LOG.warn("更新日志失败", ex);
		}
	}
}
