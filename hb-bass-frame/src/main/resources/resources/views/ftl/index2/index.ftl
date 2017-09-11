	<div>
		<style>
			._bass_uname{
				font-size: 12px;
   	 			color: #999999;
    			text-align: left;
    			overflow: hidden;
    			text-overflow: ellipsis;
    			-o-text-overflow: ellipsis;
    			white-space: nowrap;
    			width: 50px;
    			display: block;
			}
		</style>
		
			<div class="base">
			
			<div class="nav-top">
				<div class="_lable">
					<ul>
					<!--<li><span class="play3" onclick="addTab('98091080','标签库','../hbapp/dispatch.jsp?targetUrl=http://10.25.124.112:8080/COC/ci/ciIndexAction!labelIndex.ai2do')">标签库</span></li>  -->
					<li><a class="play3" href="../hbapp/dispatch_locat.jsp?menuid=98091080&targetUrl=http://10.25.124.112:8080/COC/ci/ciIndexAction!labelIndex.ai2do" target="_blank">标签库</a></li>	
						<!--<li><span class="play3" onclick="addTab('98091240','知识库','../hbapp/app/yx_redirect.jsp')">知识库</span></li>-->
						<li><span class="play3" onclick="addTab('98091104','指标库','../hbapp/app/req_redirect.jsp?method=zbInfolistFrame&menuid=98091104')">指标库</span></li>
					    <li><span class="play3" onclick="addTab('382','问题申告','../issue?menuid=382')">问题申告</span></li><li>
					    <li><span class="play3" onclick="addTab('266789980','应用责任人','./applyAbility.ftl')">应用责任人</span></li>
					</ul>
				</div>
				<div class="logo_quit">
					<div class="quit_left">
						<div class="circls"><img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/admin.png"/></div>						
					</div>
					<p><span class="_bass_uname" title="${user.name}">${user.name}</span></p>
					<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/line_u184.png" />
					<div class="quit_right">
						<span class="icon-swap-right"></span>
						<span ><a href="../outlogin">注销</a></span>
					</div>
				</div>
			</div>
			<div class="con">
				<div class="con-top">
					<ul>
						<li style="display: block;">
							<div class="shuff"  style="background-color: #F6FAFE;">
								<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/sptip1_u9.png" class="u9_img"/>
								<div class="shuff-concent">
									<div class="text1">
										<span style="font-size:30px;">M</span>
										<span style="font-size:24px;">arketing</span>
										<span style="font-size:30px;">M</span>
										<span style="font-size:24px;">anagement</span>										
										<p class="text3">统一营销管理</p>				
									</div>	
									<div class="text2">
										<p><span>以资费和营销案的申请和审批管理为核心，通过整合营销域多个</span></p>
										<p><span>业务支撑系统，完成营销活动信息的跨平台</span></p>
										<!--<p><span>自动流转、快速部署及跟踪评估</span></p>-->
									</div>									
									
									
								</div>
								<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/sptip0_u7.png" class="u7_img"/>
								
							</div>
							
						</li>
						<li style="">
							<div class="shuff" >
								<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/sptip1_u9.png" class="u9_img"/>
								<div class="shuff-concent">
									<div class="text1">
										<span style="font-size:30px;">E</span>
										<span style="font-size:24px;">fficient</span>
										<span style="font-size:30px;">O</span>
										<span style="font-size:24px;">perator</span>										
										<p class="text3"  style="">高效4G运营</p>				
									</div>	
									<div class="text2">
										<p><span>流量、语音、短信全国使用，随心选择，搭配使用更实惠</span></p>
										<p><span>主套餐流量不够用了,加个流量可选包吧。</span></p>
									</div>									
									
									
								</div>
								<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/4g3.png"  class="g4_img"/>
								
							</div>
						</li>
						<li style="">
							<div class="shuff">
								<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/sptip1_u9.png" class="u9_img"/>
								<div class="shuff-concent">
									<div class="text1">
									<span style="font-size:30px;">F</span>
										<span style="font-size:24px;">astest</span>
										<span style="font-size:30px;">S</span>
										<span style="font-size:24px;">peed</span>									
										<p class="text3"  style="">超快网速宽带</p>				
									</div>	
									<div class="text2">
										<p><span>通过光纤网络向您提供宽带服务满足全家高速上网，高速购物</span></p>
										<p><span>畅快网络，资费更低，极速光纤全家共享</span></p>
									</div>									
									
									
								</div>
								<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/bl4.png" class="b16_img"/>
								
							</div>
						</li>
						
					</ul>
					<div class="icon">
									<ul>
										<li onclick=" roller()"></li>
										<li onclick=" roller()"></li>
										<li onclick=" roller()"></li>
									</ul>
					   </div>
				</div>
				<div class="search">
					<div class="_search">
					 <div class="_search-text" >
					  	<span style="font-family:'MicrosoftYaHei', 'Microsoft YaHei';">经分</span>
					 	<span style="font-family:'ArialMT', 'Arial';">BASS</span>
					 </div>				
					 <input type="text" id="txtSearch" placeholder="热门搜索：累计电信 月联通4G" class="text-input"/>
				     <span class=" icon-search" id="btnSearch" style="cursor: pointer;"></span>
					</div>
					<div style="margin-top: 10px;"><span style="font-size:12px;">建议使用Firefox，Chrome，IE10+浏览器</span></div>
				</div>
				<div class="con-bottom">
					<div class="notice" style="margin-left: 0.7%;">
						<div class="title">
							<div class="model">
								<div class="model-name"><span class="icon-star-on"></span> <span class="play2">公告</span></div>
								<div class="arr" style="display:inline-block;cursor:pointer;" onclick="addTab('noticeMenu','公告信息','../NoticeCenter/noticeMenu')"><span style="font-size:11px;" class="icon-arrow-right"><nobr>更多</nobr></span></div>
							</div>
							<div class="cont hot-cont">
								<ul id="TopThreeNewsUl">
									<#list TopThreeNews as news>
										<#if (news_index<7)>
											<li><div class="cis"></div><span class="play1">
												<a  href="javascript:;" onclick="openDiv('${news.newsmsg?trim}',$(this));" title="${news.newstitle}">
													${news.newsdate?date("yyyy-MM-dd")}&nbsp;&nbsp;
													<#if (news.newstitle?length>16)>
														${news.newstitle?replace(news.newstitle?substring(16,news.newstitle?length),"....")}
													<#else>
														${news.newstitle}
													</#if>
												</a></span>
											</li>
										</#if>
									</#list>
								</ul>
							</div>
						</div>
					</div>
					<div class="notice" style="margin: 0 0.7%;">
						<div class="title">
							<div class="model">
								<div class="model-name"><span class="icon-star-on"></span> <span class="play2">热门KPI</span></div>
								<div class="arr" style="display:inline-block;cursor:pointer;" onclick="addTab('TopKpi','热门kpi','../TopkpiCenter/TopKpi')"><span style="font-size: 11px;" class="icon-arrow-right"><nobr>更多</nobr></span></div>
							</div>
							<div class="cont hot-cont">
								<ul>
								<#list TopKpi as kpi>
										<#if (kpi_index<7)>
											<li><div class="cis"></div><span class="play1" style="width: 80%;display:inline-block;text-align: left;">
												<span title="${kpi.kpiname}">
													<#if (kpi.kpiname?length>16)>
														${kpi.kpiname?replace(kpi.kpiname?substring(16,kpi.kpiname?length),"....")}
													<#else>
														${kpi.kpiname}
													</#if>
												</span></span><span class="play1">${kpi.ct}</span>
											</li>
										</#if>
									</#list>
								</ul>
							</div>
						</div>
					</div>
					<div class="notice">
						<div class="title">
							<div class="model">
								<div class="model-name"><span class="icon-star-on"></span> <span class="play2">最新上线</span></div>
								<div class="arr" style="display:inline-block;cursor:pointer;" onclick="addTab('onlineMenu','最新上线','../LastestOnline/LastestOnlineMenu')"><span style="font-size: 11px;" class="icon-arrow-right"><nobr>更多</nobr></span></div>
							</div>
							<div class="cont hot-cont">
								<ul>
									<#list lastestOnlineReport as online>
										<#if (online_index<7)>
											<li><div class="cis"></div><span class="play1">
												${online.dt}&nbsp;&nbsp;
												<a href="javascript:;" onclick="addTab('online${online.id}','${online.name}','../report/${online.id}')" title="${online.desc}">
													<#if (online.name?length>16)>
														${online.name?replace(online.name?substring(16,online.name?length),"....")}
													<#else>
														${online.name}
													</#if>
												</a>
											</span></li>
										</#if>
									</#list>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery-1.11.3.min.js"></script>
<script type="text/javascript">

	function openDiv(msg,aTarget){
		if(aTarget.next('span').length > 0){
			aTarget.next('span').remove();
		}else{
			aTarget.parents("#TopThreeNewsUl").find("span.topThreeNewsSpan").remove();
			aTarget.after("<span class='topThreeNewsSpan' style='color:black;display:block;width:90%;text-align:left; white-space: pre-wrap;'>"+msg+"</span>");
		}
	}
	
	$(document).ready(function(){
	   $("#btnSearch").on("click",function(){
	      var txt = $("#txtSearch").val();
	      if(txt==""||txt.trim()=="")
	      {
	        alert("请输入搜索内容后进行搜索!");
	        return;
	      }
	      var url = "${mvcPath}/hbapp/bir/search.jsp?kw="+txt;
	      window.parent.addTab('s1999','经分搜索',url);
	   }); 
	})
</script>
