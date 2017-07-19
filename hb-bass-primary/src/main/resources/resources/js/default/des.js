
function strEncode(data) {
	var operOption = "X";
	return defalutStrEnc(data, operOption);
}
function defalutStrEnc(data, firstKey) {
	//var now1=new Date();
	var leng = data.length;
	var encData = "";
	var firstKeyBt, secondKeyBt, thirdKeyBt, firstLength, secondLength, thirdLength;
	if (firstKey != null && firstKey != "") {
		firstKeyBt = getKeyBytes(firstKey);
		firstLength = firstKeyBt.length;
	}
	if (leng > 0) {
		if (leng < 4) {
			var bt = strToBt(data);
			var encByte;
			if (firstKey != null && firstKey != "") {
				var tempBt;
				var x = 0;
				tempBt = bt;
				for (x = 0; x < firstLength; x++) {
					tempBt = enc(tempBt, firstKeyBt[x]);
				}
				encByte = tempBt;
			}
			encData = bt64ToHex(encByte);
		} else {
			var iterator = leng / 4;
			var remainder = leng % 4;
			var i = 0;
			for (i = 0; i < iterator; i++) {
				var tempData = data.substring(i * 4 + 0, i * 4 + 4);
				var tempByte = strToBt(tempData);
				var encByte;
				if (firstKey != null && firstKey != "") {
					var tempBt;
					var x;
					tempBt = tempByte;
					for (x = 0; x < firstLength; x++) {
						tempBt = enc(tempBt, firstKeyBt[x]);
					}
					encByte = tempBt;
				}
				encData += bt64ToHex(encByte);
			}
			if (remainder > 0) {
				var remainderData = data.substring(iterator * 4 + 0, leng);
				var tempByte = strToBt(remainderData);
				var encByte;
				if (firstKey != null && firstKey != "") {
					var tempBt;
					var x;
					tempBt = tempByte;
					for (x = 0; x < firstLength; x++) {
						tempBt = enc(tempBt, firstKeyBt[x]);
					}
					encByte = tempBt;
				}
				encData += bt64ToHex(encByte);
			}
		}
	}
	//var now2=new Date();
	//alert(now2-now1);
	return encData;
}
function getKeyBytes(key) {
	var keyBytes = new Array();
	var leng = key.length;
	var iterator = parseInt(leng / 4);
	var remainder = leng % 4;
	var i = 0;
	for (i = 0; i < iterator; i++) {
		keyBytes[i] = strToBt(key.substring(i * 4 + 0, i * 4 + 4));
	}
	if (remainder > 0) {
		keyBytes[i] = strToBt(key.substring(i * 4 + 0, leng));
	}
	return keyBytes;
}
/*

* chang the string(it's length <= 4) into the bit array

* 

* return bit array(it's length = 64)

*/
function strToBt(str) {
	var leng = str.length;
	var bt = new Array(64);
	if (leng < 4) {
		var i = 0, j = 0, p = 0, q = 0;
		for (i = 0; i < leng; i++) {
			var k = str.charCodeAt(i);
			for (j = 0; j < 16; j++) {
				var pow = 1, m = 0;
				for (m = 15; m > j; m--) {
					pow *= 2;
				}
				bt[16 * i + j] = (k / pow) % 2;
			}
		}
		for (p = leng; p < 4; p++) {
			var k = 0;
			for (q = 0; q < 16; q++) {
				var pow = 1, m = 0;
				for (m = 15; m > q; m--) {
					pow *= 2;
				}
				bt[16 * p + q] = (k / pow) % 2;
			}
		}
	} else {
		for (i = 0; i < 4; i++) {
			var k = str.charCodeAt(i);
			for (j = 0; j < 16; j++) {
				var pow = 1;
				for (m = 15; m > j; m--) {
					pow *= 2;
				}
				bt[16 * i + j] = (k / pow) % 2;
			}
		}
	}
	return bt;
}
/*

* chang the bit(it's length = 4) into the hex

* 

* return hex

*/
function bt4ToHex(binary) {
	var hex;
	switch (binary) {
	  case "0000":
		hex = "0";
		break;
	  case "0001":
		hex = "1";
		break;
	  case "0010":
		hex = "2";
		break;
	  case "0011":
		hex = "3";
		break;
	  case "0100":
		hex = "4";
		break;
	  case "0101":
		hex = "5";
		break;
	  case "0110":
		hex = "6";
		break;
	  case "0111":
		hex = "7";
		break;
	  case "1000":
		hex = "8";
		break;
	  case "1001":
		hex = "9";
		break;
	  case "1010":
		hex = "A";
		break;
	  case "1011":
		hex = "B";
		break;
	  case "1100":
		hex = "C";
		break;
	  case "1101":
		hex = "D";
		break;
	  case "1110":
		hex = "E";
		break;
	  case "1111":
		hex = "F";
		break;
	}
	return hex;
}
/*

* chang the hex into the bit(it's length = 4)

* 

* return the bit(it's length = 4)

*/
function hexToBt4(hex) {
	var binary;
	switch (hex) {
	  case "0":
		binary = "0000";
		break;
	  case "1":
		binary = "0001";
		break;
	  case "2":
		binary = "0010";
		break;
	  case "3":
		binary = "0011";
		break;
	  case "4":
		binary = "0100";
		break;
	  case "5":
		binary = "0101";
		break;
	  case "6":
		binary = "0110";
		break;
	  case "7":
		binary = "0111";
		break;
	  case "8":
		binary = "1000";
		break;
	  case "9":
		binary = "1001";
		break;
	  case "A":
		binary = "1010";
		break;
	  case "B":
		binary = "1011";
		break;
	  case "C":
		binary = "1100";
		break;
	  case "D":
		binary = "1101";
		break;
	  case "E":
		binary = "1110";
		break;
	  case "F":
		binary = "1111";
		break;
	}
	return binary;
}
/*

* chang the bit(it's length = 64) into the string

* 

* return string

*/
function byteToString(byteData) {
	var str = "";
	for (i = 0; i < 4; i++) {
		var count = 0;
		for (j = 0; j < 16; j++) {
			var pow = 1;
			for (m = 15; m > j; m--) {
				pow *= 2;
			}
			count += byteData[16 * i + j] * pow;
		}
		if (count != 0) {
			str += String.fromCharCode(count);
		}
	}
	return str;
}
function bt64ToHex(byteData) {
	var hex = "";
	for (i = 0; i < 16; i++) {
		var bt = "";
		for (j = 0; j < 4; j++) {
			bt += byteData[i * 4 + j];
		}
		hex += bt4ToHex(bt);
	}
	return hex;
}
function hexToBt64(hex) {
	var binary = "";
	for (i = 0; i < 16; i++) {
		binary += hexToBt4(hex.substring(i, i + 1));
	}
	return binary;
}
function enc(dataByte, keyByte) {
	return xor(dataByte, keyByte);
}
function xor(byteOne, byteTwo) {
	var xorByte = new Array(byteOne.length);
	for (i = 0; i < byteOne.length; i++) {
		if (byteTwo[i]) {
			xorByte[i] = byteOne[i] ^ byteTwo[i];
		} else {
			xorByte[i] = byteOne[i] ^ 0;
		}
	}
	return xorByte;
}


//end-------------------------------------------------------------------------------------------------------------

