var charge = ["brand_id,brands,品牌","CHARGE_TYPE,CHARGE_TYPE,收入类型"];
var dura = ["brand_id,brands,品牌","TOLL_TYPE,TOLL_TYPE,费用类型","ROAM_TYPE,ROAM_TYPE,漫游类型","CALL_TYPE,CALL_TYPE,呼叫类型"];
var user = ["brand_id,brands,品牌"];
var sms = ["brand_id,brands,品牌","SMS_TYPE,SMS_TYPE,短信类型"];
var mms = ["brand_id,brands,品牌","MMS_TYPE,MMS_TYPE,彩信类型"];
var zhanbi = ["NET_TYPE,NET_TYPE,网络类型"];
var payfee = ["channel_kind,channelkind,渠道种类","channel_type,channeltype,渠道类型"];
var cs = ["brand_id,brands,品牌","WD1,complaint,投诉类型"];

var hasFluctuating = {};
hasFluctuating["K10001"]=charge;
hasFluctuating["K10002"]=charge;
hasFluctuating["K20001"]=charge;

hasFluctuating["K10006"]=dura;
hasFluctuating["K10007"]=dura;
hasFluctuating["K20002"]=dura;

hasFluctuating["K10003"]=user;
hasFluctuating["K10004"]=user;
hasFluctuating["K10005"]=user;
hasFluctuating["K10008"]=user;
hasFluctuating["K10009"]=user;
hasFluctuating["K10010"]=user;
hasFluctuating["K10019"]=user;
hasFluctuating["K20003"]=user;
hasFluctuating["K20004"]=user;
hasFluctuating["K20005"]=user;
hasFluctuating["K20006"]=user;
hasFluctuating["K20009"]=user;
hasFluctuating["K20011"]=user;
hasFluctuating["K20012"]=user;
hasFluctuating["K20013"]=user;
hasFluctuating["K20017"]=user;
hasFluctuating["K20018"]=user;
hasFluctuating["K20020"]=user;

hasFluctuating["K10013"]=sms;
hasFluctuating["K10014"]=mms;

hasFluctuating["K10020"]=payfee;
hasFluctuating["K10021"]=payfee;
hasFluctuating["K20019"]=payfee;

hasFluctuating["K11002"]=zhanbi;
hasFluctuating["K11004"]=zhanbi;
hasFluctuating["K11006"]=zhanbi;
hasFluctuating["K22011"]=zhanbi;
hasFluctuating["K22012"]=zhanbi;
hasFluctuating["K22013"]=zhanbi;
hasFluctuating["K22014"]=zhanbi;

hasFluctuating["CS10001"]=cs;
hasFluctuating["CS10002"]=cs;
hasFluctuating["CS10003"]=cs;
hasFluctuating["CS10004"]=cs;
hasFluctuating["CS10005"]=cs;
hasFluctuating["CS10006"]=cs;

hasFluctuating["CS20001"]=cs;
hasFluctuating["CS20002"]=cs;
hasFluctuating["CS20003"]=cs;
hasFluctuating["CS20004"]=cs;
hasFluctuating["CS20005"]=cs;
hasFluctuating["CS20006"]=cs;