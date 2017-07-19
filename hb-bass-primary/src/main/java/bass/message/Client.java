package bass.message;

/*
 * Created on 2005-3-24
 * Preferences - Java - Code Style - Code Templates
 */

import java.net.*;
import java.io.*;

import org.apache.log4j.Logger;

public class Client extends Thread {
	private static Logger LOG = Logger.getLogger(Client.class);
	// 套接字 连接至服务器
	private Socket socket;

	private String phone;

	private String message;

	// 套接字连接的输入输出流，与服务端通信

	private DataOutputStream dout;

	private DataInputStream din;

	public Client(String host, int port, String phone, String message) {

		// 连接服务器
		try {
			this.phone = phone;
			this.message = message;
			// 初始化改连接
			socket = new Socket(host, port);
			// 从Socket连接中得到DataInputStream/DataOutputStream流

			din = new DataInputStream(socket.getInputStream());
			dout = new DataOutputStream(socket.getOutputStream());

			// 启动后台线程，接受通信信息
			new Thread(this).start();
		} catch (IOException ie) {
			ie.printStackTrace();
		}
	}

	// Gets called when the user types something
	private void processMessage(String message) {
		try {

			// 发送通信信息至服务端

			dout.writeUTF(message);

		} catch (IOException ie) {
			ie.printStackTrace();
		}
	}

	// Gets called when the user types something
	private void processMessage(String phone, String message) {
		try {

			// 发送通信信息至服务端
			dout.writeUTF(phone);
			dout.writeUTF(message);
			// WriteLog ss=new WriteLog();
			// ss.log("用户:"+phone+" 发送内容:"+message);
		} catch (IOException ie) {
			ie.printStackTrace();
		}
	}

	// 后台线程的运行方法,接受发送信息
	public void run() {
		try {

			while (true) {

				// first step:initial
				this.processMessage("INITIAL");

				// second step:Get the next message
				String message1 = din.readUTF();
				if (!message1.equals("REBACK")) {
					LOG.debug("应答不成功");
					continue;
				}
				// third step: send message to server
				LOG.debug("应答成功");
				this.processMessage(phone, message);

				// fourth step: receive status from server reback
				String message2 = din.readUTF();

				if (message2.equals("SUCCESS")) {
					LOG.debug("发送成功");
					break;// 跳出无限循环
				}
				if (message2.equals("FAILURE")) {
					LOG.debug("发送失败");
					continue;// 没有发送成功,重新通信
				}

			}
		} catch (IOException ie) {
			ie.printStackTrace();
		}
	}

}
