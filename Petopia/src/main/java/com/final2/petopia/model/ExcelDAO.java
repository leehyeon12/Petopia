package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ExcelDAO {
//	===== #DI(의존객체) 주입하기
	@Autowired
	private SqlSessionTemplate sqlsession;	
	String ns = "excel.";
	public List<DepositVO> selectDepositListForMember(HashMap<String, Object> paraMap) {
		List<DepositVO> depositList = sqlsession.selectList(ns+"selectDepositListForMember", paraMap);
		return depositList;
	}
	public void insertExcelCare(HashMap<String, Object> paraMap) {
		
		sqlsession.insert(ns+"insertExcelCare", paraMap);
		
	}
	public List<ChartVO> selectChartListForMember(HashMap<String, Object> paraMap) {
		List<ChartVO> chartList = sqlsession.selectList(ns+"selectChartListForMember", paraMap);
		return chartList;
	}

}
