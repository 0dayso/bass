package com.asiainfo.hb.bass.frame.access;

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
	private static String hexKey = "B5584A5D9B61C23BE52CA1168C9110894C4FE9ABC8E9F251";

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
		if (null == _instance) {
			try {
				_instance = new DES(DES._DESede);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		_instance.setKey(_instance.hex2byte(_instance.hexKey));
		byte[] enc=new byte[0];
		try {
			enc = _instance.encode(s.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}
		String hexenc = _instance.byte2hex(enc);
		return hexenc;
	}

	@SuppressWarnings("static-access")
	public static String decrypt(String s) throws Exception {
		if (null == _instance) {
			_instance = new DES(DES._DESede);
		}
		return new String(_instance.decode(_instance.hex2byte(s), _instance.hex2byte(_instance.hexKey)));
	}
	
	public static String encode(String strPub) {
		String strPri = "";
		/*BASE64Encoder base64en = new BASE64Encoder();*/
		try { 
			/*strPri = base64en.encode(strPub.getBytes("UTF8"));*/
			strPri = Base64.encodeBase64String(strPub.getBytes("UTF8"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return strPri;
	}

	public static String decode(String strPri) {
		/*BASE64Decoder base64De = new BASE64Decoder();*/
		String strPub = "";
		try {
			/*byte[] bytePri = base64De.decodeBuffer(strPri);*/
			byte[] bytePri = Base64.decodeBase64(strPri);
			strPub = new String(bytePri, "UTF8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return strPub;
	}

	public static void main(String[] args) throws Exception {
		String str = DES.encode("userId=lizhijian&reginId=HB.WH");
		System.out.println(str);
		System.out.println(DES.decode(str));
		
		String userIdJm = DES.encode("wangshihai");
		String userNameJm = DES.encode("李志坚");
		String regionIdJm = DES.encode("HB.SY.04");
		
		String param = "userId="+userIdJm+"&userName="+userNameJm+"&regionId="+regionIdJm;
		System.out.println(param);
		
//		System.out.println(DES.encode("ff808081554f71dc015556e079940ff91466041399700@20020011@8a998b262cab3d0f012cab3d0fec0000h1466042357769@10.27.28.130@huxuesong"));
//		String str1 = "ZmY4MDgwODE1NTRmNzFkYzAxNTU1NmUwNzk5NDBmZjkxNDY2MDQxMzk5NzAwQDIwMDIwMDExQDhhOTk4YjI2MmNhYjNkMGYwMTJjYWIzZDBmZWMwMDAwaDE0NjYwNDIzNTc3NjlAMTAuMjcuMjguMTMwQGh1eHVlc29uZw==";
//		System.out.println(DES.decode(str1));
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
