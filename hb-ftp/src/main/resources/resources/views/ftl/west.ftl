<div class="easyui-panel" data-options="title:'功能菜单',border:false,fit:true">
	<div class="easyui-accordion" data-options="fit:true,border:false">
		<div title="菜单" data-options="iconCls:'icon-ok'" style="overflow:auto;padding:10px;">
			<ul id="tt"></ul>  
		</div>
		<!--<div title="Help" data-options="iconCls:'icon-help'" style="padding:10px;">
		</div>-->	
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#tt').tree({ 
	    url:'${mvcPath}/resources/views/ftl/tree_data.json',
	    method: 'get',
	    onClick: function(node){
			if (node.attributes.url!=null) {
				var url = '${mvcPath}/resources/views/ftl'+node.attributes.url;
				addTab({
					title : node.text,
					closable : true,
					href : url
				});
			}
		}
	})
});

</script>