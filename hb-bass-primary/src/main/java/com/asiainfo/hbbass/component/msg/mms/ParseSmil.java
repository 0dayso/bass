package com.asiainfo.hbbass.component.msg.mms;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.InputStream;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ParseSmil {
	private static final Logger log = Logger.getLogger(ParseSmil.class);
	public static final int IMG = 1;
	public static final int AUDIO = 2;
	public static final int TEXT = 3;
	public static final String STRIMG = "img";
	public static final String STRAUDIO = "audio";
	public static final String STRTEXT = "text";
	private String filePath = "";

	public ParseSmil(String paramString) {
		this.filePath = paramString;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List loadMMSData() throws FileNotFoundException {
		LinkedList localLinkedList = new LinkedList();
		String str1 = this.filePath + File.separator;
		FileInputStream localFileInputStream = null;
		try {
			String[] arrayOfString = new File(str1).list(new FileNameFilter());
			if (arrayOfString.length == 0)
				throw new FileNotFoundException("smil文件找不到");
			String str2 = arrayOfString[0];
			str1 = str1 + str2;
			byte[] arrayOfByte = readFile(str2);
			SmilInfo localSmilInfo1 = new SmilInfo();
			localSmilInfo1.fileName = str2;
			localSmilInfo1.buff = arrayOfByte;
			localLinkedList.add(localSmilInfo1);
			
			
			//解析smil文件
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputStream in =new FileInputStream(str1);
			Document doc = db.parse(in);
			NodeList parList = doc.getDocumentElement()
					.getElementsByTagName("par");
			for (int i = 0; i < parList.getLength(); ++i) {
				Element par = (Element) parList.item(i);
				
				String dur = par.getAttribute("dur").trim();
				if (dur.toLowerCase().endsWith("ms")) {
					dur = dur.substring(0, dur.length() - 2);
				} else if (dur.toLowerCase().endsWith("s")) {
					dur = dur.substring(0, dur.length() - 1);
					dur = dur + "000";
				}
				HashMap localHashMap = new HashMap();
				
				localHashMap.put("time", dur);
				
				NodeList list = par.getChildNodes();
				
				for (int j = 0; j < list.getLength(); j++) {
					Node node = list.item(j);
					
					if(node.getNodeType()==1){
						
						Element elem = (Element)node;
						SmilInfo localSmilInfo2=null;
						String str4=null;
						if("img".equalsIgnoreCase(elem.getNodeName())){
							localSmilInfo2 = new SmilInfo();
							localSmilInfo2.fileName = elem.getAttribute("src");
							str4 = localSmilInfo2.fileName.substring(localSmilInfo2.fileName.lastIndexOf(".") + 1);
							if (str4.toLowerCase().indexOf("gif") >= 0)
								localSmilInfo2.fileType = "image/gif";
							else if ((str4.toLowerCase().indexOf("jpeg") >= 0)
									|| (str4.toLowerCase().indexOf("jpg") >= 0))
								localSmilInfo2.fileType = "image/jpeg";
							else if (str4.toLowerCase().indexOf("png") >= 0)
								localSmilInfo2.fileType = "image/png";
							localSmilInfo2.buff = readFile(localSmilInfo2.fileName);
							localHashMap.put("img", localSmilInfo2);
						}else if ("audio".equalsIgnoreCase(elem.getNodeName())) {
							localSmilInfo2 = new SmilInfo();
							localSmilInfo2.fileName =elem.getAttribute("src");
							str4 = localSmilInfo2.fileName
									.substring(localSmilInfo2.fileName.lastIndexOf(".") + 1);
							
							//localSmilInfo2.fileType = "audio/" + str4;
							
							localSmilInfo2.fileType = "audio/midi";
							localSmilInfo2.buff = readFile(localSmilInfo2.fileName);
							localHashMap.put("audio", localSmilInfo2);
						}else if ("text".equalsIgnoreCase(elem.getNodeName())) {
							localSmilInfo2 = new SmilInfo();
							localSmilInfo2.fileName = elem.getAttribute("src");
							localSmilInfo2.fileType = "text/plain";
							localSmilInfo2.buff = readTextFile(localSmilInfo2.fileName);
							localHashMap.put("text", localSmilInfo2);
						}
						
					}
				}
				localLinkedList.add(localHashMap);
			}
			
			/*org.jdom.input.SAXBuilder localSAXBuilder = new org.jdom.input.SAXBuilder(false);
			localFileInputStream = new FileInputStream(str1);
			org.jdom.Document localDocument = localSAXBuilder
					.build(localFileInputStream);
			org.jdom.Element localElement1 = localDocument.getRootElement();
			List localList = localElement1.getChild("body").getChildren("par");
			for (int i = 0; i < localList.size(); ++i) {
				org.jdom.Element localElement2 = (org.jdom.Element) localList.get(i);
				String str3 = localElement2.getAttributeValue("dur").trim();
				if (str3.toLowerCase().endsWith("ms")) {
					str3 = str3.substring(0, str3.length() - 2);
				} else if (str3.toLowerCase().endsWith("s")) {
					str3 = str3.substring(0, str3.length() - 1);
					str3 = str3 + "000";
				}
				HashMap localHashMap = new HashMap();
				localHashMap.put("time", str3);
				SmilInfo localSmilInfo2;
				String str4;
				if (localElement2.getChild("img") != null) {
					localSmilInfo2 = new SmilInfo();
					localSmilInfo2.fileName = localElement2.getChild("img")
							.getAttributeValue("src");
					str4 = localSmilInfo2.fileName
							.substring(localSmilInfo2.fileName.lastIndexOf(".") + 1);
					if (str4.toLowerCase().indexOf("gif") >= 0)
						localSmilInfo2.fileType = "image/gif";
					else if ((str4.toLowerCase().indexOf("jpeg") >= 0)
							|| (str4.toLowerCase().indexOf("jpg") >= 0))
						localSmilInfo2.fileType = "image/jpeg";
					else if (str4.toLowerCase().indexOf("png") >= 0)
						localSmilInfo2.fileType = "image/png";
					localSmilInfo2.buff = readFile(localSmilInfo2.fileName);
					localHashMap.put("img", localSmilInfo2);
				}
				if (localElement2.getChild("audio") != null) {
					localSmilInfo2 = new SmilInfo();
					localSmilInfo2.fileName = localElement2.getChild("audio")
							.getAttributeValue("src");
					str4 = localSmilInfo2.fileName
							.substring(localSmilInfo2.fileName.lastIndexOf(".") + 1);
					localSmilInfo2.fileType = "audio/" + str4;
					localSmilInfo2.buff = readFile(localSmilInfo2.fileName);
					localHashMap.put("audio", localSmilInfo2);
				}
				if (localElement2.getChild("text") != null) {
					localSmilInfo2 = new SmilInfo();
					localSmilInfo2.fileName = localElement2.getChild("text")
							.getAttributeValue("src");
					localSmilInfo2.fileType = "text/plain";
					localSmilInfo2.buff = readTextFile(localSmilInfo2.fileName);
					localHashMap.put("text", localSmilInfo2);
				}
				localLinkedList.add(localHashMap);
			}
			localFileInputStream.close();
			localFileInputStream = null;*/
		} catch (Exception e) {
			e.printStackTrace();
			log.error("", e);
			localLinkedList = null;
		} finally {
			if (localFileInputStream != null)
				try {
					localFileInputStream.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		return localLinkedList;
	}

	@SuppressWarnings("rawtypes")
	public void saveMMSData(List paramList) throws FileNotFoundException {
		assureDirExit(this.filePath);
		try {
			SmilInfo localSmilInfo1 = (SmilInfo) paramList.get(0);
			saveFile(localSmilInfo1);
			for (int i = 1; i < paramList.size(); ++i) {
				Map localMap = (Map) paramList.get(i);
				SmilInfo localSmilInfo2 = null;
				if (localMap.get("img") != null) {
					localSmilInfo2 = (SmilInfo) localMap.get("img");
					saveFile(localSmilInfo2);
				}
				if (localMap.get("audio") != null) {
					localSmilInfo2 = (SmilInfo) localMap.get("audio");
					saveFile(localSmilInfo2);
				}
				if (localMap.get("text") == null) {
					localSmilInfo2 = (SmilInfo) localMap.get("text");
					saveFile(localSmilInfo2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public byte[] readTextFile(String paramString) {
		String str1 = this.filePath + File.separator + paramString;
		FileInputStream localFileInputStream = null;
		byte[] arrayOfByte = null;
		try {
			localFileInputStream = new FileInputStream(str1);
			arrayOfByte = new byte[localFileInputStream.available()];
			String str2 = new String(arrayOfByte);
			arrayOfByte = str2.getBytes();
			localFileInputStream.read(arrayOfByte);
			localFileInputStream.close();
			localFileInputStream = null;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (localFileInputStream != null)
				try {
					localFileInputStream.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		return arrayOfByte;
	}

	public byte[] readFile(String paramString) {
		String str = this.filePath + File.separator + paramString;
		FileInputStream localFileInputStream = null;
		byte[] arrayOfByte = null;
		try {
			localFileInputStream = new FileInputStream(str);
			arrayOfByte = new byte[localFileInputStream.available()];
			localFileInputStream.read(arrayOfByte);
			localFileInputStream.close();
			localFileInputStream = null;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (localFileInputStream != null)
				try {
					localFileInputStream.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		return arrayOfByte;
	}

	public void saveFile(SmilInfo paramSmilInfo) {
		String str = this.filePath + File.separator + paramSmilInfo.fileName;
		FileOutputStream localFileOutputStream = null;
		try {
			localFileOutputStream = new FileOutputStream(str);
			localFileOutputStream.write(paramSmilInfo.buff);
			localFileOutputStream.close();
			localFileOutputStream = null;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (localFileOutputStream != null)
				try {
					localFileOutputStream.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
	}

	public static void assureDirExit(String paramString) {
		try {
			if (!(new File(paramString).exists()))
				new File(paramString).mkdir();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] paramArrayOfString) throws Exception {
		/*String str = "D:\\batch\\群发模块\\smil";
		ParseSmil localPraseSmil = new ParseSmil(str);
		assureDirExit(str);
		//SmilInfo localSmilInfo = new SmilInfo();
		List localList = localPraseSmil.loadMMSData();
		if (localList == null)
			localList = localPraseSmil.loadMMSData();
		localPraseSmil.saveMMSData(localList);*/
		
	}

	public static class FileNameFilter implements FilenameFilter {
		public boolean accept(File paramFile, String paramString) {
			return (paramString.toLowerCase().endsWith("smil"));
		}
	}

	public static class SmilInfo {
		public String fileName = "";
		public String fileType = "";
		public byte[] buff;
	}
}