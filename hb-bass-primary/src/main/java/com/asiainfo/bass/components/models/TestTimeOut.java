package com.asiainfo.bass.components.models;

public class TestTimeOut {
	public static void main(String a[]) {
		TimeoutThread timeOutThread = new TimeoutThread(3000, new TimeoutException("time out!"));
		try {
			timeOutThread.start();

			Thread.sleep(5000);
			timeOutThread.cancel();
		} catch (TimeoutException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
