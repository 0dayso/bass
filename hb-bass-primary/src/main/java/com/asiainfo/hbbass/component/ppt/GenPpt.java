package com.asiainfo.hbbass.component.ppt;

import java.awt.Rectangle;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.log4j.Logger;
import org.apache.poi.hslf.HSLFSlideShow;
import org.apache.poi.hslf.model.Picture;
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.model.TextBox;
import org.apache.poi.hslf.model.TextRun;
import org.apache.poi.hslf.usermodel.SlideShow;

/**
 * Java生成ppt的程序,工程需要导入POI3.6开发包
 * 
 * @author lizhijian
 * 
 */
@SuppressWarnings("unused")
public class GenPpt {

	private static Logger LOG = Logger.getLogger(GenPpt.class);

	/**
	 * 组装数据到PPT
	 * 
	 * @param fileName
	 * @param picName
	 * @param titleText
	 * @param discriptText
	 */
	public static void generatePpt(String fileName, String picName, String titleText, String discriptText) {

		// 加载PPT
		SlideShow ppt = null;
		try {
			// 如果传入的文件没生成过，则生成一个新的ppt
			File pptFile = new File(fileName);
			if (!pptFile.exists()) {
				SlideShow _slideShow = new SlideShow();
				_slideShow.write(new FileOutputStream(fileName));
			} else {
				// LOG.debug(fileName+"已经生成过了。");
			}

			ppt = new SlideShow(new HSLFSlideShow(fileName));

			// 设置标题
			TextBox titleTextBox = new TextBox();
			TextRun titleTextRun = titleTextBox.createTextRun();
			titleTextRun.setRawText(titleText);
			titleTextBox.setAnchor(new Rectangle(30, 10, 600, 30));

			// 设置文字内容
			TextBox discriptTextBox = new TextBox();
			TextRun discriptTextRun = discriptTextBox.createTextRun();
			discriptTextRun.setRawText(discriptText);
			discriptTextBox.setAnchor(new Rectangle(30, 40, 650, 120));

			// add a new picture to this slideshow and insert it in a new slide
			int idx = ppt.addPicture(new File(picName), Picture.JPEG);

			Picture pict = new Picture(idx);

			// set image position in the slide
			pict.setAnchor(new java.awt.Rectangle(50, 110, 600, 400));

			Slide slide = ppt.createSlide();
			slide.addShape(pict);

			// 将文本对象置入幻灯片
			slide.addShape(titleTextBox);
			slide.addShape(discriptTextBox);

			FileOutputStream out = new FileOutputStream(fileName);
			// 将ppt数据写到文件
			ppt.write(out);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) throws Exception {

	}

}
