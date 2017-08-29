function monthFormat(date) {
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	return y + '-' + (m < 10 ? ('0' + m) : m)
}
function monthParse(s) {
	if (!s)
		return new Date();
	var y = s.substring(0, 4);
	var m = s.substring(5, 7);
	if (!isNaN(y) && !isNaN(m)) {
		return new Date(y, m - 1);
	} else {
		return new Date();
	}
}
function dayFormat(date) {
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d)
}
function dayParse(s) {
	if (!s)
		return new Date();
	var y = s.substring(0, 4);
	var m = s.substring(5, 7);
	var d = s.substring(8, 10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
		return new Date(y, m - 1, d);
	} else {
		return new Date();
	}
}
