//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');
describe('com.asiainfo.zhouy.widgetCheckBox', function(){
    var checkBox;
    var option;
    before(function(){//describe执行it之前执行
        var option = {};
        label = jsUtils.loadJSObject("WidgetLabel",$,_,["Widget"]);
        wdigetLabel = label.createNew(option);
        box = jsUtils.loadJSObject("WidgetCheckBox",option,$,_,["Widget"]);
        checkBox = box.createNew(option);
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });
    it('widgetCheckBox.test', function(){
        console.log("getOptions:"+checkBox.getOptions());
        assert.equal("1123",checkBox.getOptions(),"wrong value")
    });
});



