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
<script src='${mvcPath}/resources/widget/widgets/Bulletin/js/BulletinLeftImage.js' type="text/javascript"></script> 
<script src='${mvcPath}/resources/widget/widgets/Bulletin/js/BulletinTopImage.js' type="text/javascript"></script>    
<script src="${mvcPath}/resources/widget/widgets/Panel/js/Panel.js" type="text/javascript"></script>
<script src="${mvcPath}/resources/widget/widgets/ToolBar/js/ToolBar.js" type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/ToolBar/js/Page.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfInput.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButton.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButtonGroup.js' type="text/javascript"></script>
<script src='${mvcPath}/resources/widget/widgets/Panel/js/PagePanel.js' type="text/javascript"></script>       
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfSelect.js' type="text/javascript"></script>              
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButton.js' type="text/javascript"></script>              
<script src='${mvcPath}/resources/widget/widgets/Form/js/SelfButtonGroup.js' type="text/javascript"></script>    

</head>
<style type="text/css">
</style>
<title>${(appName)?default("空白页")}</title>
<script>
$(function() {
    var menuid = ${menuid};
    var appName = "";
    var bulletinleftimage = Widget.create('bulletinleftimage', {
        column: 0,
        datas: ${hotapp},
        src: '${mvcPath}/resources/widget/sass/image/applist/application.png',
        nameClick: function(name, value) {
            window.parent.openWhithNavigation(self,name, value);
        }
    });
    var Panel1 = Widget.create('panel', {
        column: 0,
        title: '热门推荐',
        top: '18px',
        items: [bulletinleftimage]
    });
    var app_name = Widget.create('selfinput', {
        placeholder: '',
        name: '应用名称'
    });
    var querybtn = Widget.create('selfbutton', {
        title: '查询',
        click: function() {
            appName = app_name.getValue();
            refreshList(menuid, groupBtnSort.getValue(), appName, Typeselect.getValue(), "1");
            pageHead.setNowpage(1);
            pageFoot.setNowpage(1);
        }
    });
    var querybar = Widget.create('toolbar', {
        column: 0,
        row: 0,
        items: [app_name, querybtn]
    });
    var groupBtnSort = Widget.create('selfbuttongroup', {
        title: '排序',
        issplit: true,
        click: function(val) {
            refreshList(menuid, val, appName, Typeselect.getValue(), "1");
            pageHead.setNowpage(1);
            pageFoot.setNowpage(1);
        },
        datas: [{
            name: "相关性",
            value: "ROWID",
            isdefault: true
        },
        {
            name: "最多浏览",
            value: "ROWID"
        },
        {
            name: "最新上线",
            value: "TIMEROWS"
        }]
    });
    var pageHead = Widget.create('page', {
        float: 'right',
        lineperpage: 10,
        totalnum: ${totalnum},
        click: function(num) {
            pageFoot.setNowpage(num);
            refreshList(menuid, groupBtnSort.getValue(), appName, Typeselect.getValue(), num);
        }
    });
    var pageFoot = Widget.create('page', {
        float: 'right',
        lineperpage: 10,
        totalnum: ${totalnum},
        click: function(num) {
            pageHead.setNowpage(num);
            refreshList(menuid, groupBtnSort.getValue(), appName, Typeselect.getValue(), num);
        }
    });
    var Typeselect = Widget.create('selfselect', {
        name: '类型',
        datas: ${apptypelist},
        clickFunc: function(value) {
            refreshList(menuid, groupBtnSort.getValue(), appName, value, "1");
        }
    });
    var menubar = Widget.create('toolbar', {
        items: [Typeselect, groupBtnSort]
    });
    var bulletintopimage = Widget.create('bulletintopimage', {
        column: 0,
        datas: ${applist},
        src: '${mvcPath}/resources/widget/sass/image/applist/app.png',
        nameClick: function(name, value) {
            window.parent.openWhithNavigation(self, name, value);
        },
        collectClick: function(rid) {
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
                        refreshList(menuid, groupBtnSort.getValue(), appName, Typeselect.getValue(), pageHead.getNowpage());
                    } else {
                        alert(data.msg);
                    }
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {}
            });
        }
    });
    var pagepanel = Widget.create('pagepanel', {
        column: 0,
        row: 1,
        title: '相关指标',
        top: '18px',
        headLeftItems: [menubar],
        headRightItems: [pageHead],
        bodyItems: [bulletintopimage],
        footItems: [pageFoot]
    });
    var Panel2 = Widget.create('panel', {
        column: 1,
        title: '营销活动评估',
        top: '18px',
        layouter: {
            type: 'grid',
            gridDefine: [[{
                width: '100%'
            }], [{
                width: '100%'
            }]],
            items: [querybar, pagepanel]
        }
    });
    var refreshList = function(sid, orderByStr, searchVal, appType, pageNumStr) {
        $.ajax({
            url: '${mvcPath}/appCenter/getAppList',
            type: "POST",
            async: false,
            dataType: 'json',
            data: {
                sid: sid,
                orderByStr: orderByStr,
                searchVal: searchVal,
                appType: appType,
                pageNumStr: pageNumStr
            },
            success: function(data, textStatus) {
                bulletintopimage.load(data);
                var count = data.length == 0 ? 0 : data[0].count;
                pageHead.setTotalnum(count);
                pageFoot.setTotalnum(count);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
						}
        });
    }
    var applicationCenter = Widget.create('gridlayouter', {
        minWidth: 1186,
        maxWidth: 1325,
        applyTo: 'body',
        gridDefine: [[{
            width: '19%',
            interval: '11px'
        },
        {
            width: '77%',
            interval: '12px 0 0 0'
        }]],
        items: [Panel1, Panel2]
    });
});
</script>
</head>
<body style="overflow: auto; background: url(${mvcPath}/hb-bass-frame/images/back.png) repeat  center center;">
</body>
</html>