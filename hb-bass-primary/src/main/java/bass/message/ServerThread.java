package bass.message;

import java.io.*;
import java.net.*;

/**
 * <p>
 * Title:
 * </p>
 * <p>
 * Description:
 * </p>
 * <p>
 * Copyright: Copyright (c) 2004
 * </p>
 * <p>
 * Company:AI
 * </p>
 * 
 * @author not attributable
 * @version 1.0
 */

public class ServerThread extends Thread {
	// 通信服务器
	private Server server;

	// 连接客户端的Socket
	private Socket socket;

	private DataInputStream din;
	DataOutputStream dout;

	// Constructor.
	public ServerThread(Server server, Socket socket) {

		this.server = server;
		this.socket = socket;

		// 启动线程
		start();
	}

	public void run() {

		// Create a DataInputStream/DataOutputStream for communication
		try {
			din = new DataInputStream(socket.getInputStream());
			dout = new DataOutputStream(socket.getOutputStream());
		} catch (IOException io) {
			io.printStackTrace();
		}

		try {
			while (true) {
				// first step: initial
				String initial = din.readUTF();
				if (!initial.equals(Protocol.INITIAL)) {
					continue;
				}
				// second step: reback client socket
				dout.writeUTF(Protocol.REBACK);

				// third step: receive the phone num
				String phone = din.readUTF();

				// fourth step: receive short message
				String message = din.readUTF();

				// String message1=new String(message.getBytes("UTF-8") );
				// String message2=new
				// String(message.getBytes("UTF-8"),"GB2312");
				// String message3=new
				// String(message.getBytes("UTF-8"),"ISO-8859-1") ;
				// String message4=new
				// String(message.getBytes("ISO-8859-1"),"GB2312");
				message = new String(message.getBytes("GB2312"), "ISO-8859-1");

				// fifth step: invoke send message program
				try {
					Runtime.getRuntime().exec("/zhangyj/sdsm/sdsm -a 10.25.5.34:6666 -p -t " + phone + " -m " + message);
					System.out.println("/zhangyj/sdsm/sdsm -a 10.25.5.34:6666 -p -t " + phone + " -m " + message);
					System.out.println("have send a short message to " + phone);
					// sixth step : reback result status
					dout.writeUTF(Protocol.SUCCESS_STATUS);

					server.removeConnection(socket);

					break;
				} catch (Exception e) {
					dout.writeUTF(Protocol.FAILURE_STATUS);
					continue;
				}
				//

			} // End of while loop

		} // End of try block
		catch (EOFException ie) {

		} catch (IOException ie) {
			ie.printStackTrace();
		} finally {

		}
	}

}
