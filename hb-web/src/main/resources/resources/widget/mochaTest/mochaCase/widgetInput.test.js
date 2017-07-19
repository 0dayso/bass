//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.lfz.widgetInput', function(){
    var input;
    var inputObj;
    var input;
    before(function(){//describe执行it之前执行
        var option = {
            id : 'input',
            name : 'input',
            parentId : 's',
            value : 'input',
            cls : 'defaultCls'
        };
        input = jsUtils.loadJSObject("WidgetInput",$,_,["Widget"]);
        inputObj = input.createNew(option);
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });
    it('widgetInput.test.set/getText()', function(){
        inputObj.setText("123456");
        assert.equal("123456",inputObj.getText(), 'widgetInput.set/getValue()没有按预期设置值');
    });
});



