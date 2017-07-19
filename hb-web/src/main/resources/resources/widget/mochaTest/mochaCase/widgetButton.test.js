//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.lfz.widgetButton', function(){
    var button;
    var buttonObj;
    var option;//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.lfz.widgetButton', function(){
    var button;
    var buttonObj;
    var option;
    before(function(){//describe执行it之前执行
        var option = {
            id : 'button',
            name : 'button',
            parentId : 's',
            value : 'button',
            cls : 'defaultCls'
        };
        button = jsUtils.loadJSObject("WidgetButton",$,_,["Widget","WidgetInput"]);
        buttonObj = button.createNew(option);
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });
    it('widgetButton.test.set/getText()', function(){
        buttonObj.setText("123456");
        assert.equal("123456",buttonObj.getText(), 'widgetButton.set/getValue()没有按预期设置值');
    });
});




    before(function(){//describe执行it之前执行
        var option = {
            id : 'button',
            name : 'button',
            parentId : 's',
            value : 'button',
            cls : 'defaultCls'
        };
        button = jsUtils.loadJSObject("WidgetButton",$,_,["Widget"]);
        buttonObj = button.createNew(option);
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });
    it('widgetButton.test.set/getText()', function(){
        buttonObj.setText("123456");
        assert.equal("123456",buttonObj.getText(), 'widgetButton.set/getValue()没有按预期设置值');
    });
});



