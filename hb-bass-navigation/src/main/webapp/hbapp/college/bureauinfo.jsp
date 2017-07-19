<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="org.apache.log4j.Logger"%>

<%!
static Logger LOG = Logger.getLogger("com.asiainfo.bureauinfo.jsp");
%>
<%
	String bureauTemp = (String) request.getParameter("bureauTemp");
	String s_area_id = (String) request.getParameter("s_area_id");
	String s_zone_id = (String) request.getParameter("s_zone_id");
	String s_town_id = (String) request.getParameter("s_town_id");
	String bureau_name = (String) request.getParameter("bureau_name");
	String start = (String) request.getParameter("start");
	String limit = (String) request.getParameter("limit");
	if (StringUtils.isNotEmpty(s_area_id)) {
		s_area_id = URLDecoder.decode(s_area_id, "utf-8");
	}
	if (StringUtils.isNotEmpty(s_zone_id)) {
		s_zone_id = URLDecoder.decode(s_zone_id, "utf-8");
	}
	if (StringUtils.isNotEmpty(s_town_id)) {
		s_town_id = URLDecoder.decode(s_town_id, "utf-8");
	}
	if (StringUtils.isNotEmpty(bureau_name)) {
		bureau_name = URLDecoder.decode(bureau_name, "utf-8");
	}

	int index = Integer.parseInt(start);
	int pageSize = Integer.parseInt(limit);
	int end = index + pageSize;
	
	User user = (User) request.getSession().getAttribute("user");

	String cityId = user.getCityId();
	Connection conn = null;
	try {
		conn = ConnectionManage.getInstance().getDWConnection();

		String countsql = "";
		if("0".equals(cityId)){
			countsql = "select count(*) from NWH.DIM_BUREAU_CFG bur"
				+ " left join BUREAU_CFG_COLLEGE_PT bc on bc.status <> 'FAL' and bc.bureau_id = bur.bureau_id "
				+ " where bc.bureau_id is null and bur.AREA_CODE in( select TRIM(CHAR(NEW_CODE)) from mk.bt_area ) ";
		}else{
			countsql = "select count(*) from NWH.DIM_BUREAU_CFG bur"
				+ " left join BUREAU_CFG_COLLEGE_PT bc on bc.status <> 'FAL' and bc.bureau_id = bur.bureau_id "
				+ " where bc.bureau_id is null and bur.AREA_CODE in( select TRIM(CHAR(NEW_CODE)) from mk.bt_area where AREA_CODE=(select area_code from mk.bt_area where area_id=" + cityId + ")) ";
		}
				
		if (StringUtils.isNotEmpty(bureauTemp)) {
			countsql += " and bur." + bureauTemp;
		}
		if (StringUtils.isNotEmpty(s_area_id)) {
			countsql += (" and ucase(bur.county_name) like '%"
					+ s_area_id.toUpperCase() + "%' ");
		}
		if (StringUtils.isNotEmpty(s_zone_id)) {
			countsql += (" and ucase(bur.zone_name) like '%"
					+ s_zone_id.toUpperCase() + "%' ");
		}
		if (StringUtils.isNotEmpty(s_town_id)) {
			countsql += (" and ucase(bur.town_name) like '%"
					+ s_town_id.toUpperCase() + "%' ");
		}
		if (StringUtils.isNotEmpty(bureau_name)) {
			countsql += (" and ucase(bur.bureau_name) like '%"
					+ bureau_name.toUpperCase() + "%' ");
		}
		countsql += " with ur";
		
		LOG.info(countsql);

		PreparedStatement ps = conn.prepareStatement(countsql);
		ResultSet rs = ps.executeQuery();

		StringBuffer buf = null;
		buf = new StringBuffer();

		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}

		if (count > 0) {
			String sql = "";
			if("0".equals(cityId)){
				sql = "select aa.*\n" +
"  from (\n" + 
"    select replace(bur.area_name,'\\','') c1,replace(bur.county_name,'\\','') c2,replace(bur.zone_name,'\\','') c3,bur.zone_code\n" + 
"        c23,replace(bur.town_name,'\\','') c4,bur.bureau_id c0_1,replace(bur.bureau_name,'\\','') c0_2,\n" + 
"        bur.lac_dec c5 , bur.cellid_dec c6 ,bur.eff_date c7 ,\n" + 
"        case\n" + 
"          when bur.cover_type = '1'\n" + 
"            then '城市'\n" + 
"          when bur.cover_type = '2'\n" + 
"            then '县城'\n" + 
"          when bur.cover_type = '3'\n" + 
"            then '市辖农村'\n" + 
"          when cover_type = '4'\n" + 
"            then '县辖农村'\n" + 
"        end c8 ,\n" + 
"        case\n" + 
"          when bur.village_connect_flag = '0'\n" + 
"            then '非村村通小区'\n" + 
"          else '村村通小区'\n" + 
"        end c9 ,\n" + 
"        case\n" + 
"          when bur.cover_business = 1\n" + 
"            then '是'\n" + 
"          else '否'\n" + 
"        end c10 ,\n" + 
"        case\n" + 
"          when bur.cover_hotel = 1\n" + 
"            then '是'\n" + 
"          else '否'\n" + 
"        end c11 ,\n" + 
"        case\n" + 
"          when bur.cover_office = 1\n" + 
"            then '是'\n" + 
"          else '否'\n" + 
"        end c12 ,\n" + 
"        case\n" + 
"          when bur.cover_resident = 1\n" + 
"            then '是'\n" + 
"          else '否'\n" + 
"        end c13 ,\n" + 
"        case\n" + 
"          when bur.terrain = 0\n" + 
"            then '平原'\n" + 
"          when bur.terrain = 1\n" + 
"            then '山区'\n" + 
"          when bur.terrain = 2\n" + 
"            then '丘陵'\n" + 
"        end c14 ,replace(bur.business_hall_name,'\\','') c15 ,bur.bass_create_date c16,\n" + 
"        row_number() over(partition by 1 order by bur.area_name,\n" + 
"        bur.county_name,bur.zone_name,bur.town_name,bur.cellid_dec) as row_num\n" + 
"      from NWH.DIM_BUREAU_CFG bur\n" + 
"        left join (select * from BUREAU_CFG_COLLEGE_PT where status <> 'FAL') bc\n" + 
"        on bc.bureau_id = bur.bureau_id\n" + 
"      where bc.bureau_id is null and bur.AREA_CODE in( select TRIM(CHAR(NEW_CODE)) from mk.bt_area ) ";
			}else{
				sql = "select aa.* from (select bur.area_name c1,bur.county_name c2,bur.zone_name c3,bur.zone_code c23,"
					+ "bur.town_name c4,bur.bureau_id c0_1,bur.bureau_name c0_2,bur.lac_dec c5 , bur.cellid_dec c6 ,"
					+ "bur.eff_date c7 ,case when bur.cover_type = '1' then '城市' when bur.cover_type = '2' then '县城' when bur.cover_type = '3' then '市辖农村' when cover_type = '4' then '县辖农村'  end c8 ,"
					+ "case when bur.village_connect_flag = '0' then '非村村通小区' else '村村通小区' end c9 ,"
					+ "case when bur.cover_business = 1 then '是' else '否' end c10 , case when bur.cover_hotel = 1 then '是' else '否' end c11 ,"
					+ " case when bur.cover_office = 1 then '是' else '否' end c12 , case when bur.cover_resident = 1 then '是' else '否' end c13 ,"
					+ " case when bur.terrain = 0 then '平原' when bur.terrain = 1 then '山区' when bur.terrain = 2 then '丘陵' end c14 ,"
					+ "bur.business_hall_name c15 ,bur.bass_create_date c16,row_number() over(partition by 1 order by bur.area_name,bur.county_name,bur.zone_name,bur.town_name,bur.cellid_dec) as row_num  from NWH.DIM_BUREAU_CFG bur "
					+ " left join BUREAU_CFG_COLLEGE_PT bc on bc.status <> 'FAL' and bc.bureau_id = bur.bureau_id"
					+ " where bc.bureau_id is null and bur.AREA_CODE in( select TRIM(CHAR(NEW_CODE)) from mk.bt_area where AREA_CODE=(select area_code from mk.bt_area where area_id=" + cityId + ")) ";
			}
			
			if (StringUtils.isNotEmpty(bureauTemp)) {
				sql += " and bur." + bureauTemp;
			}
			if (StringUtils.isNotEmpty(s_area_id)) {
				sql += (" and ucase(bur.county_name) like '%"
						+ s_area_id.toUpperCase() + "%' ");
			}
			if (StringUtils.isNotEmpty(s_zone_id)) {
				sql += (" and ucase(bur.zone_name) like '%"
						+ s_zone_id.toUpperCase() + "%' ");
			}
			if (StringUtils.isNotEmpty(s_town_id)) {
				sql += (" and ucase(bur.town_name) like '%"
						+ s_town_id.toUpperCase() + "%' ");
			}
			if (StringUtils.isNotEmpty(bureau_name)) {
				sql += (" and ucase(bur.bureau_name) like '%"
						+ bureau_name.toUpperCase() + "%' ");
			}
			sql += " ) aa";
			sql += " where 1=1 and aa.row_num >" + index
					+ " and aa.row_num <=" + end;
			sql += " with ur";
			
			LOG.info("在/hbapp/college/bureauinfo.jsp中的SQL："+sql);
			
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			buf.append("{Total:").append(count).append(",Info:[");

			for (int i = 0; rs.next(); i++) {
				if (i != 0) {
					buf.append(",");
				}
				buf.append("{c1:'").append(rs.getString(1)).append(
						"',c2:'").append(rs.getString(2)).append(
						"',c3:'").append(rs.getString(3)).append(
						"',c23:'").append(rs.getString(4)).append(
						"',c4:'").append(rs.getString(5)).append(
						"',c0_1:'").append(rs.getString(6)).append(
						"',c0_2:'").append(rs.getString(7)).append(
						"',c5:'").append(rs.getString(8)).append(
						"',c6:'").append(rs.getString(9)).append(
						"',c7:'").append(rs.getString(10)).append(
						"',c8:'").append(rs.getString(11)).append(
						"',c9:'").append(rs.getString(12)).append(
						"',c10:'").append(rs.getString(13)).append(
						"',c11:'").append(rs.getString(14)).append(
						"',c12:'").append(rs.getString(15)).append(
						"',c13:'").append(rs.getString(16)).append(
						"',c14:'").append(rs.getString(17)).append(
						"',c15:'").append(rs.getString(18)).append(
						"',c16:'").append(rs.getString(19)).append(
						rs.getString(1)).append("'}");
			}

			buf.append("]}");
		} else {
			buf.append("{Total:0,Info:[]}");
		}

		rs.close();
		ps.close();

		PrintWriter outs = null;
		outs = response.getWriter();
		outs.write(buf.toString());
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
