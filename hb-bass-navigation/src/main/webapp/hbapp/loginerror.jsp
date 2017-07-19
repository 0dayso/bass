<%@ page contentType="text/html; charset=utf-8"  %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>信息提示</title>
<style>
<!--
a            { color: #FFFFFF; text-decoration: none }
a:link       { text-decoration: none; color: #FFFFFF; font-family: 宋体 }
a:visited    { text-decoration: none; color: #FFFFFF; font-family: 宋体 }
a:hover      { text-decoration: underline; color: #CCCCCC }
a:active     { text-decoration: underline; color: #CCCCCC }
body         { font-size: 9pt }
table        { font-size: 9pt }
.bt { font-family: 宋体; font-size: 16px }
-->
</style>
</head>
<body>

<br>
<TABLE height="72%" cellSpacing=0 cellPadding=0 width="80%" align=center border=0>
  <TBODY>
    <TR> 
      <TD height=16> <DIV align=right><IMG height=32 src="${mvcPath}/hbapp/resources/image/default/error01.gif" width=450></DIV></TD>
    </TR>
    <TR> 
      <TD height=338> <TABLE cellSpacing=0 cellPadding=0 width=535 align=center border=0>
          <TBODY>
            <TR> 
              <TD colSpan=3><IMG height=42 src="${mvcPath}/hbapp/resources/image/default/error02.gif" width=534 border=0></TD></TR>
            <TR> 
              <TD width=43 rowSpan=2><IMG height=239 src="${mvcPath}/hbapp/resources/image/default/error03.gif" width=43 border=0></TD>
              <TD class=htd align=middle width=479 bgColor=#f7f7f7 height=228 > <FONT class=bt> 登录超时，请重新登录！<p align="center"><BR> <a href="http://10.25.124.29" target="_parent"><font color="#000000">返回登录页</font></a><BR> </p></TD>
              <TD width=12 rowSpan=2><IMG height=239 src="${mvcPath}/hbapp/resources/image/default/error04.gif" width=12 border=0></TD>
              <TD><IMG height=228 src="" width=1 border=0></TD>
            </TR>
            <TR> 
              <TD><IMG height=11 src="${mvcPath}/hbapp/resources/image/default/error05.gif" width=479 border=0></TD>
              <TD><IMG height=11 src="" width=1  border=0></TD>
            </TR>
          </TBODY>
        </TABLE></TD>
    </TR>
  </TBODY>
</TABLE>
<br>
</body>
</html>
