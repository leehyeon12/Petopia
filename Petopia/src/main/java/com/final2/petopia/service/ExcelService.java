package com.final2.petopia.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.final2.petopia.common.ExcelRead;
import com.final2.petopia.common.ExcelReadOption;
import com.final2.petopia.model.ChartVO;
import com.final2.petopia.model.DepositVO;
import com.final2.petopia.model.ExcelDAO;

@Service
public class ExcelService {
	@Autowired
	private ExcelDAO dao;

	public List<DepositVO> selectDepositListForMember(HashMap<String, Object> paraMap) {
		List<DepositVO> depositList = dao.selectDepositListForMember(paraMap);
		return depositList;
	}

	public void excelUploadCareList(File destFile, String idx) {
		ExcelReadOption excelReadOption = new ExcelReadOption();

//		파일경로 추가
		excelReadOption.setFilePath(destFile.getAbsolutePath());
//      추출할 컬럼 명 추가						
//		excelReadOption.setOutputColumns("no", "petcode", "caretype", "contents", "memo", "start", "end", "alarm");
		excelReadOption.setOutputColumns("B", "C", "D", "E", "F", "G", "H");
		// 시작 행
		excelReadOption.setStartRow(4);

		List<HashMap<String, String>> excelContent = ExcelRead.read(excelReadOption);

		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("excelContent", excelContent);
		try {
			dao.insertExcelCare(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public List<ChartVO> selectChartListForMember(HashMap<String, Object> paraMap) {
		List<ChartVO> chartList = dao.selectChartListForMember(paraMap);
		return chartList;
		
	}

}
