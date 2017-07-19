<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	copied from modelmodify.jsp
  --%>
    <title>修改页面</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <%
 	String oper = request.getParameter("oper");
 	String o_channellevel = request.getParameter("o_channellevel");
 	String staff_id = (String)session.getAttribute("loginname");
 	String channel_code = request.getParameter("channel_code");
 	//log.debug("oper : " + oper + ";;; o_channellevel : " + o_channellevel + ";;; staff_id : " + staff_id + ";;;channel_code : " + channel_code);
 %>
 <script type="text/javascript">
 	//cellclass[0]="grid_row_cell_text";
	//cellclass[1]="grid_row_cell_number";
	//cellclass[2]="grid_row_cell_number";
	//cellclass[3]="grid_row_cell_number";
	
	//cellfunc[1] = numberFormatDigit2;
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	cellfunc[4] = function(datas,options) {
		return datas[options.seq].substr(0,19);//done
	}
	function doSubmit()
	{	
	//select "CHANNELLEVEL", "MIN_VAL", "MAX_VAL", "CHANGE_STAFF", "CHANGES_DATE", "EFF_DATE"
  //from "NMK"."AI_CHANNEL_LEVEL_HIST"
		sql = "select CHANNELLEVEL, MIN_VAL, MAX_VAL,CHANGE_STAFF, CHANGES_DATE, EFF_DATE from " + "NMK.AI_CHANNEL_LEVEL_HIST" + " order by changes_date desc";
	 	countSql = "select count(*) from " + "NMK.AI_CHANNEL_LEVEL_HIST";
	 	ajaxSubmitWrapper(sql+" fetch first " + fetchRows  + " rows only with ur",countSql);
	} 
	Ext.onReady(function(){
		Ext.QuickTips.init();
		var fm = Ext.form;
		var cm = new Ext.grid.ColumnModel([{
           id: 'channel_level',
           header: '序号',
           dataIndex: 'channel_level',
           width: 100
        },{
           header: '渠道分数',
           dataIndex: 'channel_lname',
           width: 130
        },{
           header: '最低分',
           dataIndex: 'min_val',
           width: 100,
           editor: new fm.NumberField({
               allowBlank: false,
               allowNegative: false,
               maxValue: 100,
               minValue: 0
           })
        },{
           header: '最高分',
           dataIndex: 'max_val',
           width: 100,
           editor: new fm.NumberField({
               allowBlank: false,
               allowNegative: false,
               maxValue: 100,
               minValue: 0
           })
        }
    ]);
     var store = new Ext.data.Store({
        // load remote data using HTTP
        url: 'modifylevel.jsp',

        // specify a XmlReader (coincides with the XML format of the returned data)
        reader: new Ext.data.JsonReader(
            {
                root: 'records'
            },
            [
                {name: 'channel_level', type: 'string'},
                {name: 'channel_lname', type: 'string'},
                {name: 'min_val', type: 'string'},
                {name: 'max_val', type: 'string'}             
            ]
        ),
        sortInfo: {field:'channel_level', direction:'ASC'}
    });
    var grid = new Ext.grid.EditorGridPanel({
    	//added mask
    	loadMask:{
    		msg:'数据加载中，请稍后...',
    		removeMask:true
    	},
        store: store,
        cm: cm,
        renderTo: 'editor-grid',
        width: 600,
        height: 300,
        title: '点击修改',
        frame: true,
        clicksToEdit: 1,
        tbar: [{
            text: '保存',
            handler : function(){
            	var newRecords = store.getModifiedRecords();
            	 if(newRecords.length==0){  // 确认修改记录数量
			       alert("没有修改数据！");
       				return false;
     			}
     			var ids = "";var mins = ""; var maxs = "";
     			for(var i = 0 ; i< newRecords.length; i++) {
     				//var thisObj = newRecords[i].modified;
     				var dataObj = newRecords[i].data;
     				//alert("dataObj[min_val] : " + dataObj['min_val']);
     				//alert("dataObj[max_val] : " + dataObj['max_val']);
     				//alert(dataObj['channel_level']);
     				ids += dataObj['channel_level'];
     				mins += dataObj['min_val'];
     				maxs += dataObj['max_val'];
     				if(i<newRecords.length -1) {
     				ids += ",";
     				mins += ",";
     				maxs += ",";
     				}
     			}
     			//alert("ids : " + ids);
     			//alert("mins : " + mins);
     			//alert("maxs : " + maxs);
     			//ajax request start
     			Ext.Ajax.request({
					url: 'modifylevel.jsp',
					params: {
						action : 'modify',
						ids : ids,
						mins : mins,
						maxs : maxs
					},
					success: function(response, options) { 
				            //获取响应的json字符串 
				            var responseArray = Ext.util.JSON.decode(response.responseText); 
				            if (responseArray.success == true) {
				           		Ext.Msg.alert('成功','设置成功!'); 
				           		store.reload();
				           		doSubmit();//get hist log
				            } 
				            else {
				            	 Ext.Msg.alert('失败', responseArray.errorInfo); 
				            	 store.reload();
				            	 doSubmit();//get hist log
				            }
					},
					failure: function() {
						Ext.Msg.alert("提示","设置失败！请联系管理员.");
						store.reload();
					}
				});
     			//ajax request end
            }
        }]
    });
    store.load();
	doSubmit();
	});
	String.prototype.trim=function(){      
   	 	return this.replace(/(^\s*)|(\s*$)/g, '');   
	} 
  </script>
  <body>
  <form action="" method="post">

	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'editor-grid')" title="点击隐藏">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;级别分数档次划分区域：
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="editor-grid">
				
			</div>
		</fieldset>
	</div>
	<br/>
	</form>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;操作历史记录：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<%-- 怎么加渠道类型?<td class='grid_title_cell'>渠道类型</td> --%>
				 	<td class='grid_title_cell'>渠道星级</td>
				 	<td class='grid_title_cell'>起始分数</td>
				 	<td class='grid_title_cell'>上限分数</td>
				 	<td class='grid_title_cell'>操作人员</td>
				 	<td class='grid_title_cell'>修改日期</td>
				 	<td class='grid_title_cell'>生效日期</td>
				 </tr>
			</table>
		</div>			

  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
