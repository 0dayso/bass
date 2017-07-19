package com.asiainfo.hb.web.util;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class SaxHandler extends DefaultHandler {
	public StringBuffer result = new StringBuffer();

	public StringBuffer getResult() {
		return result;
	}

	public void setResult(StringBuffer result) {
		this.result = result;
	}

	// public static void main(String[] argv) {
	// try {
	// // 建立SAX解析工厂
	// SAXParserFactory spfactory = SAXParserFactory.newInstance();
	// // 生成SAX解析对象
	// SAXParser parser = spfactory.newSAXParser();
	// // 指定XML文件，进行XML解析
	// parser.parse(new File("src/book.xml"), new SaxTestHandler());
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	// }
	/**
	 * 方法说明：文件打开时调用
	 */
	public void startDocument() {
		System.out.println("***开始解析***");
	}

	/**
	 * 方法说明：当遇到开始标记时调用
	 */
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		System.out.println("节点开始：" + qName);
		if (qName.equals("SSO")) {
			return;
		}
		// for (int i = 0; i < attributes.getLength(); i++) {
		// System.out.println("节点属性名称：" + attributes.getQName(i));
		// System.out.println("节点属性值：" + attributes.getValue(i));
		// }
	}

	/**
	 * 方法说明：当分析器遇到无法识别为标记或者指令类型字符时调用
	 */
	public void characters(char[] ch, int offset, int length) throws SAXException {
		result.append(new String(ch, offset, length)).append(";");
		System.out.println("节点数据：" + new String(ch, offset, length));
	}

	/**
	 * 方法说明：当遇到节点结束时调用
	 */

	public void endElement(String uri, String localName, String qName) {
		System.out.println("节点结束：" + qName);
	}

	/**
	 * 方法说明：当到文档的末尾调用
	 */
	public void endDocument() {
		System.out.println("****文件解析完毕****");
	}

}