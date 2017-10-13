/**************************
*Desc:提交操作时遮罩
*Argument:type=0 全屏遮 1局部遮
*Author:Zery-Zhang
*Date:2014-09-18
*Version:1.0.0
**************************/
(function ($) { 
    $.fn.jqLoading =function(option) {
        var defaultVal = {
            backgroudColor: "#ECECEC",//背景色
            backgroundImage: "../resources/lib/jqLoading/image/loading.gif",//背景图片
            text: "正在处理，请稍候...",//文字 
            width: 180,//宽度
            height: 60,//高度
            type:0 //0全部遮，1 局部遮
            
        };
        var opt = $.extend({}, defaultVal, option);
        if (opt.type == 0) {
            //全屏遮
            openLayer();
        } else {
            //局部遮(当前对象应为需要被遮挡的对象)
            openPartialLayer(this);
        }
        
        //销毁对象
        if (option === "destroy") {
            closeLayer();
        }
        
        //设置背景层高
        function height () {
            var scrollHeight, offsetHeight;
            // handle IE 6
            return $(document).height();
        };
        
        //设置背景层宽
        function width() {
            var scrollWidth, offsetWidth;
            // handle IE
            return $(document).width();
        };
        
        /*==========全部遮罩=========*/
        function openLayer() {
            //背景遮罩层
            var layer = $("<div id='layer'></div>");
            layer.css({
                zIndex:9998,
                position: "absolute",
                height: height() + "px",
                width: width() + "px",
                background: "black",
                top: 0,
                left: 0,
                filter: "alpha(opacity=30)",
                opacity: 0.3
              
            });
           
           //图片及文字层
            var content = $("<div id='content'></div>");
            content.css({
                textAlign: "left",
                position:"absolute",
                zIndex: 11000,
                height: opt.height + "px",
                width: opt.width + "px",
                top: "35%",
                left: "50%",
                verticalAlign: "middle",
                background: opt.backgroudColor,
                borderRadius:"8px",
                fontSize:"12px"
            });
            
            content.append("<img style='vertical-align:middle;margin:"+(opt.height/4)+"px; 0 0 5px;margin-right:5px;' src='" + opt.backgroundImage + "' /><span style='text-align:center; vertical-align:middle;'>" + opt.text + "</span>");
            $("body").append(layer).append(content);
            var left = content.css("left").replace('px','');
            content.css("left",(parseFloat(left)-opt.width/2));
            
           return this;
        }

        //销毁对象
        function closeLayer() {
            $("#layer,#content,#partialLayer").remove();
            return this;
        }
        
        /*==========局部遮罩=========*/
        function openPartialLayer(obj) {
         
            var eheight = $(obj).css("height");//元素带px的高宽度
            var ewidth = $(obj).css("width");
            var top = $(obj).offset().top; // 元素在文档中位置 滚动条不影响
            var left = $(obj).offset().left;

            var layer = $("<div id='partialLayer'></div>");
            layer.css({
                style: 'z-index:9998',
                position: "absolute",
                height: eheight,
                width: ewidth,
                background: "black",
                top: top,
                left: left,
                filter: "alpha(opacity=60)",
                opacity: 0.6,
                borderRadius:"3px",
                dispaly: "block"
            });
            $("body").append(layer);

            return this;
        }
    };
    
})(jQuery)