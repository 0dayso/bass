package bass.common;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.dimension.BassDimCache;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class SQLSelect
{
  private static final Logger LOG = Logger.getLogger(SQLSelect.class);
  @SuppressWarnings("rawtypes")
private List mappingTagName = null;
  private Connection conn = null;
  
  public SQLSelect() {}
  
  public SQLSelect(Connection conn)
  {
    this.conn = conn;
  }
  
  public SQLSelect(String ds)
  {
	  LOG.info("ds=" + ds);
    this.conn = ConnectionManage.getInstance().getConnection(ds);
  }
  
  @SuppressWarnings("rawtypes")
public SQLSelect(List list)
  {
    this.mappingTagName = list;
  }
  
  public Connection getConnection()
  {
    if (this.conn == null) {
    	LOG.info("默认连接dw");
      return ConnectionManage.getInstance().getDWConnection();
    }
    return this.conn;
  }
  
  public void releaseConnection(Connection conn)
  {
    if (conn != null) {
      try
      {
        conn.close();
      }
      catch (SQLException e)
      {
        e.printStackTrace();
      }
    }
  }
  
  @SuppressWarnings({ "rawtypes", "unchecked" })
protected List executeList(ResultSet rs)
    throws SQLException
  {
    List list = new ArrayList();
    String[] data = (String[])null;
    int width = rs.getMetaData().getColumnCount();
    Map[] maps = (Map[])null;
    if (this.mappingTagName != null)
    {
      maps = new Map[this.mappingTagName.size()];
      for (int i = 0; i < maps.length; i++)
      {
        String temp = (String)this.mappingTagName.get(i);
        if ((temp != null) && (temp.length() > 0))
        {
          if ("area".equalsIgnoreCase(temp))
          {
            Map citymap = BassDimCache.getInstance().get("city");
            Map countymap = BassDimCache.getInstance().get("county");
            countymap.putAll(citymap);
            maps[i] = countymap;
          }
          else
          {
            maps[i] = BassDimCache.getInstance().get(temp);
          }
        }
        else {
          maps[i] = null;
        }
      }
    }
    while (rs.next())
    {
      data = new String[width];
      for (int i = 0; i < width; i++)
      {
        String key = rs.getString(i + 1);
        if ((maps != null) && (maps.length > i) && (maps[i] != null) && (key != null))
        {
          String value = (String)maps[i].get(key);
          data[i] = (value != null ? value : key);
        }
        else
        {
          data[i] = key;
        }
      }
      list.add(data);
    }
    return list;
  }
  
  protected String executeCustomFormat(ResultSet rs)
    throws SQLException
  {
    StringBuffer sb = new StringBuffer();
    int width = rs.getMetaData().getColumnCount();
    while (rs.next())
    {
      sb.append(rs.getString(1));
      for (int i = 1; i < width; i++)
      {
        sb.append("@,");
        sb.append(rs.getString(i + 1));
      }
      sb.append("@|");
    }
    if (sb.length() > 0) {
      sb.delete(sb.length() - 2, sb.length());
    }
    return sb.toString();
  }
  
  @SuppressWarnings("rawtypes")
public List getTotalList(String sql)
  {
    List list = null;
    Connection conn = getConnection();
    try
    {
      ResultSet rs = conn.createStatement().executeQuery(sql);
      LOG.info("execute sql:" + sql);
      list = executeList(rs);
      String size = list!=null ? String.valueOf(list.size()): "null";
      LOG.info("查询结果:" + size);
      rs.close();
    }
    catch (Exception e)
    {
    	LOG.error("查询异常：" + e.getMessage());
      e.printStackTrace();
    }
    finally
    {
      releaseConnection(conn);
    }
    return list;
  }
  
  public String getCustomFormatResult(String sql)
  {
    Connection conn = getConnection();
    String result = null;
    try
    {
      ResultSet rs = conn.createStatement().executeQuery(sql);
      LOG.info("execute sql:" + sql);
      
      result = executeCustomFormat(rs);
      rs.close();
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    finally
    {
      releaseConnection(conn);
    }
    return result;
  }
  
  public static void main(String[] args) {}
}
