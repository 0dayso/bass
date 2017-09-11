<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<!--[if lt IE 9]>
		<script type="text/javascript" src="${mvcPath}/resources/lib/html5.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/lib/respond.min.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/lib/PIE_IE678.js"></script>
		<![endif]-->
<!--[if IE 7]>
		<link href="${mvcPath}/resources/lib/font-awesome/font-awesome-ie7.min.css" rel="stylesheet" type="text/css" />
		<![endif]-->
<!--[if IE 6]>
		<script type="text/javascript" src="${mvcPath}/resources/lib/DD_belatedPNG_0.0.8a-min.js" ></script>
		<script>DD_belatedPNG.fix('*');</script>
		<![endif]-->
<link rel="stylesheet"
	href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
<link rel="stylesheet"
	href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/bootstrap/css/bootstrap.min.css"/>
<link rel="stylesheet"
	href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/hbbass.css" />
<script
	src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
<script
	src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jqmeter.min.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/main.js"></script>
<!--tree-->
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hb-bass-frame/views/ftl/index/css/zTreeStyle.css">
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hb-bass-frame/views/ftl/index/css/zTreeStyle/zTreeStyle.css">
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/menuTree.css">
<script type="text/javascript"
	src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery.ztree.all.min.js"></script>
<script type="text/javascript"
	src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery.ztree.exhide.js"></script>
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/css/bootstrap-datetimepicker.css">
<script type="text/javascript"
	src="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript"
	src="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/bootstrap/js/bootstrap.min.js"></script>
<!--<script type="text/javascript"
	src="${mvcPath}/resources/lib/layer3.0.1/layer/layer.js"></script>-->
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/jqLoading/js/jquery-ui-jqLoding.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/echarts.common.min.js"></script>
<style type="text/css">
.btn_search{
    padding: 0px 7px;
    height: 20px;
    line-height: 19px;
    border: 0px solid #ccc;
    border-radius: 2px;
    color: #f5f5f5;
    background-color: #3AA0DA;
    font-size: 13px;
}
.Modal-bdy-ul {
	list-style-type: none;
	padding-left: 0px;
	padding-top: 3px;
}

.Modal-bdy-ul .Modal-bdy-ul-item {
	padding-bottom: 3px;
	padding-top: 6px;
}

.Modal-bdy-ul .Modal-bdy-ul-item .Modal-bdy-ul-item-title {
	font-weight: bold;
}

.Modal-bdy-ul .Modal-bdy-ul-item .Modal-bdy-ul-item-context {
	background-color: #B9DEF1;
	padding: 6px;
	margin-top: 6px;
	margin-bottom: 6px;
}

.dropdown-submenu {
	position: relative;
}

.dropdown-submenu>.dropdown-menu {
	top: 0;
	left: 100%;
	margin-top: -6px;
	margin-left: -1px;
	-webkit-border-radius: 0 6px 6px 6px;
	-moz-border-radius: 0 6px 6px;
	border-radius: 0 6px 6px 6px;
}

.dropdown-submenu:hover>.dropdown-menu {
	display: block;
}

.dropdown-submenu>a:after {
	display: block;
	content: " ";
	float: right;
	width: 0;
	height: 0;
	border-color: transparent;
	border-style: solid;
	border-width: 5px 0 5px 5px;
	border-left-color: #ccc;
	margin-top: 5px;
	margin-right: -10px;
}

.dropdown-submenu:hover>a:after {
	border-left-color: #fff;
}

.dropdown-submenu.pull-left {
	float: none;
}

.dropdown-submenu.pull-left>.dropdown-menu {
	left: -100%;
	margin-left: 10px;
	-webkit-border-radius: 6px 0 6px 6px;
	-moz-border-radius: 6px 0 6px 6px;
	border-radius: 6px 0 6px 6px;
}

.sys-wrap-r {
	min-width: 600px;
	width: 78%;
	position: relative;
	float: left;
	padding-left: 1%;
	margin-left: 0;
}
.arrow-control {
border-radius: 3px;
    width: 98px;
    border: 1px solid #E8E8E8;
    height: 25px;text-align: center;display: inline-block;}
    
#cover{ 
display:none; 
position:fixed; 
z-index:1; 
top:0; 
left:0; 
width:100%; 
height:100%; 
background:rgba(0, 0, 0, 0.44); 
} 
#coverShow{ 
display:none; 
position:fixed; 
z-index:2; 
top:50%; 
left:50%; 
border:1px solid #127386; 
width:300px; 
height:100px; 
margin-left:-150px; 
margin-top:-150px; 
background:#127386; 
} 
option{
text-align: center;
}


#name{
  margin-left: 45px;
}
.alert-down{
 width: 451px;
 margin-left: -15px;
 background: rgb(232,242,254);
 height: 40px;
}
.alert-button{
  margin-top: 10px;
}
.alert-suer{
margin-left: 300px;
}
.mask {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: #000;
	opacity: 0.5;
	filter: Alpha(opacity=50);
	-moz-opacity: 0.5;
	z-index: 10;
}
.alert {
	display: none;
	position: fixed;
	top: 60%;
	left: 58%;
	width: 453px;
	height: auto;
	margin-top: -231px;
	margin-left: -330px;
	background-color: #fff;
	z-index: 20;
}

</style>
</head>
<body>
	<div class="connent"
		style="background-color: #F4F4F4; padding-top: 10px;">
		<div id="r102">
			<div id="r103">
				<div>
					<div id="r1031" class="r1">
						<span class="play7" id="kpiTitle"></span>
					</div>
					<div id="r1032">
						<input type="text" id="txtMenu" placeholder="请输入您要搜索的内容" /><span
							class=" icon-search" id="btnMenuSearch"></span>
					</div>
					<div id="r1033">
						<ul id="indexTree" class="ztree2"
							style="width: 95%; margin-left: 10px">
						</ul>
					</div>
				</div>
			</div>
			<div id="r104">
				<div>
					<span class="play7 r1">热门推荐</span>
				</div>
				<div id="r1041" class="recommed">
				</div>
			</div>
		</div>
		<div id="r105" class="container">
			<div id="r106" class="row">
				<div class="col-md-12" style="width: 99%;">
					<div class="table-connent">
						<div id="r1061">
							<span class="play7">指标&nbsp&nbsp</span>
							<div class="r10611">
								<span class="span1 span1_left" id="dayBtn">日</span><span
									class="span1 span1_right" id="monthBtn">月</span><span class="span2">日</span>
							</div>
							<input type="text" id="datepickerD" readonly
								class="arrow-control" style="height: 25px;" value="${lastDay!}">
							<input type="text" id="datepickerM" readonly
								class="arrow-control" style="height: 25px; display: none"
								value="${lastDay!}"> <select class="play1" id="selCity">
                                                                 <option value='HB'>湖北</option>
								
							</select>
							<div class="r10612">
								<span class="span1 span3_left">入网</span><span class="span1 span3_right">区域</span><span class="span3">入网</span>
							</div>
							<div class="r10613">
								<span class="span1 span4_left">高速</span><span class="span1 span4_right">实时</span><span class="span4">高速</span>
							</div>
							<div class="chart">
								<span class="icon-data-chart2"></span>
							</div>
							<input type="button" class='btn_search' id="queryBtn"  value="查询">
						</div>
						<div id="r1062">
							<table id="kpitable">
								 <tr id="kpiTabTitle">
									<th class="play_1" style="width:26%">综合市场</th>
									<th class="play_1" style="width:10%">日</th>
									<th class="play_1" style="width:10%">较昨日</th>
									<th class="play_1" style="width:12%">较上月同期</th>
									<th class="play_1" style="width:10%">日累计</th>
									<th class="play_1" style="width:10%">较上月</th>
									<th class="play_1" style="width:12%">较去年同期</th>
									<th class="play_1" style="width:10%">操作</th>
								</tr>
								 <tbody id="kpitbody" >
							     </tbody>
							 </table>
						</div>
						<div id="r1063" style="height: 100%; width: 96%; display: none;">
							<div class="r10614">
								<span onclick="showAre('1')" class="span1 span5_left">地域分析</span> 
								<span onclick="showTime('1')" class="span1 span5_right">时域分析</span><span class="span5">地域分析</span>
								</div>
								<div class="r10611">
								    <span class="span1 span6_left" id="dayBtnd">日</span>
								    <span class="span1 span6_right" id="monthBtnm">月</span><span class="span6">日</span>
								</div>
								<input type="text" id="datepickerDd" readonly
									class="arrow-control" style="height: 25px;text-align: center" value="${lastDay!}">&nbsp
								<input type="text" id="datepickerMm" readonly
									class="arrow-control" style="height: 25px;display:none;text-align: center" value="${lastDay!}">&nbsp
								<input type="text" id="datepickerDd_1" readonly
									class="arrow-control" style="height: 25px;display:none;text-align: center" value="${lastDay!}">&nbsp
								<input type="text" id="datepickerMm_1" readonly
									class="arrow-control" style="height: 25px;display:none;text-align: center" value="${lastDay!}">
							
							<button type="text" class='btn_search' id="queryBtn1">查询</button>
							<div id="chart" style="height: 300px; border: 1px solid #ccc;margin-top:1%; padding: 10px;"></div>
							<p style="text-align:center;width:100%;"><span id="selectOne" style="font-size: 17px;color:#555;"></span></p>
						</div>
					</div>
				</div>
			</div>
			<div id="r107" class="row">
				<div class="col-md-12" style="width: 99%;">
					<div class="col-md-4 rel-box">
						<div class="r1071 rel-content" style="margin-right: 3%;">
							<div class="r1072">
								<div style="float:left; width:87.5%;"><span class="play3">报表中心</span></div>
								<div style="float:left;"><img
									src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/u116.png"
									class="u116_img" style="cursor:pointer;margin-left:0;"
									onclick="window.parent.addTab('reportCenter_${menu_id!?trim}','报表中心(${appName!})','../reportCenter/index/${menu_id!?trim}')" ;/>
								</div>
							</div>
							<div id="relaReports" class="r1073">
								
							</div>
						</div>
					</div>
					<div class="col-md-4 rel-box">
						<div class="r1071 rel-content"
							style="margin-left: 1.5%; margin-right: 1.5%;">
							<div class="r1072">
								<div style="float:left; width:87.5%;"><span class="play3">应用中心</span></div>
								<div style="float:left;"><img
									src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/u116.png"
									class="u116_img" style="cursor:pointer;margin-left:0;"
									onclick="window.parent.addTab('appCenter_${menu_id!?trim}','应用中心(${appName!})','../appCenter/index/${menu_id!?trim}')" />
								</div>
							</div>
							<div id="relaApps" class="r1073 ">
								
							</div>
						</div>
					</div>
					<div class="col-md-4 rel-box">
						<div class="r1071 rel-content" style="margin-left: 3%;">
							<div class="r1072">
								<div style="float:left; width:87.5%;"><span class="play3">我的收藏</span></div>
								<div><img
									src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/u116.png"
									class="u116_img" style="cursor:pointer;margin-left:0;"
									onclick="window.parent.addTab('myCollect_${menu_id!?trim}','我的收藏(${appName!})','../myCollect/index/${menu_id!?trim}')" /></div>
							</div>
							<div id="relaColls" class="r1073">
								
							</div>
		                 </div>
		             </div>
		         </div>
			</div>
			<div id="r108" class="row">
				<div class="col-md-12" style="width: 100%;">
					<div class="table-connent">
						<div style="padding: 10px;padding-left:2%">
							<span class="play7 z3">最新上线</span>

						</div>
						<#if (lastestOnlineReport ? exists) && (lastestOnlineReport ? size) gt 0>
						<#list lastestOnlineReport as online>
						    <div class="r1082">
						    <a href="#"
						        onclick="window.parent.addTab('${online.id!}','${online.name!}','${online.uri!}')"
						        title="${online.name}">
						        <div>
						            <span class="u995_img" style="display: block; /* width: 122px;height: 84px; */margin: auto;background-color: #e5f1f8;color:#3aa0da;font-size: 60px;padding: 12px 30px;"></span>	 
						            <span class="play1 play5" style="margin-left: 0px;text-align: center;">${online.name!''}</span>
						        </div>
						     </a>
						     </div>
						</#list>
						</#if>
					</div>
				</div>
			</div>
		</div>
	</div>
<div id="cover" style=""></div> 
<div id="coverShow" style=""> 
<table align="center" border="0" width="100%" cellspacing="0" cellpadding="0" style="border-collapse: collapse; height: 100px; min-height: 100px;" bgcolor="#127386"> 
<tr> 
<td height="30" style="font-size: 12px;">正在加载，请稍后......</td> 
</tr> 
<tr> 
<td align="center" bgcolor="#ffffff"> 
<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/5-140FGQT6.gif"/>
</td> 
</tr> 
</table> 
</div> 

<!--蒙版      弹窗-->
<div class="mask"></div>
<div class="alert">
    <span id="name">单次曝光成本(元)</span>：
    <input type="text" id="updvalue" style="width:65%"> 
    <div class="alert-down">
      <button class="alert-sure alert-button">确定</button>
      <button class="alert-button alert-return">取消</button>
    </div>
</div>

</body>
<script type="text/javascript">
var timeType;
// 设置选中指标
var menuId;
//选中的指标所有id集合
var menusId=[];
// 设置选中地区
var areaValue;
var selectedNode;
var mvcPath = "${mvcPath}";
// 指标树
var curMenu = null, zTree_Menu = null;
var setting = {
  view: {
   showLine: false,
   showIcon: false,
   selectedMulti: false,
   dblClickExpand: false,
   addDiyDom: addDiyDom,
   fontCss: getFontCss
 },
 data: {
   simpleData: {
    enable: true
  }
},
callback: {
 beforeClick: beforeClick,
 onClick: this.onClick
},
};
zNodes = ${bocIndicatorMenus!};
function addDiyDom(treeId, treeNode) {
	var spaceWidth = 5;
	var switchObj = $("#" + treeNode.tId + "_switch"),
	icoObj = $("#" + treeNode.tId + "_ico");
	switchObj.remove();
	icoObj.before(switchObj);
	if (treeNode.level > 1) {
		var spaceStr = "<span style='display: inline-block;width:" + (spaceWidth * treeNode.level)+ "px'></span>";
		switchObj.before(spaceStr);
	}
 var spantxt=$("#" + treeNode.tId + "_span").html();  
 if(spantxt.length>11){  
  spantxt=spantxt.substring(0,11)+"...";  
  $("#" + treeNode.tId + "_span").html(spantxt);  
 }
}

function getFontCss(treeId, treeNode) {
  return (!!treeNode.highlight) ? {color:"#A60000", "font-weight":"bold"} : {color:"#333", "font-weight":"normal"};
}

function beforeClick(treeId, treeNode) {
  var zTree = $.fn.zTree.getZTreeObj("indexTree");
  zTree.expandNode(treeNode);
  return true;
}
function onClick(e, treeId, node) {
    var arr=[];
    var arr1=[];
	menuId = node.id;
	selectedNode = node;
	arr.push(menuId);
	   var textNode;
    textNode=node.name;
    $("#selectOne").text(textNode);
    if(node.children){
	if(node.children.length>0){
	for(var i=0;i<node.children.length;i++){
	var nodeData=node.children;
	  arr1.push(nodeData[i].id);
	  }
     }
    }
    arr.push(arr1);
    menusId=arr.join(",").split(",");
}

  //数据追加“%”和箭头
  var upArrow="<span class='icon-swap-up' style='color:#4BB901'></span>";
  var downArrow="<span class='icon-swap-down' style='color:red'></span>";
  var zeroArrow="<span class='icon-swap-right' style='color:#777'></span>";
function appendArrow(data){
if(data==null||data==''||data==undefined){
 data="--";
}else if(data!=null){
   if(data>0){
   data=data+"%"+upArrow;
   }
   if(data<0){
   data=data+"%"+downArrow;
   }
   if(data==0){
   data=zeroArrow;
   }
  }
  return data;
}


//创建菜单
function createKPiRow(queryDB){
	var kpiData,time,dimType,dimValue;
	if($("#datepickerD")[0].style.display != "none"){
		timeType = 'day';
		time = $("#datepickerD").val();
	}
	if($("#datepickerM")[0].style.display != "none"){
		timeType = 'month';
		time = $("#datepickerM").val();
		time = time.replace(/-/g,"");
	}
    dimValue = $("#selCity").val();
    if(dimValue==null&&dimValue==''){
    	dimValue="HB";
    	dimType="PROV_ID";
    }
    if(dimValue=="HB"){dimType="PROV_ID";}
    else{dimType="CITY_ID";}
    //修改表头
    var tr = $("#kpiTabTitle");
    if(timeType=='day')
    {
      tr.find("th:nth-child(2)").text("日");
      tr.find("th:nth-child(3)").text("较昨日");
      tr.find("th:nth-child(4)").text("较上月同期");
      tr.find("th:nth-child(5)").text("日累计");
      tr.find("th:nth-child(6)").text("较上月");
      tr.find("th:nth-child(7)").text("较去年同期");
    }
    else
    {
      tr.find("th:nth-child(2)").text("月");
      tr.find("th:nth-child(3)").text("较上月");
      tr.find("th:nth-child(4)").text("较去年同期");
      tr.find("th:nth-child(5)").text("月累计");
      tr.find("th:nth-child(6)").text("较上月");
      tr.find("th:nth-child(7)").text("较去年同期");
    }
      createKpiFormRow(menusId,dimType,dimValue,time,queryDB);
       $(".tableTr:odd").css("backgroundColor","#F4F4F4");
       $(".tableTr:even").css("backgroundColor","#fff");
}

//生成KPI表单Row
  	     function createKpiFormRow(menusId,dimCode,dimValue,time,queryDB){
       try{
      getKPIData(menusId,dimCode,dimValue,time,queryDB,function(data,dimCode,dimValue,queryDB){
      var kpiData=[];
      var kpiHtml="";
      if(dimCode=="PROV_ID"){
        for(var a=0;a<data.length;a++){
       if(data[a]!=null){
        if(data[a].sql==null||data[a].sql==''){
             kpiData.push(data[a]);
          }
         }
        }
        for(var j=0;j<kpiData.length;j++){
           if(kpiData[j].regionName=="湖北"){
               if(kpiData[j].kpiUnit==''||kpiData[j].kpiUnit==null){
               kpiData[j].regionName=kpiData[j].kpiName;
               }else{
               kpiData[j].regionName=kpiData[j].kpiName+"("+kpiData[j].kpiUnit+")";
                }
            }
          }
        }else if(dimCode=="CITY_ID"){
          for(var k=0;k<data.length;k++){
         if(data[k]!=null){
           if(data[k].sql==null||data[k].sql==''){
             kpiData.push(data[k]);
             }
           }
          }
           for(var m=0;m<kpiData.length;m++){
           var cityName=$.trim( $("#selCity option:selected").text());
            if(kpiData[m].regionName==cityName){
              if(kpiData[m].kpiUnit==''||kpiData[m].kpiUnit==null){
               kpiData[m].regionName=kpiData[m].kpiName;
              }else{
              kpiData[m].regionName=kpiData[m].kpiName+"("+kpiData[m].kpiUnit+")";}
            }
           }
        }
      for(var i=0;i<kpiData.length;i++){
      var d=kpiData[i];
       dimValue=dimValue.replace(".","_").replace(".","_").replace(".","_");
       if(timeType == 'day'){
           var dailyComparedYesterday=appendArrow(d.dailyComparedYesterday);
           var dailyComparedLastMonth=appendArrow(d.dailyComparedLastMonth);
           var dailyAccumulationComparedLastMonth=appendArrow(d.dailyAccumulationComparedLastMonth);
           var dailyAccumulationComparedLastYear=appendArrow(d.dailyAccumulationComparedLastYear);
           if(dimCode=="PROV_ID"){
                 if(d.dimCode=="CITY_ID"){
                  kpiHtml+="<tr class='tableTr "+d.menuId+"' style='display:none;' menuId='"+d.menuId+"' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:30px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+d.description+"' style='float:right;color: #3aa0da;display: inline-block' onclick='if(checkAuth()){showEdit(\""+d.menuId+"\",\""+d.description+"\")}'></span></td>";
                  }else{
                  kpiHtml+="<tr class='tableTr'  menuId='"+d.menuId+"' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:20px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+d.description+"' style='float:right;color: #3aa0da;display: inline-block' onclick='if(checkAuth()){showEdit(\""+d.menuId+"\",\""+d.description+"\")}'></span></td>";
                  }
             }else if(dimCode=="CITY_ID"){
                if(d.dimCode=="COUNTY_ID"){
                 kpiHtml+="<tr class='tableTr "+d.menuId+"_"+dimValue+" "+d.menuId+"_"+dimCode+"'  style='display:none;'  menuId='"+d.menuId+"' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:30px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+d.description+"' style='float:right;color: #3aa0da;display: inline-block' onclick='if(checkAuth()){showEdit(\""+d.menuId+"\",\""+d.description+"\")}'></span></td>";
               }else {
                 kpiHtml+="<tr class='tableTr "+d.menuId+"'  menuId='"+d.menuId+"' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:20px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+d.description+"' style='float:right;color: #3aa0da;display: inline-block' onclick='if(checkAuth()){showEdit(\""+d.menuId+"\",\""+d.description+"\")}'></span></td>";
                }
             }
	        kpiHtml+="<td class='play1'>"+(d.dailyCurrent||"--")+"</td>";
			kpiHtml+="<td class='play1'>"+dailyComparedYesterday+"</td>";
			kpiHtml+="<td class='play1'>"+dailyComparedLastMonth+"</td>";
			kpiHtml+="<td class='play1'>"+(d.dailyAccumulation||"--")+"</td>";
			kpiHtml+="<td class='play1'>"+dailyAccumulationComparedLastMonth+"</td>";
			kpiHtml+="<td class='play1'>"+dailyAccumulationComparedLastYear+"</td>";
			kpiHtml+="<td class='play1' style='text-align:center;'><span style='color:#3AA0DA;cursor: pointer;'  onclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>分析</span>&nbsp;<span style='color:#4BB901;cursor: pointer;' onclick='addFavorite(\""+d.id+"\")'>收藏</span></td></tr>";
           }else if(timeType == 'month'){
           var monthlyComparedLastMonth=appendArrow(d.monthlyComparedLastMonth);
           var monthlyComparedLastYear=appendArrow(d.monthlyComparedLastYear);
           var monthlyAccumulationComparedLastMonth=appendArrow(d.monthlyAccumulationComparedLastMonth);
           var monthlyAccumulationComparedLastYear=appendArrow(d.monthlyAccumulationComparedLastYear);
            if(dimCode=="PROV_ID"){
                 if(d.dimCode=="CITY_ID"){
                  kpiHtml+="<tr class='tableTr "+menuId+"' style='display:none;' menuId='2110000'  menuId='2110000' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:30px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'     title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block' ></span></td>";
                  }else{
                  kpiHtml+="<tr class='tableTr'  menuId='2110000' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:20px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'     title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block'></span></td>";
                  }
             }else if(dimCode=="CITY_ID"){
                if(d.dimCode=="COUNTY_ID"){
                 kpiHtml+="<tr class='tableTr "+d.menuId+"_"+dimValue+" "+d.menuId+"_"+dimCode+"'  style='display:none;' menuId='"+d.menuId+"'  type='"+d.dimCode+"'><td class='play1' style='text-align:left;padding-left:30px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block' ></span></td>";
               }else {
                 kpiHtml+="<tr class='tableTr "+d.menuId+"'  menuId='"+d.menuId+"'   type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:20px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block' ></span></td>";
                }
             }
			kpiHtml+="<td class='play1'>"+(d.monthlyCurrent||"--")+"</td>";
			kpiHtml+="<td class='play1'>"+monthlyComparedLastMonth+"</td>";
			kpiHtml+="<td class='play1'>"+monthlyComparedLastYear+"</td>";
			kpiHtml+="<td class='play1'>"+(d.monthlyAccumulation||"--")+"</td>";
			kpiHtml+="<td class='play1'>"+monthlyAccumulationComparedLastMonth+"</td>";
			kpiHtml+="<td class='play1'>"+monthlyAccumulationComparedLastYear+"</td>";
			kpiHtml+="<td class='play1' style='text-align:center;'><span style='color:#3AA0DA;cursor: pointer;' onclick='controlShowKpi(\""+d.menuId+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>分析</span>&nbsp;<span style='color:#4BB901;cursor: pointer;' onclick='addFavorite(\""+d.id+"\")'>收藏</span></td></tr>";
          }
        }
           $("#kpitbody").html(kpiHtml);
           $(".tableTr:odd").css("backgroundColor","#F4F4F4");
           $(".tableTr:even").css("backgroundColor","#fff");
           $("body").jqLoading("destroy");
   });
   }catch(err) {
   	 $("body").jqLoading("destroy");
   }
}


//请求kpi数据
function getKPIData(menuid,dimCode,dimVal,date,queryDB,cb)
{
	$("body").jqLoading();
  var url = "${mvcPath}/kpi/"+menuid;
  $.ajax({
		url: url,
		timeout : 30000,
		type:"get",
		//async: false,
		dataType: 'json',
		data: {
		     date:date,
		     dimCode:dimCode,
		     dimVal:dimVal,
		     queryDB:queryDB
		},
		success: function(data, textStatus) {
			if(cb){
			  cb(data,dimCode,dimVal,queryDB);
			}
		},
　          complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
　　　           　if(status=='timeout'){//超时,status还有success,error等值的情况
 　　　　            　 //ajaxTimeoutTest.abort();
　　　　　            $("body").jqLoading("destroy");
　　　　            }
　　            }
	});
}


//双击菜单显示or隐藏or查询子菜单/分析
function controlShowKpi(menuid,dimCode,dimValue,th){
     $("#kpitable tr td").css("font-weight","normal");
     $(th).parent("td").parent("tr").find("td").css("font-weight","bold");
     $("#kpitable tr td").css("color","rgb(153, 153, 153)");
     $(th).parent("td").parent("tr").find("td").css("color","#3AA0DA");
    var dimVal=dimValue.replace(".","_").replace(".","_").replace(".","_");
    if(dimCode=="PROV_ID"){
         if($("."+menuid+"").css("display")=="none"){
            $("."+menuid+"").css("display","");
            }else{
            $("."+menuid+"_CITY_ID").css("display","none");
            $("."+menuid+"_COUNTY_ID").css("display","none");
            $("."+menuid+"_MARKET_ID").css("display","none");
            $("."+menuid+"").css("display","none");
            }
     }else{
           if(dimCode=="CITY_ID"){
             if($("."+menuid+"_"+dimVal+"").length>0){
                if($("."+menuid+"_"+dimVal+"").css("display")=="none"){
                   $("."+menuid+"_COUNTY_ID").css("display","none");
                   $("."+menuid+"_MARKET_ID").css("display","none");
                   $("."+menuid+"_"+dimVal+"").css("display","");
               }else{
                   $("."+menuid+"_"+dimCode+"").css("display","none");
                   $("."+menuid+"_"+dimVal+"").css("display","none");
                }
             }else{
                appendNextLevelData(menuid,dimCode,dimValue,th);
                 $(".tableTr:odd").css("backgroundColor","#F4F4F4");
	             $(".tableTr:even").css("backgroundColor","#fff");
              }
         }else if(dimCode=="COUNTY_ID"){
           if($("."+menuid+"_"+dimVal+"").length>0){
                if($("."+menuid+"_"+dimVal+"").css("display")=="none"){
                   $("."+menuid+"_MARKET_ID").css("display","none");
                   $("."+menuid+"_"+dimVal+"").css("display","");
               }else{
                   $("."+menuid+"_"+dimCode+"").css("display","none");
                   $("."+menuid+"_"+dimVal+"").css("display","none");
                }
           }else{
                appendNextLevelData(menuid,dimCode,dimValue,th);
                 $(".tableTr:odd").css("backgroundColor","#F4F4F4");
	             $(".tableTr:even").css("backgroundColor","#fff");
           }
         }
     }
}

//追加下级菜单
function appendNextLevelData(menuid,dimCode,dimValue,th){
             var childHtml="";
             var tr =  $("<tr class='tableTr'></tr>");
             $("."+menuid+"_"+dimCode+"").css("display","none");
         	 var time;
	         if($("#datepickerD")[0].style.display != "none"){
		      timeType = 'day';
		      time = $("#datepickerD").val();
	          }
	       if($("#datepickerM")[0].style.display != "none"){
		     timeType = 'month';
		     time = $("#datepickerM").val();
		     time = time.replace(/-/g,"");
	          }
	        getKPIData(menuid,dimCode,dimValue,time,queryDB,function(data,dimCode,dimVal,queryDB){
	        dimValue=dimValue.replace(".","_").replace(".","_").replace(".","_");
	         for(var j=2;j<data.length;j++){
	            var d=data[j];
	            if(d!=null){
	          if(timeType == 'day'){
	           var dailyComparedYesterday=appendArrow(d.dailyComparedYesterday);
	           var dailyComparedLastMonth=appendArrow(d.dailyComparedLastMonth);
	           var dailyAccumulationComparedLastMonth=appendArrow(d.dailyAccumulationComparedLastMonth);
	           var dailyAccumulationComparedLastYear=appendArrow(d.dailyAccumulationComparedLastYear);
	          if(d.dimCode=="COUNTY_ID"){
	            childHtml+="<tr class='tableTr "+menuid+"_"+dimValue+" "+menuid+"_"+dimCode+"' menuId='"+menuid+"'  type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:40px;cursor: pointer;' ><span ondblclick='controlShowKpi(\""+menuid+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block' ></span></td>";
	            childHtml+="<td class='play1'>"+(d.dailyCurrent||"--")+"</td>";
				childHtml+="<td class='play1'>"+dailyComparedYesterday+"</td>";
				childHtml+="<td class='play1'>"+dailyComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+(d.dailyAccumulation||"--")+"</td>";
				childHtml+="<td class='play1'>"+dailyAccumulationComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+dailyAccumulationComparedLastYear+"</td>";
				childHtml+="<td class='play1' style='text-align:center;'><span style='color:#3AA0DA;cursor: pointer;'  onclick='controlShowKpi(\""+menuid+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>分析</span>&nbsp;<span style='color:#4BB901;cursor: pointer;' onclick='addFavorite(\""+d.id+"\")'>收藏</span></td></tr>";
	           }else if(d.dimCode=="MARKET_ID"){
	            childHtml+="<tr class='tableTr "+menuid+"_"+dimValue+" "+menuid+"_"+dimCode+"'  menuId='"+menuid+"' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:50px;cursor: pointer;'>"+(d.regionName||"--")+"<span class='icon-export'      title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block'></span></td>";
	            childHtml+="<td class='play1'>"+(d.dailyCurrent||"--")+"</td>";
				childHtml+="<td class='play1'>"+dailyComparedYesterday+"</td>";
				childHtml+="<td class='play1'>"+dailyComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+(d.dailyAccumulation||"--")+"</td>";
				childHtml+="<td class='play1'>"+dailyAccumulationComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+dailyAccumulationComparedLastYear+"</td>";
				childHtml+="<td class='play1' style='text-align:center;'><span style='color:#3AA0DA;cursor: pointer;'>分析</span>&nbsp;<span style='color:#4BB901;cursor: pointer;' onclick='addFavorite(\""+d.id+"\")'>收藏</span></td></tr>";
	           }
	     }else if(timeType == 'month'){
	           var monthlyComparedLastMonth=appendArrow(d.monthlyComparedLastMonth);
	           var monthlyComparedLastYear=appendArrow(d.monthlyComparedLastYear);
	           var monthlyAccumulationComparedLastMonth=appendArrow(d.monthlyAccumulationComparedLastMonth);
	           var monthlyAccumulationComparedLastYear=appendArrow(d.monthlyAccumulationComparedLastYear);
	           if(d.dimCode=="COUNTY_ID"){
	            childHtml+="<tr class='tableTr "+menuid+"_"+dimValue+" "+menuid+"_"+dimCode+"' menuId='"+menuid+"'  type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:40px;cursor: pointer;'><span ondblclick='controlShowKpi(\""+menuid+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"</span><span class='icon-export'      title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block' ></span></td>";
	            childHtml+="<td class='play1'>"+(d.monthlyCurrent||"--")+"</td>";
				childHtml+="<td class='play1'>"+monthlyComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+monthlyComparedLastYear+"</td>";
				childHtml+="<td class='play1'>"+(d.monthlyAccumulation||"--")+"</td>";
				childHtml+="<td class='play1'>"+monthlyAccumulationComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+monthlyAccumulationComparedLastYear+"</td>";
				childHtml+="<td class='play1' style='text-align:center;'><span style='color:#3AA0DA;cursor: pointer;' onclick='controlShowKpi(\""+menuid+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>分析</span>&nbsp;<span style='color:#4BB901;cursor: pointer;' onclick='addFavorite(\""+d.id+"\")'>收藏</span></td></tr>";
	           }else if(d.dimCode=="MARKET_ID"){
	            childHtml+="<tr class='tableTr "+menuid+"_"+dimValue+" "+menuid+"_"+dimCode+"'  menuId='"+menuid+"' type='"+d.dimCode+"' ><td class='play1' style='text-align:left;padding-left:50px;cursor: pointer;' ondblclick='controlShowKpi(\""+menuid+"\",\""+d.dimCode+"\",\""+d.dimVal+"\",this)'>"+(d.regionName||"--")+"<span class='icon-export'      title='"+(d.menuName||d.regionName||"--")+"' style='float:right;color: #3aa0da;display: inline-block'></span></td>";
	            childHtml+="<td class='play1'>"+(d.monthlyCurrent||"--")+"</td>";
				childHtml+="<td class='play1'>"+monthlyComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+monthlyComparedLastYear+"</td>";
				childHtml+="<td class='play1'>"+(d.monthlyAccumulation||"--")+"</td>";
				childHtml+="<td class='play1'>"+monthlyAccumulationComparedLastMonth+"</td>";
				childHtml+="<td class='play1'>"+monthlyAccumulationComparedLastYear+"</td>";
				childHtml+="<td class='play1' style='text-align:center;'><span style='color:#3AA0DA;cursor: pointer;'>分析</span>&nbsp;<span style='color:#4BB901;cursor: pointer;' onclick='addFavorite(\""+d.id+"\")'>收藏</span></td></tr>";
	                }
				 }
	           }
	         }
	                  $(th).parent("td").parent("tr").after(childHtml);
	                  $(".tableTr:odd").css("backgroundColor","#F4F4F4");
	                  $(".tableTr:even").css("backgroundColor","#fff");
	                  $("body").jqLoading("destroy");
	      })
}

   // 添加收藏
   function addFavorite(data)
   {
     $.ajax({
       url: '${mvcPath}/myCollect/addCollect',
       type: "POST",
       async: false,
       dataType: 'json',
       data: {
        rid: data,
        menuId: ${menu_id!}
      },
      success: function(data, textStatus) {
       if (data.flag) {
        alert(data.msg);
      } else {
        alert(data.msg);
      }
    },
  });
 }
   //初始化Kpi报表
   function initFormData(){
          var dim_Type;
          var dim_Value;
          var opTime;
          if($("#datepickerD")[0].style.display != "none"){
		   timeType = 'day';
		   opTime = $("#datepickerD").val();
	       }
	      if($("#datepickerM")[0].style.display != "none"){
		   timeType = 'month';
		   opTime = $("#datepickerM").val();
	     }
	         dim_Value = $("#selCity").val();
           if(dim_Value==null&&dim_Value==''){
    	     dim_Value="HB";
    	     dim_Type="PROV_ID";
           }
          if(dim_Value=='HB'){
            dim_Type="PROV_ID";}
            else{dim_Type='CITY_ID';}
       createKpiFormRow(menusId,dim_Type,dim_Value,opTime,0);
   }
   
     var queryDB=0;
    $(".span4_right").click(function(){
		    var _text=$(this).text();
		  	$(".span4").animate({left:'50px'});
		  	$(".span4").text( _text);
		   if(_text=="高速"){
	          queryDB=0;
	        }else if(_text=="实时"){
	        queryDB=1;
	          }
		  });
	$(".span4_left").click(function(){
			    var _text=$(this).text();
			  	$(".span4").animate({left:'0px'});
			  	$(".span4").text( _text);
			  	 if(_text=="高速"){
	          queryDB=0;
	        }else if(_text=="实时"){
	        queryDB=1;
	          }
			  });

	$("#queryBtn").on({
	 click: function(){  
	     $("#kpitbody").empty();
	        menuId=selectedNode.id; 
        	 createKPiRow(queryDB);
         $(".tableTr:odd").css("backgroundColor","#F4F4F4");
         $(".tableTr:even").css("backgroundColor","#fff");
        }
	});
	
  function searchNode(txt)
 {
    var zTree = $.fn.zTree.getZTreeObj("indexTree");
    var nodes = zTree.transformToArray(zTree.getNodes());
    //先清除所有的
    for(var i=0;i<nodes.length;i++)
    {
       nodes[i].isVisible = false;
       nodes[i].highlight = false;
       zTree.updateNode(nodes[i]);
    }
    zTree.hideNodes(nodes);
    if(txt!=null&&txt!="")
    {
	    nodes = zTree.getNodesByParamFuzzy("name", txt);
	    for(var i=0;i<nodes.length;i++)
	    {
	       var node = nodes[i];
	       node.isVisible = true;
	       node.highlight = true;
	       zTree.updateNode(node);
	       eachPNode(node,function(pNode){
	          pNode.isVisible = true;
	       });
	       eachChildren(node,function(n){
	         n.isVisible = true;
	       });
	    }
	    nodes = zTree.getNodesByParam("isVisible", true);
	    zTree.showNodes(nodes);
	    zTree.expandAll(true);
    }
    else
    {
       var nodes = zTree.getNodesByParam("isVisible", false);
	   zTree.showNodes(nodes);
	   zTree.expandAll(false);//收缩所有节点
    }
 }
 
  function eachPNode(node,cb)
 {
    if(node==null)
    {
      return;
    }
    else
    {
       cb(node);
       node = node.getParentNode();
       eachPNode(node,cb);
    }
 }
 
 function eachChildren(node,cb)
 {
    if(node!=null)
    {
        cb(node);
        var children = node.children;
	    if(children!=null)
	    {
	      for(var i=0;i<children.length;i++)
	      {
	         eachChildren(children[i],cb);
	      }
	    }
    }
 }
 
$(document).ready(function(){
    $("[data-toggle='tooltip']").tooltip();
	// 构建指标树
	var treeObj = $("#indexTree");
	// 去掉前两项
	var node1,node2;
	if(zNodes.length>2)
	{
   node1 = zNodes[0];
   node2 = zNodes[1];
   zNodes = zNodes.slice(2,zNodes.length);
   $("#kpiTitle").html(node2.name);
	  // kpi表头修改
	  $("#kpiTabTitle").find("th:nth-child(1)").text(node2.name);
	}
	$.fn.zTree.init(treeObj, setting, zNodes);
	zTree_Menu = $.fn.zTree.getZTreeObj("indexTree");
	// curMenu = zTree_Menu.getNodes()[0].children[0];
	// menuId = curMenu.id;
	// 设置标签内容
	zTree_Menu.selectNode(curMenu);// 选中第二级的第一个节点
	treeObj.hover(function () {
		if (!treeObj.hasClass("showIcon")) {
			treeObj.addClass("showIcon");
		}
	}, function() {
		treeObj.removeClass("showIcon");
	});
	 zTree_Menu.expandAll(false);// 收缩所有节点
    // 增加树搜索
    $("#btnMenuSearch").on({  
      click: function(){
        searchNode($("#txtMenu").val());
      }});
    $("#txtMenu").on("keydown", 
     function(event){
       var keycode = (event.keyCode ? event.keyCode : event.which);  
       if(keycode == '13'){  
         searchNode($("#txtMenu").val());
       } 
     });
    
    
     //默认选择第一个节点展开
      var zTree = $.fn.zTree.getZTreeObj("indexTree");  
       var nodes = zTree.getNodes();    
      zTree.expandNode(nodes[0], true); 
      var childNodes = zTree.transformToArray(nodes[0]); 
        zTree.selectNode(nodes[0]);
         var array=[];
	     menuId = nodes[0].id;
	     selectedNode = nodes[0];
	     array.push(menuId);
	     var textNode;
         textNode=nodes[0].name;
      $("#selectOne").text(textNode);
       var array1=[];
       if(nodes[0].children){
	    if(nodes[0].children.length>0){
        for(var j=0;j<nodes[0].children.length;j++){
        var nodesData=nodes[0].children;
        array1.push(nodesData[j].id);
          }
        }
      }else{
      array1=[];
      }
      array.push(array1);
    menusId=array.join(",").split(",");
        
	// 日期选择
	$("#datepickerD").datetimepicker({
		format: 'yyyy-mm-dd',
		weekStart: 1,  
    autoclose: true,  
    startView: 2,  
    minView: 2,  
    forceParse: false,
    todayHighlight : true,
    language: 'zh-CN',
  });
	$("#datepickerM").datetimepicker({
		format: 'yyyy-mm',
		weekStart: 1,  
    autoclose: true,  
    startView: 3,  
    minView: 3,  
    forceParse: false,
    language: 'zh-CN'
  });
	$("#datepickerDd").datetimepicker({
		format: 'yyyy-mm-dd',
		weekStart: 1,  
    autoclose: true,  
    startView: 2,  
    minView: 2,  
    forceParse: false,
    todayHighlight : true,
    language: 'zh-CN',
  });
	$("#datepickerDd_1").datetimepicker({
		format: 'yyyy-mm-dd',
		weekStart: 1,  
    autoclose: true,  
    startView: 2,  
    minView: 2,  
    forceParse: false,
    todayHighlight : true,
    language: 'zh-CN',
  });
	$("#datepickerMm").datetimepicker({
		format: 'yyyy-mm',
		weekStart: 1,  
    autoclose: true,  
    startView: 3,  
    minView: 3,  
    forceParse: false,
    language: 'zh-CN'
  });
	$("#datepickerMm_1").datetimepicker({
		format: 'yyyy-mm',
		weekStart: 1,  
    autoclose: true,  
    startView: 3,  
    minView: 3,  
    forceParse: false,
    language: 'zh-CN'
  });
	
	// 默认选中
	// 切换日月的样式
	$("#dayBtn,#monthBtn").on({  
    click: function(){
      if($(this).attr("id") == "dayBtn"){
       $("#datepickerD").show();
       $("#datepickerM").hide();
     }
     if($(this).attr("id") == "monthBtn"){
       $("#datepickerM").show();
       $("#datepickerD").hide();
     }
   }
 });
 
	$("#queryBtn1").on({
    click: function(){  
     menuId=selectedNode.id; 
     refreshReport('2');
   }
 });
	
	 // 图标展开
  $(".chart").click(function(){
    if(selectedNode==null){
      alert("请选择KPI指标项");
      return ;
    }else{
      menuId = selectedNode.id;
      if($("#r1063").css("display")=="none"){
       $("#r1063").css("display","block");
       if(flag==1){
        showAre('1');
      }else{
        showTime('1');
      }
      var textNode;
      textNode=selectedNode.name;
      $("#selectOne").text(textNode);
    }else{
     $("#r1063").css("display","none");
   }
 }
});

 //初始化KPI
 initFormData();

});


// 刷新报表的数据
function refreshReport(num) {
  if(flag==1){
   showAre(num);
 }
 if(flag==2){
  if($("#datepickerDd")[0].style.display != "none" &&  $("#datepickerDd_1")[0].style.display != "none"){
    var   sT=$.trim($("#datepickerDd").val().replace(/-/g,"/").replace(/-/g,"/"));
    var   eT=$.trim($("#datepickerDd_1").val().replace(/-/g,"/").replace(/-/g,"/"));
    var sTime =new Date(sT);
    var eTime = new Date(eT); 
    function dateC(sTime,eTime){
     return (eTime-sTime)/86400000>15;
   } 
   if(sTime>eTime){
     alert("开始时间不能大于结束时间");
     return false;
   }
   if(eTime!=""&&sTime!=""){
    if(dateC(sTime,eTime)){
      alert("日期间隔太大，请您选择15天内范围！");
      return false;
    }
  }
}
if($("#datepickerMm")[0].style.display != "none" &&  $("#datepickerMm_1")[0].style.display != "none"){
 var sT=$.trim($("#datepickerMm").val().replace(/-/g,"/").replace(/-/g,"/"));
 var eT=$.trim($("#datepickerMm_1").val().replace(/-/g,"/").replace(/-/g,"/"));
 var sTime =new Date(sT);
 var eTime = new Date(eT); 
 function dateC(sTime,eTime){
   return (eTime-sTime)/86400000/30>15;
 } 
 if(sTime>eTime){
  alert("开始时间不能大于结束时间");
  return false;
}
if(eTime!=""&&sTime!=""){
  if(dateC(sTime,eTime)){
    alert("日期间隔太大，请您选择15个月内范围！");
    return false;
  }
}
}
showTime(num);
}
}

function openNewPage(name, value){
	var sid = new Date().getTime();
	$("#position").find("ul").append("<li class='divide fl'>></li><li class=\"fl\"><a onclick=\"backto('" + sid + "')\" pageId='" + sid + "'>" + name + "</a></li>");
	if((new RegExp("^redirect:")).test(value)){
		value = mvcPath + "/accessOtherSys?redirectPath="+encodeURIComponent(value.substring("redirect:".length));
	}
	$("#page").parent().append("<div id=" + sid + "><iframe frameborder='0' src='" + value + "' style='height: 100%;width: 98%; position: absolute;'></iframe></div>");
	$("#page").parent().children("div").hide();
	$("#" + sid).show();
	$("#position").show();
}

var flag=1;
// 按地域展示
function showAre(num){
  var dimType,dimValue, dateType,time;
  dimValue = $("#selCity").val();
  if(dimValue==null&&dimValue==''){
   dimValue="HB";
   dimType="PROV_ID";
 }
 if(dimValue=='HB'){
 dimType="PROV_ID";
 }else{dimType='CITY_ID';}
 
 	// 切换日月的样式
  $("#dayBtnd,#monthBtnm").on({  
    click: function(){
      if($(this).attr("id") == "dayBtnd"){
       $("#datepickerDd").show();
       $("#datepickerDd_1").hide();
       $("#datepickerMm").hide();
       $("#datepickerMm_1").hide();
     }
     if($(this).attr("id") == "monthBtnm"){
       $("#datepickerMm").show();
       $("#datepickerDd").hide();
       $("#datepickerDd_1").hide();
       $("#datepickerMm_1").hide();
     }
   }
 });
 if(num==1){
  $("#datepickerDd").show();
   document.getElementById("datepickerDd").value="${lastDay!}";
   time = $.trim($("#datepickerDd").val());
  $("#datepickerDd_1").hide();
  $("#datepickerMm").hide();
  $("#datepickerMm_1").hide();
 // $("#dayBtnd").addClass("span2").siblings().removeClass("span2");
}else{
  if($("#datepickerDd")[0].style.display != "none"){
    dateType = "day";
    time = $.trim($("#datepickerDd").val());
  }
  if($("#datepickerMm")[0].style.display != "none"){
   dateType = "month";
   time = $.trim($("#datepickerMm").val());
  } 
}

  flag = 1;
  var myChart = echarts.init(document.getElementById('chart'));
  
  var cityValues=[];
  var currentValue=[];
  var yoyValue=[];
  var chainValue=[];
  $(function() {
  	$("body").jqLoading();
  	$.ajax({
  		type: "post",
  		timeout: 30000,
  		async: false,
  		url: "${mvcPath}/kpi/" + menuId,
  		data: {
  			dimCode: dimType,
  			dimVal: dimValue,
  			date: time,
  			queryDB: queryDB
  		},
  		dataType: "json",
  		success: function(data) {
  			var arr = [];
  			for(var i = 2; i < data.length; i++) {
  				arr.push(data[i]);
  			}
  			var date, currentNum, tbNum, hbNum;
  			if(dateType == "day") {
  				for(var i = 0; i < arr.length; i++) {
  					cities = arr[i].regionName;
  					currentNum = arr[i].dailyCurrent;
  					tbNum = arr[i].dailyComparedYesterday;
  					hbNum = arr[i].dailyComparedLastMonth;
  					cityValues.push({
  						value: cities
  					});
  					currentValue.push({
  						value: currentNum
  					});
  					yoyValue.push({
  						value: tbNum
  					});
  					chainValue.push({
  						value: hbNum
  					});
  				}
  			}
  			if(dateType == "month") {
  				for(var i = 0; i < arr.length; i++) {
  					cities = arr[i].regionName;
  					currentNum = arr[i].monthlyCurrent;
  					tbNum = arr[i].monthlyComparedLastMonth;
  					hbNum = arr[i].monthlyComparedLastYear;
  					cityValues.push({
  						value: cities
  					});
  					currentValue.push({
  						value: currentNum
  					});
  					yoyValue.push({
  						value: tbNum
  					});
  					chainValue.push({
  						value: hbNum
  					});
  				}
  			}
  		},
  		error: function(errorMsg) {
  			alert("图表请求数据失败!");
  		},
　　     complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
　　　           　if(status=='timeout'){//超时,status还有success,error等值的情况
 　　　　       //    ajaxTimeoutTest.abort();
            $("body").jqLoading("destroy");
　　　　            }
　　            }
  	});
  });
 Option = {
   backgroundColor:'#f4f4f4',
   tooltip : {
    trigger: 'axis'
  },
  color:['rgba(58, 160, 218, 1)','rgba(255, 102, 102, 1)','rgba(179, 226, 149, 1)'],
  calculable : false,
  legend: {	
    orient: 'horizontal',
    x: 'right',
    y:"top",
    data:['当前值','同比','环比']
  },
  xAxis : [
  {
    type : 'category',
    axisLabel :{
     interval:0,
			    rotate: -20,// 60度角倾斜显示

       },
       data : cityValues
     }
     ],
     yAxis : [
     {
      type : 'value',
      name:'单位(万元)',
      axisLabel : {
        formatter: '{value}'
      }
    },
    {
      type : 'value',
      axisLabel : {
        formatter: '{value}%'
      }
    }
    ],
    series : [

    {
      name:'当前值',
      type:'bar',
      barWidth:30,
      data:currentValue
    },
    {
      name:'同比',
      type:'line',
      yAxisIndex: 1,
      data:yoyValue
    },
    {
      name:'环比',
      type:'line',
      yAxisIndex: 1,
      data:chainValue
    }
    ]
  };
  myChart.setOption(Option);
   $("body").jqLoading("destroy");
}

// 按時域展示
function showTime(num){
          // 切换日月的样式
          $("#dayBtnd,#monthBtnm").on({  
         click: function(){
          if($(this).attr("id") == "dayBtnd"){
           $("#datepickerDd").show();
           $("#datepickerDd_1").show();
           $("#datepickerMm").hide();
           $("#datepickerMm_1").hide();
         }
         if($(this).attr("id") == "monthBtnm"){
           $("#datepickerMm").show();
           $("#datepickerDd").hide();
           $("#datepickerMm_1").show();
           $("#datepickerDd_1").hide();
         }
       }
     });
     
  var starTime,endTime,dateType;
  if(num==1){
    $("#datepickerDd").show();
    document.getElementById("datepickerDd").value="${lastDay!}";
    $("#datepickerDd_1").show();
    document.getElementById("datepickerDd_1").value="${lastDay!}";
    $("#datepickerMm").hide();
    $("#datepickerMm_1").hide();
 //   $("#dayBtnd").addClass("span2").siblings().removeClass("span2");
     starTime=$.trim($("#datepickerDd").val());
     endTime=$.trim($("#datepickerDd_1").val());
  }else{
         if($("#datepickerDd")[0].style.display != "none" &&  $("#datepickerDd_1")[0].style.display != "none"){
             dateType='day';
             starTime=$.trim($("#datepickerDd").val());
             endTime=$.trim($("#datepickerDd_1").val());
           } 

           if($("#datepickerMm")[0].style.display != "none" &&  $("#datepickerMm_1")[0].style.display != "none"){
             dateType='month';
             starTime=$.trim($("#datepickerMm").val());
             endTime=$.trim($("#datepickerMm_1").val());
           }
  }
           flag =2 ;
           var myChart = echarts.init(document.getElementById('chart'));
           var dimType,dimValue;
           dimValue = $("#selCity").val();
           if(dimValue==null&&dimValue==''){
             dimValue="HB";
             dimType="PROV_ID";
           }
           if(dimValue=='HB'){dimType="PROV_ID";}
           else{dimType='CITY_ID';}
           var dateArr=[]; 
           var currenArr=[];
           var yoyArr=[];
           var chainArr=[];  
            $("body").jqLoading();     
           $.ajax({
             type:"post",
             timeout : 30000,
             async:false,
             url:"${mvcPath}/kpi/query/"+menuId,
                 data:{
                   dimVal:dimValue,
                   dimCode:dimType,
                   startTime:starTime,
                   endTime:endTime,
                   queryDB:queryDB
                 },
                 dataType:"json",
                 success : function(data) {
                   var date,currenNum,tbNum,hbNum;
                   if(dateType=='day'){
                     for(var i=0;i<data.length;i++){
                       date=data[i].opTime;
                       currenNum=data[i].dailyCurrent;
                       tbNum=data[i].dailyComparedYesterday;
                       hbNum=data[i].dailyComparedLastMonth;
                       dateArr.push({value:date});  
                       currenArr.push({value:currenNum});
                       yoyArr.push({value:tbNum});
                       chainArr.push({value:hbNum}); 
                     }
                   }
                   if(dateType=='month'){
                    for(var i=0;i<data.length;i++){
                     date=data[i].opTime;
                     currenNum=data[i].monthlyCurrent;
                     tbNum=data[i].monthlyComparedLastMonth;
                     hbNum=data[i].monthlyComparedLastYear;
                     dateArr.push({value:date});  
                     currenArr.push({value:currenNum});
                     yoyArr.push({value:tbNum});
                     chainArr.push({value:hbNum}); 
                   }
                 }
               },
               error : function(errorMsg) {
                alert("图表请求数据失败!");
              },
　　                       complete : function(XMLHttpRequest,status){ 
　　　                            　if(status=='timeout'){
 　　　　            　         //     ajaxTimeoutTest.abort();
　　　　　                         $("body").jqLoading("destroy");
　　　　                          }
　　                         }
            });      
           Option = {
            backgroundColor:'#f4f4f4',
            tooltip : {
              trigger: 'axis'
            },
            color:['rgba(58, 160, 218, 1)','rgba(255, 102, 102, 1)','rgba(179, 226, 149, 1)'],
            calculable : false,
            legend: {	
             orient: 'horizontal',
             x: 'right',
             y:"top",
             data:['当前值','同比','环比']
           },
           xAxis : [
           {
            type : 'category',
            axisLabel :{
             interval:0,
			    rotate: -20,// 60度角倾斜显示

       },
       data : dateArr
     }
     ],
     yAxis : [
     {
      type : 'value',
      name:'单位(万元)',
      axisLabel : {
        formatter: '{value}'
      }
    },
    {
      type : 'value',
      axisLabel : {
        formatter: '{value}%'
      }
    }
    ],
    series : [

    {
      name:'当前值',
      type:'bar',
      barWidth:30,
      data:currenArr
    },
    {
      name:'同比',
      type:'line',
      yAxisIndex: 1,
      data:yoyArr
    },
    {
      name:'环比',
      type:'line',
      yAxisIndex: 1,
      data:chainArr
    }
    ]
  };
  myChart.setOption(Option);
   $("body").jqLoading("destroy");
}

$(function(){
$('.u995_img').eq(0).addClass("icon-data-chart4");
$('.u995_img').eq(1).addClass("icon-data-chart1");
$('.u995_img').eq(2).addClass("icon-data-chart2");
$('.u995_img').eq(3).addClass("icon-setting");
$('.u995_img').eq(4).addClass("icon-api2");

  $.ajax({
    typ:'post',
    url:'${mvcPath}/roleAdapt/roleAdaptParam/',
    async: false,
    data:{
     menuId: ${menu_id!}
   },
   dataType:'json',
   success:function(data){
     if(data){
      var options = '';
      var relaReports = '';
      var relaApps = '';
      var relaColls = '';
      var option  = '';
      for(var key in data){
       if(key == 'cityList'){
        for(var num in data[key]){
         var list = data[key];
         options +="<option value='"+list[num].city_id+"'>"+list[num].city_name+"</option>";
       }
     }
     if(key == 'relaReports'){
      for(var num in data[key]){
       var list = data[key];
       relaReports +="<div class='rela-row'><div class='rela-point'><span class='cicrs'></span></div>"
       +"<div class='rela-text'>"
       +"<a href='javascript:;' onclick=\"window.parent.addTab('"+$.trim(list[num].id)+"','"+$.trim(list[num].text)+"','"+$.trim(list[num].uri)+"')\" title='"+list[num].text+"'> "+list[num].text+" </a>"
       +"</div><div class='rela-num'> <span class='play4'>"+list[num].remark+"</span></div></div>";
     }
   }
   if(key == 'relaApps'){
    for(var num in data[key]){
     var list = data[key];
     relaApps +="<div class='rela-row'><div class='rela-point'><span class='cicrs'></span></div>"
     +"<div class='rela-text'>"
     +"<a href='javascript:;' data-uri='"+$.trim(list[num].uri)+"' onclick=\"openRelaApps('"+$.trim(list[num].id)+"','"+$.trim(list[num].text)+"','"+$.trim(list[num].uri)+"')\" title='"+list[num].text+"'> "+list[num].text+" </a>"
     +"</div><div class='rela-num'> <span class='play4'>"+list[num].remark+"</span></div></div>";
   }
 }
 if(key == 'relaColls'){
  for(var num in data[key]){
   var list = data[key];
   relaColls +="<div class='rela-row'><div class='rela-point'><span class='cicrs'></span></div>"
   +"<div class='rela-text'>"
   +"<a href='javascript:;' onclick=\"window.parent.addTab('"+$.trim(list[num].id)+"','"+$.trim(list[num].text)+"','"+$.trim(list[num].uri)+"')\" title='"+list[num].text+"'> "+list[num].text+" </a>"
   +"</div><div class='rela-num'> <span class='play4'>"+list[num].remark+"</span></div></div>";
 }
}
}
$("#selCity").append(options);
$("#relaReports").html(relaReports);
$("#relaApps").html(relaApps);
$("#relaColls").html(relaColls);
}
}
});
});
function openRelaApps(id,title,uri){
 if(uri.indexOf('renderpageSpecialTopic:')>-1){
  window.parent.addTab(id,title,"../appCenter/subSpecialTopic?resId=" + id);
}else if(uri.indexOf('renderPageZtShow:')>-1){
  window.parent.addTab(id,title,'../appCenter/appzt?menuId='+id)
}else{
  window.parent.addTab(id,title,uri)
}
}
function coverit() { 
  var cover = document.getElementById("cover"); 
  var covershow = document.getElementById("coverShow"); 
  cover.style.display = 'block'; 
  covershow.style.display = 'block'; 
} 
function closeit() { 
  var cover = document.getElementById("cover"); 
  var covershow = document.getElementById("coverShow"); 
  cover.style.display = 'none'; 
  covershow.style.display = 'none'; 
}
window.onload = function(){
	var icons=["icon-sum","icon-user","icon-api2","icon-data-chart1","icon-data-chart3"];
	var goal=[];
	var raised=[];
	var name=[];
	 var Tablehtml="";
	$.ajax({
		typ:'post',
		url:'${mvcPath}/roleAdapt/recommend',
		dataType:'json',
		success:function(data){
			for(var key in data){	
				name.push(data[key].name);
				raised.push(data[key].raised.toString());
				goal.push(data[key].goal.toString());
			}
			 
			  Tablehtml+="<table>";
			for(var i=0;i<name.length;i++){
				Tablehtml+="<tr><td style='width:12%;text-align:right;border: none;'><span style=\"color: rgb(57, 158, 216)\" class='"+icons[i]+"'></span></td>";
				Tablehtml+="<td style='width:30%;border: none;'><span style='width:100%;display: inline-block;white-space: nowrap;text-overflow: ellipsis; overflow: hidden;' class='play1 play2' >"+name[i]+"</span></td>";
				Tablehtml+="<td style=\"width:58%;border: none;\"><span id='a"+i+"'></span></td></tr>";
			}
			
			Tablehtml+="</table>";
			$(".recommed").html(Tablehtml);
			for(var i=0;i<name.length;i++){
				$("#a"+ i).jQMeter({"goal":goal[i],"raised":raised[i]});
			}
			
		}
		
	});
}
//描述编辑


function checkAuth(){
var name='${loginUser!}';
	if('zhaojing'==name || 'admin'==name){
	return true;
	}
	alert("您没有编辑权限");
	return false;
}

function showEdit(menuid,oldWord){
	   $("#updvalue").val(oldWord);
	   $("#name").text("编辑");
	   $(".mask,.alert").show();
	   $(".alert-sure").unbind('click');
	   $(".alert-sure").click(function() {
		var newWord = $("#updvalue").val();
		commitUpdateDisc(menuid,newWord);
		});

}

$(".alert-return").click(function() {
		$(".mask,.alert").hide();
	});
	
function commitUpdateDisc(menuid,value){
		$.ajax({
			type : "POST",
			url : '${mvcPath}/roleAdapt/updateKpiDes',
			data : {
				menuid :menuid,
				description:value
			},
			dataType:'json',
			async : false,
			success : function(data) {
					if(data.RESULT_CODE==0){
						alert("修改成功");	
						$(".mask,.alert").hide();
					}else if(data.RESULT_CODE==-1){
						alert("修改失败");
					}
			},
			error : function(request, text, error) {
				alert("Server Error!");
			}
		});
	}



//document.getElementsByClassName('u995_img')[0].setAttribute("src","${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/"+"u995.png");
//document.getElementsByClassName('u995_img')[1].setAttribute("src","${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/"+"u1009.png");
//document.getElementsByClassName('u995_img')[2].setAttribute("src","${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/"+"u1023.png");
//document.getElementsByClassName('u995_img')[3].setAttribute("src","${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/"+"u1036.png");
//document.getElementsByClassName('u995_img')[4].setAttribute("src","${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/"+"u1050.png");
</script>
</html>
