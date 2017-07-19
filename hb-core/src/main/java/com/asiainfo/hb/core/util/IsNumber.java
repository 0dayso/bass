/**
 * 
 */
package com.asiainfo.hb.core.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author zhangdongsheng
 *
 */
public class IsNumber {
	public static boolean isNumeric(String str)
    {
          Pattern pattern = Pattern.compile("[0-9]*");
          Matcher isNum = pattern.matcher(str);
          if( !isNum.matches() )
          {
                return false;
          }
          return true;
    }
	 public static boolean isDouble(String str) {
         try {
             Double.parseDouble(str);
             return true;
         }
         catch (NumberFormatException ex) {
             return false;
         }
     }
}
