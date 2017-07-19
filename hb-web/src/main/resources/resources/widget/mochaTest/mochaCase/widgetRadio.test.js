//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');

describe('com.asiainfo.zx.widgetFrom.radio', function(){
    var radioObj;
    var option;
    before(function(){//describe执行it之前执行
        var option = {
            id: 'r',
            parentId:'s',
            value:'radio',
            listener:{
                click:function(){
                    alert('321');
                }          
            }
        };
        var radioType = jsUtils.loadJSObject("WidgetRadio",option,$,_,["Widget"]);
        radioObj = radioType.createNew(option);
        radioObj.init();
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });

    it('widgetFrom.radio.getValue()', function(){
        assert.equal('radio', radioObj.getValue(), 'widgetFrom.radio.getValue()没有按照预期正确获得值');
    });

    it('widgetFrom.radio.setValue()', function(){
        radioObj.setValue("test");
        assert.equal('test', radioObj.getValue(), 'widgetFrom.radio.setValue()没有按照预期正确设置值');
    });
    
});



