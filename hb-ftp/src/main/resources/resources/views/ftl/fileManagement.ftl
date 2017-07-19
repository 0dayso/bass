
<div id="diaEdit"  class="easyui-dialog" style="width:400px;height:380px;" closed="true" buttons="#dlg-buttons" >
	<div id="div" style="margin: 20px 23px;"> </div>
</div>
<div id="dlg-buttons" style="text-align: center;">
    <a href="javascript:void(0)" class="easyui-linkbutton" icon-Cls="icon-ok" onclick="examie()">审核</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" icon-Cls="icon-cancel" onclick="javascript:$('#diaEdit').dialog('close');">取消</a>
</div>
<script type="text/javascript">
$('#btn').bind('click', function(){
    $.ajax({
        url:"/hb-ftp/toExamine",
        async:false,
        data : {file_id:'2017060700011'},
        type : "get",
        success: function(msg){
        	if(msg==1){
        		$.parser.parse();
			    $(function () {  
			       $.messager.alert("操作信息", "该信息已经审核通过","info");  
				}); 
        	}else{
        		var targetObj = $(msg).appendTo("#div");//先进行添加 然后 再打开页面 
				$.parser.parse(targetObj);
				$('#diaEdit').dialog('open').dialog('setTitle','审核');  
        	}
        	
        	
		},
    });       
});
function examie(){
	$('#loginForm').ajaxSubmit({
		url : '/hb-ftp/from',
		data : {file_id:'2017060700012'},
		success : function(data) {
			alert(data);
			$('#diaEdit').dialog('close')
		}
	});
}
</script>