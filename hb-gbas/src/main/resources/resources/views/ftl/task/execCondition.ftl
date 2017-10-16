<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>任务运行概况</title>
<script src="${mvcPath}/resources/js/d3/d3.min.js"></script>
<script src="${mvcPath}/resources/js/d3/dagre-d3.min.js"></script>
<style id="css">
text {
  font-weight: 200;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
  font-size: 12px;
}

.node rect {
  stroke: #333;
  fill: #fff;
  stroke-width: 1.5px;
}

.edgePath path.path {
  stroke: #333;
  fill: none;
  stroke-width: 1.5px;
}

.arrowhead {
 stroke: black;
 fill: black;
 stroke-width: 1.5px;
}

.null-msg{
	font-size: 12px;
	font-family: "MicrosoftYaHei", "Microsoft YaHei";
	color: red;
}

</style>
</head>
<body>
<div>
<div id="msg" class="null-msg" style="display:none;"><span>此任务未配置执行条件……</span></div>
<svg id="svg" width="100%" height="100%"></svg>
</div>
<script>

var nodeData = ${nodeData};
var nodes = nodeData.nodes;
var edgeArr = nodeData.edges;

if(nodes.length == 0){
	d3.select('#msg').attr("style", "display: inline");
}else{
	var g = new dagreD3.graphlib.Graph().setGraph({});

	for(var i=0; i<nodes.length; i++){
		g.setNode(nodes[i].proc, {label: nodes[i].proc, style: "fill: #afa"});
	}
	for(var j=0; j<edgeArr.length; j++){
		g.setEdge(edgeArr[j].proc_dep, edgeArr[j].proc,{lineInterpolate: 'basis', arrowheadClass: 'arrowhead'});
	}
	
	var render = new dagreD3.render();
	var svg = d3.select("svg"),
	inner = svg.append("g");
	
	//增加拖拽、缩放事件
	/**var zoom = d3.behavior.zoom().on("zoom", function() {
      inner.attr("transform", "translate(" + d3.event.translate + ")" +
                                  "scale(" + d3.event.scale + ")");
    });
	svg.call(zoom);**/
	
	render(inner, g);
	var xCenterOffset = (svg.attr("width") - g.graph().width) / 2;
	inner.attr("transform", "translate(" + xCenterOffset + ", 20)");
	svg.attr("width", g.graph().width);
	svg.attr("height", g.graph().height + 40);
}

</script>
</body>
</html>