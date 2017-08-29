$(function(){
	
	function pagerFilter(data) {
		if ($.isArray(data)) { // is array  
			data = {
				total : data.length,
				rows : data
			}
		}
		var dg = $(this);
		var state = dg.data('treegrid');
		var opts = dg.treegrid('options');
		var pager = dg.treegrid('getPager');
		pager.pagination({
			onSelectPage : function(pageNum, pageSize) {
				opts.pageNumber = pageNum;
				opts.pageSize = pageSize;
				pager.pagination('refresh', {
					pageNumber : pageNum,
					pageSize : pageSize
				});
				dg.treegrid('loadData', state.originalRows);
			}
		});
		if (!state.originalRows) {
			state.originalRows = data.rows;
		}
		var topRows = [];
		var childRows = [];
		$.map(state.originalRows, function(row) {
			row._parentId ? childRows.push(row) : topRows.push(row);
		});
		data.total = topRows.length;
		var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		data.rows = $.extend(true, [], topRows.slice(start, end).concat(
				childRows));
		return data;
	}

	var appendMethod = $.fn.treegrid.methods.append;
	var loadDataMethod = $.fn.treegrid.methods.loadData;
	$.extend($.fn.treegrid.methods, {
		clientPaging : function(jq) {
			return jq.each(function() {
				var state = $(this).data('treegrid');
				var opts = state.options;
				opts.loadFilter = pagerFilter;
				var onBeforeLoad = opts.onBeforeLoad;
				opts.onBeforeLoad = function(row, param) {
					state.originalRows = null;
					onBeforeLoad.call(this, row, param);
				}
				$(this).treegrid('loadData', state.data);
				$(this).treegrid('reload');
			});
		},
		loadData : function(jq, data) {
			jq.each(function() {
				$(this).data('treegrid').originalRows = null;
			});
			return loadDataMethod.call($.fn.treegrid.methods, jq, data);
		},
		append : function(jq, param) {
			return jq.each(function() {
				var state = $(this).data('treegrid');
				if (state.options.loadFilter == pagerFilter) {
					$.map(param.data, function(row) {
						row._parentId = row._parentId || param.parent;
						state.originalRows.push(row);
					});
					$(this).treegrid('loadData', state.originalRows);
				} else {
					appendMethod.call($.fn.treegrid.methods, jq, param);
				}
			})
		}
	});
	
});