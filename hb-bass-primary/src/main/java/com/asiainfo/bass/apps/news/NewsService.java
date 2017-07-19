package com.asiainfo.bass.apps.news;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.KEY;

@Repository
public class NewsService {
	
	private static Logger LOG = Logger.getLogger(NewsService.class);
	
//	private static String ENCRYPTURL = "http://192.168.1.103:8080/MbiServer/service/bass/notice/publish";
	private static String ENCRYPTURL = "http://10.25.124.98:8072/MbiServer/service/bass/notice/publish";
	//按照掌分的最新要求接口改为服务器88下的8070端口
//	private static String ENCRYPTURL = "http://10.25.124.88:8070/MbiServer/service/bass/notice/publish";
	
	@Autowired
	private NewsDao newsDao;
	
	@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	public HashMap sendPost(String newsid){
		HashMap result = new HashMap();
		HttpClient client = new HttpClient();
		LOG.info("开始调用掌分接口");
		PostMethod post = new PostMethod(ENCRYPTURL);
		List list = newsDao.getNews(newsid);
		LOG.info("newsid======="+newsid);
		StringBuffer content = new StringBuffer();
		if(list.size()>0 && list!=null){
			for(int i=0;i<list.size();i++){
				SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				HashMap map = (HashMap)list.get(0);
				String newdate = String.valueOf(map.get("VALID_BEGIN_DATE"))+" 00:00:00";
				String validenddate = String.valueOf(map.get("VALID_END_DATE"))+" 00:00:00";
				String newtitle = String.valueOf(map.get("NEWSTITLE"));
				String newsmsg = String.valueOf(map.get("NEWSMSG"));
				String creator = String.valueOf(map.get("CREATOR"));
				String creatorname = String.valueOf(map.get("CREATORNAME"));
				content.append("<Request>")
					   .append("<title>").append(newtitle).append("</title>")
					   .append("<content>").append(newsmsg).append("</content>")
					   .append("<creator>").append(creator).append("</creator>")
					   .append("<creatorname>").append(creatorname).append("</creatorname>")
					   .append("<starttime>").append(newdate).append("</starttime>")
					   .append("<expiretime>").append(validenddate).append("</expiretime>")
					   .append("<noticeid>").append(newsid).append("</noticeid>")
					   .append("</Request>");
			}
		}
		try {
			post.setParameter("data", KEY.encrypt(content.toString()));
			post.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
			client.executeMethod(post);
			String code = String.valueOf(post.getStatusCode());
			String text = post.getResponseBodyAsString();
			result.put("code", code);
			result.put("msg", text);
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return result;
	}
}
