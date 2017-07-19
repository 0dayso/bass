<style>
.banner_panel{width:100%;height:80px;background:#CEEEF4;position:relative;}
.menu_panel{height:100%;width:180px;background:#DDF3F7;}
.content_panel{height:100%;font-size:14px;position:absolute;left:180;top:60;border-top:1px solid;border-left:1px solid;border-color:#c1c1c1;background:#fff;}
.aTwi{padding: 5 px 0;width: 99%;border-bottom:1px dashed #CCC;overflow:hidden;cursor:pointer;}
</style>
<script>
(function($){

$(document).ready(function(){
	
	$(".uinfo").each(function(){
		new aihb.Dialog({
			el:$(this)
			,height: 180
			,width: 330
			,title:"用户信息"
			,mouseOverEl:$(this).parent().children(0)
		});
	});
	
	$(".content_panel").css("width",(document.body.clientWidth-183)+"px");
	
	$("#commentBtn").prependTo($(".content_panel"));
	$("#reply_panel").prependTo($(".reply"));
	
	
	$("#search").click(function(){
		$("#form1").submit();
	})
	
	$("#uploadBtn").click(function(){
		var sid = $("#issueId").val();
		$.ajax({
			url: "${mvcPath}/issue/onload"
			,data : "sid="+sid
			,type : "get"
			,dataType : "text"
		});
	});
	
});

function addIssue(url,data){
		
	var title = encodeURIComponent($("#issue_title").val().trim());
	var content = encodeURIComponent($("#content").val().trim());
	if(title.length==0){
		alert("标题不能为空");
		return;
	}
	
	if(content.length==0){
		alert("内容不能为空");
		return;
	}
	$.ajax({
		url: url
		,data : "state=申告&content=#"+title+"# "+content+data
		,type : "post"
		,dataType : "text"
		,success:function(res){
			location.reload();
		}
	});
}

function update(issueId){
	var url = "${mvcPath}/issue/update?sid="+issueId;
	location.href = url;
}

function deleteById(issueId){

	if(window.confirm("确定要删除该条申告吗？")){
		$.ajax({
			url: "${mvcPath}/issue/delete"
			,data : "sid="+issueId
			,type : "post"
			,dataType : "text"
			,success:function(xmlrequest){
				if(xmlrequest=="1"){
					alert("删除成功！");
				}else{
					alert("删除失败！");
				}
				var url = "${mvcPath}/issue";
				location.href = url;
			}
		});
	}
	
}

window.addIssue=addIssue;
window.update=update;
window.deleteById=deleteById;

})(jQuery)
</script>

<div class="banner_panel">

<div style="position:absolute;z-index:0;FILTER: alpha(opacity=60);opacity:0.6;left:90 px;top:0 px;background:url(${mvcPath}/resources/image/default/ask_pic.png);width:112px;height:133px;"></div>

<a href="${mvcPath}/issue" title="问题申告" style="text-decoration:none;cursor:pointer;"><div style="padding:5px;position:absolute;left:10 px;top:30px;z-index:2;font-size:28px;font-family:黑体;color:#c1c1c1">问题申告</div></a>

<div style="position:absolute;z-index:2000;left:200px;top:14%;">
	<form id="form1" action="${mvcPath}/issue" method="post">
	<input type="text" name="kw" id="kw" style="width:390px;line-height:24px;font-size:20px;margin:0%;padding:3px;" maxlength="100">
	类型：<select id="issue_type" name="issue_type" style="font-size:16px;line-height: 33px;height: 33px;">
		<option value="">全部</option>
		<#list typeList as type>
			<option value="${type.type}">${type.type}</option>
		</#list>
	</select>
	<a href="#" id="search" style="display:inline-block;background:#4B8CF7;border:1px solid #3079ED;width:75px;line-height:28px;height:28px;text-align:center;">
	 <b class="search-white" style="display:inline-block;background:no-repeat url(${mvcPath}/resources/image/default/hpimgs19.png) 0 2px;width:16px;height:16px;margin-top:5px;"></b>
	</a>
	</form>
</div>

</div>

<div class="menu_panel">

	<ul style="width:100%;">
		<li style="border-bottom:1px #ccc solid; padding: 5;">活跃用户</li>
		<#list actives as u>
			<li id="act_${u.id}" style="height: 83px;width:70px;float:left;padding: 5 0 0 6; text-align: center;font-size: 12px;">
				<div style="width:42px;height:39px;border:#bbb 1px solid;padding:2px;background-color: #fff; margin:0 auto;">
					<img src="${mvcPath}/resources/image/default/default_face.gif" width="39" height="36">
				</div>
				
				<!-- <a href="${mvcPath}/twitter/user/${u.id}">${u.name}</a> -->
				<a href="#">${u.name}</a>
				<!--<a href="javascript:void(0)" onclick="feed('${u.id}')">+</a>-->
			</li>
		</#list>
	</ul>
</div>

<div class="content_panel">
	<ul style="padding-left:5;">
		<#list twis as myt>
		<li class="aTwi" url="${mvcPath}/issue/${myt.id?c}" onmousemove="{this.style.backgroundColor='#f5f5f5';}" onmouseout="{this.style.backgroundColor='#fff';}">
			<table>
				<tr valign="top">
				<td>
				<div style="width:43px;height:40px;border:#bbb 1px solid;padding:2px;background-color: #fff;">
					<img src="${mvcPath}/resources/image/default/default_face.gif" width="43" height="40"></img>
					<div style="padding:3px;" class="uinfo">
						<ul>
							<li style="float:left;width:90px;height:88px;border:#bbb 1px solid;padding:2px;background-color: #fff;">
							<img src="${mvcPath}/resources/image/default/default_face.gif" width="89" height="87">
							</li>
							<li style="float:left;padding-left:5px;">
								<#if myt.user?? >
									<div>${myt.user.id}</div>
									<div>${myt.user.name}</div>
									<div>${myt.user.phone}</div>
									<div>${myt.user.areaName}</div>
									<div>${myt.user.groupName}</div>
								</#if>	
							</li>
						</ul>
					</div>
				</div>
					
				</td>
				<td>
					<#assign content_arr = myt.content?split("#")>
					<div><#if myt.replyType!="已回复"><span style="font-size:12px;color:red;">${myt.replyType}</span></#if> 
						<a href="#" style="color: #6EAFD5;"><#if myt.user??>${myt.user.name}</#if></a>：<b style="color: #6EAFD5;">${content_arr[1]} [${myt.type}]</b> --- 当前责任人:${myt.responsible}<#if myt.responsiblePhone !=''>（${myt.responsiblePhone}）</#if>
						<div>
							${content_arr[2]?replace("\n","<br>")}
						</div>
					</div>
					<div>${myt.dateContent}</div>
					<#if myt.fileName??>
						<div>
							<#assign file_arr = myt.fileName?split("_")>
							附件：<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=issue&amp;fileName=${myt.fileName}"><font color="red"><b>${file_arr[1]}</b></font></a>
						</div>
					</#if>
				</td>
				</tr>
			</table>
		</li>
		
		<li class="control">
			<table>
				<tr valign="top">
				<#if myt.user?? && myt.user.id=userId && myt.pid==0>
					<td>
						<input type=button name="updateBtn"	id="updateBtn" value="修改" onclick="update('${myt.id}')">	
					</td>
				</#if>
				<#if userId=='hujuan7' && myt.pid==0 && myt.replyType!="已回复">
					<td>
						<input type=button name="deleteBtn"	id="deleteBtn" value="删除" onclick="deleteById('${myt.id}')">	
					</td>
				</#if>
				</tr>
			</table>
		</li>
		</#list>
		
		<div class="reply">
		</div>
	</ul>
	</div>
</div>
