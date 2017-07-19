package com.asiainfo.hbbass.bir;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.sql.Statement;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

/**
 * 
 * @author Mei Kefu
 * @date 2010-1-20
 */
public class BIR implements Job {

	private static Logger LOG = Logger.getLogger(BIR.class);

	public static void main(String[] args) {

		initialize();

		/*
		 * System.out.println(0.6931*0.9241 + 0.4864*0.6486);
		 * 
		 * System.out.println(Math.pow(0.6931, 2)+Math.pow(0.4864,
		 * 2)+Math.pow(0.2746, 2) );
		 * 
		 * System.out.println(Math.pow(0.9241, 2)+Math.pow(0.6486, 2) );
		 * 
		 * System.out.println(Math.sqrt(Math.pow(0.6931, 2)+Math.pow(0.4864,
		 * 2)+Math.pow(0.2746, 2)) * Math.sqrt(Math.pow(0.9241,
		 * 2)+Math.pow(0.6486, 2)) );
		 */

	}

	public static void initialize() {
		// 指标
		// segment();
		// termWeight();
		// indicatorVector();
		// indicatorCorrelation();

		// 应用
		subjectIndicatorSegment();
		termWeight();
		subjectVector();
		subjectCorrelation();
	}

	/**
	 * 
	 */
	public static void segment() {

		Connection conn = null;
		try {
			conn = getConnection();
			Statement stat = conn.createStatement();

			stat.execute("delete from FPF_bir_indicator_segment");

			ResultSet rs = stat.executeQuery("select fullname from FPF_IRS_INDICATOR where appname !='EntGridD' and id not like 'G%' and id not in ('BM0054','K10097')");
			PreparedStatement ps = conn.prepareStatement("insert into FPF_bir_indicator_segment values(?,?)");

			while (rs.next()) {
				String fullname = rs.getString(1);
				ps.setString(1, fullname.replaceAll(",", ""));
				String segment = Segment.segment(fullname);

				ps.setString(2, segment);

				LOG.debug(fullname.replaceAll(",", "") + " " + segment);

				ps.execute();
			}
			ps.close();
			rs.close();
			stat.close();

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			releaseConnection(conn);
		}

	}

	/**
	 * 基于IDF
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void termWeight() {

		Map termCount = new HashMap();

		Connection conn = null;
		try {
			conn = getConnection();
			Statement stat = conn.createStatement();
			stat.execute("delete from FPF_bir_term_weight");
			// ResultSet rs =
			// stat.executeQuery("select segment from FPF_bir_indicator_segment");
			String sql = "select distinct segment from (select indicator,segment from FPF_bir_subject_indicator_segment union all select indicator,segment from FPF_bir_indicator_segment) t";
			ResultSet rs = stat.executeQuery(sql);

			int d = 0;
			while (rs.next()) {
				String segment = rs.getString(1);

				String[] terms = segment.split(",");

				for (int i = 0; i < terms.length; i++) {

					Integer dw = null;
					if (!termCount.containsKey(terms[i])) {
						termCount.put(terms[i], new Integer(1));
					} else {
						dw = (Integer) termCount.get(terms[i]);
						dw++;
						termCount.put(terms[i], dw);
					}

				}
				d++;
			}
			rs.close();
			stat.close();

			PreparedStatement ps = conn.prepareStatement("insert into FPF_bir_term_weight values(?,?)");

			for (Iterator iterator = termCount.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				Integer dw = (Integer) entry.getValue();

				LOG.debug(entry.getKey() + " d:" + d + " dw:" + dw);
				ps.setString(1, (String) entry.getKey());
				ps.setDouble(2, Math.log(Double.valueOf(d) / dw));
				ps.addBatch();
				// ps.execute();
			}
			ps.executeBatch();
			ps.close();

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			releaseConnection(conn);
		}

	}

	/**
	 * 基于IDF*TF
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void indicatorVector() {

		String sql = "select segment from FPF_bir_indicator_segment";

		Map indicatorSegCount = new HashMap();

		Connection conn = null;
		try {
			conn = getConnection();
			Statement stat = conn.createStatement();

			stat.execute("delete from FPF_bir_indicator_vector");

			ResultSet rs = stat.executeQuery(sql);
			while (rs.next()) {
				String segment = rs.getString(1);

				indicatorSegCount.put("," + segment + ",", segment.split(",").length);
			}
			rs.close();
			stat.close();

			stat = conn.createStatement();
			rs = stat.executeQuery("select term,weight from FPF_bir_term_weight");

			Map termWeight = new HashMap();

			while (rs.next()) {
				termWeight.put(rs.getString(1), rs.getDouble(2));
			}
			rs.close();
			stat.close();

			PreparedStatement ps = conn.prepareStatement("insert into FPF_bir_indicator_vector values(?,?,?)");

			for (Iterator iterator = indicatorSegCount.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry indicatorEntry = (Map.Entry) iterator.next();
				String indicatorValue = (String) indicatorEntry.getKey();
				for (Iterator iterator2 = termWeight.entrySet().iterator(); iterator2.hasNext();) {

					Map.Entry termEntry = (Map.Entry) iterator2.next();

					String termValue = (String) termEntry.getKey();

					if (indicatorValue.matches(".*," + termValue + ",.*")) {
						Double idf = (Double) termEntry.getValue();
						Integer segCount = (Integer) indicatorEntry.getValue();
						LOG.debug(indicatorValue + " term:" + termValue + " idf:" + idf + " tf:" + (1d / segCount) + " value:" + idf * (1d / segCount));
						ps.setString(1, indicatorValue.replaceAll(",", ""));
						ps.setString(2, termValue);
						// ps.setString(3, df.format(idf*(1d/segCount)));
						ps.setDouble(3, idf * (1d / segCount));
						ps.execute();
					}
				}
				// ps.executeBatch();
			}
			ps.close();

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			releaseConnection(conn);
		}

	}

	/**
	 * 基于cos(idf*tf)
	 */
	public static void indicatorCorrelation() {

//		String sql = "select a.indicator,b.indicator from FPF_bir_indicator_segment a , FPF_bir_indicator_segment b where a.indicator!=b.indicator";
//
//		Connection conn = null;
//		try {
//			conn = getConnection();
//			Statement stat = conn.createStatement();
//
//			PreparedStatement ps1 = conn.prepareStatement(" insert into bir_indicator_correlation" + " select ?||'',?||'',decimal(va1,11,8)/va2 from(" + " select sum(value(a.value,0)*value(b.value,0)) va1,(sqrt(sum(power(value(a.value,0),2)))*sqrt(sum(power(value(b.value,0),2)))) va2 "
//					+ " from (select * from FPF_bir_indicator_vector where indicator = ?) a full join (select * from FPF_bir_indicator_vector where indicator = ?) b on a.term=b.term" + " ) t where va2!=0 and va1!=0");
//
//			ResultSet rs = stat.executeQuery(sql);
//			while (rs.next()) {
//				String source = rs.getString(1);
//				String target = rs.getString(2);
//
//				ps1.setString(1, source);
//				ps1.setString(2, target);
//				ps1.setString(3, source);
//				ps1.setString(4, target);
//				ps1.execute();
//			}
//			ps1.close();
//			rs.close();
//			stat.close();
//
//		} catch (Exception e) {
//			e.printStackTrace();
//			LOG.error(e.getMessage(), e);
//		} finally {
//			releaseConnection(conn);
//		}
	}

	static String EXCEPT = "(#rspan|#cspan)";

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void subjectIndicatorSegment() {

		String sql = "select distinct id,name from (" + " select id,name from FPF_IRS_SUBJECT where (kind='配置' and status='在用') or kind='动态'" + " union all" + " select distinct sid id,name from FPF_IRS_SUBJECT_INDICATOR  where sid in (select id from FPF_IRS_SUBJECT where (kind='配置' and status='在用') or kind='动态') and name !=''"
				+ " ) t order by 1 ";

		Connection conn = null;
		try {
			Set indis = new HashSet();

			String subjectId = "";

			conn = getConnection();
			Statement stat = conn.createStatement();

			stat.execute("delete from FPF_bir_subject_indicator_segment");
			stat.close();

			PreparedStatement ps1 = conn.prepareStatement(" insert into FPF_bir_subject_indicator_segment(sid,indicator,segment) values (?,?,?)");
			stat = conn.createStatement();
			ResultSet rs = stat.executeQuery(sql);

			while (rs.next()) {
				String sid = rs.getString(1);
				String name = rs.getString(2);

				if (sid.equalsIgnoreCase("5145")) {
					LOG.debug(111);
				}

				if (!subjectId.equalsIgnoreCase(sid)) {
					if (indis.size() > 0) {
						for (Iterator iterator = indis.iterator(); iterator.hasNext();) {
							String object = (String) iterator.next();
							ps1.setInt(1, Integer.parseInt(subjectId));
							ps1.setString(2, object);
							LOG.debug(sid + "-->" + object + "-->" + Segment.segment(object));
							ps1.setString(3, Segment.segment(object));
							// ps1.addBatch();
							ps1.execute();
						}
						// ps1.executeBatch();
					}
					subjectId = sid.intern();
					indis = new HashSet();
				}

				String[] names = name.split(",");

				for (int i = 0; i < names.length; i++) {
					String string = names[i];
					if (!string.matches(EXCEPT)) {
						indis.add(string);
					}
				}
			}
			ps1.close();
			rs.close();
			stat.close();

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			releaseConnection(conn);
		}
	}

	/**
	 * 基于IDF*TF
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void subjectVector() {

		String sql = "select sid,segment from FPF_bir_subject_indicator_segment order by sid";

		String sql1 = "select id,name,kind from FPF_IRS_SUBJECT where (kind='配置' and status='在用') or kind='动态'";

		Connection conn = null;
		try {
			conn = getConnection();

			Statement stat = conn.createStatement();

			ResultSet rs = stat.executeQuery(sql1);

			Map subs = new HashMap();

			while (rs.next()) {
				Map map = new HashMap();

				String id = rs.getString("id");

				map.put("id", id);
				map.put("name", rs.getString("name"));
				map.put("kind", rs.getString("kind"));

				subs.put(id, map);

			}

			rs.close();
			stat.close();

			stat = conn.createStatement();

			rs = stat.executeQuery(sql);

			Map subject = new HashMap();
			Map subjectCount = new HashMap();
			while (rs.next()) {

				String sid = rs.getString("sid");
				String segment = rs.getString("segment");
				if (!subject.containsKey(sid)) {
					subject.put(sid, new HashMap());
					subjectCount.put(sid, Integer.valueOf(0));
				}

				Map termMap = (Map) subject.get(sid);
				String[] segs = segment.split(",");
				Integer subCount = (Integer) subjectCount.get(sid);
				subjectCount.put(sid, Integer.valueOf(subCount.intValue() + segs.length));

				for (int i = 0; i < segs.length; i++) {
					if (!termMap.containsKey(segs[i])) {
						termMap.put(segs[i], Integer.valueOf(0));
					}
					Integer termCount = (Integer) termMap.get(segs[i]);

					termMap.put(segs[i], Integer.valueOf(termCount.intValue() + 1));
				}
			}
			rs.close();

			rs = stat.executeQuery("select term,weight from FPF_bir_term_weight");

			Map termWeight = new HashMap();

			while (rs.next()) {
				termWeight.put(rs.getString(1), rs.getDouble(2));
			}
			rs.close();

			stat.execute("delete from FPF_bir_subject_vector");
			stat.close();

			// 循环插入
			PreparedStatement ps = conn.prepareStatement("insert into FPF_bir_subject_vector values(?,?,?)");
			for (Iterator iterator = subject.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();

				String sid = (String) entry.getKey();
				Map sub = (Map) entry.getValue();

				// 报表的点击率也要在这里加权

				Map subEntity = (Map) subs.get(sid);

				String subKind = (String) subEntity.get("kind");
				String subName = (String) subEntity.get("name");

				int kindOffset = 1;

				if ("配置".equalsIgnoreCase(subKind)) {
					kindOffset = 2;
				}

				int subCount = ((Integer) subjectCount.get(sid)).intValue();
				for (Iterator iterator2 = sub.entrySet().iterator(); iterator2.hasNext();) {
					Map.Entry termEntry = (Map.Entry) iterator2.next();

					String term = (String) termEntry.getKey();
					Integer termCount = (Integer) termEntry.getValue();

					ps.setInt(1, Integer.valueOf(sid));
					ps.setString(2, term);

					Double idf = (Double) termWeight.get(term);

					double value = idf * (Double.valueOf(termCount.intValue()) / Double.valueOf(subCount)) * kindOffset;

					if (subName.matches(".*" + term + ".*")) {// 报表的名称要在这里加权
						value *= 2;
					}

					ps.setDouble(3, value);

					LOG.debug(sid + " " + term + " " + idf + " " + termCount + "  " + subCount + " " + (idf * (Double.valueOf(termCount.intValue()) / Double.valueOf(subCount))));
					ps.addBatch();
				}
				ps.executeBatch();
			}

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			releaseConnection(conn);
		}

	}

	/**
	 * 基于cos(idf*tf)
	 */
	public static void subjectCorrelation() {

		/*
		 * String sql =
		 * "select a.sid,b.sid from (select distinct sid from FPF_bir_subject_vector) a,(select distinct sid from FPF_bir_subject_vector) b where a.sid!=b.sid"
		 * ;
		 * 
		 * Connection conn = null; try{ conn=getConnection(); Statement stat =
		 * conn.createStatement();
		 * 
		 * PreparedStatement ps1 =
		 * conn.prepareStatement(" insert into FPF_bir_subject_correlation"
		 * +" select ?+0,?+0,decimal(va1,11,8)/va2 from(" +
		 * " select sum(value(a.value,0)*value(b.value,0)) va1,(sqrt(sum(power(value(a.value,0),2)))*sqrt(sum(power(value(b.value,0),2)))) va2 "
		 * +
		 * " from (select * from FPF_bir_subject_vector where sid = ?) a full join (select * from FPF_bir_subject_vector where sid = ?) b on a.term=b.term"
		 * +" ) t where va2!=0 and va1!=0");
		 * 
		 * ResultSet rs = stat.executeQuery(sql); while(rs.next()){ String
		 * sourceStr = rs.getString(1); String targetStr = rs.getString(2);
		 * 
		 * int source = Integer.valueOf(sourceStr); int target =
		 * Integer.valueOf(targetStr);
		 * 
		 * ps1.setInt(1, source); ps1.setInt(2, target); ps1.setInt(3, source);
		 * ps1.setInt(4, target); System.out.println(source+" "+target);
		 * ps1.execute(); } ps1.close(); rs.close(); stat.close();
		 * 
		 * }catch(Exception e){ e.printStackTrace(); }finally{
		 * releaseConnection(conn); }
		 */

		String[] sql = {
				"delete from fpf_bir_subject_sid_map",
				"delete from fpf_bir_subject_sid_term_map",
				"INSERT INTO fpf_bir_subject_sid_map select a.sid e1, b.sid e2 from (SELECT distinct sid from FPF_bir_subject_indicator_segment) a,(SELECT distinct sid from FPF_bir_subject_indicator_segment) b WHERE a.sid <> b.sid",
				"INSERT INTO fpf_bir_subject_sid_term_map SELECT a.*, b.term from fpf_bir_subject_sid_map a,(select distinct sid, term from FPF_bir_subject_vector) b where a.e1 = b.sid",
				"merge into fpf_bir_subject_sid_term_map a using (SELECT a.*, b.term from fpf_bir_subject_sid_map a,(select distinct sid, term from FPF_bir_subject_vector) b where a.e2 = b.sid) b on (a.e1 = b.e1 AND a.e2 = b.e2 AND a.term = b.term) when NOT matched then INSERT VALUES (b.e1, b.e2, b.term)",
				"DELETE FROM FPF_bir_subject_correlation",
				"insert into FPF_bir_subject_correlation   select e1, e2, decimal(va1, 11, 8) / va2     from (select e1                 ,e2                 ,sum(value(a.value, 0) * value(b.value, 0)) va1                 ,(sqrt(sum(power(value(a.value, 0), 2))) *                  sqrt(sum(power(value(b.value, 0), 2)))) va2             from fpf_bir_subject_sid_term_map e             left join FPF_bir_subject_vector a               on e.e1 = a.sid              and e.TERM = a.term             left join fpf_bir_subject_vector b               on e.e2 = b.sid              and e.TERM = b.term            group by e1, e2) t    where va1 != 0      and va2 != 0" };

		Connection conn = null;
		try {
			conn = getConnection();
			Statement stat = conn.createStatement();

			for (int i = 0; i < sql.length; i++) {
				stat.execute(sql[i]);
			}
			stat.close();

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			releaseConnection(conn);
		}

	}

	public static Connection getConnection() {
		return ConnectionManage.getInstance().getWEBConnection();
	}

	public static void releaseConnection(Connection conn) {
		ConnectionManage.getInstance().releaseConnection(conn);
	}

	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		LOG.info("开始执行Bir计算");
		initialize();
		LOG.info("成功计算Bir");
	}

	/*
	 * public static Connection getConnection() { Connection conn = null; try {
	 * Class.forName("COM.ibm.db2.jdbc.app.DB2Driver"); conn =
	 * DriverManager.getConnection("jdbc:db2:wbdb", "pt","pt"); } catch
	 * (ClassNotFoundException e) { e.printStackTrace(); } catch (SQLException
	 * e) { e.printStackTrace(); }
	 * 
	 * return conn; }
	 * 
	 * public static void releaseConnection(Connection conn) { if (conn != null)
	 * try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } }
	 */
}
