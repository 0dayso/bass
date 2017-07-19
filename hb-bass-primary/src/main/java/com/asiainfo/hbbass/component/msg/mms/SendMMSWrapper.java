package com.asiainfo.hbbass.component.msg.mms;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

/**
 * 发送彩信类型，只要使用发送长文本用，
 * 没有实现发送图片声音的方法，参考main中可以使用，以后要使用时在实现方法即可
 * @author Mei Kefu
 * @date 2010-6-4
 */
public class SendMMSWrapper {

	private static Logger LOG = Logger.getLogger(SendMMSWrapper.class);

	/**
	 * 发送纯文本彩信，支持多个联系人发送，间隔500毫秒
	 * 
	 * @param contacts ：联系人用;分隔
	 * @param subject ：彩信主题
	 * @param content : 长文本
	 */
	public static boolean send(String contacts,String subject ,String content) {
		boolean res = false;
		if (content != null && content.length() > 0) {
			String[] arrConts = contacts.replaceAll("；", ";").split(";");
			int size=6;
			for (int i = 0; i < arrConts.length/size + (arrConts.length%size==0?0:1) ; i++) {
				
				try {
					int j = 0;
					
					String[] phone = new String[size];
					while(j<size && i*size+j < arrConts.length){
						phone[j]=arrConts[i*size+j];
						j++;
					}
					if(!oriSend(phone,subject ,content)){
						break;
					}else{
						res = true;
					}
					
				} catch (Exception e) {
					e.printStackTrace();
					LOG.error("发送失败:" + arrConts + content + e.getMessage(),
							e);
				}
				try {
					Thread.sleep(3000);
					LOG.debug("休眠3秒");
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
		
		String sql = "insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values(?,?,?,?,?)";
		Connection  conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "sender");
			ps.setInt(2, 0);
			ps.setString(3, "信息推送-彩信");
			ps.setString(4, contacts);
			ps.setString(5, (res?"":"失败")+subject);
			
			ps.execute();
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		
		return res;
	}

	/**
	 * 原始发彩信的方法
	 * 
	 * @param phone
	 * @param message
	 */
	public static boolean oriSend(String[] phone,String subject ,String message)  {
		// 需要用到mm7 包，暂时先注释
		System.out.println("需要用到mm7 包，暂时先注释");
		return false;
//		MM7SubmitReq localMM7SubmitReq = new MM7SubmitReq();
//		localMM7SubmitReq.setSubject(subject);
//		localMM7SubmitReq.setTransactionID(System.currentTimeMillis()+"");//随便传一个，还不知道有什么用
//		
//		for (int i = 0; i < phone.length; i++) {
//			if (phone[i]!=null && phone[i].trim().matches("[0-9]{11}")) {
//				localMM7SubmitReq.addTo(phone[i].trim());
//				LOG.debug(phone[i].trim());
//			} else {
//				LOG.debug(phone[i]+"号码不正确");
//			}
//		}
//		localMM7SubmitReq.setVASPID("817299");
//		localMM7SubmitReq.setVASID("1065845103");
//		localMM7SubmitReq.setServiceCode("0");
//		localMM7SubmitReq.setSenderAddress("1065845103");
//		localMM7SubmitReq.setDeliveryReport(false);
//		localMM7SubmitReq.setReadReply(false);
//		
//		localMM7SubmitReq.setContent(genContent(message));
//		//Websphere SendMMSWrapper.class.getClassLoader().getResource("") 有问题
//		//linux环境下catalina.out日志文件报错java.io.FileNotFoundException: usr/WebServer/Node2/webapps/ROOT/WEB-INF/classes/mm7Config.xml (No such file or directory)
//		//修改replaceAll("file:/", "") 成replaceAll("file:", "")这样就能找到文件了
//		MM7Config mm7Config= new MM7Config(SendMMSWrapper.class.getClassLoader().getResource("mm7Config.xml").toString().replaceAll("file:", ""));
//		mm7Config.setConnConfigName(SendMMSWrapper.class.getClassLoader().getResource("ConnConfig.xml").toString().replaceAll("file:", ""));
//		
//		MM7Sender mm7Sender = new MM7Sender(mm7Config);
//		MM7RSRes localMM7RSRes = mm7Sender.send(localMM7SubmitReq);
//		LOG.info("彩信发送结果 手机号码:" + phone + " 返回码 = " + localMM7RSRes.getStatusCode() + " 结果描述 =" + localMM7RSRes.getStatusText());
//		if(localMM7RSRes.getStatusCode()!=1000){
//			//throw new RuntimeException(localMM7RSRes.getStatusCode()+":"+localMM7RSRes.getStatusText());
//			return false;
//		}else{
//			return true;
//		}
		
	}
	/**
	 * 得到 MMContent 
	 * @param message
	 * @return
	 */
//	private static MMContent genContent(String message){
//		MMContent mainContent = new MMContent();
//		mainContent.setContentType(MMConstants.ContentType.MULTIPART_RELATED);
//		mainContent.setContentID("smil.smil");
//		mainContent.setContentLocation("smil.smil");
//		
//		MMContent contect = MMContent.createFromBytes(message.getBytes());
//		contect.setContentType("text/plain");
//		mainContent.addSubContent(contect);
//		
//		return mainContent;
//	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			oriSend(new String[]{"13697339119"}, "ceshi", "ceshi");
		} catch (Exception e) {
			e.printStackTrace();
		}
		//String str = "1.综合指标\r\n1.1.数据及信息业务使用客户数\r\n1.2.数据及信息业务付费客户数\r\n1.3.数据及信息业务收入比重\r\n1.4.语音增值业务使用客户数\r\n1.5.语音增值业务付费客户数\r\n1.6.IP通话费\r\n1.7.自有业务短信计费量";
		//生成目录
		/*String str="";
		try {
			BufferedReader br = new BufferedReader(new FileReader("c://aaa"));
			String line=null;
			while((line=br.readLine())!=null){
				str+=line+"\r\n";
			}
			br.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		System.out.println(str);
		
		
		
		
		
		String[] arr = str.split("\r\n");
		List root = new ArrayList();
		
		Map top = new HashMap();
		Map level1 = new HashMap();
		
		for (int i = 0; i < arr.length; i++) {
			String string = arr[i];
			if(string.length()>0){
				Map map = new HashMap();
				
				String[] level=string.split("\\.");
				
				map.put("id", string.substring(0, string.lastIndexOf(".")));
				map.put("text", string.substring(string.lastIndexOf(".")+1,string.length()));
				System.out.println(string);
				if(level.length==2){
					top.put(level[0], map);
					map.put("children", new ArrayList());
					root.add(map);
				}else if(level.length==3){
					level1.put(level[0]+level[1], map);
					List parent=(List)((Map)top.get(level[0])).get("children");
					map.put("leaf", Boolean.valueOf(true));
					parent.add(map);
				}else if(level.length==4){
					Map parent = (Map)level1.get(level[0]+level[1]);
					if(parent.containsKey("leaf"))parent.remove("leaf");
					
					if(!parent.containsKey("children")){
						parent.put("children", new ArrayList());
					}
					List pList = (List)parent.get("children");
					map.put("leaf", Boolean.valueOf(true));
					pList.add(map);
				}
			}
			
		}
		
		System.out.println(JsonHelper.getInstance().write(root));
		
		*/
		//生成HTML
	/*	StringBuilder sb = new StringBuilder();
		
		try {
			BufferedReader br = new BufferedReader(new FileReader("c://bbb"));
			String line=null;
			while((line=br.readLine())!=null){
				
				if(line.length()>0){
					
					if(line.startsWith("2")&&!line.matches("2[0-9]?\\..*")&&!line.startsWith("2)")){//是内容
						sb.append("<p><span style='font-family:Wingdings;'>&sup2;</span>").append(line.substring(1, line.length())).append("</p>");
					}else {
						int level = line.split("\\.").length - 1;
						//System.out.println(line);
						if(line.lastIndexOf(".")>0){
							sb.append("<a name='").append(line.substring(0, line.lastIndexOf("."))).append("'>");
						}
						sb.append("<h"+level+">").append(line).append("</h"+level+">");
						if(line.lastIndexOf(".")>0){
							sb.append("</a>");
						}
					}
					sb.append("\r\n");
				}
			}
			br.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		try {
			PrintWriter pw = new PrintWriter("c:\\bbb.htm");
			
			pw.write(sb.toString());
			pw.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}*/
		
		//System.out.println(sb);
	}

}
