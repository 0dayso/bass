<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>湖北移动经营分析系统</title>
		<link rel="Shortcut Icon" type="images/x-icon" href="${mvcPath}/hb-bass-frame/images/he.ico" />
		<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
		<!--<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/main.css" />
		<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/bootstrap/css/bootstrap.min.css" />-->
		<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/index.css" />
		<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
	   <!--	<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/index.js"></script>-->
		<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/main.js"></script>
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
	</head>
	<body>
	<div id="base">

	<!--letf menu start-->
	<div class="nav-left menu">
				<div id="l100" class="l100">
		         <div class="l101">
			        <img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/u348.png" class="img"/>
			        <span>湖北移动经分系统</span>
		        </div>
		         <div class="l105 off" style="margin-left: 85%;">
        	<span class="icon-swap-left" style="margin-left:0px;margin-top: 0px;font-size: 10px;position: absolute;right: 7%;"></span>        	
           </div>
                <div id="l101" class="l102 menu">
        	    <ul></ul>
				</div>
      
                <div class="l103" >
        	<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/zhangfen.png" class="u361_img"/>
        </div>
        <div class="l104">            
  
             <span class=" icon-cellphone"></span>   
        	<span style="font-family:'MicrosoftYaHei', 'Microsoft YaHei';font-size: 12px;">热线电话:</span>
        	<span style="font-family:'ArialMT', 'Arial';font-size: 12px;">15827475854</span>
        </div>
	</div>
	<div class="pushoff"  style="display:none;">
					<div class="l11">
			           <img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/u348.png" class="img"/>
		            </div>
		            <div class="l105 up" style="margin-left: 16px;">
		            	<span class="icon-swap-right" style="margin-left: 0px;margin-top: 0px;font-size: 10px;"></span>
		            </div>
		            <div class="l12">
		            	<ul>
		            		<li><span class="icon-flow"></span>
		            		<li><span class="icon-data-chart4"></span>
		            		<li><span class="icon-shopping"></span>
		            		<li><span class="icon-api2"></span>
		            		<li><span class="icon-data-chart1"></span>
		            		<li><span class="icon-lock"></span>
		            		<li><span class="icon-group"></span>
		            		<li><span class="icon-data-chart2"></span>
		            		<li><span class="icon-setting"></span>
		            		<li><span class="icon-time"></span>	
		            		<li><span class="icon-table"></span>
		            	</ul>
		            </div>
		            
				</div>
	
		
	</div>
	<!--letf menu end-->
	
    	
    <div id="r100" >
    	<!--kpi top start-->
		<div id="r101" style="display:none;">
			<div id="r1010" >
				<ul style="margin-bottom: -1px;padding-left:12px;font-size:0; padding-top: 9px;">
					<!--<li class="menu-first">
						<div style="width:100%; height:3px; background-color:#4BB901"></div>
						<div style="margin: 0 8px;">
							<a>综合市场分析</a>
                         	<span class="icon-error"></span>
						</div>
					</li>-->
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
		<!--kpi top end-->
		
		<div id="myTabPanel">
			<div id="main_index" style="width: 80%;position: absolute;left:16%;z-index=-1;"></div>
		</div>
		
		
	</div>
	</div>
	<script>
		$("#main_index").load('${mvcPath}/HBBassFrame/main');
	    var icons=["icon-flow","icon-data-chart4","icon-shopping ","icon-api2","icon-data-chart1","icon-lock","icon-group ","icon-data-chart2","icon-setting","icon-time ","icon-table"];
        var icon2=["icon-document","icon-computer","icon-api2","icon-data-chart1","icon-data-chart2","icon-data-chart3","icon-data-chart4","icon-database","icon-edit","icon-email",
        "icon-empower","icon-enlarge","icon-error","icon-export icon-flow","icon-folder-open","icon-folder","icon-forbidden","icon-group",
        "icon-heart-on","icon-help","icon-home","icon-image","icon-menu-card","icon-menu-list","icon-minus","icon-move-to","icon-position",
        "icon-recommit","icon-setting","icon-restart","icon-share","icon-shopping","icon-star-on","icon-sum","icon-table","icon-user","icon-time","icon-calendar","icon-cellphone"]
	    $(document).ready(function(){
		   	var menus=${menus};
		   	html="";
		   	for (var i = 0; i<menus.length; i++) {
		   		html=html+creaePmenu(menus[i],i);
		   	}
	
	   		$("#l101 ul").html(html);
	   			//侧菜单栏展开
	             showChildrenMenus();
	             //点击打开新的Tab
	             openNewTab();  
	             	        
	   });


	function creaePmenu(parentMenu,i){
			var pHtml = "<li><span class='"+icons[i]+"'></span><span class='play'>"+parentMenu.name+"</span><img src=' ${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/u297.png' class='u297_img'/>";
			if(parentMenu.children!=null){
				pHtml = pHtml+createChildMenu(parentMenu.children);
			}
				 pHtml = pHtml+"</li>";
			return pHtml;
	}
		           
	   function createChildMenu(childmenus){
	   		var childhtml = "<div  class='sub-menu' style='display:none;'>";
	   		for(var m = 0;m<childmenus.length;m++){
	   			if(m==0){
	  				childhtml+="<ul style='float:left'>";
	 			}else if(m%10==0){
	    			childhtml=childhtml+"</ul><ul style='float:left'>";
				}
	   			childhtml+=createli(childmenus[m].id,childmenus[m].file,childmenus[m].name,m);
	   		}
	   		childhtml+="</ul></div>";
	   		
	   		return childhtml;
	   }
	   
	   	function createli(menuid,url,name,m){
	   		//报表开发工具不拼接menuid，拼接会导致报表开发页面打不开
	   		if(url!=null && url.length >0 && url.indexOf('/ve/ide')<0){
	   			if(url.indexOf('?')<0){
					url = url+'?menuid='+menuid;
				}else{
					url = url+'&menuid='+menuid;
				}
	   		}
	   	
	   		return "<li data-index='"+menuid+"' data-url='"+url+"'><span class='"+icon2[m]+"'></span><a href='#'><span class='play'>"+name+"</span><a/></li>";
	   	}
   
	</script>
		
	</body>
</html>
