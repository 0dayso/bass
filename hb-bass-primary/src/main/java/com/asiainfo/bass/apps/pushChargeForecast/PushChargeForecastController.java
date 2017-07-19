package com.asiainfo.bass.apps.pushChargeForecast;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/PushChargeForecast")
@SessionAttributes({ "mvcPath", "contextPath", SessionKeyConstants.USER})
public class PushChargeForecastController {

	private static Logger LOG = Logger.getLogger(PushChargeForecastController.class);
	
	@Autowired
	private PushChargeForecastService pushChargeForecastService;
	
	@RequestMapping(method = RequestMethod.GET)
	public String PushChargeForecast(@ModelAttribute("user") User user) {
		return "ftl/pushChargeForecast/pushChargeForecast";
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/send", method = RequestMethod.PUT)
	public void send(HttpServletResponse response ,@RequestParam String time ,@RequestParam String sender){
		Map msg = new HashMap();
		msg.put("status", "发送成功");
		try{
			//检验此时间邮件是否发送过
			boolean flag = pushChargeForecastService.check(time); 
			LOG.info("邮件是否发送========================="+flag);
			if(!flag){
				pushChargeForecastService.send(time ,sender);
			}else{
				msg.put("status", "发送失败，所选时间邮件已经发送");
			}
		}catch(Exception e){
			msg.put("status", "发送失败");
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(msg);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
