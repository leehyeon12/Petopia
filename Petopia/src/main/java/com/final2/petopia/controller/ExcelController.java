package com.final2.petopia.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.final2.petopia.model.ChartVO;
import com.final2.petopia.model.DepositVO;
import com.final2.petopia.service.ExcelService;

@Controller
public class ExcelController {
	@Autowired
	private ExcelService service;

	@RequestMapping(value = "/ExcelPoi.pet", method = { RequestMethod.POST })
	public void ExcelPoi(@RequestParam(defaultValue = "test") String fileName, HttpServletRequest req,
			HttpServletResponse res, Model model) throws Exception {
		HSSFWorkbook objWorkBook = new HSSFWorkbook();
		HSSFSheet objSheet = null;
		HSSFRow objRow = null;
		HSSFCell objCell = null;

		// 제목 폰트
		HSSFFont font = objWorkBook.createFont();
		// 글자 크기 설정
		font.setFontHeightInPoints((short) 12);
		// 글자 굵게 하기
		font.setBoldweight((short) font.BOLDWEIGHT_BOLD);
		// 폰트 설정
		font.setFontName("나눔고딕");

		// 제목 스타일에 폰트 적용, 정렬
		HSSFCellStyle styleHd = objWorkBook.createCellStyle();// 제목 스타일 생성
		// 만들어 놓은 폰트 적용
		styleHd.setFont(font);
		// 가운데 정렬 설정
		styleHd.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 수직 중앙 정렬 설정
		styleHd.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		// 본문 폰트
		HSSFFont fontcontent = objWorkBook.createFont();
		// 글자 크기 설정
		fontcontent.setFontHeightInPoints((short) 10);
		// 글자 굵게 하기
		fontcontent.setBoldweight((short) font.BOLDWEIGHT_NORMAL);
		// 폰트 설정
		fontcontent.setFontName("나눔고딕");

		// 제목 스타일에 폰트 적용, 정렬
		HSSFCellStyle styleContent = objWorkBook.createCellStyle();// 제목 스타일 생성
		// 만들어 놓은 폰트 적용
		styleContent.setFont(fontcontent);
		// 가운데 정렬 설정
		styleContent.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 수직 중앙 정렬 설정
		styleContent.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		
		objSheet = objWorkBook.createSheet("admin_depositList"); // 워크시트 생성
		// objSheet.autoSizeColumn(index);

		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		String idx = req.getParameter("idx");
		String type = req.getParameter("type");
		paraMap.put("fk_idx", idx);

		if ("deposit".equals(type)) {
			List<DepositVO> rowList = service.selectDepositListForMember(paraMap);

			// 1행
			objRow = objSheet.createRow(0);
			objRow.setHeight((short) 0x150);

			objCell = objRow.createCell(0);
			objCell.setCellValue("순");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(1);
			objCell.setCellValue("금액");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(2);
			objCell.setCellValue("충전/사용일");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(3);
			objCell.setCellValue("상태");
			objCell.setCellStyle(styleHd);

			int index = 1;
			for (DepositVO dvo : rowList) {
				objRow = objSheet.createRow(index);
				objRow.setHeight((short) 0x150);

				objCell = objRow.createCell(0);
				objCell.setCellValue(dvo.getRno());
				objCell.setCellStyle(styleContent);

				objCell = objRow.createCell(1);
				objCell.setCellValue(dvo.getDepositcoin());
				objCell.setCellStyle(styleContent);

				objCell = objRow.createCell(2);
				objCell.setCellValue(dvo.getDeposit_date());
				objCell.setCellStyle(styleContent);

				objCell = objRow.createCell(3);
				objCell.setCellValue(dvo.getDeposit_status());
				objCell.setCellStyle(styleContent);
				index++;
			}

			for (int i = 0; i < rowList.size(); i++) {
				objSheet.autoSizeColumn(i);
			}
		} else if ("chart".equals(type)) {
			List<ChartVO> rowList = service.selectChartListForMember(paraMap);

			// 1행
			objRow = objSheet.createRow(0);
			objRow.setHeight((short) 0x150);

			objCell = objRow.createCell(0);
			objCell.setCellValue("차트번호");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(1);
			objCell.setCellValue("방문날짜");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(2);
			objCell.setCellValue("병원/약국");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(3);
			objCell.setCellValue("진료 타입");
			objCell.setCellStyle(styleHd);

			objCell = objRow.createCell(4);
			objCell.setCellValue("총 결제 금액");
			objCell.setCellStyle(styleHd);
			
			int index = 1;
			for (ChartVO cvo : rowList) {
				objRow = objSheet.createRow(index);
				objRow.setHeight((short) 0x150);

				objCell = objRow.createCell(0);
				objCell.setCellValue(cvo.getChart_UID());
				objCell.setCellStyle(styleContent);

				objCell = objRow.createCell(1);
				objCell.setCellValue(cvo.getReservation_DATE());
				objCell.setCellStyle(styleContent);

				objCell = objRow.createCell(2);
				objCell.setCellValue(cvo.getBiz_name());
				objCell.setCellStyle(styleContent);

				objCell = objRow.createCell(3);
				objCell.setCellValue(cvo.getChart_type());
				objCell.setCellStyle(styleContent);
				
				objCell = objRow.createCell(4);
				objCell.setCellValue(cvo.getTotalpay());
				objCell.setCellStyle(styleContent);

				
				index++;
			}

			for (int i = 0; i < rowList.size(); i++) {
				objSheet.autoSizeColumn(i);
			}
		}

		res.setContentType("Application/Msexcel");
		res.setHeader("Content-Disposition", "ATTachment; Filename=" + URLEncoder.encode(fileName, "UTF-8") + ".xls");

		OutputStream fileOut = res.getOutputStream();
		objWorkBook.write(fileOut);
		fileOut.close();

		res.getOutputStream().flush();
		res.getOutputStream().close();
	}
	
	@RequestMapping(value="/excelUploadCare.pet", method= {RequestMethod.GET})
	public String excelUpload(HttpServletRequest req, HttpServletResponse res) {
		String idx = req.getParameter("idx");
		
		req.setAttribute("idx", idx);
		
		return "excel/uploadExcel.notiles";
	}
	@RequestMapping(value = "/excelUploadCareAjax.pet", method = {RequestMethod.POST})
	@ResponseBody
	public ModelAndView excelUploadChartAjax(MultipartFile testFile, MultipartHttpServletRequest req) throws Exception {

		System.out.println("업로드 진행");
		String idx = req.getParameter("idx");
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("idx", idx);
		
		MultipartFile excelFile = req.getFile("excelFile");

		if (excelFile == null || excelFile.isEmpty()) {

			throw new RuntimeException("엑셀파일을 선택 해 주세요.");
		}

		File destFile = new File("C:\\" + excelFile.getOriginalFilename());

		try {
			// 내가 설정한 위치에 내가 올린 파일을 만들고
			excelFile.transferTo(destFile);

		} catch (Exception e) {
			throw new RuntimeException(e.getMessage(), e);
		}

		// 업로드를 진행하고 다시 지우기
		service.excelUploadCareList(destFile, idx);

		destFile.delete();
		// FileUtils.delete(destFile.getAbsolutePath());

		ModelAndView view = new ModelAndView();

		view.setViewName("excel/uploadExcel.notiles");

		return view;
	}
	
	
	@RequestMapping(value="/downCareFile.pet", method= {RequestMethod.GET})
	public void requireLogin_downCareFile(HttpServletRequest req, HttpServletResponse res) {

		String saveFilename = "petcare.xlsx";	// 디스크에 올라가있는 파일명
		String orgFilename = "petcare.xlsx";	// 실제 파일명
		
//		#다운받을 파일이 있는 메타데이터 경로 구하기
		HttpSession session = req.getSession();
		String root = session.getServletContext().getRealPath("/");	// >> / == webapp(like webcontent)
		// >> root는 .metadata
		
		String path =root+"resources" +File.separator+"excel"; // 첨부파일들을 저장할 WAS내의 폴더  경로
		
//		#다운로드하기; boolean flag
		boolean flag = false;
		flag = doFileDownload(saveFilename, orgFilename, path, res);
		// >> 다운로드 성공시 true, 실패시 false return
		if(!flag) {
			// 실패시 메시지 띄우기
			res.setContentType("text/html; charset=UTF-8");
			try {
				PrintWriter out = res.getWriter();	// 웹브라우저상에 내용물을 기재하는 객체
				out.println("<script type='text/javascript'>alert('파일 다운로드 실패');</script>");
				
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}
	}
	
	
	
	// ==파일 다운로드==
	// saveFilename : 서버에 저장된 파일명
	// originalFilename : 클라이언트가 업로드한 파일명
	// path : 서버에 저장된 경로
	public boolean doFileDownload(String saveFilename, String originalFilename, String path, HttpServletResponse response) {
		String pathname = path + File.separator + saveFilename;
		
        try {
    		if(originalFilename == null || originalFilename.equals(""))
    			originalFilename = saveFilename;
        	originalFilename = new String(originalFilename.getBytes("UTF-8"),"8859_1");
        } catch (UnsupportedEncodingException e) {
        }

	    try {
	        File file = new File(pathname);

	        if (file.exists()){
	            byte readByte[] = new byte[4096];

	            response.setContentType("application/octet-stream");
				response.setHeader(
						"Content-disposition",
						"attachment;filename=" + originalFilename);

	            BufferedInputStream  fin = new BufferedInputStream(new FileInputStream(file));
	            ServletOutputStream outs = response.getOutputStream(); 
	   			int length = 0;
	    		while ((length = fin.read(readByte, 0, 4096)) != -1) {
	    				outs.write(readByte, 0, length);
	    		}
	    		 
	    		outs.flush();
	    		outs.close();
	            fin.close();
	            
	            return true;
	        }
	    } catch(Exception e) {
	    }
	    
	    return false;
	}
}
