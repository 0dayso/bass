<!DOCTYPE HTML>
<html ng-app ng-cloak>
	<head>
		<meta charset="utf-8">
		<meta name="renderer" content="webkit|ie-comp|ie-stand">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		<meta http-equiv="Cache-Control" content="no-siteapp" />
		<meta name="keywords" content="">
		<meta name="description" content="">
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
		
		<script src="${mvcPath}/resources/lib/underscore/underscore-min.js" type="text/javascript"></script>
		<link href="${mvcPath}/hb-bass-frame/css/H-ui.min.css" rel="stylesheet" type="text/css" />
		<link href="${mvcPath}/hb-bass-frame/css/H-ui.admin.css" rel="stylesheet" type="text/css" />
		<link href="${mvcPath}/resources/lib/iconfont/iconfont.css" rel="stylesheet" type="text/css" />
		<link href="${mvcPath}/resources/lib/font-awesome/font-awesome.min.css" rel="stylesheet" type="text/css" />
		<script src="${mvcPath}/resources/lib/angular/angular.js"></script>
		
		<!-- //使用的h-ui版本有点老,不能直接使用响应式布局,手工临时解决宽度问题 -->
		<style type="text/css">
			.row label{
				width:20%;
			}
			.row div{
				width:75%;
			}
		</style>
		
		<title>系统公告管理</title>
	</head>
	<body ng-controller="noticeController">
		<div class="cl pd-5 bg-1 bk-gray mt-20">
			<div class="text-l"> 
				公告标题
				<input ng-model="query.noticetitle" type="text" class="input-text" style="width:120px" placeholder="公告标题">
				公告内容
				<input ng-model="query.noticemsg" type="text" class="input-text" style="width:160px" placeholder="公告内容">
				公告起止时间
				<input ng-model="query.notice_start_dt" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" ng-blur="query.notice_start_dt=$event.target.value" class="input-text Wdate" style="width:165px;">
				-
				<input ng-model="query.notice_end_dt" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" ng-blur="query.notice_end_dt=$event.target.value" class="input-text Wdate" style="width:165px;">
				<button ng-click="note_query()"  type="submit" class="btn btn-success radius">
					<i class=" icon-search"></i>&nbsp;查询
				</button>
				<button type="submit" class="btn btn-warning radius" ng-click="note_add()">
					<i class=" icon-plus"></i>&nbsp;新增公告
				</button>
			</div>
		</div>
		
		<div class="mt-20">
			<table class="table table-border table-striped table-bordered table-hover table-bg table-sort">
				<thead>
					<tr class="text-c">
						<th width="70">开始时间</th>
						<th width="70">结束时间</th>
						<th width="150">标题</th>
						<th width="200">公告内容</th>
						<th width="30">背景色</th>
						<th width="30">创建人</th>
						<th width="30">状态</th>
						<th width="60">操作</th>
					</tr>
				</thead>
				<tbody>
					<tr class="text-l" ng-repeat = "notice in notices">
						<td width="70">{{notice.notice_start_dt}}</td>
						<td width="70">{{notice.notice_end_dt}}</td>
						<td width="150">{{notice.noticetitle}}</td>
						<td width="200">{{notice.noticemsg}}</td>
						<td width="30">{{notice.extend_color}}</td>
						<td width="30">{{notice.creator}}</td>
						<td width="30" class="text-c">
							<span class="label label-success radius">
								{{notice.status == 0?'未发布':'已发布'}}
							</span>
						</td>
						<td width="60" class="text-c">
						 	<span class="badge" ng-click="note_publish(notice.noticeId)"><i class="icon-minus-sign" title="发布/未发布"></i></span>
							&nbsp;
							<span class="badge" ng-click="note_update(notice.noticeId)"><i class="icon-wrench" title="修改"></i></span>
							&nbsp;
							<span class="badge" ng-click="note_del(notice.noticeId)"><i class="icon-trash" title="删除"></i></span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="page-container" id="noticeInfoPage" style="display:none;">
			<form class="form form-horizontal">
				<div class="row cl">
					<label class="form-label col-xs-4"><span class="c-red">*</span>开始时间：</label>
					<div class="formControls col-xs-8">
						<input ng-model="currentNotice.notice_start_dt" type="text" class="input-text Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" ng-blur="currentNotice.notice_start_dt=$event.target.value">
					</div>
				</div>

				<div class="row cl">
					<label class="form-label col-xs-4"><span class="c-red">*</span>结束时间：</label>
					<div class="formControls col-xs-8">
						<input type="text" ng-model="currentNotice.notice_end_dt" class="input-text Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" ng-blur="currentNotice.notice_end_dt=$event.target.value">
					</div>
				</div>

				<div class="row cl">
					<label class="form-label col-xs-4"><span class="c-red">*</span>公告标题：</label>
					<div class="formControls col-xs-8">
						<input ng-model="currentNotice.noticetitle" type="text" class="input-text">
					</div>
				</div>

				<div class="row cl">
					<label class="form-label col-xs-4"><span class="c-red">*</span>公告内容：</label>
					<div class="formControls col-xs-8">
						<textarea ng-model="currentNotice.noticemsg" class="textarea"></textarea>
					</div>
				</div>
				
				<div class="row cl">
					<label class="form-label col-xs-4"><span class="c-red">*</span>背景色：</label>
					<div class="formControls col-xs-8">
						<input ng-model="currentNotice.extend_color" type="text" class="input-text">
					</div>
				</div>

				<div class="row cl">
					<label class="form-label col-xs-4"><span class="c-red">*</span>发布状态：</label>
					<div class="select-box col-xs-8">
						<select ng-model="currentNotice.status" class="select">
							<option ng-selected="currentNotice.status==0" value="0">未发布</option>
							<option ng-selected="currentNotice.status==1" value="1">已发布</option>
						</select>
					</div>
				</div>
			</form>
		</div>

		
		<script type="text/javascript" src="${mvcPath}/resources/lib/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/lib/layer1.9/layer.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/lib/laypage/laypage.js"></script>
		<script type="text/javascript" src="${mvcPath}/resources/lib/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.js"></script>
		<script type="text/javascript" src="${mvcPath}/hb-bass-frame/js/H-ui.admin.js"></script>
		<script type="text/javascript">
			var rootpath = "../..";//可能是layer1.9框架的原因,不能使用项目绝对路径
			function noticeController($scope,$http){
				var notices = ${notices!default('')};
				if(notices.length){
					$scope.notices = notices;
					$scope.currentNotice = {};
				}else{
					$scope.notices = [];
				}
				
				$scope.query = {
					noticetitle:'',
					noticemsg:'',
					notice_start_dt:'',
					notice_end_dt:''
				}
				
				$scope.note_query = function(){
					$http({
						url:'./query',
						method:'GET',
						params:$scope.query
					}).success(function(notices){
						$scope.notices = notices;
					}).error(function(){
						layer.alert('查询出错');
					});
				}
				
				function validateNoticeInfo(notice){
					var result = true;
					var resultMsg = "";
					if(!notice.notice_start_dt){
						resultMsg += "公告开始时间不可为空;";
						result = false;
					}
					if(!notice.notice_end_dt){
						resultMsg += "公告结束时间不可为空;";
						result = false;
					}
					if(!notice.noticetitle){
						resultMsg += "标题不可为空;";
						result = false;
					}
					if(!notice.noticemsg){
						resultMsg += "公告内容不可为空;";
						result = false;
					}
					if(!notice.extend_color){
						resultMsg += "公告背景色不可为空;";
						result = false;
					}
					if(!notice.status && notice.status != 0){
						resultMsg += "请选择发布状态;";
						result = false;
					}
					layer.alert(resultMsg);
					return result;
				}
				
				function copyNotice(targetnotice,srcnotice){
					if(srcnotice){
						targetnotice.noticeId=srcnotice.noticeId;
						targetnotice.notice_start_dt=srcnotice.notice_start_dt;
						targetnotice.notice_end_dt=srcnotice.notice_end_dt;
						targetnotice.noticetitle=srcnotice.noticetitle;
						targetnotice.noticemsg=srcnotice.noticemsg;
						targetnotice.extend_color=srcnotice.extend_color;
						targetnotice.creator=srcnotice.creator;
						targetnotice.status=parseInt(srcnotice.status);
					}else{
						targetnotice.noticeId='';
						targetnotice.notice_start_dt='';
						targetnotice.notice_end_dt='';
						targetnotice.noticetitle='';
						targetnotice.noticemsg='';
						targetnotice.extend_color='';
						targetnotice.creator='';
						targetnotice.status=1;
					}
				}
				
				$scope.note_add = function(){
					copyNotice($scope.currentNotice);
					
					showNoticeInfoPage('新增公告',function(index){
						if(validateNoticeInfo($scope.currentNotice)){
							$http({
								url:'./add',
								method:'GET',
								params:$scope.currentNotice
							}).success(function(resp){
								if(resp.result == "ok"){
									layer.msg('添加成功',{icon:1,time:1000});
									layer.close(index);
									$scope.note_query();
								}else{
									layer.alert(result.msg);
								}
								
							}).error(function(){
								layer.alert('调用后台服务出错');
							});
						}
					
					});
				}
				
				function showNoticeInfoPage(title,yes_call_back){
					layer.open({
    					type: 1,
    					title:title,
    					area: ['600px', '450px'], 
    					content:$("#noticeInfoPage"),
   						maxmin: true,
   						btns: 2,
   						btn: ['提交', '取消'],
   						yes:function(index){//index用于关闭窗口
   							if(yes_call_back){
   								yes_call_back(index);
   							}
   						}
					});
				}
				
				function findSelectNotice(noticeId){
					return _.find($scope.notices,function(notice){
						return notice.noticeId == noticeId;
					})
				}
				
				$scope.note_publish = function(noticeId){
					var notice = findSelectNotice(noticeId);
					var msg,status;
					if(notice.status == 0){
						msg = "确定要发布该公告吗?";
						status = 1;
					}else{
						msg = "确定要取消发布该公告吗?";
						status = 0;	
					}
					layer.confirm(msg,function(index){
						notice.status = status;
						$http({
							url:'./publish',
							method:'GET',
							params:notice
						}).success(function(resp){
							if(resp.result == "ok"){
								layer.msg('操作成功',{icon:1,time:1000});
							}else{
								layer.alert(result.msg);
							}
						}).error(function(){
							layer.alert('调用后台服务出错');
						});
					});
				}
				$scope.note_update = function(noticeId){
					var selectedNotice = findSelectNotice(noticeId);
					copyNotice($scope.currentNotice,selectedNotice);
					
					showNoticeInfoPage('修改公告',function(index){
						if(validateNoticeInfo($scope.currentNotice)){
							$http({
								url:'./update',
								method:'GET',
								params:$scope.currentNotice
							}).success(function(resp){
								if(resp.result == "ok"){
									copyNotice(selectedNotice,$scope.currentNotice);
									layer.msg('修改成功',{icon:1,time:1000});
									layer.close(index);
								}else{
									layer.alert(result.msg);
								}
							}).error(function(){
								layer.alert('调用后台服务出错');
							});
						}
					});
					
				}
				$scope.note_del = function(noticeId){
					layer.confirm('确认要删除吗？',function(index){
						$http({
							url:'./delete',
							method:'GET',
							params:{noticeId:noticeId}
						}).success(function(resp){
							if(resp.result == "ok"){
								layer.msg('已删除!',{icon:1,time:1000});
								$scope.note_query();
							}else{
								layer.alert(result.msg);
							}
						}).error(function(){
							layer.alert('调用后台服务出错');
						});
					});
				}
			}
		</script>
	</body>
</html>





























