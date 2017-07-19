<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	copied from levelmodify.jsp
  --%>
    <title>�޸�ҳ��</title>
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
		//�־�������
		function pctFmt(val) {
			if(val != 'null') {
				val *= 100;
				val = val + "";
				return val + "%";
			} else return val;
			
			
		}
		Ext.QuickTips.init();
		var fm = Ext.form;
		var cm = new Ext.grid.ColumnModel([{
           id: 'zb_code',
           header: 'ָ�����',
           dataIndex: 'zb_code',
           width: 65
        },{
           header: 'ָ������',
           dataIndex: 'zb_name',
           width: 180
        },{
           header: 'Ԥ����ֵ(min)',
           dataIndex: 'min_value',
           renderer : pctFmt,
           sortable: true,
           width: 90,
           
           editor: new fm.NumberField({
               allowBlank: false,
               allowNegative: true
           })
        },{
           header: 'Ԥ����ֵ(max)',
           dataIndex: 'max_value',
           width: 90,
            renderer : pctFmt,
           sortable: true,
           editor: new fm.NumberField({
               allowBlank: false,
               allowNegative: true
           })
        },
        {
           header: 'Ԥ������',
           dataIndex: 'alert_level',
           width: 80
        }
    ]);
     var store = new Ext.data.Store({
        url: 'modifyalert.jsp',
        reader: new Ext.data.JsonReader(
            {
                root: 'records'
            },
            [
                {name: 'zb_code', type: 'string'},
                {name: 'zb_name', type: 'string'},
                {name: 'min_value', type: 'string'},
                {name: 'max_value', type: 'string'},
                {name: 'alert_level', type: 'string'}            
            ]
        ),
        sortInfo: {field:'zb_code', direction:'ASC'}
    });
    var grid = new Ext.grid.EditorGridPanel({
    	//added mask
    	loadMask:{
    		msg:'���ݼ����У����Ժ�...',
    		removeMask:true
    	},
        store: store,
        cm: cm,
        renderTo: 'editor-grid',
        width: 600,
        height: 600,
        title: '����޸�',
        frame: true,
        clicksToEdit: 1,
        tbar: [{
            text: '����',
            handler : function(){
            	var newRecords = store.getModifiedRecords();
            	 if(newRecords.length==0){  // ȷ���޸ļ�¼����
			       alert("û���޸����ݣ�");
       				return false;
     			}
     			var ids = "";var mins = ""; var maxs = "";var ids2 = "";//added
     			for(var i = 0 ; i< newRecords.length; i++) {
     				//var thisObj = newRecords[i].modified;
     				var dataObj = newRecords[i].data;
     				//alert("dataObj[min_val] : " + dataObj['min_val']);
     				//alert("dataObj[max_val] : " + dataObj['max_val']);
     				//alert(dataObj['channel_level']);
     				ids += dataObj['zb_code'];
     				mins += dataObj['min_value'];
     				maxs += dataObj['max_value'];
     				//added
     				ids2 += dataObj['alert_level'];
     				if(i<newRecords.length -1) {
     				ids += ",";
     				mins += ",";
     				maxs += ",";
     				ids2 += ",";
     				}
     			}
     			//alert("ids : " + ids);
     			//alert("mins : " + mins);
     			//alert("maxs : " + maxs);
     			//ajax request start
     			Ext.Ajax.request({
					url: 'modifyalert.jsp',
					params: {
						action : 'modify',
						ids : ids,
						mins : mins,
						maxs : maxs,
						ids2 : ids2
					},
					success: function(response, options) { 
				            //��ȡ��Ӧ��json�ַ��� 
				            var responseArray = Ext.util.JSON.decode(response.responseText); 
				            if (responseArray.success == true) {
				           		Ext.Msg.alert('�ɹ�','���óɹ�!'); 
				           		store.reload();
				           		//doSubmit();//get hist log
				            } 
				            else {
				            	 Ext.Msg.alert('ʧ��', responseArray.errorInfo); 
				            	 store.reload();
				            	 //doSubmit();//get hist log
				            }
					},
					failure: function() {
						Ext.Msg.alert("��ʾ","����ʧ�ܣ�����ϵ����Ա.");
						store.reload();
					}
				});
     			//ajax request end
            }
        }]
    });
    store.load();
	//doSubmit();
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
						<td onClick="hideTitle(this.childNodes[0],'editor-grid')" title="�������">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;����������λ�������
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
		<%-- 
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="�������">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;������ʷ��¼��
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
				 	<td class='grid_title_cell'>�����Ǽ�</td>
				 	<td class='grid_title_cell'>��ʼ����</td>
				 	<td class='grid_title_cell'>���޷���</td>
				 	<td class='grid_title_cell'>������Ա</td>
				 	<td class='grid_title_cell'>�޸�����</td>
				 	<td class='grid_title_cell'>��Ч����</td>
				 </tr>
			</table>
		</div>			

  <%@ include file="/hbbass/common2/loadmask.htm"%>
  --%>
  </body>
</html>
