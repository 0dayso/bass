package com.asiainfo.bass.apps.jinku;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.log4j.Logger;
import org.dom4j.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import org.springframework.stereotype.Repository;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import com.asiainfo.bass.components.models.DES;
import com.asiainfo.bass.components.models.ExcelWriter;
import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.Util;
import com.asiainfo.bass.components.sax.SaxHandler;
import com.asiainfo.hbbass.ws.bo.MenuInfoBO;
import com.asiainfo.hbbass.ws.common.Constant;
import com.asiainfo.hbbass.ws.interfaceclient.InterfaceClient;

@Repository
public class JinkuService {

	private static Logger log = Logger.getLogger(JinkuService.class);
	//获取ftp用户信息url
	private  static final String GETFTPUSERURL="http://10.30.44.27:8080/DocumentServer/app.do?method=getFtp";
	//加密文件url
	private static final String ENCRYPTURL="http://10.30.44.27:8080/DocumentServer/app.do?method=fileUploadFinish";

	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceNl;

	@Autowired
	private DataSource dataSourceDw;
	
	@Autowired
	private JinkuDao jinkuDao;

	@SuppressWarnings("rawtypes")
	public File createTempFile(String ds, String sql, String fileName,
			Map header, String fileType) {
		sql = charFilter(sql);

		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(ds))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(ds)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		return executeNotDelete(jdbcTemplate, sql, fileName, header, fileType,
				null);
	}

	public HashMap<String,String> encryptFile(File tempFile, HttpServletRequest request) {
		HashMap<String,String> result = new HashMap<String,String>();
		String flag = "2";
		result.put("msg", "未加水印文件生成成功。");
		try {
			// 得到用户云平台信息
			HashMap<String,String> userInfoMap = getFtpInfo(request.getSession());
			if ("1".equals(userInfoMap.get("flag").toString())) {
				result.put("msg", "得到用户云平台信息。");
				result.put("username", userInfoMap.get("username")
						.toString());
				result.put("password", userInfoMap.get("password")
						.toString());
				result.put("filename", tempFile.getName());
				result.put("remotePath", userInfoMap.get("path").toString());
			} else {
				log.info("得到用户云平台信息失败:" + userInfoMap.get("msg").toString());
				result.put("flag", flag);
				result.put("msg", "得到用户云平台信息失败:"+userInfoMap.get("msg").toString());
				return result;
			}
			flag ="3";
			log.info("tempFile.Name========="+tempFile.getName());
			String path4A = userInfoMap.get("path").toString() + "\\"
					+ tempFile.getName();
			// 上传4A云平台
			boolean uploadFlag = uploadFtp(tempFile.getPath(), userInfoMap
					.get("username").toString(), userInfoMap
					.get("password").toString(), path4A);
			flag="4";
			if (uploadFlag) {
				result.put("msg", "上传云平台FTP成功。");
				// 发送请求给云平台，给文件加水印
				HashMap<String,String> encryptInfo = postEncrypt(request, path4A);
				if (encryptInfo.get("flag").toString().equals("1")) {
					flag = "1";
					result.put("flag", flag);
					result.put("msg", "文件加水印成功。");
					String downUrl = encryptInfo.get("downUrl").toString();
					result.put("downUrl", downUrl);
				} else {
					result.put("flag", flag);
					result.put("msg", "文件加水印失败。");
					return result;
				}
			} else {
				result.put("flag", flag);
				result.put("msg", "上传云平台FTP失败。");
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
			if("2".equals(flag)){
				result.put("msg", "得到ftp用户信息失败:"+e.getMessage());
			}else if("3".equals(flag)){
				result.put("msg", "文件上传ftp失败:"+e.getMessage());
			}else if("4".equals(flag)){
				result.put("msg", "文件水印加密失败:"+e.getMessage());
			}
		} finally {
			if (tempFile != null) {
				log.debug("删除文件" + tempFile.getAbsolutePath());
				tempFile.delete();
			}
		}
		log.info("flag=============================================" + flag);
		return result;
	}

	/**
	 * 
	 * @param sql
	 * @param fileName
	 * @param header
	 * @param ds
	 * @param fileType
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public File executeNotDelete(JdbcTemplate jdbcTemplate, String sql, String fileName, Map header, String fileType, String sheetName) {
		
		String path = System.getProperty("user.dir") + "/";
		log.info("文件生成路径："+path);
		// String path = "d:"+"/";
		File tempFile = null;

		try {
			int headRows = 1;
			Iterator iterator = header.entrySet().iterator();
			if (iterator.hasNext()) {
				Map.Entry entry = (Map.Entry) iterator.next();
				Object obj = entry.getValue();

				if (obj instanceof List) {
					headRows = ((ArrayList) obj).size();
				}
			}
			Object target = null;

			List result = null;
			BufferedWriter bw = null;

			if ("excel".equalsIgnoreCase(fileType)) {
				tempFile = new File(path + fileName + ".xls");
				result = new ArrayList();
				target = result;
			} else {
				tempFile = new File(path + fileName + ".csv");
				bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tempFile), "GBK"), 512 * 1024);
				target = bw;
			}
			log.info("文件生成sql："+sql+"=========文件名称："+fileName+"==============表头："+header+"==============文件类型："+fileType+"sheet名称："+sheetName);

			SqlRowSet rs = jdbcTemplate.queryForRowSet(sql);
			try {

				SqlRowSetMetaData rsmd = rs.getMetaData();
				List<String> columnNames = new ArrayList<String>();// 记录列的别名索引，避免数据库取的字段多余header的值会报错
				int size = rsmd.getColumnCount();
				String[] line = null;
				for (int j = 0; j < headRows; j++) {
					if ("excel".equalsIgnoreCase(fileType)) {
						line = new String[size];
					}
					int excelHeaderCount = 0;// excel的表头不能用i来标识，会有空的情况发生
					for (int i = 0; i < size; i++) {

						String columnName = rsmd.getColumnName(i + 1);

						if (headRows == 1) {
							String value = "";
							Object obj = header.get(columnName);

							if (obj instanceof List) {
								value = (String) ((List) obj).get(0);
							} else if (obj instanceof String) {
								value = (String) obj;
							} else {
								value = columnName;
							}

							value = (value == null ? "" : value);
							if ("excel".equalsIgnoreCase(fileType)) {
								line[i] = value;
							} else {
								bw.write(value);
								bw.write(",");
							}

						} else {
							List list = (List) header.get(columnName);
							if (list == null) {
								continue;
							}

							Object obj1 = list.get(j);

							if (obj1 == null) {
								continue;
							}

							if ("excel".equalsIgnoreCase(fileType)) {
								line[excelHeaderCount] = (String) list.get(j);
								excelHeaderCount++;
							} else {
								// #cspan，然后再这里替换成重复的名字
								bw.write((String) list.get(j));
								bw.write(",");
							}

						}
						if (j == 0) {// 只是第一次记录一次
							columnNames.add(columnName);
						}
					}
					if ("excel".equalsIgnoreCase(fileType)) {
						result.add(line);
					} else {
						bw.write("\r\n");
					}
				}
				int lineCount = 0;
				while (rs.next()) {
					if ("excel".equalsIgnoreCase(fileType)) {
						line = new String[size];
					}
					for (int j = 0; j < columnNames.size(); j++) {
						String value = rs.getString((String) columnNames.get(j));
						value = (value == null ? "" : value);
						if ("excel".equalsIgnoreCase(fileType)) {
							line[j] = value;
						} else {
							bw.write(value);
							bw.write(",");
						}
					}
					if ("excel".equalsIgnoreCase(fileType)) {
						result.add(line);
						lineCount++;

						if (lineCount > 60000) {
							String[] notice = new String[] { "超过6w条截断" };
							result.add(notice);
							break;
						}
					} else {
						bw.write("\r\n");
					}
				}
				log.info("文件生成成功");

			} catch (IOException e) {
				e.printStackTrace();
			}

			if ("excel".equalsIgnoreCase(fileType)) {
				ExcelWriter writer = new ExcelWriter();
				writer.createBook(tempFile);
				writer.writerSheet((List) target, sheetName != null ? sheetName : fileName);
				writer.closeBook();
			} else {
				((BufferedWriter) target).flush();
				((BufferedWriter) target).close();
			}

		} catch (Exception e) {
			e.printStackTrace();
			log.error("生成" + sheetName + "时出错：" + e.getMessage(), e);
		}

		return tempFile;
	}

	/**
	 * 得到用户云平台用户名、密码、路径
	 * 
	 * @return
	 */
	public HashMap<String,String> getFtpInfo(HttpSession session) {
		HashMap<String,String> result = new HashMap<String,String>();
		String ticket = (String) session.getAttribute("_token");
		log.info("ticket=====================" + ticket);
		if(ticket ==null ||"".equals(ticket)){
			result.put("flag", "2");
			result.put("msg", "请重新从4A平台登录！");
			return result;
		}
		// 如果没有进行加密，则做加密 ，因传给
		if (ticket !=null && ticket.split("@").length > 1) {
			ticket = DES.encode(ticket);
		}
		HttpClient client = new HttpClient();
		PostMethod post = new PostMethod(GETFTPUSERURL);
		try {
			post.addParameter("ticket", ticket);
			client.executeMethod(post);
			log.debug("认证返回的状态码===============" + post.getStatusCode());
			if (post.getStatusCode() == HttpStatus.SC_OK) {
				SAXParserFactory factory = SAXParserFactory.newInstance();
				XMLReader reader = factory.newSAXParser().getXMLReader();
				SaxHandler hander = new SaxHandler();
				reader.setContentHandler(hander);
				reader.parse(new InputSource(post.getResponseBodyAsStream()));
				String[] resultArray = hander.getResult().toString().split(";");
				String flag = resultArray[0].toString();
				String msg = resultArray[1].toString();
				String msgcode = resultArray[2].toString();
				// 返回的标记不为1时证明获取失败，直接返回错误信息回去。
				if (!"1".equals(flag)) {
					result.put("flag", flag);
					result.put("msg", msg);
					return result;
				}
				String host = resultArray[3].toString();
				String username = resultArray[4].toString();
				log.info("用户云平台帐号："+username);
				String password = resultArray[5].toString();
				log.info("用户云平台密码："+password);
				String path = resultArray[6].toString();
				result.put("flag", flag);
				result.put("msg", msg);
				result.put("msgcode", msgcode);
				result.put("host", host);
				result.put("username", username);
				result.put("password", password);
				result.put("path", path);
			}
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} finally {
			post.releaseConnection();
		}
		return result;
	}

	/**
	 * 上传FTP
	 * 
	 * @param filename
	 * @param username
	 * @param password
	 * @param path
	 */
	public boolean uploadFtp(String filename, String username, String password,
			String path) {
		boolean flag = false;
		FtpHelper ftp = new FtpHelper(username + ":" + password
				+ "@10.30.44.27:21");
		try {
			ftp.connect();
			log.info("filePath=" + path);
			File tempFile = new File(filename);
			ftp.upload(tempFile);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info(e.getMessage().toString());
		} finally {
			try {
				ftp.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		log.info("上传FTP成功");
		return flag;
	}

	public HashMap<String,String> postEncrypt(HttpServletRequest request, String path4A) {
		log.info("开始进行文件加水印");
		String _token = (String) request.getSession().getAttribute("_token");
		HashMap<String,String> result = new HashMap<String,String>();
		HttpClient client = new HttpClient();
		PostMethod post = new PostMethod(ENCRYPTURL);
		try {
			String ip = Util.getRemoteAddr(request);
			String mac = Util.getMACAddress();
			String sid = request.getParameter("sid");
			if (_token.split("@").length > 1) {
				_token = DES.encode(_token);
			}
			if(sid == null || "".equals(sid)){
				sid ="湖北移动经营分析系统";
			}
			post.setParameter("ticket", _token);
			post.setParameter("filePath", path4A);
			post.setParameter("word", ip + "|" + mac.replace("-", ":")
					+ "|"+sid);
			post.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded;charset=utf-8");
			client.executeMethod(post);
			log.info("认证返回的状态码===============" + post.getStatusCode());
			if (post.getStatusCode() == HttpStatus.SC_OK) {
				SAXParserFactory factory = SAXParserFactory.newInstance();
				XMLReader reader = factory.newSAXParser().getXMLReader();
				SaxHandler hander = new SaxHandler();
				reader.setContentHandler(hander);
				reader.parse(new InputSource(post.getResponseBodyAsStream()));
				log.info(hander.getResult().toString());
				String[] resultArray = hander.getResult().toString().split(";");
				String flag = resultArray[0].toString();
				String msg = resultArray[1].toString();
				String msgcode = resultArray[2].toString();
				String downUrl = resultArray[3].toString();
				result.put("flag", flag);
				result.put("msg", msg);
				result.put("msgcode", msgcode);
				result.put("downUrl", downUrl);
			}
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} finally {
			post.releaseConnection();
		}
		return result;
	}
	
	/**
	 * 金库认证信息判断
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap<String,Object> checkJinku(String userid, String date, ServletRequest request, String ip){
		HashMap<String,Object> resultInfo = new HashMap<String,Object>();
		String sceneid = "";
		String nid = "";
		String impowerFashion = "";
		String cooperate = "";
		String cooperateStatus = "";
		
		if (!"".equals(date) && date.length() == 8) {
			sceneid = Constant.DAY_KPI_SCENEID;
			nid = "日KPI";
		} else if (!"".equals(date) && date.length() == 6) {
			sceneid = Constant.MONTH_KPI_SCENEID;
			nid = "月KPI";
		} else if (!"".equals(date) && date.equals("2")) {
			sceneid = Constant.GROUP2_SCENEID;
			nid = "虚假集团客户成员清单场景ID";
		} else if (!"".equals(date) && date.equals("3")) {
			sceneid = Constant.GROUP3_SCENEID;
			nid = "集团客户关键人清单场景ID";
		} else if (!"".equals(date) && date.equals("5")) {
			sceneid = Constant.GROUP5_SCENEID;
			nid = "农信通订购用户清单场景ID";
		} else if (!"".equals(date) && date.equals("6")) {
			sceneid = Constant.GROUP6_SCENEID;
			nid = "校信通订购用户清单场景ID";
		} else if (!"".equals(date) && date.equals("7")) {
			sceneid = Constant.GROUP7_SCENEID;
			nid = "动力100订购业务清单下载场景ID";
		} else if (!"".equals(date) && date.equals("8")) {
			sceneid = Constant.GROUP8_SCENEID;
			nid = "集团客户成员中拍照中高端客户预警明细场景ID";
		} else if (!"".equals(date) && date.equals("9")) {
			sceneid = Constant.GROUP9_SCENEID;
			nid = "集团客户欠费清单场景ID";
		} else if (!"".equals(date) && date.equals("10")) {
			sceneid = Constant.GROUP10_SCENEID;
			nid = "集团客户产品订购明细场景ID";
		} else if (!"".equals(date) && date.equals("11")) {
			sceneid = Constant.GROUP11_SCENEID;
			nid = "重点关注集团关键人清单场景ID";
		} else if (!"".equals(date) && date.equals("12")) {
			sceneid = Constant.GROUP12_SCENEID;
			nid = "2011年拍照跟踪清单场景ID";
		} else if (!"".equals(date) && date.equals("13")) {
			sceneid = Constant.GROUP13_SCENEID;
			nid = "集团价值评估清单场景ID";
		} else if (!"".equals(date) && date.equals("14")) {
			sceneid = Constant.GROUP14_SCENEID;
			nid = "无线商话号码清单场景ID";
		} else if (!"".equals(date) && date.equals("15")) {
			sceneid = Constant.GROUP15_SCENEID;
			nid = "无线商话订购集团清单场景ID";
		} else if (!"".equals(date) && date.equals("16")) {
			sceneid = Constant.GROUP16_SCENEID;
			nid = "S前缀集团订购产品清单场景ID";
		} else if (!"".equals(date) && date.equals("17")) {
			sceneid = Constant.GROUP17_SCENEID;
			nid = "重点关注集团数据下载场景ID";
		} else if (!"".equals(date) && date.equals("18")) {
			sceneid = Constant.GROUP18_SCENEID;
			nid = "集团客户信息化产品欠费明细场景ID";
		} else if (!"".equals(date) && date.equals("19")) {
			sceneid = Constant.GROUP19_SCENEID;
			nid = "真实成员清单下载场景ID";
		} else if (!"".equals(date) && date.equals("20")) {
			sceneid = Constant.GROUP21_SCENEID;
			nid = "重点关注集团成员号码下载场景ID";
		} else if (!"".equals(date) && date.equals("21")) {
			sceneid = Constant.GROUP21_SCENEID;
			nid = "重点关注集团信息化业务收入的清单下载场景ID";
		} else if (!"".equals(date) && date.equals("22")) {
			sceneid = Constant.GROUP22_SCENEID;
			nid = "省级重点关注集团年累计离网率和累计收入降幅清单下载场景ID";
		} else if (!"".equals(date) && date.equals("23")) {
			sceneid = Constant.GROUP23_SCENEID;
			nid = "校讯通业务订购用户清单场景ID";
		} else if (!"".equals(date) && date.indexOf("finance") > -1) {
			sceneid = Constant.FINANCE_SCENEID;
			nid = "月度财务报表下发";
		} else if (!"".equals(date) && date.equals("dataBiz")) {
			sceneid = Constant.DATEBIZ_SCENEID;
			nid = "数据业务打包下载";
		} else if (!"".equals(date) && date.equals("marketBase")) {
			sceneid = Constant.MARKETBASE_SCENEID;
			nid = "市场基础报表打包下载";
		} else if (!"".equals(date) && date.equals("/college/college")) {
			sceneid = Constant.COLLEAGE_SCENEID;
			nid = "算法说明与操作手册";
		} else if (!"".equals(date) && date.equals("/notice")) {
			sceneid = Constant.NOTICE_SCENEID;
			nid = "公告附件";
		} else if (!"".equals(date) && date.equals("group")) {
			sceneid = Constant.GROUP_SCENEID;
			nid = "集团满意度PPT上传下载";
		} else if (!"".equals(date) && date.equals("province")) {
			sceneid = Constant.PROVINCE_SCENEID;
			nid = "省内满意度PPT上传下载";
		} else if (!"".equals(date) && date.equals("cwbb")) {
			sceneid = Constant.CWBB_SCENEID;
			nid = "财务报表省级下载";
		} else if (!"".equals(date) && date.equals("jiFen")) {
			sceneid = Constant.JIFEN_SCENEID;
			nid = "积分下载";
		} else if (!"".equals(date) && date.equals("monthMarket")) {
			sceneid = Constant.MONTHMARKET_SCENEID;
			nid = "月度市场情况报表打包下载";
		} else if (!"".equals(date) && date.equals("feeDown")) {
			sceneid = Constant.FEEDOWN_SCENEID;
			nid = "全网统一资费编码规范文档下载";
		} else if (!"".equals(date) && date.equals("checkReport")){
			String sid = request.getParameter("sid");
			log.info(sid);
			List list = jinkuDao.getList(sid);
			if (list != null && list.size() > 0) {
				HashMap resultMap = (HashMap) list.get(0);
				sceneid = resultMap.get("sceneid").toString();
				nid = resultMap.get("name").toString();
			}else{
				resultInfo.put("msg", "此次下载未经过金库模式");
				resultInfo.put("flag", false);
				resultInfo.put("isPass", "N");
				return resultInfo;
			}
		}else if(!"".equals(date) && date.equals("zhdb")){
			sceneid = Constant.DBFDS_SCENEID;
			nid = "定报分地市数据打包下载";
		}
		String isOpen = jinkuDao.get4ASwitch();
		if (!"".equals(isOpen) && isOpen.equals("Y")) {
			try{
				// 查询4a帐号
				ArrayList<String> accounts = getAccount(userid, ip);
				// 如果得不到4A的接口数据，说明4A服务器当机
				Jinku bodyInfoDTO = getTreasuryStatus(userid, sceneid, Constant.getRandomMsgId(), ip, accounts.get(0));
				ArrayList relations = bodyInfoDTO.getRelations();
				ArrayList<String> fashionList = new ArrayList<String>();
				// 获得金库认证的授权方式
				if (relations != null && relations.size() > 0) {
					for (int i = 0; i < relations.size(); i++) {
						HashMap hashMap = (HashMap) relations.get(0);
						impowerFashion = hashMap.get("policyAuthMethod").toString();
						fashionList.add(impowerFashion);
					}
				}
				// 获得金库认证的审批人
				ArrayList approvers = bodyInfoDTO.getApprovers();
				// 获得金库认证的有效时间
				String maxTime = bodyInfoDTO.getMaxTime();
				String result = bodyInfoDTO.getResult();
				// 匹配全省金库审批员名单,如果审批人不是全省金库审批员名单则删除
				ArrayList<String> resultList = jinkuDao.getAccount(approvers);
				if (result != null && resultList.size() > 0) {
					for (int i = 0; i < resultList.size(); i++) {
						if (i == 0) {
							cooperate = resultList.get(i).toString();
						} else {
							cooperate = cooperate + "," + resultList.get(i);
						}
					}
				}
				// 如果金库协作人为空则弹出提示
				if (!"".equals(cooperate) && cooperate != null) {
					cooperateStatus = "1";
					//取消了该金库场景
					if("0".equals(result)&&result!=null){
						String comment = "是敏感信息|申请";
						Jinku logModel = new Jinku();
						logModel.setUserID(userid);
						logModel.setClientIp(ip);
						logModel.setNid(nid);
						logModel.setOperate("D");
						logModel.setSceneId(sceneid); // 场景id缺省值
						logModel.setIsSensitive("Y"); // 敏感信息标识
						logModel.setVisitDateStr(Constant.getCurrentDate()); // 当前访问时间
						logModel.setComment(comment);
						logModel.setCooperate("");
						logModel.setApplyReason("");
						logModel.setOperateContent("");
						logModel.setImpowerFashion("");
						logModel.setImpowerCondition("");
						logModel.setImpowerResult("");
						logModel.setImpowerTime("");
						logModel.setImpowerIdea("");
						logModel.setResult(result);
						jinkuDao.insertLog(logModel);
						resultInfo.put("msg", "该金库场景已取消，无需金库认证");
						resultInfo.put("flag", true);
						resultInfo.put("isPass", "Y");
					}else if("9".equals(result)&&result!=null){
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Calendar calendar = Calendar.getInstance();
						calendar.add(Calendar.HOUR, 2);
						String beginTime = sdf.format(new Date());
						String endTime = sdf.format(calendar.getTime());
						boolean isPass = siteAuth(userid, nid, Constant.getRandomMsgId(), cooperate, "111111", beginTime, endTime, ip, accounts.get(0), sceneid);
						String comment = "是敏感信息|审批";
						Jinku logModel = new Jinku();
						logModel.setUserID(userid);
						logModel.setClientIp(ip);
						logModel.setNid(nid);
						logModel.setOperate("D");
						logModel.setSceneId(sceneid); // 场景id缺省值
						logModel.setIsSensitive("Y"); // 敏感信息标识
						logModel.setVisitDateStr(Constant.getCurrentDate()); // 当前访问时间
						logModel.setComment(comment);
						logModel.setCooperate(cooperate);
						logModel.setApplyReason("快速审批模式");
						logModel.setOperateContent("快速审批模式");
						logModel.setImpowerFashion("siteAuth");
						logModel.setImpowerCondition("");
						logModel.setImpowerResult("");
						logModel.setImpowerTime("1");
						logModel.setImpowerIdea("");
						logModel.setResult(result);
						jinkuDao.insertLog(logModel);
						if (isPass) {
							resultInfo.put("msg", "金库快速审批模式通过！");
							resultInfo.put("flag", isPass);
							resultInfo.put("isPass", "Y");
						}else{
							resultInfo.put("msg", "金库快速审批模式失败！");
							resultInfo.put("flag", isPass);
							resultInfo.put("isPass", "N");
						}
					}else if("2".equals(result) && result!=null){
						String comment = "是敏感信息|审批";
						Jinku logModel = new Jinku();
						logModel.setUserID(userid);
						logModel.setClientIp(ip);
						logModel.setNid(nid);
						logModel.setOperate("D");
						logModel.setSceneId(sceneid); // 场景id缺省值
						logModel.setIsSensitive("Y"); // 敏感信息标识
						logModel.setVisitDateStr(Constant.getCurrentDate()); // 当前访问时间
						logModel.setComment(comment);
						logModel.setCooperate(cooperate);
						logModel.setApplyReason("审批通过时间内下载");
						logModel.setOperateContent("审批通过时间内下载");
						logModel.setImpowerFashion("");
						logModel.setImpowerCondition("");
						logModel.setImpowerResult("");
						logModel.setImpowerTime("");
						logModel.setImpowerIdea("");
						logModel.setResult(result);
						jinkuDao.insertLog(logModel);
						resultInfo.put("msg", "审批通过时间内下载，无需再次审批");
						resultInfo.put("flag", true);
						resultInfo.put("isPass", "Y");
					}else{
						resultInfo.put("appSessionId", Constant.getRandomMsgId());
						resultInfo.put("ip", ip);
						resultInfo.put("maxTime", maxTime);
						resultInfo.put("cooperate", cooperate);
						resultInfo.put("sceneId", sceneid);
						resultInfo.put("accounts", accounts);
						resultInfo.put("cooperate", cooperate);
						resultInfo.put("nid", nid);
						resultInfo.put("result", result);
						resultInfo.put("cooperateStatus", cooperateStatus);
						resultInfo.put("msg", "开始金库模式！");
						resultInfo.put("flag", false);
						resultInfo.put("isPass", "N");
					}
				} else {
					cooperateStatus = "0";
					resultInfo.put("msg", "无协作人，请联系4A管理员");
					resultInfo.put("flag", false);
					resultInfo.put("isPass", "N");
				}
			} catch(Exception e){
				// 记录金库应急日志,在申请原因字段中记录6:为无法调用4A接口
				String comment = "是敏感信息|申请";
				Jinku logModel = new Jinku();
				logModel.setUserID(userid);
				logModel.setClientIp(ip);
				logModel.setNid(nid);
				logModel.setOperate("D");
				logModel.setSceneId(sceneid); // 场景id缺省值
				logModel.setIsSensitive("Y"); // 敏感信息标识
				logModel.setVisitDateStr(Constant.getCurrentDate()); // 当前访问时间
				logModel.setComment(comment);
				logModel.setCooperate("");
				logModel.setApplyReason("");
				logModel.setOperateContent("");
				logModel.setImpowerFashion("");
				logModel.setImpowerCondition("");
				logModel.setImpowerResult("");
				logModel.setImpowerTime("");
				logModel.setImpowerIdea("");
				logModel.setResult("6");
				jinkuDao.insertLog(logModel);
				resultInfo.put("msg", "无法调用4A接口，可以直接下载文件");
				resultInfo.put("flag", true);
				resultInfo.put("isPass", "N");
			}
		}else{
			resultInfo.put("msg", "未开启金库模式，可直接下载");
			resultInfo.put("flag", true);
		}
		return resultInfo;
	}


	protected String charFilter(String sql) {
		sql = sql.trim();
		if (sql.endsWith(";")) {
			sql = sql.substring(0, sql.length() - 1);
		}
		return sql;
	}
	
	/**
	 * 获取场景状态信息
	 */
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	public Jinku getTreasuryStatus(String userId, String sceneId, String appSessionId, String ip,
			String account) throws Exception {
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("CertificationStatusQuery").append("</method>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("<sceneName>").append("").append("</sceneName>");
		stringBuffer.append("<sensitiveData>").append("").append("</sensitiveData>");
		stringBuffer.append("<sensitiveOperate>").append("").append("</sensitiveOperate>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		log.info("stringBuffer = "+stringBuffer.toString());
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "getTreasuryStatus", "reqMsg", "getTreasuryStatusResponse", "treasuryManagerResult");
//		String returnXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><head><responseTime>2017-08-24 10:44:38</responseTime><method>CertificationStatusResponse</method></head><body><result>1</result><resultDesc>经分菜单ID改变以后导入的新场景</resultDesc><sceneId>8a9987ee3b2b4630013b2b4707e90662</sceneId><historyAppSessionId>null</historyAppSessionId><relation><policyAuthMethod>flowAuth</policyAuthMethod><policyAccessMethod>authent_type_flow:工单;</policyAccessMethod></relation><relation><policyAuthMethod>siteAuth</policyAuthMethod><policyAccessMethod>authent_type_static:主账号密码;</policyAccessMethod></relation><relation><policyAuthMethod>remoteAuth</policyAuthMethod><policyAccessMethod>authent_type_sms:动态口令(短信);</policyAccessMethod></relation><maxTime>2</maxTime><approvers><approver>zhaojing</approver><approver>maojingjing</approver><approver>maowenjun</approver><approver>gaowen</approver><approver>jifenghua</approver><approver>zhuangli</approver><approver>hujuan7</approver></approvers></body></response>";
		log.info("returnXml = "+returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();								//场景状态
		String resultDesc = ((Element) element.element("resultDesc")).getText();						//原因
		String historyAppSessionId = ((Element) element.element("historyAppSessionId")).getText();		//历史有效应用sessionid
		//授权条件（必填属性）：当为0时，为单次授权；否则为时间段授权即允许以当前时间为开始时间，开始时间+maxTime时间为最大结束时间，允许用户在此范围选择
		String maxTime = ((Element) element.element("maxTime")).getText();								
		//多值授权方式与访问方式关系其中节点policyAuthMethod:授权方式 policyAccessMethod:访问方式
		List elementRelationList = root.selectNodes("/response/body/relation");							
		Iterator<Element> iter = elementRelationList.iterator();
		ArrayList<HashMap<String, String>> relations = new ArrayList<HashMap<String, String>>();
		while (iter.hasNext()) {
			Element relationInfo = (Element) iter.next();
			if (relationInfo != null) {
				relations.add(this.parseRelationInfo(relationInfo));
				HashMap map = this.parseRelationInfo(relationInfo);
			}
		}

		List elementApproverList = root.selectNodes("/response/body/approvers/approver");
		iter = elementApproverList.iterator();
		ArrayList<String> approver = new ArrayList<String>();
		while (iter.hasNext()) {
			String str = (String)iter.next().getText();
			approver.add(str);
		}
		Jinku bodyInfoDTO = new Jinku();
		bodyInfoDTO.setResult(result);
		bodyInfoDTO.setResultDesc(resultDesc);
		bodyInfoDTO.setRelations(relations);
		bodyInfoDTO.setApprovers(approver);
		if(!"".equals(historyAppSessionId) && historyAppSessionId != null){
			bodyInfoDTO.setHistoryAppSessionId(historyAppSessionId);
		}
		bodyInfoDTO.setMaxTime(maxTime);			
		return bodyInfoDTO;
	}

	/**
	 * 获取4A主账号
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ArrayList<String> getAccount(String userId, String ip) throws Exception {
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("ApproverQuery").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		log.info("stringBuffer = "+stringBuffer);
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "getAccount", "reqMsg", "getAccountResponse", "accountResult");
//		String returnXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><head><responseTime>2017-08-24 11:33:24</responseTime><method>ApproverSet</method></head><body><account>mengxiaoli</account></body></response>";
		log.info("returnXml = "+returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);

		List elementAccountList = root.selectNodes("/response/body/account");
		Iterator<Element> iter = elementAccountList.iterator();
		ArrayList<String> accounts = new ArrayList<String>();
		while (iter.hasNext()) {
			accounts.add(iter.next().getText());
		}
		return accounts;
	}

	/**
	 * 现场授权认证
	 */
	public boolean siteAuth(String userId, String nid, String appSessionId, String approverAccount,
			String authCode, String beginTimeStr, String endTimeStr, String ip, String account, String sceneId)
			throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("authent_type_static").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<approverAccount>").append(approverAccount).append("</approverAccount>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<authCode>").append(authCode).append("</authCode>");
		stringBuffer.append("<moreMsg>").append("").append("</moreMsg>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		log.info("stringBuffer = " +stringBuffer.toString());

		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "siteAuth", "reqMsg", "siteAuthResponse", "siteAuthResult");
//		String returnXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><head><responseTime>2015-03-11 08:25:55</responseTime><method>Response</method><appId></appId></head><body><result>0</result><resultDesc></resultDesc></body></response>";
		log.info("returnXml = " +returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	/**
	 * 远程授权第一次认证
	 */
	public boolean remoteFirstAuth(String userId, String nid, String appSessionId, String approverAccount,
			String cerReason, String beginTimeStr, String endTimeStr, String ip, String account,
			String sceneId) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("RemoteAuthorization").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<approverAccount>").append(approverAccount).append("</approverAccount>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<cerReason>").append(cerReason).append("</cerReason>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		log.info("stringBuffer = " +stringBuffer.toString());
		
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "remoteFirstAuth", "reqMsg", "remoteFirstAuthResponse", "remoteFirstAuthResult");
		log.info("returnXml = " +returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	/**
	 * 远程授权第二次认证
	 */
	public boolean remoteSecondAuth(String userId, String nid, String appSessionId, String approverAccount,
			String dynamicCode, String beginTimeStr, String endTimeStr, String ip, String account,
			String sceneId) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("RemoteSecondAuthorization").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<approverAccount>").append(approverAccount).append("</approverAccount>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<dynamicCode>").append(dynamicCode).append("</dynamicCode>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "remoteSecondAuth", "reqMsg", "remoteSecondAuthResponse", "remoteSecondAuthResult");
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}
	
	/**
	 * 工单认证
	 */

	public boolean workOrderAuth(String userId, String nid, String appSessionId, String operContent,
			String workorderNO, String beginTimeStr, String endTimeStr,String cerReason, String ip, String account,
			String sceneId) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("RemoteSecondAuthorization").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<operContent>").append(operContent).append("</operContent>");
		stringBuffer.append("<workorderNO>").append(workorderNO).append("</workorderNO>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<cerReason>").append(cerReason).append("</cerReason>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		log.info("stringBuffer = " +stringBuffer.toString());
		
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "workOrderAuth", "reqMsg", "workOrderAuthResponse", "workOrderAuthResult");
		log.info("returnXml = " +returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	/**
	 * 切换金库场景
	 */
	public boolean getCertificationSwitch(String ip, String certificationStatus) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("CertificationSwitch").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<certificationStatus>").append(certificationStatus).append(
				"</certificationStatus>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");

		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "getCertificationSwitch", "reqMsg", "getCertificationSwitchResponse", "getCertificationSwitchResult");
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	public HashMap<String, String> parseRelationInfo(Element relationInfo) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("policyAuthMethod", relationInfo.element("policyAuthMethod").getText());
		hashMap.put("policyAccessMethod", relationInfo.element("policyAccessMethod").getText());
		return hashMap;
	}
}
