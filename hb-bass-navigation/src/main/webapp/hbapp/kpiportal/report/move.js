/*
*  ���б��е�Ԫ�������ƶ�λ��
* @e �������б�
* 
*/
function moveDown(e)
{
	i = e.selectedIndex;
  if(i<0||i>=(e.options.length-1))
  	return;
  var o =	e.options[i];
  var o1=	e.options[i+1];
  e.options.remove(i);
  e.options.remove(i);
  e.add(o1,i);
  e.add(o,i+1);
}

/*
*  ���б��е�Ԫ�������ƶ�λ��
*  @e �������б�
* 
*/
function moveUp(e)
{
	i = e.selectedIndex;
  if(i<=0)
  	return;
  var o =	e.options[i];
	var o1=	e.options[i-1];
  e.options.remove(i);
  e.options.remove(i-1);
  e.add(o,i-1);
  e.add(o1,i);
}

/*
*  ���������б� Ԫ�����һ���  ָ����ѡ������Ŀ������Ӻ�ɾ��
* @e1 Դ�б�
* @e2 Ŀ���б�
*/

function moveOption(e1, e2){
	try{
		for(var i=0;i<e1.options.length;i++){
			if(e1.options[i].selected){
				var e = e1.options[i];
				e2.options.add(new Option(e.text, e.value));
				e1.remove(i);
				i=i-1
			}
		}
		
	}
	catch(e){}
}

function moveOption2(e1, e2){
	try{
		for(var i=0;i<e1.options.length;i++){
			if(e1.options[i].selected){
				var e = e1.options[i];
				e2.options.add(new Option(e.text, e.value));
				e1.remove(i);
				i=i-1
			}
		}
		
	}
	catch(e){}
}