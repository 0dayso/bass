/*
Infomation
==========================================================================================
jQuery Plugin
	Name       : jquery.ajaxComboBox
	Version    : 3.5.3
	Update     : 2010-07-18   
	Author     : sutara_lumpur
	Author-URI : http://d.hatena.ne.jp/sutara_lumpur/20090124/1232781879
	License    : MIT License (http://www.opensource.org/licenses/mit-license.php)
	Based-on   : Uses code and techniques from following libraries...
		* jquery.suggest 1.1
			Author     : Peter Vulgaris
			Author-URI : http://www.vulgarisoip.com/
==========================================================================================

Contents
==========================================================================================
	01. ComboBox�ѥå��`��������  
	02. ComboBox�ѥå��`���äΥ᥽�å�
	03. ����?��Ʒ�ζ��x
	04. ���٥�ȥϥ�ɥ�
	05. ComboBox�å᥽�å� - δ���
	06. ComboBox�å᥽�å� - Ajax�v�B
	07. ComboBox�å᥽�å� - �ک`���ʥ��v�B
	08. ComboBox�å᥽�å� - ���a�ꥹ���v�B
	09. ComboBox�å᥽�å� - ��������v�B
	10. �I����ʼ�ޤ�
==========================================================================================
*/
(function($) {
	$.ajaxComboBox = function(area_pack, source, options, msg) {
		debugger;
		//================================================================================
		// 01. ComboBox�ѥå��`��������
		//--------------------------------------------------------------------------------
		var num       = 0; //ͬ�ѥå��ڤΥܥå�������
		var box_width = $(area_pack).width();

		//************************************************************
		// ComboBox���ꥢ��ʂ�
		//************************************************************
		var $add_area = $('<div></div>')
			.addClass(options.p_add_cls);

		if(options.package){
			var $add_btn = $('<img />')
				.attr({
					'alt'   : msg['add_btn'],
					'title' : msg['add_title'],
					'src'   : options.p_add_img1
				})
				.mouseover(function (ev){
					$(ev.target).attr('src',options.p_add_img2);
				})
				.mouseout(function (ev){
					$(ev.target).attr('src',options.p_add_img1);
				})
				.click(function (){
					addPack(area_pack);
				})
				.appendTo($add_area);
		}

		//����ˡ�Box��ҤȤ�����
		if(options.init_val === false){
			addPack(area_pack);
		}else{
			for(i=0; options.init_val.length > i ;i++){
				addPack(area_pack);
			}
			options.init_val = false;
		}

		//================================================================================
		// 02. ComboBox�ѥå��`���äΥ᥽�å�
		//--------------------------------------------------------------------------------
		//************************************************************
		//ComboBox������
		//************************************************************
		function delPack(box){
			var past_id = $(area_pack).find('input[type=text]').eq(0).attr('id');
			$(box).parent().parent().remove();

			var new_id = $(area_pack).find('input[type=text]').eq(0).attr('id');
			$('label[for=' + past_id + ']').attr('for', new_id);

			delBtnShowHide();
		}

		//************************************************************
		//�����ܥ���α�ʾ?�Ǳ�ʾ���ж�
		//************************************************************
		function delBtnShowHide(){
			var box_cls_name = '#' + $(area_pack).attr('id') + ' .'+ options.p_area_cls;

			if($(box_cls_name).length == 1){
				$(box_cls_name + ' .' + options.p_del_cls).css('visibility','hidden');
			} else {
				$(box_cls_name + ' .' + options.p_del_cls).css('visibility','visible');
			}
		}

		//************************************************************
		//ComboBox��׷��
		//************************************************************
		function addPack(btn){
			num++;

			var $pack = $('<div></div>')
				.addClass(options.p_area_cls);

			var $box = $('<div></div>');

			var $del_area = $('<div></div>')
				.addClass(options.p_del_cls);

			var del_btn = $('<img />')
				.attr({
					'alt'   : msg['del_btn'],
					'title' : msg['del_title'],
					'src'   : options.p_del_img1
				})
				.mouseover(function (ev){
					$(ev.target).attr('src',options.p_del_img2);
				})
				.mouseout(function (ev){
					$(ev.target).attr('src',options.p_del_img1);
				})
				.click(function(ev){
					delPack(ev.target);
				})
				.appendTo($del_area);

			var $clear = $('<div style="clear:both"></div>');

			if(options.package){
				$box.addClass(options.p_acbox_cls);
				$pack
					.append($box)
					.append($del_area)
					.append($clear);

				$(area_pack)
					.append($pack)
					.append($add_area);

				$box.width(box_width);
				$(area_pack).width(
					box_width + $del_area.width()
				);
				$add_area.css('margin-left', $box.width());
			} else {
				$pack.append($box);
				$(area_pack).append($pack);
				$box.width($(area_pack).width());
			}

			//���􂀄e��ComboBox���ɄI������ӳ�������
			individual($box);

			delBtnShowHide();
		}

		//************************************************************
		//���􂀄e��ComboBox�����ɡ���
		//************************************************************
		function individual(area_combobox){
		
			//Ajax�ˤ����륭��å����o���ˤ���
			$.ajaxSetup({cache: false});
			
			//================================================================================
			// 03. ����?��Ʒ�ζ��x
			//--------------------------------------------------------------------------------
			//**********************************************
			//�����γ��ڻ�
			//**********************************************
			var show_hide        = false; //���a�򡢥����ީ`�I���Ǳ�ʾ���뤫�ɤ�������s
			var timer_show_hide  = false; //�����ީ`���ե��`��������줿�ᡢ���a��Ǳ�ʾ�ˤ��뤫
			var timer_delay      = false; //hold timeout ID for suggestion result_area to appear
			var timer_val_change = false; //�����ީ`����(һ���r�g���Ȥ��������Ή仯��Oҕ)
			var type_suggest     = false; //�ꥹ�ȤΥ����ס�false=>ȫ�� / true=>��y
			var page_num_all     = 1;     //ȫ����ʾ���H�Ρ��F�ڤΥک`������
			var page_num_suggest = 1;     //���a��ʾ���H�Ρ��F�ڤΥک`������
			var max_all          = 1;     //ȫ����ʾ���H�Ρ�ȫ�ک`����
			var max_suggest      = 1;     //���a��ʾ���H�Ρ�ȫ�ک`����
			var now_loading      = false; //Ajax�ǆ����Ϥ碌�Ф��ɤ�����
			var reserve_btn      = false; //�ܥ���α���ɫ�������s�����뤫�ɤ�����
			var reserve_click    = false; //�ޥ����Υ��`��Ѻ���A��������ˌ��ꤹ�뤿��mousedown���֪
			var $xhr             = false; //XMLHttp���֥������Ȥ��{
			var key_paging       = false; //���`�ǥک`���ƄӤ�������
			var key_select       = false; //���`�Ǻ��a�ƄӤ���������
			var prev_value       = '';    //ComboBox�Ρ���ǰ�΂�

			//�������
			var size_navi        = null;  //��������ʾ��(�ک`���ʥӤθߤ�)
			var size_results     = null;  //��������ʾ��(�ꥹ�Ȥ��ϖ���)
			var size_li          = null;  //��������ʾ��(���aһ�з֤θߤ�)
			var size_left        = null;  //��������ʾ��(�ꥹ�Ȥκ��)
			var select_field;             //��������ʾ�Έ��Ϥ�ȡ�ä��륫���
			
			
			if(options.sub_info){
				if(options.show_field && !options.hide_field){
					select_field = options.field + ',' + options.show_field;
				} else {
					select_field = '*';
				}
			} else {
				select_field = options.field;
				options.hide_field = '';
			}
			if(options.select_only && select_field != '*'){
				select_field += ',' + options.primary_key;
			}

			//���쥯�Ȍ��Õr���ե��`�����Ť���һ��������{����
			var primary_key = (options.select_only)
				? options.primary_key
				: '';

			//**********************************************
			//��Ʒ�ζ��x
			//**********************************************
			$(area_combobox).addClass(options.combo_class);

			var $table = $('<table cellspacing="1"><tbody><tr><th></th><td></td></tr></tbody></table>')
				.addClass(options.table_class);


			var $input = $('<input />')
				.attr({
					'type'         : 'text',
					'autocomplete' : 'off'
				})
				.addClass(options.input_class);
			if(options.cake_rule){
				//-----------------------------------
				//CakePHP�ä�name,id�������O��
				//-----------------------------------
				var field_camel = toCakeCamelCase(options.cake_field);

				if(options.package){
					//�ѥå��`��
					$input.attr({
						'name' : 'data[' + options.cake_model + '][' + options.cake_field + '][' + (num - 1) + ']',
						'id'   : options.cake_model + field_camel + (num - 1)
					});
				} else {
					//�gƷ
					$input.attr({
						'name' : 'data[' + options.cake_model + '][' + options.cake_field + ']',
						'id'   : options.cake_model + field_camel
					});
				}
			} else {
				//-----------------------------------
				//ͨ����name,id�������O��
				//-----------------------------------
				$input.attr({
					'name' : options.input_prefix + num,
					'id'   : options.input_prefix + num
				});
			}


			var $obj_th = $table.children('tbody').children('tr').children('th');

			var $button = $table.children('tbody').children('tr').children('td');
			$button.append('<img />');

			var $result_area = $('<div></div>')
				.addClass(options.re_area_class);

			var $navi = $('<div></div>')
				.addClass(options.navi_class);

			var $results = $('<ul></ul>')
				.addClass(options.results_class);

			//�������
			var $attached_tbl = $('<div></div>')
				.addClass(options.sub_info_class);

			//"���쥯�Ȍ���"���ץ������
			var $hidden = $('<input type="hidden" />')
				.attr({
					'name': $input.attr('name'),
					'id'  : $input.attr('name') + '_hidden'
				})
				.val('');

			//�ܥ����title���Գ��ڻ�
			btnAttrDefault();

			//**********************************************
			//��ʾ��ʽ��������
			//**********************************************

			$obj_th.append($input);

			$result_area.append($navi).append($results);

			$(area_combobox)
				.append($table)
				.append($result_area);

			//���쥯�Ȍ��Õr��hidden��׷��
			if(options.select_only) $(area_combobox).append($hidden);

			//�ƥ����ȥܥå����η���Q��
			$input.width(
				$(area_combobox).width() -
				$button.children('img').width() -
				parseInt($obj_th.css('padding-left')) -
				parseInt($obj_th.css('padding-right')) -
				parseInt($button.css('padding-left')) -
				parseInt($button.css('padding-right')) -
				parseInt($button.css('border-left-width')) -
				parseInt($button.css('border-right-width')) -
				parseInt($table.css('border-left-width')) -
				parseInt($table.css('border-right-width')) -
				3 //�Ʃ`�֥��"border-spacing:1px��3"�΂�

				//IE8�Ǥ�'border-spacing'�΂���ȡ�äǤ��ʤ����ᡢ����
				// - (parseInt($table.css('border-spacing')) * 3)
			);

			//ComboBox�˳��ڂ�����
			setInitVal();

			//================================================================================
			// 04. ���٥�ȥϥ�ɥ�
			//--------------------------------------------------------------------------------
			//**********************************************
			//ȫ��ȡ�åܥ���
			//**********************************************
			$button.mouseup(function(ev) {
				if($result_area.css('display') == 'none') {
					clearInterval(timer_val_change);
					
					type_suggest = false;
					suggest();
					
					$input.focus();
				} else {
					hideResult();
				}
				ev.stopPropagation();
			});
			$button.mouseover(function() {
				reserve_btn = true;
				if (now_loading) return;
				$button
					.addClass(options.btn_on_class)
					.removeClass(options.btn_out_class);
			});
			$button.mouseout(function() {
				reserve_btn = false;
				if (now_loading) return;
				$button
					.addClass(options.btn_out_class)
					.removeClass(options.btn_on_class);
			});
			//�����mouseout��״�B
			$button.mouseout();

			//**********************************************
			//�ƥ������������ꥢ
			//**********************************************
			//ǰ�I��(�������֥饦����)
			if ($.browser.mozilla || $.browser.opera) {
				$input.keypress(processKey);
			}else{
				$input.keydown(processKey);
			}
			$input.focus(function() {
				show_hide = true;
				checkValChange();
			});
			$input.blur(function(ev) {
				//�������αOҕ����ֹ
				clearTimeout(timer_val_change);

				//���a��ȥ����s
				show_hide = false;

				//��ȥ��s�����ީ`�򥻥å�
				checkShowHide();

				//���쥯��״�B��_�J
				btnAttrDefault();
			});
			$input.mousedown(function(ev) {
				reserve_click = true;

				//��ȥ��s�����ީ`����ֹ
				clearTimeout(timer_show_hide);

				ev.stopPropagation();
			});
			$input.mouseup(function(ev) {
				$input.focus();
				reserve_click = false;
				ev.stopPropagation();
			});

			//**********************************************
			//�ک`���ʥ�
			//**********************************************
			$navi.mousedown(function(ev) {
				reserve_click = true;

				//��ȥ��s�����ީ`����ֹ
				clearTimeout(timer_show_hide);

				ev.stopPropagation();
			});
			$navi.mouseup(function(ev) {
				$input.focus();
				reserve_click = false;
				ev.stopPropagation();
			});

			//**********************************************
			//�������
			//**********************************************
			$attached_tbl.mousedown(function(ev) {
				reserve_click = true;

				//��ȥ��s�����ީ`����ֹ
				clearTimeout(timer_show_hide);
				ev.stopPropagation();
			});
			$attached_tbl.mouseup(function(ev) {
				$input.focus();
				reserve_click = false;
				ev.stopPropagation();
			});

			//**********************************************
			//bodyȫ��
			//**********************************************
			$('body').mouseup(function() {
				//��ȥ��s�����ީ`����ֹ
				clearTimeout(timer_show_hide);

				//���a����ȥ����
				show_hide = false;
				hideResult();
			});

			//================================================================================
			// 05. ComboBox�å᥽�å� - δ���
			//--------------------------------------------------------------------------------
			//**********************************************
			//CakePHP�äˡ��ե��`�������UpperCamelCase��
			//**********************************************
			// @param text str ��Qǰ��������
			function toCakeCamelCase(str){
				return str.replace(
					/^.|_./g,
					function(match){
						return match
							.replace(/_(.)/, '$1')
							.toUpperCase();
					}
				);
			}

			//**********************************************
			//ComboBox�˳��ڂ�����
			//**********************************************
			function setInitVal(){
				if(options.init_val === false) return;

				if(options.select_only){
					//------------------------------------------
					//���쥯�Ȍ��äؤ΂�����
					//------------------------------------------
					//hidden�؂�����
					$hidden.val(options.init_val[num - 1]);

					//�ƥ����ȥܥå����؂�����
					var init_val_data = '';
					var $xhr2 = $.get(
						options.init_src,
						{
							'q_word'      : options.init_val[num - 1],
							'field'       : options.field,
							'primary_key' : options.primary_key,
							'db_table'    : options.db_table
						},
						function(data){
							$input.val(data);
							prev_value = data;

							//�x�k״�B
							$button.attr('title',msg['select_ok']);
							$button.children('img').attr({
								'src'   : options.select_ok_img,
								'alt'   : msg['get_all_alt'],
								'title' : msg['select_ok']
							});
						}
					);
				} else {
					//------------------------------------------
					//ͨ���Ρ��ƥ����ȥܥå����ؤ΂�����
					//------------------------------------------
					prev_value = options.init_val[num - 1];
					$input.val(options.init_val[num - 1]);
				}
			}

			//**********************************************
			//�x�k���a��׷�������ƻ���򥹥����`��
			//**********************************************
			//���`�����ˤ����a�Ƅӡ��ک`���ƄӤΤߤ��m��
			//
			// @param boolean enforce �Ƅ��Ȥ�ƥ����ȥܥå����ˏ��Ƥ��뤫��
			function scrollWindow(enforce) {

				//------------------------------------------
				//ʹ�ä���������x
				//------------------------------------------
				var $current_result = getCurrentResult();

				var target_top = ($current_result && !enforce)
					? $current_result.offset().top
					: $table.offset().top;

				var target_size;
				if(options.sub_info){
					var $tbl = $attached_tbl.children('table:visible');
					target_size =
						$tbl.height() +
						parseInt($tbl.css('border-top-width'), 10) +
						parseInt($tbl.css('border-bottom-width'), 10);

				} else {
					setSizeLi();
					target_size = size_li;
				}

				var client_height = document.documentElement.clientHeight;

				var scroll_top = (document.documentElement.scrollTop > 0)
					? document.documentElement.scrollTop
					: document.body.scrollTop;

				var scroll_bottom = scroll_top + client_height - target_size;

				//------------------------------------------
				//�������`��I��
				//------------------------------------------
				var gap;
				if ($current_result.length) {
					if(target_top < scroll_top || target_size > client_height) {
						//�Ϥإ������`��
						//���֥饦���θߤ������`���åȤ���ͤ����Ϥ⤳����ط�᪤��롣
						gap = target_top - scroll_top;

					} else if (target_top > scroll_bottom) {
						//�¤إ������`��
						gap = target_top - scroll_bottom;

					} else {
						//�������`����Ф��ʤ�
						return;
					}

				} else if (target_top < scroll_top) {
					gap = target_top - scroll_top;
				}
				window.scrollBy(0, gap);
			}
			//**********************************************
			//�ܥ����title���ԉ��
			//**********************************************
			//���ڻ� & ���쥯�Ȍ��Õr�η��
			function btnAttrDefault() {

				if(options.select_only){

					if($input.val() != ''){
						if($hidden.val() != ''){

							//�x�k״�B
							$button.attr('title',msg['select_ok']);
							$button.children('img').attr({
								'src'   : options.select_ok_img,
								'alt'   : msg['get_all_alt'],
								'title' : msg['select_ok']
							});
							return;
						} else {

							//����;��
							$button.attr('title',msg['select_ng']);
							$button.children('img').attr({
								'src'   : options.select_ng_img,
								'alt'   : msg['get_all_alt'],
								'title' : msg['select_ng']
							});
							return;
						}
					} else {
						//��ȫ�ʳ���״�B�ؑ���
						$hidden.val('');
					}
				}
				//����״�B
				$button.attr('title',msg['get_all_btn']);
				$button.children('img').attr({
					'src'   : options.button_img,
					'alt'   : msg['get_all_alt'],
					'title' : msg['get_all_btn']
				});
			}
			//�]����
			function btnAttrClose() {
				$button.attr('title',msg['close_btn']);
				$button.children('img').attr({
					'src'   : options.load_img,
					'alt'   : msg['close_alt'],
					'title' : msg['close_btn']
				});
			}
			//���`����
			function btnAttrLoad() {
				$button.attr('title',msg['loading']);
				$button.children('img').attr({
					'src'   : options.load_img,
					'alt'   : msg['loading_alt'],
					'title' : msg['loading']
				});
			}

			//**********************************************
			//�����ީ`�ˤ���������仯�Oҕ
			//**********************************************
			function checkValChange() {
				timer_val_change = setTimeout(isChange,500);

				function isChange() {
					now_value = $input.val();

					if(now_value != prev_value) {

						//���쥯�Ȍ��Õr
						if(options.select_only){
							$hidden.val('');
							btnAttrDefault();
						}
						//�ک`������ꥻ�å�
						page_num_suggest = 1;
						
						type_suggest = true;
						suggest();
					}
					prev_value = now_value;

					//һ���r�g���ȤαOҕ�����_
					checkValChange();
				}
			}

			//**********************************************
			//���a����ȥ�򱾵��ˌg�Ф��뤫�ж�
			//**********************************************
			function checkShowHide() {
				timer_show_hide = setTimeout(function() {
					if (show_hide == false && reserve_click == false){
						hideResult();
					}
				},500);
			}

			//**********************************************
			//���`�����ؤΌ���
			//**********************************************
			function processKey(e) {
				if (
					(/27$|38$|40$|^9$/.test(e.keyCode) && $result_area.is(':visible')) ||
					(/^37$|39$|13$|^9$/.test(e.keyCode) && getCurrentResult()) ||
					/40$/.test(e.keyCode)
				) {
					if (e.preventDefault)  e.preventDefault();
					if (e.stopPropagation) e.stopPropagation();

					e.cancelBubble = true;
					e.returnValue  = false;

					switch(e.keyCode) {
						case 37: // left
							if (e.shiftKey) firstPage();
							else            prevPage();
							break;

						case 38: // up
							key_select = true;
							prevResult();
							break;

						case 39: // right
							if (e.shiftKey) lastPage();
							else            nextPage();
							break;

						case 40: // down
							if (!$result_area.is(':visible') && !getCurrentResult()){
								type_suggest = false;
								suggest();
							} else {
								key_select = true;
								nextResult();
							}
							break;

						case 9:  // tab
							key_paging = true;
							hideResult();
							break;

						case 13: // return
							selectCurrentResult();
							break;

						case 27: //	escape
							key_paging = true;
							hideResult();
							break;
					}

				} else {
					checkValChange();
				}
			}

			//**********************************************
			//���`�ɻ���α�ʾ?���
			//**********************************************
			function setLoadImg() {
				now_loading = true;
				btnAttrLoad();
			}
			function clearLoadImg() {
				$button.children('img').attr('src' , options.button_img);
				now_loading = false;
				if(reserve_btn) $button.mouseover(); else $button.mouseout();
			}

			//================================================================================
			// 06. ComboBox�å᥽�å� - Ajax�v�B
			//--------------------------------------------------------------------------------
			//**********************************************
			//Ajax���ж�
			//**********************************************
			function abortAjax() {
				if ($xhr){
					//jQuery1.4.3�Ǥϡ���ӛ��IE7�÷�᪤ϱ�Ҫ�ʤ��ʤ�Ϥ�
					if($.browser.msie && $.browser.version == '7.0') return;
					$xhr.abort();
					$xhr = false;
					clearLoadImg();
				}
			}

			//**********************************************
			//Ajaxͨ��
			//**********************************************
			function suggest(){
				var q_word         = (type_suggest) ? $.trim($input.val()) : '';
				//q_word = encodeURIComponent(q_word); // ������������
				//alert(q_word);
				var which_page_num = (type_suggest) ? page_num_suggest : page_num_all;

				if (type_suggest && q_word.length < options.minchars){ 
					hideResult();
					
				} else {
					//Ajaxͨ�Ť򥭥�󥻥�
					abortAjax();

					//���������ȥ
					$attached_tbl.children('table').css('display','none');

					setLoadImg();

					//������Ajaxͨ�Ť��ФäƤ���
					$xhr = $.post(
						options.source,
						{
							'q_word'      : q_word,
							'page_num'    : which_page_num,
							'per_page'    : options.per_page,
							'field'       : options.field,
							'show_field'  : options.show_field,
							'hide_field'  : options.hide_field,
							'select_field': select_field,
							'order_field' : options.order_field,
							'order_by'    : options.order_by,
							'primary_key' : primary_key,
							'db_table'    : options.db_table
						},
						function(json_data, status){
							//�B�A��Ajaxͨ�Ť���ȡ�ͨ�Ť�ʧ�����Ƒ��ꂎ�Υǩ`�����դΈ��Ϥ�����
							//���Τ���ˡ�json_data���������å����롣
							debugger;
							if(!json_data || status != 'success'){
								hideResult();
								return;
							}
							//added by me for changed the query function from $.getjson to $.post, so that the json_data become a string
							if(typeof json_data == 'string'){
							eval("json_data = (" + json_data + ")");
							}
							if(!json_data.candidate){
								//һ�¤���ǩ`��Ҋ�Ĥ���ʤ��ä�
								hideResult();
							} else {
								//ȫ������1�ک`��������򳬤��ʤ����ϡ��ک`���ʥӤϷǱ�ʾ
								if(json_data.cnt > json_data.cnt_page){
									setNavi(json_data.cnt, json_data.cnt_page, which_page_num);
								} else {
									$navi.css('display','none');
								}

								//���a�ꥹ��(arr_candidate)
								var arr_candidate = [];
								$.each(json_data.candidate, function(i,obj){
									arr_candidate[i] = obj.replace(
										new RegExp(q_word, 'ig'),
										function(q_word) {
											return '<span class="' + options.match_class + '">' + q_word + '</span>';
										}
									);
								});

								//�������(arr_attached)
								var arr_attached = [];
								if(json_data.attached){
									$.each(json_data.attached,function(i,obj){
										arr_attached[i] = obj;
									});
								} else {
									arr_attached = false;
								}

								//���쥯�Ȍ���(arr_primary_key)
								var arr_primary_key = [];
								if(json_data.primary_key){
									$.each(json_data.primary_key,function(i,obj){
										arr_primary_key[i] = obj;
									});
								} else {
									arr_primary_key = false;
								}
								displayItems(arr_candidate, arr_attached, arr_primary_key);
							}
							clearLoadImg();
							selectFirstResult();
						}
					);
				}
			}
				
			//================================================================================
			// 07. ComboBox�å᥽�å� - �ک`���ʥ��v�B
			//--------------------------------------------------------------------------------
			//**********************************************
			//�ʥӲ��֤�����
			//**********************************************
			// @param integer cnt         DB����ȡ�ä������a����
			// @param integer page_num    ȫ�����ޤ�����y���a��һ�E�Υک`����
			function setNavi(cnt, cnt_page, page_num) {

				var num_page_top = options.per_page * (page_num - 1) + 1;
				var num_page_end = num_page_top + cnt_page - 1;

				//var cnt_result = msg['page_info']
				var cnt_result = msg['page_info']
					.replace('cnt'          , cnt)
					.replace('num_page_top' , num_page_top)
					.replace('num_page_end' , num_page_end);

				$navi.text(cnt_result);

				var navi_p = $('<p></p>'); //�ک`���󥰲��֤Υ��֥�������
				var max    = Math.ceil(cnt / options.per_page); //ȫ�ک`����

				//�ک`����
				if (type_suggest) {
					max_suggest = max;
				}else{
					max_all = max;
				}

				//��ʾ����һ�B�Υک`�����Ť����Ҷ�
				var left  = page_num - Math.ceil ((options.navi_num - 1) / 2);
				var right = page_num + Math.floor((options.navi_num - 1) / 2);

				//�F�ک`�����˽����Έ��Ϥ�left,right���{��
				while(left < 1){ left ++;right++; }
				while(right > max){ right--; }
				while((right-left < options.navi_num - 1) && left > 1){ left--; }

				//----------------------------------------------
				//�ک`���󥰲��֤�����

				//��<< ǰ�ء��α�ʾ
				if(page_num == 1) {
					if(!options.navi_simple){
						$('<span></span>')
							.text('<< 1')
							.addClass('page_end')
							.appendTo(navi_p);
					}
					$('<span></span>')
						.text(msg['prev'])
						.addClass('page_end')
						.appendTo(navi_p);
				} else {
					if(!options.navi_simple){
						$('<a></a>')
							.attr({'href':'javascript:void(0)','class':'navi_first'})
							.text('<< 1')
							.attr('title', msg['first_title'])
							.appendTo(navi_p);
					}
					$('<a></a>')
						.attr({'href':'javascript:void(0)','class':'navi_prev'})
						.text(msg['prev'])
						.attr('title', msg['prev_title'])
						.appendTo(navi_p);
				}

				//���ک`���ؤΥ�󥯤α�ʾ
				for (i = left; i <= right; i++)
				{
					//�F�ڤΥک`�����Ť�<span>�Ǉ��(���{��ʾ��)
					var num_link = (i == page_num) ? '<span class="current">'+i+'</span>' : i;

					$('<a></a>')
						.attr({'href':'javascript:void(0)','class':'navi_page'})
						.html(num_link)
						.appendTo(navi_p);
				}

				//���Τ�X�� >>���α�ʾ
				if(page_num == max) {
					$('<span></span>')
						.text(msg['next'])
						.addClass('page_end')
						.appendTo(navi_p);
					if(!options.navi_simple){
						$('<span></span>')
							.text(max + ' >>')
							.addClass('page_end')
							.appendTo(navi_p);
					}
				} else {
					$('<a></a>')
						.attr({'href':'javascript:void(0)','class':'navi_next'})
						.text(msg['next'])
						.attr('title', msg['next_title'])
						.appendTo(navi_p);
					if(!options.navi_simple){
						$('<a></a>')
							.attr({'href':'javascript:void(0)','class':'navi_last'})
							.text(max + ' >>')
							.attr('title', msg['last_title'])
							.appendTo(navi_p);
					}
				}

				//�ک`���ʥӤα�ʾ�����٥�ȥϥ�ɥ���O���ϱ�Ҫ�ʈ��ϤΤ��Ф�
				if (max > 1) {
					$navi.append(navi_p).show();

					//----------------------------------------------
					//�ک`���󥰲��֤Υ��٥�ȥϥ�ɥ�

					//��<< 1���򥯥�å�
					$('.navi_first').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						firstPage();
					});

					//��< ǰ�ء��򥯥�å�
					$('.navi_prev').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						prevPage();
					});

					//���ک`���ؤΥ�󥯤򥯥�å�
					$('.navi_page').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();

						if(!type_suggest){
							page_num_all = parseInt($(this).text(), 10);
						}else{
							page_num_suggest = parseInt($(this).text(), 10);
						}
						suggest();
					});

					//���Τ� >���򥯥�å�
					$('.navi_next').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						nextPage();
					});

					//��max >>���򥯥�å�
					$('.navi_last').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						lastPage();
					});
				}
			}

			//**********************************************
			//�ک`���ʥӲ���
			//**********************************************
			//1�ک`��Ŀ��
			function firstPage() {
				if(!type_suggest) {
					if (page_num_all > 1) {
						page_num_all = 1;
						suggest();
					}
				}else{
					if (page_num_suggest > 1) {
						page_num_suggest = 1;
						suggest();
					}
				}
			}
			//ǰ�Υک`����
			function prevPage() {
				if(!type_suggest){
					if (page_num_all > 1) {
						page_num_all--;
						suggest();
					}
				}else{
					if (page_num_suggest > 1) {
						page_num_suggest--;
						suggest();
					}
				}
			}
			//�ΤΥک`����
			function nextPage() {
				if(!type_suggest){
					if (page_num_all < max_all) {
						page_num_all++;
						suggest();
					}
				} else {
					if (page_num_suggest < max_suggest) {
						page_num_suggest++;
						suggest();
					}
				}
			}
			//����Υک`����
			function lastPage() {
				if(!type_suggest){
					if (page_num_all < max_all) {
						page_num_all = max_all;
						suggest();
					}
				}else{
					if (page_num_suggest < max_suggest) {
						page_num_suggest = max_suggest;
						suggest();
					}
				}
			}

			//================================================================================
			// 08. ComboBox�å᥽�å� - ���a�ꥹ���v�B
			//--------------------------------------------------------------------------------
			//**********************************************
			//���aһ�E��<ul>���Ρ���ʾ
			//**********************************************
			// @params array arr_candidate   DB�������?ȡ�ä�����������
			// @params array arr_attached    ������������
			// @params array arr_primary_key �����`������
			//
			//arr_candidate���줾��΂���<li>�Ǉ��Ǳ�ʾ��
			//ͬ�r�ˡ����٥�ȥϥ�ɥ��ӛ����
			function displayItems(arr_candidate, arr_attached, arr_primary_key) {

				if (arr_candidate.length == 0) {
					hideResult();
					return;
				}

				//���a�ꥹ�Ȥ�һ���ꥻ�å�
				$results.empty();
				$attached_tbl.empty();

				for (var i = 0; i < arr_candidate.length; i++) {

					//���a�ꥹ��
					var $li = $('<li>' + arr_candidate[i] + '</li>');

					//���쥯�Ȍ���
					if(options.select_only){
						$li.attr('id', arr_primary_key[i]);
					}

					$results.append($li);

					//�������ΥƩ`�֥������
					if(arr_attached){
						var $tbl = $('<table><tbody></tbody></table>');

						for (var j=0; j < arr_attached[i].length; j++) {

							//th�΄e�����������
							if(options.sub_as[arr_attached[i][j][0]] != null){
								var th_name = options.sub_as[arr_attached[i][j][0]];
							} else {
								var th_name =  arr_attached[i][j][0];
							}

							var $tr = $('<tr></tr>');
							$tr.append('<th>' + th_name + '</th>');
							$tr.append('<td>' + arr_attached[i][j][1] + '</td>');
							$tbl.children('tbody').append($tr);
						}
						$attached_tbl.append($tbl);
					}
				}
				//����˱�ʾ
				if(arr_attached) $attached_tbl.insertAfter($results);

				$result_area
					.show()
					.width(
						$table.width() +
						parseInt($table.css('border-left-width')) +
						parseInt($table.css('border-right-width'))
					);

				$results
					.children('li')
					.mouseover(function() {

						//Firefox�Ǥϡ����aһ�E���Ϥ˥ޥ������`���뤬�\�äƤ����
						//���ޤ��������`�뤷�ʤ������Τ���Ό��ߡ����٥���жϡ�
						if (key_select) {
							key_select = false;
							return;
						}

						//���������ʾ
						setSubInfo(this);

						$results.children('li').removeClass(options.select_class);
						$(this).addClass(options.select_class);
					})
					.mousedown(function(e) {
						reserve_click = true;

						//��ȥ��s�����ީ`����ֹ
						clearTimeout(timer_show_hide);
						//ev.stopPropagation();
					})
					.mouseup(function(e) {
						reserve_click = false;

						//Firefox�Ǥϡ����aһ�E���Ϥ˥ޥ������`���뤬�\�äƤ����
						//���ޤ��������`�뤷�ʤ������Τ���Ό��ߡ����٥���жϡ�
						if (key_select) {
							key_select = false;
							return;
						}
						e.preventDefault();
						e.stopPropagation();
						selectCurrentResult();
					});

				//�ܥ����title���ԉ��(�]����)
				btnAttrClose();
			}

			//**********************************************
			//���a���ꥢ�β���
			//**********************************************
			//�F���x�k�Фκ��a��ȡ��
			// @return object current_result �F���x�k�Фκ��a�Υ��֥�������(<li>Ҫ��)
			function getCurrentResult() {

				if (!$result_area.is(':visible')) return false;

				var $current_result = $results.children('li.' + options.select_class);

				if (!$current_result.length) $current_result = false;

				return $current_result;
			}
			//�F���x�k�Фκ��a�˛Q������
			function selectCurrentResult() {

				//�x�k���a��׷�������ƥ������`��
				scrollWindow(true);

				var $current_result = getCurrentResult();

				if ($current_result) {
					$input.val($current_result.text());
					hideResult();

					//added
					prev_value = $input.val();

					//���쥯�Ȍ���
					if(options.select_only){
						$hidden.val($current_result.attr('id'));
						btnAttrDefault();
					}
				}
				$input.focus();  //�ƥ����ȥܥå����˥ե��`�������Ƥ�
				$input.change(); //�ƥ����ȥܥå����΂������ä����Ȥ�֪ͨ
			}
			//�x�k���a��Τ��Ƥ�
			function nextResult() {
				var $current_result = getCurrentResult();

				if ($current_result) {

					//���������ʾ
					setSubInfo($current_result.next());

					$current_result
						.removeClass(options.select_class)
						.next()
							.addClass(options.select_class);
				}else{
					//���������ʾ
					setSubInfo($results.children('li:first-child'), 0);

					$results.children('li:first-child').addClass(options.select_class);
				}
				//�x�k���a��׷�������ƥ������`��
				scrollWindow();
			}
			//�x�k���a��ǰ���Ƥ�
			function prevResult() {
				var $current_result = getCurrentResult();

				if ($current_result) {

					//���������ʾ
					setSubInfo($current_result.prev());

					$current_result
						.removeClass(options.select_class)
						.prev()
							.addClass(options.select_class);
				}else{
					//���������ʾ
					setSubInfo(
						$results.children('li:last-child'),
						($results.children('li').length - 1)
					);

					$results.children('li:last-child').addClass(options.select_class);
				}
				//�x�k���a��׷�������ƥ������`��
				scrollWindow();
			}
			//���a���ꥢ����ȥ
			function hideResult() {

				if (key_paging) {
					//�x�k���a��׷�������ƥ������`��
					scrollWindow(true);
					key_paging = false;
				}

				$result_area.hide();

				//���������ȥ
				$attached_tbl.children('table')
					.css('display','none');

				//Ajaxͨ�Ť򥭥�󥻥�
				abortAjax();

				//�ܥ����title���Գ��ڻ�
				btnAttrDefault();
			}
			//���aһ�E��1��Ŀ���Ŀ���x�k״�B�ˤ���
			function selectFirstResult() {
				$results.children('li:first-child').addClass(options.select_class);

				//���������ʾ
				setSubInfo($results.children('li:first-child'));

				//�x�k���a��׷�������ƥ������`��
				scrollWindow(true);
			}

			//================================================================================
			// 09. ComboBox�å᥽�å� - ��������v�B
			//--------------------------------------------------------------------------------
			//**********************************************
			//���������l����ʹ�ä���Ҫ�ؤΥ����������
			//**********************************************
			function setSizeResults(){
				if(size_navi == null){
					size_navi =
						$navi.height() +
						parseInt($navi.css('border-top-width'), 10) +
						parseInt($navi.css('border-bottom-width'), 10) +
						parseInt($navi.css('padding-top'), 10) +
						parseInt($navi.css('padding-bottom'), 10);
				}
			}
			function setSizeNavi(){
				if(size_results == null){
					size_results = parseInt($results.css('border-top-width'), 10);
				}
			}
			function setSizeLi(){
				if(size_li == null){
					$obj = $results.children('li:first');
					size_li =
						$obj.height() +
						parseInt($obj.css('border-top-width'), 10) +
						parseInt($obj.css('border-bottom-width'), 10) +
						parseInt($obj.css('padding-top'), 10) +
						parseInt($obj.css('padding-bottom'), 10);
				}
			}
			function setSizeLeft(){
				if(size_left == null){
					size_left =
						$results.width() +
						parseInt($results.css('padding-left'), 10) +
						parseInt($results.css('padding-right'), 10) +
						parseInt($results.css('border-left-width'), 10) +
						parseInt($results.css('border-right-width'), 10);
				}
			}

			//**********************************************
			//���������ʾ
			//**********************************************
			// @paramas object  obj   �����������O�˱�ʾ������<li>Ҫ��
			// @paramas integer n_idx �x�k�Ф�<li>�η���(0��)
			function setSubInfo(obj, n_idx){

				//���������ʾ���ʤ��O���ʤ顢�����ǽK��
				if(!options.sub_info) return;

				//�������������O���äλ������
				//���ؤ��O�������ǡ���Ϻ��ӳ�����ʤ���
				setSizeNavi();
				setSizeResults();
				setSizeLi();
				setSizeLeft();

				//�F�ڤ�<li>�η��Ťϣ�
				if(n_idx == null){
					n_idx = $results.children('li').index(obj);
				}

				//һ�����������ȫ��ȥ
				$attached_tbl.children('table').css('display','none');

				//�ꥹ���ڤκ��a���x�k������ϤΤߡ����¤�g��
				if(n_idx > -1){

					var t_top = 0;
					if($navi.css('display') != 'none') t_top += size_navi;
					t_top += (size_results + size_li * n_idx);
					var t_left = size_left;

					//Firefox�Έ��ϡ���border-collapse:collapse;���ˤ���ȡ�
					//���1px,�Ϥ�1px����Ƥ��ޤ������λرܲ�
					//�ο���http://www.nk0206.com/life/2009/10/bordercollapse2.html
					if($.browser.mozilla) {
						t_top  ++;
						t_left ++;
					}
					t_top  += 'px';
					t_left += 'px';
					
					$attached_tbl.children('table:eq(' + n_idx + ')').css({
						'position': 'absolute',
						'top'     : t_top,
						'left'    : t_left,
						'display' : ($.browser.msie) ? 'block' : 'table' //for IE7
					});
				}
			}
		}
	};

	//================================================================================
	// 10. �I����ʼ�ޤ�
	//--------------------------------------------------------------------------------
	$.fn.ajaxComboBox = function(source, options) {
		if (!source) return;

		//************************************************************
		//���ץ����
		//************************************************************
		options = $.extend({
			//�����O��
			source         : source,
			db_table       : 'tbl',                    //�ӾA����DB�ΥƩ`�֥���
			//img_dir        : 'acbox/img/',             //�ܥ�����ؤΥѥ�
			img_dir        : '/hbapp/resources/js/acbox/img/',             //modified by higherzl
			field          : 'name',                   //���a�Ȥ��Ʊ�ʾ���륫�����
			minchars       : 1,                        //���a��y�I����ʼ���Τ˱�Ҫ����ͤ�������
			per_page       : 10,                       //���aһ�E1�ک`���˱�ʾ�������
			navi_num       : 5,                        //�ک`���ʥӤǱ�ʾ����ک`�����Ť���
			navi_simple    : false,                    //���^��ĩβ�Υک`���ؤΥ�󥯤��ʾ���뤫��
			init_val       : false,                    //ComboBox�γ��ڂ�(������ʽ�Ƕɤ�)
			init_src       : 'acbox/php/initval.php',  //���ڂ��O���ǡ����쥯�Ȍ��äΈ��Ϥ˱�Ҫ
			input_prefix   : $(this).attr('id') + '_', //�ƥ����ȥܥå�����name���Ԥν��^��
			mini           : false,                    //ComboBox��ߥ˥������Ǳ�ʾ���뤫�ɤ�����
			lang           : 'ja',                     //���Z���x�k(�ǥե���Ȥ��ձ��Z)
			
			//�������
			sub_info       : false, //���������ʾ���뤫�ɤ�����
			sub_as         : {},    //�������ǤΡ���������΄e��
			show_field     : '',    //�������Ǳ�ʾ���륫���(�}��ָ���ϥ�������Ф�)
			hide_field     : '',    //�������ǷǱ�ʾ�ˤ��륫���(�}��ָ���ϥ�������Ф�)

			//���쥯�Ȍ���
			select_only    : false, //���쥯�Ȍ��äˤ��뤫�ɤ�����
			primary_key    : 'id'   //���쥯�Ȍ��Õr��hidden�΂��Ȥʤ륫���
		}, options);
		
		//2��Ŀ���O��(���Υ��ץ����΂������ä��뤿��)
		options = $.extend({
			order_field    : options.field,            //ORDER BY(SQL) �λ��ʤȤʤ륫�����
			order_by       : 'ASC',                    //ORDER BY(SQL) �ǡ��K���椨��ΤϕN혤���혤�

			//�ѥå��`��
			package       : false,                            //�ѥå��`���Ȥ��Ʊ�ʾ���뤫�ɤ�����
			p_del_img1     : options.img_dir + 'del_out.png',  //�����ܥ���(�ޥ���������)
			p_del_img2     : options.img_dir + 'del_over.png', //�����ܥ���(�ޥ������`�Щ`)
			p_add_img1     : options.img_dir + 'add_out.png',  //׷�ӥܥ���(�ޥ���������)
			p_add_img2     : options.img_dir + 'add_over.png', //׷�ӥܥ���(�ޥ������`�Щ`)

			//CakePHP�v�B
			cake_rule      : false, //ComboBox��name���Ԥˡ�CakePHP��������`����m�ä��뤫��
			cake_model     : options.db_table, //�ⲿ���`�Έ��ϡ�Ԫ�Υǩ`������{���줿��ǥ���
			cake_field     : options.field,    //�ⲿ���`�Έ��ϡ�Ԫ�Υǩ`������{���줿�ե��`�����
			
			//--------------------------
			// �������ˤ����
			//--------------------------
			//�ѥå��`���v�B
			p_area_cls     : 'box_area'  + ((options.mini)?'_mini':''), //ComboBox + �����ܥ���
			p_acbox_cls    : 'combo_box' + ((options.mini)?'_mini':''), //ComboBox
			p_add_cls      : 'add_area'  + ((options.mini)?'_mini':''), //׷�ӥܥ���
			p_del_cls      : 'del_area'  + ((options.mini)?'_mini':''), //�����ܥ���

			//ComboBox�v�B
			combo_class    : 'ac_combobox_area' + ((options.mini)?'_mini':''), //ComboBoxȫ�����<div>
			table_class    : 'ac_table'         + ((options.mini)?'_mini':''), //ComboBox��<table>
			input_class    : 'ac_input'         + ((options.mini)?'_mini':''), //�ƥ����ȥܥå���
			button_class   : 'ac_button'        + ((options.mini)?'_mini':''), //�ܥ����CSS���饹
			btn_on_class   : 'ac_btn_on'        + ((options.mini)?'_mini':''), //�ܥ���(mover�r)
			btn_out_class  : 'ac_btn_out'       + ((options.mini)?'_mini':''), //�ܥ���(mout�r)
			re_area_class  : 'ac_result_area'   + ((options.mini)?'_mini':''), //�Y���ꥹ�Ȥ�<div>
			navi_class     : 'ac_navi'          + ((options.mini)?'_mini':''), //�ک`���ʥӤ���<div>
			results_class  : 'ac_results'       + ((options.mini)?'_mini':''), //���aһ�E����<ul>
			select_class   : 'ac_over'          + ((options.mini)?'_mini':''), //�x�k�Ф�<li>
			match_class    : 'ac_match'         + ((options.mini)?'_mini':''), //�ҥå����֤�<span>
			sub_info_class : 'ac_attached'      + ((options.mini)?'_mini':''), //�������

			//����t��
			button_img     : options.img_dir + 'combobox_button' + ((options.mini)?'_mini':'') + '.png',
			load_img       : options.img_dir + 'ajax-loader'     + ((options.mini)?'_mini':'') + '.gif',
			select_ok_img  : options.img_dir + 'select_ok'       + ((options.mini)?'_mini':'') + '.png',
			select_ng_img  : options.img_dir + 'select_ng'       + ((options.mini)?'_mini':'') + '.png'
		}, options);

		//************************************************************
		//��å��`�������Z�e������
		//************************************************************
		switch (options.lang){
		
			//�ձ��Z
			case 'ja':
				var msg = {
					'add_btn'     : '׷�ӥܥ���',
					'add_title'   : '�����ܥå�����׷�Ӥ��ޤ�',
					'del_btn'     : '�����ܥ���',
					'del_title'   : '�����ܥå������������ޤ�',
					'next'        : '�Τ�',
					'next_title'  : '�Τ�'+options.per_page+'�� (�ҥ��`)',
					'prev'        : 'ǰ��',
					'prev_title'  : 'ǰ��'+options.per_page+'�� (�󥭩`)',
					'first_title' : '����Υک`���� (Shift + �󥭩`)',
					'last_title'  : '����Υک`���� (Shift + �ҥ��`)',
					'get_all_btn' : 'ȫ��ȡ�� (�¥��`)',
					'get_all_alt' : '����:�ܥ���',
					'close_btn'   : '�]���� (Tab���`)',
					'close_alt'   : '����:�ܥ���',
					'loading'     : '���`����...',
					'loading_alt' : '����:���`����...',
					'page_info'   : 'num_page_top - num_page_end �� (ȫ cnt ��)',
					'select_ng'   : 'ע�� : �ꥹ�Ȥ��Ф����x�k���Ƥ�������',
					'select_ok'   : 'OK : �������x�k����ޤ�����'
				};
				break;

			//Ӣ�Z
			case 'en':
				var msg = {
					'add_btn'     : 'Add button',
					'add_title'   : 'add a box',
					'del_btn'     : 'Del button',
					'del_title'   : 'delete a box',
					'next'        : 'Next',
					'next_title'  : 'Next'+options.per_page+' (Right key)',
					'prev'        : 'Prev',
					'prev_title'  : 'Prev'+options.per_page+' (Left key)',
					'first_title' : 'First (Shift + Left key)',
					'last_title'  : 'Last (Shift + Right key)',
					'get_all_btn' : 'Get All (Down key)',
					'get_all_alt' : '(button)',
					'close_btn'   : 'Close (Tab key)',
					'close_alt'   : '(button)',
					'loading'     : 'loading...',
					'loading_alt' : '(loading)',
					'page_info'   : 'num_page_top - num_page_end of cnt',
					'select_ng'   : 'Attention : Please choose from among the list.',
					'select_ok'   : 'OK : Correctly selected.'
				};
				break;

			//���ڥ����Z (Joaquin G. de la Zerda�Ϥ�����ṩ)
			case 'es':
				var msg = {
					'add_btn'     : 'Agregar boton',
					'add_title'   : 'Agregar una opcion',
					'del_btn'     : 'Borrar boton',
					'del_title'   : 'Borrar una opcion',
					'next'        : 'Siguiente',
					'next_title'  : 'Proximas '+options.per_page+' (tecla derecha)',
					'prev'        : 'Anterior',
					'prev_title'  : 'Anteriores '+options.per_page+' (tecla izquierda)',
					'first_title' : 'Primera (Shift + Left)',
					'last_title'  : 'Ultima (Shift + Right)',
					'get_all_btn' : 'Ver todos (tecla abajo)',
					'get_all_alt' : '(boton)',
					'close_btn'   : 'Cerrar (tecla TAB)',
					'close_alt'   : '(boton)',
					'loading'     : 'Cargando...',
					'loading_alt' : '(Cargando)',
					'page_info'   : 'num_page_top - num_page_end de cnt',
					'select_ng'   : 'Atencion: Elija una opcion de la lista.',
					'select_ok'   : 'OK: Correctamente seleccionado.'
				};
				break;

			default:
		}
		this.each(function() {
			new $.ajaxComboBox(this, source, options, msg);
		});
		return this;
	};
})(jQuery);