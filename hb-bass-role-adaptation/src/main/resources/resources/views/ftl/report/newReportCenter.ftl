        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>报表中心</title>
			<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
			<link href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/report.css" type="text/css" rel="stylesheet" />
			<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
			<script type="text/javascript">
			//分页
			function paging(orderByStr,nameLike,isKeyWord,pageNumStr){
			  var meId = menuid;
			  var orderByStr=orderByStr;
		      var nameLike=nameLike;
		      var isKeyWord=isKeyWord;
		      var pageNumStr=pageNumStr;
			   $.ajax({
		        url: '${mvcPath}/reportCenter/getReportList',
		        type: "POST",
		        async: false,
		        dataType: 'json',
		        data: {
		            menuId: meId,
		            orderByStr:orderByStr,
		            nameLike:nameLike,
		            isKeyWord:isKeyWord,
		            pageNumStr:pageNumStr
		        },
		        success: function(data) {       
		         if(data!=null&&data!=""&& data != undefined){
		           var likeList=eval(data);
		           var count,optionHtml;
		           count=likeList[0].count;
	                 if((count/6)<1){
	                    count=1;
	                  }else{
	                           if((count%6)>0){
	                            count=Math.ceil(count/6);
	                           }else{
	                            count=count/6;
	                            }
	                   }
	                  optionHtml="<span style='color:#fcf8e3;font-size: 13px;right: 0%;position: absolute;'><span>"+likeList[0].count+"条信息&nbsp</span>";
	                  optionHtml+="<span>共"+count+"页&nbsp</span>";
	                  optionHtml+="<span style='color:#09f83e;cursor: pointer;' onclick='upPage()'>上一页</span><span style='color: #09f83e;cursor: pointer;' onclick='downPage()'>&nbsp&nbsp下一页&nbsp&nbsp</span><span>第<select id='pageNumStr'  onchange='refreshForm()'>";
	                  optionHtml+="<option value='1' selected='selected'>1</option>";	                 
	                  for(var j=2;j<=count;j++){	                        
	                      optionHtml+="<option value='"+j+"'>"+j+"</option>";
	                     }
	                  optionHtml+="</select>页</span></span>";
	              }else{
	                 optionHtml="<span style='color:#fcf8e3;;font-size: 13px;right: 0%;position: absolute;'><span>0条信息&nbsp</span>";
	                 optionHtml+="<span>共0页&nbsp</span><span>第<select id='pageNumStr'  onchange='refreshForm()'>";
	                 optionHtml+="<option value='1' selected='selected'>0</option>";	                 
	                 optionHtml+="</select>页</span></span>";
	                 }
	                $("#page_Num").html(optionHtml);
		        },		      
			  });
			}
			function btnMenuSearch(){
				 var MenuSearch = $("#MenuSearch").val();
				 $.ajax({
			        url: '${mvcPath}/reportCenter/MenuSearch',
			        type: "GET",
			        dataType: 'json',
			        data: {name: MenuSearch},
			        success: function(data) {
			        	var obj = eval(data);
			        	repCenter(obj);
			        },
			    });
			}
			
			function initReportTable(reportList){
				var reportHtml = '';
				for(var i=0; i<reportList.length; i++){
					var childList = reportList[i].child;
					reportHtml += "<tr onclick='tiger("+(i)+")' class='Table_Tr' style='cursor: pointer;background-color:#DDF1F9;'>"
						+ "<td style='text-align: left;background-color:#EBF5F9;'>"
							+ "<span class='icon-add'style='display: inline-block;width: 15px;height: 15px;background-color: #C8E8FB;border-radius: 50%;text-align: center;line-height: 15px;color: #fff;'>"
							+ "</span><span style='color: #666666;font-size:12px;'>" + reportList[i].name + "（共" + reportList[i].num + "张）</span>"
						+ "</td>"
						+ "<td style='background-color:#EBF5F9;'></td>"
						+ "<td style='background-color:#EBF5F9;'></td>"
						+ "<td style='background-color:#EBF5F9;'></td>"
						+ "<td style='background-color:#EBF5F9;'></td>"
					+ "</tr>"
				for(var j=0; j < childList.length; j++){
					reportHtml += "<tr class='a"+(i)+" on' style='display:none;'>";
					reportHtml += "<td class='tl pdl5'><a title='" + childList[j].rname + "'  onclick=\"openReport('" + childList[j].rid + "','" + childList[j].rname + "','" + childList[j].ruri + "')\">" + childList[j].rname + "</a></td>";
					reportHtml += "<td class='rep-name' title='" + childList[j].rdesc + "'>" + childList[j].rdesc + "</td>";
					reportHtml += "<td>" + childList[j].lastupd + "</td>";
					var cycle="";
					if(childList[j].cycle=='day'){
						cycle="日报表";
					}else if(childList[j].cycle=='month'){
						cycle="月报表";
					}
					reportHtml += "<td>" + cycle + "</td>";
					if(parseInt(childList[j].favsnum)>0){
						reportHtml += "<td>已收藏</td>";
					}else{
						reportHtml += "<td><a href='JavaScript:' onclick=\"addFavorite('" + childList[j].rid + "')\"><div class=\"coll-col\">收藏</div></a></td>";
					}
					reportHtml += "</tr>";
				 }
				}
				$('#repBody').html(reportHtml);
				$(".spread").html("全部展开");
				$(".Table_Tr").click(function(){
				    if( $(this).children().children().first().attr("class")=="icon-add"){  
				    	$(this).children().children().first().attr("class","icon-lessen");
				    }else{
						$(this).children().children().first().attr("class","icon-add");
				    }
			    });
			}
			function tiger(a){
				if($(".a"+(a)+"").css("display")=="none"){
					$(".a"+(a)+"").css("display","");
				}else{
					$(".a"+(a)+"").css("display","none");
				}
			}
			function openReport(id,name, uri){
				id = _trim(id);
				name = _trim(name);
				uri = _trim(uri);
				window.parent.addTab(id,name, uri);
			}
	
	function _trim(str){
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}
			
			function addFavorite(rid){
				$.ajax({
			        url: '${mvcPath}/myCollect/addCollect',
			        type: "POST",
			        async: false,
			        dataType: 'json',
			        data: {
			            rid: rid,
			            menuId: ${menuId}
			        },
			        success: function(data, textStatus) {
			            if (data.flag) {
			                alert(data.msg);
			                queryFormList();
			            } else {
			                alert(data.msg);
			            }
			        },
			    });
			}
			
			var tabFlag;
			//相关性/最多游览/最新上线
			function changeFormData(obj) {
				var orderByStr = obj;
				var nameLike = $.trim($("#nameLike").val());
				var isKeyWord = "";
				var pageNumStr = $.trim($("#pageNumStr option:selected").val());
				var meId = menuid;
				$.ajax({
					url: '${mvcPath}/reportCenter/getReportList',
					type: "POST",
					async: false,
					dataType: 'json',
					data: {
						menuId: meId,
						orderByStr: orderByStr,
						nameLike: nameLike,
						isKeyWord: isKeyWord,
						pageNumStr: pageNumStr
					},
					success: function(data) {
						var likeList = eval(data);
						initTabList(likeList);
					},
				});
				tabFlag = obj;
				return tabFlag;
			}
			
			
			function  initTabList(likeList){		
		        var likelyHtml="";
		        for(var i=0;i<likeList.length;i++){
		        	likelyHtml +="<span class='repport_img1'><img src='${mvcPath}/hb-bass-frame/views/ftl/index2/img/report/u2588.png' width='50px' height='50px'/></span><div class='excelIcon'><div class='excel'><span class='excelTitle boldTitle'>";
		        	likelyHtml+="<a onclick=\"openReport('" + likeList[i].rid + "','" + likeList[i].name + "','" + likeList[i].uri + "')\" title='"+likeList[i].name+"'>"+likeList[i].name+"</a></span><span class='excelTitle'>("+likeList[i].num+"人浏览)&nbsp&nbsp上线时间："+likeList[i].create_dt+"</span></div>";	
	                likelyHtml +="<div class='excel'><span class='excelTitle text_over' title='"+likeList[i].desc+"'>"+likeList[i].desc+"</span><span class='excelTitle collect'>";
	                if(parseInt(likeList[i].favsnum)>0){
						likelyHtml += "<span>已收藏</span></span></div>";
					}else{
						likelyHtml+="<a href=\"#\" onclick=\"addFavorite('" + likeList[i].reportid + "')\"><span class='coll-col'>加入收藏</span></a></span></div>";	
					} 
					     if(likeList[i].keywords!=null && likeList[i].keywords!="" &&likeList[0].keywords!= undefined){
	                    likelyHtml +="<div class='excel'><span class='excelTitle'>关键字:"+likeList[i].keywords+"</span></div></div>";}
	                    else{
	                     likelyHtml +="<div class='excel'><span class='excelTitle'>关键字:</span></div></div>";
	                        }
	                }
		            $('#formData').html(likelyHtml);
			}
			
			//分页刷新
	            function refreshForm(){
	                str=tabFlag;
	               changeFormData(str);
	              }

            //上一页
             function upPage() {       
			  var orderByStr=tabFlag;
		      var nameLike=$.trim($("#nameLike").val());
		      var isKeyWord="";
		      var pageNumStr=$("#pageNumStr option:selected").val();
		        if (pageNumStr - 1 > 1) {
                 pageNumStr -= 1;
                 } else {
                 pageNumStr = 1;        
                   }
			   $.ajax({
		        url: '${mvcPath}/reportCenter/getReportList',
		        type: "POST",
		        async: false,
		        dataType: 'json',
		        data: {
		            menuId: ${menuId},
		            orderByStr:orderByStr,
		            nameLike:nameLike,
		            isKeyWord:isKeyWord,
		            pageNumStr:pageNumStr
		        },
		        success: function(data) {       
		         var likeList=eval(data);
		          document.getElementById("pageNumStr").value=pageNumStr;		         
		         initTabList(likeList);
		          refreshForm();
		        },
		       });
            }

            //下一页
           function downPage() {
            var orderByStr=tabFlag;
            var pageNumStr=$.trim($("#pageNumStr option:selected").val());
            var countPage=$.trim($("#pageNumStr option:last").val());
             if ((Number(pageNumStr) + 1) >= Number(countPage)) {
                pageNumStr = countPage;
               } else {
                pageNumStr=String(Number(pageNumStr)+1);
              }
               var nameLike=$.trim($("#nameLike").val());
		      var isKeyWord="";
               $.ajax({
		        url: '${mvcPath}/reportCenter/getReportList',
		        type: "POST",
		        async: false,
		        dataType: 'json',
		        data: {
		            menuId: ${menuId},
		            orderByStr:orderByStr,
		            nameLike:nameLike,
		            isKeyWord:isKeyWord,
		            pageNumStr:pageNumStr
		        },
		        success: function(data) {       
		         var likeList=eval(data);
		          document.getElementById("pageNumStr").value=pageNumStr;		         
		         initTabList(likeList);
		          refreshForm();
		        },
		       });
            }
            //搜索
           function queryFormList(){
				if($(".views").html()=="详细视图" ){
				var reportName = $.trim($("#nameLike").val());
				$.ajax({
			        url: '${mvcPath}/reportCenter/getReportInfo',
			        type: "POST",
			        async: false,
			        dataType: 'json',
			        data: {
			            menuId:menuid,
			            reportName: reportName
			        },
			        success: function(data) {
			        	var reportInfo = eval(data);
			        	initReportTable(reportInfo);
			        },
			      });
				}else if($(".views").html()=="全景视图" ){
				 var nameLike =$.trim($("#nameLike").val());
				 var orderByStr=tabFlag;		        
		         var isKeyWord="";
		         var pageNumStr=$.trim($("#pageNumStr option:selected").val());
				$.ajax({
			       url: '${mvcPath}/reportCenter/getReportList',
			        type: "POST",
			        async: false,
			        dataType: 'json',
			        data: {
			        menuId: menuid,
		            orderByStr:orderByStr,
		            nameLike:nameLike,
		            isKeyWord:isKeyWord,
		            pageNumStr:pageNumStr
			        },
			        success: function(data) {
			        	 var likeList=eval(data);
		                 initTabList(likeList);
		           paging(orderByStr,nameLike,isKeyWord,pageNumStr);
			         },
			      });
			    }
			}	
			
				var menuid = ${menuId};
			function repCenter(obj) {
			var orderByStr =tabFlag;
			var nameLike=$.trim($("nameLike").val());
			var isKeyWord='';
			var pageNumStr='1';
				menuid = obj.id;
				var _text = obj.innerText;
				$("#div_6").text(_text);
				if ($(".views").html() == "详细视图") {
					repCenterAjax(menuid);
				} else {
					str = tabFlag;
					changeFormData(str);
					paging(orderByStr,nameLike,isKeyWord,pageNumStr);
					
				}		
			};
			function repCenterAjax(menuid){
				$.ajax({
						url: '${mvcPath}/reportCenter/getRepCenter',
						type: "GET",
						dataType: 'json',
						data: {
							menuId: menuid,
						},
						success: function(data) {
							var reportInfo = eval(data);
							initReportTable(reportInfo);
						},
					});
			}
			function veiws_switch(obj) {
				var _text = $.trim(obj.innerText);
				if (_text == "全景视图") {
					$(".views").html("详细视图");
					$(".spread").css("visibility","visible");
					$("#div_2 table").css("display", "");
					$("#page_Num").css("display", "none");
					$("#div_2 .gridSubContent").css("display", "none");
					repCenterAjax(menuid);
				} else {
					var num = '';
					$(".views").html("全景视图");
					$(".spread").css("visibility","hidden");
					$("#div_2 table").css("display", "none");
					$("#page_Num").css("display", "block");
					$("#div_2 .gridSubContent").css("display", "block");
					if (_text == "详细视图") {
						changeFormData(num);
					} else if (_text == "相关性") {
						changeFormData('');
					} else if (_text == "|最多浏览") {
						changeFormData('num');
					}else if (_text == "|最新上线"){
						changeFormData('create_dt');
					}
				}
			}
			function spread_all(){
			    var _text=$(".spread").html();
			    _text = _trim(_text);
			    if(_text=="全部展开"){
			       $(".spread").html("全部收起");
			       $(".on").css("display","");
			       $(".icon-add").removeClass("icon-add").addClass("icon-lessen");
			    }
			    else{
			     $(".spread").html("全部展开");
			       $(".on").css("display","none");
			       $(".icon-lessen").removeClass("icon-lessen").addClass("icon-add");
			    }		    
			}
			
			$(function(){
				var reportList = ${reportList};
				initReportTable(reportList);
				$(".color1").click(function(){
			      $(this).css("color","#3AA0DA").siblings().css("color","#999999");
			      document.getElementById("pageNumStr").value="1";
			      changeFormData(tabFlag)
			    });
			    paging('','','','1')
			    $(".rep_text").click(function(){
			      $(this).css("color","#3AA0DA").siblings().css("color","#999999");
			      
			    });
			    
			    $(".rep_text").each(function(){
			    	if($(this).text()==$("#div_6").text()){
			    		$(this).css("color","#3AA0DA")
			    	}
			    });
			   
			});
			
			</script>
	
		</head>
		<body style="background-color: rgba(244, 244, 244, 1);">
			<div id="div_9" style="margin-left: 1%;margin-top: 1%;width: 20%;border-radius: 5px;height: 79%;">
				<span id="div_3"> 报表中心 </span>
				<div id="div_4" style="width:100%;">
					<img id="u1686_img" class="img " src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/u598.png" style="width:100%;">
				</div>
				<!-- <div id="div-5"  style="padding-left:11px;padding-top:60px;"> 
				  <input id="MenuSearch" class="1_input text_input" placeholder="请输入您要搜索的内容" style="width:180px">
				  <span class="icon-search"  style="position:absolute;left:160px;top:68px;cursor: pointer;color: #ccc;" onclick="btnMenuSearch()"></span>
				</div> -->
				<span id="div_1">
					<ul style="list-style-type: none;margin-top: -53%;" id="menuTitleList">
							<li id="collect" class="text" onclick="window.parent.addTab('myCollect','我的收藏','../myCollect/index/${menuId?trim}')" style="line-height:28px;padding-left:30px;cursor:pointer;">我的收藏</li>
					   <#list reportMenu as rep>
		                   <li id="${rep.id}" class="text rep_text" onclick="repCenter(this)" style="line-height:28px;padding-left:30px;cursor:pointer;height:28px;">${rep.name}</li>
		               </#list>
					</ul> </span>
			</div>
	
			<div id="div_10" style="width: 78%;margin-left: 3%;margin-top: 1%;border-radius: 5px;">
				<div style="height: 50px;line-height: 50px;border-bottom: 0px solid #E8E8E8;padding-left: 2%;">
					<span id="div_6" style="font-size: 16px;position: static;display:inline-block;width: 15%;">${title}</span>
					
				<div class="ser-name-box">
					<input class="ser-inp" placeholder="请输入您要搜索的内容" id="nameLike">
					<span class="icon-search ser-btn" onclick="queryFormList()"></span>
				</div>
		
					<div id="div_8" style="display: inline-block;position: static;float: right;margin-right: 3%;margin-top: 1%;font-size: 12px;">
					<span style="color: #999999;cursor:pointer;" class="spread color1" onclick="spread_all()">全部展开 </span>
					<span style="color: #999999;cursor:pointer;" data_id="1" class="views color1" onclick="veiws_switch(this)">详细视图</span>
					<span style="color: #999999;">&nbsp;&nbsp;排列：</span> 
					<span style="color: #999999;cursor:pointer;" onclick="veiws_switch(this)" class="color1 like">相关性</span>
				    <span style="color: #999999;cursor:pointer;"  onclick="veiws_switch(this)" class="color1">|最多浏览</span>
					<span style="color: #999999;cursor:pointer;" onclick="veiws_switch(this)" class="color1">|最新上线</span>
				</div>
				<div id="div_2">
					<table class="table" >
						<tr class="tr_title">
							<th class="u1_th" width="30%">
								名称
							</th>
							<th class='u1_th'  width="40%">
								描述
							</th>
							<th class='u1_th'  width="10%">
								更新时间
							</th>
							<th class='u1_th'  width="10%">
								报表类型
							</th>
							<th class='u1_th' width="10%">
								操作
							</th>
						</tr>

							<tbody id="repBody"  >
							
							</tbody>
						
					</table>
			     <span id="page_Num" style="position: absolute;margin-bottom: 73%;display:none;top: -0.1%;width: 100%;height: 30px;line-height: 30px;border: 1px solid #ccc;background-color:rgba(43, 164, 224, 0.94);">
	            </span>
		         <div id="formData" class="gridSubContent" style="display:none">
				 </div>	
				</div>
				</div>
			</div>

			<div class="div_11" style="margin-left: 1%;width: 20%;top: 82%;">
				<span id="div_12"> 热门推荐 </span>
				<span id="div_13" style="width:100%;"> <img id="u1686_img" class="img "
						src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/u598.png" style="width:100%;"> </span>
				<div class="div_14" style="top: 70px;left:10%;">
					<div class="div_15">
						 收入类
					</div>
					<div class="div_16 prog">
						<div class=" prog-bar" style="width:88%;"><span class="aa" style="color: white;width:88%;">88%</span></div>
					</div>
				</div>
	
				<div class="div_14" style="top: 100px;left:10%;">
					<div class="div_15">
						 用户类
					</div>
					<div class="div_16 prog">
						<div class=" prog-bar" style="width:72%;"><span class="aa" style="color: white;width:72%;">72%</span></div>
					</div>
				</div>
	
				<div class="div_14" style="top: 130px;left:10%;">
					<div class="div_15">
						 业务类
					</div>
					<div class="div_16 prog">
						<div class=" prog-bar" style="width:57%;"><span class="aa" style="color: white;width:57%;">57%</span></div>
					</div>
				</div>
	
				<div class="div_14" style="top: 160px;left:10%;">
					<div class="div_15">
						 在网情况
					</div>
					<div class="div_16 prog">
						<div class=" prog-bar" style="width:46%;"><span class="aa" style="color: white;">46%</span></div>
					</div>
				</div>
	
				<div class="div_14" style="top: 190px;left:10%;">
					<div class="div_15">
						 在网情况
					</div>
					<div class="div_16 prog">
						<div class=" prog-bar" style="width:22%;"><span class="aa" style="color: white;width:22%;">22%</span></div>
					</div>
				</div>
		</body>
	</html>