var chBoxName = "box1";
void function(window, document, undefined) {
	/* ȫ�����ú����� */
	$.noConflict();
	var _params = aihb.Util.paramsObj();
	var _header;
	/* ��Ӧ�����õı����ֵ� */
	var dic = {
		addBtnId : "addBtn",
		queryBtnId : "queryBtn",
		editBtnId : "editBtn",
		downBtnId : "downBtn",
		editDivId : "edit"
	};
	/* ȫ�����úͽ��� */

	/* ��ʼ������ */
	function init() {
		/* ��ѯ���� */
		var queryOptions = {
			data : [{
						label : "ҵ�����",
						elements : {
							type : "text",
							condi : " and @pt.business_code like '%@val%'"
						}
					}, {
						label : "ҵ�����",
						elements : {
							type : "text",
							condi : " and @pt.business_name like '%@val%'"
						}
					}]
		};
		var _table = createTblOptions(queryOptions);
		$("dim_div").insertBefore(_table, $("dim_div").lastChild);
		/* ��ͷ */
		_header = [{
					"name" : "ѡ��",
					"dataIndex" : "select_all",
					"cellStyle" : "grid_row_cell",
					"cellFunc" : function(value, options) {
						var ckBox = $C("<input name='" + chBoxName + "'>");
						ckBox.type = "checkbox";
						var records = options.record;
						ckBox.value = JSON.stringify(records);
						return ckBox;
					}
				}, {
					"name" : "ҵ�����",
					"dataIndex" : "business_code",
					"cellStyle" : "grid_row_cell"
				}, {
					"name" : "ҵ�����",
					"dataIndex" : "business_name",
					"cellstyle" : "grid_row_cell"
				}, {
					"name" : "����ʱ��",
					"dataIndex" : "eff_date",
					"cellstyle" : "grid_row_cell"
				}, {
					"name" : "ҵ������",
					"dataIndex" : "business_type",
					"cellstyle" : "grid_row_cell"
				}, {
					"name" : "����",
					"dataIndex" : "import_type",
					"cellstyle" : "grid_row_cell"
				}, {
					"name" : "���",
					"dataIndex" : "export_result",
					"cellstyle" : "grid_row_cell"
				}, {
					"name" : "���̶ܳ�",
					"dataIndex" : "secrecy_level",
					"cellstyle" : "grid_row_cell"
				}, {
					"name" : "ҵ����Ҫ��",
					"dataIndex" : "busi_importance",
					"cellStyle" : "grid_row_cell"
				}, {
					"name" : "�ͻ���ע�̶�",
					"dataIndex" : "attention_level",
					"cellStyle" : "grid_row_cell"
				}];

		aihb.Util.loadmask();
		aihb.Util.watermark();

		/* ����¼����� */
		$(dic.queryBtnId).onclick = query;
		$(dic.downBtnId).onclick = down;
		$(dic.editBtnId).onclick = modify;
		$(dic.addBtnId).onclick = modify;

	};
	/* ��ѯ������� */
	function query() {
		var grid = new aihb.SimpleGrid({
					header : _header,
					sql : genSQL(),
					isCached : false,
					callback : function() {
						aihb.Util.watermark();
					}
				});
		grid.run();
	}
	function down() {
		aihb.AjaxHelper.down({
					sql : genSQL(),
					header : _header
				});
	}
	function genSQL() {
		var condition = bi.genSQLConditions(document.forms[0]);
		var sql = "select '' select_all, business_code,business_name,eff_date,business_type,import_type,export_result,secrecy_level,busi_importance,attention_level from nmk.dim_rec_business_property a where 1=1 " + condition;
		return sql;
	}

	window.onload = function() {
		init();
	}

	/* �޸ġ���� */
	// һ��class
	function JPanel(id, options) {
		var oriObj = jQuery("#" + id);
		this.clear = function() {
			oriObj.html(""); // Ӧ��Ҳ����
			oriObj.dialog("destroy");
		}
		oriObj.dialog(options);
	}
	var _window;
	function modify(e) {
		if (_window) {
			_window.clear();
		}
		e = e || window.event;
		var srcObj = e.target || e.srcElement;
		var editDiv = $(dic.editDivId);
		editDiv.title = srcObj.value + "ҵ�����Բ���";
		if (dic.addBtnId === srcObj.id) {
			/* ����form */
			var datas = [{
						label : "ҵ�����: ",
						elements : {
							type : "text",
							name : "business_code"
						}
					}, {
						label : "ҵ�����: ",
						elements : {
							type : "text",
							name : "business_name"
						}
					}, {
						label : "����ʱ��: ",
						elements : {
							type : "text",
							name : "eff_date"
						}
					}, {
						label : "ҵ������: ",
						elements : {
							type : "text",
							name : "business_type"
						}
					}, {
						label : "����: ",
						elements : {
							type : "text",
							name : "import_type"
						}
					}, {
						label : "���: ",
						elements : {
							type : "text",
							name : "export_result"
						}
					}, {
						label : "���̶ܳ�: ",
						elements : {
							type : "text",
							name : "secrecy_level"
						}
					}, {
						label : "ҵ����Ҫ��: ",
						elements : {
							type : "text",
							name : "busi_importance"
						}
					}, {
						label : "�ͻ���ע�̶�: ",
						elements : {
							type : "text",
							name : "attention_level"
						}
					}];
			var queryOptions = {
				data : datas,
				tableProps : {},
				fmProps : {
					name : "form1"
				},
				rowClass : "fmRow",
				labelClass : "fmLabel",
				felClass : "fmEl"
			};
			var _table = createTblOptions(queryOptions);
			editDiv.appendChild(_table);

			var okBtnHandler = function() {

				var fm = document.form1, valArr = [];
				var colNames = ["business_code", "business_name", "eff_date", "business_type", "import_type", "export_result", "secrecy_level", "busi_importance", "attention_level"];
				if (!fm["business_code"].length)
					fm["business_code"].length = 1; // ��ֻ�õ�һ��Ԫ�ص�ʱ��length����undefined
				for (var i = 0; i < fm["business_code"].length; i++) {
					var tempArr = [];
					for (var j = 0; j < colNames.length; j++) {
						if (fm["business_code"].length == 1) {
							// ����������
							if (fm[colNames[j]]) {
								var tempVal = fm[colNames[j]].value || null; // ����ǿ��ַ����Ϊnull,��ΪJSON���""���ַ�ת����"null"
								tempArr.push(tempVal);
							} else {
								alert(colNames[j] + "Ϊ��");
							}
						} else {
							var tempVal = fm[colNames[j]][i].value;
							tempArr.push(tempVal);
						}

					}
					valArr.push(tempArr);
				};
				var jsonObj = {
					tableName : "nmk.dim_rec_business_property",
					oper : "insert" // ����
					,
					cols : ["business_code", "business_name", "eff_date", "business_type", "import_type", "export_result", "secrecy_level", "busi_importance", "attention_level"],
					vals : valArr
				};
				var jsonStr = JSON.stringify(jsonObj);
//				alert("oringinal json string : " + jsonStr);
//				alert("encoded json string : " + encodeURIComponent(jsonStr));
				var ajax = new aihb.Ajax({
							url : "/hb-bass-navigation/hbirs/action/updateDB?oper=insert",
							parameters : "json=" + jsonStr// a json string
							,
							callback : function(xmlrequest) {
								alert(xmlrequest.responseText);
								query();
							}
						});
				ajax.request();
				jp.clear();
				jQuery(this).dialog('close');
			}

			var jp = _window = new JPanel(dic.editDivId, {
						modal : true,
						height : 200,
						width : 750,
						buttons : {
							"ȡ��" : function() {
								jp.clear();
							},
							"ȷ��" : okBtnHandler
						}
					});

		} else if (dic.editBtnId === srcObj.id) {

			var datas = [];
			var vals = getCheckedVals();
			if (!vals.length) {
				alert("�������ٹ�ѡһ��!");
				return;
			}
			var crtVal = [];
			for (var i = 0; i < vals.length; i++) {
				crtVal = JSON.parse(vals[i]);
				// document.tempValForm.ids.value += crtVal["mobilephone"] + ",";
				datas.push({
							label : "ҵ�����:",
							elements : {
								type : "text",
								name : "business_code",
								value : crtVal["business_code"]
							}
						});
				datas.push({
							label : "ҵ�����: ",
							elements : {
								type : "text",
								name : "business_name",
								value : crtVal["business_name"]
							}
						});
				datas.push({
							label : "����ʱ��: ",
							elements : {
								type : "text",
								name : "eff_date",
								value : crtVal["eff_date"]
							}
						});
				datas.push({
							label : "ҵ������: ",
							elements : {
								type : "text",
								name : "business_type",
								value : crtVal["business_type"]
							}
						});
				datas.push({
							label : "����: ",
							elements : {
								type : "text",
								name : "import_type",
								value : crtVal["import_type"]
							}
						});
				datas.push({
							label : "���: ",
							elements : {
								type : "text",
								name : "export_result",
								value : crtVal["export_result"]
							}
						});
				datas.push({
							label : "���̶ܳ�: ",
							elements : {
								type : "text",
								name : "secrecy_level",
								value : crtVal["secrecy_level"]
							}
						});
				datas.push({
							label : "ҵ����Ҫ��: ",
							elements : {
								type : "text",
								name : "busi_importance",
								value : crtVal["busi_importance"]
							}
						});
				datas.push({
							label : "�ͻ���ע�̶�: ",
							elements : {
								type : "text",
								name : "attention_level",
								value : crtVal["attention_level"]
							}
						});
			}

			var queryOptions = {
				data : datas,
				tableProps : {},
				fmProps : {
					name : "form1"
				},
				rowClass : "fmRow",
				labelClass : "fmLabel",
				felClass : "fmEl"
			};
			var _table = createTblOptions(queryOptions);
			editDiv.appendChild(_table);

			var editHandler = function() {
				var fm = document.form1, valArr = [];
				var colNames = ["business_code", "business_name", "eff_date", "business_type", "import_type", "export_result", "secrecy_level", "busi_importance", "attention_level"];
				if (!fm["business_code"].length)
					fm["business_code"].length = 1; // ��ֻ�õ�һ��Ԫ�ص�ʱ��length����undefined
				for (var i = 0; i < fm["business_code"].length; i++) {
					var tempArr = [];
					for (var j = 0; j < colNames.length; j++) {
						if (fm["business_code"].length == 1) {
							// ����������
							if (fm[colNames[j]]) {
								var tempVal = fm[colNames[j]].value || null; // ����ǿ��ַ����Ϊnull,��ΪJSON���""���ַ�ת����"null"
								tempArr.push(tempVal);
							} else {
								alert(colNames[j] + "Ϊ��");
							}
						} else {
							var tempVal = fm[colNames[j]][i].value;
							tempArr.push(tempVal);
						}

					}
					valArr.push(tempArr);
				};
				var jsonObj = {
					tableName : "nmk.dim_rec_business_property",
					oper : "insert" // ����
					,
					cols : ["business_code", "business_name", "eff_date", "business_type", "import_type", "export_result", "secrecy_level", "busi_importance", "attention_level"],
					vals : valArr,
					pkCol : "business_code",
					ids : crtVal["business_code"]
				};
				var jsonStr = JSON.stringify(jsonObj);
//				alert("oringinal json string : " + jsonStr);
//				alert("encoded json string : " + encodeURIComponent(jsonStr));
				var ajax = new aihb.Ajax({
							url : "/hb-bass-navigation/hbirs/action/updateDB?oper=updateJson",
							parameters : "json=" + jsonStr// a json string
							,
							callback : function(xmlrequest) {
								alert(xmlrequest.responseText);
								query();
							}
						});
				ajax.request();
				jp.clear();
				jQuery(this).dialog('close');
			}

			var jp = _window = new JPanel(dic.editDivId, {
						modal : true,
						height : 200,
						width : 850,
						buttons : {
							"ȡ��" : function() {
								jp.clear();
								// document.tempValForm.ids.value = "";
							},
							"ȷ��" : function() {
								// some business logic
								editHandler();
								// document.tempValForm.ids.value = "";
							}
						}
					});
		}
	}
	function getCheckedVals() {
		// debugger;
		var ckBoxes = document.getElementsByName(chBoxName);
		var vals = [];
		for (var i = 0; i < ckBoxes.length; i++) {
			if (ckBoxes[i].checked)
				vals.push(ckBoxes[i].value);
		}
		return vals;
	}

}(window, window.document);