package com.asiainfo.hbbass.ws.common;

import org.apache.log4j.Logger;
import org.apache.commons.codec.binary.Base64;
/**
 * 
 * 使用DES加密与解密,可对byte[],String类型进行加密与解密 密文可使用String,byte[]存储. getKey(String strKey)从strKey的字条生成一个Key
 * String getEncString(String strMing)对strMing进行加密,返回String密文 String getDesString(String
 * strMi)对strMin进行解密,返回String明文
 * 
 * byte[] getEncCode(byte[] byteS)byte[]型的加密 byte[] getDesCode(byte[] byteD)byte[]型的解密
 */

public class ThreeDesBase64 {
	private static Logger LOG = Logger.getLogger(ThreeDesBase64.class);
	// private static final String PRIVATE_KEY = "boco";

	// /**
	// * 根据参数生成KEY
	// *
	// * @param strKey
	// */
	// private Key getKey(String strKey) {
	// strKey = PRIVATE_KEY.concat(strKey);
	// Key key = null;
	// try {
	// KeyGenerator generator = KeyGenerator.getInstance("DESede");
	// SecureRandom secure = SecureRandom.getInstance("SHA1PRNG");
	// secure.setSeed(strKey.getBytes());
	// generator.init(112, secure);// 安全性高168也行
	// key = generator.generateKey();
	// generator = null;
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	// return key;
	// }

	/**
	 * 加密String明文输入,String密文输出
	 * 
	 * @param strPub
	 *            明文字符串
	 * @param strKey
	 * @return
	 */
	public String encode(String strPub, String strKey) {
		byte[] byteStr = null;
		String strPri = "";
		try {
			byteStr = strPub.getBytes("UTF8");
			strPri = Base64.encodeBase64String(byteStr);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			/*base64en = null;*/
			byteStr = null;
		}
		return strPri;
	}

	/**
	 * 解密 以String密文输入,String明文输出
	 * 
	 * @param strMi
	 * @return
	 */
	public String decode(String strPri, String strKey) {
		byte[] bytePri = null;
		String strPub = "";
		try {
			bytePri = Base64.decodeBase64(strPri);
			strPub = new String(bytePri, "UTF8");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			/*base64De = null;*/
			bytePri = null;
		}
		return strPub;
	}

	// /**
	// * 加密以byte[]明文输入,byte[]密文输出
	// *
	// * @param byteS
	// * @return
	// */
	// private byte[] encodeDES(byte[] bytePub, String strKey) {
	// byte[] bytePri = null;
	// Cipher cipher;
	// try {
	// cipher = Cipher.getInstance("DESede/ECB/PKCS5Padding");
	// Key key = getKey(strKey);
	// cipher.init(Cipher.ENCRYPT_MODE, key);
	// bytePri = cipher.doFinal(bytePub);
	// } catch (Exception e) {
	// e.printStackTrace();
	// } finally {
	// cipher = null;
	// }
	// return bytePri;
	// }
	//
	// /**
	// * 解密以byte[]密文输入,以byte[]明文输出
	// *
	// * @param byteD
	// * @return
	// */
	// private byte[] decodeDES(byte[] bytePri, String strKey) {
	// Cipher cipher;
	// byte[] bytePub = null;
	// try {
	// cipher = Cipher.getInstance("DESede/ECB/PKCS5Padding");
	// Key key = getKey(strKey);
	// cipher.init(Cipher.DECRYPT_MODE, key);
	// bytePub = cipher.doFinal(bytePri);
	// } catch (Exception e) {
	// e.printStackTrace();
	// } finally {
	// cipher = null;
	// }
	// return bytePub;
	// }

	public static void main(String[] args) {
		String xmlAdd = "<?xml version='1.0' encoding='UTF-8'?>" + "<request>" + "<head>"
				+ "<appId>8a89bace2aea40d7012aea40d7f00000</appId>" + "<appName>经营分析</appName>"
				+ "<requestTime>2011-01-25 11:12:13</requestTime>" + "<accId>liuhongyi</accId>"
				+ "<clientIP>10.32.3.120</clientIP>" + "<sign>数字签名</sign>" + "</head>" + "<body>"
				+ "<method>UserAdd</method>" + "<page>" + "<totalrow>2</totalrow>" + "<pagesize>0</pagesize>"
				+ "<currentpage>1</currentpage>" + "</page>" + "<values>" + "<object>" + "<parameter>"
				+ "<appField>userid</appField>" + "<fieldValue>sanmao</fieldValue>" + "</parameter>"
				+ "<parameter>" + "<appField>username</appField>" + "<fieldValue>sanmao</fieldValue>"
				+ "</parameter>" + "<parameter>" + "<appField>phone</appField>"
				+ "<fieldValue>13912345678</fieldValue>" + "</parameter>" + "<parameter>"
				+ "<appField>phone</appField>" + "<fieldValue>13812345678</fieldValue>" + "</parameter>"
				+ "<parameter>" + "<appField>email</appField>" + "<fieldValue>987@654.321</fieldValue>"
				+ "</parameter>" + "<parameter>" + "<appField>userpassword</appField>"
				+ "<fieldValue>$#%2fheoi%@#$</fieldValue>" + "</parameter>" + "</object>" + "<object>"
				+ "<parameter>" + "<appField>userid</appField>" + "<fieldValue>simao</fieldValue>"
				+ "</parameter>" + "<parameter>" + "<appField>username</appField>"
				+ "<fieldValue>simao</fieldValue>" + "</parameter>" + "<parameter>"
				+ "<appField>mobilephone</appField>" + "<fieldValue>13912345678</fieldValue>"
				+ "</parameter>" + "<parameter>" + "<appField>email</appField>"
				+ "<fieldValue>13912345678</fieldValue>" + "</parameter>" + "<parameter>"
				+ "<appField>userpassword</appField>" + "<fieldValue>$#%2fheoi%@#$</fieldValue>"
				+ "</parameter>" + "</object>" + "</values>" + "</body>" + "</request>";

		ThreeDesBase64 des = new ThreeDesBase64();// 实例化一个对像
		String key = "bsb";
		String strEnc = des.encode(xmlAdd, key);// 加密字符串,返回String的密文
		LOG.debug(strEnc);
		String strDes = des.decode(strEnc, key);// 把String 类型的密文解密
		LOG.debug(strDes);
	}
}
