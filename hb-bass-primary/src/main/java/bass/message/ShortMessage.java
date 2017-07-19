package bass.message;

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

public class ShortMessage {
	private String phone = "";
	private String message = "";

	public ShortMessage() {
	}

	public ShortMessage(String phone, String message) throws PhoneException {
		if (validatePhone(phone)) {
			this.phone = phone;
		} else {
			throw new PhoneException();
		}
		this.message = message;
	}

	public void setPhone(String phone) throws PhoneException {

		if (validatePhone(phone)) {
			this.phone = phone;
		} else {
			throw new PhoneException();

		}
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void sendShortMessage() {
		// ���������ͨ�ţ�֪ͨ���������ó����Ͷ���
		// 2004-4-4 �޸�ip 10.25.9.10Ϊ10.25.124.80
		// 2005-11-30 �޸�ip 10.25.124.80Ϊ10.25.124.69
		new Client("10.25.124.217", 8000, phone, message);
		// new Client("10.25.125.111",8000,phone,message);
	}

	private boolean validatePhone(String phone) {
		try {
			Long.parseLong(phone);
		} catch (Exception e) {

			return false;
		}
		if (phone.length() > 11 || phone.length() < 11) {

			return false;
		}

		return true;
	}

	public static void main(String args[]) throws PhoneException {
		ShortMessage sm = new ShortMessage("13871244337", "��ľ�Ӫ����ϵͳ��¼������ hbcmccac,�������Ʊ���,��ʱ��¼ϵͳ���޸�����!");
		sm.sendShortMessage();
		System.out.println("**************send message succuss!***********");

	}

}
