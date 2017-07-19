package com.asiainfo.hbbass.kpiportal.core;

import java.util.List;
import java.util.Map;
@SuppressWarnings({"rawtypes"})
public interface KPIEntityCache {

	public Map getKPIEntities(String date);

	public KPIEntity getKPIEntity(String date, String zbCode);

	public void putKPIEntity(String date, Map map);

	public void removeKPIEntity(String date);

	public List getKeys();

	public int size();

	public String getName();
}
