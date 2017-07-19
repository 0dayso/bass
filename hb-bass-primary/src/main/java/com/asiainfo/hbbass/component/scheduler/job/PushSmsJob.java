package com.asiainfo.hbbass.component.scheduler.job;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;

import bass.message.ShortMessage;

/**
 *
 * @author Mei Kefu
 * @date 2010-2-23
 */
@SuppressWarnings("rawtypes")
public class PushSmsJob extends PushJob {

	private static Logger LOG = Logger.getLogger(PushSmsJob.class);

	public void push(List list, Map context) {
		String[] textArr = ((String[])list.get(0));
		String text = textArr[0];
		for (int i = 1; i < textArr.length; i++) {
			text +=","+textArr[i];
		}
		String contacts = (String)context.get("contacts");
		LOG.debug("contacts:"+contacts+" content:"+text);
		
		SendSMSWrapper.send(contacts, text);
	}
	
	public static void main(String[] args){
		
		String[] contacts={"vchenling1,13872087907","vzhangguoli,13508642567","gaojianhui,13774117401","xueyanxia,13451228339","luojie1,13886585350","lijia1,15872136822","vhuixiaoying,13886581314","huangjuan1,13593898823","heyu,15926564966","hanting1,15826535823","chengfenping,13697167430","sudexiang,13508619999","zhoutiecheng,13872361198","zhoulu,13807211505","wangli10,15826606112","lijiaxian,13972128889","vdengjinyu,13797513535","vzhumin1,13797337468","zhouquan1,15926558611","zhangtianzhi,13886647771","wujianguo,13697198311","vwangyong2,13797416178","muhanghang,13972131520","liuran,13972152133","huhao1,13972370930","hechunxiang,13507213051","guanjuan,13872338099","vdengjing,13872265859","chenkang,13972390000","zhouzuping,13872263344","vsujianghua,13986725258","liujun1,13607214021","vlixiuge,15926566608","vhuqian,13872305556","ganting,13797463788","vyinsumei,13907213111","vwangli2,13972309900","vlesujuan,13907213222","vlaitingting,15827777782","lixiaowen1,13797517176","songbin,13593888555","vwangshijun,13477811157","lizhuojun,13707210802","sunping,13908613999","yeyan,13972391918","vchenyuanyuan,13872293888","liujuan,13972125958","zhuli4,13986735919","yingmeiyan,13908610086","duanfangli,13669068569","liqing1,13797399953","lujiadan,13886558662","yuandanqing,15826554855","zhangtingting1,15826555500","dengyali,15927772111","vlizhixiang,13872366660","vningbenju,13797288207","zhangrong1,13972119898","zhangyan6,13797458333","yiyuan,15927920521","yejinzhi,13886608102","yaolan,13437226677","vxuzhiyan,13593807818","vwufanqiang,13972118889","weiniandong,13972126666","vwangqiang1,13872200295","wanwei2,13593861106","qiankongli,15971603222","suncheng1,13476971794","tanyan,13797438568","luodongmei,15872096996","liuxiafang,15027061265","xiajiajia,13872333822","xurong,13797466689","lijuan3,13872352221","lijing8,13593863113","fudongmei,13972363303","liaokunpeng,13593866698","zhouyang1,13545921075","wangjiang,15926666987","zhangxia2,13971745898","shaoying,13971702716","jiangyuan,13995901756","xiaobaiqing,15926730308","uhongwei,13986344444","vdaiyu,13972081118","wangqin8,13995788899"};
		
		for (int i = 0; i < contacts.length; i++) {
			String[] string = contacts[i].split(",");
			try {
				System.out.println(string[1]+"您的经分系统工号["+string[0]+"]已添加成功,默认密码为[jfqt2011]，欢迎您访问。");
				ShortMessage sm = new ShortMessage(string[1],"您的经分系统工号["+string[0]+"]已添加成功,默认密码为[jfqt2011]，欢迎您访问。");
				sm.sendShortMessage();
			} catch (Throwable e) {
				System.out.println("发送失败:");
				e.printStackTrace();
				
			}
		}
		
		
	}
}
