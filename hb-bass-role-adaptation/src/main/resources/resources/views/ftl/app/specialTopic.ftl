<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${topicDetail.name}</title>
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/center.css" />
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/main.js"></script>
</HEAD>
<BODY>
	<div class="spec-container">
		<div class="spec-title">${topicDetail.name}</div>
		<div class="item-row">
		<#assign index=0/>  
		<#list subTopics as subTopic>
			<#if topicDetail.deep == 3>
				<#if (subTopic.child?exists) && (subTopic.child?size) gt 0>
				<#list subTopic.child as child1>
					<div class="spec-item">
						<!--一级标题-->
						<#if child1_index != 0>
							<div class="spec-item-title">&nbsp;</div>
						<#else>
							<div class="spec-item-title 
							<#if index != 0>
								left-bor
							</#if>
							">
								<div class="sub-icon"><span class="${subTopic.icon!''}"></span></div>${subTopic.sname}
							</div>
						</#if>
						<!--二级标题-->
						<div class="
							<#if index != 0 && child1_index!=0>
								sub-spe-content 
							<#else>
								spe-content 
							</#if>
							<#if index != 0 && child1_index==0>
								left-bor 
							</#if>">
							<div class="sub_spec-title 
								<#if index != 0 && child1_index!=0>
									left-bor-dashed
								</#if>">${child1.sname}</div>
							<#if (child1.child?exists) && (child1.child?size) gt 0>
								<#list child1.child as child2>
									<div class="spec-item-row 
										<#if index != 0 && child1_index!=0>
											left-bor-dashed
										</#if> "><a href="#" 
									<#if child2.uri??> onclick="window.parent.addTab('zt_${child2.id?trim}','${child2.sname?trim}','${child2.uri?trim}')"
									</#if> title="${child2.sname}" >${child2.sname}</a></div>
								</#list>
							</#if>
							
							<#if index=3>
								<#assign index= 0/>
							<#else>
								<#assign index= index + 1/>
							</#if>
						</div>
					</div>
					<#if child1_index == 3>
						<div class="row-split"></div>
					</#if>
				</#list>
				</#if>
			<#else>
				<div class="spec-item 
					<#if index != 0>
						left-bor
					</#if>">
					<div class="spec-item-title"><div class="sub-icon"><span class="${subTopic.icon!''}"></span></div>${subTopic.sname}</div>
					 <div class="spe-content">
					 	<#if (subTopic.child?exists) && (subTopic.child?size) gt 0>
						<#list subTopic.child as child>
							<div class="spec-item-row"><a href="#" 
								<#if child.uri??> onclick="window.parent.addTab('zt_${child.id?trim}','${child.sname?trim}','${child.uri?trim}')"
								</#if> title="${child.sname}">${child.sname}</a>
							</div>
						</#list>
						</#if>
						<#if index==3>
							<#assign index= 0/>
						<#else>
							<#assign index= index + 1/>
						</#if>
					</div>
				</div>
			</#if>
		</#list>
		<#if index !=0>
			<#list index..3 as j>
				<div class="spec-item">
					<div class="spec-item-title">&nbsp;</div>
					<div class="spe-content">&nbsp;</div>
				</div>
			</#list>
		</#if>
		</div>
		<!--专题描述信息-->
		<div class="item-row">
			<div class="spec-item-title pl2">${topicDetail.name}</div>
			<div class="spe-desc">${topicDetail.desc}</div>
		</div>
	</div>
	<script>
	function changeWidth(){
		var itemWid =$(".item-row").width();
		$(".spec-item").css("width", itemWid/4);
	}
	
	changeWidth();
	</script>
</BODY>
</HTML>