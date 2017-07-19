<%@page contentType="text/html; charset=gb2312" %>
<html>
	<head>
		<title>test</title>
	</head>
	<body>body
	<div id="editor-grid">
	</div>
	</body>
</html>

<script type="text/javascript">
Ext.onReady(function(){
		Ext.QuickTips.init();
		var fm = Ext.form;
		var cm = new Ext.grid.ColumnModel([{
           id: 'id',
           header: '序号',
           dataIndex: 'channel_level',
           width: 220,
        },{
           header: '渠道分数',
           dataIndex: 'channel_lname',
           width: 130,
        },{
           header: '最低分',
           dataIndex: 'min_val',
           width: 70,
           editor: new fm.NumberField({
               allowBlank: false,
               allowNegative: false,
               maxValue: 100,
               minValue: 0
           })
        },{
           header: '最高分',
           dataIndex: 'max_val',
           width: 70,
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
        url: 'test.jsp',

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
        store: store,
        cm: cm,
        renderTo: 'editor-grid',
        width: 600,
        height: 300,
        title: 'Edit Plants?',
        frame: true,
        clicksToEdit: 1,
    });
    store.load();
	});
	</script>