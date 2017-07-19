//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.zx.widgetFrom.textArea', function(){
	var textAreaObj;
	var option;
	before(function(){//describe执行it之前执行
        var option = {
            id: 'testArea',
            parentId:'s',
            value:'testArea',
            listener:{
                click:function(){
                    alert('321');
                },
                change:function(){
                    alert('321');
                }             
            }
        };
		var textAreaType = jsUtils.loadJSObject("WidgetTextArea",option,$,_,["Widget"]);
        textAreaObj = textAreaType.createNew(option);
	});
	after(function(){//describe执行it之后执行

	});
	beforeEach(function(){//describe执行每一个it之前执行

	});
	afterEach(function(){//describe执行每一个it之后执行

	});

    it('widgetFrom.textArea.getValue()', function(){
        textAreaObj.setValue('test1');
        assert.equal('test1', textAreaObj.getValue(), 'widgetFrom.textArea.getValue()没有按照预期正确获得值');
    });

    it('widgetFrom.textArea.setValue()', function(){
        textAreaObj.setValue("test");
        assert.equal('test', textAreaObj.getValue(), 'widgetFrom.textArea.setValue()没有按照预期正确设置值');
    });

    it('widgetFrom.textArea.getLength()', function(){
        console.log('textAreaObj.getValue()');
        assert(textAreaObj.getLength() == 4, 'widgetFrom.testArea.getLength()没有按照预期正确获得值');
    });

});



