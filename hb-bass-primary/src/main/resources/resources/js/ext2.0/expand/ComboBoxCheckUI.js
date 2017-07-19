
/**
 * @singleton
 * @class Ext.ux.util
 *
 * Contains utilities that do not fit elsewhere
 *
 * @author Ing. Jozef Sakálo?
 * @copyright (c) 2009, Ing. Jozef Sakálo?
 * @version 1.0
 * @date 30. January 2009
 * @revision $Id: ComboBoxCheckUI.js,v 1.1 2009/04/05 07:56:24 LiZhijian Exp $
 *
 * @license
 * Ext.ux.util.js is licensed under the terms of
 * the Open Source LGPL 3.0 license. Commercial use is permitted to the extent
 * that the code/component(s) do NOT become part of another Open Source or Commercially
 * licensed development library or toolkit without explicit permission.
 *
 * <p>License details: <a href="http://www.gnu.org/licenses/lgpl.html"
 * target="_blank">http://www.gnu.org/licenses/lgpl.html</a></p>
 *
 * @donate
 * <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">
 * <input type="hidden" name="cmd" value="_s-xclick">
 * <input type="hidden" name="hosted_button_id" value="3430419">
 * <input type="image" src="https://www.paypal.com/en_US/i/btn/x-click-butcc-donate.gif"
 * border="0" name="submit" alt="PayPal - The safer, easier way to pay online.">
 * <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
 * </form>
 */

Ext.ns('Ext.ux.util');

// {{{
/**
 * @param {String} s
 * @return {String} MD5 sum
 * Calculates MD5 sum of the argument
 * @forum 28460
 * @author <a href="http://extjs.com/forum/member.php?u=13648">wm003</a>
 * @version 1.0
 * @date 20. March 2008
 *
 */
Ext.ux.util.MD5 = function(s) {
var hexcase = 0;
var chrsz = 8;

function safe_add(x, y){
var lsw = (x & 0xFFFF) + (y & 0xFFFF);
var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
return (msw << 16) | (lsw & 0xFFFF);
}
function bit_rol(num, cnt){
return (num << cnt) | (num >>> (32 - cnt));
}
function md5_cmn(q, a, b, x, s, t){
return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b);
}
function md5_ff(a, b, c, d, x, s, t){
return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
}
function md5_gg(a, b, c, d, x, s, t){
return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
}
function md5_hh(a, b, c, d, x, s, t){
return md5_cmn(b ^ c ^ d, a, b, x, s, t);
}
function md5_ii(a, b, c, d, x, s, t){
return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
}

function core_md5(x, len){
x[len >> 5] |= 0x80 << ((len) % 32);
x[(((len + 64) >>> 9) << 4) + 14] = len;
var a = 1732584193;
var b = -271733879;
var c = -1732584194;
var d = 271733878;
for(var i = 0; i < x.length; i += 16){
var olda = a;
var oldb = b;
var oldc = c;
var oldd = d;
a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
c = md5_ff(c, d, a, b, x[i+ 2], 17, 606105819);
b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
d = md5_ff(d, a, b, c, x[i+ 5], 12, 1200080426);
c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
a = md5_ff(a, b, c, d, x[i+ 8], 7 , 1770035416);
d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
a = md5_ff(a, b, c, d, x[i+12], 7 , 1804603682);
 d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
 c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
 b = md5_ff(b, c, d, a, x[i+15], 22, 1236535329);
 a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
 d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
 c = md5_gg(c, d, a, b, x[i+11], 14, 643717713);
 b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
 a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
 d = md5_gg(d, a, b, c, x[i+10], 9 , 38016083);
 c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
 b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
 a = md5_gg(a, b, c, d, x[i+ 9], 5 , 568446438);
 d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
 c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
 b = md5_gg(b, c, d, a, x[i+ 8], 20, 1163531501);
 a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
 d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
 c = md5_gg(c, d, a, b, x[i+ 7], 14, 1735328473);
 b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);
 a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
 d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
 c = md5_hh(c, d, a, b, x[i+11], 16, 1839030562);
 b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
 a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
 d = md5_hh(d, a, b, c, x[i+ 4], 11, 1272893353);
 c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
 b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
 a = md5_hh(a, b, c, d, x[i+13], 4 , 681279174);
 d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
 c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
 b = md5_hh(b, c, d, a, x[i+ 6], 23, 76029189);
 a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
 d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
 c = md5_hh(c, d, a, b, x[i+15], 16, 530742520);
 b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);
 a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
 d = md5_ii(d, a, b, c, x[i+ 7], 10, 1126891415);
 c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
 b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
 a = md5_ii(a, b, c, d, x[i+12], 6 , 1700485571);
 d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
 c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
 b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
 a = md5_ii(a, b, c, d, x[i+ 8], 6 , 1873313359);
 d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
 c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
 b = md5_ii(b, c, d, a, x[i+13], 21, 1309151649);
 a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
 d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
 c = md5_ii(c, d, a, b, x[i+ 2], 15, 718787259);
 b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);
 a = safe_add(a, olda);
 b = safe_add(b, oldb);
 c = safe_add(c, oldc);
 d = safe_add(d, oldd);
 }
 return [a, b, c, d];
 }
 function str2binl(str){
 var bin = [];
 var mask = (1 << chrsz) - 1;
 for(var i = 0; i < str.length * chrsz; i += chrsz) {
 bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32);
 }
 return bin;
 }
 function binl2hex(binarray){
 var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
 var str = "";
 for(var i = 0; i < binarray.length * 4; i++) {
 str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) + hex_tab.charAt((binarray[i>>2] >> ((i%4)*8 )) & 0xF);
 }
 return str;
 }
 return binl2hex(core_md5(str2binl(s), s.length * chrsz));
};

/**
 * Clone Function
 * @param {Object/Array} o Object or array to clone
 * @return {Object/Array} Deep clone of an object or an array
 * @author Ing. Jozef Sakálo?
 */
Ext.ux.util.clone = function(o) {
 if(!o || 'object' !== typeof o) {
 return o;
 }
 if('function' === typeof o.clone) {
 return o.clone();
 }
 var c = '[object Array]' === Object.prototype.toString.call(o) ? [] : {};
 var p, v;
 for(p in o) {
 if(o.hasOwnProperty(p)) {
 v = o[p];
 if(v && 'object' === typeof v) {
 c[p] = Ext.ux.util.clone(v);
 }
 else {
 c[p] = v;
 }
 }
 }
 return c;
};
/**
 * Copies the source object properties with names that match target object properties to the target.
 * Undefined properties of the source object are ignored even if names match.
 * This way it is possible to create a target object with defaults, apply source to it not overwriting
 * target defaults with <code>undefined</code> values of source.
 * @param {Object} t The target object
 * @param {Object} s (optional) The source object. Equals to scope in which the function runs if omitted. That
 * allows to set this function as method of any object and then call it in the scope of that object. E.g.:
 * <pre>
 * var p = new Ext.Panel({
 * &nbsp; prop1:11
 * &nbsp; ,prop2:22
 * &nbsp; ,<b>applyMatching:Ext.ux.util.applyMatching</b>
 * &nbsp; // ...
 * });
 * var t = p.applyMatching({prop1:0, prop2:0, prop3:33});
 * </pre>
 * The resulting object:
 * <pre>
 * t = {prop1:11, prop2:22, prop3:33};
 * </pre>
 * @return {Object} Original passed target object with properties updated from source
 */
Ext.ux.util.applyMatching = function(t, s) {
 var s = s || this;
 for(var p in t) {
 if(t.hasOwnProperty(p) && undefined !== s[p]) {
 t[p] = s[p];
 }
 }
 return t;
}; 
/**
 * Same as {@link Ext#override} but overrides only if method does not exist in the target class
 * @member Ext
 * @param {Object} origclass
 * @param {Object} overrides
 */
Ext.overrideIf = 'function' === typeof Ext.overrideIf ? Ext.overrideIf : function(origclass, overrides) {
 if(overrides) {
 var p = origclass.prototype;
 for(var method in overrides) {
 if(!p[method]) {
 p[method] = overrides[method];
 }
 }
 }
};

/**
 * @class RegExp
 */
if('function' !== typeof RegExp.escape) {
 /**
 * Escapes regular expression
 * @param {String} s
 * @return {String} The escaped string
 * @static
 */
 RegExp.escape = function(s) {
 if('string' !== typeof s) {
 return s;
 }
 return s.replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1');
 };
}
Ext.overrideIf(RegExp, {

 /**
 * Clones RegExp object
 * @return {RegExp} Clone of this RegExp
 */
 clone:function() {
 return new RegExp(this);
 } // eo function clone
});

Ext.overrideIf(Array, {
 // {{{
 /**
 * One dimensional copy. Use {@link Ext.ux.util#clone Ext.ux.util.clone} to deeply clone an Array.
 * @member Array
 * @return {Array} New Array that is copy of this
 */
 copy:function() {
 var a = [];
 for(var i = 0, l = this.length; i < l; i++) {
 a.push(this[i]);
 }
 return a;
 } 
 /**
 * Not used anyway as Ext has its own indexOf
 * @member Array
 * @return {Integer} Index of v or -1 if not found
 * @param {Mixed} v Value to find indexOf
 * @param {Integer} b Starting index
 */
 ,indexOf:function(v, b) {
 for(var i = +b || 0, l = this.length; i < l; i++) {
 if(this[i] === v) {
 return i;
 }
 }
 return -1;
 } 
 /**
 * Returns intersection of this Array and passed arguments
 * @member Array
 * @return {Array} Intersection of this and passed arguments
 * @param {Mixed} arg1 (optional)
 * @param {Mixed} arg2 (optional)
 * @param {Mixed} etc. (optional)
 */
 ,intersect:function() {
 if(!arguments.length) {
 return [];
 }
 var a1 = this, a2, a;
 for(var k = 0, ac = arguments.length; k < ac; k++) {
 a = [];
 a2 = arguments[k] || [];
 for(var i = 0, l = a1.length; i < l; i++) {
 if(-1 < a2.indexOf(a1[i])) {
 a.push(a1[i]);
 }
 }
 a1 = a;
 }
 return a.unique();
 } 
 /**
 * Returns last index of passed argument
 * @member Array
 * @return {Integer} Index of v or -1 if not found
 * @param {Mixed} v Value to find indexOf
 * @param {Integer} b Starting index
 */
 ,lastIndexOf:function(v, b) {
 b = +b || 0;
 var i = this.length;
 while(i-- > b) {
 if(this[i] === v) {
 return i;
 }
 }
 return -1;
 } 
 /**
 * @member Array
 * @return {Array} New Array that is union of this and passed arguments
 * @param {Mixed} arg1 (optional)
 * @param {Mixed} arg2 (optional)
 * @param {Mixed} etc. (optional)
 */
 ,union:function() {
 var a = this.copy(), a1;
 for(var k = 0, ac = arguments.length; k < ac; k++) {
 a1 = arguments[k] || [];
 for(var i = 0, l = a1.length; i < l; i++) {
 a.push(a1[i]);
 }
 }
 return a.unique();
 } 
 /**
 * Removes duplicates from array
 * @member Array
 * @return {Array} New Array with duplicates removed
 */
 ,unique:function() {
 var a = [], i, l = this.length;
 for(i = 0; i < l; i++) {
 if(a.indexOf(this[i]) < 0) {
 a.push(this[i]);
 }
 }
 return a;
 } 

});



// Check RegExp.escape dependency
if('function' !== typeof RegExp.escape) {
throw('RegExp.escape function is missing. Include Ext.ux.util.js file.');
}

Ext.ns('Ext.ux.form');

/**
 * Creates new LovCombo
 * @constructor
 * @param {Object} config A config object
 */
Ext.ux.form.LovCombo = Ext.extend(Ext.form.ComboBox, {

// {{{
// configuration options
/**
* @cfg {String} checkField Name of field used to store checked state.
* It is automatically added to existing fields.
* (defaults to "checked" - change it only if it collides with your normal field)
*/
checkField:'checked'

/**
* @cfg {String} separator Separator to use between values and texts (defaults to "," (comma))
*/
,separator:','

/**
* @cfg {String/Array} tpl Template for items.
* Change it only if you know what you are doing.
*/
// }}}
// {{{
,constructor:function(config) {
config = config || {};
config.listeners = config.listeners || {};
Ext.applyIf(config.listeners, {
scope:this
,beforequery:this.onBeforeQuery
,blur:this.onRealBlur
});
Ext.ux.form.LovCombo.superclass.constructor.call(this, config);
} // eo function constructor
// }}}
// {{{
,initComponent:function() {

// template with checkbox
if(!this.tpl) {
this.tpl =
'<tpl for=".">'
+'<div class="x-combo-list-item">'
+'<img src="' + Ext.BLANK_IMAGE_URL + '" '
 +'class="ux-lovcombo-icon ux-lovcombo-icon-'
 +'{[values.' + this.checkField + '?"checked":"unchecked"' + ']}">'
 +'<div class="ux-lovcombo-item-text">{' + (this.displayField || 'text' )+ '}</div>'
 +'</div>'
 +'</tpl>'
 ;
 }

 // call parent
 Ext.ux.form.LovCombo.superclass.initComponent.apply(this, arguments);

 // remove selection from input field
 this.onLoad = this.onLoad.createSequence(function() {
 if(this.el) {
 var v = this.el.dom.value;
 this.el.dom.value = '';
 this.el.dom.value = v;
 }
 });

 } // eo function initComponent
 // }}}
 // {{{
 /**
 * Disables default tab key bahavior
 * @private
 */
 ,initEvents:function() {
 Ext.ux.form.LovCombo.superclass.initEvents.apply(this, arguments);

 // disable default tab handling - does no good
 this.keyNav.tab = false;

 } // eo function initEvents
 // }}}
 // {{{
 /**
 * Clears value
 */
 ,clearValue:function() {
 this.value = '';
 this.setRawValue(this.value);
 this.store.clearFilter();
 this.store.each(function(r) {
 r.set(this.checkField, false);
 }, this);
 if(this.hiddenField) {
 this.hiddenField.value = '';
 }
 this.applyEmptyText();
 } // eo function clearValue
 // }}}
 // {{{
 /**
 * @return {String} separator (plus space) separated list of selected displayFields
 * @private
 */
 ,getCheckedDisplay:function() {
 var re = new RegExp(this.separator, "g");
 return this.getCheckedValue(this.displayField).replace(re, this.separator + ' ');
 } // eo function getCheckedDisplay
 // }}}
 // {{{
 /**
 * @return {String} separator separated list of selected valueFields
 * @private
 */
 ,getCheckedValue:function(field) {
 field = field || this.valueField;
 var c = [];

 // store may be filtered so get all records
 var snapshot = this.store.snapshot || this.store.data;

 snapshot.each(function(r) {
 if(r.get(this.checkField)) {
 c.push(r.get(field));
 }
 }, this);

 return c.join(this.separator);
 } // eo function getCheckedValue
 // }}}
 // {{{
 /**
 * beforequery event handler - handles multiple selections
 * @param {Object} qe query event
 * @private
 */
 ,onBeforeQuery:function(qe) {
 qe.query = qe.query.replace(new RegExp(RegExp.escape(this.getCheckedDisplay()) + '[ ' + this.separator + ']*'), '');
 } // eo function onBeforeQuery
 // }}}
 // {{{
 /**
 * blur event handler - runs only when real blur event is fired
 * @private
 */
 ,onRealBlur:function() {
 this.list.hide();
 var rv = this.getRawValue();
 var rva = rv.split(new RegExp(RegExp.escape(this.separator) + ' *'));
 var va = [];
 var snapshot = this.store.snapshot || this.store.data;

 // iterate through raw values and records and check/uncheck items
 Ext.each(rva, function(v) {
 snapshot.each(function(r) {
 if(v === r.get(this.displayField)) {
 va.push(r.get(this.valueField));
 }
 }, this);
 }, this);
 this.setValue(va.join(this.separator));
 this.store.clearFilter();
 } // eo function onRealBlur
 // }}}
 // {{{
 /**
 * Combo's onSelect override
 * @private
 * @param {Ext.data.Record} record record that has been selected in the list
 * @param {Number} index index of selected (clicked) record
 */
 ,onSelect:function(record, index) {
 if(this.fireEvent('beforeselect', this, record, index) !== false){

 // toggle checked field
 record.set(this.checkField, !record.get(this.checkField));

 // display full list
 if(this.store.isFiltered()) {
 this.doQuery(this.allQuery);
 }

 // set (update) value and fire event
 this.setValue(this.getCheckedValue());
 this.fireEvent('select', this, record, index);
 }
 } // eo function onSelect
 // }}}
 // {{{
 /**
 * Sets the value of the LovCombo
 * @param {Mixed} v value
 */
 ,setValue:function(v) {
 if(v) {
 v = '' + v;
 if(this.valueField) {
 this.store.clearFilter();
 this.store.each(function(r) {
 var checked = !(!v.match(
 '(^|' + this.separator + ')' + RegExp.escape(r.get(this.valueField))
 +'(' + this.separator + '|$)'))
 ;

 r.set(this.checkField, checked);
 }, this);
 this.value = this.getCheckedValue();
 this.setRawValue(this.getCheckedDisplay());
 if(this.hiddenField) {
 this.hiddenField.value = this.value;
 }
 }
 else {
 this.value = v;
 this.setRawValue(v);
 if(this.hiddenField) {
 this.hiddenField.value = v;
 }
 }
 if(this.el) {
 this.el.removeClass(this.emptyClass);
 }
 }
 else {
 this.clearValue();
 }
 } // eo function setValue
 // }}}
 // {{{
 /**
 * Selects all items
 */
 ,selectAll:function() {
 this.store.each(function(record){
 // toggle checked field
 record.set(this.checkField, true);
 }, this);

 //display full list
 this.doQuery(this.allQuery);
 this.setValue(this.getCheckedValue());
 } // eo full selectAll
 // }}}
 // {{{
 /**
 * Deselects all items. Synonym for clearValue
 */
 ,deselectAll:function() {
 this.clearValue();
 } // eo full deselectAll
 // }}}

}); // eo extend

// register xtype
Ext.reg('lovcombo', Ext.ux.form.LovCombo);

// eof



Ext.ns('Ext.ux.form');

/*
**
* Creates new ThemeCombo
* @constructor
* @param {Object} config A config object
*/
Ext.ux.form.ThemeCombo = Ext.extend(Ext.form.ComboBox, {
// configurables
themeBlueText: 'Ext Blue Theme'
,themeGrayText: 'Gray Theme'
,themeBlackText: 'Black Theme'
,themeOliveText: 'Olive Theme'
,themePurpleText: 'Purple Theme'
,themeDarkGrayText: 'Dark Gray Theme'
,themeSlateText: 'Slate Theme'
,themeVistaText: 'Vista Theme'
,themePeppermintText: 'Peppermint Theme'
,themePinkText: 'Pink Theme'
,themeChocolateText: 'Chocolate Theme'
,themeGreenText: 'Green Theme'
,themeIndigoText: 'Indigo Theme'
,themeMidnightText: 'Midnight Theme'
,themeSilverCherryText: 'Silver Cherry Theme'
,themeSlicknessText: 'Slickness Theme'
,themeVar:'theme'
,selectThemeText: 'Select Theme'
,themeGrayExtndText:'Gray-Extended Theme'
,lazyRender:true
,lazyInit:true
,cssPath:'/mmp/common/script/ext/resources/css/' // mind the trailing slash

// {{{
,initComponent:function() {

var config = {
store: new Ext.data.SimpleStore({
fields: ['themeFile', {name:'themeName', type:'string'}]
,data: [
['xtheme-default.css', this.themeBlueText]
,['xtheme-gray.css', this.themeGrayText]
,['xtheme-darkgray.css', this.themeDarkGrayText]
,['xtheme-black.css', this.themeBlackText]
,['xtheme-olive.css', this.themeOliveText]
,['xtheme-purple.css', this.themePurpleText]
,['xtheme-slate.css', this.themeSlateText]
,['xtheme-peppermint.css', this.themePeppermintText]
,['xtheme-chocolate.css', this.themeChocolateText]
,['xtheme-green.css', this.themeGreenText]
,['xtheme-indigo.css', this.themeIndigoText]
,['xtheme-midnight.css', this.themeMidnightText]
,['xtheme-silverCherry.css', this.themeSilverCherryText]
,['xtheme-slickness.css', this.themeSlicknessText]
,['xtheme-gray-extend.css', this.themeGrayExtndText]
// ,['xtheme-pink.css', this.themePinkText]
]
})
,valueField: 'themeFile'
,displayField: 'themeName'
,triggerAction:'all'
,mode: 'local'
,forceSelection:true
,editable:false
,fieldLabel: this.selectThemeText
 }; // eo config object

 // apply config
 Ext.apply(this, Ext.apply(this.initialConfig, config));

 this.store.sort('themeName');

 // call parent
 Ext.ux.form.ThemeCombo.superclass.initComponent.apply(this, arguments);

 if(false !== this.stateful && Ext.state.Manager.getProvider()) {
 this.setValue(Ext.state.Manager.get(this.themeVar) || 'xtheme-default.css');
 }
 else {
 this.setValue('xtheme-default.css');
 }

 } // end of function initComponent
 // }}}
 // {{{
 ,setValue:function(val) {
 Ext.ux.form.ThemeCombo.superclass.setValue.apply(this, arguments);

 // set theme
 Ext.util.CSS.swapStyleSheet(this.themeVar, this.cssPath + val);

 if(false !== this.stateful && Ext.state.Manager.getProvider()) {
 Ext.state.Manager.set(this.themeVar, val);
 }
 } // eo function setValue
 // }}}

}); // end of extend

// register xtype
Ext.reg('themecombo', Ext.ux.form.ThemeCombo);

