package com.asiainfo.hbbass.common.persistence;

import java.sql.SQLException;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-21
 */
@Table(name = "table1")
public class Test extends Persistence {

	@Column(name = "id", type = "int", isPrimaryKey = true, isIncrement = true)
	private String id = "";

	@Column(name = "name")
	private String name = "";

	@Column(name = "content")
	private String content = "";

	public static void main(String[] args) {

		Test test = (Test) Test.parse(Test.class, null);
		try {
			test.save();
			test.update();
			test.delete();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
}
