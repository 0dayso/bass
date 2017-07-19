package com.asiainfo.hbbass.app.action;

import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Transparency;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2010-3-3
 */
public class WatermarkAction extends Action {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(WatermarkAction.class);

	@ActionMethod(isLog = false)
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		int width = 265;
		int height = 80;
		// 创建BufferedImage对象
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		// 获取Graphics2D
		Graphics2D g2d = image.createGraphics();
		image = g2d.getDeviceConfiguration().createCompatibleImage(width, height, Transparency.TRANSLUCENT);
		g2d.dispose();
		g2d = image.createGraphics();

		// 画图
		g2d.setColor(Color.GRAY);
		g2d.setStroke(new BasicStroke(1));
		g2d.setFont(new Font("华文细黑", Font.ITALIC, 20));
		g2d.rotate(Math.toRadians(-13));
		g2d.drawString( "10.25.125.100"+ " 湖北移动经分", -18, 75);//request.getRemoteAddr()原来水印为获取客户端地址,request.getLocalAddr()获取服务端ip
		// 释放对象

		// 透明度设置 结束
		g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER));

		g2d.dispose();
		// 保存文件

		response.setContentType("image/png");
		try {
			ImageIO.write(image, "png", response.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		int width = 265;
		int height = 80;
		// 创建BufferedImage对象
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		// 获取Graphics2D
		Graphics2D g2d = image.createGraphics();
		image = g2d.getDeviceConfiguration().createCompatibleImage(width, height, Transparency.TRANSLUCENT);
		g2d.dispose();
		g2d = image.createGraphics();

		// 画图
		g2d.setColor(Color.GRAY);
		g2d.setStroke(new BasicStroke(1));
		g2d.setFont(new Font("华文细黑", Font.ITALIC, 20));
		g2d.rotate(Math.toRadians(-13));
		g2d.drawString("127.127.127.127" + " 湖北移动经分", -18, 75);

		// 释放对象

		// 透明度设置 结束
		g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER));

		g2d.dispose();
		// 保存文件

		try {
			ImageIO.write(image, "png", new java.io.File("C://test.png"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
