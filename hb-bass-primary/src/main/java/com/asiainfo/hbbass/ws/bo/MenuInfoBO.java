package com.asiainfo.hbbass.ws.bo;

import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.hbbass.ws.dao.MenuInfoDAO;
import com.asiainfo.hbbass.ws.model.MenuInfoModel;

public class MenuInfoBO {

	private MenuInfoBO() {
	}

	private static MenuInfoBO instance = null;

	public static MenuInfoBO getInstance() {
		if (instance == null) {
			instance = new MenuInfoBO();
		}
		return instance;
	}

	@SuppressWarnings("finally")
	public Element parseStringToDocument(String xml) throws Exception {
		Element root = null;
		try {
			Document document = DocumentHelper.parseText(xml);
			root = document.getRootElement();
		} catch (DocumentException e) {
			throw new Exception();
		} finally {
			return root;
		}
	}

	private String appendNodeForMenuInfo(MenuInfoModel menuInfo) {
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<menuInfo>");
		stringBuffer.append("<id>").append(menuInfo.getId()).append("</id>");
		stringBuffer.append("<menuLev1>").append(menuInfo.getMenuLev1()).append("</menuLev1>");
		stringBuffer.append("<menuLev2>").append(menuInfo.getMenuLev2()).append("</menuLev2>");
		stringBuffer.append("<menuLev3>").append(menuInfo.getMenuLev3()).append("</menuLev3>");
		stringBuffer.append("<menuLev4>").append(menuInfo.getMenuLev4()).append("</menuLev4>");
		stringBuffer.append("<menuLev5>").append(menuInfo.getMenuLev5()).append("</menuLev5>");
		stringBuffer.append("<typeMenu>").append(menuInfo.getTypeMenu()).append("</typeMenu>");
		stringBuffer.append("<typeOp>").append(menuInfo.getTypeOp()).append("</typeOp>");
		stringBuffer.append("<status>").append(menuInfo.getStatus()).append("</status>");
		stringBuffer.append("<updDateStr>").append(menuInfo.getUpdDateStr()).append("</updDateStr>");
		stringBuffer.append("<sceneId>").append(menuInfo.getSceneId()).append("</sceneId>");
		stringBuffer.append("</menuInfo>");
		return stringBuffer.toString();
	}

	public String menuInfoList(String xml) throws Exception {
		MenuInfoDAO menuInfoDAO = (MenuInfoDAO) BeanFactoryA.getBean("menuInfoDAO");
		StringBuffer stringBuffer = new StringBuffer();
		Element root;
		try {
			root = this.parseStringToDocument(xml);
		} catch (Exception e) {
			throw new IllegalArgumentException("解析入参XML异常。");
		}
		Element element = (Element) root.selectSingleNode("/service/data_info");
		String id = ((Element) element.element("id")).getText();
		String menuLev1 = ((Element) element.element("menuLev1")).getText();
		String menuLev2 = ((Element) element.element("menuLev2")).getText();
		String menuLev3 = ((Element) element.element("menuLev3")).getText();
		String menuLev4 = ((Element) element.element("menuLev4")).getText();
		String menuLev5 = ((Element) element.element("menuLev5")).getText();
		String typeMenu = ((Element) element.element("typeMenu")).getText();
		String typeOp = ((Element) element.element("typeOp")).getText();
		String status = ((Element) element.element("status")).getText();
		String sceneId = ((Element) element.element("sceneId")).getText();
		String begin = ((Element) element.element("begin")).getText();
		String length = ((Element) element.element("length")).getText();
		if (StringUtils.isBlank(begin) || Integer.valueOf(begin) < 0) {
			throw new IllegalArgumentException("参数begin错误。");
		}
		if (StringUtils.isBlank(length) || Integer.valueOf(length) <= 0) {
			throw new IllegalArgumentException("参数length错误。");
		}
		MenuInfoModel pInfoModel = new MenuInfoModel();
		pInfoModel.setId(id);
		pInfoModel.setMenuLev1(menuLev1);
		pInfoModel.setMenuLev2(menuLev2);
		pInfoModel.setMenuLev3(menuLev3);
		pInfoModel.setMenuLev4(menuLev4);
		pInfoModel.setMenuLev5(menuLev5);
		pInfoModel.setStatus(status);
		pInfoModel.setTypeMenu(typeMenu);
		pInfoModel.setTypeOp(typeOp);
		pInfoModel.setSceneId(sceneId);
		Integer count = menuInfoDAO.menuInfoListCount(pInfoModel);
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
		stringBuffer.append("<service>");
		stringBuffer.append("<data_info>");
		if (count == 0) {
			stringBuffer.append("<menuInfo/>");
		} else {
			List<MenuInfoModel> menuInfoList = menuInfoDAO.menuInfoList(pInfoModel,
					Integer.valueOf(begin), Integer.valueOf(length));
			for (Iterator<MenuInfoModel> iterator = menuInfoList.iterator(); iterator.hasNext();) {
				MenuInfoModel menuInfoModel = (MenuInfoModel) iterator.next();
				stringBuffer.append(this.appendNodeForMenuInfo(menuInfoModel));
			}
		}
		stringBuffer.append("<pager>");
		stringBuffer.append("<count>").append(count).append("</count>");
		stringBuffer.append("<begin>").append(begin).append("</begin>");
		stringBuffer.append("<length>").append(length).append("</length>");
		stringBuffer.append("</pager>");
		stringBuffer.append("</data_info>");
		stringBuffer.append("</service>");
		return stringBuffer.toString();
	}

	public String menuInfoByKey(String xml) throws Exception {
		MenuInfoDAO menuInfoDAO = (MenuInfoDAO) BeanFactoryA.getBean("menuInfoDAO");
		StringBuffer stringBuffer = new StringBuffer();
		Element root;
		try {
			root = this.parseStringToDocument(xml);
		} catch (Exception e) {
			throw new IllegalArgumentException("解析入参XML异常。");
		}
		Element element = (Element) root.selectSingleNode("/service/data_info");
		String id = ((Element) element.element("id")).getText();
		String typeOp = ((Element) element.element("typeOp")).getText();
		if (StringUtils.isBlank(id)) {
			throw new IllegalArgumentException("参数id不能为空。");
		}
		if (StringUtils.isBlank(typeOp) || typeOp.length() != 1) {
			throw new IllegalArgumentException("参数typeOp错误。");
		}
		MenuInfoModel pInfoModel = new MenuInfoModel();
		pInfoModel.setId(id);
		pInfoModel.setTypeOp(typeOp);
		MenuInfoModel menuInfoModel = menuInfoDAO.menuInfoByKey(pInfoModel);
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
		stringBuffer.append("<service>");
		stringBuffer.append("<data_info>");
		if (menuInfoModel != null && !StringUtils.isBlank(menuInfoModel.getId())) {
			this.appendNodeForMenuInfo(menuInfoModel);
		} else {
			stringBuffer.append("<menuInfo/>");
		}
		stringBuffer.append("</data_info>");
		stringBuffer.append("</service>");
		return stringBuffer.toString();
	}

	public void insertMenuInfo(String xml) throws Exception {
		MenuInfoDAO menuInfoDAO = (MenuInfoDAO) BeanFactoryA.getBean("menuInfoDAO");
		Element root;
		try {
			root = this.parseStringToDocument(xml);
		} catch (Exception e) {
			throw new IllegalArgumentException("解析入参XML异常。");
		}
		Element element = (Element) root.selectSingleNode("/service/data_info/menuInfo");
		String id = ((Element) element.element("id")).getText();
		String menuLev1 = ((Element) element.element("menuLev1")).getText();
		String menuLev2 = ((Element) element.element("menuLev2")).getText();
		String menuLev3 = ((Element) element.element("menuLev3")).getText();
		String menuLev4 = ((Element) element.element("menuLev4")).getText();
		String menuLev5 = ((Element) element.element("menuLev5")).getText();
		String typeMenu = ((Element) element.element("typeMenu")).getText();
		String typeOp = ((Element) element.element("typeOp")).getText();
		String status = ((Element) element.element("status")).getText();
		String sceneId = ((Element) element.element("sceneId")).getText();
		String updDateStr = ((Element) element.element("updDateStr")).getText();
		if (StringUtils.isBlank(id)) {
			throw new IllegalArgumentException("参数id不能为空。");
		}
		if (StringUtils.isBlank(typeOp) || typeOp.length() != 1) {
			throw new IllegalArgumentException("参数typeOp错误。");
		}
		if (StringUtils.isBlank(typeMenu) || typeMenu.length() != 1) {
			throw new IllegalArgumentException("参数typeMenu错误。");
		}
		if (StringUtils.isBlank(status) || status.length() != 1) {
			throw new IllegalArgumentException("参数status错误。");
		}
		if (StringUtils.isBlank(updDateStr) || updDateStr.length() != 8) {
			throw new IllegalArgumentException("参数updDateStr错误。");
		}
		MenuInfoModel pInfoModel = new MenuInfoModel();
		pInfoModel.setId(id);
		pInfoModel.setMenuLev1(menuLev1);
		pInfoModel.setMenuLev2(menuLev2);
		pInfoModel.setMenuLev3(menuLev3);
		pInfoModel.setMenuLev4(menuLev4);
		pInfoModel.setMenuLev5(menuLev5);
		pInfoModel.setStatus(status);
		pInfoModel.setTypeMenu(typeMenu);
		pInfoModel.setTypeOp(typeOp);
		pInfoModel.setUpdDateStr(updDateStr);
		pInfoModel.setSceneId(sceneId);
		menuInfoDAO.insertMenuInfo(pInfoModel);
	}

	public void updateMenuInfo(String xml) throws Exception {
		MenuInfoDAO menuInfoDAO = (MenuInfoDAO) BeanFactoryA.getBean("menuInfoDAO");
		Element root;
		try {
			root = this.parseStringToDocument(xml);
		} catch (Exception e) {
			throw new IllegalArgumentException("解析入参XML异常。");
		}
		Element element = (Element) root.selectSingleNode("/service/data_info/menuInfo");
		String id = ((Element) element.element("id")).getText();
		String menuLev1 = ((Element) element.element("menuLev1")).getText();
		String menuLev2 = ((Element) element.element("menuLev2")).getText();
		String menuLev3 = ((Element) element.element("menuLev3")).getText();
		String menuLev4 = ((Element) element.element("menuLev4")).getText();
		String menuLev5 = ((Element) element.element("menuLev5")).getText();
		String typeMenu = ((Element) element.element("typeMenu")).getText();
		String typeOp = ((Element) element.element("typeOp")).getText();
		String status = ((Element) element.element("status")).getText();
		String sceneId = ((Element) element.element("sceneId")).getText();
		String updDateStr = ((Element) element.element("updDateStr")).getText();
		if (StringUtils.isBlank(id)) {
			throw new IllegalArgumentException("参数id不能为空。");
		}
		if (StringUtils.isBlank(typeOp) || typeOp.length() != 1) {
			throw new IllegalArgumentException("参数typeOp错误。");
		}
		if (StringUtils.isBlank(typeMenu) || typeMenu.length() != 1) {
			throw new IllegalArgumentException("参数typeMenu错误。");
		}
		if (StringUtils.isBlank(status) || status.length() != 1) {
			throw new IllegalArgumentException("参数status错误。");
		}
		if (StringUtils.isBlank(updDateStr) || updDateStr.length() != 8) {
			throw new IllegalArgumentException("参数updDateStr错误。");
		}
		MenuInfoModel pInfoModel = new MenuInfoModel();
		pInfoModel.setId(id);
		pInfoModel.setMenuLev1(menuLev1);
		pInfoModel.setMenuLev2(menuLev2);
		pInfoModel.setMenuLev3(menuLev3);
		pInfoModel.setMenuLev4(menuLev4);
		pInfoModel.setMenuLev5(menuLev5);
		pInfoModel.setStatus(status);
		pInfoModel.setTypeMenu(typeMenu);
		pInfoModel.setTypeOp(typeOp);
		pInfoModel.setUpdDateStr(updDateStr);
		pInfoModel.setSceneId(sceneId);
		menuInfoDAO.updateMenuInfo(pInfoModel);
	}

	public void deleteMenuInfo(String xml) throws Exception {
		MenuInfoDAO menuInfoDAO = (MenuInfoDAO) BeanFactoryA.getBean("menuInfoDAO");
		Element root;
		try {
			root = this.parseStringToDocument(xml);
		} catch (Exception e) {
			throw new IllegalArgumentException("解析入参XML异常。");
		}
		Element element = (Element) root.selectSingleNode("/service/data_info");
		String id = ((Element) element.element("id")).getText();
		String typeOp = ((Element) element.element("typeOp")).getText();
		if (StringUtils.isBlank(id)) {
			throw new IllegalArgumentException("参数id不能为空。");
		}
		if (StringUtils.isBlank(typeOp) || typeOp.length() != 1) {
			throw new IllegalArgumentException("参数typeOp错误。");
		}
		MenuInfoModel pInfoModel = new MenuInfoModel();
		pInfoModel.setId(id);
		pInfoModel.setTypeOp(typeOp);
		menuInfoDAO.deleteMenuInfo(pInfoModel);
	}
}
