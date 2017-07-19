package bass.message;

import java.io.*;
import java.net.*;
import java.util.*;

import org.apache.log4j.Logger;

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
 * Company: AI
 * </p>
 * 
 * @author not attributable
 * @version 1.0
 */

public class Server {
	private static Logger LOG = Logger.getLogger(Server.class);

	// ServerSocket接受请求创建连接
	private ServerSocket ss;

	// A mapping from sockets to DataOutputStreams. This will
	// help us avoid having to create a DataOutputStream each time
	// we want to write to a stream.
	@SuppressWarnings("rawtypes")
	private Hashtable outputStreams = new Hashtable();

	// 构建器循环侦听请求
	public Server(int port) throws IOException {
		// All we have to do is listen
		listen(port);
	}

	@SuppressWarnings("unchecked")
	private void listen(int port) throws IOException {
		// 创建 ServerSocket
		ss = new ServerSocket(port);
		// 不断的侦听请求连接
		while (true) {
			// 抓住请求连接
			Socket s = ss.accept();
			// 创建输出流，
			DataOutputStream dout = new DataOutputStream(s.getOutputStream());
			// 保存输出流
			outputStreams.put(s, dout);
			// 为每一个连接创建线程
			new ServerThread(this, s);
		}
	}

	// 得到所有的连接输出
	@SuppressWarnings("rawtypes")
	public Enumeration getOutputStreams() {
		return outputStreams.elements();
	}

	// 发送消息至所有的客户端
	@SuppressWarnings("rawtypes")
	public void sendToAll(String message) {

		// We synchronize on this because another thread might be
		// calling removeConnection() and this would screw us up
		// as we tried to walk through the list
		synchronized (outputStreams) {

			for (Enumeration e = getOutputStreams(); e.hasMoreElements();) {

				// 得到每一个输出流
				DataOutputStream dout = (DataOutputStream) e.nextElement();

				// 发送消息
				try {
					dout.writeUTF(message);
				} catch (IOException ie) {
					LOG.debug(ie);
				}
			}
		}
	}

	// 删除套接字，相应的删除列表中的socket
	public void removeConnection(Socket s) {

		synchronized (outputStreams) {

			// 从哈希表里删除这个Socket
			outputStreams.remove(s);

			// 关闭Socket
			try {
				s.close();

			} catch (IOException ie) {

				ie.printStackTrace();
			}
		}
	}

	static public void main(String args[]) throws Exception {

		// Get the port # from the command line
		int port = Integer.parseInt(args[0]);

		new Server(port);
	}

}
