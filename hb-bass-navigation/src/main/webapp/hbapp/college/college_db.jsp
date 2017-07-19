<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="com.asiainfo.bass.components.models.ConnectionManage"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Iterator"%>
<%
	String oper = request.getParameter("oper");//delete 
	Connection conn = null;
	PreparedStatement ps = null;
	if("delete".equalsIgnoreCase(oper)) {
	    //一般是XHR发出的请求，有可能是同步的
	    String deleteSql = request.getParameter("delSql");
	    System.out.println(deleteSql);
	    String[] params = request.getParameterValues("params");
	    System.out.println(params);
	    try{
		    conn = ConnectionManage.getInstance().getDWConnection();
			ps = conn.prepareStatement(deleteSql);
			for(int i = 0 ; i < params.length ; i ++) {
				 System.out.println(java.net.URLDecoder.decode(params[i],"UTF-8"));
			    ps.setString(i+1,new String(java.net.URLDecoder.decode(params[i],"UTF-8")));
			}
			int counts = ps.executeUpdate();
			if(counts>=1) {
			    log.info("删除成功! " + counts + "条记录删除(1条为正常)");
			    out.print("{success:true,msg : '删除成功!" + counts + "条记录删除.'}");	
			} else if(counts == 0) {
			    log.info("删除失败! " + counts + "条记录删除(1条为正常)");
			    out.print("{success:false,msg : '删除失败!'}");				    
			}
	    	
	    } catch(Exception e) {
	        out.print("{success:false,msg : '删除失败!'" + e.getMessage() + "}");
		    e.printStackTrace();
		} finally {
		    ConnectionManage.getInstance().releaseConnection(conn);
		}
	} else if("update".equalsIgnoreCase(oper)) {
	    checker(request);
	    String[] ids = (String[])request.getParameterValues("collegeId");
	    if(ids != null) {
	        String sql1 = " update nwh.college_info set manager= ?, manager_nbr=? where college_id=?";
	        Map map = request.getParameterMap();
	        //多声明几个ps变量
	        PreparedStatement psKeyManI = null;
	        PreparedStatement psKeyManU = null;
	        PreparedStatement psBeginDateI = null;
	        PreparedStatement psBeginDateU = null;
	        PreparedStatement psSaleManI = null;
	        PreparedStatement psSaleManU = null;
	        try{
	            conn = ConnectionManage.getInstance().getDWConnection();
	            conn.setAutoCommit(false);
	            ps = conn.prepareStatement(sql1);
	        	
	            Set keys = map.keySet();
		        Iterator it = keys.iterator();
	            for(int i = 0 ; i < ids.length; i++) {
		            log.info("id : " + ids[i]);
		            ps.setString(1,new String(request.getParameter("manager" + ids[i])));
		            System.out.println(request.getParameter("manager" + ids[i]));
		            ps.setString(2,new String(request.getParameter("managerNbr" + ids[i])));
		            ps.setString(3,ids[i]);
		            ps.addBatch();
		            String KEYMAN_SMPL = "keyMan";
		            String BEGINDATE_SMPL = "beginDate";
		            String SALEMAN_SMPL = "saleMan";
		            boolean hasKeyManI = false;
		            boolean hasBeginDateI = false;
		            boolean hasSaleManI = false;
		            boolean hasKeyManU = false;
		            boolean hasBeginDateU = false;
		            boolean hasSaleManU = false;
		        	//for(Object key : keys) {
			        while(it.hasNext()) {
		        		Object key = it.next();    
		        	    /*
		        	   // if(((String)key).contains(id))
		        	      //  key = ((String)key).replace(id,"");
		        	  		//else nothing . id本身不需要替换,还有 oper ,也没有加编码。
		        	  */  
		        	  //遍历key,确定三类六种信息是否存在
		        	  	if(!((String)key).contains(ids[i]))
		        	  	    continue;//不是当前id
	       		     	if(((String)key).startsWith(KEYMAN_SMPL)) {
		        	    	//有关键人信息
		        	    	hasKeyManI = true;
		        	    } else if(((String)key).startsWith(SALEMAN_SMPL)) {
		        	        hasSaleManI = true;
		        	    } else if(((String)key).startsWith(BEGINDATE_SMPL)) {
		        	        hasBeginDateI = true;
		        	    }
	  		    	 	if(((String)key).startsWith("update@" + KEYMAN_SMPL)) {
		        	    	//有关键人信息[更新]
		        	    	hasKeyManU = true;
		        	    } else if(((String)key).startsWith("update@" + SALEMAN_SMPL)) {
		        	        hasSaleManU = true;
		        	    } else if(((String)key).startsWith("update@" + BEGINDATE_SMPL)) {
		        	        hasBeginDateU = true;
		        	    }
		        		if(hasKeyManI && hasBeginDateI && hasSaleManI && hasKeyManU && hasBeginDateU && hasSaleManU)
		        		    break;
		        	}
		        	if(hasKeyManI) {
		        	    String sqlKeyManI = " insert into NWH.COLLEGE_KEYMAN(KEY_NAME,position,department,link_nbr,office_nbr,college_id,note)" + 
	        	    	" values (?,?,?,?,?,?,?)";
		        	    if(psKeyManI == null)psKeyManI = conn.prepareStatement(sqlKeyManI);
	        	    	for(int j = 0 ; j < 5; j ++) {
	        	    	    String preKey = KEYMAN_SMPL + "@" + ids[i] + "_" + (j+1);
	        	    		if(request.getParameter(preKey.replace("@","Name"))!= null) {
	        	    		    //j+1有记录
	        	    		    psKeyManI.setString(1,new String(request.getParameter(preKey.replace("@","Name"))));
	        	    		    psKeyManI.setString(2,new String(request.getParameter(preKey.replace("@","Position"))));
	        	    		    psKeyManI.setString(3,new String(request.getParameter(preKey.replace("@","Dept"))));
	        	    		    psKeyManI.setString(4,new String(request.getParameter(preKey.replace("@","LinkNbr"))));
	        	    		    psKeyManI.setString(5,new String(request.getParameter(preKey.replace("@","OfficeNbr"))));
	        	    		    psKeyManI.setString(6,ids[i]);
	        	    		    psKeyManI.setString(7,new String(request.getParameter(preKey.replace("@","Note"))));
	        	    			psKeyManI.addBatch();
	        	    		}
	        	    	}
		        	}
		        	if(hasBeginDateI) {
		        	    String sqlBeginDateI = " insert into NWH.COLLEGE_TERM_BEGINDATE (college_id,year,spring_term_begin,autumn_term_begin)" + 
	        	    	" values (?,?,?,?)";
		        	    if(psBeginDateI == null)psBeginDateI = conn.prepareStatement(sqlBeginDateI);
	        	    	for(int j = 0 ; j < 5; j ++) {
	        	    	    String preKey = BEGINDATE_SMPL + "@" + ids[i] + "_" + (j+1);
	        	    		if(request.getParameter(preKey.replace("@","Year"))!= null) {
	        	    		    //j+1有记录
	        	    		    psBeginDateI.setString(1,ids[i]);
	        	    		    /* psBeginDateI.setString(2,new String(request.getParameter(preKey.replace("@","Year")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psBeginDateI.setString(3,new String(request.getParameter(preKey.replace("@","SpringDate")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psBeginDateI.setString(4,new String(request.getParameter(preKey.replace("@","AutumnDate")).getBytes("iso-8859-1"),"gb2312")); */
	        	    		    psBeginDateI.setString(2,new String(request.getParameter(preKey.replace("@","Year"))));
	        	    		    psBeginDateI.setString(3,new String(request.getParameter(preKey.replace("@","SpringDate"))));
	        	    		    psBeginDateI.setString(4,new String(request.getParameter(preKey.replace("@","AutumnDate"))));
	        	    		    psBeginDateI.addBatch();
	        	    		}
	        	    	}
		        	}
		        	if(hasSaleManI) {
		        	    String sqlSaleManI = " insert into NWH.COLLEGE_SALESMAN(direct_team,direct_team_name,team_type,bossstaff_id,channel_id,college_id,leader_name,leader_nbr,leader_mail,note)" + 
	        	    	" values (?,?,?,?,?,?,?,?,?,?)";
		        	    if(psSaleManI == null)psSaleManI = conn.prepareStatement(sqlSaleManI);
	        	    	for(int j = 0 ; j < 5; j ++) {
	        	    	    String preKey = SALEMAN_SMPL + "@" + ids[i] + "_" + (j+1);
	        	    		if(request.getParameter(preKey.replace("@","TeamCode"))!= null) {
	        	    		    //j+1有记录
	        	    		    //psSaleManI = conn.prepareStatement(sqlSaleManI);
	        	    		 /*    psSaleManI.setString(1,new String(request.getParameter(preKey.replace("@","TeamCode")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(2,new String(request.getParameter(preKey.replace("@","TeamName")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(3,new String(request.getParameter(preKey.replace("@","TeamType")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(4,new String(request.getParameter(preKey.replace("@","BossstaffId")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(5,new String(request.getParameter(preKey.replace("@","ChannelId")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(6,ids[i]);
	        	    		    psSaleManI.setString(7,new String(request.getParameter(preKey.replace("@","LeaderName")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(8,new String(request.getParameter(preKey.replace("@","LeaderNbr")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(9,new String(request.getParameter(preKey.replace("@","LeaderEmail")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManI.setString(10,new String(request.getParameter(preKey.replace("@","Note")).getBytes("iso-8859-1"),"gb2312")); */
	        	    		    psSaleManI.setString(1,new String(request.getParameter(preKey.replace("@","TeamCode"))));
	        	    		    psSaleManI.setString(2,new String(request.getParameter(preKey.replace("@","TeamName"))));
	        	    		    psSaleManI.setString(3,new String(request.getParameter(preKey.replace("@","TeamType"))));
	        	    		    psSaleManI.setString(4,new String(request.getParameter(preKey.replace("@","BossstaffId"))));
	        	    		    psSaleManI.setString(5,new String(request.getParameter(preKey.replace("@","ChannelId"))));
	        	    		    psSaleManI.setString(6,ids[i]);
	        	    		    psSaleManI.setString(7,new String(request.getParameter(preKey.replace("@","LeaderName"))));
	        	    		    psSaleManI.setString(8,new String(request.getParameter(preKey.replace("@","LeaderNbr"))));
	        	    		    psSaleManI.setString(9,new String(request.getParameter(preKey.replace("@","LeaderEmail"))));
	        	    		    psSaleManI.setString(10,new String(request.getParameter(preKey.replace("@","Note"))));
	        	    			psSaleManI.addBatch();
	        	    		}
	        	    	}
		        	}
		        	if(hasKeyManU) {
		        	    String sqlKeyManU = " update NWH.COLLEGE_KEYMAN set position=?,department=?,link_nbr=?,office_nbr=?,note=? where KEY_NAME=? and college_id=? ";
		        	    if(psKeyManU == null)psKeyManU = conn.prepareStatement(sqlKeyManU);
		        	    //psKeyManU = conn.prepareStatement(sqlKeyManU);
	        	    	int keyManSize = Integer.parseInt(request.getParameter(ids[i] + KEYMAN_SMPL + "Size"));
		        	    for(int j = 0 ; j < keyManSize; j ++) {
	        	    	    String preKey = "update@" + KEYMAN_SMPL + "%" + ids[i] + "_" + (j+1);//%为替换标记
	        	    		if(request.getParameter(preKey.replace("%","Name"))!= null) {
	        	    		    //j+1有记录
	        	    		   /*  psKeyManU.setString(6,new String(request.getParameter(preKey.replace("%","Name")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psKeyManU.setString(1,new String(request.getParameter(preKey.replace("%","Position")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psKeyManU.setString(2,new String(request.getParameter(preKey.replace("%","Dept")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psKeyManU.setString(3,new String(request.getParameter(preKey.replace("%","LinkNbr")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psKeyManU.setString(4,new String(request.getParameter(preKey.replace("%","OfficeNbr")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psKeyManU.setString(7,ids[i]);
	        	    		    psKeyManU.setString(5,new String(request.getParameter(preKey.replace("%","Note")).getBytes("iso-8859-1"),"gb2312")); */
	        	    		    psKeyManU.setString(6,new String(request.getParameter(preKey.replace("%","Name"))));
	        	    		    psKeyManU.setString(1,new String(request.getParameter(preKey.replace("%","Position"))));
	        	    		    psKeyManU.setString(2,new String(request.getParameter(preKey.replace("%","Dept"))));
	        	    		    psKeyManU.setString(3,new String(request.getParameter(preKey.replace("%","LinkNbr"))));
	        	    		    psKeyManU.setString(4,new String(request.getParameter(preKey.replace("%","OfficeNbr"))));
	        	    		    psKeyManU.setString(7,ids[i]);
	        	    		    psKeyManU.setString(5,new String(request.getParameter(preKey.replace("%","Note"))));
	        	    			psKeyManU.addBatch();
	        	    		}
	        	    	}
		        	}
		        	if(hasSaleManU) {
		        	   	String sqlSaleManU = " update NWH.COLLEGE_SALESMAN set direct_team_name=?,team_type=?,bossstaff_id=?,channel_id=?,leader_name=?,leader_nbr=?,leader_mail=?,note=? where direct_team=? and college_id=?";
		        	    //psSaleManU = conn.prepareStatement(sqlSaleManU);
	        	    	 if(psSaleManU == null)psSaleManU = conn.prepareStatement(sqlSaleManU);
		        	    int saleManSize = Integer.parseInt(request.getParameter(ids[i] + SALEMAN_SMPL + "Size"));
		        	    for(int j = 0 ;j < saleManSize; i ++) {
	        	    	    String preKey = "update@" + SALEMAN_SMPL + "%" + ids[i] + "_" + (j+1);//%为替换标记
	        	    		if(request.getParameter(preKey.replace("%","TeamCode"))!= null) {
	        	    		    //j+1有记录
	        	    		    /* psSaleManU = conn.prepareStatement(sqlSaleManU);
	        	    		    psSaleManU.setString(9,new String(request.getParameter(preKey.replace("%","TeamCode")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(1,new String(request.getParameter(preKey.replace("%","TeamName")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(2,new String(request.getParameter(preKey.replace("%","TeamType")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(3,new String(request.getParameter(preKey.replace("%","BossstaffId")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(4,new String(request.getParameter(preKey.replace("%","ChannelId")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(10,ids[i]);
	        	    		    psSaleManU.setString(5,new String(request.getParameter(preKey.replace("%","LeaderName")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(6,new String(request.getParameter(preKey.replace("%","LeaderNbr")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(7,new String(request.getParameter(preKey.replace("%","LeaderEmail")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psSaleManU.setString(8,new String(request.getParameter(preKey.replace("%","Note")).getBytes("iso-8859-1"),"gb2312")); */
	        	    		    psSaleManU = conn.prepareStatement(sqlSaleManU);
	        	    		    psSaleManU.setString(9,new String(request.getParameter(preKey.replace("%","TeamCode"))));
	        	    		    psSaleManU.setString(1,new String(request.getParameter(preKey.replace("%","TeamName"))));
	        	    		    psSaleManU.setString(2,new String(request.getParameter(preKey.replace("%","TeamType"))));
	        	    		    psSaleManU.setString(3,new String(request.getParameter(preKey.replace("%","BossstaffId"))));
	        	    		    psSaleManU.setString(4,new String(request.getParameter(preKey.replace("%","ChannelId"))));
	        	    		    psSaleManU.setString(10,ids[i]);
	        	    		    psSaleManU.setString(5,new String(request.getParameter(preKey.replace("%","LeaderName"))));
	        	    		    psSaleManU.setString(6,new String(request.getParameter(preKey.replace("%","LeaderNbr"))));
	        	    		    psSaleManU.setString(7,new String(request.getParameter(preKey.replace("%","LeaderEmail"))));
	        	    		    psSaleManU.setString(8,new String(request.getParameter(preKey.replace("%","Note"))));
	        	    			psSaleManU.addBatch();
	        	    		}
	        	    	}
		        	}
		        	
		        	if(hasBeginDateU) {
		        	    //修改会覆盖修改时间为当前时间
		        	    String sqlBeginDateU = " update NWH.COLLEGE_TERM_BEGINDATE set spring_term_begin=?,autumn_term_begin=?,status_date=current_date where college_id=? and year=?";
		        	    //psBeginDateU = conn.prepareStatement(sqlBeginDateU);
	        	    	if(psBeginDateU == null)psBeginDateU = conn.prepareStatement(sqlBeginDateU);
		        	    int beginDateSize = Integer.parseInt(request.getParameter(ids[i] + BEGINDATE_SMPL + "Size"));
		        	    for(int j = 0 ; j < beginDateSize; i ++) {
	        	    	    String preKey = "update@" + BEGINDATE_SMPL + "%" + ids[i] + "_" + (j+1);//%为替换标记
	        	    		if(request.getParameter(preKey.replace("%","Year"))!= null) {
	        	    		    //j+1有记录
	        	    		    psBeginDateU.setString(3,ids[i]);
	        	    		   /*  psBeginDateU.setString(4,new String(request.getParameter(preKey.replace("%","Year")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psBeginDateU.setString(1,new String(request.getParameter(preKey.replace("%","SpringDate")).getBytes("iso-8859-1"),"gb2312"));
	        	    		    psBeginDateU.setString(2,new String(request.getParameter(preKey.replace("%","AutumnDate")).getBytes("iso-8859-1"),"gb2312")); */
	        	    		    psBeginDateU.setString(4,new String(request.getParameter(preKey.replace("%","Year"))));
	        	    		    psBeginDateU.setString(1,new String(request.getParameter(preKey.replace("%","SpringDate"))));
	        	    		    psBeginDateU.setString(2,new String(request.getParameter(preKey.replace("%","AutumnDate"))));
	        	    		    psBeginDateU.addBatch();
	        	    		}
	        	    	}
		        	}
		        }
		        if(ps != null) log.info("更新成功! rows : " + ps.executeBatch().length);
		        if(psSaleManU != null) log.info("更新成功! rows : " + psSaleManU.executeBatch());
		        if(psSaleManI != null) log.info("更新成功! rows : " + psSaleManI.executeBatch());
		        if(psBeginDateU != null) log.info("更新成功! rows : " + psBeginDateU.executeBatch());
		        if(psBeginDateI != null) log.info("更新成功! rows : " + psBeginDateI.executeBatch());
		        if(psKeyManU != null) log.info("更新成功! rows : " + psKeyManU.executeBatch());
		        if(psKeyManI != null) log.info("更新成功! rows : " + psKeyManI.executeBatch());
	        	conn.commit();
		        log.debug("全部更新成功!");
		        out.print("<script type='text/javascript'>alert('更新成功!');</script>");
	        } catch(Exception e) {
	            e.printStackTrace();
	            //提示更新失败
	            conn.rollback();
	            log.info("回退成功!");
	            out.print("<script type='text/javascript'>alert('更新失败,请检查输入正确性，或联系管理员。系统错误如下:" + e.getMessage() + "');</script>");
	        } finally {
			    ConnectionManage.getInstance().releaseConnection(conn);
			}
	        
	    } else {
	        //提示不需要更新
	    }
	    	        
	}
%>
<%! private static Logger log = Logger.getLogger("collegedb");
	
	private void checker(HttpServletRequest request)throws Exception {

		/*
		//String[] collegeIds = request.getParameterValues("collegeId");
		
		//System.out.println("encoding : " + request.getCharacterEncoding());
	//request.setCharacterEncoding("gb2312");	
	//for(String id : collegeIds)
		    //System.out.println("collegeIds : " + id);
		//Map map = request.getParameterMap();
		//Set keySet = map.keySet();
		//Iterator it = keySet.iterator();
		//while(it.hasNext()){
		//    Object key = it.next();
		 //   String[] vals = (String[])map.get(key);
		//    for(String val : vals) {
		//        val = new String(val.getBytes("iso-8859-1"),"gb2312");
		//        System.out.println("key : " + key + "\t value : " + val);
		//    }
		//}*/
	}

%>