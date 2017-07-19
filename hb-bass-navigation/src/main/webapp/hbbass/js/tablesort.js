

//-----------------------------------------------------------------------------
// sortTable(id, col, rev)
//
// id - ID of the TABLE, TBODY, THEAD or TFOOT element to be sorted.
// col - Index of the column to sort, 0 = first column, 1 = second column,
// etc.
// rev - If true, the column is sorted in reverse (descending) order
// initially.
//
// Note: the team name column (index 1) is used as a secondary sort column and
// always sorted in ascending order.
//-----------------------------------------------------------------------------

function sortTable(id, col, rev,n) 
{

 // Get the table or table section to sort.
 var tblEl = document.getElementById(id);

 // The first time this function is called for a given table, set up an
 // array of reverse sort flags.
 if (tblEl.reverseSort == null) {
 tblEl.reverseSort = new Array();
 // Also, assume the team name column is initially sorted.
 tblEl.lastColumn = 1;
 }

 // If this column has not been sorted before, set the initial sort direction.
 if (tblEl.reverseSort[col] == null)
 tblEl.reverseSort[col] = rev;

 // If this column was the last one sorted, reverse its sort direction.
 if (col == tblEl.lastColumn)
 tblEl.reverseSort[col] = !tblEl.reverseSort[col];

 // Remember this column as the last one sorted.
 tblEl.lastColumn = col;

 // Set the table display style to "none" - necessary for Netscape 6 
 // browsers.
 var oldDsply = tblEl.style.display;
 tblEl.style.display = "none";

 // Sort the rows based on the content of the specified column using a
 // selection sort.

 var tmpEl;
 var i, j;
 var minVal, minIdx;
 var testVal;
 var cmp;

 for (i = 0; i < tblEl.rows.length - 1-n; i++) 
 {

 // Assume the current row has the minimum value.
 minIdx = i;
 minVal = getTextValue(tblEl.rows[i].cells[col]);

 // Search the rows that follow the current one for a smaller value.
 for (j = i + 1; j < tblEl.rows.length-n; j++) {
 testVal = getTextValue(tblEl.rows[j].cells[col]);
 cmp = compareValues(minVal, testVal);
 // Negate the comparison result if the reverse sort flag is set.
 if (tblEl.reverseSort[col])
 cmp = -cmp;
 // Sort by the second column (team name) if those values are equal.
 if (cmp == 0 && col != 1)
 cmp = compareValues(getTextValue(tblEl.rows[minIdx].cells[1]),
 getTextValue(tblEl.rows[j].cells[1]));
 // If this row has a smaller value than the current minimum, remember its
 // position and update the current minimum value.
 if (cmp > 0) {
 minIdx = j;
 minVal = testVal;
 }
 }

 // By now, we have the row with the smallest value. Remove it from the
 // table and insert it before the current row.
 if (minIdx > i) {
 tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
 tblEl.insertBefore(tmpEl, tblEl.rows[i]);
 }
 }

 // Make it look pretty.
 makePretty(tblEl, col,n);


 // Restore the table's display style.
 tblEl.style.display = oldDsply;

 return false;
}


//-----------------------------------------------------------------------------
// Functions to get and compare values during a sort.
//-----------------------------------------------------------------------------

// This code is necessary for browsers that don't reflect the DOM constants
// (like IE).
if (document.ELEMENT_NODE == null) {
 document.ELEMENT_NODE = 1;
 document.TEXT_NODE = 3;
}

function getTextValue(el) {

 var i;
 var s;

 // Find and concatenate the values of all text nodes contained within the
 // element.
 s = "";
 for (i = 0; i < el.childNodes.length; i++)
 if (el.childNodes[i].nodeType == document.TEXT_NODE)
 s += el.childNodes[i].nodeValue;
 else if (el.childNodes[i].nodeType == document.ELEMENT_NODE &&
 el.childNodes[i].tagName == "BR")
 s += " ";
 else
 // Use recursion to get text within sub-elements.
 s += getTextValue(el.childNodes[i]);

 return normalizeString(s);
}

function compareValues(v1, v2) {

 var f1, f2;

 // If the values are numeric, convert them to floats.

 f1 = parseFloat(v1);
 f2 = parseFloat(v2);
 if (!isNaN(f1) && !isNaN(f2)) {
 v1 = f1;
 v2 = f2;
 }

 // Compare the two values.
 if (v1 == v2)
 return 0;
 if (v1 > v2)
 return 1
 return -1;
}

// Regular expressions for normalizing white space.
var whtSpEnds = new RegExp("^\\s*|\\s*$", "g");
var whtSpMult = new RegExp("\\s\\s+", "g");

function normalizeString(s) {

 s = s.replace(whtSpMult, " "); // Collapse any multiple whites space.
 s = s.replace(whtSpEnds, ""); // Remove leading or trailing white space.

 return s;
}

//-----------------------------------------------------------------------------
// Functions to update the table appearance after a sort.
//-----------------------------------------------------------------------------

// 定义样式表的名称  result_v_1和result_v_2 为单双行互动的颜色,result_v_3为排序及鼠标所在行的颜色
var rowClsNm = "result_v_1";
var rowClsNm1 = "result_v_2";
var colClsNm = "result_v_3";

// Regular expressions for setting class names.
var rowTest = new RegExp(rowClsNm, "gi");
var rowTest1 = new RegExp(rowClsNm1, "gi");
var colTest = new RegExp(colClsNm, "gi");

function makePretty(tblEl, col,n) {

 var i, j;
 var rowEl, cellEl;

 // Set style classes on each row to alternate their appearance.
 for (i = 0; i < tblEl.rows.length-n; i++) {
 rowEl = tblEl.rows[i];
 rowEl.className = rowEl.className.replace(rowTest, "");
 if (i % 2 != 0)
rowEl.className= " " + rowClsNm;
else
	rowEl.className= " " + rowClsNm1;


 rowEl.className = normalizeString(rowEl.className);

 // Set style classes on each column (other than the name column) to
 // highlight the one that was sorted.
 for (j =1; j < tblEl.rows[i].cells.length; j++) {
 cellEl = rowEl.cells[j];
 cellEl.className = cellEl.className.replace(colTest, "");
 if (j == col)
 cellEl.className += " " + colClsNm;
 cellEl.className = normalizeString(cellEl.className);
 }
 }

		 // 高亮显示排序的列,如果有必要可以把i的起始值设置小点,
		 var el = tblEl.parentNode.tHead;
		 rowEl = el.rows[el.rows.length - 1];
		 // 设置上面每列的样式表
		 for (i = 100; i < rowEl.cells.length; i++) 
		 {
		 cellEl = rowEl.cells[i];
		 cellEl.className = cellEl.className.replace(colTest, "");
		 // 高亮显示排序的列
		 if (i == col)
		 cellEl.className += " " + colClsNm;
		 cellEl.className = normalizeString(cellEl.className);
		 }
}



 // wangbt 添加 变换排序列的标题
function changeText(id)
{
    var thead=document.getElementById("resultHead"); 
    for(i=0;i<thead.children.length;i++)
    {
    	tr=thead.children.item(i);
    	for(j=0;j<tr.children.length;j++)
    	{
    		var idstr=tr.children.item(j).getAttribute("id");
    		if(id==idstr)
    		{
    			 if(tr.children.item(j).innerHTML.indexOf("↓")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			  tr.children.item(j).innerHTML+="↑";
    			 }
    		else if(tr.children.item(j).innerHTML.indexOf("↑")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			  tr.children.item(j).innerHTML+="↓";
    			 }
    		else
    			tr.children.item(j).innerHTML+="↓";
    		}
    		else
    		{
    			if(tr.children.item(j).innerHTML.indexOf("↓")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
     			 }
    		  else if(tr.children.item(j).innerHTML.indexOf("↑")!=-1)
           {
    			  tr.children.item(j).innerHTML=tr.children.item(j).innerHTML.substring(0,tr.children.item(j).innerHTML.length-1);
    			 }
    			
    		}	
    	}

    }
}
