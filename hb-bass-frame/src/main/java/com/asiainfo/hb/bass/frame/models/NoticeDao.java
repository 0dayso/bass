package com.asiainfo.hb.bass.frame.models;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.frame.models.MenuDao.DbSysNoticeQuery;
import com.asiainfo.hb.core.models.BaseDao;

@Repository
public class NoticeDao extends BaseDao {
	
	public List<NoticeBean> getSystemNotices(){
		String sql = "select * from sys_notice order by notice_end_dt desc";
		return jdbcTemplate.query(sql,new DbSysNoticeQuery());
	}
	
	public List<NoticeBean> queryNotice(String noticetitle,String noticemsg,String notice_start_dt,String notice_end_dt){
		String sql = "select * from sys_notice where 1=1 ";
		if(noticetitle != null && !"".equals(noticetitle)){
			sql += " and noticetitle like '%"+noticetitle+"%'";
		}
		if(noticemsg != null && !"".equals(noticemsg)){
			sql += " and noticemsg like '%"+noticemsg+"%'";
		}
		if(notice_start_dt != null && !"".equals(notice_start_dt)){
			sql += " and notice_start_dt >= timestamp('"+notice_start_dt+"')";
		}
		if(notice_end_dt != null && !"".equals(notice_end_dt)){
			sql += " and notice_end_dt <= timestamp('"+notice_end_dt+"')";
		}
		sql += " order by notice_end_dt desc";
		return jdbcTemplate.query(sql,new DbSysNoticeQuery());
	}
	
	public void saveNotice(String noticetitle,String noticemsg,String notice_start_dt,String notice_end_dt,String extend_color,String status,String creator){
		String sql = "insert into sys_notice(noticeid,notice_start_dt,notice_end_dt,noticetitle,noticemsg,extend_color,creator,status)"+
					 "values((select max(noticeid)+1 from sys_notice),?,?,?,?,?,?,?)";
		jdbcTemplate.update(sql,notice_start_dt,notice_end_dt,noticetitle,noticemsg,extend_color,creator,status);
	}
	
	public void publishNotice(String noticeId,String status){
		String sql = "update sys_notice set status=? where noticeid=?";
		jdbcTemplate.update(sql,status,noticeId);
	}
	
	public void removeNotice(String noticeId){
		String sql = "delete from sys_notice where noticeid=?";
		jdbcTemplate.update(sql,noticeId);
	}
	
	public void updateNotice(String noticeId,String noticetitle,String  noticemsg,String notice_start_dt,String notice_end_dt,String extend_color,String status){
		String sql = "update sys_notice set noticetitle=?,noticemsg=?,notice_start_dt=?,notice_end_dt=?,extend_color=?,status=? where noticeId=?";
		jdbcTemplate.update(sql,noticetitle,noticemsg,notice_start_dt,notice_end_dt,extend_color,status,noticeId);
	}
	
}
