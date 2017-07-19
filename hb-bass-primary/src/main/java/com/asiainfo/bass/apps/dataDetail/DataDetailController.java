package com.asiainfo.bass.apps.dataDetail;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hbbass.common.action.FileManageAction;

/**
 * 
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/dataDetail")
@SessionAttributes({SessionKeyConstants.USER})
public class DataDetailController {
	
	@Autowired
	private DataDetailDao mDetailDataDao;
	
	@RequestMapping("/index")
	public String index(Model model, @ModelAttribute(SessionKeyConstants.USER) User user){
		List<Map<String, Object>> timeList = mDetailDataDao.getTimeList();
		model.addAttribute("timeList", timeList);
		return "ftl/data/dataDetail";
	}
	
	@RequestMapping("/getListData")
	@ResponseBody
	public List<Map<String, Object>> getListData(HttpServletRequest req, @ModelAttribute(SessionKeyConstants.USER) User user){
		String timeId = req.getParameter("timeId");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		if(StringUtils.isEmpty(timeId)){
			return list;
		}
		timeId = timeId.replace("-", "");
		list = mDetailDataDao.getDataList(user.getCityId(), timeId);
		return list;
	}
	
	@RequestMapping("/downLoad")
	public void downLoad(HttpServletRequest request, HttpServletResponse response) {
		
		String timeId = request.getParameter("downTime");
		timeId = timeId.replace("-", "");
		String regionId = request.getParameter("downRegion");
		String sql = "select REGION_ID,COUNTY,COUNTY_TYPE,PHONE_NO,PHONE_TYPE," +
				" CONNECT_TYPE,INSTALL_FLAG,INSTALLMAINTAIN FROM NWH.DM_BROADBAND_INSTALLMAINTAIN_DM " +
				" WHERE FLAG = 0 AND REGION_ID = '" + regionId + "' and time_id=" + timeId + " WITH UR";

		Map<String, String> headerMap = new HashMap<String, String>();
		headerMap.put("REGION_ID", "地市");
		headerMap.put("COUNTY", "县域");
		headerMap.put("COUNTY_TYPE", "区域属性");
		headerMap.put("PHONE_NO", "电话号码");
		headerMap.put("PHONE_TYPE", "用户类型");
		headerMap.put("CONNECT_TYPE", "接入方式");
		headerMap.put("INSTALL_FLAG", "安装情况");
		headerMap.put("INSTALLMAINTAIN", "装维公司");
		

		FileManageAction.FilePorcess process = new FileManageAction.FilePorcess() {

			HttpServletResponse response;

			public void setObject(Object object) {
				this.response = (HttpServletResponse) object;
			}

			public void process(File file) {
				try {
					FileManageAction.outFile(response, file);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		};
		process.setObject(response);
		String fileName = regionId + "_" + timeId;
		try {
			FileManageAction.genFile(process, sql, fileName, headerMap, "web", true);
		} catch (ServletException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
	
}
