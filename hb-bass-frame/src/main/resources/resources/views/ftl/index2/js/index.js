$(function(){	
	$(".l102 ul li").mouseover(function(){
     $(this).find(".sub-menu").show();
   }).mouseout(function(){
   $(this).find(".sub-menu").hide();
   }); 
	 //轮播图
	  var _index=0;
	  setInterval(function(){
			_index++;//_index = _index-1
			if(_index>2){
				_index=0;
			}
			//auto(_index);
			$(".con-top ul li").eq(_index).css("display","block").siblings().css("display","none");
		},2000);
});
function roller(){ 
	  $(".icon ul li").click(function(){	 
	  	   _index=$(this).index();
	  	  auto(_index);
	  //	$(".con-top ul li").eq(_index).css("display","block").siblings().css("display","none");
	  });	  

}
var _index=0;
function auto(_index){
	$(".con-top ul li").eq(_index).css("display","block").siblings().css("display","none");
}
