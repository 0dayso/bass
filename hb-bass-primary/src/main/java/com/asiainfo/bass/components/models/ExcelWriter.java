package com.asiainfo.bass.components.models;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.regex.Pattern;

import jxl.Range;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.VerticalAlignment;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableCell;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

/**
 * 
 * @author Mei Kefu
 * @date 2009-4-22
 */
@Component
public class ExcelWriter {

	private WritableWorkbook book;

	private static final Logger LOG = Logger.getLogger(ExcelWriter.class);

	public void createBook(String excelName, String path) {
		if (book == null) {
			try {
				book = Workbook.createWorkbook(new File(path + "\\" + excelName));
			} catch (IOException e) {
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			}
		}
	}

	public void createBook(File file) {
		if (book == null) {
			try {
				if (file.exists()) {
					Workbook book1 = Workbook.getWorkbook(file);
					book = Workbook.createWorkbook(file, book1);
				} else {
					book = Workbook.createWorkbook(file);
				}
			} catch (IOException e) {
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			} catch (BiffException e) {
				e.printStackTrace();
			}
		}
	}

	public void createBook(OutputStream os) {
		if (book == null) {
			try {
				book = Workbook.createWorkbook(os);
			} catch (IOException e) {
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			}
		}
	}

	public void closeBook() {
		try {
			book.write();
			book.close();
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}

	/**
	 * data <string[]>
	 * 
	 * @param data
	 * @param sheetName
	 */
	@SuppressWarnings("rawtypes")
	public void writerSheet(List data, String sheetName) {
		WritableSheet sheet = book.createSheet(sheetName, book.getNumberOfSheets() + 1);

		Pattern p = Pattern.compile("(\\-|\\+)?[0-9]+\\.?[0-9]*((E|e)\\+[0-9]+)?");

		Pattern p1 = Pattern.compile("[0-9]{15,18}");// 身份证

		for (int i = 0; i < data.size(); i++) {
			String[] lines = (String[]) data.get(i);

			for (int j = 0; j < lines.length; j++) {
				try {
					if ("#rspan".equalsIgnoreCase(lines[j])) {

						// 判断是否是最后一个#rspan不是最后一个就直接pass
						if (i + 1 < data.size()) {
							String[] lines1 = (String[]) data.get(i + 1);

							if ("#rspan".equalsIgnoreCase(lines1[j])) {
								continue;
							}
						}
						// 再判断第一个rowspan的位置
						int rowOffset = 1;
						while (i - rowOffset > 0) {

							String[] lines1 = (String[]) data.get(i - rowOffset);
							if (!"#rspan".equalsIgnoreCase(lines1[j])) {
								break;
							}
							rowOffset++;
						}

						Range range = sheet.mergeCells(j, i - rowOffset, j, i);

						if (range.getTopLeft() instanceof Label) {
							Label cell = (Label) range.getTopLeft();
							WritableCellFormat wcf = new WritableCellFormat();
							wcf.setAlignment(Alignment.CENTRE);
							wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
							cell.setCellFormat(wcf);
						}
					} else if ("#cspan".equalsIgnoreCase(lines[j])) { // 判断是否是合并列
						// 判断是是合并Range的最后一个
						if (j + 1 < lines.length && "#cspan".equalsIgnoreCase(lines[j + 1])) {
							continue;
						}

						int colOffset = 1;
						while (j - colOffset > 0) {
							if (!"#cspan".equalsIgnoreCase(lines[j - colOffset])) {
								break;
							}
							colOffset++;
						}
						Range range = sheet.mergeCells(j - colOffset, i, j, i);
						if (range.getTopLeft() instanceof Label) {
							Label cell = (Label) range.getTopLeft();
							WritableCellFormat wcf = new WritableCellFormat();
							wcf.setAlignment(Alignment.CENTRE);
							cell.setCellFormat(wcf);
						}
					} else {
						WritableCell cell = null;
						String val = lines[j];
						if (val != null && p1.matcher(val).matches()) {
							cell = new Label(j, i, val);
						} else if (val != null && p.matcher(val).matches()) {
							cell = new jxl.write.Number(j, i, Double.parseDouble(val));
						} else {
							cell = new Label(j, i, val);
						}

						sheet.addCell(cell);
					}
				} catch (RowsExceededException e) {
					e.printStackTrace();
				} catch (WriteException e) {
					e.printStackTrace();
				}
			}
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void main(String[] args) {
		ExcelWriter book = new ExcelWriter();
		List list = new java.util.ArrayList();

		String[] lines = { "105621", "2", "3", "我是傻逼" };
		list.add(lines);
		book.createBook("out.xls", "d:\\");

		book.writerSheet(list, "我是傻逼1");

		book.writerSheet(list, "我是傻逼2");

		book.closeBook();

		System.out.println("1.8e+04".matches("(\\-|\\+)?[0-9]+\\.?[0-9]*((E|e)\\+[0-9]{2})?"));
	}
}
