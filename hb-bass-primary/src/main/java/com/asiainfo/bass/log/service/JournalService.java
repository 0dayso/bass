package com.asiainfo.bass.log.service;


import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.bass.log.dao.JournalDao;
import com.asiainfo.bass.log.model.JournalModel;




@Service
public class JournalService {
	@Autowired
	JournalDao dao;
	 public Map<String,Object> selectjournal(JournalModel journalModel){
		 return dao.selectjournal(journalModel);
	 }
}
