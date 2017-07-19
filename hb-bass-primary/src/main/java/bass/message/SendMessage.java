package bass.message;

/*
 * Created on 2005-3-24
 *
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */

import org.apache.log4j.Logger;

import bass.message.*;

/**
 * @author maclj
 * 
 *         
 *         Window - Preferences - Java - Code Style - Code Templates
 */
@SuppressWarnings("unused")
public class SendMessage {
	private static Logger LOG = Logger.getLogger(SendMessage.class);
	private String phone;

	private String message;

	public SendMessage() {
		phone = "";
		message = "";
	}

	public SendMessage(String phone, String message) throws PhoneException {
		this.phone = "";
		this.message = "";
		if (validatePhone(phone))
			this.phone = phone;
		else
			throw new PhoneException();
		this.message = message;
	}

	public void setPhone(String phone) throws PhoneException {
		if (validatePhone(phone))
			this.phone = phone;
		else
			throw new PhoneException();
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void sendShortMessage() {
		// 2005-4-4 124网段更改ip10.25.9.10为10.25.124.80
		// 2005-11-30修改10.2.124.80为10.25.124.69
		new Client("10.25.124.81", 8000, phone, message);

	}

	private boolean validatePhone(String phone) {
		try {
			Long.parseLong(phone);
		} catch (Exception e) {
			return false;
		}
		return phone.length() <= 11 && phone.length() >= 11;
	}

	public static void main(String args[]) throws PhoneException {
		SendMessage sm = new SendMessage("13871244337", "测试socket程序");
		sm.sendShortMessage();
		LOG.debug("**************send message succuss!***********");
	}

}
