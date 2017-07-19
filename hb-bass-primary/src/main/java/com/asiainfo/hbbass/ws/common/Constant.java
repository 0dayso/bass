package com.asiainfo.hbbass.ws.common;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang.RandomStringUtils;

public final class Constant {

	/**
	 * WebService命名空间
	 */
	public static final String TARGET_NAMESPACE_JF = "http://www.asiainfo-linkage.com/jfxt2017";
	public static final String TARGET_NAMESPACE_4A = "http://SoapTreasury4A.boco.com.cn";

	/**
	 * 请求系统命名
	 */
	public static final String REQUEST_SYSTEMAPP_4A = "4A";
	public static final String REQUEST_SYSTEMAPP_JF = "JFXT";

	/**
	 * 对于4A系统经分APP_ID
	 */
	public static final String APP_ID = "8a998b262cab3d0f012cab3d0fec0000";

	/**
	 * ws访问修改参数加密CODE
	 */
	public static final String REQUEST_PASSWORD = "JFXT2012";

	/**
	 * soap返回解析信息
	 */
	public static final String SOAP_XPATH = "/soap:Envelope/soap:Body/ns1:executeXMLResponse/responseXML";
	
	/**
     * 是(真)
     */
    public static final String TRUE  = "Y";
    /**
     * 否(假)
     */
    public static final String FALSE = "N";

    /**
     * 缺省字符
     */
    public static final String DEFAULT_CODE = "0";
    
    /**
     * 场景状态-- 正常：1  应急：0已授权：2 未知：3
     */
    public static final String RESULT_STATUS_EXIGENCE = "0";
    public static final String RESULT_STATUS_NONAML = "1";
    public static final String RESULT_STATUS_PASS = "2";
    public static final String RESULT_STATUS_UNKNOW = "3";

	public static String getCurrentDate() {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return f.format(new Date());
	}
	
	public static String getVisitDateStr() {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		return f.format(new Date());
	}

	/**
	 * 生成32位随机id，其中只包含26个字母和10个数字
	 */
	public static String getRandomMsgId() {
		char[] chs = new char[] { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
				'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6',
				'7', '8', '9' };
		String randomString = RandomStringUtils.random(32, 0, chs.length, true, true, chs);
		return randomString;
	}
	
	//日KPI场景ID
	public static String DAY_KPI_SCENEID = "8a9987ee3b2b4630013b2b46e9070568";
	
	//月KPI场景ID
	public static String MONTH_KPI_SCENEID = "8a9987ee3b2b4630013b2b466b5b022a";
	
	//虚假集团客户成员清单场景ID
	public static String GROUP2_SCENEID = "8a9987ee3b2b4630013b2b4635660022";
	
	//集团客户关键人清单场景ID
	public static String GROUP3_SCENEID = "8a9987ee3b2b4630013b2b4636ce0031";
	
	//农信通订购用户清单场景ID
	public static String GROUP5_SCENEID = "8a9987ee3b2b4630013b2b4637c8003c";
	
	//校信通订购用户清单场景ID
	public static String GROUP6_SCENEID = "8a9987ee3b2b4630013b2b46393f0052";
	
	//动力100订购业务清单下载场景ID
	public static String GROUP7_SCENEID = "8a9987ee3b2b4630013b2b4639db0059";
	
	//集团客户成员中拍照中高端客户预警明细场景ID
	public static String GROUP8_SCENEID = "8a9987ee3b2b4630013b2b463a39005d";
	
	//集团客户欠费清单场景ID
	public static String GROUP9_SCENEID = "8a9987ee3b2b4630013b2b463a48005e";
	
	//集团客户产品订购明细场景ID
	public static String GROUP10_SCENEID = "8a9987ee3b2b4630013b2b463ab60064";
	
	//重点关注集团关键人清单场景ID
	public static String GROUP11_SCENEID = "8a9987ee3b2b4630013b2b463b33006b";
	
	//2011年拍照跟踪清单场景ID
	public static String GROUP12_SCENEID = "8a9987ee3b2b4630013b2b463b90006e";
	
	//集团价值评估清单场景ID
	public static String GROUP13_SCENEID = "8a9987ee3b2b4630013b2b463bb00070";
	
	//无线商话号码清单场景ID
	public static String GROUP14_SCENEID = "8a9987ee3b2b4630013b2b463fc70091";
	
	//无线商话订购集团清单场景ID
	public static String GROUP15_SCENEID = "8a9987ee3b2b4630013b2b4640820096";
	
	//S前缀集团订购产品清单场景ID
	public static String GROUP16_SCENEID = "8a9987ee3b2b4630013b2b46411e0099";
	
	//重点关注集团数据下载场景ID
	public static String GROUP17_SCENEID = "8a9987ee3b2b4630013b2b46414d009a";
	
	//集团客户信息化产品欠费明细场景ID
	public static String GROUP18_SCENEID = "8a9987ee3b2b4630013b2b4643fd00ac";
	
	//真实成员清单下载场景ID
	public static String GROUP19_SCENEID = "8a9987ee3b2b4630013b2b46462000c7";
	
	//重点关注集团成员号码下载场景ID
	public static String GROUP20_SCENEID = "8a9987ee3b2b4630013b2b46471a00d7";
	
	//重点关注集团信息化业务收入的清单下载场景ID
	public static String GROUP21_SCENEID = "8a9987ee3b2b4630013b2b46477700dc";
	
	//省级重点关注集团年累计离网率和累计收入降幅清单下载场景ID
	public static String GROUP22_SCENEID = "8a9987ee3b2b4630013b2b4647b600e0";
	
	//校讯通业务订购用户清单场景ID
	public static String GROUP23_SCENEID = "8a9987ee3b2b4630013b2b4647d500e1";
	
	//月度财务报表下发"
	public static String FINANCE_SCENEID = "8a9987ee3b2b4630013b2b46be2e040e";
	
	//数据业务打包下载"
	public static String DATEBIZ_SCENEID = "8a9987ee3b2b4630013b2b47402f07f2";
	
	//市场基础报表打包下载"
	public static String MARKETBASE_SCENEID = "8a9987ee3b2b4630013b2b46e6380552";
	
	//算法说明与操作手册"
	public static String COLLEAGE_SCENEID = "8a9987ee3b2b4630013b2b472f280779";
	
	//公告附件"
	public static String NOTICE_SCENEID = "8a9987ee3b2b4630013b2b465dde01c0";
	
	//集团满意度PPT上传下载"
	public static String GROUP_SCENEID = "8a9987ee3b2b4630013b2b46db7a0506";
	
	//省内满意度PPT上传下载"
	public static String PROVINCE_SCENEID = "8a9987ee3b2b4630013b2b46f7fb05d5";
	
	//财务报表省级下载"
	public static String CWBB_SCENEID = "8a9987ee3b2b4630013b2b4643fd00ac";
	
	//积分下载"
	public static String JIFEN_SCENEID = "8a9987ee3b2b4630013b2b46daed0502";
	
	//月度市场情况报表打包下载"
	public static String MONTHMARKET_SCENEID = "8a9987ee3b2b4630013b2b4697d90332";
	
	//全网统一资费编码规范文档下载"
	public static String FEEDOWN_SCENEID = "8a9987ee3b2b4630013b2b46f6e205cb";
	
	//集团客户欠费清单下载"	
	//public static String FINANCE_SCENEID = "8a9987ee3b2b4630013b2b47344807a1";
	
	//定包分地市数据打包下载
	public static String DBFDS_SCENEID = "8a9eaca2430f2f2001430f2f22730008";
	
	
	
}
