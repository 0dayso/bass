var xPos;
var yPos;

function showToolTip(title,msg,evt){
    if (evt) {
        var url = evt.target;
    }
    else {
        evt = window.event;
        var url = evt.srcElement;
    }
    xPos = evt.clientX+document.body.scrollLeft - document.body.clientLeft;
    yPos = evt.clientY+document.body.scrollTop  - document.body.clientTop ;

   var toolTip = document.getElementById("toolTip");
   toolTip.innerHTML = "<table border=0 width=100% cellspacing=1 cellpadding=1><tr bgcolor='#ebf3fd'><td width=85% ><h1>"+title+"</h1></td><td align=center><img src='/hbbass/common2/image/tab-close.gif' onclick='hideToolTip();'></img></td></tr><tr><td colspan=2>"+msg+"</td></tr></table>";
   toolTip.style.top = parseInt(yPos)+4 + "px";
   toolTip.style.left = parseInt(xPos)+2 + "px";
   toolTip.style.visibility = "visible";
   
  
}

function hideToolTip(){
   var toolTip = document.getElementById("toolTip");
   toolTip.style.visibility = "hidden";
}

document.ondblclick=hideToolTip;