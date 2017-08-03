package com.asiainfo.hb.ftp.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.log4j.Logger;

public class FtpUtil {

	private static Logger LOG = Logger.getLogger(FtpUtil.class);

	private FTPClient ftpClient = null;

	private String host = "";
	private int port = 21;
	private String userName = "";
	private String passWord = "";
	private String chartset = "UTF-8";

	public FtpUtil() {
		// this("yh:yh@10.31.81.246:21");
		// this("file:file@10.25.124.115:21");
		this("jfftp:1Qaz#edc@10.25.125.87:21");
//		this("jfftp:1Qaz#edc@192.168.1.200:21");
		
	}

	public FtpUtil(String url) {
		String[] arr = url.split("@");

		if (arr.length > 2) {
			for (int m = 1; m < arr.length - 1; m++) {
				arr[0] = arr[0] + "@" + arr[m];
			}
			arr[1] = arr[arr.length - 1];
		}

		String[] arr0 = arr[0].split(":");
		String[] arr1 = arr[1].split(":");

		userName = arr0[0];
		passWord = arr0[1];

		LOG.debug("userName=====" + userName);
		LOG.debug("passWord=====" + passWord);

		host = arr1[0];
		if (arr1.length == 2 && arr1[1].matches("[0-9]+")) {
			port = Integer.parseInt(arr1[1]);
		}
	}

	public String getChartset() {
		return chartset;
	}

	public void setChartset(String chartset) {
		this.chartset = chartset;
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

		// FTPClientConfig conf = new
		// FTPClientConfig(FTPClientConfig.SYST_UNIX);
		// conf.setServerLanguageCode("en");
		// ftpClient.config(conf);
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
	 * 上传文件
	 * 
	 * @param
	 * @return
	 * @throws IOException
	 */
	public void upload(File file) throws IOException {
		upload("/" + file.getName(), file);// 直接上传到根目录
	}

	/**
	 * 上传文件
	 * 
	 * @param remoteAbsFileName
	 *            : 绝对路径如 /path/subPath/filename.txt
	 * @param file
	 *            : 本地保存文件
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void upload(String remoteAbsFileName, File file) throws IOException {
		LOG.info("FTP上传文件");

		String dirStr = "";
		if (remoteAbsFileName.startsWith("/")) {
			dirStr = "home/jfftp";
		} else {
			dirStr = "home/jfftp/";
		}

		remoteAbsFileName = dirStr + remoteAbsFileName;
		Map map = parseFileName(remoteAbsFileName);
		String remoteAbsFile = (String) map.get("remoteAbsFileName");
		List pathArray = (List) map.get("pathArray");

		for (int i = pathArray.size() - 1; i >= 0; i--) {// 创建多级目录
			String c_path = (String) pathArray.get(i);
			if (!ftpClient.changeWorkingDirectory(c_path)) {
				LOG.warn(c_path + "路径不存在，创建路径");
				ftpClient.makeDirectory(c_path);
			}
		}

		InputStream in = new FileInputStream(file);
		// 没有判断文件名重复，重名直接覆盖
		// if(!ftpClient.storeFile(new
		// String(remoteAbsFile.getBytes(chartset),"iso-8859-1"), in)){
		// throw new RuntimeException(remoteAbsFile+"文件上传失败");
		// }
		if (chartset.equals("utf-8")) {
			boolean b = ftpClient.storeFile(remoteAbsFile, in);
			System.out.println(b);
			// if(!ftpClient.storeFile(remoteAbsFile, in)){
			// throw new RuntimeException(remoteAbsFile+"文件上传失败");
			// }
		} else {
			ftpClient.storeFile(new String(remoteAbsFile.getBytes(chartset), "iso-8859-1"), in);
		}
		//
		in.close();
		LOG.info("文件上传FTP服务器成功：" + remoteAbsFile);
	}

	/**
	 * 查询目录的下的文件
	 * 
	 * @param path
	 *            ： 远程的路径
	 * @return 返回文件名列表
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public List listFiles(String path) throws IOException {
		return listFiles(path, false);
	}

	/**
	 * 查询目录的下的文件
	 * 
	 * @param path
	 *            ： 远程的路径
	 * @param deep
	 *            : 是否遍历子目录
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public List listFiles(String path, boolean deep) throws IOException {
		List result = new ArrayList();
		fetchAbsFileName(path, result, deep);
		return result;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected void fetchAbsFileName(String path, List list, boolean isRec) throws IOException {
		if (path == null || path.length() == 0) {
			path = "/";
		} else if (!path.equals("/")) {
			if (!path.startsWith("/")) {
				path = "/" + path;
			}

			if (!path.endsWith("/")) {
				path = path + "/";
			}
		}
		FTPFile[] ftpFiles = ftpClient.listFiles(path);
		for (int i = 0; i < ftpFiles.length; i++) {
			if (ftpFiles[i].getType() == FTPFile.FILE_TYPE) {
				list.add(path + ftpFiles[i].getName());
			} else if (ftpFiles[i].getType() == FTPFile.DIRECTORY_TYPE && !ftpFiles[i].getName().equals(".") && !ftpFiles[i].getName().equals("..") && isRec) {
				fetchAbsFileName(path + ftpFiles[i].getName(), list, isRec);
			}
		}
	}

	/**
	 * 下载文件
	 * 
	 * @param remoteAbsFileName
	 *            ： 绝对路径 如/path/subPath/filename.txt
	 * @param file
	 *            ： 本地下载的路径
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void down(String remoteAbsFileName, File file) throws IOException {
		LOG.info("下载文件");
		// 取远程文件的相对路径
		Map map = parseFileName(remoteAbsFileName);
		String remoteAbsFile = (String) map.get("remoteAbsFileName");
		String isoRemoteAbsFile = new String(remoteAbsFile.getBytes(chartset), "iso-8859-1");
		FTPFile[] ftpFiles = ftpClient.listFiles(isoRemoteAbsFile);

		if (ftpFiles.length == 1) {
			String localAbsPath = file.getAbsolutePath();

			OutputStream oStream = new FileOutputStream(file);

			if (!ftpClient.retrieveFile(isoRemoteAbsFile, oStream)) {
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
	 * 下载文件
	 * 
	 * @param remoteAbsFileName
	 *            ： 绝对路径 如/path/subPath/filename.txt
	 * @param oStream
	 *            ： 下载文件的输出流
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void down(String remoteAbsFileName, OutputStream oStream) throws IOException {
		LOG.info("下载文件");
		// 取远程文件的相对路径
		Map map = parseFileName(remoteAbsFileName);
		String remoteAbsFile = (String) map.get("remoteAbsFileName");
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

	/**
	 * 解析文件的路径，区分相对路径与绝对路径，如果传进来的是/开头就是绝对路径，如果不以/开头就是相对路径，程序通过调用pwd命令来自动加上前缀路径
	 * 返回 fileName属性 解析出来的文件名 /a/b/c/d/filename.txt => filename.txt
	 * remoteAbsFileName 属性 /a/b/c/d/filename.txt pathArray 属性
	 * <list>[/a/b/c/d/,/a/b/c,/a/b,/a]返回所有的路径为了递归创建远程目录使用
	 * 
	 * @param remoteFileName
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map parseFileName(String remoteAbsFileName) {
		/*
		 * String tempRemoteAbs =
		 * remoteAbsFileName.startsWith("/")?remoteAbsFileName
		 * .substring(1):remoteAbsFileName;//先去掉最开始的‘/’ int
		 * lastSepLoc=tempRemoteAbs.lastIndexOf("/"); Map map = new HashMap();
		 * if(lastSepLoc>0){//存在 字符‘/’ String path =
		 * tempRemoteAbs.substring(0,lastSepLoc); String fileName=
		 * tempRemoteAbs.substring(lastSepLoc+1); map.put("fileName", fileName);
		 * map.put("remoteAbsFileName", "/"+tempRemoteAbs);
		 * 
		 * List pathArray = new ArrayList(); pathArray.add("/"+path);
		 * 
		 * while(path.indexOf("/")>0){ path =
		 * path.substring(0,path.lastIndexOf("/")); pathArray.add("/"+path); }
		 * 
		 * map.put("pathArray", pathArray); }else{ map.put("fileName",
		 * tempRemoteAbs); List pathArray = new ArrayList(); pathArray.add("/");
		 * map.put("pathArray", pathArray); map.put("remoteAbsFileName",
		 * "/"+tempRemoteAbs); }
		 */

		if (!remoteAbsFileName.startsWith("/")) {
			String prefixPath = "";
			try {
				ftpClient.pwd();
			} catch (IOException e) {
				e.printStackTrace();
			}
			Pattern p = Pattern.compile(".*257 \"(.*)\" is current directory.*");
			Matcher m = p.matcher(ftpClient.getReplyString().replaceAll("\r\n", ""));
			if (m.matches()) {
				prefixPath = m.group(1);
			}
			remoteAbsFileName = prefixPath + (prefixPath.length() > 1 ? "/" : "") + remoteAbsFileName;
		}

		String tempRemoteAbs = remoteAbsFileName.startsWith("/") ? remoteAbsFileName.substring(1) : remoteAbsFileName;// 先去掉最开始的‘/’
		int lastSepLoc = tempRemoteAbs.lastIndexOf("/");
		Map map = new HashMap();
		if (lastSepLoc > 0) {// 存在 字符‘/’
			String path = tempRemoteAbs.substring(0, lastSepLoc);
			String fileName = tempRemoteAbs.substring(lastSepLoc + 1);
			map.put("fileName", fileName);
			map.put("remoteAbsFileName", "/" + tempRemoteAbs);

			List pathArray = new ArrayList();
			pathArray.add("/" + path);

			while (path.indexOf("/") > 0) {
				path = path.substring(0, path.lastIndexOf("/"));
				pathArray.add("/" + path);
			}

			map.put("pathArray", pathArray);
		} else {
			map.put("fileName", tempRemoteAbs);
			List pathArray = new ArrayList();
			pathArray.add("/");
			map.put("pathArray", pathArray);
			map.put("remoteAbsFileName", "/" + tempRemoteAbs);
		}
		return map;

	}

	/**
	 * 删除文件
	 * 
	 * @param remoteAbsFileName
	 *            ： 绝对路径 如/path/subPath/filename.txt
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void delete(String remoteAbsFileName) throws IOException {
		LOG.info("删除文件");
		// 取远程文件的相对路径
		Map map = parseFileName(remoteAbsFileName);
		String remoteAbsFile = (String) map.get("remoteAbsFileName");
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

	public static void main(String[] args) {
		FtpUtil ftp = new FtpUtil("bass:bass@111w@10.25.124.111:21");
		// ftp.setRemotePath("asia/aaaaaa/bbbb/countyRank");
		try {
			ftp.connect();
			ftp.upload(new File("c:/a.txt"));
			ftp.disconnect();
		} catch (SocketException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
