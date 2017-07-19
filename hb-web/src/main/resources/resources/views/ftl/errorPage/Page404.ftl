<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>这个.. 页面没有找到！！！</title>		
		<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
	<style type="text/css">
		*{
			margin: 0;
			padding: 0;
		}
			body{
				background-color: #FFF;
				width: 100%;
				
			}
			p{
				font-family:"微软雅黑";
				font-size: 14px;
                margin: 10px 0px;
                color: #7D7B7C;
			}
			.header{
				width: 80%;
				height: 150px;
				margin: auto;
				position: relative;
			}
			img{
				width: 87px;
                height: 81px;
                position: absolute;
                top: 35%;
                left: 10%;
			}
			.text{
				position: absolute;
				left: 20%;
                 top: 35%; 
			}
			.content{
				width: 63%;
				margin:10px auto;
			}
			.trace{
				color: #FF9900;
				width: 10%;
			}
			.trace:hover{
				cursor: pointer;
				color: #188EEE;
			}
			.error{
				color: #FF9900;
				width: 10%;
			}
			.error:hover{
				cursor: pointer;
				color: #188EEE;
			}
			.footer{
				width: 63%;
				margin: 40px auto;
			}
		</style>
		<script>
			$(function(){
				$(".trace").click(function(){
					if($(".trace_text").css("display")=="none"){
						$(".trace_text").css("display","block");
					}else{
					$(".trace_text").css("display","none");}
				})
				$(".error").click(function(){
					if($(".error_text").css("display")=="none"){
						$(".error_text").css("display","block");
					}else{
					$(".error_text").css("display","none");}
				})
			})
		</script>
	</head>
	<body>
		<div class="header">
			<div style="background-color: #FFF;height: 90%;margin: 2% 10%;">
				<img src="${mvcPath}/hb-bass-frame/views/ftl/index2/img/index/14.png"/>
				<div class="text">
				<p style="font-size: 23px;color: red;">您的访问出错了！</p>
				<p style="font-size: 18px;">请联系管理员解决，热线电话: 15827475854</p>
				</div>
			</div>
		</div>
		<div class="content">
			<div class="mess_text">
			<p>1、请检查您输入的网址是否正确</p>
			<p>2、系统暂时暂停了对代理服务器的对本系统的访问，请检查您的浏览器或网络是否启用了代理服务器</p>
			<p>3、直接输入要访问的内容进行搜索</p>
			<p>4、出现了其他的错误，请注意上面的错误提示，有问题请与我们取得联系</p>
			</div>
			<p class="error">[错误信息]</p>
			<div class="error_text"style="display: none;<!--background-color: #FFFFDD;-->padding: 9px 4px;">
			<p>你所请求的方法不存在</p>
			</div>
			<p class="trace">[TRACE]</p>
			<div class="trace_text" style="display: none;<!--background-color: #E6F7FE;-->padding: 9px 4px;">
			<p>[org.mybatis.spring.SqlSessionUtils]Closing non transactional SqlSession</p> 
            <p>[org.springframework.jdbc.datasource.DataSourceUtils]Returning JDBC Connection to DataSource</p>
		    </div>
		</div>
		<div class="footer">
			<p><a href="http://localhost:8080/hb-bass-navigation/HBBassFrame/index#">返回>>></a></p>
		</div>
	</body>
</html>
