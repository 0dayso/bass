package com.asiainfo.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Random;

/**
 * 加密解密工具
 * @author yulei3
 * @date 2013-04-15
 */
public class Encrypt {
    private static final String std_ch = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    private static final String tab_ch = "SboJU9#dL,O+a&sh:c/mpIj;*FE_V64]Dvz0uf7yCnM.~)t\\rKxA<$NT=Rg`!B|PGZ{Yl\"Hq'i[@?^-%3}185we2X(QWk>";
//    private static final String std_ch = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
//    private static final String tab_ch = "3daINP6wEAx2C5oD70ZkzYKbX4rlBptcSQuimfvV1W9sLRgjenHyUh8MJTqOFG";
    private static final int size = std_ch.getBytes().length;
    private static String key;
    private static int gene;

    static {
	        try {
	            InputStream is = Encrypt.class.getResourceAsStream("/key");
	            ByteArrayOutputStream out = new ByteArrayOutputStream();
	            byte[] b = new byte[1024];
	            int n;
	            while ((n = is.read(b)) != -1) {
	                out.write(b, 0, n);
	            }
	            key = new String(out.toByteArray(), "utf-8");
	            is.close();
	            out.flush();
	            out.close();
	            gene = Math.abs(key.hashCode()) % size;
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
    }

    /**
     * 生成码表
     *
     * @return 码表
     */
    public static String createCodeTab() {
        StringBuffer sb = new StringBuffer();
        char[] c_std = std_ch.toCharArray();
        Random random = new Random();
        for (int i = c_std.length; i > 0; i--) {
            int p = random.nextInt(i);
            sb.append(c_std[p]);
            c_std[p] = c_std[i - 1];
        }
        System.out.println(sb.toString());
        return sb.toString();
    }

    /**
     * 加密
     *
     * @param text 明文
     * @return 密文
     */
    public static String encode(String text) {
        StringBuffer sb = new StringBuffer();
        char[] cx = text.toCharArray();
        for (char c : cx) {
            if (tab_ch.contains(Character.toString(c))) {
                int idx = tab_ch.indexOf(c) + gene;
                if (idx >= size) idx = idx - size;
                char cc = tab_ch.charAt(idx);
                sb.append(cc);
            } else
                sb.append(c);
//            System.out.println(sb.toString());
        }
        return sb.toString();
    }

    /**
     * 解密
     *
     * @param text 密文
     * @return 明文
     */
    public static String decode(String text) {
        StringBuffer sb = new StringBuffer();
        char[] cx = text.toCharArray();
        for (char c : cx) {
            if (tab_ch.contains(Character.toString(c))) {
                int idx = tab_ch.indexOf(c) - gene;
                if (idx < 0) idx = idx + size;
                char cc = tab_ch.charAt(idx - 0);
                sb.append(cc);
            }else sb.append(c);
        }
        return sb.toString();
    }


    public static void main(String[] args) throws UnsupportedEncodingException {
//        System.out.println(createCodeTab());
//        StringBuilder sb = new StringBuilder();
//        for(int i=33;i<127;i++){
//            sb.append((char)i);
//        }
//        System.out.println(sb);
//        String v = "Ffn./d";
        String v = "123456";
        String x = encode(v);       //加密
        String d = decode(x);       //解密
        System.out.println(v);
        System.out.println(x);
        System.out.println(d);
    }
}
