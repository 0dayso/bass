package com.asiainfo.hb.web.models;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.csvreader.CsvWriter;
import net.sf.json.JSONArray;

@Repository
public class SqlDao extends CommonDao {
	private static Logger logger = Logger.getLogger(SqlDao.class);
	
	public List<Map<String, Object>> excuteSql(String sqlStr) {
		return jdbcTemplate.queryForList(sqlStr);
	}
	

	public void  excuteSqlOper(String sqlStr) {
		 jdbcTemplate.execute(sqlStr);
	}
	
	/**
	 * 动态获取要查询的sql结果集的第一个字段
	 * @param sqlStr
	 * @return
	 */
	public String getColumns(String sqlStr) {
		Connection conn = null;
		PreparedStatement pre = null;
		ResultSetMetaData rmd = null;
		String column = null;
		String [] columns=null;
		try {
			conn = jdbcTemplate.getDataSource().getConnection();
			 pre = conn.prepareStatement(sqlStr);
			 rmd = pre.getMetaData();
			 int count = rmd.getColumnCount();
			 columns = new String[count];
			 for(int i= 1;i<=count;i++){
					columns[i-1] =rmd.getColumnName(i);
				}
			 column=columns[0];
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(conn!=null){
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return column;
	}
	
	/**
	 * 
	 * 分页
	 * @param sql
	 * @param page
	 * @param rows
	 * @param order
	 * @return
	 */
	public Map<String, Object> sqlPaging(String sql, String page, String rows,String order) {
		logger.debug("querySqlPaging-------------------------------->");
		String totalRows = sql;
		String totalPage = "select count(1) as count from(" +sql+")";
		return page(totalRows, totalPage, Integer.parseInt(rows), Integer.parseInt(page),order);
	}
	

    @SuppressWarnings("unused")
	public void genCsvFile(String sql,String filePath) throws IOException{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet=null;
	//	 判断文件是否存在,存在则删除,然后创建新表格
		File tmp = new File(filePath);
		if (tmp.exists()){

		    if (tmp.delete()){
		        logger.info(filePath +"已删除副本文件!");
		    }
		}

		// 创建CSV写对象
		CsvWriter csvWriter = new CsvWriter(filePath,',', Charset.forName("GBK"));

		// 数据查询开始
		try {
			connection = jdbcTemplate.getDataSource().getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();

			// 获取结果集表头
			ResultSetMetaData md = resultSet.getMetaData();
			int columnCount = md.getColumnCount();
			logger.debug("返回结果字段个数:" + columnCount);

			JSONArray columnName = new JSONArray();
			for (int i = 1; i <= columnCount; i++) {
			//JSONObject object = new JSONObject();
			//object.put("column",md.getColumnName(i));
			columnName.add(md.getColumnName(i));
			}
			// 获取表头数组
			int columnSize = columnName.size();
			String[] columnNameList =getJsonToStringArray(columnName);
			csvWriter.writeRecord(columnNameList);
			// 数据记录数
			int i = 0;
			// 临时数据存储
			StringBuffer stringBuffer = new StringBuffer();
			while (resultSet.next()) {
			    // 记录号
			    i++;
			    // 依据列名获取各列值
			    for (int j = 1; j<=columnSize; j++){

			        String value = resultSet.getString(j);
			        //创建列
			        stringBuffer.append(value);
			        if (j != columnSize){
			            stringBuffer.append(",");
			        }
			    }
			    String buffer_string = stringBuffer.toString();
			    String[] content = buffer_string.split(",");
			    csvWriter.writeRecord(content);
			    stringBuffer.setLength(0);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(connection!=null){
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		// 文件输出
		csvWriter.flush();
		csvWriter.close();
	}
    
    public static String[] getJsonToStringArray(JSONArray jsonArray) {   
        String[] arr=new String[jsonArray.size()];   
        for(int i=0;i<jsonArray.size();i++){   
            arr[i]=jsonArray.getString(i);   
            //System.out.println(arr[i]);   
        }   
        return arr;   
  }  
    
    
    public String generateFilename(){  
        String filename = "";  
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");  
        filename += "data_";  
        filename += sdf.format(new Date());  
        filename += ".csv";  
        return filename;  
    }  
    
    
    //测试  
    public static void main(String args[]) throws Exception {  
    	SqlDao dao=new SqlDao();
    	String sql="select name  from sysibm.sysschemata ";
    	String filePath="e:/";
    	dao.genCsvFile(sql,filePath);
    }
    
    
}