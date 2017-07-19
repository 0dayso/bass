package com.asiainfo.bass.components.models;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

/**
 * 解析excel成为list对象，如果行数太多会有OOM的隐患
 * 
 * @author Mei Kefu
 * @date 2009-3-18
 */
@Component
@SuppressWarnings({"rawtypes"})
public class ExcelReader {

	private Workbook workbook;

	private static final Logger LOG = Logger.getLogger(ExcelReader.class);

	public void openWorkbook(String strPath) {
		try {
			workbook = Workbook.getWorkbook(new File(strPath));
		} catch (BiffException e) {
			LOG.error(e.getMessage(), e);
			e.printStackTrace();
		} catch (IOException e) {
			LOG.error(e.getMessage(), e);
			e.printStackTrace();
		}
	}

	public List sheetDataList() {
		return sheetDataList("0");
	}

	/**
	 * 
	 * @param sheetName
	 *            : 序号，或者 sheetName
	 * @return
	 */
	public List<String[]> sheetDataList(String sheetName) {
		List<String[]> list = new ArrayList<String[]>();

		if (workbook != null) {

			Sheet sheet = null;
			if (sheetName == null || sheetName.length() == 0) {// 传null或者""就自动取第一个
				sheetName = "0";
			}
			try {
				sheet = workbook.getSheet(sheetName);

				if (sheet == null && sheetName.matches("[0-9]+")) {
					LOG.warn(sheetName + "，通过数字来取");
					try {
						sheet = workbook.getSheet(Integer.parseInt(sheetName));
					} catch (Exception e1) {
						LOG.warn("通过sheetNum取sheet不正确" + sheetName);
						e1.printStackTrace();
					}
				}
			} catch (Exception e) {
				LOG.warn("取sheetName不正确" + sheetName);
				e.printStackTrace();

			}
			SimpleDateFormat sdf = null;
			if (sheet != null) {
				int columnsCount = sheet.getColumns();
				String[] lines = null;
				for (int i = 0; i < sheet.getRows(); i++) {
					lines = new String[columnsCount];
					Cell[] cells = sheet.getRow(i);
					for (int j = 0; j < columnsCount; j++) {
						if (cells.length <= j) {
							lines[j] = ""; // 加上 这两行可以解决下面这个问题：
						} else {
							if (cells[j].getType() == CellType.DATE) {
								DateCell dateCell = (DateCell) cells[j];

								if (sdf == null) {
									sdf = new SimpleDateFormat("yyyy-MM-dd");
								}
								lines[j] = sdf.format(dateCell.getDate());
							} else {
								lines[j] = cells[j].getContents().trim();// 如下形式的excel在这里会报错
							}
						}

					}
					list.add(lines);
				}
			}
		}
		return list;
	}

	public void closeWorkbook() {
		if (workbook != null)
			workbook.close();
	}

	public static void main(String[] args) {
		ExcelReader reader = new ExcelReader();
		reader.openWorkbook("C:/Documents and Settings/higherzl/桌面/回流上传重构/sample.xls");

		System.out.println(reader.sheetDataList(null).size());

		System.out.println("+9.01212".matches("[+|-]?[0-9]+(\\.[0-9]+)?"));

	}

}
