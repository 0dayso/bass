<#if msg = 1>  
 <form id="auditForm" method="get">
 <div>
 	<input id="file_id" name="file_id" value="${file_id!''}" type="hidden"/>
	<table style='width: 360px;font-size:12px;border-collapse:collapse;text-align: center;'>
		<thead><tr><th colspan="4" style='text-align: center;border: 1px solid #c3daf9;width: 340px;height: 30px;font-size: 14px; font-weight:  600;'  align="right">文件信息</th></tr></thead>
		
		<tr >
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">文件名称  :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${file_name!""}</td>
		</tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">文件编码  :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${file_code!""}</td>
		</tr>
		<tr >
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">文件描述  :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${file_desc!""}</td>
		</tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">文件路径  :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${file_path!""}</td>
		</tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">上传者&nbsp :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${creator!""}</td>
		</tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">上传时间 :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${create_time!""}</td>
		</tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">文件需求 :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">${req_id!""}</td>
		</tr>
		<tr><th colspan="4"style='text-align: center;border: 1px solid #c3daf9;width: 340px;height: 30px;font-size: 14px; font-weight:  600;' >审核</th></tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">审核结果 :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;'  align="left"><select name="status" class="easyui-combobox" ><option value="审核通过">审核通过</option><option value="审核不通过">审核不通过</option><lect></td>
		</tr>
		<tr>
			<td style='width:70px;height:30px;border: 1px solid #c3daf9;' align="right">审核意见 :</td>
			<td style='width:110px;height:30px;border: 1px solid #c3daf9;' align="left">
				<textarea name="approve_opinion" id="approve_opinion" style="height: 60px; width: 96%;"></textarea>
				<#if approve_opinion??>${approve_opinion}</#if>
			</td>
		</tr>
	</table>
</div>
</form>

<#else>  
	1
</#if>  
