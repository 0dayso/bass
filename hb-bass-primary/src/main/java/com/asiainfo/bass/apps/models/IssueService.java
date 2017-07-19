package com.asiainfo.bass.apps.models;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.boco.bomc.inter.work.mobile.hubei.client.CreateThroughProblemSheetServiceImplClient;
import com.boco.bomc.inter.work.mobile.hubei.client.CreateThroughProblemSheetServiceImplPortType;
import com.boco.bomc.inter.work.mobile.hubei.throughproblem.webservice.service.inter.String2StringMap;
import com.boco.bomc.inter.work.mobile.hubei.throughproblem.webservice.service.inter.String2StringMap.Entry;

@Repository
public class IssueService {
	//测试环境
//	private static String ENCRYPTURL = "http://10.25.11.110:48080/bomcbpinterface/service/CreateThroughProblemSheetServiceImpl";
	//生产环境
	private static String ENCRYPTURL = "http://10.25.11.108:48080/bomcbpinterface/service/CreateThroughProblemSheetServiceImpl";
	private static Logger LOG = Logger.getLogger(IssueService.class);
	
	
	/**
	 * @param operType
	 * 1.create 新建工单
	 * 2.modify 修改工单内容
	 * 3.delete 撤销工单
	 * @param issue
	 */
	public Map<String, String> sendIssue(String operType, Issue issue){
		LOG.info("开始调用BOMC接口……，类型：" + operType);
		Map<String, String> resMap = new HashMap<String, String>();
		resMap.put("errmsg", "");
		resMap.put("succflag", "success");
		
		try {
			CreateThroughProblemSheetServiceImplClient client = new CreateThroughProblemSheetServiceImplClient();
			CreateThroughProblemSheetServiceImplPortType service=client.getCreateThroughProblemSheetServiceImplHttpPort(ENCRYPTURL);
			String2StringMap map = new String2StringMap();
			Map<String,String> infoMap = new HashMap<String,String>();
			
			String totalContent = issue.getContent();
			String title = "";
			String content = "";
			int index = (totalContent.substring(1, totalContent.length())).indexOf("#");
			if(index>0){
				String[] contents = totalContent.split("#");
				title = contents[1];
				content = contents[2];
			}
			
			infoMap.put("S_TITLE", title);//标题
			infoMap.put("BA_USER_NAME", issue.getResponsibleId());//经分账号
			infoMap.put("H_DESC", content);//内容
			infoMap.put("S_PLAN_END_TIME", issue.getEndTime() + ":00");//计划结束时间
			infoMap.put("H_ASKER", issue.getUser().getName());//申请人姓名
			infoMap.put("H_TEL", issue.getTelephone());//申请人电话
			infoMap.put("H_CHARGER", issue.getResponsible());//负责人
			infoMap.put("H_CHARGER_TEL", issue.getResponsiblePhone());//负责人电话
			infoMap.put("H_TYPE", issue.getType());//分类
			infoMap.put("BA_ID", String.valueOf(issue.getId()));//经分单号
			infoMap.put("OPER_TYPE", operType);//操作类别
			
			if(!StringUtils.isEmpty(issue.getFileName())){
				infoMap.put("ATTACH_NAME", issue.getFileName());//附件名
				infoMap.put("ATTACH_PATH", "//home//jfftp//issue//" + issue.getFileName());//附件路径
			}else{
				infoMap.put("ATTACH_NAME", "");//附件名
				infoMap.put("ATTACH_PATH", "");//附件路径
			}
			
			
			LOG.info("调用参数");
			for(String key:infoMap.keySet()){
				Entry en = new Entry();
				en.setKey(key);
				en.setValue(infoMap.get(key));
				map.getEntry().add(en);
				
				LOG.info(en.getKey() + ":" + en.getValue());
			}
			String2StringMap hmap = service.createForm(map);
			List<Entry> tList=hmap.getEntry();
			LOG.info("bomc返回结果：");
			for(Entry ent : tList){
				LOG.info(ent.getKey() + ":" + ent.getValue());
				resMap.put(ent.getKey().toLowerCase(), ent.getValue());
			}
		} catch (Exception e) {
			LOG.error("调用bomc接口出现异常，" + e.getMessage());
			e.printStackTrace();
			resMap.put("errmsg", e.getMessage());
			resMap.put("succflag", "false");
		}
		return resMap;
	}
	
}
