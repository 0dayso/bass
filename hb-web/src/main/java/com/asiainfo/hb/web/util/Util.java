package com.asiainfo.hb.web.util;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.awt.Graphics;

import javax.imageio.ImageIO;
import java.awt.Image;
import java.awt.Font;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

@SuppressWarnings("unused")
public class Util {
	
	private static Logger LOG = Logger.getLogger(Util.class);

	public static String getRemoteAddr(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

	public static String getTime(int index, String type) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = GregorianCalendar.getInstance();

		if (type.equals("年")) {
			calendar.add(Calendar.YEAR, index);
			return sdf.format(calendar.getTime()).substring(0, 4);
		} else if (type.equals("月")) {
			calendar.add(Calendar.MONTH, index);
			return sdf.format(calendar.getTime()).substring(0, 6);
		} else if (type.equals("日")) {
			calendar.add(Calendar.DATE, index);
			return sdf.format(calendar.getTime());
		} else {
			return "";
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println(Util.getTime(0, "日"));

	}

	/** 
     * 获取当前操作系统名称. 
     * return 操作系统名称 例如:windows xp,linux 等. 
     */ 
    public static String getOSName() {   
        return System.getProperty("os.name").toLowerCase();   
    }   
       
    /** 
     * 获取网卡的mac地址. 
     * @return mac地址 
     */ 
    public static String getMACAddress() {   
    	 String os = getOSName();   
         String mac = null;   
         BufferedReader bufferedReader = null;   
         Process process = null;   
         try {   
	         if(os.startsWith("windows")){   
	             //本地是windows   
	        	 process = Runtime.getRuntime().exec("ipconfig /all");// windows下的命令，显示信息中包含有mac地址信息   
	             bufferedReader = new BufferedReader(new InputStreamReader(process   
	                     .getInputStream()));   
	             String line = null;   
	             int index = -1;   
	             int index1 = -1;  
	             while ((line = bufferedReader.readLine()) != null) {   
	                 index = line.toLowerCase().indexOf("physical address");// 寻找标示字符串[physical address] 
	                 index1 = line.toLowerCase().indexOf("物理地址");  
	                 if (index >= 0) {// 找到了   
	                     index = line.indexOf(":");// 寻找":"的位置   
	                     if (index>=0) {   
	                         mac = line.substring(index + 1).trim();// 取出mac地址并去除2边空格   
	                     }   
	                     break;   
	                 } else if(index1 != -1){
	                	index1 = line.indexOf(":");   
	                    if (index1 != -1) {   
	                           /**  
	                            *   取出mac地址并去除2边空格  
	                            */  
	                       mac = line.substring(index1 + 1).trim();    
	                   }   
	                    break;     
	                }    
	             }   
	         }else{   
	             //本地是非windows系统 一般就是unix   
	        	 process = Runtime.getRuntime().exec("/sbin/ifconfig eth0");// linux下的命令，一般取eth0作为本地主网卡 显示信息中包含有mac地址信息   
	             bufferedReader = new BufferedReader(new InputStreamReader(process   
	                     .getInputStream()));   
	             String line = null;   
	             int index = -1;   
	             while ((line = bufferedReader.readLine()) != null) {   
	                 index = line.toLowerCase().indexOf("hwaddr");// 寻找标示字符串[hwaddr]   
	                 if (index >= 0) {// 找到了   
	                     mac = line.substring(index +"hwaddr".length()+ 1).trim();// 取出mac地址并去除2边空格   
	                     break;   
	                 }   
	             }   
	         }   
        } catch (IOException e) {   
            e.printStackTrace();   
        } finally {   
            try {   
                if (bufferedReader != null) {   
                    bufferedReader.close();   
                }   
            } catch (IOException e1) {   
                e1.printStackTrace();   
            }   
            bufferedReader = null;   
            process = null;   
        }   

        return mac;   
    }   

    public static byte[] getImageData(String userid,String ip, String mac, String menuid,String username){
		
		//String userCode = "ai_huqin";

		String fontName = "Arial-Black";
		int fontStyle = 36;
		Color color = new Color(227, 227, 227);
		int fontSize = 36;
		int x = 0;
		int y = 0;
		float alpha = 1f;
		int degree = -45;
		try {

			Calendar cn = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String dateTime = sdf.format(cn.getTime());
			String date = sdf.format(cn.getTime());
			

			String path = System.getProperty("user.dir") + "/security_image.jpg";
			File f = new File(path);
			BufferedImage bgimg = ImageIO.read(f);
			BufferedImage currentImg = getPressText(userid, bgimg, fontName, fontStyle, color, fontSize, x, y, alpha);
			y += fontSize;
			currentImg = getPressText(username, bgimg,
					fontName, fontStyle, color, fontSize, x, y, alpha);
			y += fontSize;
			currentImg = getPressText(dateTime, bgimg, fontName,
					fontStyle, color, fontSize, x, y, alpha);
			y += fontSize;
			currentImg = getPressText(ip, bgimg, fontName, fontStyle,
					color, fontSize, x, y, alpha);
			y += fontSize;
			
			currentImg = getPressText(mac, bgimg, fontName, fontStyle,
					color, fontSize, x, y, alpha);
			y += fontSize;
			
			currentImg = getPressText(menuid, bgimg, fontName, fontStyle,
					color, fontSize, x, y, alpha);
			y += fontSize;
			
			currentImg = rotateImg(currentImg, degree, Color.white);
			
			ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
			ImageIO.write(currentImg, "bmp", byteArray);
			
			return byteArray.toByteArray();
			
		} catch (Exception ex) {
			System.out.println("加水印报错：" + ex.toString());
		}
		return null;
		
	}

	public static BufferedImage rotateImg( BufferedImage image, int degree, Color bgcolor ){
	 
	  int iw = image.getWidth();//原始图象的宽度 
	  int ih = image.getHeight();//原始图象的高度  
	  int w=0;
	  int h=0; 
	  int x=0; 
	  int y=0; 
	  degree=degree%360;
	  if(degree<0)degree=360+degree;//将角度转换到0-360度之间
	  double ang=degree* 0.0174532925;//将角度转为弧度
	  
	  /**
	   *确定旋转后的图象的高度和宽度
	   */
	   
	  if(degree == 180|| degree == 0 || degree == 360){
	   w = iw; 
	   h = ih; 
	  }else if(degree == 90|| degree == 270){ 
	   w = ih; 
	   h = iw;  
	  }else{  
	   int d=iw+ih;  
	   w=(int)(d*Math.abs(Math.cos(ang)));
	   h=(int)(d*Math.abs(Math.sin(ang)));
	  }
	  
	  x = (w/2)-(iw/2);//确定原点坐标
	  y = (h/2)-(ih/2); 
	  BufferedImage rotatedImage=new BufferedImage(w,h,image.getType()); 
	  Graphics gs=rotatedImage.getGraphics();
	  gs.setColor(bgcolor);
	  gs.fillRect(0,0,w,h);//以给定颜色绘制旋转后图片的背景
	  AffineTransform at=new AffineTransform();
	  at.rotate(ang,w/2,h/2);//旋转图象
	  at.translate(x,y); 
	  AffineTransformOp op=new AffineTransformOp(at,AffineTransformOp.TYPE_NEAREST_NEIGHBOR); 
	  op.filter(image, rotatedImage); 
	  image=rotatedImage;
	  return image;
	}
	
	/**  
     * 图片水印  
     * @param pressImg 水印图片  
     * @param targetImg 目标图片  
     * @param x 修正值 默认在中间  
     * @param y 修正值 默认在中间  
     * @param alpha 透明度  
     */  
    public void pressImage(String pressImg, String targetImg, int x, int y, float alpha) {   
        try {   
            File img = new File(targetImg);   
            Image src = ImageIO.read(img);   
            int wideth = src.getWidth(null);   
            int height = src.getHeight(null);   
            BufferedImage image = new BufferedImage(wideth, height, BufferedImage.TYPE_INT_RGB);   
            Graphics2D g = image.createGraphics();   
            g.drawImage(src, 0, 0, wideth, height, null);   
            //水印文件   
            Image src_biao = ImageIO.read(new File(pressImg));   
            int wideth_biao = src_biao.getWidth(null);   
            int height_biao = src_biao.getHeight(null);   
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP, alpha));   
            g.drawImage(src_biao, (wideth - wideth_biao) / 2, (height - height_biao) / 2, wideth_biao, height_biao, null);   
            //水印文件结束   
            g.dispose();   
            ImageIO.write( image, "jpg", img);   
        } catch (Exception e) {   
            e.printStackTrace();   
        }   
    }   
    
    public BufferedImage getPressImage(String pressImg, String targetImg, int x, int y, float alpha) {   
        try {
            File img = new File(targetImg);   
            Image src = ImageIO.read(img);   
            int wideth = src.getWidth(null);   
            int height = src.getHeight(null);   
            BufferedImage image = new BufferedImage(wideth, height, BufferedImage.TYPE_INT_RGB);   
            Graphics2D g = image.createGraphics();   
            g.drawImage(src, 0, 0, wideth, height, null);   
            //水印文件   
            Image src_biao = ImageIO.read(new File(pressImg));   
            int wideth_biao = src_biao.getWidth(null);   
            int height_biao = src_biao.getHeight(null);   
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP, alpha));   
            g.drawImage(src_biao, (wideth - wideth_biao) / 2, (height - height_biao) / 2, wideth_biao, height_biao, null);   
            //水印文件结束   
            g.dispose();   
            return image;
        } catch (Exception e) {   
            e.printStackTrace();   
        }   
        return null;
    }   
  
    /**  
     * 文字水印  
     * @param pressText 水印文字  
     * @param targetImg 目标图片  
     * @param fontName 字体名称  
     * @param fontStyle 字体样式  
     * @param color 字体颜色  
     * @param fontSize 字体大小  
     * @param x 修正值  
     * @param y 修正值  
     * @param alpha 透明度  
     */  
    public void  pressText(String pressText, String targetImg, String fontName, int fontStyle, Color color, int fontSize, int x, int y, float alpha) {   
        try {   
            File img = new File(targetImg);   
            Image src = ImageIO.read(img);   
            int width = src.getWidth(null);   
            int height = src.getHeight(null);   
            BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);   
            Graphics2D g = image.createGraphics();   
            g.drawImage(src, 0, 0, width, height, null);   
            g.setColor(color);   
            g.setFont(new Font(fontName, fontStyle, fontSize));   
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP, alpha));   
            g.drawString(pressText, (width - (getLength(pressText) * fontSize)) / 2 + x, (height - fontSize) / 2 + y);   
            g.dispose();   
            ImageIO.write((BufferedImage) image, "jpg", img);   
        } catch (Exception e) {   
            e.printStackTrace();   
        }   
       
    }   
    /**  
     * 文字水印  
     * @param pressText 水印文字  
     * @param targetImg 目标图片  
     * @param fontName 字体名称  
     * @param fontStyle 字体样式  
     * @param color 字体颜色  
     * @param fontSize 字体大小  
     * @param x 修正值  
     * @param y 修正值  
     * @param alpha 透明度  
     */  
    public static BufferedImage  getPressText(String pressText, BufferedImage image, String fontName, int fontStyle, Color color, int fontSize, int x, int y, float alpha) {   
        try {   
        	Graphics2D g = image.createGraphics();   
            g.setColor(color);   
            g.setFont(new Font(fontName, fontStyle, fontSize));   
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP, alpha));   
            g.drawString(pressText, (image.getWidth() - (getLength(pressText) * fontSize)) / 2 + x, (image.getHeight() - fontSize) / 2 + y);   
            g.dispose();               
            return image;
           
        } catch (Exception e) {   
            e.printStackTrace();   
        }   
        return null;
       
    }   
    
  
    /**  
     * 缩放  
     * @param filePath 图片路径  
     * @param height 高度  
     * @param width 宽度  
     * @param bb 比例不对时是否需要补白  
     */  
    public void resize(String filePath, int height, int width, boolean bb) {   
        try {   
            double ratio = 0.0; //缩放比例    
            File f = new File(filePath);   
            BufferedImage bi = ImageIO.read(f);   
            @SuppressWarnings("static-access")
			Image itemp = bi.getScaledInstance(width, height, bi.SCALE_SMOOTH);   
            //计算比例   
            if ((bi.getHeight() > height) || (bi.getWidth() > width)) {   
                if (bi.getHeight() > bi.getWidth()) {   
                    ratio = (new Integer(height)).doubleValue() / bi.getHeight();   
                } else {   
                    ratio = (new Integer(width)).doubleValue() / bi.getWidth();   
                }   
                AffineTransformOp op = new AffineTransformOp(AffineTransform.getScaleInstance(ratio, ratio), null);   
                itemp = op.filter(bi, null);   
            }   
            if (bb) {   
                BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);   
                Graphics2D g = image.createGraphics();   
                g.setColor(Color.white);   
                g.fillRect(0, 0, width, height);   
                if (width == itemp.getWidth(null))   
                    g.drawImage(itemp, 0, (height - itemp.getHeight(null)) / 2, itemp.getWidth(null), itemp.getHeight(null), Color.white, null);   
                else  
                    g.drawImage(itemp, (width - itemp.getWidth(null)) / 2, 0, itemp.getWidth(null), itemp.getHeight(null), Color.white, null);   
                g.dispose();   
                itemp = image;   
            }   
            ImageIO.write((BufferedImage) itemp, "jpg", f);   
        } catch (IOException e) {   
            e.printStackTrace();   
        }   
    }   
    
    public static int getLength(String text) {   
        int length = 0;   
        for (int i = 0; i < text.length(); i++) {   
            if (new String(text.charAt(i) + "").getBytes().length > 1) {   
                length += 2;   
            } else {   
                length += 1;   
            }   
        }   
        return length / 2;   
    }

}
