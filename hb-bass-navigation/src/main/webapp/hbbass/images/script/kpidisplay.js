// JavaScript Document
function keepValue(t1,t2,t3,t4,t5,t6)
{
 this.kpi.abegintime1.value=t1;
 this.kpi.abegintime2.value=t2;
 var oOption = document.createElement('OPTION');
 oOption.value=t3;
 oOption.text=t3;
 this.kpi.abegintime3.options.add(oOption);
 this.kpi.abegintime3.value=t3;
 this.kpi.aendtime1.value=t4;
 this.kpi.aendtime2.value=t5;
 var oOption = document.createElement('OPTION');
 oOption.value=t6;
 oOption.text=t6;
 this.kpi.aendtime3.options.add(oOption);
 this.kpi.aendtime3.value=t6;
}
function keepValueMonth(t1,t2,t4,t5)
{
 this.kpi.abegintime1.value=t1;
 this.kpi.abegintime2.value=t2;
 this.kpi.aendtime1.value=t4;
 this.kpi.aendtime2.value=t5;
}
function onClickSave()
{
			kpi.action = "#";
	    	kpi.submit();
}
function onClickDetail(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_trend_detail.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickIndi(oper,area_id,supercata_id,column)
{
			indidetail.action = "./kpiReport_trend.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id+"&column="+column;
	    	indidetail.submit();
			
}
function onClickDetailMonth(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_trend_detail_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickIndiMonth(oper,area_id,supercata_id,column)
{
			indidetail.action = "./kpiReport_trend_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id+"&column="+column;
	    	indidetail.submit();
			
}
function onClickPole(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_pole.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickPoleDetail(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_pole_detail.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickPoleIndi(oper,area_id,supercata_id,column)
{
			indidetail.action = "./kpiReport_pole.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id+"&column="+column;
	    	indidetail.submit();
			
}
function onClickPoleMonth(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_pole_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickPoleDetailMonth(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_pole_detail_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickPoleIndiMonth(oper,area_id,supercata_id,column)
{
			indidetail.action = "./kpiReport_pole_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id+"&column="+column;
	    	indidetail.submit();
			
}
function onClickTrend(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_trend.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickTrendMonth(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_trend_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}

function onClickCake(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_cake.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickCakeDetail(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_cake_detail.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickCakeIndi(oper,area_id,supercata_id,column)
{
			indidetail.action = "./kpiReport_cake.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id+"&column="+column;
	    	indidetail.submit();
			
}
function onClickCakeMonth(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_cake_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickCakeDetailMonth(oper,area_id,supercata_id)
{
			kpidetail.action = "./kpiReport_cake_detail_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id;
	    	kpidetail.submit();
			
}
function onClickCakeIndiMonth(oper,area_id,supercata_id,column)
{
			indidetail.action = "./kpiReport_cake_month.jsp?oper="+oper+"&area_id="+area_id+"&supercata_id="+supercata_id+"&column="+column;
	    	indidetail.submit();
			
}
function getIndiComment(indication_id)
{
	var width=window.parent.document.body.clientWidth;
	var height=window.parent.document.body.clientHeight;
	var left=(width-400)/2;
	var top=(height-400)/2;
	var commentwindow=window.open('indicationComment.jsp?reportCode='+indication_id , "IndicationCommentWindow", "height=400, width=400, left="+left+", top="+top+", toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no")
	commentwindow.focus();
}
function selectAll()
{
	 var  chk = document.kpi.checkbox;
	 for(var p=0;p<chk.length;p++)
	    {
		document.kpi.checkbox[p].checked=true;
		}
	 
}
function selectNone()
{
     var  chk = document.kpi.checkbox;
	 for(var p=0;p<chk.length;p++)
	    {
		document.kpi.checkbox[p].checked=false;
		}

}	    
