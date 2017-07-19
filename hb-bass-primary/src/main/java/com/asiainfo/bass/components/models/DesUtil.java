package com.asiainfo.bass.components.models;

public class DesUtil {

	private static String operOption = "X";

	public static String defaultStrDec(String data) {
		//long now1 = new Date().getTime();
		String result = strDec(data, operOption, null, null);
		//long now2 = new Date().getTime();
		//System.out.println(data + "\r\n耗时:" + (now2 - now1) + "\r\n" + result);
		return result;
	}


	// 支持3重des算法,firstKey必填,其他为null即可
	@SuppressWarnings("unused")
	public static String strDec(String data, String firstKey, String secondKey,
			String thirdKey) {
		int leng = data.length();
		String decStr = "";
		int[] firstKeyBt = null;
		int firstLength = 0;
		if (firstKey != null && firstKey != "") {
			firstKeyBt = strToBt(firstKey);
		}

		int iterator = leng / 16;
		int i = 0;
		for (i = 0; i < iterator; i++) {
			String tempData = data.substring(i * 16 + 0, i * 16 + 16);
			String strByte = hexToBt64(tempData);
			int[] intByte = new int[64];
			int j = 0;
			for (j = 0; j < 64; j++) {
				intByte[j] = Integer.parseInt(strByte.substring(j, j + 1));
			}
			int[] decByte = null;
			if (firstKey != null && firstKey != "") {
				int[] tempBt;
				tempBt = xor(intByte, strToBt(firstKey));
				decByte = tempBt;
			}
			decStr += byteToString(decByte);
		}
		return decStr;
	}

	/*
	 * chang the string(it's length <= 4) into the bit array
	 * 
	 * return bit array(it's length = 64)
	 */
	private static int[] strToBt(String str) {
		int leng = str.length();
		int[] bt = new int[64];
		if (leng < 4) {
			int i = 0, j = 0, p = 0, q = 0;
			for (i = 0; i < leng; i++) {
				int k = str.charAt(i);
				for (j = 0; j < 16; j++) {
					int pow = 1, m = 0;
					for (m = 15; m > j; m--) {
						pow *= 2;
					}
					// bt.set(16*i+j,""+(k/pow)%2));
					bt[16 * i + j] = (k / pow) % 2;
				}
			}
			for (p = leng; p < 4; p++) {
				int k = 0;
				for (q = 0; q < 16; q++) {
					int pow = 1, m = 0;
					for (m = 15; m > q; m--) {
						pow *= 2;
					}
					// bt[16*p+q]=parseInt(k/pow)%2;
					// bt.add(16*p+q,""+((k/pow)%2));
					bt[16 * p + q] = (k / pow) % 2;
				}
			}
		} else {
			for (int i = 0; i < 4; i++) {
				int k = str.charAt(i);
				for (int j = 0; j < 16; j++) {
					int pow = 1;
					for (int m = 15; m > j; m--) {
						pow *= 2;
					}
					// bt[16*i+j]=parseInt(k/pow)%2;
					// bt.add(16*i+j,""+((k/pow)%2));
					bt[16 * i + j] = (k / pow) % 2;
				}
			}
		}
		return bt;
	}
	
	/*
	 * chang the hex into the bit(it's length = 4)
	 * 
	 * return the bit(it's length = 4)
	 */
	private static String hexToBt4(String hex) {
		String binary = "";
		if (hex.equalsIgnoreCase("0")) {
			binary = "0000";
		} else if (hex.equalsIgnoreCase("1")) {
			binary = "0001";
		}
		if (hex.equalsIgnoreCase("2")) {
			binary = "0010";
		}
		if (hex.equalsIgnoreCase("3")) {
			binary = "0011";
		}
		if (hex.equalsIgnoreCase("4")) {
			binary = "0100";
		}
		if (hex.equalsIgnoreCase("5")) {
			binary = "0101";
		}
		if (hex.equalsIgnoreCase("6")) {
			binary = "0110";
		}
		if (hex.equalsIgnoreCase("7")) {
			binary = "0111";
		}
		if (hex.equalsIgnoreCase("8")) {
			binary = "1000";
		}
		if (hex.equalsIgnoreCase("9")) {
			binary = "1001";
		}
		if (hex.equalsIgnoreCase("A")) {
			binary = "1010";
		}
		if (hex.equalsIgnoreCase("B")) {
			binary = "1011";
		}
		if (hex.equalsIgnoreCase("C")) {
			binary = "1100";
		}
		if (hex.equalsIgnoreCase("D")) {
			binary = "1101";
		}
		if (hex.equalsIgnoreCase("E")) {
			binary = "1110";
		}
		if (hex.equalsIgnoreCase("F")) {
			binary = "1111";
		}
		return binary;
	}

	/*
	 * chang the bit(it's length = 64) into the string
	 * 
	 * return string
	 */
	private static String byteToString(int[] byteData) {
		String str = "";
		for (int i = 0; i < 4; i++) {
			int count = 0;
			for (int j = 0; j < 16; j++) {
				int pow = 1;
				for (int m = 15; m > j; m--) {
					pow *= 2;
				}
				count += byteData[16 * i + j] * pow;
			}
			if (count != 0) {
				str += "" + (char) (count);
			}
		}
		return str;
	}

	private static String hexToBt64(String hex) {
		String binary = "";
		for (int i = 0; i < 16; i++) {
			binary += hexToBt4(hex.substring(i, i + 1));
		}
		return binary;
	}

	private static int[] xor(int[] byteOne, int[] byteTwo) {
		// var xorByte = new Array(byteOne.length);
		// for(int i = 0;i < byteOne.length; i ++){
		// xorByte[i] = byteOne[i] ^ byteTwo[i];
		// }
		// return xorByte;
		int[] xorByte = new int[byteOne.length];
		for (int i = 0; i < byteOne.length; i++) {
			if (i < byteTwo.length) {
				xorByte[i] = byteOne[i] ^ byteTwo[i];
			} else {
				xorByte[i] = byteOne[i] ^ 0;
			}

		}
		return xorByte;
	}
	
}
