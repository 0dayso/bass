package com.asiainfo.hbbass.kpiportal.customize;

import bsh.EvalError;
import bsh.Interpreter;

import com.asiainfo.hbbass.kpiportal.core.KPIEntity;

/**
 * 稽核规则类
 * 
 * @author Mei Kefu
 * @date 2010-4-21
 */
public class KPIAudit {

	private KPIEntity kpiEntity = null;

	private String auditExp = "";

	private String areaCode = "HB";

	public KPIAudit(KPIEntity kpiEntity, String auditExp) {
		this.kpiEntity = kpiEntity;
		this.auditExp = auditExp;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String format() {
		String result = "";
		if (kpiEntity != null) {

			if (audit()) {
				KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaCode);

				result = entity.content();
			}
		}

		return result;
	}

	private int rank() {
		int rank = 0;
		if (rank == 0 && !"HB".equalsIgnoreCase(areaCode)) {
			KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaCode);
			String expRules = kpiEntity.getKpiMetaData().getExpRules();
			String orderType = "tongbi";
			if ("年同比".equalsIgnoreCase(expRules)) {
				orderType = "yeartongbi";
			} else if ("绝对值".equalsIgnoreCase(expRules)) {
				orderType = "current";
			}
			KPIEntity.Entity[] entities = entity.getParent().getOrderChildren(orderType);// 根据同比值排名
			for (int i = 0; i < entities.length; i++) {
				rank++;
				if (entities[i].getKey().equalsIgnoreCase(areaCode))
					break;
			}
		}
		return rank;
	}

	public boolean audit() {
		boolean bl = true;// 默认发送短信
		if (auditExp != null && auditExp.trim().length() > 0) {
			String exp = auditExp.replaceAll("and", "&&").replaceAll("or", "||").replaceAll("年同比", "yearbi").replaceAll("同比", "tongbi").replaceAll("环比", "huanbi").replaceAll("值", "val").replaceAll("排名", "rank");
			try {
				KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaCode);

				Interpreter i = new Interpreter();
				i.set("huanbi", entity.getHuanBi());
				i.set("tongbi", entity.getTongBi());
				i.set("yearbi", entity.getYearTongBi());
				i.set("val", entity.getCurrentValue());
				i.set("rank", rank());
				i.eval("bl=" + exp);
				bl = (Boolean) i.get("bl");
			} catch (EvalError e) {
				e.printStackTrace();
			}
		}

		return bl;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {

	}

}
