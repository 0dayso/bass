package com.asiainfo.hb.bass.frame.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.frame.models.NoticeBean;
import com.asiainfo.hb.bass.frame.models.NoticeDao;

@Service
public class NoticeService {
	@Autowired
	NoticeDao noticeDao;
	
	public List<NoticeBean> getSystemNotices(){
		return noticeDao.getSystemNotices();
	}
	
	public List<NoticeBean> queryNotice(String noticetitle,String noticemsg,String notice_start_dt,String notice_end_dt){
		return noticeDao.queryNotice(noticetitle, noticemsg, notice_start_dt, notice_end_dt);
	}
	
	public void addNotice(String noticetitle,String noticemsg,String notice_start_dt,String notice_end_dt,String extend_color,String status,String creator){
		noticeDao.saveNotice(noticetitle, noticemsg, notice_start_dt, notice_end_dt, extend_color, status, creator);
	}
	
	public void publishNotice(String noticeId,String status){
		noticeDao.publishNotice(noticeId,status);
	}
	
	public void removeNotice(String noticeId){
		noticeDao.removeNotice(noticeId);
	}
	
	public void updateNotice(String noticeId,String noticetitle,String noticemsg,String notice_start_dt,String notice_end_dt,String extend_color,String status){
		noticeDao.updateNotice(noticeId,noticetitle, noticemsg, notice_start_dt, notice_end_dt, extend_color, status);
	}
}
