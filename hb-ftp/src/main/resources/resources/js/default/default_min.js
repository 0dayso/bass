/*  
 * ReportMeta使用的js
 * @author Mei Kefu
 */
/*----------------------------------  基础方法  ----------------------------------------*/
var $ = function(_id){return document.getElementById(_id);}
var $C = function(_tag){return document.createElement(_tag);}
var $CT = function(_text){return document.createTextNode(_text);}
Array.prototype.indexOf = function(value){for(var i=0,l=this.length;i<l;i++)if(this[i]==value)return i;return -1;}
Array.prototype.Remove = function(value){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){return this.splice(i,1);}}
Array.prototype.Replace = function(value,source){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){this[i]=source;break;}}
Array.prototype.ReplaceAll = function(value,source){for(var i=0,l=this.length;i<l;i++)if(this[i]==value){this[i]=source;}}
Array.prototype.Clear = function(){this.splice(0,this.length);}