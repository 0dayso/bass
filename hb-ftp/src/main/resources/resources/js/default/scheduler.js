/*  
 * �����࣬��������default.js
 * @author Mei Kefu
 */
/*----------------------------------  �������  ----------------------------------------*/
if(typeof aihb.Scheduler == "undefined") aihb.Scheduler = {};
aihb.Scheduler = function() {this.initialize.apply(this,arguments);}

aihb.Scheduler.prototype = {
	initialize : function (options) {
		this.options=options;
		this.container=options.container||{};
	},
	
	render : function(){
		var _div=$C("form");
		
		_div.appendChild($CT("���ڣ�"));
		var _select=$C("select");
		
		_div.appendChild(_select);
		
		_select.name="cycle";
		_select.id="tagCycle";
		
		var _cons=["��(ѭ��)","��(ѭ��)","ִ��һ��"];
		
		for(var _i=0;_i<_cons.length;_i++){
			var _option=$C("option");
			_option.value=_cons[_i];
			_option.innerText=_cons[_i];
			_select.appendChild(_option);
		}
		
		var _divTime=$C("div");
		_divTime.id="divTime";
		_divTime.appendChild($CT("ʱ�䣺"));
		var _input=$C("input");
		_input.type="text";
		_input.id="tagTime";
		_input.name="time";
		_divTime.appendChild(_input);
		_divTime.appendChild($CT("hh:mi:ss"));
		_div.appendChild(_divTime);
		
		var _divDay=$C("div");
		_divDay.id="divDay";
		_divDay.style.display="none";
		_divDay.appendChild($CT("ÿ�¼��ţ�"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagDay";
		_input.name="day";
		_divDay.appendChild(_input);
		_divDay.appendChild($CT("(С��31,L��ʾÿ�����һ��)"));
		_div.appendChild(_divDay);
		
		var _divDate=$C("div");
		_divDate.id="divDate";
		_divDate.style.display="none";
		_divDate.appendChild($CT("���ڣ�"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagDate";
		_input.name="date";
		_divDate.appendChild(_input);
		_divDate.appendChild($CT("yyyymmdd"));
		_div.appendChild(_divDate);
		
		_select.onclick=function(){
			if(this.value=="��(ѭ��)"){
					_divDay.style.display="none";
					_divDate.style.display="none";
			}else if(this.value=="ִ��һ��"){
					_divDay.style.display="none";
					_divDate.style.display="";
			}else{
					_divDay.style.display="";
					_divDate.style.display="none";
			}
		};
		
		var _triGroup=$C("div");
		_triGroup.id="_triGroup";
		_triGroup.appendChild($CT("�������飺"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagTriGroup";
		_input.name="triGroup";
		_triGroup.appendChild(_input);
		_div.appendChild(_triGroup);
		
		var _jobGroup=$C("div");
		_jobGroup.id="_jobGroup";
		_jobGroup.appendChild($CT("�������飺"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagJobGroup";
		_input.name="jobGroup";
		_jobGroup.appendChild(_input);
		_div.appendChild(_jobGroup);
		
		
		var _jobSelDiv=$C("div");
		_jobSel=$C("<input name=jobSel>");
		_jobSel.type="radio";
		_jobSel.onclick=function(){
			$("_jobClassName1").style.display="none";
			$("_jobClassName").style.display="";
		}
		_jobSelDiv.appendChild(_jobSel);
		_jobSelDiv.appendChild($CT("�Զ���Job"));
		_div.appendChild(_jobSelDiv);
		
		var _jobClassName=$C("div");
		_jobClassName.id="_jobClassName";
		_jobClassName.style.display="none";
		_jobClassName.appendChild($CT("Jobȫ������"));
		_input=$C("input");
		_input.type="text";
		_input.maxlength=20;
		_input.id="tagJobClassName";
		_input.name="jobClassName";
		_jobClassName.appendChild(_input);
		
		_div.appendChild(_jobClassName);
		
		var _jobSelDiv1=$C("div");
		var _jobSel=$C("<input name=jobSel checked=checked>");
		_jobSel.type="radio";
		_jobSel.id="builtin";
		//_jobSel.checked=this.options.builtin||false;
		_jobSel.onclick=function(){
			$("_jobClassName1").style.display="";
			$("_jobClassName").style.display="none";
		}
		_jobSelDiv1.appendChild(_jobSel);
		_jobSelDiv1.appendChild($CT("����Job"));
		_div.appendChild(_jobSelDiv1);
		
		
		var _jobClassName1=$C("div");
		_jobClassName1.id="_jobClassName1";
		//_jobClassName1.style.display="none";
		_jobClassName1.appendChild($CT("���ͣ�"));
		_select=$C("select");
		_select.id="tagBuildin";
		_select.name="jobClassName1";
		_jobClassName1.appendChild(_select);
		_div.appendChild(_jobClassName1);
		
		
		var _ds=$C("select");
		_ds.id="_ds";
		_ds[0]=new Option("���ı�","text");
		_ds[1]=new Option("Web��","web");
		_ds[2]=new Option("��ݲֿ�","");
		
		if(this.options.ds=="web"){
			_ds[1].selected = true;
		}
		_jobClassName1.appendChild($CT("���Դ���ͣ�"))
		_jobClassName1.appendChild(_ds);
		
		_ds.onchange=function(){
			if(this.value=="text"){
				_sql.childNodes[0].innerText="�����ı���";
				_tip.style.display="none";
			}else{
				_sql.childNodes[0].innerText="ȡ��SQL��";
				_tip.style.display="";
			}
		}
		
		_cons=["����","����","�ʼ�"];
		
		for(var _i=0;_i<_cons.length;_i++){
			var _option=$C("option");
			_option.value=_cons[_i];
			_option.innerText=_cons[_i];
			_select.appendChild(_option);
		}
		
		var _sql=$C("div");
		_sql.id="_sql";
		_sql.appendChild($C("span"));
		_sql.childNodes[0].innerText="�����ı���";
		_input=$C("textarea");
		_input.id="tagSql";
		_input.rows=5;
		_input.cols=60;
		_input.value=this.options.sql||"";
		_sql.appendChild(_input);
		var _tip=$C("div");
		_tip.style.display="none";
		_tip.appendChild($CT("(���ñ���@month:�������;@date:���ǰһ��)"))
		_sql.appendChild(_tip);
		_jobClassName1.appendChild(_sql);
		
		var _contacts=$C("div");
		_contacts.id="_contacts";
		_contacts.appendChild($CT("��ϵ�ˣ�"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagContacts";
		_input.value=this.options.contacts||"";
		_contacts.appendChild(_input);
		_contacts.appendChild($CT("(ʹ��;�ָ������ϵ��)"));
		_jobClassName1.appendChild(_contacts);
		
		
		var _proc=$C("div");
		_proc.id="_proc";
		_proc.appendChild($CT("��������"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagProc";
		_input.value=this.options.proc||"";
		_proc.appendChild(_input);
		_jobClassName1.appendChild(_proc);
		
		var _subject=$C("div");
		_subject.id="_subject";
		_subject.style.display="none";
		_subject.appendChild($C("span"));
		_input=$C("input");
		_input.type="text";
		_input.id="tagSubject";
		_subject.appendChild(_input);
		_subject.appendChild($CT("(���ñ���@month:�������;@date:���ǰһ��)"));
		_jobClassName1.appendChild(_subject);
		
		_select.onclick=function(){
			if(this.value=="����"){
				_subject.style.display="none";
			}else{
				_subject.style.display="";
				_subject.childNodes[0].innerText=this.value+"���⣺";
			}
		};
		var sched=this;
		var btnAdd=$C('<input type="button" value="ȷ��">');
		_div.appendChild(btnAdd);
		btnAdd.onclick=function(){
			sched.submit();
		};
		if(this.container.innerHTML.length==0)
		this.container.appendChild(_div);
	},
	
	submit : function(){
		var sched=this;
		var ajax = new aihb.Ajax({
			url : "/hb-bass-navigation/hbirs/action/scheduler?method=add"
			,parameters : sched.params()
			,loadmask : false
			,callback : function(xmlrequest){
				alert(xmlrequest.responseText);
				sched.container.parentMask.style.display="none";
			}
		});
		//alert(sched.params());
		if(confirm("ȷ����")){
			//alert(sql+" "+sched.cronExpress());
			ajax.request();
		}
	},
	
	cronExpress : function(){
		var cronExpress="";
		
		var _timeArr = $("tagTime").value.split(":")
		if(_timeArr!=""){
		
			for(var i=2;i>=0;i--){
				if(cronExpress.length>0)cronExpress+=" ";
				cronExpress+=parseInt(_timeArr[i],10);
			}
			
			var _tagCycle = $("tagCycle").value;
			
			if(_tagCycle=="��(ѭ��)"){
				cronExpress +=" * * ?";
			}else if(_tagCycle=="ִ��һ��"){
				var _date=$("tagDate").value;
				cronExpress +=" "+parseInt(_date.substring(6,8),10)+" "+parseInt(_date.substring(4,6),10)+" ? "+parseInt(_date.substring(0,4),10);
			}else{
				var _day=$("tagDay").value;
				if(_day!="L"){
					_day= parseInt(_day,10);
				}
				cronExpress +=" "+_day+" * ?";
			}
		}
		return cronExpress;
	},
	
	params : function(){
		var piece="";
		if($("builtin").checked){
			var jsonStr="{";
				jsonStr+="\"sql\":\""+encodeURIComponent($("tagSql").value)+"\"";
				jsonStr+=",\"contacts\":\""+encodeURIComponent($("tagContacts").value)+"\"";
				jsonStr+=",\"subject\":\""+encodeURIComponent($("tagSubject").value)+"\"";
				jsonStr+=",\"ds\":\""+$("_ds").value+"\"";
				jsonStr+=",\"proc\":\""+$("tagProc").value+"\"";
				
				if(this.options.msg)jsonStr+=",\"msg\":\""+this.options.msg+"\"";
				
				jsonStr+="}";
			piece+="&json="+jsonStr;
			piece+="&jobClassName=";
			
			if($("tagBuildin").value=="����"){
				piece+="com.asiainfo.hbbass.component.scheduler.job.PushSmsJob";
			}else if($("tagBuildin").value=="�ʼ�"){
				piece+="com.asiainfo.hbbass.component.scheduler.job.PushEmailJob";
			}else if($("tagBuildin").value=="����"){
				piece+="com.asiainfo.hbbass.component.scheduler.job.PushMmsJob";
			}
		}else{
			piece+="&jobClassName="+$("tagJobClassName").value
		}
		var res="triGroup="+$("tagTriGroup").value
			+"&jobGroup="+$("tagJobGroup").value
			+"&cronExpress="+this.cronExpress()
			+piece;
		
		return res;
	}
};