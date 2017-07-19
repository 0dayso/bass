<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>应用专题</title>
		<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
		<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/index.css" />
		<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/bootstrap/css/bootstrap.min.css" />
		<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
		<style>
		
.nav-left-1 {
    width: 17%;
    height: 100%;
    background-color: #FFFFFF;
    position: absolute;
    top: 0;
    left: 0;
    margin: 5px;
}		
.con-1 {
    position: absolute;
    left: 17%;
    top: 0%;
    width: 83%;
    height: 93%;
    margin-top: 5px;
    margin-left: 12px;
}
	.zt_hot_title {
		background: url("images/repeatBg01.gif") repeat-x scroll left -90px rgba(0, 0, 0, 0);
		color: #456789;
    display: block;
    float: left;
    font-size: 14px;
    font-weight: bold;
    height: 32px;
    line-height: 32px;
    position: relative;
    text-align: left;
    text-indent: 14px;
    width: 100%;
}
.zt_hot_content {
    background-color: #F1F5F8;
    padding: 35px 5px 5px;
}
.zt_hot_content .rr {
    background: url("images/iconBg01.gif") no-repeat scroll 0 -68px rgba(0, 0, 0, 0);
    color: #5A5A5A;
    margin-left: 10px;
    margin-right: 5px;
    margin-top: 5px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.rr {
    background: url("images/icon_03B.png") no-repeat scroll left center transparent;
    margin-left: 5px;
    margin-right: 5px;
    margin-top: 5px;
    color: #5a5a5a;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

#pageZTshowPanel_1_page_title .icon {
    background: url("images/iconBg01.gif") repeat scroll 0 -60px rgba(0, 0, 0, 0);
    display: inline-block;
    height: 30px;
    line-height: 30px;
    vertical-align: middle;
    width: 16px;
    margin-left: 20px;
    margin-top: 10px;
    cursor: pointer;
}

#pageZTshowTabPanel .nav {
    margin-bottom: -1px;
}
#pageZTshowPanel_1_page_title {
    height: 58px;
    background: url("images/repeatBg01.gif") repeat-x scroll 0 -222.3px rgba(0, 0, 0, 0);
}
#pageZTshowPanel_1_page_title .icon {
    background: url("images/iconBg01.gif") repeat scroll 0 -60px rgba(0, 0, 0, 0);
    display: inline-block;
    height: 30px;
    line-height: 30px;
    vertical-align: middle;
    width: 16px;
    margin-left: 20px;
    margin-top: 10px;
    cursor: pointer;
}
#pageZTshowPanel_1_page_title .ztTitle {
    color: #333;
    display: inline-block;
    font-size: 14px;
    font-weight: bold;
    height: 30px;
    line-height: 30px;
    margin-top: 10px;
    text-indent: 7px;
    vertical-align: middle;
}#pageZTshowPanel_1_page_title .ztCollectNum {
    color: #666;
    display: inline-block;
    height: 30px;
    line-height: 35px;
    margin-top: 10px;
    text-indent: 10px;
    vertical-align: middle;
}
#pageZTshowPanel_1_page_title .zbCollectIcon {
    background: url("images/iconBg01.gif") repeat scroll 0 -180.4px rgba(0, 0, 0, 0);
    width: 16px;
    display: inline-block;
    height: 30px;
    line-height: 35px;
    margin-top: 10px;
    margin-left: 20px;
    vertical-align: middle;
    cursor: pointer;
}
#pageZTshowPanel_1_page_title .zbCollectTitle {
    color: #456789;
    display: inline-block;
    height: 30px;
    line-height: 35px;
    margin-top: 10px;
    margin-left: 2px;
    vertical-align: middle;
}
div .active {
    background-color: white;
}
#pageZTshowPanel_1 {
    border-left: 1px solid rgb(201, 220, 226);
    border-right: 1px solid rgb(201, 220, 226);
    border-top: 1px solid rgb(233, 233, 233);
    border-bottom: 1px solid rgb(233, 233, 233);
}
#pageZTshowPanel_1_page_context, #pageZTshowPanel_1_page_pdf {
    height: 500px;
}
</style>
<script>
function openRelaApps(id,title,th){
	var uri = $(th).attr("data-uri");
	if(uri.indexOf('renderpageSpecialTopic:')>-1){
				
	}else if(uri.indexOf('renderPageZtShow:')>-1){
		window.parent.addTab(id,title,'../appCenter/appzt?menuId='+id);
	}else{
		window.parent.addTab(id,title,uri);
	}
}
</script>
	</head>
	<body>
		<div>
		<div class="base">
			<div class="nav-left nav-left-1">
				<div class="l100">
		         <div class="zt_hot_title" >		       
			        <span >热门推荐</span>
		        </div>
                <div class="zt_hot_content" >
                <#list hot as hotApp>
					<div>
						<div class="rr">
							<a title="${hotApp.name}" data-uri="${hotApp.uri?trim}" onclick="openRelaApps('${hotApp.id}','${hotApp.name}',this)">${hotApp.name}</a>
						</div>
					</div>
        		</#list>
				</div>
				</div>	
			</div>
				<div class="con con-1" style=" top:0%;">
					<div id="pageZTshow_TabPanel" class="row-fluid">
						<div id="pageZTshowTabPanel" class="row-fluid ">
							<div class="tabbable tabs-top">
								<ul class="nav nav-tabs">
									<li class="active"><a data-toggle="tab" href="#pageZTshowPanel_1" seq="0">应用专题</a></li>
								</ul>
								<div class="tab-content">
									<div id="pageZTshowPanel_1" class="tab-pane active">
										<div class="container-fluid">
										<div id="pageZTshowPanel_1_page_title" class="row-fluid">
											<div>
												<div class="icon"></div>
												<div class="ztTitle">${detail.name}</div>
												<div class="ztCollectNum">${detail.views!0}人阅读</div>
												<div class="zbCollectIcon"></div>
												<div class="zbCollectTitle" param="${detail.id}">加入收藏</div>
											</div>
										</div>
										<div id="pageZTshowPanel_1_page_context" class="row-fluid">
											<div>
												<div id="pageZTshowPanel_1_page_pdf">
													<object data="http://10.25.124.110:8080/pst/DOC/${show.imgurl}#scrollbars=0&amp;toolbar=0&amp;statusbar=0" type="application/pdf" width="100%" height="500px" internalinstanceid="19"></object>
												</div>
											</div>
										</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			<div>
	
			
			</div>
		</div>
		</div>
	</body>
</html>

