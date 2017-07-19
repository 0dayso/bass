package com.asiainfo.hb.web.util;

/**
 * @author wangbt
 */
import java.security.Security;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;


public class DES {

	public static int _DES = 1;
	public static int _DESede = 2;
	public static int _Blowfish = 3;

	private Cipher p_Cipher;
	private SecretKey p_Key;
	private String p_Algorithm;
	private static DES _instance;
	private static String hexKey = "B5584A5D9B61C23BE52CA1168C9110894C4FE9ABC8E9F251";// 密钥

	private void selectAlgorithm(int al) {
		switch (al) {
		default:
		case 1:
			this.p_Algorithm = "DES";
			break;
		case 2:
			this.p_Algorithm = "DESede";
			break;
		case 3:
			this.p_Algorithm = "Blowfish";
			break;
		}
	}

	@SuppressWarnings("restriction")
	public DES(int algorithm) throws Exception {
		this.selectAlgorithm(algorithm);
		Security.addProvider(new com.sun.crypto.provider.SunJCE());
		this.p_Cipher = Cipher.getInstance(this.p_Algorithm);
	}

	public byte[] getKey() {
		return this.checkKey().getEncoded();
	}

	private SecretKey checkKey() {
		try {
			if (this.p_Key == null) {
				KeyGenerator keygen = KeyGenerator.getInstance(this.p_Algorithm);
				/*
				 * SecureRandom sr = new SecureRandom(key.getBytes());
				 * keygen.init(168, sr);
				 */
				this.p_Key = keygen.generateKey();
			}
		} catch (Exception nsae) {
		}
		return this.p_Key;
	}

	public void setKey(byte[] enckey) {
		this.p_Key = new SecretKeySpec(enckey, this.p_Algorithm);
	}

	public byte[] encode(byte[] data) throws Exception {
		this.p_Cipher.init(Cipher.ENCRYPT_MODE, this.checkKey());
		return this.p_Cipher.doFinal(data);
	}

	public byte[] decode(byte[] encdata, byte[] enckey) throws Exception {
		this.setKey(enckey);
		this.p_Cipher.init(Cipher.DECRYPT_MODE, this.p_Key);
		return this.p_Cipher.doFinal(encdata);
	}

	public String byte2hex(byte[] b) {
		String hs = "";
		String stmp = "";
		for (int i = 0; i < b.length; i++) {
			stmp = Integer.toHexString(b[i] & 0xFF);
			if (stmp.length() == 1) {
				hs += "0" + stmp;
			} else {
				hs += stmp;
			}
		}
		return hs.toUpperCase();
	}

	public byte[] hex2byte(String hex) throws IllegalArgumentException {
		if (hex.length() % 2 != 0) {
			System.out.println("hex:" + hex + "\nlength:" + hex.length());
			throw new IllegalArgumentException();
		}
		char[] arr = hex.toCharArray();
		byte[] b = new byte[hex.length() / 2];
		for (int i = 0, j = 0, l = hex.length(); i < l; i++, j++) {
			String swap = "" + arr[i++] + arr[i];
			int byteint = Integer.parseInt(swap, 16) & 0xFF;
			b[j] = new Integer(byteint).byteValue();
		}
		return b;
	}

	public static String encrypt(String s){
		// byte[] key; //密钥文件(byte)
		if (null == _instance) {
			try {
				_instance = new DES(DES._DESede);
			} catch (Exception e) {
		
				e.printStackTrace();
			}
		}
		// key = _instance.getKey();
		_instance.setKey(_instance.hex2byte(DES.hexKey));
		// String hexkey = _instance.byte2hex(key); //生成十六进制密钥
		byte[] enc=new byte[0];
		try {
			enc = _instance.encode(s.getBytes());
		} catch (Exception e) {
			
			e.printStackTrace();
		} // 生成加密文件(byte)
		String hexenc = _instance.byte2hex(enc);
		// System.out.println("hexkey:"+hexkey);
		// System.out.println("hexenc:"+hexenc);
		return hexenc;
	}

	public static String decrypt(String s) throws Exception {
		if (null == _instance) {
			_instance = new DES(DES._DESede);
		}
		return new String(_instance.decode(_instance.hex2byte(s), _instance.hex2byte(DES.hexKey)));
	}
	
	/**
	 * 加密String明文输入,String密文输出
	 * 
	 * @param strPub 明文字符
	 * @return
	 */
	public static String encode(String strPub) {
		String strPri = "";
		try { 
			strPri = Base64.encodeBase64String(strPub.getBytes("UTF8"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return strPri;
	}

	/**
	 * 解密 以String密文输入,String明文输出
	 * 
	 * @param strMi
	 * @return
	 */
	public static String decode(String strPri) {
		String strPub = "";
		try {
			byte[] bytePri = Base64.decodeBase64(strPri);
			strPub = new String(bytePri, "UTF8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return strPub;
	}


	public static void main(String[] args) throws Exception {
//		String token = DES.decode("ZmY4MDgwODE0MTBiMjczYjAxNDExMDFjYzBhYTAwMDMxMzc4OTU0ODIxODAyQDhhOWVhYzk1M2ZjMjhiNzMwMTQxMDdhMzVkZjEwNDIwQGZmODA4MDgxMzE4OTkyYWEwMTMxOGQ2ODJmOTkwMDEzQDEwLjI1LjguNDJAemhhbmd3ZWk=");
		//		String sessionID = token.split("@")[0];
//		String accountID = token.split("@")[1];
//		String appID = token.split("@")[2];
//		String IP = token.split("@")[3];
//		String userID = token.split("@")[4];
//		System.out.println(DES.encrypt("Jfxt@2015"));
//		System.out.println(DES.decrypt("52268D33F50B144B"));
//		System.out.println(DES.decrypt("F7ACAEB4BDE271F0FD5024B6C2EE9F4B"));

	}

}
