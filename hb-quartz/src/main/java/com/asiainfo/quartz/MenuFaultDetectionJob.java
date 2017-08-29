package com.asiainfo.quartz;

import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.models.CheckUrlService;
import com.asiainfo.hb.web.models.ErrorPageInfoVO;

@Component
public class MenuFaultDetectionJob {
	
	public Logger LOG = Logger.getLogger(MenuFaultDetectionJob.class);
	
	String mmsUrl = "http://10.31.100.19/dacp/hbpush";

	// 创建HttpClient
	public CloseableHttpClient closeableHttpClient = null;
	
//	@Scheduled(cron = "0 30 7,12 * * ?")
	@SuppressWarnings("unchecked")
	@Scheduled(cron = "0 0/1 * * * ?")
	public void getMsgcontent() {
		try {
			getPropertiesInfo();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		CheckUrlService checkUrlService = (CheckUrlService) BeanFactory.getBean("checkUrlService");
		try {
			//访问所有url
			Map<String, Object> map = checkUrl(checkUrlService);
			int count = (int) map.get("count");//访问url个数
			int succ = (int) map.get("succ");//访问成功次数
			List<ErrorPageInfoVO> contentList = new ArrayList<ErrorPageInfoVO>();
			if(count > 30 && succ < 3){
				LOG.info("------------------访问"+count+"次中成功次数不足:"+succ+"次，停止访问------------------");
			}else{
				LOG.info("------------------访问url:"+count+"个,成功访问:"+succ+"个------------------");
				contentList = (List<ErrorPageInfoVO>) map.get("errorMsgVO");
				//发送短信
				contentList = sendMessage(contentList);
				if(contentList != null && contentList.size() > 0){
					for(ErrorPageInfoVO error : contentList){
						error.setSendState("1");//发送短信成功
						LOG.info(error.getErrorCode());
					}
					checkUrlService.insertErrorUrl(contentList);//将访问错误的url和错误信息持久化
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		}
		LOG.info("------------------结束并且关闭连接------------------");
	}

	/**
	 * 访问所有url
	 * @param checkUrlService
	 * @return
	 * @throws IOException 
	 * @throws InterruptedException 
	 */
	private Map<String, Object> checkUrl(CheckUrlService checkUrlService) throws IOException, InterruptedException {
		HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();
		closeableHttpClient = httpClientBuilder.build();
		List<ErrorPageInfoVO> checkUrls = checkUrlService.getUrlVO();
		Map<String,Object> map = new HashMap<String, Object>();
		map = getErrorUrl(checkUrls);
		closeableHttpClient.close();
		return map;
	}
	
	private List<ErrorPageInfoVO> sendMessage(List<ErrorPageInfoVO> contentList) throws ServletException, IOException{
		CloseableHttpClient httpclient = HttpClients.createDefault();
		HttpPost httppost = new HttpPost(mmsUrl);
		List<NameValuePair> params = new ArrayList<NameValuePair>(6);
		String contacs = getPropertiesInfo();
		String content = "访问:";
		for(ErrorPageInfoVO errorPage : contentList){
			content += "‘"+errorPage.getMenuItemTitle()+"’,";
			errorPage.setSendPhoneNum(contacs);
		}
		content += content.substring(0,content.length()-1)+"页面失败";
		//请求类型action。email为邮件，sms为短信，mms为彩信
		params.add(new BasicNameValuePair("action", "mms"));
		//发送主题subject。短信发送不需要此属性
		params.add(new BasicNameValuePair("subject", "无法访问页面彩信"));
		//发送号码或者邮件的收件人contacts，多个则用英文分号分隔
		params.add(new BasicNameValuePair("contacs",contacs));
		//发送内容
		params.add(new BasicNameValuePair("content", content));
		//设置编码
		httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
		//处理返回结果
		CloseableHttpResponse response1 = httpclient.execute(httppost);
		HttpEntity entity = response1.getEntity();
		EntityUtils.toString(entity);
//		URLDecoder.decode(EntityUtils.toString(entity, "UTF-8"),"UTF-8");
		return contentList;
	}
	
	/**
	 * 从配置文件中个读取所需电话号码
	 * @return
	 * @throws IOException 
	 */
	private String getPropertiesInfo() throws IOException{
		Properties pro = new Properties();
		InputStream in = MenuFaultDetectionJob.class.getClassLoader().getResourceAsStream("/contentInformation.properties");
		pro.load(in);
		Iterator<String> it = pro.stringPropertyNames().iterator();
		while(it.hasNext()){
			System.out.println(pro.getProperty(it.next()));
		}
		return "";
	}
	
	/**
	 * 获取url并访问
	 * 
	 * @param closeableHttpClient
	 *            连接对象
	 * @param response
	 *            返回对象
	 * @param target
	 *            访问地址
	 */
	public Map<String,Object> getErrorUrl(List<ErrorPageInfoVO> checkUrls) throws IOException, ClientProtocolException, InterruptedException {
		int count = 0;//计算访问url个数
		int succ = 0;//访问成功个数
		Map<String,Object> map = new HashMap<String,Object>();
		List<ErrorPageInfoVO> list = new ArrayList<ErrorPageInfoVO>();
		String host = InetAddress.getLocalHost().getHostAddress();
		for (ErrorPageInfoVO checkUrl : checkUrls) {
			String str = checkUrl.getUrl();
			HttpGet get = null;
			URL url = null;
			str = str.replace("..", "");
			Matcher matcher = Pattern.compile("[\u4e00-\u9fa5]+|[\uFF00-\uFFFF]").matcher(str);//中文和大部分全角符号（不是所有）
			while(matcher.find()){//转换url里的中文
				str = str.replace(matcher.group(), URLEncoder.encode(matcher.group(),"gbk"));
			}
			if (str.startsWith("/")) {
				url = new URL("http://"+host+":8080/hb-bass-navigation" + str);
			} else if (str.startsWith("http://")) {
				url = new URL(str);
			} else {
				LOG.info("------------------URL地址错误，地址为：" + str + "------------------");
				continue;
			}
			CloseableHttpResponse response = null;
			try {
				get = new HttpGet(url.toURI());
				// 设置request访问头,模仿游览器访问
				get.addHeader("User-Agent",
						"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36");
				LOG.info("------------------访问url:" + get.getURI().toString() + "------------------");
				response = closeableHttpClient.execute(get);
				LOG.info("------------------返回状态码:" + response.getStatusLine() + "------------------");
				if (response != null) {
					EntityUtils.toString(response.getEntity());
					EntityUtils.consumeQuietly(response.getEntity());
					StatusLine status = response.getStatusLine();
					if(String.valueOf(status.getStatusCode()).startsWith("5") || String.valueOf(status.getStatusCode()).startsWith("4")){//获取访问错的短信发送内容
						ErrorPageInfoVO errorMsg = new ErrorPageInfoVO();
						errorMsg.setErrorCode(status.getStatusCode());
						errorMsg.setErrorMessage(status.getReasonPhrase());
						errorMsg.setMenuItemId(checkUrl.getMenuItemId());
						errorMsg.setMenuItemTitle(checkUrl.getMenuItemTitle());
						list.add(errorMsg);
//						map.put(checkUrl.getMenuItemId(), "访问页面"+checkUrl.getMenuItemTitle()+"错误，"
//								+ "返回错误码："+String.valueOf(status.getStatusCode())+ ",错误原因：" +status.getReasonPhrase());
					}
				}
				succ++;
			} catch (ClientProtocolException e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} catch (IOException e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} catch (IllegalStateException e) {
				LOG.error("连接池关闭！");
				LOG.error(LogUtil.getExceptionMessage(e));
			}  catch (URISyntaxException e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} catch (Exception e) {
				LOG.error(LogUtil.getExceptionMessage(e));
			} finally {
				get.releaseConnection();
				if (response != null) {
					EntityUtils.consumeQuietly(response.getEntity());
					response.close();
				}
			}
			count++;
			if(count > 30 && succ <3){//访问30次中成功次数不足3次，关闭连接
				map.put("count", count);
				map.put("succ", succ);
				map.put("errorMsgVO", null);
				return map;
			}
		}
		map.put("count", count);
		map.put("succ", succ);
		map.put("errorMsgVO", list);
		return map;
	}

}
