package com.asiainfo.hbbass.bir;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.Token;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.cn.smart.SmartChineseAnalyzer;

/**
 * 
 * @author Mei Kefu
 * @date 2010-1-25
 */
@SuppressWarnings({ "unchecked", "unused" })
public class Segment {

	@SuppressWarnings("rawtypes")
	public static Set dic = new HashSet();

	private static int maxWordLen = 0;

	static {
		String[] _dic = "中高,签约,月租,统付,TD,本地,真实,互转,高危,方案,PC,话,解决,主动,保有,大于,单价,次,份额,标准,合计,大众,MAS,费用,开通,余额,校信通,回收,ADC,流失,WAP,市话,上年,国际,农信通,定购,港澳台,套餐,梦网,下载,非IP,点对点,品牌,VPMN,新,动力100,邮箱,户均,附卡,信息,139,会员,通信,IP,其它,号簿管家,化,高级,订购,在网,主卡,纯度,呼转,条,上网,端,省内,零次,本,增幅,注册,使用,增值,SP,来电,数据,含,产品,不,存活,欠,提醒,俱乐部,手机,无线,全球通,新版,预存,款,捆绑,话务,音乐,合家欢,缴,年,发展,其他,量,占比,ARPM,总,10元,出帐,活跃,每,三月,省际,以上,金额,彩信,手机报,GPRS,长途,被叫,关注,主叫,付,拍照,及,流量,活动,出账,短信,行业,业务,188,有价值,网内,ARPU,关键人,重点,飞信,彩铃,与,开门红,人均,普及,MOU,漫游,186,固话,小灵通,两家,款,WLAN,入网,指标,当,189,156,V网,三家,到达,成员,计,G网,净增,C网,移动,离网,费,占有,市场,时长,收入,集团,率,联通,电信,客户,新增,通话,高校,累计,区域化,用户,月,数,日"
				.split(",");

		for (int i = 0; i < _dic.length; i++) {

			if (_dic[i].length() > maxWordLen) {
				maxWordLen = _dic[i].length();
			}

			dic.add(_dic[i].intern());
		}
	}

	/*
	 * public static String segment(String sentence){ if(sentence!=null &&
	 * sentence.length()>0){ List terms = new ArrayList();
	 * 
	 * int pos = sentence.length();
	 * 
	 * int offset = 0;
	 * 
	 * while(pos>0){ int start = pos-maxWordLen;
	 * 
	 * if(start<0){ start=0; } start += offset; if(start<pos){ String tempTerm =
	 * sentence.substring(start, pos);
	 * 
	 * if(dic.contains(tempTerm)){ terms.add(tempTerm); pos -=
	 * tempTerm.length(); offset=0; }else{ offset++; } }else{ pos--; offset=0; }
	 * }
	 * 
	 * StringBuilder sb = new StringBuilder(); for (int i = terms.size()-1; i >=
	 * 0; i--) { sb.append(terms.get(i)).append(","); }
	 * 
	 * if(sb.length()>0){ sb.deleteCharAt(sb.length()-1); return sb.toString();
	 * }else{ return sentence; } }else { return ""; } }
	 */

	@SuppressWarnings({ "deprecation" })
	public static String segment(String str) {
		Token nt = new Token();
		Analyzer ca = new SmartChineseAnalyzer();
		Reader sentence = new StringReader(str);
		TokenStream ts = ca.tokenStream("sentence", sentence);
		StringBuilder sb = new StringBuilder();
		long before = System.currentTimeMillis();
		try {
			nt = ts.next(nt);

			while (nt != null) {
				sb.append(nt.term().toUpperCase()).append(",");
				nt = ts.next(nt);
			}
			ts.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (sb.length() > 0) {
			sb.deleteCharAt(sb.length() - 1);
		}
		return sb.toString();
	}

	@SuppressWarnings({ "deprecation" })
	public static void main(String[] args) {

		System.out.println(segment("区域化日电信C网离网用户数"));

		// System.out.println(segment("WLAN"));

		Token nt = new Token();
		Analyzer ca = new SmartChineseAnalyzer();
		String str = "区域化三家日累计市场占有率(移动)";
		String str2 = "我从小就不由自主地认为自己长大以后一定得成为一个象我父亲一样的画家, 可能是父母潜移默化的影响。其实我根本不知道作为画家意味着什么，我是否喜欢，最重要的是否适合我，我是否有这个才华。其实人到中年的我还是不确定我最喜欢什么，最想做的是什么？我相信很多人和我一样有同样的烦恼。毕竟不是每个人都能成为作文里的宇航员，科学家和大教授。知道自己适合做什么，喜欢做什么，能做好什么其实是个非常困难的问题。"
				+ "幸运的是，我想我的孩子不会为这个太过烦恼。通过老大，我慢慢发现美国高中的一个重要功能就是帮助学生分析他们的专长和兴趣，从而帮助他们选择大学的专业和未来的职业。我觉得帮助一个未成形的孩子找到她未来成长的方向是个非常重要的过程。"
				+ "美国高中都有专门的职业顾问，通过接触不同的课程，和各种心理，个性，兴趣很多方面的问答来帮助每个学生找到最感兴趣的专业。这样的教育一般是要到高年级才开始， 可老大因为今年上计算机的课程就是研究一个职业走向的软件项目，所以她提前做了这些考试和面试。看来以后这样的教育会慢慢由电脑来测试了。老大带回家了一些试卷，我挑出一些给大家看看。这门课她花了2个多月才做完，这里只是很小的一部分。" + "在测试里有这样的一些问题："
				+ "你是个喜欢动手的人吗？ 你喜欢修东西吗？你喜欢体育运动吗？你喜欢在室外工作吗？你是个喜欢思考的人吗？你喜欢数学和科学课吗？你喜欢一个人工作吗？你对自己的智力自信吗？你的创造能力很强吗？你喜欢艺术，音乐和戏剧吗？  你喜欢自由自在的工作环境吗？你喜欢尝试新的东西吗？ 你喜欢帮助别人吗？你喜欢教别人吗？你喜欢和机器和工具打交道吗？你喜欢当领导吗？你喜欢组织活动吗？你什么和数字打交道吗？";
		Reader sentence = new StringReader(str);
		TokenStream ts = ca.tokenStream("sentence", sentence);

		long before = System.currentTimeMillis();
		try {
			nt = ts.next(nt);

			while (nt != null) {
				System.out.print(nt.term());
				System.out.print(",");
				nt = ts.next(nt);
			}
			ts.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
