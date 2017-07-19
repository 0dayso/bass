/**
 * 
 */
package com.asiainfo.bass.apps.models;

import java.sql.ResultSet;
import java.sql.SQLException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

/**
 * @author zhangds
 *
 */ 
@Repository
public class SzReportDao {
	
	private static Logger LOG = Logger.getLogger(SzReportDao.class);
			
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@SuppressWarnings("rawtypes")
	static final class SzReportUser implements RowMapper {

		@Override
		public String[] mapRow(ResultSet rs, int index) throws SQLException {
	
			String[] string = new String[2] ;
			string[0] = rs.getString(1);
			string[1] = rs.getString(2);
			return string;
		}
		
	}

	@SuppressWarnings({ "unchecked", "unused" })
	public String getXml(String szToken) {
		StringBuffer stringBuffer = new StringBuffer();
		if (szToken != null && !"".equals(szToken)) {
			try {
				String querySql = "select token,MSTR_USER from sz.mstr_token_info a,sz.MSTR_USER b where a.cityname=b.cityname and token='"
						+ szToken + "'";
				String[] str = (String[]) jdbcTemplate.queryForObject(querySql,
						new SzReportUser());
				if (str != null && str.length > 0) {
					String oldToken = str[0];
					String szUser = str[1];
					if (szUser != null && oldToken != null) {
						String s = Encryption.encrypt(szUser);
						String s1 = Encryption.decrypt(s);
						stringBuffer.append("<?xml version=\"1.0\"?>\r\n");
						stringBuffer.append("<return_code>\r\n");
						stringBuffer.append("<pass userid=\"")
								.append(Encryption.encrypt(szUser))
								.append("\" />\r\n");
						stringBuffer.append("</return_code>\r\n");
					} else {
						stringBuffer.append("<?xml version=\"1.0\"?>\r\n");
						stringBuffer.append("<return_code>\r\n");
						stringBuffer
								.append("<fail msg=\"Cannot validate the token, the token may be invalid or expired.\" />");
						stringBuffer.append("</return_code>\r\n");
					}
				}
			} catch (Exception e) {
				LOG.error(e.getMessage());
			}
		}
		return stringBuffer.toString();
	}
}
