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
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfInput.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButton.js' type="text/javascript"></script>   
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfSelect.js' type="text/javascript"></script>              
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButton.js' type="text/javascript"></script>              
<script src='${mvcPath}/resources/widget/widgets/Table/js/CollectTable.js' type="text/javascript"></script>    
<script src="${mvcPath}/resources/widget/widgets/core/DateBoxUtil.js" type="text/javascript"></script>         
<script src='${mvcPath}/resources/widget/widgets/DateBox/js/SelfDateBox.js' type="text/javascript"></script> 
<script src='${mvcPath}/resources/widget/widgets/ToolBar/js/Page.js' type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/resource/datepicker/js/datepicker.min.js" type="text/javascript"></script>     

</head>
<style type="text/css">
</style>
<title>${(appName)?default("空白页")}</title>
<script>
$(function() {
    var menuId = ${menuid};
    var collectName = "";
    var hotBullet = Widget.create('bulletinsimple', {
        column: 0,
        hasSubhead: 'false',
        titleText: '热门推荐',
        titleColor: '#B9DEF1',
        funcTitle: '更多',
        funcClick: function(text) {},
        width: '100%',
        lineNum: '6',
        datas: ${hotcollectlist},
        rowClick: function(row) {
            window.parent.openWhithNavigation(self, row.text, row.uri);
        }
    });
    var collect_name = Widget.create('selfinput', {
        placeholder: '',
        name: '收藏标题'
    });
    var Typeselect = Widget.create('selfselect', {
        name: '收藏类型',
        datas: ${collecttypelist},
        clickFunc: function(value) {}
    });
    var dateDbl = Widget.create('selfdatebox', {
        name: '周期选择',
        format: 'yyyy-mm-dd',
        select: function(format, value) {}
    });
    var btn = Widget.create('selfbutton', {
        title: '查询',
        click: function() {
            collectName = collect_name.getValue();
            refreshTable(menuId, collectName, dateDbl.getValue().startdate, dateDbl.getValue().enddate, Typeselect.getValue(), "1");
        }
    });
    var querybar = Widget.create('toolbar', {
        items: [collect_name, Typeselect, dateDbl, btn]
    });
    var reportTable = Widget.create('collecttable', {
        row: 1,
        clickitem: function(name, value) {
            window.parent.openWhithNavigation(self, name, value);
        },
        clickdell: function(val) {
            $.ajax({
                url: '${mvcPath}/myCollect/delCollect',
                type: "POST",
                async: false,
                dataType: 'json',
                data: {
                    rid: val,
                    menuId: menuId
                },
                success: function(data, textStatus) {
                    if (data.flag) {
                        alert(data.msg);
                        refreshTable(menuId, collectName, dateDbl.getValue().startdate, dateDbl.getValue().enddate, Typeselect.getValue(), pageFoot.getNowpage());
                    } else {
                        alert(data.msg);
                    }
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {}
            });
        },
        datas: ${collectlist}
    });
    var pageFoot = Widget.create('page', {
        row: 2,
        float: 'center',
        lineperpage: 10,
        totalnum: ${totalnum},
        click: function(num) {
            refreshTable(menuId, collectName, dateDbl.getValue().startdate, dateDbl.getValue().enddate, Typeselect.getValue(), num);
        }
    });
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
            }]],
            items: [querybar, reportTable, pageFoot]
        },
    });
    var refreshTable = function(menuId, resourceName, startDate, endDate, resourceType, pageNumStr) {
        $.ajax({
            url: '${mvcPath}/myCollect/getCollectList',
            type: "POST",
            async: false,
            dataType: 'json',
            data: {
                menuId: menuId,
                resourceName: resourceName,
                startDate: startDate,
                endDate: endDate,
                resourceType: resourceType,
                pageNumStr: pageNumStr
            },
            success: function(data, textStatus) {
                reportTable.load(data);
                var count = data.length == 0 ? 0 : data[0].count;
                pageFoot.setTotalnum(count);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {}
        });
    }
    var page = Widget.create('gridlayouter', {
        minWidth: 1100,
        maxWidth: 1186,
        applyTo: 'body',
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
</body>
</html>