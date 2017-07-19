onit=true
num=0

/*
*  @this.fromtab          @this.totab
*  @this.hiddiv          
*  @startrow          @this.startcol
*  @this.toolsflag 
*  @this.initRow   array  初时化需要进行画图的列,并将这些列选中
*  @this.initCol   array     初时化默认选择的行
*         
*/
function init_table(fromtab,totab,startrow,startcol,headtitle,initRow,initCol)
{
this.fromtab=fromtab;
this.totab=totab;

this.startrow=(startrow==null?1:startrow);
this.startcol=(startcol==null?1:startcol);
this.headtitle=headtitle;
this.initRow=initRow;
this.initCol=initCol;

this.Color=new Array("#ff00ff","#ffA6A6","##ff0000","#ffaeff","#0000ff","#84aeff","#00ffff","#a6aeff","#00ff00","#b5ffb5","#ffff00","#ffffb5","#C0C0C0","#800000","#808000","#008000","#008080","#000080","#800080")  ;
this.X_unit="x轴" ; 
this.Y_unit="y轴";
this.table_left=0;   											// 距离页面左边距离
this.table_top=0;    											// 距离页面上边距离
this.DrGroup=new Array("eval(DrGroup[i])","group2","group3");        //画了的图的记录集  

// 给源表的标题行和标题列加上复选框
this.fromtab.rows(startrow-1).cells(startrow-1).innerHTML +='<input type="checkbox" checked name="SelectRow" style="display:none"><input type="checkbox" checked name="SelectCol"  style="display:none">'
	
	if(this.initRow[1]=="0")
	{
		for(var i=startrow;i<this.fromtab.rows.length;i++)
		{
		    this.fromtab.rows(i).cells(startrow-1).innerHTML ='<input type="checkbox" checked name="SelectRow" >'+this.fromtab.rows(i).cells(startrow-1).innerHTML
		} 
	}
	else
	{
			for(var i=startrow;i<this.fromtab.rows.length;i++)
			{
			    this.fromtab.rows(i).cells(startrow-1).innerHTML ='<input type="checkbox" name="SelectRow" >'+this.fromtab.rows(i).cells(startrow-1).innerHTML
			} 
			for(i=1;i<this.initRow.length;i++)
			{
			  form1.SelectRow[this.initRow[i]].checked=true;
			}
	}

	if(this.initCol[1]=="0")
	{
		for(var i=this.startcol;i<this.fromtab.rows(startrow-1).cells.length;i++)
		{
		      this.fromtab.rows(startrow-1).cells(i).innerHTML ='<input type="checkbox"  checked name="SelectCol" >'+this.fromtab.rows(startrow-1).cells(i).innerHTML ;
		}
	}
	else
	{
			for(var i=this.startcol;i<this.fromtab.rows(startrow-1).cells.length;i++)
			{
			      this.fromtab.rows(startrow-1).cells(i).innerHTML ='<input type="checkbox"   name="SelectCol" >'+this.fromtab.rows(startrow-1).cells(i).innerHTML;
			}
			for(i=1;i<this.initCol.length;i++)
			{
			  form1.SelectCol[this.initCol[i]].checked=true;
			}
	}
	
  
	createTab();
}


function  createTab()
{

var intCol=0;
var intRow=0;

pagerow=form1.pagerow.value;  // 每页的行数
k=form1.totalrow.value;       // 总行数
p=form1.currentPage.value;    // 当前页   

var startRow=(p-1)*pagerow+1  ;   //  本页面开始行
var endRow=p*pagerow>=k?k:p*pagerow;     //  本页面结束行

// 清除上页中选中的复选框 第一行的除外
if(startRow>pagerow)
{
			for(i=1;i<startRow;i++)
		{
		   form1.SelectRow[i].checked=false;
		}
}
// 清除下页中选中的复选框 第一行的除外
if(endRow<k)
{
			for(i=parseInt(endRow+1);i<=k;i++)
		{
		  form1.SelectRow[i].checked=false;
		}
}

 
for(i=0;i<form1.SelectCol.length;i++)
{
   if(form1.SelectCol[i].checked)
	{
		intCol++;
	}
}

for(i=0;i<form1.SelectRow.length;i++)
{
    if(form1.SelectRow[i].checked)
	{
		intRow++;
	}
}

if((intCol>10&&intRow>3)||(intCol>3&&intRow>10))
{
	alert("请不要同时选择太多指标!");
	return;	
}
var temp

if(form1.direct_type.value=="zong")
{
	temp=	intRow;
  intRow=intCol;
  intCol=temp;
  
}

var hidRow=this.totab.rows.length;  // 掩藏表的行数
var hidCol=this.totab.rows(0).cells.length  ;//掩藏表的列数

if(intRow>hidRow)
{
	for(i=hidRow;i<intRow;i++)
	{
		addRow(i,this.totab.rows(0).cells.length);
	}
}
else
{
	for(i=hidRow;i>intRow;i--)
	{
		delRow(i-1);
	}
}
if(intCol>hidCol)
{
	for(i=0;i<intRow;i++)
	{
		for(j=hidCol;j<intCol;j++)
		{
			addCell(i,j);
		}
	}
}else
{
	for(i=0;i<intRow;i++)
	{
		for(j=hidCol;j>intCol;j--)
		{
			delCell(i,j-1);
		}
	}
}

var m=0,n=0;  // m为行数 n为列数
if(form1.direct_type.value=="heng")   // 横向表
{
for(i=startrow-1;i<this.fromtab.rows.length;i++)
{
	  if(this.fromtab.rows(i).cells(this.startcol-1).all('SelectRow').checked)
		{  
	   for(j=this.startcol-1;j<this.fromtab.rows(startrow-1).cells.length;j++)
		   {
			  if(this.fromtab.rows(startrow-1).cells(j).all('SelectCol').checked)
			  {
			     
			     this.totab.rows(m).cells(n).innerText=this.fromtab.rows(i).cells(j).innerText.replace(/\r\n/g,"");
				   n=n+1;
			  }
		   }
		   n=0;
		   m=m+1;
		}
	} 
	// 合并相同目标表中相同的行
		for(i=0;i<this.totab.rows.length;i++)
		{
			temp=this.totab.rows(i).cells(0).innerText;
			for(j=0;j<i;j++)
			{
				//alert(i+" "+j+" "+this.totab.rows(i).cells(j).innerText);
				if(temp==this.totab.rows(j).cells(0).innerText)
				{
					for(m=1;m<this.totab.rows(0).cells.length;m++)
					{
						this.totab.rows(j).cells(m).innerText=parseFloat(this.totab.rows(j).cells(m).innerText)+parseFloat(this.totab.rows(i).cells(m).innerText);
					}  
					delRow(i);
					i--;
				}
			}
		}
 }
 else   // 纵向表
 	{
 		for(i=startrow-1;i<this.fromtab.rows.length;i++)
   {
	  if(this.fromtab.rows(i).cells(this.startcol-1).all('SelectRow').checked)
		{  
	   for(j=this.startcol-1;j<this.fromtab.rows(startrow-1).cells.length;j++)
		   {
			  if(this.fromtab.rows(startrow-1).cells(j).all('SelectCol').checked)
			  {
			     this.totab.rows(n).cells(m).innerText=this.fromtab.rows(i).cells(j).innerText.replace(/\r\n/g,"");
				   n=n+1;
			  }
		   }
		   n=0;
		   m=m+1;
		}
	} 
	
	
	// 合并相同目标表中相同的列
	//for(i=0;i<this.totab.rows.length;i++)  
	for(i=0;i<this.totab.rows(0).cells.length;i++)   
	{
		temp=this.totab.rows(0).cells(i).innerText;
		for(j=0;j<i;j++)
		{
			//alert(i+" "+j+" "+this.totab.rows(i).cells(j).innerText);
			if(temp==this.totab.rows(0).cells(j).innerText)
			{
				for(m=0;m<this.totab.rows.length;m++)
				{
					if(m>0) 
					{
					this.totab.rows(m).cells(j).innerText=parseFloat(this.totab.rows(m).cells(i).innerText)+parseFloat(this.totab.rows(m).cells(j).innerText);
				  }
				  delCell(m,i);  
				   
				} 
        i--; 
			}
		}
	}
 }

 draw();	
}

function draw()
{
 	 if(this.totab.rows.length<2)
	{  
		if(form1.direct_type.value=="heng")
		{
		 alert("对不起!请您选择需要绘图的行.");
		 str="<font color=red>对不起!请您选择需要绘图的行.</font>";
		 return str;
		}else if(form1.direct_type.value=="zong")
		{
			alert("对不起!请您选择需要绘图的列.");
		 str="<font color=red>对不起!请您选择需要绘图的列.</font>";
		 return str;
		}	
	}
	if(this.totab.rows(0).cells.length<2)
	{  
		if(form1.direct_type.value=="heng")
		{
		 alert("对不起!请您选择需要绘图的列.");
		 str="<font color=red>对不起!请您选择需要绘图的列.</font>";
		 return str;
		}else if(form1.direct_type.value=="zong")
		{
			alert("对不起!请您选择需要绘图的行.");
		 str="<font color=red>对不起!请您选择需要绘图的行.</font>";
		 return str;
		}
	}
 
   	    this.polediv.innerHTML=drawPole();                                                                                                                                                                                                                                                                                                                                                
        this.piediv.innerHTML=drawPie();
        this.linediv.innerHTML=drawLine(); 
}

function drawPie()
{
    intTotal=0  
    k=0
    vmlpie=new Array(this.totab.rows[0].cells.length);                                                                                                                                                                                                                                                                                                                                                                              
    for (var i=1;i<this.totab.rows[0].cells.length;i++)
    {
    		intTotal+= parseFloat(this.totab.rows[1].cells[i].innerText); 	
    }
    for (var i=1;i<this.totab.rows[0].cells.length-1;i++)
    {
    	 vmlpie[i]=this.totab.rows[1].cells[i].innerText/intTotal ;
   		 k=k+vmlpie[i];
    } 
    vmlpie[this.totab.rows[0].cells.length-1]=1-k;                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                      
all_width=600;
all_height=360;
table_title=this.headtitle+"三维饼状图";
var str="";


  
str+="<v:shapetype id='Cake_3D' coordsize='21600,21600' o:spt='95' adj='11796480,5400' path='al10800,10800@0@0@2@14,10800,10800,10800,10800@3@15xe'></v:shapetype>"
str+="<v:shapetype id='3dtxt' coordsize='21600,21600' o:spt='136' adj='10800' path='m@7,l@8,m@5,21600l@6,21600e'> "
str+=" <v:path textpathok='t' o:connecttype='custom' o:connectlocs='@9,0;@10,10800;@11,21600;@12,10800' o:connectangles='270,180,90,0'/>"
str+=" <v:textpath on='t' fitshape='t'/>"
str+=" <o:lock v:ext='edit' text='t' shapetype='t'/>"
str+="</v:shapetype>"

// 输出矩形,内容为标题和图形
str+="<v:rect id='background' style='position:absolute;left:"+table_left+"px;top:"+table_top+"px;WIDTH:"+all_width+"px;HEIGHT:"+all_height+"px;' fillcolor='#EFEFEF' strokecolor='gray'>"
str+=" <v:shadow on='t' type='single' color='silver' offset='4pt,4pt'/>"
str+="</v:rect>"
  
    
// 输出标题及图形背景区域
str+="<v:group id='eval(DrGroup[i])' style='position:absolute;left:"+table_left+"px;top:"+table_top+"px;WIDTH:"+all_width+"px;HEIGHT:"+all_height+"px;' coordsize = '21000,11500'>" 
str+=" <v:Rect style='position:absolute;left:500;top:200;width:20000;height:800'filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt'>"
str+=" <table width='100%' border='0' align='center' cellspacing='0'>"
str+=" <tr>"
str+=" <td align='center' valign='middle'><div style='font-size:15pt; font-family:黑体;'><B>"+table_title+"</B></div></td>"
str+=" </tr>"
str+=" </table>"
str+=" </v:TextBox>"
str+=" </v:Rect> "

// 输出图形背景区域
str+=" <v:rect id='back' style='position:absolute;left:500;top:1000;width:20000; height:10000;' onmouseover='movereset(1)' onmouseout='movereset(0)' fillcolor='#9cf' strokecolor='#888888'>"
str+=" <v:fill rotate='t' angle='-45' focus='100%' type='gradient'/>"
str+=" </v:rect>"

str+=" <v:rect id='back' style='position:absolute;left:14500;top:1300;width:5800; height:"+parseInt((this.totab.rows[0].cells.length)*600+500)+";' fillcolor='#9cf' stroked='t' strokecolor='#0099ff'>"
str+=" <v:fill rotate='t' angle='-175' focus='100%' type='gradient'/>"
str+=" <v:shadow on='t' type='single' color='silver' offset='3pt,3pt'/>"
str+=" </v:rect>"

// 输出总数
//str+=" <v:Rect style='position:absolute;left:14600;top:1400;width:5600;height:750' fillcolor='#000000' stroked='t' strokecolor='#ffffff'>"
//str+=" <v:TextBox inset='8pt,4pt,3pt,3pt' style='font-size:10pt;'><div align='left'><font color='#ffffff'><b>总数: "+dataRound(intTotal,2)+"</b></font></div></v:TextBox>"
//str+=" </v:Rect> " 

// 输出各个分项图释
 for (var i=1;i<this.totab.rows[0].cells.length;i++)
 { 
 	 // 高亮显示的方框
   str+=" <v:Rect id='rec"+i+"' style='position:absolute;left:14600;top:"+parseInt(800+600*i)+";width:5600;height:600;display:none' fillcolor='#efefef' strokecolor='"+this.Color[i*2%19]+"'>"
   str+=" <v:fill opacity='.6' color2='fill darken(118)' o:opacity2='1.6' rotate='t' method='linear sigma' focus='100%' type='gradient'/>"
   str+=" </v:Rect>"
    
   // 色块
   str+=" <v:Rect style='position:absolute;left:14700;top:"+parseInt((i+1)*600+300)+";width:450;height:300' fillcolor='"+this.Color[i*2%19]+"' stroked='f'/>"
   // 指标名称
   str+=" <v:Rect style='position:absolute;left:15250;top:"+parseInt((i+1)*600+50)+";width:2050;height:700' filled='f' stroked='f'>"
   str+=" <v:TextBox inset='0pt,5pt,0pt,0pt' style='font-size:9pt;'><div align='left' title='"+this.totab.rows[0].cells[i].innerText+"'>"+this.totab.rows[0].cells[i].innerText+"</div></v:TextBox>"
   str+=" </v:Rect> " 
    // 指标值
   str+=" <v:Rect style='position:absolute;left:17300;top:"+parseInt((i+1)*600+50)+";width:1500;height:700' filled='f' stroked='f' >"
   str+=" <v:TextBox inset='0pt,5pt,0pt,0pt' style='font-size:9pt;'><div align='center'>"+this.totab.rows[1].cells[i].innerText+"</div></v:TextBox>"
   str+=" </v:Rect> " 
    // 百分比
   str+=" <v:Rect style='position:absolute;left:18800;top:"+parseInt((i+1)*600+50)+";width:1300;height:700' filled='f' stroked='f' >"
   str+=" <v:TextBox inset='0pt,5pt,0pt,0pt' style='font-size:9pt;'><div align='left'>"+dataRound(vmlpie[i]*100,2)+"%</div></v:TextBox>"
   str+=" </v:Rect> " 

 }	

str+="</v:group>" 

k1=180 
k4=10


for (var i=1;i<this.totab.rows[0].cells.length;i++)
{
k2=360*vmlpie[i]/2
k3=k1+k2
if(k3>=360)
k3=k3-360
kkk=5898240-11796480*vmlpie[i]

k5=3.1415926*2*(180-(k3-180))/360
R=all_height/2
txt_x = table_left+all_height/8-30+R+R*Math.sin(k5)*0.7
txt_y = table_top+all_height/14-39+R+R*Math.cos(k5)*0.7*0.5


var titlestr = "&nbsp;名称："+totab.rows[0].cells[i].innerText+"&#13;&#10;&nbsp;数值："+totab.rows[1].cells[i].innerText+"&#13;&#10;&nbsp;比例："+dataRound(vmlpie[i]*100,2)+"%&nbsp;&nbsp;"
str+=" <div style='cursor:hand;'>"
  str+=" <v:shape id='cake"+i+"' type='#Cake_3D' title='"+titlestr+"'"
  str+=" style='position:absolute;left:"+table_left+all_height/8+"px;top:"+table_top+all_height/14+"px;WIDTH:"+all_height*8/9+"px;HEIGHT:"+all_height*8/9+"px;rotation:"+k3+";z-index:"+k4+"'"
  str+=" adj='"+kkk+",0' fillcolor='"+this.Color[i*2%19]+"' onmouseover='moveup(cake"+i+","+(table_top+all_height/14)+",txt"+i+",rec"+i+")'; onmouseout='movedown(cake"+i+","+(table_top+all_height/14)+",txt"+i+",rec"+i+");'>"
  str+=" <v:fill opacity='60293f' color2='fill lighten(120)' o:opacity2='60293f' rotate='t' angle='-135' method='linear sigma' focus='100%' type='gradient'/>"
  str+=" <o:extrusion v:ext='view' on='t'backdepth='20' rotationangle='60' viewpoint='0,0'viewpointorigin='0,0' skewamt='0' lightposition='-50000,-50000' lightposition2='50000'/>"
  str+=" </v:shape>"
  str+=" <v:shape id='txt"+i+"' type='#3dtxt' style='position:absolute;left:"+txt_x+"px;top:"+txt_y+"px;z-index:20;display:none;width:50; height:18;' fillcolor='#ffffff'"
  str+=" onmouseover='ontxt(cake"+i+","+(table_top+all_height/14)+",txt"+i+",rec"+i+")'>"
  str+=" <v:fill opacity='60293f' color2='fill lighten(120)' o:opacity2='60293f' rotate='t' angle='-135' method='linear sigma' focus='100%' type='gradient'/>"
  str+=" <v:textpath style='font-family:'宋体';v-text-kern:t' trim='t' fitpath='t' string='"+dataRound(vmlpie[i]*100,2)+"%'/>"
  str+=" <o:extrusion v:ext='view' backdepth='9pt' on='t' lightposition='0,0' lightposition2='0,0'/>"
  str+=" </v:shape>" 
str+=" </div>"

k1=k1+k2*2
if(k1>=360)
k1=k1-360

if(k1>180)
k4=k4+1
else
k4=k4-1
}

return str;

}

// 画柱状图
function drawPole()
{
		var str="";
    var all_width=600;					// 图形宽度
    var all_height=360;						//图形高度
		var table_title=this.headtitle+"柱状图";             // 标题
		var value_Max=0       
		var num =this.totab.rows.length*(this.totab.rows(0).cells.length-1); 


	for(i=1;i<this.totab.rows.length;i++)
	{
		for(j=1;j<this.totab.rows(0).cells.length;j++)
		{  
			 if(value_Max<parseFloat(this.totab.rows(i).cells(j).innerText))
	     value_Max=this.totab.rows(i).cells(j).innerText   
		}
	}

value_Max = Math.round(value_Max) 
value_Max_str =""+value_Max       
temp2=0                           
if(value_Max>9)
{
	  temp=value_Max_str.substring(2,1)
    if(temp>4)
			temp2=(parseInt(value_Max/Math.pow(10,(value_Max_str.length-1)))+1)*Math.pow(10,(value_Max_str.length-1))
		 else
			  temp2=(parseInt(value_Max/Math.pow(10,(value_Max_str.length-1)))+0.5)*Math.pow(10,(value_Max_str.length-1))
}
else
{
if(value_Max>4)
  temp2=10 
else 
	 temp2=5
}

item_hight = temp2/5 
 
var xspan_width=17500/num; 

if(xspan_width>1000)
    xspan_width=1000;
var x_width=17500/(this.totab.rows(0).cells.length-1);


str+="<v:rect id='background' style='position:absolute;left:"+table_left+"px;top:"+table_top+"px;WIDTH:"+all_width+"px;HEIGHT:"+all_height+"px;' fillcolor='#EFEFEF' strokecolor='gray'>"
str+=" <v:shadow on='t' type='single' color='silver' offset='4pt,4pt'/>"
str+="</v:rect>" 

str+="<v:group id='group2' style='position:absolute;left:"+table_left+"px;top:"+table_top+"px;WIDTH:"+all_width+"px;HEIGHT:"+all_height+"px;' coordsize = '23500,12700'>" 
str+=" <v:Rect style='position:absolute;left:1500;top:200;width:20000;height:800'filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt'>"
str+=" <table width='100%' border='0' align='center' cellspacing='0'>"
str+=" <tr>"
str+=" <td align='center' valign='middle'><div style='font-size:15pt; font-family:黑体;'><B>"+table_title+"</B></div></td>"
str+=" </tr>"
str+=" </table>"
str+=" </v:TextBox>"
str+=" </v:Rect> "
     // 画背景
str+=" <v:rect id='back' style='position:absolute;left:1700;top:1200;width:18500; height:9500;' fillcolor='#9cf' strokecolor='#DFDFDF'>"
str+=" <v:fill rotate='t' angle='-45' focus='100%' type='gradient'/>"
str+=" </v:rect>"  
 // 画x和y轴
str+=" <v:line ID='X' from='1700,10700' to='20700,10700' style='z-index:2' strokecolor='#000000' strokeWeight=1pt><v:stroke EndArrow='Classic'/></v:line>"
str+=" <v:line ID='Y' from='1700,900' to='1700,10700' style='z-index:2' strokecolor='#000000' strokeWeight=1pt><v:stroke StartArrow='Classic'/></v:line>"
str+=" <v:Rect style='position:absolute;left:100;top:700;width:1500;height:500' filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='right'>"+Y_unit+"</div></v:TextBox>"
str+=" </v:Rect> " 
str+=" <v:Rect style='position:absolute;left:20200;top:10700;width:2000;height:500' filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='left'>"+X_unit+"</div></v:TextBox>"
str+=" </v:Rect> " 

// 画平行x,y轴的线形成立体感  
str+=" <v:line from='2200,1200' to='2200,10200' style='z-index:2' strokecolor='#0099FF'></v:line>"
str+=" <v:line from='2200,10200' to='20200,10200' style='z-index:2' strokecolor='#0099FF'></v:line>"
str+=" <v:line from='1700,10700' to='2200,10200' style='z-index:2' strokecolor='#0099FF'></v:line>"

for(i=0;i<5;i++)
{

str+=" <v:line from='1200,"+(10700-1600*(i+1))+"' to='1700,"+(10700-1600*(i+1))+"' style='z-index:2' strokecolor='#000000'></v:line>"
str+=" <v:line from='1700,"+(10700-1600*(i+1))+"' to='2200,"+(10200-1600*(i+1))+"' style='z-index:2' strokecolor='#0099FF'></v:line>"
str+=" <v:line from='2200,"+(10200-1600*(i+1))+"' to='20200,"+(10200-1600*(i+1))+"' style='z-index:2' strokecolor='#0099FF'></v:line>"
  // 画平行x轴虚线
str+=" <v:line from='2200,"+(10200-1600*i-900)+"' to='20200,"+(10200-1600*i-900)+"' style='z-index:2' strokecolor='#0099FF'>"
str+=" <v:stroke dashstyle='Dot'/>"
str+=" </v:line>"
// 画y轴坐标
str+=" <v:Rect style='position:absolute;left:80;top:"+(10700-1600*(i+1)-500)+";width:1500;height:500' filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='right'>"+item_hight*(i+1)+"</div></v:TextBox>"
str+=" </v:Rect> " 
}

for(i=0;i<this.totab.rows(0).cells.length;i++)
{ 
	 //画平行y轴的立体虚线  -- 800/(totab.rows(0).cells.length-1)  
 	str+=" <v:line from='"+(19700-x_width*i)+",10700' to='"+(19700-x_width*i)+",11100' style='z-index:2' strokecolor='#000000'></v:line>"

   
   xt =" " + parseInt(19700-x_width*i) +",10700,"+parseInt(19700-x_width*i+500)+",10200,"+parseInt(19700-x_width*i+500)+",1200";
   str += "<v:PolyLine dashstyle='Dot'  style='z-index:5' filled='false' Points='"+xt+"' strokeweight='0.5pt'   strokecolor='#0099FF' >\n" 	
   str+=" <v:stroke id='xpolepoly"+i+"' dashstyle='Dot'/>" ;
   str+=" </v:PolyLine>"
  // x轴方向的 标注信息 
   if(i<this.totab.rows(0).cells.length-1)
   {  
   str+=" <v:Rect style='position:absolute;left:"+parseInt(19700-x_width*(i+1))+";top:11000;width:"+x_width+";height:800' filled='false' stroked='f'>"
   str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='center' title='"+this.totab.rows(0).cells(this.totab.rows(0).cells.length-i-1).innerText+"' style='overflow:auto'>"+this.totab.rows(0).cells(this.totab.rows(0).cells.length-i-1).innerText+"</div></v:TextBox>"
   str+=" </v:Rect> " 
   }
}


var this_hight1=0;
for(i=1;i<this.totab.rows.length;i++)
{
  var st = "";
   for(j=1;j<this.totab.rows(0).cells.length;j++)
   {
     
   	 // 柱子主体输出区
   	 str+=" <v:shape  coordsize='21600,21600' o:spt='16' adj='5400' style='display:block;position:absolute; left:"+(2200+xspan_width*(i-1)*74/100+x_width*(j-1)+x_width*1/4)+";top:"+(10700-this.totab.rows(i).cells(j).innerText*8000/temp2-500)+";width:"+xspan_width+";height:"+(this.totab.rows(i).cells(j).innerText*8000/temp2+300)+";z-index:6'  fillcolor='"+this.Color[i*2%19]+"' strokecolor='#5f5f5f'>"
     str+=" <v:fill id='polebox"+i+j+"' o:opacity2='52429f' rotate='t' angle='-45' focus='100%' type='gradient'/>"
     str+=" </v:shape>"
     // 画柱子上的 数值标记 
     titletxtwidth=xspan_width<1500?1500:xspan_width;
     
     str+=" <v:Rect id='poletext"+i+j+"' style='position:absolute;display:block;z-index:12;left:"+(2200+xspan_width*(i-1)*74/100+x_width*(j-1)+x_width*1/4)+";top:"+(10700-this.totab.rows(i).cells(j).innerText*8000/temp2-1200)+";width:"+titletxtwidth+";height:500' filled='false' stroked='f'>"
		 str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:10pt;z-index:12'><div align='left'>"+this.totab.rows(i).cells(j).innerText+"</div></v:TextBox>"
		 str+=" </v:Rect> " 
		
   }
    // 画右侧标识区 
    str+=" <v:rect id='back' style='position:absolute;left:20400;top:1200;width:2900; height:"+parseInt(1700+600*(i-1))+";'z-index:3 fillcolor='#9cf' stroked='t' strokecolor='#0099ff'>"
    str+=" <v:fill rotate='t' angle='-175' focus='100%' type='gradient'/>"
    str+=" <v:shadow on='t' type='single' color='silver' offset='3pt,3pt'/>"
    str+=" </v:rect>"
   
    // 画色块
    str+=" <v:Rect style='position:absolute;left:20600;top:"+parseInt(1500+600*(i-1)+200)+";width:400;height:200;z-index:5' fillcolor='"+this.Color[i*2%19]+"' stroked='f'  />"
    str+=" <v:Rect style='position:absolute;left:21200;top:"+parseInt(1500+600*(i-1)-100)+";width:2000;height:700;z-index:5' filled='f' stroked='f'>"
    str+=" <v:TextBox inset='0pt,5pt,0pt,0pt' style='font-size:9pt;z-index:5'><div align='left' title='"+this.totab.rows(i).cells(0).innerText+"'>"+this.totab.rows(i).cells(0).innerText+"</div></v:TextBox>"
    str+=" </v:Rect> " 
}

 str += "</v:group>" 
 
 return str;
 
}
function drawLine()
{
	  var str="";
		var all_width=600;					// 图形宽度     
		var all_height=360;						//图形高度  
		var table_title=this.headtitle+"折线图";             // 标题
		var value_Max=0                           //需要处理数据源中的最大值	
		var num =this.totab.rows(0).cells.length-1;      // 数据集长度
		if(this.totab.rows(0).cells.length-1<3)
		var x_width=4400;
		else
    var x_width=18000/(this.totab.rows(0).cells.length-1);  
	for(i=1;i<this.totab.rows.length;i++)
	{
		for(j=1;j<this.totab.rows(0).cells.length;j++)
		{  
			 if(value_Max<parseFloat(this.totab.rows(i).cells(j).innerText))
	     value_Max=this.totab.rows(i).cells(j).innerText   //取出需要画图的数据集的最大值
		}
	
	}

value_Max = Math.round(value_Max)  // 取整
value_Max_str =""+value_Max        // 转为字符串
temp2=0                            // y轴坐标的最大值
if(value_Max>9)
{
	  temp=value_Max_str.substring(2,1)
    if(temp>4)
			temp2=(parseInt(value_Max/Math.pow(10,(value_Max_str.length-1)))+1)*Math.pow(10,(value_Max_str.length-1))
		 else
			  temp2=(parseInt(value_Max/Math.pow(10,(value_Max_str.length-1)))+0.5)*Math.pow(10,(value_Max_str.length-1))
}
else
{
if(value_Max>4)
  temp2=10 
else 
	 temp2=5
}

item_hight = temp2/5  //y轴每个单元格的长度


var xspan_width=16000/(num-1); //x轴每个单元格的长度
var str="";  


// 定义类
str+="<v:shapetype id='Box2' coordsize='21600,21600' o:spt='16' adj='5400'></v:shapetype>"
// 画容器 存放图表标题和图形
str+="<v:rect id='background' style='position:absolute;left:"+table_left+"px;top:"+table_top+"px;WIDTH:"+all_width+"px;HEIGHT:"+all_height+"px;' fillcolor='#EFEFEF' strokecolor='gray'>"
str+=" <v:shadow on='t' type='single' color='silver' offset='4pt,4pt'/>"
str+="</v:rect>" 

str+="<v:group  id='group3' style='position:absolute;left:"+table_left+"px;top:"+table_top+"px;WIDTH:"+all_width+"px;HEIGHT:"+all_height+"px;' coordsize = '23500,12700'>" 
str+=" <v:Rect style='position:absolute;left:1500;top:200;width:20000;height:800'filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt'>"
str+=" <table width='100%' border='0' align='center' cellspacing='0'>"
str+=" <tr>"
str+=" <td align='center' valign='middle'><div style='font-size:15pt; font-family:黑体;'><B>"+table_title+"</B></div></td>"
str+=" </tr>"
str+=" </table>"
str+=" </v:TextBox>"
str+=" </v:Rect> "

// 画背景
str+=" <v:rect id='back' style='position:absolute;left:1700;top:1200;width:18500; height:9500;' fillcolor='#9cf' strokecolor='#DFDFDF'>"
str+=" <v:fill rotate='t' angle='-45' focus='100%' type='gradient'/>"
str+=" </v:rect>"

// 画x和y轴
str+=" <v:line ID='X' from='1700,10700' to='20700,10700' style='z-index:2' strokecolor='#000000' strokeWeight=1pt><v:stroke EndArrow='Classic'/></v:line>"
str+=" <v:line ID='Y' from='1700,900' to='1700,10700' style='z-index:2' strokecolor='#000000' strokeWeight=1pt><v:stroke StartArrow='Classic'/></v:line>"
str+=" <v:Rect style='position:absolute;left:100;top:700;width:1500;height:500' filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='right'>"+Y_unit+"</div></v:TextBox>"
str+=" </v:Rect> " 
str+=" <v:Rect style='position:absolute;left:20200;top:10700;width:2000;height:500' filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='left'>"+X_unit+"</div></v:TextBox>"
str+=" </v:Rect> " 
// 画平行x,y轴的线形成立体感
str+=" <v:line from='2200,10200' to='20200,10200' style='z-index:2' strokecolor='#0099FF'></v:line>"
str+=" <v:line from='2200,1200' to='2200,10200' style='z-index:2' strokecolor='#0099FF'></v:line>"
str+=" <v:line from='1700,10700' to='2200,10200' style='z-index:2' strokecolor='#0099FF'></v:line>"

for(i=0;i<5;i++)
{
str+=" <v:line from='1200,"+(10700-1600*(i+1))+"' to='1700,"+(10700-1600*(i+1))+"' style='z-index:2' strokecolor='#000000'></v:line>"
str+=" <v:line from='1700,"+(10700-1600*(i+1))+"' to='2200,"+(10200-1600*(i+1))+"' style='z-index:2' strokecolor='#0099FF'></v:line>"
str+=" <v:line from='2200,"+(10200-1600*(i+1))+"' to='20200,"+(10200-1600*(i+1))+"' style='z-index:2' strokecolor='#0099FF'></v:line>"
// 画平行x轴虚线
str+=" <v:line from='2200,"+(10200-1600*i-900)+"' to='20200,"+(10200-1600*i-900)+"' style='z-index:2' strokecolor='#0099FF'>"
str+=" <v:stroke dashstyle='Dot'/>"
str+=" </v:line>"
// 画y轴坐标
str+=" <v:Rect style='position:absolute;left:80;top:"+(10700-1600*(i+1)-500)+";width:1500;height:500' filled='false' stroked='false'>"
str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='right'>"+item_hight*(i+1)+"</div></v:TextBox>"
str+=" </v:Rect> " 
}

var xt="";
for(i=0;i<num;i++)
{
  	// 画平行y轴的立体虚线
	str+=" <v:line from='"+(18700-xspan_width*i)+",10700' to='"+(18700-xspan_width*i)+",11100' style='z-index:2' strokecolor='#000000'></v:line>"
  xt =" " + parseInt(18700-xspan_width*i) +",10700,"+parseInt(18700-xspan_width*i+500)+",10200,"+parseInt(18700-xspan_width*i+500)+",1200";

  str += "<v:PolyLine dashstyle='Dot' id='xlinepoly"+i+"' style='z-index:5' filled='false' Points='"+xt+"' strokeweight='0.5pt'   strokecolor='#0099FF' >\n" 	
  str+=" <v:stroke id='xline"+i+"' dashstyle='Dot'/>" ;
  str+=" </v:PolyLine>"   
    //画x轴个等分点标注   标注往左移1000即得 20700-1000=19700
  str+=" <v:Rect style='position:absolute;left:"+parseInt(18700-xspan_width*i-x_width*1/2)+";top:11200;width:"+x_width+";height:500' filled='false' stroked='f'>"
  str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:9pt;'><div align='center' title='"+this.totab.rows(0).cells(num-i).innerText+"'>"+this.totab.rows(0).cells(num-i).innerText+"</div></v:TextBox>"
  str+=" </v:Rect> " 
 
}

var this_hight1=0,this_hight2=0
titlestr=new Array(this.totab.rows.length-1);
titlestr[0]="";
  
for(i=1;i<this.totab.rows.length;i++)
{
   var st = "";
   
   for(j=1;j<this.totab.rows(0).cells.length;j++)	
   {
   	 this_hight1 = this.totab.rows(i).cells(j).innerText*8300/temp2
     // 画折线交接点处的圆或矩形
      var linetitlestr = ""+this.totab.rows(i).cells(j).innerText
      str+="<v:rect style='position:absolute;left:"+parseInt((j-1)*xspan_width+1700+1300)+";top:"+parseInt(10700-this_hight1-500)+";width:300px;height:300px;z-index:6' fillcolor='"+this.Color[i*2%19]+"' strokecolor='"+this.Color[i*2%19]+"' title='"+linetitlestr+"'/>"
      
     str+=" <v:Rect style='position:absolute;display:block;z-index:12;left:"+parseInt((j-1)*xspan_width+1700+1000)+";top:"+parseInt(10700-this_hight1-1100)+";width:1500px;height:500px' filled='false' stroked='f'>"
		 str+=" <v:TextBox inset='0pt,0pt,0pt,0pt' style='font-size:10pt;z-index:12'><div align='left'>"+this.totab.rows(i).cells(j).innerText+"</div></v:TextBox>"
		 str+=" </v:Rect> " 
     
     st +=" " + parseInt((j-1)*xspan_width+1700+1400) +","+parseInt(10700-this_hight1-300)

   	}
    str += "<v:PolyLine id='linepoly"+i+"' style='z-index:5' filled='false' Points='"+st+"' strokeweight='1.5pt'  strokecolor='"+this.Color[i*2%19]+"'/>\n" 	
    // 画右侧标识区
    str+=" <v:rect id='back' style='position:absolute;left:20400;top:1200;width:2900; height:"+parseInt(1700+600*(i-1))+";'z-index:3 fillcolor='#9cf' stroked='t' strokecolor='#0099ff'>"
    str+=" <v:fill rotate='t' angle='-175' focus='100%' type='gradient'/>"
    str+=" <v:shadow on='t' type='single' color='silver' offset='3pt,3pt'/>"
    str+=" </v:rect>"
    
    // 画色块
    str+=" <v:Rect style='position:absolute;left:20600;top:"+parseInt(1500+600*(i-1)+200)+";width:400;height:200;z-index:5' fillcolor='"+this.Color[i*2%19]+"' stroked='f'/>"
    str+=" <v:Rect style='position:absolute;left:21200;top:"+parseInt(1500+600*(i-1)-100)+";width:2000;height:700;z-index:5' filled='f' stroked='f' >"
    str+=" <v:TextBox inset='0pt,5pt,0pt,0pt' style='font-size:9pt;z-index:5'><div align='left' title='"+this.totab.rows(i).cells(0).innerText+"'>"+this.totab.rows(i).cells(0).innerText+"</div></v:TextBox>"
    str+=" </v:Rect> " 
}

 str += "</v:group>" 
 return str;

}
function addRow(rIndex,cols)
{
	totab.insertRow(rIndex);
	var i;
	for(i=0;i<cols;i++)
	{
		addCell(rIndex,i)
	}
}

function delRow(rIndex)
{
	totab.deleteRow(rIndex);
}

function addCell(rIndex,cIndex)
{
	totab.rows(rIndex).insertCell(cIndex);
}

function delCell(rIndex,cIndex)
{
	totab.rows(rIndex).deleteCell(cIndex);
}
function checkNum(str)
{
	if(str==null||str==""||isNaN(str))
	{
		return 0;
	}
return str;
}


function moveup(iteam,top,txt,rec){
temp=eval(iteam)
tempat=eval(top)
temptxt=eval(txt)
temprec=eval(rec)
at=parseInt(temp.style.top)
temprec.style.display = ""; 
if (num>19){
temptxt.style.display = "";
}
if(at>(tempat-20)&&onit){
num++
temp.style.top=at-1
Stop=setTimeout("moveup(temp,tempat,temptxt,temprec)",10)
}else{
return
} 
}
function movedown(iteam,top,txt,rec){
temp=eval(iteam)
temptxt=eval(txt)
temprec=eval(rec)
clearTimeout(Stop)
temp.style.top=top
num=0
temptxt.style.display = "none";
temprec.style.display = "none";
}
function ontxt(iteam,top,txt,rec){
temp = eval(iteam);
temptxt = eval(txt);
temprec = eval(rec)
if (onit){
temp.style.top = top-20;
temptxt.style.display = "";
temprec.style.display = "";
}
}
function movereset(over)
{
if (over==1)
	{
		onit=false
	}else{
		onit=true
	}
}

function  dataRound(Input,decimal)  
{  
    Input  =  Math.round  (Input*Math.pow(10,decimal))/Math.pow(10,decimal);  
    return  Input;  
}  

function changeTab(n)
{
 /*
  if(n==0)
  { 
  	if(polediv.innerHTML=="")
  	   polediv.innerHTML=drawPole();
  	picTable.tBodies[0].style.display="block";
  	picTable.tBodies[1].style.display="none";
  	picTable.tBodies[2].style.display="none";
  }
  else if(n==1)
  {  
  	if(piediv.innerHTML=="")
  	   piediv.innerHTML=drawPie();
  	picTable.tBodies[0].style.display="none";
  	picTable.tBodies[1].style.display="block";
  	picTable.tBodies[2].style.display="none";
  }
  else if(n==2)
  { 
  	if(linediv.innerHTML=="")
  	   linediv.innerHTML=drawLine();
  	picTable.tBodies[0].style.display="none";
  	picTable.tBodies[1].style.display="none";
  	picTable.tBodies[2].style.display="block";
  }   
  */
  for(i=0;i<picTable.tBodies.length ;i++)
  {
    picTable.tBodies[i].style.display="none";
  }
  picTable.tBodies[n].style.display="block";
}  


function fenye(num)
{
	
	if(num=="+1")
	{   
		  if(parseInt(form1.currentPage.value)<parseInt(form1.totalpage.value))
		  {
	   		 form1.currentPage.value=parseInt(form1.currentPage.value)+1;
	  	}
	}
	else if(num=="-1")
	{
			if(form1.currentPage.value>1)
			{
	 			form1.currentPage.value=parseInt(form1.currentPage.value)-1;
	 		}
	}
	else
		form1.currentPage.value=num;

  if(form1.currentPage.value<1)
     form1.currentPage.value=1;
  else if(parseInt(form1.currentPage.value)>parseInt(form1.totalpage.value))
   	form1.currentPage.value=form1.totalpage.value ; 
  form1.currentPage2.value=form1.currentPage.value;
  
  // 对表格行数得显示和掩藏开始代码
   pagerow=form1.pagerow.value;  // 每页的行数
   k=form1.totalrow.value;       // 总行数
   p=form1.currentPage.value;    // 当前页   
   
  for(i=1;i<=k;i++)
  {
 			if(i>=(p-1)*pagerow+1&&i<=(p*pagerow>=k?k:p*pagerow))
   			  	eval("row"+i).style.display="block";
 			else
   				eval("row"+i).style.display="none";
  }
}

