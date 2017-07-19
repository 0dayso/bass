/*
 * Ext JS Library 2.2
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */
 Ext.BLANK_IMAGE_URL = 'js/ext/resources/images/default/s.gif';
 Ext.onReady(function(){

    Ext.QuickTips.init();
    // reader
    var reader = new Ext.data.ArrayReader({}, [
       {name: 'seatnum'},
       {name: 'userid'},
       {name: 'bussnum'},
       {name: 'trval'},
       {name: 'gotone'},
	   {name: 'mzone'},
	   {name: 'vip'},
	   {name: 'opttime'},
	   {name: 'satisfy'}
    ]);
	 
	var ds=new Ext.data.Store({
            reader: reader,
            data: Ext.grid.dummyData
        })
	
   var planmanagegrid_row = new Ext.grid.RowSelectionModel({singleSelect:true});
	//grid defined
  var grid3 = new Ext.grid.GridPanel({
        store: ds,
        cm: new Ext.grid.ColumnModel([
            new Ext.grid.RowNumberer(),
            {header: "坐席号", width: 40, sortable: true, dataIndex: 'seatnum'},
            {header: "员工编号", width: 20, sortable: true, dataIndex: 'userid'},
            {header: "办理业务数", width: 20, sortable: true, dataIndex: 'bussnum'},
            {header: "神州行", width: 20, sortable: true, dataIndex: 'trval'},
            {header: "全球通", width: 20, sortable: true, dataIndex: 'gotone'},
			{header: "动感地带", width: 20, sortable: true, dataIndex: 'mzone'},
			{header: "VIP", width: 20, sortable: true, dataIndex: 'vip'},
			{header: "办理时间(分钟)", width: 20, sortable: true, dataIndex: 'opttime'},
			{header: "满意度", width: 20, sortable: true, dataIndex: 'satisfy'}
        ]),
		sm:planmanagegrid_row,
        viewConfig: {
            forceFit:true
        },
		bbar: new Ext.PagingToolbar({
	            pageSize: 7,
	            store: ds,
	            displayInfo: true,
	            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
	            emptyMsg: "没有记录"
        	}),
        width:950,
        height:312,
        title:'',
        iconCls:'icon-grid',
        renderTo: 'extgrid'
    });
		
		
 })
 
 
 	// Array data for the grids
     Ext.grid.dummyData = [
    ['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意'],
	['001','00121','98', '98','98','78','78','45','满意']
];	