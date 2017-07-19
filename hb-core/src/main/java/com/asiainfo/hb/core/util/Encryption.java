package com.asiainfo.hb.core.util;

/**
 * @author Mei Kefu
 */
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class Encryption {

	public static int _DES = 1;
	public static int _DESede = 2;
	public static int _Blowfish = 3;

	private Cipher p_Cipher;
	private SecretKey p_Key;
	private String p_Algorithm;
	private static Encryption _instance;
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

	public Encryption(int algorithm) throws Exception {
		this.selectAlgorithm(algorithm);
		//java.security.Security.addProvider(new com.sun.crypto.provider.SunJCE());
		this.p_Cipher = Cipher.getInstance(this.p_Algorithm);
	}

	public byte[] getKey() {
		return this.checkKey().getEncoded();
	}

	private SecretKey checkKey() {
		try {
			if (this.p_Key == null) {
				KeyGenerator keygen = KeyGenerator
						.getInstance(this.p_Algorithm);
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

	@SuppressWarnings("static-access")
	public static String encrypt(String s){
		try{
			// byte[] key; //密钥文件(byte)
			if (null == _instance) {
				_instance = new Encryption(Encryption._DESede);
			}
			// key = _instance.getKey();
			_instance.setKey(_instance.hex2byte(_instance.hexKey));
			// String hexkey = _instance.byte2hex(key); //生成十六进制密钥
			byte[] enc = _instance.encode(s.getBytes()); // 生成加密文件(byte)
			String hexenc = _instance.byte2hex(enc);
			return hexenc;
		}catch(Exception e){
			e.printStackTrace();
			return s;
		}
	}

	@SuppressWarnings("static-access")
	public static String decrypt(String s){
		try{
			if (null == _instance) {
				_instance = new Encryption(Encryption._DESede);
			}
			return new String(_instance.decode(_instance.hex2byte(s),
					_instance.hex2byte(_instance.hexKey)));
		}catch(Exception e){
			e.printStackTrace();
			return s;
		}	
	}
	
	static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
		'a', 'b', 'c', 'd', 'e', 'f' };
	
	public static String md5Encode(String string){
		try {
			MessageDigest digest = MessageDigest.getInstance("MD5");
			byte[] md = digest.digest(string.getBytes());
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return String.valueOf(str);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return string;
	}
	
	/*
	public static String md5Encode(String sourceString) {
		String resultString = null;
		try {
			resultString = new String(sourceString);
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] bytes = md.digest(resultString.getBytes());
			StringBuffer buf = new StringBuffer(bytes.length * 2);
			for (int i = 0; i < bytes.length; i++) {
				if (((int) bytes[i] & 0xff) < 0x10) {
					buf.append("0");
				}
				buf.append(Long.toString((int) bytes[i] & 0xff, 16));
			}
			return buf.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultString;
	}
	*/
}
