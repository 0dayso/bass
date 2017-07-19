<html> 
<head> 
<title>kpi指标计算</title> 
<script type="text/javascript" src="/hb-bass-navigation/resources/lib/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<style type="text/css">
.warning{
	color:red;
	font-size: 11px;
}
</style>
<script type="text/javascript">
		$(function(){
			$("#checkRefushKpi").click(function(){
				$("p").html("");
				var beginDate = $("#beginDate").val();
				var endDate = $("#endDate").val();
				var reg = /^\d{4}((0[1-9])|(1[0-2]))((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1])){0,1}$/;
				if(!$("#menuId").val()){
					$("#menuIdMsg").html("指标id不能为空");
					return;
				}
				if(!beginDate && !endDate){
					$("#endDateMsg").html("请至少填写一个时间");
					return;
				}
				if(beginDate){
					if(!reg.test(beginDate)){
						$("#beginDateMsg").html("请填写正确格式的开始时间");
	                    return;
	           		}
				}
				if(endDate){
					if(!reg.test(endDate)){
						$("#endDateMsg").html("请填写正确格式的结束时间");
	                    return;
	           		}
				}
				if(beginDate && endDate){
					if(beginDate.length != endDate.length){
	                    $("#endDateMsg").html("请填写格式相同的开始时间与结束时间");
	                    return;
	              	}else if(!(parseInt(beginDate) < parseInt(endDate))){
	                    $("#endDateMsg").html("开始时间必须小于结束时间");
	                    return;
	              	}
				}
				$("#refushKpi").submit();
			});
			$("#state").html("");
			var flag = $("#flag").val();
			if(flag == 'true'){
				$("#state").html("刷新成功！");
			}else if(flag == 'false'){
				$("#state").html("刷新失败！");
			}
		})
</script>
</head>
<body>
	<form class="form-horizontal" action="${mvcPath}/kpiCalculate/refreshDuring" method="POST" id="refushKpi" role="form">
		<input value="${flag}" type="hidden" id="flag"/>
		<div class="modal-body" style="width: 100%; height:355px; overflow-y:auto;">
           <div class="form-group">
                <!-- Text input-->
               <label class="col-sm-2 control-label titWid"><span style="color:red;">*</span>指标id</label>
               <div class="col-sm-4 conWid">
                   <input name="menuId" id="menuId" class="form-control" type="text">
                   <p id="menuIdMsg" class="warning"></p>
                </div>
           </div>
           <div class="form-group">
               <label class="col-sm-2 control-label titWid" for="input01"><span style="color:red;">*</span>地市</label>
               <div class="col-sm-4 conWid">
                   <select id="dimVal" name="dimVal" class="form-control">
						<option value="HB" selected="selected">全省</option>
						<option value="HB.WH">武汉</option>
						<option value="HB.HS">黄石</option>
						<option value="HB.EZ">鄂州</option>
						<option value="HB.YC">宜昌</option>
						<option value="HB.ES">恩施</option>
						<option value="HB.SY">十堰</option>
						<option value="HB.XF">襄阳</option>
						<option value="HB.JH">江汉</option>
						<option value="HB.XN">咸宁</option>
						<option value="HB.JZ">荆州</option>
						<option value="HB.JM">荆门</option>
						<option value="HB.SZ">随州</option>
						<option value="HB.HG">黄冈</option>
						<option value="HB.XG">孝感</option>
						<option value="HB.QJ">潜江</option>
						<option value="HB.TM">天门</option>
					</select>
                   <p id="dimValMsg" class="warning" style="font-size: 5px"></p>
               </div>
           </div>
           <div class="form-group">
               <label class="col-sm-2 control-label titWid">开始时间</label>
               <div class="col-sm-4 conWid">
                   <input id="beginDate" name="beginDate" type="text" class="form-control" maxlength="8" />
                   <p id="beginDateMsg" class="warning"></p>
                </div>
           </div>
           <div class="form-group">
               <label class="col-sm-2 control-label titWid">结束时间</label>
                <div class="col-sm-4 conWid">
                    <input id="endDate" name="endDate" class="form-control" type="text" maxlength="8" />
                    <p id="endDateMsg" class="warning"></p>
                </div>
           </div>
           <div class="form-group">
               <label class="col-sm-2 control-label titWid"></label>
               <div class="col-sm-4 conWid">
                   <button id="checkRefushKpi" class="btn btn-info btn-sm" type="button"/>刷新</button>
                   <span id="state" style="color: red"></span>
                </div>
           </div>
       </div>
	</form>
</body>
</html>