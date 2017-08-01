<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>任务运行概况</title>
<script src="${mvcPath}/resources/js/d3/d3.min.js"></script>
<script src="${mvcPath}/resources/js/d3/dagre-d3.min.js"></script>
<style id="css">
text {
  font-weight: 300;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
  font-size: 14px;
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

</style>
</head>
<body>
<div>
<svg id="svg" width=200 height=390 viewBox="0 0 400 500" ></svg>
</div>
<script>

var nodeData = ${nodeData};
var g = new dagreD3.graphlib.Graph().setGraph({});

var nodes = nodeData.nodes;
for(var i=0; i<nodes.length; i++){
	g.setNode(nodes[i].id, {label: nodes[i].name, style: "fill: #afa"});
}

var edgeArr = nodeData.edges;
for(var j=0; j<edgeArr.length; j++){
	var rel = edgeArr[j].val;
	var ed = rel.split(',');
	g.setEdge(ed[0], ed[1],{lineInterpolate: 'basis', arrowheadClass: 'arrowhead'});
}

var render = new dagreD3.render();
var svg = d3.select("svg"),
inner = svg.append("g");
render(inner, g);
var xCenterOffset = (svg.attr("width") - g.graph().width) / 2;
inner.attr("transform", "translate(" + xCenterOffset + ", 20)");
svg.attr("width", g.graph().width);
svg.attr("height", g.graph().height + 40);

</script>
</body>
</html>