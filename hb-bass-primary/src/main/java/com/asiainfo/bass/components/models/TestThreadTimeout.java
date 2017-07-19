package com.asiainfo.bass.components.models;

public class TestThreadTimeout extends Thread {
	public static void main(String[] args) {
		TestThreadTimeout ttt = new TestThreadTimeout();
		ttt.start();
	}

	public void run() {
		int timeout = 2000;
		TestThread task = new TestThread();
		task.start();
		try {
			task.join(timeout);
		} catch (InterruptedException e) {
			/* if somebody interrupts us he knowswhat he is doing */
		}
		if (task.isAlive()) {
			task.interrupt();
			System.out.println("超时啦。。。");
			throw new TimeoutException("xxx");
		} else {
			System.out.println("没超时...");
		}
	}
}

class TestThread extends Thread {
	public void run() {
		try {
			Thread.sleep(5000);
			System.out.println("ccccccccccccc");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	// 如果希望run中方法正常结束，覆盖interrupt方法
	public void interrupt() {
		System.out.println("qqqqqqqqqqqqqqqq");
	}
}