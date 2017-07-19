//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.zengx.widgetTree', function(){
    var treeObj;
    var option;
    before(function(){//describe执行it之前执行
        var option = {
            id:'testTree',
            parentId:'s',
            cls:'defaultCls',
            data :
            [
                {id:"1",name:"父节点1",url:"www.baidu.com",pid:"0"},
                    {id:"4",name:"父节点11",url:"",pid:"1"},
                        {id:"13",name:"父节点111",url:"",pid:"4"},
                        {id:"14",name:"父节点112",url:"",pid:"4"},
                    {id:"5",name:"父节点12",url:"",pid:"1"},
                    {id:"6",name:"父节点13",url:"",pid:"1"},
                {id:"2",name:"父节点4",url:"",pid:"0"},
                    {id:"7",name:"父节点41",url:"",pid:"2"},
                    {id:"8",name:"父节点42",url:"",pid:"2"},
                    {id:"9",name:"父节点43",url:"",pid:"2"},
                {id:"3",name:"父节点5","url":"",pid:"0"},
                    {id:"10",name:"父节点51",url:"",pid:"3"},
                    {id:"11",name:"父节点52",url:"",pid:"3"},
                    {id:"12",name:"父节点53",url:"",pid:"3"}
            ] 
        };
        var treeType = jsUtils.loadJSObject("WidgetDemoTree",option,$,_,["Widget"]);
        treeObj = treeType.createNew(option);
        treeObj.init();
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });
});



