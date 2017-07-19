//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.lfz.widgetFrom.text', function(){
	var textObj;
	var option;
	before(function(){//describe执行it之前执行
		var name = "";
        var option = {
            parentId:'s',
            value:'setV',
            cls:'defaultCls',
            listener:{
                change:function(){
                    alert(123)
                }
            }
        };
		text = jsUtils.loadJSObject("WidgetText",option,$,_,["Widget"]);
        textObj = text.createNew(option);
	});
	after(function(){//describe执行it之后执行

	});
	beforeEach(function(){//describe执行每一个it之前执行

	});
	afterEach(function(){//describe执行每一个it之后执行

	});
    it('WidgetText.test', function(){
        textObj.setValue("123");
        assert.equal("123",textObj.getValue(), 'WidgetText.get/setValue()没有按照预期正确设置值');
    });

});



