/*
 * Ext JS Library 2.2
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */
Ext.BLANK_IMAGE_URL = 'js/ext/resources/images/default/s.gif';
Ext.onReady(function(){

    var tabs = new Ext.TabPanel({
        renderTo:'hisotrypeopletab',
        resizeTabs:true, // turn on tab resizing
        minTabWidth: 115,
        tabWidth:135,
        enableTabScroll:true,
        width:782,
        height:240,
        defaults: {autoScroll:true}
    });

    // tab generation code
    var index = 0;
    while(index < 7){
        addTab();
    }
    function addTab(){
        tabs.add({
            title: 'New Tab ' + (++index),
            iconCls: 'tabs',
            html: 'Tab Body ' + (index) + '<br/><br/>',
            closable:true
        }).show();
    }

});