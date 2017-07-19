package com.asiainfo.hb.bass.role.adaptation.models;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.Future;

/**
 * ${DESCRIPTION}
 *
 * @author lijie
 * @date 2016/6/13
 */
@Service
@Async
public class AdapMenuAsyncService {

    @Autowired
    AdapMenuDao adapMenuDao;

    public Future<String> getKpiDataByOneMenuAsync(AdapMenu menu,List<String> list,String time,String dimType,String dimValue){
        adapMenuDao.getKpiDataByOneMenu(menu, list, time, dimType, dimValue);
        return new AsyncResult<String>("done!");
    }
}
