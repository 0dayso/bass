<!DOCTYPE HTML>
<html ng-app="adaptZbModule">
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<meta name="keywords" content="">
<meta name="description" content="">
<!--[if IE 6]>
<script type="text/javascript" src="${mvcPath}/resources/lib/DD_belatedPNG_0.0.8a-min.js" ></script>
<script>DD_belatedPNG.fix('*');</script>
<![endif]-->
<!--[if IE 7]>
<link href="${mvcPath}/resources/lib/font-awesome/font-awesome-ie7.min.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if lt IE 9]>
<script type="text/javascript" src="${mvcPath}/resources/lib/html5.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/PIE_IE678.js"></script>
<script src="${mvcPath}/resources/lib/es5-shim.min.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/lib/es5-sham.min.js" type="text/javascript"></script>
<![endif]-->

<script src="${mvcPath}/resources/lib/underscore/underscore-min.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/lib/riot/js/riot.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/lib/jquery/js/jquery-1.11.3.min.js" type="text/javascript"></script>
<link href="${mvcPath}/resources/lib/Font-Awesome-3.2.1/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
<script src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.js" type="text/javascript"></script>
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="${mvcPath}/resources/widget/resource/datepicker/css/datepicker.min.css" rel="stylesheet" type="text/css" />

<link href="${mvcPath}/resources/widget/sass/target.css" rel="stylesheet" type="text/css" />

<script src="${mvcPath}/resources/widget/widgets/core/BoxCommpent.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/core/ComponentBase.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/core/Container.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/core/Layouter.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/core/Widget.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/Layouter/js/GridLayouter.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/Layouter/js/DefaultLayouter.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/Bulletin/js/BulletinSimple.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/Panel/js/Panel.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/ToolBar/js/ToolBar.js" type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/ToolBar/js/Page.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfInput.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButton.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButtonGroup.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Table/js/ReportTable.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Table/js/ReportList.js' type="text/javascript"></script>

</head>
<style type="text/css">
</style>
<title>${(appName)?default("空白页")}</title>
<script>
$(function() {
    var menuid = ${menuid};
    var rptName = "";
    var hotBullet = Widget.create('bulletinsimple', {
        column: 0,
        hasSubhead: 'false',
        titleText: '热门推荐',
        titleColor: '#B9DEF1',
        width: '100%',
        lineNum: '6',
        datas: ${hotcollect},
        rowClick: function(row) {
            window.parent.openWhithNavigation(self, row.text, row.uri);
        },
    });
    var rpt_name = Widget.create('selfinput', {
        placeholder: '',
        name: '报表名称'
    });
    var btn = Widget.create('selfbutton', {
        title: '查询',
        click: function() {
            rptName = rpt_name.getValue();
            groupBtnMain.hide([0, 1]);
            groupBtnMain.show(2);
            reportList.show();
            reportTable.hide();
            pageHead.show();
            pageFoot.show();
            refreshList(menuid, groupBtnSort.getValue(), rptName, "", 1);
            pageHead.setNowpage(1);
            pageFoot.setNowpage(1);
        }
    });
    var querybar = Widget.create('toolbar', {
        items: [rpt_name, btn]
    });
    var groupBtnSort = Widget.create('selfbuttongroup', {
        title: '排序',
        issplit: true,
        click: function(val) {
            groupBtnMain.hide([0, 1]);
            groupBtnMain.show(2);
            reportList.show();
            reportTable.hide();
            pageHead.show();
            pageFoot.show();
            refreshList(menuid, val, rptName, "", 1);
            pageHead.setNowpage(1);
            pageFoot.setNowpage(1);
        },
        datas: [{
            name: "相关性",
            value: "num",
            isdefault: true
        },
        {
            name: "最多浏览",
            value: "num"
        },
        {
            name: "最新上线",
            value: "create_dt"
        }]
    });
    var groupBtnMain = Widget.create('selfbuttongroup', {
        issplit: false,
        click: function(val) {
            if (val == 'list') {
                groupBtnMain.hide([0, 1]);
                groupBtnMain.show(2);
                reportList.show();
                reportTable.hide();
                pageHead.show();
                pageFoot.show();
            }
            if (val == 'table') {
                groupBtnMain.hide(2);
                groupBtnMain.show([0, 1]);
                reportList.hide();
                reportTable.show();
                pageHead.hide();
                pageFoot.hide();
            }
            if (val == 'expandAll') {
                groupBtnMain.reSetitem(val, "全部关闭", "unexpandAll");
                reportTable.expandAll();
            }
            if (val == 'unexpandAll') {
                groupBtnMain.reSetitem(val, "全部展开", "expandAll");
                reportTable.unexpandAll();
            }
        },
        datas: [{
            name: "详细视图",
            value: "list"
        },
        {
            name: "全部展开",
            value: "expandAll"
        },
        {
            name: "全景视图",
            value: "table",
            ishide: true
        }]
    });
    var pageHead = Widget.create('page', {
        float: 'right',
        lineperpage: 6,
        totalnum: ${totalnum},
        click: function(num) {
            pageFoot.setNowpage(num);
            refreshList(menuid, groupBtnSort.getValue(), rptName, "", num);
        }
    });
    var pageFoot = Widget.create('page', {
        float: 'right',
        lineperpage: 6,
        totalnum: ${totalnum},
        click: function(num) {
            pageHead.setNowpage(num);
            refreshList(menuid, groupBtnSort.getValue(), rptName, "", num);
        }
    });
    var menubar = Widget.create('toolbar', {
        items: [groupBtnMain, groupBtnSort]
    });
    var reportTable = Widget.create('reporttable', {
        click: function(row) {
            window.parent.openWhithNavigation(self, row.rname, row.ruri);
        },
        addfavorite: function(row) {
            $.ajax({
                url: '${mvcPath}/myCollect/addCollect',
                type: "POST",
                async: false,
                dataType: 'json',
                data: {
                    rid: row.rid,
                    menuId: menuid
                },
                success: function(data, textStatus) {
                    if (data.flag) {
                        alert(data.msg);
                        refreshTable();
                    } else {
                        alert(data.msg);
                    }
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {}
            });
        },
        datas: ${reporttable}
    });
    var reportList = Widget.create('reportlist', {
        titleclick: function(name, value) {
            window.parent.openWhithNavigation(self, name, value);
        },
        addfavorite: function(rid) {
            $.ajax({
                url: '${mvcPath}/myCollect/addCollect',
                type: "POST",
                async: false,
                dataType: 'json',
                data: {
                    rid: rid,
                    menuId: menuid
                },
                success: function(data, textStatus) {
                    if (data.flag) {
                        alert(data.msg);
                        refreshList(menuid, groupBtnSort.getValue(), rptName, "", pageHead.getNowpage());
                    } else {
                        alert(data.msg);
                    }
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {}
            });
        },
        datas: ${reportlist}
    });
    reportList.hide();
    pageHead.hide();
    pageFoot.hide();
    var rpt_panel = Widget.create('panel', {
        column: 1,
        title: '营销活动评估',
        top: '18px',
        layouter: {
            type: 'grid',
            gridDefine: [[{
                width: '100%'
            }], [{
                width: '100%'
            }], [{
                width: '100%'
            }], [{
                width: '100%'
            }], [{
                width: '100%'
            }], [{
                width: '100%'
            }]],
            items: [querybar, pageHead, menubar, reportList, reportTable, pageFoot]
        },
    });
    var refreshList = function(menuId, orderByStr, nameLike, isKeyWord, pageNumStr) {
        $.ajax({
            url: '${mvcPath}/reportCenter/getReportList',
            type: "POST",
            async: false,
            dataType: 'json',
            data: {
                menuId: menuId,
                orderByStr: orderByStr,
                nameLike: nameLike,
                isKeyWord: isKeyWord,
                pageNumStr: pageNumStr
            },
            success: function(data, textStatus) {
                reportList.load(data);
                var count = data.length == 0 ? 0 : data[0].count;
                pageHead.setTotalnum(count);
                pageFoot.setTotalnum(count);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
						}
        });

    }
    var refreshTable = function() {
        $.ajax({
            url: '${mvcPath}/reportCenter/getReportTable',
            type: "POST",
            async: false,
            dataType: 'json',
            data: {
                menuId: menuid
            },
            success: function(data, textStatus) {
                reportTable.load(data);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
						}
        });
    }
    var page = Widget.create('gridlayouter', {
        minWidth: 1100,
        maxWidth: 1186,
        applyTo: '#container',
        gridDefine: [[{
            width: '20%',
            interval: '11px'
        },
        {
            width: '76%',
            interval: '12px 0 0 0'
        }]],
        items: [hotBullet, rpt_panel]
    });
});
</script>
</head>
<body style="overflow: auto; background: url(${mvcPath}/hb-bass-frame/images/back.png) repeat  center center;">
	<div id='container'></div>
</body>
</html>