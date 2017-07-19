//mocha测试案例不能在nodejs下直接运行,需要使用testFrames里的测试工具,需要在mocha环境下执行
var assert = require("assert");
var jsUtils = require("../mochaFrame/jsUtils.js");
//引入underscore
_ = require ('underscore');
//初始化jquery对象
var cheerio = require('cheerio');
$ = cheerio.load('');
describe('com.asiainfo.zhouy.widgetCombo', function(){
    var combo;
    var option;
    before(function(){//describe执行it之前执行
        var option = {}
        WidgetCombo = jsUtils.loadJSObject("WidgetCombo",$,_,["Widget"]);
        combo = WidgetCombo.createNew(
        {                          
            id:'widgetCombo',      
            value:'005',           
            cls:'textCls',         
            data:[
                {value:'001',displayValue:'option1'}, 
                {value:'002',displayValue:'option2'},
                {value:'003',displayValue:'option3'}
            ],             
            referTo:'testDiv'        
        });     
    });
    after(function(){//describe执行it之后执行

    });
    beforeEach(function(){//describe执行每一个it之前执行

    });
    afterEach(function(){//describe执行每一个it之后执行

    });
    it('widgetCombo.test', function(){
        console.log("getValue:"+combo.getValue());
        assert.equal("005",combo.getValue(),"wrong value")
    });
});