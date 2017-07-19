package com.asiainfo.hbbass.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.log4j.Logger;

import edu.emory.mathcs.backport.java.util.Collections;

/**
 * FTP包装类，
 * 
 * @author Mei Kefu
 * @date 2009-11-4
 */
public class FTPHelper {

	private static Logger LOG = Logger.getLogger(FTPHelper.class);

	private FTPClient ftpClient = null;

	private String remotePath = "/";

	private String host = "";
	private int port = 21;
	private String userName = "";
	private String passWord = "";
	private String chartset = "utf-8";

	public FTPHelper() {
		//this("yh:yh@10.31.81.246:21");
		//this("ocdc:ocdc201%%@10.25.176.201:21");
//		this("file:file@10.25.124.115:21");
		this("jfftp:1Qaz#edc@10.25.125.87:21");
	}

	public FTPHelper(String url) {

		String[] arr = url.split("@");

		String[] arr0 = arr[0].split(":");
		String[] arr1 = arr[1].split(":");

		userName = arr0[0];
		passWord = arr0[1];

		host = arr1[0];
		if (arr1.length == 2 && arr1[1].matches("[0-9]+")) {
			port = Integer.parseInt(arr1[1]);
		}
	}

	/**
	 * 链接主机
	 * 
	 * @throws SocketException
	 * @throws IOException
	 */
	public void connect() throws SocketException, IOException {
		LOG.info("开始链接主机" + host + " " + port);
		ftpClient = new FTPClient();
		ftpClient.connect(host, port);
		// ftpClient.addProtocolCommandListener( new PrintCommandListener( new
		// PrintWriter(System.out)));
		ftpClient.setControlEncoding(chartset);

		if (!ftpClient.login(userName, passWord)) {
			LOG.error("FTP登录失败，用户名密码不对");
			throw new RuntimeException("FTP登录失败，用户名密码不对");
		}
		ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
		LOG.info("链接主机" + host + "成功");
	}

	/**
	 * 断开主机连接
	 * 
	 * @throws IOException
	 */
	public void disconnect() throws IOException {
		if (ftpClient != null) {
			ftpClient.logout();
			ftpClient.disconnect();
			ftpClient = null;
		}
		
	}

	/**
	 * 上传文件 *目前还有个小bug，不能创建多级目录,需要递归创建
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public String upload(File file) throws IOException {
		LOG.info("FTP上传文件");
		String fileName = file.getName();
		String remoteAbsFile = remotePath + "/" + fileName;
		if (!ftpClient.changeWorkingDirectory(remotePath)) {
			LOG.info(remotePath + "路径不存在，创建路径");
			ftpClient.makeDirectory(remotePath);

			/*
			 * String tmpPath = remotePath.substring(1,
			 * remotePath.indexOf("/"));
			 * 
			 * while(!ftpClient.makeDirectory(tmpPath)){
			 * 
			 * }
			 */
		}

		InputStream in = new FileInputStream(file);
		// 没有判断文件名重复，重名直接覆盖
		if (!ftpClient.storeFile(new String(remoteAbsFile.getBytes(chartset), "iso-8859-1"), in)) {
			throw new RuntimeException(remoteAbsFile + "文件上传失败");
		}
		in.close();
		LOG.info("文件上传FTP服务器成功：" + remoteAbsFile);
		return remoteAbsFile;
	}

	/**
	 * 
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List listFiles() throws IOException {
		FTPFile[] ftpFiles = ftpClient.listFiles(remotePath);
		List result = new ArrayList();
		for (int i = 0; i < ftpFiles.length; i++) {
			if (ftpFiles[i].getType() == FTPFile.FILE_TYPE)
				result.add(ftpFiles[i].getName());
		}
		Collections.sort(result);
		Collections.reverse(result);
		return result;
	}

	/**
	 * 为客服满意度ppt导入增加时间属性
	 * 
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List listFiles1() throws IOException {
		FTPFile[] ftpFiles = ftpClient.listFiles(remotePath);
		List result = new ArrayList();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		for (int i = 0; i < ftpFiles.length; i++) {
			HashMap map = new HashMap();
			if (ftpFiles[i].getType() == FTPFile.FILE_TYPE) {
				map.put("fileName", ftpFiles[i].getName());
				map.put("modifyTime", sdf.format(ftpFiles[i].getTimestamp().getTime()));
				result.add(map);
			}
		}
		return result;
	}

	/**
	 * 
	 * @param file
	 * @throws IOException
	 */
	public void down(File file) throws IOException {
		LOG.info("下载文件");
		// 取远程文件的相对路径
		String fileName = file.getName();
		String remoteAbsFile = remotePath + "/" + fileName;
		String isoRemoteAbsFile = new String(remoteAbsFile.getBytes(chartset), "iso-8859-1");
		FTPFile[] ftpFiles = ftpClient.listFiles(isoRemoteAbsFile);
		LOG.info("ftpFiles.length=" + ftpFiles.length);
		if (ftpFiles.length == 1) {
			String localAbsPath = file.getAbsolutePath();

			OutputStream oStream = new FileOutputStream(file);

			if (!ftpClient.retrieveFile(new String(remoteAbsFile.getBytes(chartset), "utf-8"), oStream)) {
				LOG.info(remoteAbsFile + "文件下载失败");
				throw new RuntimeException(remoteAbsFile + "文件下载失败");
			}
			oStream.close();
			LOG.info("远程文件下载成功：" + localAbsPath);
		} else {
			LOG.error("远程文件不存在：" + remoteAbsFile);
			throw new RuntimeException("远程文件不存在：" + remoteAbsFile);
		}
	}

	/**
	 * 
	 * @param oStream
	 * @param fileName
	 * @throws IOException
	 */
	public void down(OutputStream oStream, String fileName) throws IOException {
		LOG.info("下载文件");
		// 取远程文件的相对路径
		String remoteAbsFile = remotePath + "/" + fileName;
		String isoRemoteAbsFile = new String(remoteAbsFile.getBytes(chartset), "iso-8859-1");
		FTPFile[] ftpFiles = ftpClient.listFiles(isoRemoteAbsFile);

		if (ftpFiles.length == 1) {
			if (!ftpClient.retrieveFile(isoRemoteAbsFile, oStream)) {
				throw new RuntimeException(remoteAbsFile + "文件下载失败");
			}
			LOG.info("远程文件下载成功：" + remoteAbsFile);
		} else {
			LOG.error("远程文件不存在：" + remoteAbsFile);
			throw new RuntimeException("远程文件不存在：" + remoteAbsFile);
		}
	}

	public void setRemotePath(String remotePath) {
		this.remotePath = "/home/jfftp/" + remotePath;
	}

	/**
	 * 
	 * @param fileName
	 * @throws IOException
	 */
	public void delete(String fileName) throws IOException {
		LOG.info("删除文件");
		// 取远程文件的相对路径
		String remoteAbsFile = remotePath + "/" + fileName;
		String isoRemoteAbsFile = new String(remoteAbsFile.getBytes(chartset), "iso-8859-1");
		FTPFile[] ftpFiles = ftpClient.listFiles(isoRemoteAbsFile);

		if (ftpFiles.length == 1) {
			if (!ftpClient.deleteFile(isoRemoteAbsFile)) {
				throw new RuntimeException(remoteAbsFile + "文件删除失败");
			}
			LOG.info("远程文件删除成功：" + remoteAbsFile);
		} else {
			LOG.error("远程文件不存在：" + remoteAbsFile);
			throw new RuntimeException("远程文件不存在：" + remoteAbsFile);
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void main(String[] args) {
		// FTPHelper ftp = new FTPHelper();
		// ftp.setRemotePath("asia/aaaaaa/bbbb/countyRank");
		// try {
		// ftp.connect();
		// ftp.upload(new File("c:/a.txt"));
		// ftp.disconnect();
		// } catch (SocketException e) {
		// e.printStackTrace();
		// } catch (IOException e) {
		// e.printStackTrace();
		// }

		List<String> result = new ArrayList();
		result.add("201203市场（一）");
		result.add("201203市场（二）");
		result.add("201204市场（一）");
		result.add("201204市场（二）");
		Collections.sort(result);
		Collections.reverse(result);
		for (String s : result) {
			System.out.println(s);
		}

	}

}
