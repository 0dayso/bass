<%@ page contentType="text/html; charset=utf-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
DateFormat monthFormater1 = new SimpleDateFormat("yyyyMM");
DateFormat monthFormater2 = new SimpleDateFormat("yyyy-MM");
DateFormat monthFormater3 = new SimpleDateFormat("yyyyMMdd");
Calendar c = Calendar.getInstance();
c.add(Calendar.MONTH,-1);
c.add(Calendar.DATE,-3);
String date = monthFormater1.format(c.getTime());

String fdate = monthFormater2.format(c.getTime()) + "-01";//增加上个月第一天yyyy-MM-dd格式

c.add(Calendar.MONTH,-1);
String ldate = monthFormater1.format(c.getTime()); //增加上上个月

c.setTime(new java.util.Date());
c.add(Calendar.DATE,-2);
String currentdate=monthFormater3.format(c.getTime());
%>
<html>
  <head>
    <title>重点集团客户运营分析类指标</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="../../css/bass21.css" />
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
<script type="text/javascript">

var pieces=[];

pieces[1]={filename:"ent_1500keygroup_zhiguankehu"
	,title:"行业,地市,省级总部集团名称,地市分支机构集团名称,县级分支机构集团名称,集团编码,层级关系,集团类别,客户状态,是否打标集团,本月集团成员到达数,打标成员到达数,通讯录人数,打标成员通信用"+
"户到达数,集团成员离网数,集团成员离网率,打标成员离网数,打标成员离网率,打标成员深度合约数(剔重),打标成员深度合约率,打标成员终端合约用户数,打标成员终端合约率,打标成员话费合约用户数"+
",打标成员话费合约率,打标成员电子券用户数,打标成员电子券合约率,打标成员礼品用户数,打标成员礼品合约率,打标成员担保用户数,打标成员担保合约率,打标成员特殊标签用户数,打标成员特殊标签"+
"合约率,打标成员V网合约数(剔重),打标成员V网合约率,打标成员综合合约数(剔重),打标成员综合合约率,本月集团客户整体收入,本月集团客户统一付费收入,本月集团成员收入,本月集团客户通信和信"+
"息化产品统一付费收入,本月集团客户通信和信息化收入,其中：本月集团成员统一付费通信收入,其中：本月集团客户通信和信息化产品收入,累计集团客户整体收入,累计集团客户统一付费收入,累计集"+
"团成员收入,累计集团客户通信和信息化产品统一付费收入,累计集团客户通信和信息化收入,其中：累计集团成员统一付费通信收入,其中：累计集团客户通信和信息化产品收入,打标成员中使用手机上网"+
"的用户数,手机上网普及率,打标成员整体收入,打标成员ARPU,打标成员的计费时长,打标成员MOU,打标成员手机上网累计上网流量,打标成员DOU(户均流量),全国直管客户拍照成员总数,全国直管客户拍照"+
"保有成员数(直管口径),拍照成员保有率(直管口径),流失成员数(直管口径)",sql:"select profess_name,"+
       "area_name,"+
       "province_groupname,"+
       "city_groupname,"+
       "county_groupname,"+
       "groupcode,"+
       "level,"+
       "cust_grade,"+
       "g_state,"+
       "group_istrue,"+
       "arrive_num,"+
       "arrive_istrue_num,"+
       "address_num,"+
       "arrive_istrue_tx_num,"+
       "lw_num,"+
       "lw_rate,"+
       "lw_istrue_num,"+
       "lw_istrue_rate,"+
       "bind_istrue_num,"+
       "bind_istrue_rate,"+
       "bind_zd_num,"+
       "bind_zd_rate,"+
       "bind_hf_num,"+
       "bind_hf_rate,"+
       "bind_dzj_num,"+
       "bind_dzj_rate,"+
       "bind_lp_num,"+
       "bind_lp_rate,"+
       "bind_db_num,"+
       "bind_db_rate,"+
       "bind_ts_num,"+
       "bind_ts_rate,"+
       "bind_v_num,"+
       "bind_v_rate,"+
       "bind_zh_num,"+
       "bind_zh_rate,"+
       "total_charge,"+
       "tf_charge,"+
       "bill_charge,"+
       "info_tf_charge,"+
       "info_charge,"+
       "member_tf_charge,"+
       "prod_info_charge,"+
       "lj_total_charge,"+
       "lj_tf_charge,"+
       "lj_bill_charge,"+
       "lj_info_tf_charge,"+
       "lj_info_charge,"+
       "lj_member_tf_charge,"+
       "lj_prod_info_charge,"+
       "mobile_num,"+
       "mobile_rate,"+
       "istrue_bill_charge,"+
       "arpu,"+
       "dura1,"+
       "mou,"+
       "gprs_dura,"+
       "dou,"+
       "snap_num,"+
       "snap_stock_num,"+
       "snap_stock_rate,"+
       "snap_ls_num "+
       "from nmk.ent_1500keygroup_#{month} "+
       "with ur "

};
pieces[2]={filename:"ent_1500keygroup"
	,title:"行业,地市,省级总部集团名称,地市分支机构集团名称,县级分支机构集团名称,集团编码,层级关系,集团类别,客户状态,是否打标集团,50元打标成员到达数,基于呼叫圈识别的集团成员,基于呼叫圈识别的集团成员+基于呼叫圈识别的集团异网成员,集团成员市场占有率(基于呼叫圈),打标成员通信用户到达数,50元以上打标成员深度合约数(剔重),50元以上打标成员深度合约率,50元以上打标成员终端合约用户数,50元以上打标成员终端合约率,50元以上打标成员话费合约用户数,50元以上打标成员话费合约率,50元以上打标成员电子券用户数,50元以上打标成员电子券合约率,50元以上打标成员礼品用户数,50元以上打标成员礼品合约率,50元以上打标成员担保用户数,50元以上打标成员担保合约率,50元以上打标成员特殊标签用户数,50元以上打标成员特殊标签合约率,50元以上打标成员V网合约数（剔重）,50元以上打标成员V网合约率,50元以上打标成员综合合约数（剔重）,50元以上打标成员综合合约率,4G用户数,4G终端用户数,4G终端换卡用户数,4G终端MIFI用户到达数,产生4G流量的用户数,4G终端销量,打标成员3G和4G的终端用户到达数,3G/4G终端渗透率,打标成员流量套餐活跃用户数,流量套餐活跃用户渗透率,全国直管客户拍照成员总数,全国直管客户拍照保有成员数(大市场KPI),拍照成员保有率,(大市场KPI),流失成员数(大市场KPI),截止当月底拍照成员中仍在网的用户当月出账收入,截止2013年底在网的打标成员数10-12月月均出账收入,直管集团拍照成员收入保有率"
	,sql:"select profess_name,"+
       "area_name,"+
       "province_groupname,"+
       "city_groupname,"+
       "county_groupname,"+
       "groupcode,"+
       "level,"+
       "cust_grade,"+
       "g_state,"+
       "group_istrue,"+
       "arrive_50_istrue_num,"+
       "cmcc_num,"+
       "cmcc_cucc_ctcc_num,"+
       "cmcc_num_rate,"+
       "arrive_istrue_tx_num,"+
       "bind_50_istrue_num,"+
       "bind_50_istrue_rate,"+
       "bind_50_zd_num,"+
       "bind_50_zd_rate,"+
       "bind_50_hf_num,"+
       "bind_50_hf_rate,"+
       "bind_50_dzj_num,"+
       "bind_50_dzj_rate,"+
       "bind_50_lp_num,"+
       "bind_50_lp_rate,"+
       "bind_50_db_num,"+
       "bind_50_db_rate,"+
       "bind_50_ts_num,"+
       "bind_50_ts_rate,"+
       "bind_50_v_num,"+
       "bind_50_v_rate,"+
       "bind_50_zh_num,"+
       "bind_50_zh_rate,"+
       "lte_num,"+
       "lte_ter_num,"+
       "lte_usim_num,"+
       "lte_mifi_num,"+
       "lte_ter_sell,"+
       "lte_gprs_num,"+
       "lte_3g_4g_num,"+
       "lte_3g_4g_rate,"+
       "gprs_num,"+
       "gprs_rate,"+
       "snap_num_1,"+
       "snap_stock_num_1,"+
       "snap_stock_rate_1,"+
       "snap_ls_num_1,"+
       "cur_bill_charge,"+
       "snap_bill_charge,"+
       "bill_charge_rate "+
       "from nmk.ent_1500keygroup_#{month} "+
       "with ur"

};

pieces[3]={filename:"GroupAccnbr"
,title:"行业,地市,总部客户名称,省级总部集团名称,地市分支机构集团名称,县级分支机构集团名称,层级关系,集团编码,集团类别,是否是打标集团成员,姓名,职务,号码,用户状态,当月消费(ARPU),近六月消费（元）,当月计费时长,当月累计手机上网流量,4G用户的4G计费流量,4G用户的3G计费流量,4G用户的2G计费流量,是否是4G用户,是否是USIM卡用户,是否有4G流量,是否为4G终端,终端类型,深度合约类型,订购的4G资费"
,sql:"select " +
"profess_name, " +
"area_name, " +
"head_groupname, " +
"province_groupname, " +
"city_groupname, " +
"county_groupname, " +
"level, " +
"groupcode, " +
"cust_grade, " +
"member_istrue, " +
"cust_name, " +
"rolename, " +
"acc_nbr, " +
"act_tid_name, " +
"value(curr_bill_charge,0)/1000, " +
"six_bill_charge/1000, " +
"dura1, " +
"totalbyte_m/1024/1024, " +
"totalbyte_lte_m/1024/1024, " +
"totalbyte_td_m/1024/1024, " +
"totalbyte_gsm_m/1024/1024, " +
"USER_FLAG, " +
"IS_USIM, " +
"IS_BYTE, " +
"IS_4G_TER, " +
"TRNL_TYPE_NAME, " +
"BIND_TYPE, " +
"FEE_NAME " +
"from nmk.ent_120keymember_#{month} " +
"with ur" 
};


pieces[4]={filename:"keyGroupCharge"
,title:"行业,地市,总部客户名称,省级总部集团名称,地市分支机构集团名称,县级分支机构集团名称,集团编码,层级关系,集团类别,累计集团客户通信和信息化产品统一付费收入,累计集团客户通信和信息化收入,其中：累计集团成员统一付费通信收入,其中：累计集团客户通信和信息化产品收入,累计无线商话,累计移动400,累计集团彩铃,累计移动总机（商务一号通）,累计移动管家,累计集群通,累计企信通,累计集团彩漫,累计行业手机报,累计数据专线,累计互联网专线,累计集团宽带,累计PBX,累计集团WLAN,累计企业随E行,累计IDC(主机托管),累计商户管家,累计BB（BLACKBERRY）,累计手机邮箱,累计一卡通,累计移动办公（移动OA）,累计效能快信,累计集团签名,累计集团通讯管家,累计企业建站,累计视频会议（云视讯）,累计集团IMS,累计行业应用卡,累计物联卡,累计机器卡,累计车务通,累计物流通,累计车联网,累计校讯通,累计城管通,累计警务通,累计商信通,累计ICT集成服务,累计兴业云,资讯通,企业彩讯,手机报统付版,其中：银信通,企业邮箱,企业阅读,爱车宝,融和网关,流量统付,集团彩漫,云监控,农机通(移动OA子品),4G专线,聪明号簿"
,sql:"select profess_name," +
"area_name," +
"head_groupname," +
"province_groupname," +
"city_groupname," +
"county_groupname," +
"groupcode," +
"level," +
"custgrade," +
"info_tf_charge/1000," +
"info_charge/1000," +
"member_tf_charge/1000," +
"prod_info_charge/1000," +
"wxsh/1000," +
"yd400/1000," +
"gcring/1000," +
"ydzj/1000," +
"ydgj/1000," +
"jqt/1000," +
"qxt/1000," +
"qycm/1000," +
"hysjb/1000," +
"vpn/1000," +
"hlzx/1000," +
"adsl/1000," +
"pbx/1000," +
"wlan/1000," +
"pp_se/1000," +
"idc_zjtg/1000," +
"shgj/1000," +
"blackberry/1000," +
"pushmail/1000," +
"ykt/1000," +
"ydoa/1000," +
"info_sms/1000," +
"gjmp/1000," +
"txgj/1000," +
"wxwz/1000," +
"sxhy/1000," +
"ims/1000," +
"m2m_card/1000," +
"wlk/1000," +
"smart_card/1000," +
"bdcar/1000," +
"wlt/1000," +
"clt/1000," +
"xxt/1000," +
"cgt/1000," +
"jwt/1000," +
"sxt/1000," +
"ict/1000," +
"xyy/1000," +
"zxt   /1000," +
"qycx  /1000," +
"sjb_tf/1000," +
"yxt   /1000," +
"qyyx  /1000," +
"qyyd  /1000," +
"acb   /1000," +
"rhwg  /1000," +
"lltf  /1000," +
"jtcm  /1000," +
"yjk   /1000," +
"njt   /1000," +
"ltezx /1000, " +
"Cmhb/1000 " + 
"from nmk.ent_infocharge_detail_#{month} " +
"with ur"
};

/* pieces[5]={filename:"120_keyGroupWarning"
,title:"总部名称,集团名称,集团编码,行业,客户经理,部室,是否是打标集团成员,姓名,职务,号码,用户状态,当月收入,近6月收入,ARPU,MOU,捆绑类型,异动情况,订购产品,订购套餐"
,sql:"select head_groupname,                                                  "+
"       case when province_groupname is not null then province_groupname "+
"            when city_groupname is not null then city_groupname         "+
"            when county_groupname is not null then county_groupname     "+
"        end,                                                            "+
"       groupcode,                                                       "+
"       profess_name,                                                    "+
"       staff_name,                                                      "+
"       department,                                                      "+
"       case when member_istrue = 1 then '是' else '否' end,             "+
"       name,                                                            "+
"       duty,                                                            "+
"       acc_nbr,                                                         "+
"       act_tid,                                                         "+
"       bill_charge/1000,                                                "+
"       six_bill_charge/1000,                                            "+
"       arpu_charge/1000,                                                "+
"       mou_times/60,                                                    "+
"       value(bind_type,'非捆绑'),                                       "+
"       case when iswarning = 1 then '是' else '否' end,                 "+
"       fee_name,                                                        "+
"       prod_name                                                        "+
"  from nmk.ent_120keymember_#{month}                                    "+
" where staff_name is not null                                           "+
"  with ur"
}; */

/* pieces[5]={
	filename:"VIPGroupDetail"
	,title:"集团编码,地市,集团名称,集团类别,客户状态,是否打标集团,存量用户数,打标成员到达数,通讯录人数,本年度累计新增用户数,打标成员累计离网数,打标成员捆绑数,打标成员话费捆绑数,打标成员终端捆绑数,打标成员礼品捆绑数,月度中高端客户数,拍照中高端用户数,集团客户本月整体收入,累计集团客户整体收入,集团客户本月信息化收入,累计信息化收入,集团客户本月数据业务收入,累计集团客户数据业务收入,打标成员累计收入,集团统付累计收入"
	,sql:"select a.groupcode,                                           "+
"       a.area_name,                                           "+
"       case when a.level = '1' then a.province_groupname      "+
"	          when a.level = '2' then a.city_groupname           "+
"			      when a.level = '3' then a.county_groupname         "+
"	     else ' '                                                "+
"	      end groupname,                                         "+
"       a.cust_grade,                                          "+
"       a.g_state,                                             "+
"       case when a.group_istrue = 1 then '是' else '否' end,  "+
"       a.stock_num,                                           "+
"       a.arrive_istrue_num,                                   "+
"       a.address_num,                                         "+
"       a.year_new_num,                                        "+
"       a.lw_istrue_num,                                       "+
"       a.istrue_bind_num,                                     "+
"       a.istrue_bind1_num,                                    "+
"       a.istrue_bind2_num,                                    "+
"       a.istrue_bind3_num,                                    "+
"       a.midd_high_num,                                       "+
"       a.snapshot_num,                                        "+
"       a.total_charge,                                        "+
"       a.lj_total_charge,                                     "+
"       a.info_charge,                                         "+
"       a.lj_info_charge,                                      "+
"       a.data_charge,                                         "+
"       a.lj_data_charge,                                      "+
"       a.lj_istrue_charge,                                    "+
"       a.lj_tf_charge                                         "+
"  from nmk.ent_1500keygroup_#{month} a,                       "+
"       nmk.ent_1500groupcode_cfg b                            "+
" where a.groupcode = b.groupcode                              "+
"  with ur                                                  "
};

pieces[6]={
	filename:"VIP_KeyManDetail"
	,title:"集团编码,地市,集团名称,集团类别,是否打标集团,是否是打标集团成员,姓名,职务,号码,用户状态,当月消费(元),近六月消费（元）,捆绑类型,是否是存量用户数,是否是月度中高端客户数,是否是拍照中高端用户,APRU,MOU,异动情况"
	,sql:"select a.groupcode,                                          "+
"       a.area_name,                                          "+
"       case when a.level = 1 then a.province_groupname       "+
"	          when a.level = 2 then a.city_groupname            "+
"			      when a.level = 3 then a.county_groupname          "+
"	     else ''                                                "+
"	      end groupname,                                        "+
"       a.cust_grade,                                         "+
"       case when c.group_istrue = 1 then '是' else '否' end, "+
"       case when a.member_istrue = 1 then '是' else '否' end,"+
"       a.name,                                               "+
"       a.duty,                                               "+
"       a.acc_nbr,                                            "+
"       a.act_tid,                                            "+
"       a.bill_charge,                                        "+
"       a.six_bill_charge,                                    "+
"       a.bind_type,                                          "+
"       case when a.is_stock = 1 then '是' else '否' end,     "+
"       case when a.is_midd_high = 1 then '是' else '否' end, "+
"       case when a.is_snap = 1 then '是' else '否' end,      "+
"       a.arpu_charge,                                        "+
"       a.mou_times,                                          "+
"       case when a.iswarning = 1 then '是' else '否' end     "+
"  from nmk.ent_120keymember_#{month} a                           "+
"       inner join nmk.ent_1500groupcode_cfg b                "+
"               on a.groupcode = b.groupcode                  "+
"       left join nwh.ent_info_#{month} c                     "+
"              on a.groupcode = c.groupcode                   "+
"  with ur                                                    "
};

pieces[7]={
	filename:"MemberTotalCount"
	,title:"集团编号,用户编号"
	,sql:"select a.groupcode, a.serv_id       "+
"  from nwh.ent_submember_#{month} a,"+
"       nmk.ent_1500groupcode_cfg b  "+
" where a.groupcode = b.groupcode    "+
"   and a.g_state in (0,1,2)         "+
"   and a.act_tid in (0,1)           "+
"   and a.member_istrue = 1          "+
" order by 1, 2                      "+
"  with ur                           "
};

pieces[8]={
	filename:"CommunicationList"
	,title:"集团编号,手机号"
	,sql:"select b.groupcode,mobile                                                                    "+
"  from (select area_id region,custid,mobile,                                                 "+
"               row_number() over(PARTITION BY mobile ORDER BY statusdate desc NULLs last) rn "+
"          from nwh.cm_cu_addressitem_#{month}                                                "+
"         where status = 1                                                                    "+
"           and int(date(statusdate)) / 100 <= #{month}) a,                                   "+
"       (select a.groupcode, gcust_id, staff_org_id, g_state                                  "+
"          from nmk.ent_sum_#{month} a,                                                       "+
"               nmk.ent_1500keygroup_cfg b                                                    "+
"         where a.groupcode=b.groupcode )  b                                                  "+
" where a.rn = 1                                                                              "+
"   and a.custid=b.gcust_id                                                                   "+
"   and b.staff_org_id like 'HB.%'                                                            "+
"   and b.g_state in (0,1)                                                                    "+
"  with ur                                                                                    "
}; */

pieces[5]={
		filename:"Communication_List"
		,title:"地市,用户号码,集团编号,成员状态,是否关键人,是否中高端,是否硬捆绑,当月出账收入"
		,sql:"select area_name," + 
	       "acc_nbr," + 
	       "groupcode," + 
	       "is_act_tid," + 
	       "is_state," + 
	       "is_key," + 
	       "is_str_bind," + 
	       "bill_charge/1000 " +
	  "from nmk.ent_member_lost_#{month} " +
	  "with ur"
	};
	
pieces[6]={
		filename:"ent_1500keygroup"
		,title:"地市,集团数量,通讯录人数,打标成员到达数,打标成员通信用户到达数,基于呼叫圈识别的集团成员,集团成员市场占有率（基于呼叫圈）,本月集团客户整体收入(万元),本月集团客户统一付费收入(万元),本月集团成员收入(万元),累计集团客户整体收入(万元),累计集团客户统一付费收入(万元),累计集团成员收入(万元),本月集团客户通信和信息化收入(万元),本月集团客户通信和信息化产品收入(万元),本月集团成员统一付费收入(万元),累计集团客户通信和信息化收入(万元),其中：累计集团成员统一付费通信收入(万元),其中：累计集团客户通信和信息化产品收入(万元)"
		,sql:"select * from ("+
	  "select area_name,"+
		"count(distinct groupcode),"+
		"sum(address_num) ,"+
		"sum(arrive_istrue_num),"+
		"sum(arrive_istrue_tx_num),"+
		"sum(cmcc_num),"+
		"SUM(case when CMCC_CUCC_CTCC_NUM=0 then 0 else decimal(cmcc_num,16,4) end)/SUM(CMCC_CUCC_CTCC_NUM),"+
		"decimal(sum(total_charge/10000),16,4),"+
		"decimal(sum(tf_charge/10000),16,4),"+
		"decimal(sum(bill_charge/10000),16,4),"+
		"decimal(sum(lj_total_charge/10000),16,4),"+
		"decimal(sum(lj_tf_charge/10000),16,4),"+
		"decimal(sum(lj_bill_charge/10000),16,4),"+
		"decimal(sum(info_charge/10000),16,4),"+
		"decimal(sum(prod_info_charge/10000),16,4),"+
		"decimal(sum(member_tf_charge/10000),16,4),"+
		"decimal(sum(lj_info_charge/10000),16,4),"+
		"decimal(sum(lj_member_tf_charge/10000),16,4),"+
		"decimal(sum(lj_prod_info_charge/10000),16,4) "+
		"from nmk.ent_1500keygroup_#{month} "+
		"group by area_name "+
		"with rollup "+
		")order by area_name "+
		"with ur"  
	};
 
pieces[7]={
		filename:"ent_1500keygroup_1"
		,title:"地市,集团数量,打标成员到达数,通讯录人数,打标成员通信用户到达数,打标成员中使用手机上网的用户数,手机上网普及率,4G用户数,4G用户渗透率,4G终端用户数,4G终端换卡用户数,4G终端销量,打标成员流量套餐活跃用户数,流量套餐活跃用户渗透率,全国直管客户拍照成员总数,打标成员3G和4G的终端用户到达数,3G/4G终端渗透率,全国直管客户拍照保有成员数（直管口径）,拍照成员保有率 （直管口径）,直管集团拍照成员收入保有率"
		,sql:"select area_name,groupcode,arrive_istrue_num,address_num,arrive_istrue_tx_num,mobile_num,arrive_istrue_tx_num1,lte_num,arrive_istrue_tx_num2,lte_ter_num,lte_usim_num,lte_gprs_num,gprs_num,arrive_istrue_tx_num3,snap_num,lte_3g_4g_num,arrive_istrue_tx_num4,snap_stock_num,snap_stock_rate,bill_charge_rate from ("+
		"select area_name,"+
		"count(groupcode) groupcode,"+
		"sum(arrive_istrue_num) arrive_istrue_num,"+
		"sum(address_num) address_num,"+
		"sum(arrive_istrue_tx_num) arrive_istrue_tx_num,"+
		"sum(mobile_num) mobile_num,"+
		"sum(case when arrive_istrue_tx_num = 0 then 0 else decimal(mobile_num,16,4) end )/sum(arrive_istrue_tx_num) arrive_istrue_tx_num1,"+
		"sum(lte_num) lte_num,"+
		"sum(case when arrive_istrue_tx_num = 0 then 0 else decimal(lte_num,16,4) end)/sum(arrive_istrue_tx_num) arrive_istrue_tx_num2,"+
		"sum(lte_ter_num) lte_ter_num,"+
		"sum(lte_usim_num) lte_usim_num,"+
		"sum(lte_gprs_num) lte_gprs_num,"+
		"sum(gprs_num) gprs_num,"+
		"sum(case when arrive_istrue_tx_num = 0 then 0 else decimal(gprs_num,16,4) end )/sum(gprs_num) arrive_istrue_tx_num3,"+
		"sum(snap_num) snap_num,"+
		"sum(lte_3g_4g_num) lte_3g_4g_num,"+
		"sum(case when arrive_istrue_tx_num = 0 then 0 else decimal(lte_3g_4g_num,16,4) end)/sum(arrive_istrue_tx_num) arrive_istrue_tx_num4,"+
		"sum(snap_stock_num) snap_stock_num,"+
		"avg(snap_stock_rate) snap_stock_rate,"+
		"avg(bill_charge_rate) bill_charge_rate "+
		"from nmk.ent_1500keygroup_#{month} "+
		"group by area_name "+
		"with rollup "+
		")order by area_name "+
		"with ur"
	};
 
pieces[8]={
		filename:"ent_infocharge_detail"
		,title:"地市,累计集团客户通信和信息化收入（万元）,其中：累计集团成员统一付费通信收入（万元）,其中：累计集团客户通信和信息化产品收入（万元）,累计集团客户通信和信息化产品统一付费收入（万元）,累计无线商话（万元）,累计移动400（万元）,累计集团彩铃（万元）,累计移动总机(商务一号通)（万元）,累计移动管家（万元）,累计集群通（万元）,累计企信通（万元）,累计集团彩漫（万元）,累计行业手机报（万元）,累计数据专线（万元）,累计互联网专线（万元）,累计集团宽带（万元）,累计PBX（万元）,累计集团WLAN（万元）,累计企业随E行（万元）,累计IDC(主机托管)（万元）,累计商户管家（万元）,累计BB（BLACKBERRY）（万元）,累计手机邮箱（万元）,累计一卡通（万元）,累计移动办公(移动OA)（万元）,累计效能快信（万元）,累计集团签名（万元）,累计集团通讯管家（万元）,累计企业建站（万元）,累计视频会议(云视讯)（万元）,累计集团IMS（万元）,累计行业应用卡（万元）,累计物联卡（万元）,累计机器卡（万元）,累计车务通（万元）,累计物流通（万元）,累计车联网（万元）,累计校讯通（万元）,累计城管通（万元）,累计警务通（万元）,累计商信通（万元）,累计ICT集成服务（万元）,累计兴业云（万元）,累计聪明号薄（万元）"
		,sql:"select area_name,info_charge,member_tf_charge,prod_info_charge,info_tf_charge,wxsh,yd400,gcring,ydzj,ydgj,jqt,qxt,qycm,hysjb,vpn,hlzx,adsl,pbx,"+
		"wlan,pp_se,idc_zjtg,shgj,blackberry,pushmail,ykt,ydoa,info_sms,gjmp,txgj,wxwz,sxhy,ims,m2m_card,wlk,smart_card,bdcar,wlt,clt,xxt,cgt,jwt,sxt,ict,xyy,cmhb from ("+
		"select area_name,"+
		"decimal(sum(info_charge/1000/10000),16,4) info_charge,"+
		"decimal(sum(member_tf_charge/1000/10000),16,4) member_tf_charge,"+
		"decimal(sum(prod_info_charge/1000/10000),16,4) prod_info_charge,"+
		"decimal(sum(info_tf_charge/1000/10000),16,4)  info_tf_charge,"+
		"decimal(sum(wxsh/1000/10000),16,4) wxsh,"+
		"decimal(sum(yd400/1000/10000),16,4) yd400,"+
		"decimal(sum(gcring/1000/10000),16,4) gcring,"+
		"decimal(sum(ydzj/1000/10000),16,4) ydzj,"+
		"decimal(sum(ydgj/1000/10000),16,4) ydgj,"+
		"decimal(sum(jqt/1000/10000),16,4) jqt,"+
		"decimal(sum(qxt/1000/10000),16,4) qxt,"+
		"decimal(sum(qycm/1000/10000),16,4) qycm,"+
		"decimal(sum(hysjb/1000/10000),16,4) hysjb,"+
		"decimal(sum(vpn/1000/10000),16,4) vpn,"+
		"decimal(sum(hlzx/1000/10000),16,4) hlzx,"+
		"decimal(sum(adsl/1000/10000),16,4) adsl,"+
		"decimal(sum(pbx/1000/10000),16,4) pbx,"+
		"decimal(sum(wlan/1000/10000),16,4) wlan,"+
		"decimal(sum(pp_se/1000/10000),16,4) pp_se,"+
		"decimal(sum(idc_zjtg/1000/10000),16,4) idc_zjtg,"+
		"decimal(sum(shgj/1000/10000),16,4) shgj,"+
		"decimal(sum(blackberry/1000/10000),16,4) blackberry,"+
		"decimal(sum(pushmail/1000/10000),16,4) pushmail,"+
		"decimal(sum(ykt/1000/10000),16,4) ykt,"+
		"decimal(sum(ydoa/1000/10000),16,4) ydoa,"+
		"decimal(sum(info_sms/1000/10000),16,4) info_sms,"+
		"decimal(sum(gjmp/1000/10000),16,4) gjmp,"+
		"decimal(sum(txgj/1000/10000),16,4) txgj,"+
		"decimal(sum(wxwz/1000/10000),16,4) wxwz,"+
		"decimal(sum(sxhy/1000/10000),16,4) sxhy,"+
		"decimal(sum(ims/1000/10000),16,4) ims,"+
		"decimal(sum(m2m_card/1000/10000),16,4) m2m_card,"+
		"decimal(sum(wlk/1000/10000),16,4) wlk,"+
		"decimal(sum(smart_card/1000/10000),16,4) smart_card,"+
		"decimal(sum(bdcar/1000/10000),16,4) bdcar,"+
		"decimal(sum(wlt/1000/10000),16,4) wlt,"+
		"decimal(sum(clt/1000/10000),16,4) clt,"+
		"decimal(sum(xxt/1000/10000),16,4) xxt,"+
		"decimal(sum(cgt/1000/10000),16,4) cgt,"+
		"decimal(sum(jwt/1000/10000),16,4) jwt,"+
		"decimal(sum(sxt/1000/10000),16,4) sxt,"+
		"decimal(sum(ict/1000/10000),16,4) ict,"+
		"decimal(sum(xyy/1000/10000),16,4) xyy,"+
		"decimal(sum(cmhb/1000/10000),16,4) cmhb "+
		"from nmk.ent_infocharge_detail_#{month} "+
		"group by area_name "+
		"with rollup "+
		")order by area_name "+
		"with ur "
	};

pieces[9]={
		filename:"ent_1500keygroup_2"
		,title:"地市,家数,打标成员到达数,通讯录人数,50元打标成员到达数,打标成员深度合约数(剔重),打标成员深度合约率,打标成员综合合约数（剔重）,打标成员综合合约率,50元以上打标成员深度合约数(剔重）,50元以上打标成员深度合约率,50元以上打标成员V网合约数（剔重）,50元以上打标成员V网合约率,50元以上打标成员综合合约数（剔重）,50元以上打标成员综合合约率"
		,sql:"select area_name,count,arrive_istrue_num,address_num,arrive_50_istrue_num,BIND_ISTRUE_NUM,bind_istrue_rate,bind_zh_num,bind_zh_rate,bind_50_istrue_num,bind_50_istrue_rate,bind_50_v_num,bind_50_v_rate,bind_50_zh_num,bind_50_zh_rate from ("+
		"select area_name,"+
		"count(1) count,"+
		"sum(arrive_istrue_num) arrive_istrue_num,"+
		"sum(address_num) address_num,"+
		"sum(arrive_50_istrue_num) arrive_50_istrue_num,"+
		"sum(bind_istrue_num) BIND_ISTRUE_NUM,"+
		"sum(case when arrive_istrue_num = 0 then 0 else decimal(bind_istrue_num,16,2) end )/sum(arrive_istrue_num) bind_istrue_rate,"+
		"sum(bind_zh_num) bind_zh_num,"+
		"sum(case when arrive_istrue_num = 0 then 0 else decimal(bind_zh_num,16,2) end )/sum(arrive_istrue_num) bind_zh_rate,"+
		"sum(bind_50_istrue_num) bind_50_istrue_num,"+
		"sum(case when arrive_istrue_num = 0 then 0 else decimal(bind_50_istrue_num,16,2) end )/sum(arrive_istrue_num) bind_50_istrue_rate,"+
		"sum(bind_50_v_num) bind_50_v_num,"+
		"sum(case when arrive_istrue_num = 0 then 0 else decimal(bind_50_v_num,16,2) end )/sum(arrive_istrue_num) bind_50_v_rate,"+
		"sum(bind_50_zh_num) bind_50_zh_num,"+
		"sum(case when arrive_istrue_num = 0 then 0 else decimal(bind_50_zh_num,16,2) end )/sum(arrive_istrue_num) bind_50_zh_rate "+
		"from nmk.ent_1500keygroup_#{month} "+
		"group by area_name "+
		"with rollup "+
		") order by area_name "+
		"with ur"
	};
	
pieces[10]={
		filename:"ent_infocharge_detail"
		,title:"行标签,累计无线商话（万元）,累计移动400（万元）,累计集团彩铃（万元）,累计移动总机(商务一号通)（万元）,累计集群通（万元）,累计集团彩漫（万元）,累计企信通（万元）,累计集团宽带（万元）,累计数据专线（万元）,累计互联网专线（万元）,累计PBX（万元）,累计企业随E行（万元）,累计集团WLAN（万元）,累计企业建站（万元）,累计IDC(主机托管)（万元）,累计商户管家（万元）,累计BB（BLACKBERRY）（万元）,累计手机邮箱（万元）,累计一卡通（万元）,累计移动办公(移动OA)（万元）,累计效能快信（万元）,累计集团通讯管家（万元）,累计视频会议(云视讯)（万元）,累计物联卡（万元）,累计机器卡（万元）,累计物流通（万元）,累计车务通（万元）,累计集团IMS（万元）,累计行业应用卡（万元）,累计移动管家（万元）,累计行业手机报（万元）,累计聪明号薄（万元）,累计兴业云（万元）,累计商信通（万元）,累计校讯通（万元）,累计警务通（万元）,累计城管通（万元）,累计车联网（万元）,累计集团签名（万元）,其他类收入（万元）,集团客户通信和信息化收入（万元）,其中：累计集团成员统一付费通信收入（万元）,其中累计集团客户通信和信息化产品收入（万元）"
		,sql:"select cust_name,wxsh,yd400,gcring,JQT,ydzj,qycm,qxt,adsl,vpn,hlzx,pbx,PP_SE,wlan,wxwz,idc_zjtg,shgj,blackberry,pushmail,ykt,ydoa,info_sms,txgj,sxhy,wlk,smart_card,wlt," +
		"bdcar,ims,m2m_card,ydgj,hysjb,cmhb,xyy,sxt,xxt,jwt,cgt,clt,gjmp,ict,info_charge,member_tf_charge,prod_info_charge from ("+
		"select b.cust_name,"+
		"decimal(sum(wxsh/1000/10000),16,4) wxsh,"+
		"decimal(sum(yd400/1000/10000),16,4) yd400,"+
		"decimal(sum(gcring/1000/10000),16,4) gcring,"+
		"decimal(sum(ydzj/1000/10000),16,4) ydzj,"+
		"decimal(sum(jqt/1000/10000),16,4) jqt,"+
		"decimal(sum(qycm/1000/10000),16,4) qycm,"+
		"decimal(sum(qxt/1000/10000),16,4) qxt,"+
		"decimal(sum(adsl/1000/10000),16,4) adsl,"+
		"decimal(sum(vpn/1000/10000),16,4) vpn,"+
		"decimal(sum(hlzx/1000/10000),16,4) hlzx,"+
		"decimal(sum(pbx/1000/10000),16,4) pbx,"+
		"decimal(sum(pp_se/1000/10000),16,4) pp_se,"+
		"decimal(sum(wlan/1000/10000),16,4) wlan,"+
		"decimal(sum(wxwz/1000/10000),16,4) wxwz,"+
		"decimal(sum(idc_zjtg/1000/10000),16,4) idc_zjtg,"+
		"decimal(sum(shgj/1000/10000),16,4) shgj,"+
		"decimal(sum(blackberry/1000/10000),16,4) blackberry,"+
		"decimal(sum(pushmail/1000/10000),16,4) pushmail,"+
		"decimal(sum(ykt/1000/10000),16,4) ykt,"+
		"decimal(sum(ydoa/1000/10000),16,4) ydoa,"+
		"decimal(sum(info_sms/1000/10000),16,4) info_sms,"+
		"decimal(sum(txgj/1000/10000),16,4) txgj,"+
		"decimal(sum(sxhy/1000/10000),16,4) sxhy,"+
		"decimal(sum(wlk/1000/10000),16,4) wlk,"+
		"decimal(sum(smart_card/1000/10000),16,4) smart_card,"+
		"decimal(sum(wlt/1000/10000),16,4) wlt,"+
		"decimal(sum(bdcar/1000/10000),16,4) bdcar,"+
		"decimal(sum(ims/1000/10000),16,4) ims,"+
		"decimal(sum(m2m_card/1000/10000),16,4) m2m_card,"+
		"decimal(sum(ydgj/1000/10000),16,4) ydgj,"+
		"decimal(sum(hysjb/1000/10000),16,4) hysjb,"+
		"decimal(sum(cmhb/1000/10000),16,4) cmhb,"+
		"decimal(sum(xyy/1000/10000),16,4) xyy,"+
		"decimal(sum(sxt/1000/10000),16,4) sxt,"+
		"decimal(sum(xxt/1000/10000),16,4) xxt,"+
		"decimal(sum(jwt/1000/10000),16,4) jwt,"+
		"decimal(sum(cgt/1000/10000),16,4) cgt,"+
		"decimal(sum(clt/1000/10000),16,4) clt,"+
		"decimal(sum(gjmp/1000/10000),16,4) gjmp,"+
		"decimal(sum(ict/1000/10000),16,4) ict,"+
		"decimal(sum(info_charge/1000/10000),16,4) info_charge,"+
		"decimal(sum(member_tf_charge/1000/10000),16,4) member_tf_charge,"+
		"decimal(sum(prod_info_charge/1000/10000),16,4) prod_info_charge "+
		"from nmk.ent_infocharge_detail_#{month} a "+
		"left join nmk.enter_1500keygroup_bank_cfg b "+
		"              on b.groupcode = a.groupcode "+
		"			  where cust_name is not null "+
		"group by b.cust_name with rollup )order by cust_name "+
		"with ur"
	};


/* pieces[10]={
		filename:"Communication_List_zk"
		,title:"集团编码 ,集团名称 ,地市 ,全国直管客户拍照成员总数 ,全国直管客户拍照保有成员数 ,保有率 ,累计流失成员数"
		,sql:"select b.area_name, a.groupcode,a.groupname,snap_count,stock_count,snap_rate,lost_count from nmk.ent_keygroup_total_#{month} a,mk.bt_area b where a.area_code = b.area_code order by b.area_name, a.groupcode with ur"
	}; */
	
var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont});
	
var appSessionId;
var clientIp;
var maxTime;
var cooperate;
var sceneId;
var accounts;
var nid;
var cooperateStatus;
var account;

function download(sSeq)
{
	var piece=pieces[sSeq];
	if(piece.sql.indexOf("currentdate")>-1){
		var cd='<%=currentdate%>';
		document.forms[0].filename.value=piece.filename+cd;
	}else{
		document.forms[0].filename.value=piece.filename;
	}
	document.forms[0].title.value=piece.title;
	document.forms[0].sql.value=piece.sql.replace(/#{month}/gi,document.forms[0].date.value).replace(/#{lmonth}/gi,document.forms[0].ldate.value).replace(/#{fdate}/gi,document.forms[0].fdate.value).replace(/#{currentdate}/gi,document.forms[0].currentdate.value).replace(/#{lastmonth}/gi,document.forms[0].ldate.value);
	
	if(document.forms[0].sql.value.toLowerCase().indexOf("with ur")==0){
		document.forms[0].sql.value+= " with ur ";
	}
	// document.getElementById("sqlview").innerHTML=document.forms[0].sql.value;
	var ajax=new aihb.Ajax({
		url: "${mvcPath}/jinku/kpiCheck"
		,loadmask : true
		,parameters : "date="+sSeq
		,callback : function(xmlrequest){
			var resultMap = xmlrequest.responseText;
			resultMap = eval("("+resultMap+")");
			var flag = resultMap.flag;
			var msg = resultMap.msg;
			if(!flag){
				alert(msg);
				appSessionId = resultMap.appSessionId;
				clientIp = resultMap.ip;
				maxTime = resultMap.maxTime;
				cooperate = resultMap.cooperate;
				sceneId = resultMap.sceneId;
				accounts = resultMap.accounts;
				nid = resultMap.nid;
				cooperateStatus = resultMap.cooperateStatus;
				var passFlag= false;
				var accountFlag = "N";
				if (cooperate == null || cooperate == "") {
					accountFlag = "Y";
				}
				if(cooperateStatus=="0"){
					alert("无协作人，请联系4A管理员");
					return;
				}else{
					if(accountFlag=="N"){						
						openAccountDialog();
					}
				}	
			}else{
				toDown();
			}
		}
	});
	ajax.request();
}
	
function openAccountDialog(){
	accounts = eval(accounts);
	var content = "<fieldset style=\"width: 350px; height: 180px; margin: 0 10px 10px 10px;\">"+
				"<legend>"+
					"您在4A系统中有如下主账号"+
				"</legend>"+
				"<table align=\"center\" width=\"90%\" height=\"90%\">"+
					"<tr>"+
						"<td align=\"center\">"+
							"<label>"+
								"<select id=\"accountSel\" style=\"width: 230px\">"+
								"</select>"+
							"</label>"+
						"</td>"+
					"</tr>"+
				"</table>"+
			"</fieldset>"+
			"<br>"+
			"<div align=\"center\" style='margin-bottom:8px;'><input type=\"button\" value=\"确定\" onclick=\"doSendAccount()\">"+
			"&nbsp;&nbsp;&nbsp;&nbsp;"+
			"<input type=\"button\" value=\"取消\" onclick=\"doClose()\"></div>";
	_cont.innerHTML = content;
	var account = document.getElementById("accountSel");
	if(accounts.length > 0){
		for(var k=0;k<accounts.length;k++){
			account[k]=new Option(accounts[k],accounts[k]);
			if(k==0){
				account[k].selected=true;
			}
		}
	}else{
		account[0]=new Option(accounts,accounts);
	}
	_mask.show();
}

function doClose(){
	alert("金库认证未通过，请重新认证！");
	document.getElementById('closeImg').parentNode.parentNode.parentNode.style.display='none';
	return;
}

function doSendAccount(){
	account = document.getElementById('accountSel').value;
	if(account == ''){
		alert('主账号信息不能为空。');
		return;
	}
	openShowDialog();
}

function openShowDialog(){
	var content = "<table align='center' width='400px;' style='margin: 10px 0;'>  "+
		"<tr height='40'>"+
			"<td colspan='2' align='center'><label> <b>金库模式访问</b>"+
			"</label></td>"+
		"</tr>"+
		"<tr>"+
			"<td align='right' width='40%'><label> *授权模式： </label></td>"+
			"<td width='60%'><input type='radio' id='model1' name='model' "+
				"checked='checked' onclick='changeModel()'> 远程授权 <input "+
				"type='radio' id='model2' name='model' onclick='changeModel()'>"+
				"现场授权 <input type='radio' id='model3' name='model'"+
				"onclick='changeModel()'> 工单授权</td>"+
		"</tr>"+
		"<tr height='30'>"+
			"<td align='right'><label> *申请人： </label></td>"+
			"<td><input id='account' type='text' style='width: 180px' "+
				"value='' readonly='readonly'></td>"+
		"</tr>"+
		"<tr height='30' id='timeShow'>"+
			"<td align='right'><label> *授权有效时限： </label></td>"+
			"<td><input id='maxTime' type='text' style='width: 180px'"+
				"value='' readonly='readonly'></td>"+
		"</tr>"+
		"<tr height='30' id='workorderShow' style='display: none' >"+
			"<td align='right'><label> *工单编号： </label></td>"+
			"<td><input id='workorderNO' type='text' style='width: 180px' "+
				"value=''></td>"+
		"</tr>"+

		"<tr height='30' id='contentShow' style='display: none'>"+
			"<td align='right'><label> *操作内容： </label></td>"+
			"<td><textarea rows='3' id='operContent' style='width: 180px'></textarea>"+
			"</td>"+
		"</tr>"+

		"<tr height='30' id='approverShow'>"+
			"<td align='right'><label> *协作人员： </label></td>"+
			"<td><select id='approver' style='width: 180px'>"+
			"</select></td>"+
		"</tr>"+
		"<tr height='30' id='pwShow' style='display: none'>"+
			"<td align='right'><label> *协作人员静态密码： </label></td>"+
			"<td><input id='pwCode' type='password' style='width: 180px'>"+
			"</td>"+
		"</tr>"+
		"<tr>"+
			"<td align='right'><label> *申请原因： </label></td>"+
			"<td><textarea rows='3' id='caseDesc' style='width: 180px'></textarea>"+
				"<input id='count' type='hidden' style='width: 180px' value='0'>"+
			"</td>"+
		"</tr>"+
		"<tr height='30'>"+
			"<td align='center' colspan='2'><input type='button' value='提交申请'"+
				"onclick='doShowSend()'> &nbsp;&nbsp;&nbsp;&nbsp; <input "+
				"type='button' value='取消' onclick='doClose()'></td>"+
		"</tr>"+
	"</table>";
_cont.innerHTML = content;
initParamValue();
_mask.show();
}

function initParamValue(){
	document.getElementById('account').value = account;
	document.getElementById('maxTime').value = maxTime;
	var approvers = document.getElementById('approver');
	if(cooperate.indexOf(",")>-1){
		var cooperates = cooperate.split(",");
		for(var k=0;k<cooperates.length;k++){
			approvers[k]=new Option(cooperates[k],cooperates[k]);
			if(k==0){
				approvers[k].selected=true;
			}
		}
	}else{
		approvers[0]=new Option(cooperate,cooperate);
	}
}

function changeModel(){
	if(document.getElementById('model1').checked){
		document.getElementById('timeShow').style.display = '';
		document.getElementById('approverShow').style.display = '';
		document.getElementById('pwShow').style.display = 'none';
		document.getElementById('workorderShow').style.display = 'none';
		document.getElementById('contentShow').style.display = 'none';
	}
	if(document.getElementById('model2').checked){
		document.getElementById('pwShow').style.display = '';
		document.getElementById('timeShow').style.display = '';
		document.getElementById('approverShow').style.display = '';
		document.getElementById('workorderShow').style.display = 'none';
		document.getElementById('contentShow').style.display = 'none';
	}
	if(document.getElementById('model3').checked){
		document.getElementById('pwShow').style.display = 'none';
		document.getElementById('timeShow').style.display = 'none';
		document.getElementById('approverShow').style.display = 'none';
		document.getElementById('workorderShow').style.display = '';
		document.getElementById('contentShow').style.display = '';
	}
}

function doShowSend(){
	var account = document.getElementById('account').value;
	var time = document.getElementById('maxTime').value;
	var approver = document.getElementById('approver').value;
	var model = 'remoteAuth';
	var caseDesc = document.getElementById('caseDesc').value;
	var pwCode = document.getElementById('pwCode').value;
	var workorderNO = document.getElementById("workorderNO").value;
	var operContent = document.getElementById("operContent").value;
	var count = document.getElementById("count").value;
	if(document.getElementById('model3').checked){
		model = 'workOrderAuth';
		if(document.getElementById('account').value == ''){
			alert('申请人信息不能为空。');
			return;
		}
		if(document.getElementById('workorderNO').value == ''){
			alert('工单编号不能为空。');
			return;
		}
		if(document.getElementById('operContent').value == ''){
			alert('操作内容不能为空。');
			return;
		}
		if(document.getElementById('caseDesc').value == ''){
			alert('申请原因不能为空。');
			return;
		}
	}else{
		if(document.getElementById('account').value == ''){
			alert('申请人信息不能为空。');
			return;
		}
		if(document.getElementById('maxTime').value == ''){
			alert('授权有效时限不能为空。');
			return;
		}
		if(document.getElementById('approver').value == ''){
			alert('协作人员信息不能为空。');
			return;
		}
		if(document.getElementById('model2').checked){
			model = 'siteAuth';
			if(document.getElementById('pwCode').value == ''){
				alert('协作人员静态密码信息不能为空。');
				return;
			}
		}
		if(document.getElementById('caseDesc').value == ''){
			alert('申请原因信息不能为空，请简要描述。');
			return;
		}
	}
	var _ajax = new aihb.Ajax({
		url : "${mvcPath}/jinku/send"
		,parameters : "account="+account+"&time="+time+"&approver="+approver+"&caseDesc="+caseDesc+"&optype="+model+"&appSessionId="+appSessionId+"&clientIp="+clientIp+"&sceneId="+sceneId+"&workorderNO="+workorderNO+"&operContent="+operContent+"&pwCode="+pwCode+"&nid="+nid
		,loadmask : true
		,callback : function(xmlrequest){
			var result = xmlrequest.responseText;
			result = eval("("+result+")");
			if('N' == result.isPass){
	    		count = parseInt(count)+1;
	    		document.getElementById("count").value = count;	
	    		alert("认证码不正确，您已错误"+count+"次，最多输入3次，请重新认证！");
					if(count==3){
						doClose();
					}
			}else{
				if(model!='remoteAuth'){
					document.getElementById('closeImg').parentNode.parentNode.parentNode.style.display='none';
					toDown();
				}else{
					showCodeDialog();
				}
			}
		}
	})
	_ajax.request();
}

function showCodeDialog(){
	var content = "<div style='margin: 0 10px 10px 10px' >"
		+"<fieldset style='width: 350px; height: 180px;'>"
			+"<legend> 请输入远程授权动态码 </legend>"
			+"<table align='center' width='90%' height='90%'>"
				+"<tr>"
					+"<td align='center'><label> <input id='pwCode1'"
							+" type='text' style='width: 230px;'>"
					+"</label> <input id='count1' type='hidden' style='width: 180px' value='0'>"
					+"</td>"
				+"</tr>"
			+"</table>"
		+"</fieldset>"
		+"<br><div align='center' style='margin-bottom:8px;'><input type='button' value='确定' onclick='doCodeSend()'>"
		+"&nbsp;&nbsp;&nbsp;&nbsp; "
		+"<input type='button' value='取消' onclick='doClose()'></div>"
	+"</div>";
	_cont.innerHTML = content;
	_mask.show();
}

function doCodeSend(){
	var pwCode = document.getElementById('pwCode1').value;
	var count = document.getElementById("count1").value;
	if(pwCode == ''){
		alert('授权动态码信息不能为空。');
		return;
	}
	
	var _ajax = new aihb.Ajax({
		url : "${mvcPath}/jinku/send"
		,parameters : "account="+account+"&time="+maxTime+"&approver="+cooperate+"&optype=remoteAuth2&appSessionId="+appSessionId+"&clientIp="+clientIp+"&sceneId="+sceneId+"&pwCode="+pwCode
		,loadmask : true
		,callback : function(xmlrequest){
			var result = xmlrequest.responseText;
			result = eval("("+result+")");
			if('N' == result.isPass){
	    		count = parseInt(count)+1;
	    		document.getElementById("count1").value = count;	
	    		alert("认证码不正确，您已错误"+count+"次，最多输入3次，请重新输入！");
				if(count==3){
					doClose();
				}
			}else{
				document.getElementById('closeImg').parentNode.parentNode.parentNode.style.display='none';
				toDown();
			}
		}
	});
	_ajax.request();
}

function toDown()
{
	document.forms[0].action = "gcdownAction.jsp";
	document.forms[0].target = "_top";
	document.forms[0].submit();
}
</script>
  </head>
  <body>
  	<div style="margin: 20 px;text-align: center;font-size: 22px;font-weight: bold;font-family: 黑体">重点集团客户运营分析类指标</div>
	<form action="" method="post">
  	<input type="hidden" name="sql" value="">
  	<input type="hidden" name="title" value="">
  	<input type="hidden" name="filename" value="">
  	<div style="padding: 10 px;"></div>
  
  	<table align="center" width="83%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
	  <tr class="grid_title_blue" height="26">
	    <td width="10%" class="grid_title_cell">序号</td>
	    <td width="18%" class="grid_title_cell">跟踪产品</td>
	    <td width="52%" class="grid_title_cell">描述</td>
	    <td width="10%" class="grid_title_cell">下载</td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26" >
	  	<td width="10%" class="grid_row_cell"></td>
	  	<td colspan="3" class="grid_row_cell_text">月份 ：<%=date%>
	  		<input type="hidden" name="date" value="<%=date %>">
	  		<input type="hidden" name="ldate" value="<%= ldate%>" />
	  		<input type="hidden" name="fdate" value="<%= fdate%>" />
	  		<input type="hidden" name="currentdate" value="<%=currentdate%>" />
	  		</td>
	  </tr>
	  	
	  	  <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">1</td>
	    <td class="grid_row_cell_text">直管客户</td>
	    <td class="grid_row_cell_text"> 直管客户基础类指标下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(1)"></td>
	  	</tr>
	      <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">2</td>
	    <td class="grid_row_cell_text">直管客户</td>
	    <td class="grid_row_cell_text"> 直管客户运营类指标下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(2)"></td>
	  	 </tr>
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">3</td>
	    <td class="grid_row_cell_text">重点关注集团关键人全量清单</td>
	    <td class="grid_row_cell_text">重点关注集团关键人全量清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(3)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">4</td>
	    <td class="grid_row_cell_text">重点关注集团信息化业务收入的清单</td>
	    <td class="grid_row_cell_text">重点关注集团信息化业务收入的清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(4)"></td>
	  	</tr>
	  	
<!-- 	  	<tr class="grid_row_alt_blue" height="26"> -->
<!-- 	    <td class="grid_row_cell">5</td> -->
<!-- 	    <td class="grid_row_cell_text">120家重点集团关键人预警清单</td> -->
<!-- 	    <td class="grid_row_cell_text">120家重点集团关键人预警清单下载</td> -->
<!-- 	     <td class="grid_row_cell"> -->
<!-- 	     	<input type="button" class="form_button_short" value="下载" onclick="download(5)"></td> -->
<!-- 	  	</tr> -->
	  	
	  	<!-- <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">5</td>
	    <td class="grid_row_cell_text">拍照重点集团清单</td>
	    <td class="grid_row_cell_text">拍照重点集团清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(5)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">6</td>
	    <td class="grid_row_cell_text">拍照重点集团关键人清单</td>
	    <td class="grid_row_cell_text">拍照重点集团关键人清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(6)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">7</td>
	    <td class="grid_row_cell_text">重点集团打标成员到达数清单</td>
	    <td class="grid_row_cell_text">重点集团打标成员到达数清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(7)"></td>
	  	</tr> 
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">8</td>
	    <td class="grid_row_cell_text">重点集团通讯录人数清单</td>
	    <td class="grid_row_cell_text">重点集团通讯录人数清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(8)"></td>
	  	</tr> -->
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">5</td>
	    <td class="grid_row_cell_text">重客拍照成员流失清单</td>
	    <td class="grid_row_cell_text">重客拍照成员流失清单下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(5)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">6</td>
	    <td class="grid_row_cell_text">直管集团收入情况</td>
	    <td class="grid_row_cell_text">直管集团收入情况下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(6)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">7</td>
	    <td class="grid_row_cell_text">4G营销类指标情况</td>
	    <td class="grid_row_cell_text">4G营销类指标情况下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(7)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">8</td>
	    <td class="grid_row_cell_text">产品收入表</td>
	    <td class="grid_row_cell_text">产品收入表下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(8)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">9</td>
	    <td class="grid_row_cell_text">合约情况</td>
	    <td class="grid_row_cell_text">合约情况下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(9)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">10</td>
	    <td class="grid_row_cell_text">重要合作银行情况（15家）</td>
	    <td class="grid_row_cell_text">重要合作银行情况（15家）下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(10)"></td>
	  	</tr>
	  	
	  	<!-- <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">10</td>
	    <td class="grid_row_cell_text">重客拍照成员保有率清单(集团粒度)</td>
	    <td class="grid_row_cell_text">重客拍照成员保有率清单(集团粒度)下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(10)"></td>
	  	</tr> -->
	  	
	</table>
		</form>
  </body>
</html>
<%@ include file="/hbapp/resources/old/loadmask.htm"%>
<div id="sqlview"></div>