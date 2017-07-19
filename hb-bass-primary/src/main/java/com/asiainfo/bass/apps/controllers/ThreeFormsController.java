package com.asiainfo.bass.apps.controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.apps.models.ThreeFormsDao;
import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping("/threeForms")
@SessionAttributes("user")
public class ThreeFormsController {

	private static Logger m_log = Logger.getLogger(ThreeFormsController.class);
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
	
	@Autowired
	private ThreeFormsDao threeFormDao;

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute("user") User user) throws IOException{
		String month = request.getParameter("month");
		m_log.info("month=" + month);
		
		String fileName = request.getParameter("fileName");
		m_log.info("fileName=" + fileName);
		
		JSONObject jsonObj = new JSONObject();
		try {
			threeFormDao.save(month, fileName, user);
			jsonObj.put("flag", "1");
			m_log.info("保存成功");
		} catch (Exception e) {
			m_log.info("保存失败，异常信息：" + e.getMessage());
			e.printStackTrace();
			jsonObj.put("flag", "-1");
		}
		response.getWriter().print(jsonObj.toString());
	}
	
	@RequestMapping(value = "deleteFile", method = RequestMethod.POST)
	public void deleteFile(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String month = request.getParameter("month");
		String fileName = request.getParameter("fileName");
		JSONObject jsonObj = new JSONObject();
		FtpHelper ftp = new FtpHelper();
		try {
			User user = (User) request.getSession().getAttribute("user");
			ftp.connect();
			String filePath = "threeForm/" + month + "/" + fileName;
			m_log.info("filePath=" + filePath);
			ftp.delete(filePath);
			threeFormDao.delete(month, user, fileName);
			jsonObj.put("flag", "1");
		}catch (Exception e) {
			m_log.info("删除文件出现异常，异常信息：" + e.getMessage());
			e.printStackTrace();
			jsonObj.put("flag", "-1");
		}finally {
			try {
				ftp.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		response.getWriter().print(jsonObj.toString());
	}
	
	@RequestMapping(value = "queryUpload", method = RequestMethod.POST)
	public void queryUpload(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String month = request.getParameter("month");
		JSONObject jsonObj = new JSONObject();
		try {
			Map<String, Object> map = threeFormDao.queryUpload(month);
			if(!map.isEmpty()){
				jsonObj.put("flag", "1");
				jsonObj.put("name", map.get("name"));
				jsonObj.put("status", map.get("status"));
				jsonObj.put("suggestion", map.get("suggestion"));
				jsonObj.put("isdelete", map.get("isdelete"));
				jsonObj.put("logList", threeFormDao.getLogInfo(month));
			}else{
				jsonObj.put("flag", "0");
			}
		} catch (Exception e) {
			m_log.info("查询失败，异常信息：" + e.getMessage());
			e.printStackTrace();
			jsonObj.put("flag", "-1");
		}
		response.getWriter().print(jsonObj.toString());
	}
	
	@RequestMapping(value = "updateStatus", method = RequestMethod.POST)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String status = request.getParameter("status");
		String month = request.getParameter("month");
		String suggestion = request.getParameter("suggestion");
		m_log.info("status=" + status + ",month=" + month);
		JSONObject obj = new JSONObject();
		try {
			User user = (User) request.getSession().getAttribute("user");
			threeFormDao.updateState(month, status, suggestion, user);
			obj.put("flag", "1");
			m_log.info("审核成功");
		} catch (Exception e) {
			m_log.info("审核失败，异常信息：" + e.getMessage());
			e.printStackTrace();
			obj.put("flag", "-1");
		}
		response.getWriter().print(obj.toString());
	}
	
	@RequestMapping(value = "upload", method = RequestMethod.POST)
	public void upload(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("user") User user)
			throws IOException {
		// 临时文件夹路径
		String path = System.getProperty("user.dir") + "/";
		String month = request.getParameter("month");
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// 设置文件目录
		File file = new File(path);
		if (!file.exists()) {
			file.mkdirs();
		}

		factory.setRepository(file);
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding("gbk");

		JSONObject jsonObj = new JSONObject();
		try {
			@SuppressWarnings("unchecked")
			List<FileItem> fileItems = upload.parseRequest(request);
			JSONArray jsonArr = new JSONArray();
			JSONObject obj = new JSONObject();
			for (FileItem item : fileItems) {
				if (!item.isFormField()) {
					String fileName = item.getName();
					if(fileName.contains("\\")){
						fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
					}
					String savePath = path + fileName;
					File saveFile = new File(savePath);
					item.write(saveFile);
					obj.put("fileName", fileName);
					jsonArr.add(obj);
					
					FtpHelper ftp = new FtpHelper();
					try {
						ftp.connect();
						String filePath = "threeForm/" + month + "/";
						m_log.info("filePath=" + filePath);
						File tempFile = new File(fileName);
						
						ftp.upload(filePath + fileName , tempFile);
						tempFile.delete();
						threeFormDao.save(month, fileName, user);
						jsonObj.put("success", true);
						m_log.info("上传FTP成功");
					} catch (Exception e) {
						e.printStackTrace();
						m_log.info(e.getMessage().toString());
						jsonObj.put("success", false);
					} finally {
						try {
							ftp.disconnect();
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
			}
			jsonObj.put("fileNames", jsonArr);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("success", false);
		}
		response.getWriter().print(jsonObj.toString());
	}
	
	@RequestMapping(value = "readExcel", method = RequestMethod.POST)
	public void readExcel(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String month = request.getParameter("month");
		String fileName = request.getParameter("fileName");
		FtpHelper ftp = new FtpHelper();
		String userpath = System.getProperty("user.dir") + "/";
		try {
			ftp.connect();
			String filePath = "threeForm/" + month;
			@SuppressWarnings("rawtypes")
			List fileList = ftp.listFiles(filePath);
			File tempFile = null;
			for(int i=0; i< fileList.size(); i++){
				tempFile = new File(fileList.get(i).toString());
				if(tempFile.getName().equals(fileName)){
					ftp.down(fileList.get(i).toString(), new File(userpath + fileName));
					break;
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				ftp.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		File file = new File(userpath + fileName);
		//测试
//		String filePath = "E:/配置检查表201305_三表合一.xls";
//		File file = new File(filePath);
		JSONObject obj = readExcel(file);
		response.getWriter().print(obj.toString());
	}
	
	public static void main(String[] args) {
		String filePath = "E:/配置检查表201305_三表合一.xls";
		File file = new File(filePath);
		ThreeFormsController co = new ThreeFormsController();
		System.out.println(co.readExcel(file));
	}

	//读取Excel内容
	private JSONObject readExcel(File file) {
		JSONObject jsonObject = new JSONObject();

		try {
			FileInputStream is = new FileInputStream(file);
			Workbook workbook = WorkbookFactory.create(is);
			// Sheet的数量
			int sheetCount = workbook.getNumberOfSheets();
			jsonObject.put("sheetCount", sheetCount);
			Row row = null;
			StringBuilder strBuilder;
			JSONArray sheetCont = new JSONArray();
			JSONObject obj;
			for (int i = 0; i < sheetCount; i++) {
				Sheet sheet = workbook.getSheetAt(i);
				strBuilder = new StringBuilder();
				strBuilder.append("<table border=\"0\" cellpadding=\"2\" cellspacing=\"1\" class='sheet'>");

				int cellNum = 0;
				// 遍历行
				for (int rowNum = 0; rowNum < sheet.getLastRowNum(); rowNum++) {
					strBuilder.append("<tr>");
					if (null != sheet.getRow(rowNum)) {
						row = sheet.getRow(rowNum);
						if(cellNum == 0){
							cellNum = row.getLastCellNum();
						}
						// 遍历列
						Cell cell = null;
						for(int n=0; n<cellNum; n++){
							cell = row.getCell(n);
							//判断是否为合并单元格
							int[] colIndex = isMergedRegion(sheet, row.getRowNum(), n);
							if (0 == colIndex[1]) {
								strBuilder.append("<td class='sheetInfo'>" + this.getCellValue(cell) + "</td>");
							}else{
								if(n == colIndex[1]){
									int cols = colIndex[1] - colIndex[0] + 1;
									strBuilder.append("<td colspan='" +cols + "' class='sheetInfo'>" + this.getMergedRegionValue(sheet, row.getRowNum(), n) + "</td>");
								}
							}
						}
					}
					strBuilder.append("</tr>");
				}
				strBuilder.append("</table>");
				obj = new JSONObject();
				obj.put("sheetCont", strBuilder.toString());
				obj.put("sheetName", sheet.getSheetName());
				sheetCont.add(obj);
			}
			jsonObject.put("flag", true);
			jsonObject.put("sheet", sheetCont);
		} catch (Exception e) {
			jsonObject.put("flag", false);
			jsonObject.put("msg", "解析Excel文件出现错误！");
			e.printStackTrace();
		}

		return jsonObject;
	}

	/**
	 * 判断指定的单元格是否是合并单元格
	 * 
	 * @param sheet
	 * @param row 行下标
	 * @param column 列下标
	 * @return
	 */
	private int[] isMergedRegion(Sheet sheet, int row, int column) {
		int sheetMergeCount = sheet.getNumMergedRegions();
		for (int i = 0; i < sheetMergeCount; i++) {
			CellRangeAddress range = sheet.getMergedRegion(i);
			int firstColumn = range.getFirstColumn();
			int lastColumn = range.getLastColumn();
			int firstRow = range.getFirstRow();
			int lastRow = range.getLastRow();
			if (row >= firstRow && row <= lastRow) {
				if (column >= firstColumn && column <= lastColumn) {
					return new int[]{firstColumn, lastColumn} ;
				}
			}
		}
		return new int[]{0, 0};
	}

	/**
	 * 获取合并单元格的值
	 * 
	 * @param sheet
	 * @param row
	 * @param column
	 * @return
	 */
	public String getMergedRegionValue(Sheet sheet, int row, int column) {
		int sheetMergeCount = sheet.getNumMergedRegions();

		for (int i = 0; i < sheetMergeCount; i++) {
			CellRangeAddress ca = sheet.getMergedRegion(i);
			int firstColumn = ca.getFirstColumn();
			int lastColumn = ca.getLastColumn();
			int firstRow = ca.getFirstRow();
			int lastRow = ca.getLastRow();

			if (row >= firstRow && row <= lastRow) {

				if (column >= firstColumn && column <= lastColumn) {
					Row fRow = sheet.getRow(firstRow);
					Cell fCell = fRow.getCell(firstColumn);
					return getCellValue(fCell);
				}
			}
		}

		return null;
	}

	/**
	 * 获取单元格的值
	 * 
	 * @param cell
	 * @return
	 */
	public String getCellValue(Cell cell) {

		if (cell == null) {
			return "";
		}

		if (cell.getCellType() == Cell.CELL_TYPE_STRING) {
			return cell.getStringCellValue();
		} else if (cell.getCellType() == Cell.CELL_TYPE_BOOLEAN) {
			return String.valueOf(cell.getBooleanCellValue());
		} else if (cell.getCellType() == Cell.CELL_TYPE_FORMULA) {
			return cell.getCellFormula();
		} else if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
			if (cell.getCellStyle().getDataFormat() == 27) {
                double value = cell.getNumericCellValue();  
                Date date = DateUtil.getJavaDate(value);  
                return sdf.format(date);  
			}

		    DecimalFormat df = new DecimalFormat("0");  
		    return df.format(cell.getNumericCellValue());  

		}
		return "";
	}

}
