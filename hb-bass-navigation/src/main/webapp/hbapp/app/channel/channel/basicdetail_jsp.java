package org.apache.jsp.hbapp.app.channel.channel;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase;
import java.util.*;

public final class basicdetail_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=gb2312");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\r\n");

// 用户登录超时判断
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hb-bass-navigation/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	


      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("  <head>\r\n");
      out.write("    <title></title>\r\n");
      out.write("\t<meta http-equiv=\"pragma\" content=\"no-cache\">\r\n");
      out.write("\t<meta http-equiv=\"cache-control\" content=\"no-cache\">\r\n");
      out.write("\t<meta http-equiv=\"expires\" content=\"0\">\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"../../common2/basscommon.js\" charset=\"gb2312\"></script>\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"../../css/bass21.css\" />\r\n");
      out.write("  </head>\r\n");
      out.write("  <script type=\"text/javascript\">\r\n");
 
	SQLQueryBase queryBase = new SQLQueryBase();
	String condition="";
	if(request.getParameter("querytype") != null) {
		if("channel_code".equalsIgnoreCase(request.getParameter("querytype"))) {
			String channel_code = request.getParameter("channel_code");
			condition = " where channel_id='" + channel_code + "'";
		} 
	}
	String sql = "SELECT channel_id ,channel_name ,area_id ,country_id ,MARKET_ORG_ID,MARKET_ORG_CODE,TOWN  ,VILLAGE ,longitude ,dimensionality ,position_type ,bureau_type ,CUSTOMER_VOLUME  ,CHANNEL_MODLE  ,CHANNEL_TYPE    ,Channel_classific ,joint_channel_code ,tenement_type ,connect_type ,channel_level ,Business_start_time ,Business_end_time ,Opening_date ,address ,response_name ,response_phone ,channel_state ,Chain_distribution_type ,exclusiveness_flag ,Mobilephone_store_flag FROM NMK.CHL_INFO " + condition;
	List list = (List)queryBase.query(sql);

      out.write("\r\n");
      out.write("  </script>\r\n");
      out.write("  <body>\r\n");
      out.write("  \r\n");
      out.write("  ");
      out.write("\r\n");
      out.write("  ");

  	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  
      out.write("\r\n");
      out.write("  \t\t <table align=\"center\" width=\"99%\" class=\"grid-tab-blue\" cellspacing=\"1\" cellpadding=\"0\" border=\"0\">\r\n");
      out.write("  \t\t \t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">渠道编码</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_id") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >渠道名称</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_name") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >市州</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("area_id") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >区县</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("country_id") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">区域营销中心（片区）</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("market_org_id") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >区域营销中心编码</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("market_org_code") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >乡镇</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("town") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >行政村</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("village") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">经度（单位：°）</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("longitude") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >纬度（单位：°）</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("dimensionality") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >地理位置类型</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("position_type") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >区域形态</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("bureau_type") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">月均客流量</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("customer_volume") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >经营模式</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_modle") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >渠道基础类型</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_type") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >自有渠道分类</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_classific") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">合建营业厅的渠道编码</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("joint_channel_code") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >自有渠道物业来源类型</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("tenement_type") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >联网方式</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("connect_type") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >自营厅分类/社会渠道分级</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_level") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">营业起始时间</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("business_start_time") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >营业结束时间</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("business_end_time") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >开业时间</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("opening_date") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >渠道地址</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("address") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">渠道联系人</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("response_name") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >联系电话</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("response_phone") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >渠道状态</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("channel_state") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >连锁分销属性</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("chain_distribution_type") );
      out.write("</td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t\t<tr class=\"dim_row\">\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\">是否排他</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("exclusiveness_flag") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" >是否为手机卖场</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\">");
      out.print(lines.get("mobilephone_store_flag") );
      out.write("</td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" ></td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\"></td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_title\" ></td>\r\n");
      out.write("\t\t\t\t<td class=\"dim_cell_content\"></td>\r\n");
      out.write("\t\t\t</tr>\t\t\t\t\t\t\r\n");
      out.write("\t\t</table>\r\n");
  	
		}
 
      out.write("\r\n");
      out.write("\t</body>\r\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
