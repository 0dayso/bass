//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.lfz.widgetLabel', function(){
	var textObj;
	var option;
	var label;
	before(function(){//describe执行it之前执行
        var option = {
        	id:'label',
            parentId:'s',
            value:'setV',
            cls:'defaultCls'
        };
		label = jsUtils.loadJSObject("WidgetLabel",$,_,["Widget"]);
		labelObj = label.createNew(option);
	});
	after(function(){//describe执行it之后执行

	});
	beforeEach(function(){//describe执行每一个it之前执行

	});
	afterEach(function(){//describe执行每一个it之后执行

	});
    it('widgetLabel.test.set/getText()', function(){
        labelObj.setText("111");
        assert.equal("111",labelObj.getText(),'widgetLabel.set/getText()没有按预期设置值');
    });

});
