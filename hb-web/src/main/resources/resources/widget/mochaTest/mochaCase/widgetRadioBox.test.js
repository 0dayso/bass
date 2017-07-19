//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.liufz.widgetRadioBox', function(){
    var radioBoxObj;
    var option;
    before(function(){//describe执行it之前执行
        var option = {
            id: 'r',
            parentId:'s',
            value:'radioBox',
            name: 'label'
        };
        var radioBox = jsUtils.loadJSObject("WidgetRadioBox",option,$,_,["Widget"]);
        radioBoxObj = radioBox.createNew(option);
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });

    it('widgetRadioBox.test.getValue()', function(){  
        assert.equal("1234", radioBoxObj.getValue(), 'widgetRadioBox.getValue()没有按照预期正确设置值');
    });
    
});
