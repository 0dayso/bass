package com.asiainfo.bass.components.models;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;

/**
 * @author helei
 * @date 2011-08-15
 */
public class ZIPUtil {
	private static ZIPUtil zu = null;

	public static ZIPUtil getInstance() {
		if (zu == null)
			zu = new ZIPUtil();
		return zu;
	}

	private ZIPUtil() {
	}

	public void CreateZipFile(String filePath, String zipFilePath) {
		FileOutputStream fos = null;
		ZipOutputStream zos = null;
		try {
			fos = new FileOutputStream(zipFilePath);
			zos = new ZipOutputStream(fos);
			writeZipFile(new File(filePath), zos, "");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if (zos != null)
					zos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				if (fos != null)
					fos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	private void writeZipFile(File f, ZipOutputStream zos, String hiberarchy) {
		if (f.exists()) {
			if (f.isDirectory()) {
				hiberarchy += f.getName() + "/";
				File[] fif = f.listFiles();
				for (int i = 0; i < fif.length; i++) {
					writeZipFile(fif[i], zos, hiberarchy);
				}

			} else {
				FileInputStream fis = null;
				try {
					fis = new FileInputStream(f);
					ZipEntry ze = new ZipEntry(hiberarchy + f.getName());
					zos.putNextEntry(ze);
					byte[] b = new byte[1024];
					while (fis.read(b) != -1) {
						zos.write(b);
						b = new byte[1024];
					}
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} finally {
					try {
						if (fis != null)
							fis.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}

			}
		}

	}

	public static void main(String args[]) {
		ZIPUtil zu = ZIPUtil.getInstance();
		String path = System.getProperty("user.dir") + File.separator;
		System.out.println("path=" + path);
		zu.CreateZipFile(path + "test", path + "test.zip");
	}
}
