//=====================================================================================
//  程序名：city.js
//  作用：  考虑到一个省的地市和县市不会经常变动，减少频繁访问数据库带来
//          效率问题.
//  使用：  在页面中加入类似 <script language=javascript src="../../js/city.js"></script> 
//          表单的名称要定义为 form1，地市的表单名称定义为 city，
//          县市的表单名称定义为county,由地市表单触发事件 onChange="setcity()"
//          在页面最后请调用一次 setcity()
//======================================================================================
function setcity()
{
	 switch(document.form1.city.value)
	{
               
	case '11':                            
		var labels=new Array("全部","武汉市","黄陂","蔡甸","江夏","新洲","东西湖","汉南");     
		var values=new Array("0","1101","1102","1103","1104","1105","1106","1107");
		break;                         
	case '12':                       
		var labels=new Array("全部","黄石营业区","大冶营业区","阳新营业区","下陆铁山营业区");
		var values=new Array("0","1201","1202","1203","1204");
		break;                         
	case '13':                       
		var labels=new Array("全部","鄂州营业区");                                              
		var values=new Array("0","1301");                                              
		break;                                                                       
	case '14':                                                                     
		var labels=new Array("全部","宜昌移动通信分公司","宜昌县移动经营部","当阳移动经营部","枝江移动经营部","宜都移动经营部","远安移动经营部","长阳移动经营部","五峰移动经营部","兴山移动经营部","秭归移动经营部");                                                                            
		var values=new Array("0","1400","1401","1402","1403","1404","1405","1406","1407","1408","1409");                                                      
		break;                                                                               
	case '15':                                                                             
		var labels=new Array("全部","恩施营业区","建始营业区","咸丰营业区","鹤峰营业区","巴东营业区","宣恩营业区","利川营业区","来凤营业区");                                                                            
		var values=new Array("0","1501","1502","1503","1504","1505","1506","1507","1508");                 
		break;                                          
	case '16':                                 
		var labels=new Array("全部","十堰移动分公司 ","郧县经营部","郧西经营部","丹江口市经营部","竹山经营部","房县经营部","神农架经营部","竹溪经营部","武当山经营部");           
		var values=new Array("0","1601","1602","1603","1604","1605","1606","1607","1608","1609");           
		break;                                    
	case '17':                                  
		var labels=new Array("全部","樊城区","襄阳区","枣阳 ","河口","谷城","保康","南漳","宜城","襄城区 ");                                   
		var values=new Array("0","1700","1701","1702","1703","1704","1705","1705","1707","1708");     
		break;                                       
	case '18':                                     
		var labels=new Array("全部","仙桃营业区","潜江营业区","天门营业区");                               
		var values=new Array("0","1801","1802","1803");                               
		break;                                                        
	case '19':                                                      
		var labels=new Array("全部","温泉营业部","咸安分公司","通山分公司","通城分公司","嘉鱼分公司","崇阳分公司","赤壁分公司");                                
		var values=new Array("0","1901","1902","1903","1904","1905","1906","1907");                                  
		break;                                                           
	case '20':                                                         
		var labels=new Array("全部","荆州营业区","公安营业区","洪湖营业区","监利营业区","石首营业区","松滋营业区","江凌营业区");                 
		var values=new Array("0","2001","2002","2003","2004","2005","2006","2007");                 
		break;                                          
	                                       
	case '23':                                       
		var labels=new Array("全部","荆门营业区","钟祥营业区","京山营业区","沙洋营业区");                                         
		var values=new Array("0","2301","2302","2303","2304");                                         
		break;                                                                       
	case '24':                                                                     
		var labels=new Array("全部","随州移动营业 ","广水移动营业 ","随州移动代理商");                                              
		var values=new Array("0","2400","2401","2402");                  
		break;  
		
	case '25':                                                                     
		var labels=new Array("全部","黄州营销中心(110)","蕲春分公司(130)","浠水分公司(140)","武穴分公司(150)","麻城分公司(160)","英山分公司(170)","罗田分公司(180)","黄梅分公司(190)","红安分公司(200)","团风分公司(210");                                              
		var values=new Array("0","2500","2501","2502","2503","2504","2505","2506","2507","2508","2509");                  
		break;    
		
	case '26':                                                                     
		var labels=new Array("全部","孝感营业区","汉川营业区","应城营业区","安陆营业区","孝昌营业区","大悟营业区","云梦营业区");                                              
		var values=new Array("0","2601","2602","2603","2604","2605","2607","2608");                  
		break;    
	
	case '0':
	        var labels=new Array("全部");	                                                                    
          var values=new Array("0");                                                                             
	}                                                                                     
                                                                                              
	document.form1.county.options.length=0;                                                 
                                                                                             
	for(var i=0;i<labels.length;i++)
	{
		document.form1.county.add(document.createElement("OPTION"));
		document.form1.county.options[i].text=labels[i];
		document.form1.county.options[i].value=values[i];
	}

	document.form1.county.selectedIndex=0;
	
}