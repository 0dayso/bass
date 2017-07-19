(function($){

	function timelineTip(data){
		var tl = $("<div>");
		
		var tl_hold=$("<div>",{id:"tl_hold","class":"tl_banner",style:"cursor:pointer;line-height:26px;height:26px;position:absolute;right:0;top:0;filter:alpha(opacity=93);opacity: 0.93;width:180px;text-align:center;font-size:12px;",text:"服务承诺"});
		
		tl_hold.append($("<c/>",{text:"×",style:"position:absolute;right:3;top:-3;font-size:10px;",title:"关闭窗口"}).click(function(){
			tl.fadeOut(200);
		}));
		
		var tl_slide=$("<ul>",{id:"tl_slide","class":"tl_banner",style:"cursor:pointer;width:180px;position:absolute;right:0;top:22px;filter:alpha(opacity=93);opacity: 0.93;"})
		tl_slide.append(
			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;"})
				.append($("<span>",{text:"预计更新时限:"})).append($("<span>",{text:data.timeline,style:"color:#FF5500"}))
		)
//		.append(
//			$("<li>",{style:"line-height:22px;padding-left:5px;color:#666;background-color:#fff;"})
//				.append($("<span>",{text:"有问题，请拨打\"数据质量专线\""}))
//		)
		
		tl.append(tl_hold).append(tl_slide).appendTo($(document.body));
		
	}

	window.timelineTip=timelineTip;

	//dialog对话框
	if(typeof aihb.Dialog == "undefined") aihb.Dialog = {};
	aihb.Dialog = function() {this.initialize.apply(this,arguments);}

	aihb.Dialog.prototype = {
		initialize : function(options){
			this.uiDialog=$("<div/>",{"class":"dialog",id:"dialog_"+options.el}).appendTo(document.body)
			var container=$("<div/>").addClass("container");
			var tit = options.title;
			var title=$("<div/>",{text:tit}).addClass("titlebar").appendTo(container);
			var self = this;
			var close=$("<a/>",{title:"点击关闭",text:"×",href:"javascript:void(0)",style:"position:absolute;right:10;top:0;font-weight:700;"})
				.click(function(){self.close();})
				.appendTo(title);
			
			
			var _element=(typeof options.el == "string")?_element=$("#"+options.el):options.el;
			
			container.append(_element);
			
			var hei = options.height;
			var wid = options.width;
			var _table = $('<table width="'+wid+'" height="'+hei+'" border="0" cellpadding="0" cellspacing="0"></table>')
			.append(
				$("<tr/>")
					.append($("<td/>",{rowspan:3}).append($("<em/>").addClass("trans left")))	
					.append($("<td/>").addClass("trans hori"))
					.append($("<td/>",{rowspan:3}).append($("<em/>").addClass("trans right")))
			)
			.append(
				$("<tr/>").append($("<td/>",{style:"border:1px solid #A0A0A0;"}).append(container))	
			)
			.append(
				$("<tr/>").append($("<td/>").addClass("trans hori"))
			)
			.appendTo(this.uiDialog);
			
			
			var mouseOverEl = options.mouseOverEl;
			if(mouseOverEl){
				var cst=null;
				mouseOverEl.mouseover(function(){
					var cX=event.clientX;
					var cY=event.clientY;
					cst=setTimeout(function(){
						var _hiddenDiv=self.uiDialog;
						if(_hiddenDiv.css("display")=="none"){
							_hiddenDiv.css("left",cX+document.body.scrollLeft- document.body.clientLeft - 130);
							
							var _newtop=cY+document.body.scrollTop- document.body.clientTop;
							if(_newtop+200>document.body.scrollHeight)_newtop-=60;
							_hiddenDiv.css("top", _newtop);
							self.open();
						}
					},800);
				});
				
				mouseOverEl.mouseout(function(){
					clearTimeout(cst);
				});
			};
			
		}
		,open:function(element){
			this.uiDialog.show(200);
		}
		
		,close:function(){
			this.uiDialog.hide(200);
		}
	};
})(jQuery);