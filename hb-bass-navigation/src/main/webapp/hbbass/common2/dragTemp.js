var dragObj=new Array();
var draging=new Array();
var offsetX=new Array();
var offsetY=new Array();
dragObj[0] = document.getElementById("selectcolumns_div");
dragObj[1] = document.getElementById("chartselect_div");

draging[0] = false;
draging[1] = false;
offsetX[0] = 0;     //X方向左右偏移量
offsetY[0] = 0;     //Y方向上下偏移量
offsetX[1] = 0;     //X方向左右偏移量
offsetY[1] = 0;     //Y方向上下偏移量

dragObj[0].style.pixelLeft = 200;
dragObj[0].style.pixelTop = 200;
dragObj[1].style.pixelLeft = 200;
dragObj[1].style.pixelTop = 200;
//准备拖拽
function beforeDrag0()
{
  if (event.button != 1)return;
  offsetX[0] = document.body.scrollLeft + event.clientX-dragObj[0].style.pixelLeft;
  offsetY[0] = document.body.scrollTop + event.clientY-dragObj[0].style.pixelTop;
  dragObj[0].style.filter = "alpha(opacity=20);";
  draging[0] = true;
}

function beforeDrag1()
{
  if (event.button != 1)return;
  offsetX[1] = document.body.scrollLeft + event.clientX-dragObj[1].style.pixelLeft;
  offsetY[1] = document.body.scrollTop + event.clientY-dragObj[1].style.pixelTop;
  dragObj[1].style.filter = "alpha(opacity=20);";
  draging[1] = true;
}

//拖拽中
function onDrag()
{
  if(!draging[0]){};
  else
  {
  	dragObj[0].style.pixelLeft = document.body.scrollLeft + event.clientX-offsetX[0];
  	dragObj[0].style.pixelTop = document.body.scrollTop + event.clientY-offsetY[0];
  }
  if(!draging[1]){};
  else
  {
	  dragObj[1].style.pixelLeft = document.body.scrollLeft + event.clientX-offsetX[1];
	  dragObj[1].style.pixelTop = document.body.scrollTop + event.clientY-offsetY[1];
	}
}

//结束拖拽
function endDrag0()
{
  if (event.button != 1)return;
  draging[0] = false;
  dragObj[0].style.filter = "alpha(opacity=80);";
}

function endDrag1()
{
  if (event.button != 1)return;
  draging[1] = false;
  dragObj[1].style.filter = "alpha(opacity=80);";
}

dragObj[0].onmousedown = beforeDrag0;
dragObj[0].onmouseup = endDrag0;
dragObj[1].onmousedown = beforeDrag1;
dragObj[1].onmouseup = endDrag1;
document.onmousemove = onDrag;