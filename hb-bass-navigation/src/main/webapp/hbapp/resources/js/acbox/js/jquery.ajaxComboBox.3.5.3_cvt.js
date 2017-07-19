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
	01. ComboBoxパッケージを生成  
	02. ComboBoxパッケージ用のメソッド
	03. 変数?部品の定義
	04. イベントハンドラ
	05. ComboBox用メソッド - 未分類
	06. ComboBox用メソッド - Ajax関連
	07. ComboBox用メソッド - ページナビ関連
	08. ComboBox用メソッド - 候補リスト関連
	09. ComboBox用メソッド - サブ情報関連
	10. 処理の始まり
==========================================================================================
*/
(function($) {
	$.ajaxComboBox = function(area_pack, source, options, msg) {
		debugger;
		//================================================================================
		// 01. ComboBoxパッケージを生成
		//--------------------------------------------------------------------------------
		var num       = 0; //同パック内のボックスの数
		var box_width = $(area_pack).width();

		//************************************************************
		// ComboBoxエリアを準備
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

		//最初に、Boxをひとつ用意
		if(options.init_val === false){
			addPack(area_pack);
		}else{
			for(i=0; options.init_val.length > i ;i++){
				addPack(area_pack);
			}
			options.init_val = false;
		}

		//================================================================================
		// 02. ComboBoxパッケージ用のメソッド
		//--------------------------------------------------------------------------------
		//************************************************************
		//ComboBoxを削除
		//************************************************************
		function delPack(box){
			var past_id = $(area_pack).find('input[type=text]').eq(0).attr('id');
			$(box).parent().parent().remove();

			var new_id = $(area_pack).find('input[type=text]').eq(0).attr('id');
			$('label[for=' + past_id + ']').attr('for', new_id);

			delBtnShowHide();
		}

		//************************************************************
		//削除ボタンの表示?非表示を判断
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
		//ComboBoxを追加
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

			//◆◆個別のComboBox生成処理を呼び出す◆◆
			individual($box);

			delBtnShowHide();
		}

		//************************************************************
		//◆◆個別のComboBoxを生成◆◆
		//************************************************************
		function individual(area_combobox){
		
			//Ajaxにおけるキャッシュを無効にする
			$.ajaxSetup({cache: false});
			
			//================================================================================
			// 03. 変数?部品の定義
			//--------------------------------------------------------------------------------
			//**********************************************
			//変数の初期化
			//**********************************************
			var show_hide        = false; //候補を、タイマー処理で表示するかどうかの予約
			var timer_show_hide  = false; //タイマー。フォーカスが外れた後、候補を非表示にするか
			var timer_delay      = false; //hold timeout ID for suggestion result_area to appear
			var timer_val_change = false; //タイマー変数(一定時間ごとに入力値の変化を監視)
			var type_suggest     = false; //リストのタイプ。false=>全件 / true=>予測
			var page_num_all     = 1;     //全件表示の際の、現在のページ番号
			var page_num_suggest = 1;     //候補表示の際の、現在のページ番号
			var max_all          = 1;     //全件表示の際の、全ページ数
			var max_suggest      = 1;     //候補表示の際の、全ページ数
			var now_loading      = false; //Ajaxで問い合わせ中かどうか？
			var reserve_btn      = false; //ボタンの背景色変更の予約があるかどうか？
			var reserve_click    = false; //マウスのキーを押し続ける操作に対応するためmousedownを検知
			var $xhr             = false; //XMLHttpオブジェクトを格納
			var key_paging       = false; //キーでページ移動したか？
			var key_select       = false; //キーで候補移動したか？？
			var prev_value       = '';    //ComboBoxの、以前の値

			//サブ情報
			var size_navi        = null;  //サブ情報表示用(ページナビの高さ)
			var size_results     = null;  //サブ情報表示用(リストの上枠線)
			var size_li          = null;  //サブ情報表示用(候補一行分の高さ)
			var size_left        = null;  //サブ情報表示用(リストの横幅)
			var select_field;             //サブ情報表示の場合に取得するカラム
			
			
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

			//セレクト専用時、フォーム送信する一意の情報を格納する
			var primary_key = (options.select_only)
				? options.primary_key
				: '';

			//**********************************************
			//部品の定義
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
				//CakePHP用のname,id属性名設定
				//-----------------------------------
				var field_camel = toCakeCamelCase(options.cake_field);

				if(options.package){
					//パッケージ
					$input.attr({
						'name' : 'data[' + options.cake_model + '][' + options.cake_field + '][' + (num - 1) + ']',
						'id'   : options.cake_model + field_camel + (num - 1)
					});
				} else {
					//単品
					$input.attr({
						'name' : 'data[' + options.cake_model + '][' + options.cake_field + ']',
						'id'   : options.cake_model + field_camel
					});
				}
			} else {
				//-----------------------------------
				//通常のname,id属性名設定
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

			//サブ情報
			var $attached_tbl = $('<div></div>')
				.addClass(options.sub_info_class);

			//"セレクト専用"オプション用
			var $hidden = $('<input type="hidden" />')
				.attr({
					'name': $input.attr('name'),
					'id'  : $input.attr('name') + '_hidden'
				})
				.val('');

			//ボタンのtitle属性初期化
			btnAttrDefault();

			//**********************************************
			//表示形式を整える
			//**********************************************

			$obj_th.append($input);

			$result_area.append($navi).append($results);

			$(area_combobox)
				.append($table)
				.append($result_area);

			//セレクト専用時、hiddenを追加
			if(options.select_only) $(area_combobox).append($hidden);

			//テキストボックスの幅を決定
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
				3 //テーブルの"border-spacing:1px×3"の値

				//IE8では'border-spacing'の値を取得できないため、削除
				// - (parseInt($table.css('border-spacing')) * 3)
			);

			//ComboBoxに初期値を挿入
			setInitVal();

			//================================================================================
			// 04. イベントハンドラ
			//--------------------------------------------------------------------------------
			//**********************************************
			//全件取得ボタン
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
			//最初はmouseoutの状態
			$button.mouseout();

			//**********************************************
			//テキスト入力エリア
			//**********************************************
			//前処理(クロスブラウザ用)
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
				//入力値の監視を中止
				clearTimeout(timer_val_change);

				//候補消去を予約
				show_hide = false;

				//消去予約タイマーをセット
				checkShowHide();

				//セレクト状態を確認
				btnAttrDefault();
			});
			$input.mousedown(function(ev) {
				reserve_click = true;

				//消去予約タイマーを中止
				clearTimeout(timer_show_hide);

				ev.stopPropagation();
			});
			$input.mouseup(function(ev) {
				$input.focus();
				reserve_click = false;
				ev.stopPropagation();
			});

			//**********************************************
			//ページナビ
			//**********************************************
			$navi.mousedown(function(ev) {
				reserve_click = true;

				//消去予約タイマーを中止
				clearTimeout(timer_show_hide);

				ev.stopPropagation();
			});
			$navi.mouseup(function(ev) {
				$input.focus();
				reserve_click = false;
				ev.stopPropagation();
			});

			//**********************************************
			//サブ情報
			//**********************************************
			$attached_tbl.mousedown(function(ev) {
				reserve_click = true;

				//消去予約タイマーを中止
				clearTimeout(timer_show_hide);
				ev.stopPropagation();
			});
			$attached_tbl.mouseup(function(ev) {
				$input.focus();
				reserve_click = false;
				ev.stopPropagation();
			});

			//**********************************************
			//body全体
			//**********************************************
			$('body').mouseup(function() {
				//消去予約タイマーを中止
				clearTimeout(timer_show_hide);

				//候補を消去する
				show_hide = false;
				hideResult();
			});

			//================================================================================
			// 05. ComboBox用メソッド - 未分類
			//--------------------------------------------------------------------------------
			//**********************************************
			//CakePHP用に、フィールド名をUpperCamelCaseに
			//**********************************************
			// @param text str 変換前の文字列
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
			//ComboBoxに初期値を挿入
			//**********************************************
			function setInitVal(){
				if(options.init_val === false) return;

				if(options.select_only){
					//------------------------------------------
					//セレクト専用への値挿入
					//------------------------------------------
					//hiddenへ値を挿入
					$hidden.val(options.init_val[num - 1]);

					//テキストボックスへ値を挿入
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

							//選択状態
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
					//通常の、テキストボックスへの値挿入
					//------------------------------------------
					prev_value = options.init_val[num - 1];
					$input.val(options.init_val[num - 1]);
				}
			}

			//**********************************************
			//選択候補を追いかけて画面をスクロール
			//**********************************************
			//キー操作による候補移動、ページ移動のみに適用
			//
			// @param boolean enforce 移動先をテキストボックスに強制するか？
			function scrollWindow(enforce) {

				//------------------------------------------
				//使用する変数を定義
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
				//スクロール処理
				//------------------------------------------
				var gap;
				if ($current_result.length) {
					if(target_top < scroll_top || target_size > client_height) {
						//上へスクロール
						//※ブラウザの高さがターゲットよりも低い場合もこちらへ分岐する。
						gap = target_top - scroll_top;

					} else if (target_top > scroll_bottom) {
						//下へスクロール
						gap = target_top - scroll_bottom;

					} else {
						//スクロールは行われない
						return;
					}

				} else if (target_top < scroll_top) {
					gap = target_top - scroll_top;
				}
				window.scrollBy(0, gap);
			}
			//**********************************************
			//ボタンのtitle属性変更
			//**********************************************
			//初期化 & セレクト専用時の分岐
			function btnAttrDefault() {

				if(options.select_only){

					if($input.val() != ''){
						if($hidden.val() != ''){

							//選択状態
							$button.attr('title',msg['select_ok']);
							$button.children('img').attr({
								'src'   : options.select_ok_img,
								'alt'   : msg['get_all_alt'],
								'title' : msg['select_ok']
							});
							return;
						} else {

							//入力途中
							$button.attr('title',msg['select_ng']);
							$button.children('img').attr({
								'src'   : options.select_ng_img,
								'alt'   : msg['get_all_alt'],
								'title' : msg['select_ng']
							});
							return;
						}
					} else {
						//完全な初期状態へ戻す
						$hidden.val('');
					}
				}
				//初期状態
				$button.attr('title',msg['get_all_btn']);
				$button.children('img').attr({
					'src'   : options.button_img,
					'alt'   : msg['get_all_alt'],
					'title' : msg['get_all_btn']
				});
			}
			//閉じる
			function btnAttrClose() {
				$button.attr('title',msg['close_btn']);
				$button.children('img').attr({
					'src'   : options.load_img,
					'alt'   : msg['close_alt'],
					'title' : msg['close_btn']
				});
			}
			//ロード中
			function btnAttrLoad() {
				$button.attr('title',msg['loading']);
				$button.children('img').attr({
					'src'   : options.load_img,
					'alt'   : msg['loading_alt'],
					'title' : msg['loading']
				});
			}

			//**********************************************
			//タイマーによる入力値変化監視
			//**********************************************
			function checkValChange() {
				timer_val_change = setTimeout(isChange,500);

				function isChange() {
					now_value = $input.val();

					if(now_value != prev_value) {

						//セレクト専用時
						if(options.select_only){
							$hidden.val('');
							btnAttrDefault();
						}
						//ページ数をリセット
						page_num_suggest = 1;
						
						type_suggest = true;
						suggest();
					}
					prev_value = now_value;

					//一定時間ごとの監視を再開
					checkValChange();
				}
			}

			//**********************************************
			//候補の消去を本当に実行するか判断
			//**********************************************
			function checkShowHide() {
				timer_show_hide = setTimeout(function() {
					if (show_hide == false && reserve_click == false){
						hideResult();
					}
				},500);
			}

			//**********************************************
			//キー入力への対応
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
			//ロード画像の表示?解除
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
			// 06. ComboBox用メソッド - Ajax関連
			//--------------------------------------------------------------------------------
			//**********************************************
			//Ajaxの中断
			//**********************************************
			function abortAjax() {
				if ($xhr){
					//jQuery1.4.3では、下記のIE7用分岐は必要なくなるはず
					if($.browser.msie && $.browser.version == '7.0') return;
					$xhr.abort();
					$xhr = false;
					clearLoadImg();
				}
			}

			//**********************************************
			//Ajax通信
			//**********************************************
			function suggest(){
				var q_word         = (type_suggest) ? $.trim($input.val()) : '';
				//q_word = encodeURIComponent(q_word); // 防治中文乱码
				//alert(q_word);
				var which_page_num = (type_suggest) ? page_num_suggest : page_num_all;

				if (type_suggest && q_word.length < options.minchars){ 
					hideResult();
					
				} else {
					//Ajax通信をキャンセル
					abortAjax();

					//サブ情報消去
					$attached_tbl.children('table').css('display','none');

					setLoadImg();

					//ここでAjax通信を行っている
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
							//連続でAjax通信すると、通信が失敗して戻り値のデータが空の場合がある
							//そのために、json_data自体をチェックする。
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
								//一致するデータ見つからなかった
								hideResult();
							} else {
								//全件数が1ページ最大数を超えない場合、ページナビは非表示
								if(json_data.cnt > json_data.cnt_page){
									setNavi(json_data.cnt, json_data.cnt_page, which_page_num);
								} else {
									$navi.css('display','none');
								}

								//候補リスト(arr_candidate)
								var arr_candidate = [];
								$.each(json_data.candidate, function(i,obj){
									arr_candidate[i] = obj.replace(
										new RegExp(q_word, 'ig'),
										function(q_word) {
											return '<span class="' + options.match_class + '">' + q_word + '</span>';
										}
									);
								});

								//サブ情報(arr_attached)
								var arr_attached = [];
								if(json_data.attached){
									$.each(json_data.attached,function(i,obj){
										arr_attached[i] = obj;
									});
								} else {
									arr_attached = false;
								}

								//セレクト専用(arr_primary_key)
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
			// 07. ComboBox用メソッド - ページナビ関連
			//--------------------------------------------------------------------------------
			//**********************************************
			//ナビ部分を作成
			//**********************************************
			// @param integer cnt         DBから取得した候補の数
			// @param integer page_num    全件、または予測候補の一覧のページ数
			function setNavi(cnt, cnt_page, page_num) {

				var num_page_top = options.per_page * (page_num - 1) + 1;
				var num_page_end = num_page_top + cnt_page - 1;

				//var cnt_result = msg['page_info']
				var cnt_result = msg['page_info']
					.replace('cnt'          , cnt)
					.replace('num_page_top' , num_page_top)
					.replace('num_page_end' , num_page_end);

				$navi.text(cnt_result);

				var navi_p = $('<p></p>'); //ページング部分のオブジェクト
				var max    = Math.ceil(cnt / options.per_page); //全ページ数

				//ページ数
				if (type_suggest) {
					max_suggest = max;
				}else{
					max_all = max;
				}

				//表示する一連のページ番号の左右端
				var left  = page_num - Math.ceil ((options.navi_num - 1) / 2);
				var right = page_num + Math.floor((options.navi_num - 1) / 2);

				//現ページが端近くの場合のleft,rightの調整
				while(left < 1){ left ++;right++; }
				while(right > max){ right--; }
				while((right-left < options.navi_num - 1) && left > 1){ left--; }

				//----------------------------------------------
				//ページング部分を作成

				//『<< 前へ』の表示
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

				//各ページへのリンクの表示
				for (i = left; i <= right; i++)
				{
					//現在のページ番号は<span>で囲む(強調表示用)
					var num_link = (i == page_num) ? '<span class="current">'+i+'</span>' : i;

					$('<a></a>')
						.attr({'href':'javascript:void(0)','class':'navi_page'})
						.html(num_link)
						.appendTo(navi_p);
				}

				//『次のX件 >>』の表示
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

				//ページナビの表示、イベントハンドラの設定は必要な場合のみ行う
				if (max > 1) {
					$navi.append(navi_p).show();

					//----------------------------------------------
					//ページング部分のイベントハンドラ

					//『<< 1』をクリック
					$('.navi_first').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						firstPage();
					});

					//『< 前へ』をクリック
					$('.navi_prev').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						prevPage();
					});

					//各ページへのリンクをクリック
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

					//『次へ >』をクリック
					$('.navi_next').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						nextPage();
					});

					//『max >>』をクリック
					$('.navi_last').mouseup(function(ev) {
						$input.focus();
						ev.preventDefault();
						lastPage();
					});
				}
			}

			//**********************************************
			//ページナビ操作
			//**********************************************
			//1ページ目へ
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
			//前のページへ
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
			//次のページへ
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
			//最後のページへ
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
			// 08. ComboBox用メソッド - 候補リスト関連
			//--------------------------------------------------------------------------------
			//**********************************************
			//候補一覧の<ul>成形、表示
			//**********************************************
			// @params array arr_candidate   DBから検索?取得した値の配列
			// @params array arr_attached    サブ情報の配列
			// @params array arr_primary_key 主キーの配列
			//
			//arr_candidateそれぞれの値を<li>で囲んで表示。
			//同時に、イベントハンドラを記述。
			function displayItems(arr_candidate, arr_attached, arr_primary_key) {

				if (arr_candidate.length == 0) {
					hideResult();
					return;
				}

				//候補リストを、一旦リセット
				$results.empty();
				$attached_tbl.empty();

				for (var i = 0; i < arr_candidate.length; i++) {

					//候補リスト
					var $li = $('<li>' + arr_candidate[i] + '</li>');

					//セレクト専用
					if(options.select_only){
						$li.attr('id', arr_primary_key[i]);
					}

					$results.append($li);

					//サブ情報のテーブルを生成
					if(arr_attached){
						var $tbl = $('<table><tbody></tbody></table>');

						for (var j=0; j < arr_attached[i].length; j++) {

							//thの別名を検索する
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
				//画面に表示
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

						//Firefoxでは、候補一覧の上にマウスカーソルが乗っていると
						//うまくスクロールしない。そのための対策。イベント中断。
						if (key_select) {
							key_select = false;
							return;
						}

						//サブ情報を表示
						setSubInfo(this);

						$results.children('li').removeClass(options.select_class);
						$(this).addClass(options.select_class);
					})
					.mousedown(function(e) {
						reserve_click = true;

						//消去予約タイマーを中止
						clearTimeout(timer_show_hide);
						//ev.stopPropagation();
					})
					.mouseup(function(e) {
						reserve_click = false;

						//Firefoxでは、候補一覧の上にマウスカーソルが乗っていると
						//うまくスクロールしない。そのための対策。イベント中断。
						if (key_select) {
							key_select = false;
							return;
						}
						e.preventDefault();
						e.stopPropagation();
						selectCurrentResult();
					});

				//ボタンのtitle属性変更(閉じる)
				btnAttrClose();
			}

			//**********************************************
			//候補エリアの操作
			//**********************************************
			//現在選択中の候補を取得
			// @return object current_result 現在選択中の候補のオブジェクト(<li>要素)
			function getCurrentResult() {

				if (!$result_area.is(':visible')) return false;

				var $current_result = $results.children('li.' + options.select_class);

				if (!$current_result.length) $current_result = false;

				return $current_result;
			}
			//現在選択中の候補に決定する
			function selectCurrentResult() {

				//選択候補を追いかけてスクロール
				scrollWindow(true);

				var $current_result = getCurrentResult();

				if ($current_result) {
					$input.val($current_result.text());
					hideResult();

					//added
					prev_value = $input.val();

					//セレクト専用
					if(options.select_only){
						$hidden.val($current_result.attr('id'));
						btnAttrDefault();
					}
				}
				$input.focus();  //テキストボックスにフォーカスを移す
				$input.change(); //テキストボックスの値が変わったことを通知
			}
			//選択候補を次に移す
			function nextResult() {
				var $current_result = getCurrentResult();

				if ($current_result) {

					//サブ情報を表示
					setSubInfo($current_result.next());

					$current_result
						.removeClass(options.select_class)
						.next()
							.addClass(options.select_class);
				}else{
					//サブ情報を表示
					setSubInfo($results.children('li:first-child'), 0);

					$results.children('li:first-child').addClass(options.select_class);
				}
				//選択候補を追いかけてスクロール
				scrollWindow();
			}
			//選択候補を前に移す
			function prevResult() {
				var $current_result = getCurrentResult();

				if ($current_result) {

					//サブ情報を表示
					setSubInfo($current_result.prev());

					$current_result
						.removeClass(options.select_class)
						.prev()
							.addClass(options.select_class);
				}else{
					//サブ情報を表示
					setSubInfo(
						$results.children('li:last-child'),
						($results.children('li').length - 1)
					);

					$results.children('li:last-child').addClass(options.select_class);
				}
				//選択候補を追いかけてスクロール
				scrollWindow();
			}
			//候補エリアを消去
			function hideResult() {

				if (key_paging) {
					//選択候補を追いかけてスクロール
					scrollWindow(true);
					key_paging = false;
				}

				$result_area.hide();

				//サブ情報消去
				$attached_tbl.children('table')
					.css('display','none');

				//Ajax通信をキャンセル
				abortAjax();

				//ボタンのtitle属性初期化
				btnAttrDefault();
			}
			//候補一覧の1番目の項目を、選択状態にする
			function selectFirstResult() {
				$results.children('li:first-child').addClass(options.select_class);

				//サブ情報を表示
				setSubInfo($results.children('li:first-child'));

				//選択候補を追いかけてスクロール
				scrollWindow(true);
			}

			//================================================================================
			// 09. ComboBox用メソッド - サブ情報関連
			//--------------------------------------------------------------------------------
			//**********************************************
			//サブ情報で頻繁に使用する要素のサイズを算出
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
			//サブ情報を表示
			//**********************************************
			// @paramas object  obj   サブ情報を右隣に表示させる<li>要素
			// @paramas integer n_idx 選択中の<li>の番号(0～)
			function setSubInfo(obj, n_idx){

				//サブ情報を表示しない設定なら、ここで終了
				if(!options.sub_info) return;

				//サブ情報の座標設定用の基本情報
				//初回の設定だけで、後は呼び出されない。
				setSizeNavi();
				setSizeResults();
				setSizeLi();
				setSizeLeft();

				//現在の<li>の番号は？
				if(n_idx == null){
					n_idx = $results.children('li').index(obj);
				}

				//一旦、サブ情報全消去
				$attached_tbl.children('table').css('display','none');

				//リスト内の候補を選択する場合のみ、以下を実行
				if(n_idx > -1){

					var t_top = 0;
					if($navi.css('display') != 'none') t_top += size_navi;
					t_top += (size_results + size_li * n_idx);
					var t_left = size_left;

					//Firefoxの場合、『border-collapse:collapse;』にすると、
					//左に1px,上に1pxずれてしまう。その回避策
					//参考→http://www.nk0206.com/life/2009/10/bordercollapse2.html
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
	// 10. 処理の始まり
	//--------------------------------------------------------------------------------
	$.fn.ajaxComboBox = function(source, options) {
		if (!source) return;

		//************************************************************
		//オプション
		//************************************************************
		options = $.extend({
			//基本設定
			source         : source,
			db_table       : 'tbl',                    //接続するDBのテーブル名
			//img_dir        : 'acbox/img/',             //ボタン画像へのパス
			img_dir        : '/hbapp/resources/js/acbox/img/',             //modified by higherzl
			field          : 'name',                   //候補として表示するカラム名
			minchars       : 1,                        //候補予測処理を始めるのに必要な最低の文字数
			per_page       : 10,                       //候補一覧1ページに表示する件数
			navi_num       : 5,                        //ページナビで表示するページ番号の数
			navi_simple    : false,                    //先頭、末尾のページへのリンクを表示するか？
			init_val       : false,                    //ComboBoxの初期値(配列形式で渡す)
			init_src       : 'acbox/php/initval.php',  //初期値設定で、セレクト専用の場合に必要
			input_prefix   : $(this).attr('id') + '_', //テキストボックスのname属性の接頭辞
			mini           : false,                    //ComboBoxをミニサイズで表示するかどうか？
			lang           : 'ja',                     //言語を選択(デフォルトは日本語)
			
			//サブ情報
			sub_info       : false, //サブ情報を表示するかどうか？
			sub_as         : {},    //サブ情報での、カラム名の別名
			show_field     : '',    //サブ情報で表示するカラム(複数指定はカンマ区切り)
			hide_field     : '',    //サブ情報で非表示にするカラム(複数指定はカンマ区切り)

			//セレクト専用
			select_only    : false, //セレクト専用にするかどうか？
			primary_key    : 'id'   //セレクト専用時、hiddenの値となるカラム
		}, options);
		
		//2回目の設定(他のオプションの値を引用するため)
		options = $.extend({
			order_field    : options.field,            //ORDER BY(SQL) の基準となるカラム名
			order_by       : 'ASC',                    //ORDER BY(SQL) で、並ベ替えるのは昇順か降順か

			//パッケージ
			package       : false,                            //パッケージとして表示するかどうか？
			p_del_img1     : options.img_dir + 'del_out.png',  //削除ボタン(マウスアウト)
			p_del_img2     : options.img_dir + 'del_over.png', //削除ボタン(マウスオーバー)
			p_add_img1     : options.img_dir + 'add_out.png',  //追加ボタン(マウスアウト)
			p_add_img2     : options.img_dir + 'add_over.png', //追加ボタン(マウスオーバー)

			//CakePHP関連
			cake_rule      : false, //ComboBoxのname属性に、CakePHPの命名ルールを適用するか？
			cake_model     : options.db_table, //外部キーの場合、元のデータが格納されたモデル名
			cake_field     : options.field,    //外部キーの場合、元のデータが格納されたフィールド名
			
			//--------------------------
			// サイズによる分岐
			//--------------------------
			//パッケージ関連
			p_area_cls     : 'box_area'  + ((options.mini)?'_mini':''), //ComboBox + 削除ボタン
			p_acbox_cls    : 'combo_box' + ((options.mini)?'_mini':''), //ComboBox
			p_add_cls      : 'add_area'  + ((options.mini)?'_mini':''), //追加ボタン
			p_del_cls      : 'del_area'  + ((options.mini)?'_mini':''), //削除ボタン

			//ComboBox関連
			combo_class    : 'ac_combobox_area' + ((options.mini)?'_mini':''), //ComboBox全体を囲む<div>
			table_class    : 'ac_table'         + ((options.mini)?'_mini':''), //ComboBoxの<table>
			input_class    : 'ac_input'         + ((options.mini)?'_mini':''), //テキストボックス
			button_class   : 'ac_button'        + ((options.mini)?'_mini':''), //ボタンのCSSクラス
			btn_on_class   : 'ac_btn_on'        + ((options.mini)?'_mini':''), //ボタン(mover時)
			btn_out_class  : 'ac_btn_out'       + ((options.mini)?'_mini':''), //ボタン(mout時)
			re_area_class  : 'ac_result_area'   + ((options.mini)?'_mini':''), //結果リストの<div>
			navi_class     : 'ac_navi'          + ((options.mini)?'_mini':''), //ページナビを囲む<div>
			results_class  : 'ac_results'       + ((options.mini)?'_mini':''), //候補一覧を囲む<ul>
			select_class   : 'ac_over'          + ((options.mini)?'_mini':''), //選択中の<li>
			match_class    : 'ac_match'         + ((options.mini)?'_mini':''), //ヒット文字の<span>
			sub_info_class : 'ac_attached'      + ((options.mini)?'_mini':''), //サブ情報

			//画像総合
			button_img     : options.img_dir + 'combobox_button' + ((options.mini)?'_mini':'') + '.png',
			load_img       : options.img_dir + 'ajax-loader'     + ((options.mini)?'_mini':'') + '.gif',
			select_ok_img  : options.img_dir + 'select_ok'       + ((options.mini)?'_mini':'') + '.png',
			select_ng_img  : options.img_dir + 'select_ng'       + ((options.mini)?'_mini':'') + '.png'
		}, options);

		//************************************************************
		//メッセージを言語別に用意
		//************************************************************
		switch (options.lang){
		
			//日本語
			case 'ja':
				var msg = {
					'add_btn'     : '追加ボタン',
					'add_title'   : '入力ボックスを追加します',
					'del_btn'     : '削除ボタン',
					'del_title'   : '入力ボックスを削除します',
					'next'        : '次へ',
					'next_title'  : '次の'+options.per_page+'件 (右キー)',
					'prev'        : '前へ',
					'prev_title'  : '前の'+options.per_page+'件 (左キー)',
					'first_title' : '最初のページへ (Shift + 左キー)',
					'last_title'  : '最後のページへ (Shift + 右キー)',
					'get_all_btn' : '全件取得 (下キー)',
					'get_all_alt' : '画像:ボタン',
					'close_btn'   : '閉じる (Tabキー)',
					'close_alt'   : '画像:ボタン',
					'loading'     : 'ロード中...',
					'loading_alt' : '画像:ロード中...',
					'page_info'   : 'num_page_top - num_page_end 件 (全 cnt 件)',
					'select_ng'   : '注意 : リストの中から選択してください',
					'select_ok'   : 'OK : 正しく選択されました。'
				};
				break;

			//英語
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

			//スペイン語 (Joaquin G. de la Zerda氏からの提供)
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
