package com.final2.petopia.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.final2.petopia.common.FileManager;
import com.final2.petopia.common.MyUtil;
import com.final2.petopia.model.ConsultCommentVO;
import com.final2.petopia.model.ConsultVO;
import com.final2.petopia.model.MemberVO;
import com.final2.petopia.service.InterConsultService;

@Controller
@Component
public class ConsultController {

	//===== 의존객체 주입(DI:Dependency Injection)  =====
	@Autowired
	private InterConsultService service;
	
	//===== 양방향 암호화 알고리즘인 AES256을 사용하여 암호화/복호화하기 위한 클래스 의존객체 주입(DI:Dependency Injection) =====
	//@Autowired
	//private AES256 aes;
	
	//===== 파일업로드 및 파일다운로드를 해주는 FileManager 클래스 의존객체 주입(DI:Dependency Injection) =====
	@Autowired
	private FileManager fileManager;
	
	// ------------------------------------------------------------------------------------------------------------
	
	
	// 1:1상담 글쓰기 페이지 요청 -------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultAdd.pet", method= {RequestMethod.GET})
	public String requireLogin_consultAdd(HttpServletRequest req, HttpServletResponse res) {
		return "consult/consultAdd.tiles2";
	}
	
	// 1:1상담 글쓰기 완료 -------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultAddEnd.pet", method= {RequestMethod.POST})
	public String consultAddEnd(HttpServletRequest req, HttpServletResponse res, ConsultVO consultvo) {
		// - 1:1상담 글쓰기 consult:insert
		int n = service.insertConsultByCvo(consultvo);
		
		String msg = "";
		String loc = "";
		if(n==1) {
			// 글쓰기 성공시 글목록 보이기
			msg = "글쓰기 성공!";
			loc = req.getContextPath()+"/consultList.pet";
		}
		else {
			// 글쓰기 실패시 글쓰기로
			msg = "글쓰기 실패!";
			loc = req.getContextPath()+"/consultAdd.pet";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
		
	}
	
	
	
	// 1:1상담 리스트 -----------------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultList.pet", method= {RequestMethod.GET})
	public String requireLogin_consultList(HttpServletRequest req, HttpServletResponse res) {
		
		List<ConsultVO> consultList = null;
		
		String colname = req.getParameter("colname");
		String search = req.getParameter("search");
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");
		String idx = req.getParameter("fk_idx");
		String str_membertype = req.getParameter("membertype");

		HttpSession session = req.getSession();
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("COLNAME", colname);
		paraMap.put("SEARCH", search);
		paraMap.put("MEMBERTYPE", str_membertype);
		paraMap.put("IDX", idx);
		
		int totalCount = 0;			// 총게시물 갯수
		int sizePerPage = 10;		// 한 페이지당 보여줄 게시물 갯수
		int currentShowPageNo = 0;	// 현재 보여주는 페이지번호
		int totalPage = 0; 			// 총페이지수 (웹브라우저상에 보여줄 총 페이지 갯수)
		
		int startRno = 0; 			// 시작행번호
		int endRno = 0; 			// 끝행번호
		
		int blockSize = 10;// '페이지바'에 보여줄 페이지의 갯수 
		
		// - [페이징처리 O, 검색조건 O] 전체글 갯수 totalCount
		if(search!=null && !search.trim().equals("") && !search.trim().equals("null")) {
			totalCount = service.selectTotalCountWithSearch(paraMap);
		}
		else {
			// - [페이징처리 O, 검색조건 X] 전체글 갯수 totalCount
			if( idx==null || idx.trim().equals("") || idx.trim().equals("null") ) {
				totalCount = service.selectTotalCountNoSearch();	
			}
			// - [페이징처리 O, 검색조건 X] 일반회원 : 내가쓴글 갯수 totalCount
			else if( idx!=null && !idx.trim().equals("") && !idx.trim().equals("null") 
					&& Integer.parseInt(str_membertype)==1 && Integer.parseInt(str_membertype)!=2 ) {
				totalCount = service.selectMyConsultCountNoSearch(idx);
			}
			// - [페이징처리 O, 검색조건 X] 기업회원 : 내가 댓글 단 글 갯수 totalCount
			else if( idx!=null && !idx.trim().equals("") && !idx.trim().equals("null") 
					&& Integer.parseInt(str_membertype)!=1 && Integer.parseInt(str_membertype)==2 ) {
				totalCount = service.selectBizConsultCountNoSearch(idx);
			}
		}
	
		totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
	
		// 게시판 목록보기 첫화면 (현재페이지번호가 없을경우)
		if(str_currentShowPageNo==null) {
			currentShowPageNo = 1;
		}
		// 게시판 목록보기 특정페이지번호를 보고자 하는 경우
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo<1 || currentShowPageNo>totalPage) { // 페이지가없는 번호를 칠경우
					currentShowPageNo = 1;
				}
			}
			catch (NumberFormatException e) { // 문자칠경우
				currentShowPageNo = 1;
			}
		}
		
		startRno = ((currentShowPageNo-1)*sizePerPage) + 1;
		endRno = startRno + sizePerPage - 1;
		
		paraMap.put("STARTRNO", String.valueOf(startRno));
		paraMap.put("ENDRNO", String.valueOf(endRno));
		
		// - [페이징처리 O, 검색조건 O] 한 페이지 범위마다 보여지는 글목록 // consult:select
		consultList = service.selectConsultListPaging(paraMap);
		
		// ------------------------------------------------------------------------------------------------------------------------------------
		
		String pageBar = "<ul>";
		String str_pageNo = "";
		String url = "consultList.pet";
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize)*blockSize + 1;
		
		// 이전 페이지
		if (pageNo == 1) {
			str_pageNo = "";
		}
		else {
			str_pageNo = "&nbsp;<a href=\""+url+"?currentShowPageNo="+(pageNo-1)+"&sizePerPage="+sizePerPage+"&colname="+colname+"&search="+search+"&membertype="+str_membertype+"&fk_idx="+idx+"\" >"+"[이전]</a>&nbsp;"; 
		}
		pageBar += str_pageNo;
		
		// 현재 페이지
		while(!(pageNo > totalPage || loop > blockSize)){
			
			if (pageNo == currentShowPageNo)
				str_pageNo = "&nbsp;<span style=\"color:#fc766b; font-weight:bold; text-decoration:underline;\">"+pageNo+"</span>&nbsp;";
			else
				str_pageNo = "&nbsp;<a href=\""+url+"?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&colname="+colname+"&search="+search+"&membertype="+str_membertype+"&fk_idx="+idx+"\" >"+pageNo+"</a>" + "&nbsp;";
			
			pageBar += str_pageNo; 
			
			pageNo++;
			loop++;
		}
		
		// 다음 페이지
		if (pageNo > totalPage) {
			str_pageNo = "";
		}
		else {
			str_pageNo = "&nbsp;<a href=\""+url+"?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&colname="+colname+"&search="+search+"&membertype="+str_membertype+"&fk_idx="+idx+"\" >"+"[다음]</a>&nbsp;"; 
		}
		pageBar += str_pageNo;
		
		pageBar += "</ul>";
		
		// ------------------------------------------------------------------------------------------------------------------------------------
		
		session.setAttribute("readCountPermission", "yes");
		
		req.setAttribute("consultList", consultList);
		
		req.setAttribute("colname", colname);
		req.setAttribute("search", search);
		req.setAttribute("pagebar", pageBar);
		
		String goBackURL = MyUtil.getCurrentURL(req);
		//System.out.println("goBackURL : "+goBackURL);
		
		req.setAttribute("goBackURL", goBackURL);
		
		return "consult/consultList.tiles2";
	}
	
	
	// 1:1상담 상세보기 -----------------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultDetail.pet", method= {RequestMethod.GET})
	public String requireLogin_consultDetail(HttpServletRequest req, HttpServletResponse res) {
		
		ConsultVO consultvo = null;

		String consult_UID = req.getParameter("consult_UID");
		String gobackURL = req.getParameter("gobackURL");
		
		// 로그인된 사용자정보 받아오기
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String readCountPermission = (String)session.getAttribute("readCountPermission");

		String userid = null;
		
		if(readCountPermission!=null && "yes".equals(readCountPermission)) {
			
			if(loginuser!=null) {
				userid = loginuser.getUserid();
			}
			
			// - [조회수 증가 O] 글 상세보기
			consultvo = service.selectConsultDetailWithCount(consult_UID, userid);
			
			session.removeAttribute("readCountPermission");
			
		}
		// 글상세보기 후에 새로고침하거나 이전글, 다음글보기인 경우
		else {
			// - [조회수 증가 X] 글 상세보기
			consultvo = service.selectConsultDetailNoCount(consult_UID);
		}

		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("CONSULT_UID", consult_UID);
		int totalCount = service.selectCommentTotalCount(paraMap);
	
		int sizePerPage = 10;
		
		int totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		
		req.setAttribute("totalPage", totalPage);
		req.setAttribute("consultvo", consultvo);
		req.setAttribute("gobackURL", gobackURL);
		
		return "consult/consultDetail.tiles2";
	}
	
	
	// 1:1상담 수정 페이지 요청 ------------------------------------------------------------------------------------
	@RequestMapping(value="/consultEdit.pet", method={RequestMethod.GET})
	public String requireLogin_consultEdit(HttpServletRequest req, HttpServletResponse res) {	
		
		// 글번호 받아오기
		String consult_UID = req.getParameter("consult_UID");
		
		// [조회수증가 없이] 수정할 글 정보 전체 가져오기 
		ConsultVO consultvo = service.selectConsultEditNoCount(consult_UID); //  selectConsultDetailNoCount 이 함수로 사용
		
		// 로그인된 사용자정보 받아오기
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		// !작성자=로그인사용자 
		if(!loginuser.getUserid().equals(consultvo.getUserid())) {
			String msg = "다른 사용자의 글은 수정이 불가합니다.";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
			return "msg";
		}
		// 작성자=로그인사용자 (내가쓴글)이면 view단 페이지로 넘긴다.
		else {
			req.setAttribute("consultvo", consultvo);
			
			return "consult/consultEdit.tiles2";
		}

	} //
	
	
	// 1:1상담 수정 완료 ------------------------------------------------------------------------------------
	@RequestMapping(value="/consultEditEnd.pet", method={RequestMethod.POST})
	public String consultEditEnd(ConsultVO consultvo, HttpServletRequest req) {	
		
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("CONSULT_UID", String.valueOf(consultvo.getConsult_UID()));
		paraMap.put("CS_TITLE", consultvo.getCs_title());
		paraMap.put("CS_CONTENTS", consultvo.getCs_contents());
		paraMap.put("CS_SECRET", String.valueOf(consultvo.getCs_secret()));
		
		// - 글상세 수정하기 
		int result = service.updateConsultDetail(paraMap);
		
		String msg = "";
		String loc = "";
		
		if(result==0) {
			msg = "글수정 실패!";
			loc = "javascript:history.back();";
			
		}
		else {
			msg = "글수정 성공!";
			loc = req.getContextPath()+"/consultDetail.pet?consult_UID="+consultvo.getConsult_UID(); // 수정후 해당글상세 보기
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	}
	
	
	// 1:1상담 삭제 요청 ------------------------------------------------------------------------------------
	@RequestMapping(value="/consultDelete.pet", method={RequestMethod.GET})
	public String requireLogin_consultDelete(HttpServletRequest req, HttpServletResponse res) throws Throwable {
		
		// 삭제해야할 글번호 가져오기
		String consult_UID = req.getParameter("consult_UID");
		
		// [조회수증가 X] 삭제할 글 정보 전체 가져오기
		ConsultVO consultvo = service.selectConsultDeleteNoCount(consult_UID); //  selectConsultDetailNoCount 이 함수로 사용
				
		String msg = "";
		String loc = "";
		
		// 로그인된 사용자정보 받아오기
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		
		System.out.println(consultvo.getUserid());
		// !삭제하는사람=로그인사용자 
		if(!loginuser.getUserid().equals(consultvo.getUserid())) {
			msg = "다른 사용자의 글은 삭제가 불가합니다.";
			loc = "javascript:history.back();";
		}
		// 삭제하는사람=로그인사용자 (내가쓴글)
		else {
			// - 1:1상담글 삭제하기
			int result = service.deleteConsult(consult_UID);
			// result가 1이면 delete 성공
			// result가 0이면 delete 실패
			if(result==0) {
				msg = "글삭제 실패!";
				loc = "javascript:history.back();";
			}
			else {
				msg = "글삭제 성공!";
				loc = req.getContextPath()+"/consultList.pet";
			}
		}
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
		
	} // 
	
	// 썸머노트 이미지파일 업로드 -------------------------------------------------------------------------------------------
	@RequestMapping(value="/summernoteImageUpload.pet", method={RequestMethod.POST})
	@ResponseBody
	public String summernoteImageUpload(MultipartHttpServletRequest req) {

		HttpSession session = req.getSession();
		
		MultipartFile file = req.getFile("file");
		
		String newFileName = "";
		
		if(!file.isEmpty()) {
			
			String root = session.getServletContext().getRealPath("/");
			String path = root + "resources"+File.separator+"img"+File.separator+"consult";
			
			byte[] bytes = null;
			
			try {
				bytes = file.getBytes();
				newFileName = fileManager.doFileUpload(bytes, file.getOriginalFilename(), path);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return newFileName;
	}
	
	// 1:1상담 댓글쓰기 -------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultCommentAdd.pet", method= {RequestMethod.POST})
	@ResponseBody
	public HashMap<String, String> requireLogin_consultCommentAdd(HttpServletRequest req, HttpServletResponse res, ConsultCommentVO commentvo) throws Throwable {
	
		HashMap<String, String> returnMap = new HashMap<String, String>();
			
		int n = service.insertComment(commentvo); // - [consult_comment]commentvo 댓글쓰기 insert + [consult]commentCount 원글의 댓글갯수 1증가 update + [notification] 댓글작성 알림 insert
		
		if(n==1) {
			// 댓글쓰기insert 및 원글의댓글갯수update 성공시
			returnMap.put("CSCMT_NICKNAME", commentvo.getCscmt_nickname());
			returnMap.put("CSCMT_CONTENTS", commentvo.getCscmt_contents());
			returnMap.put("CSCMT_WRITEDAY", MyUtil.getNowTime());
		}
	
		return returnMap;
	}
	
	
	// 1:1상담 댓글보여주기 [Ajax로 페이징처리] -------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultCommentList.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> requireLogin_consultCommentList(HttpServletRequest req, HttpServletResponse res) {
		
		List<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		// 원글의 글번호 가져오기 (원글의 댓글들을 보여주기 위해서)
		String consult_UID = req.getParameter("consult_UID");
		// 현재페이지 가져오기 (처음에는 ready에서 1페이지로 초기화)
		String currentShowPageNo = req.getParameter("currentShowPageNo");
		
		if(currentShowPageNo==null || "".equals(currentShowPageNo)) {
			currentShowPageNo = "1";
		}
		
		int sizePerPage = 10;
		
		int rno1 = Integer.parseInt(currentShowPageNo) * sizePerPage - (sizePerPage-1);
		int rno2 = Integer.parseInt(currentShowPageNo) * sizePerPage;
	
		// service로 보낼값들
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("CONSULT_UID", consult_UID);
		paraMap.put("RNO1", String.valueOf(rno1));
		paraMap.put("RNO2", String.valueOf(rno2));
		
		// 원글의 글번호에 대한 댓글들의 각 페이지 번호에 해당하는 댓글리스트
		List<ConsultCommentVO> commentList = service.selectCommentList(paraMap);
		
		for(ConsultCommentVO commentvo :commentList) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("CMT_ID", commentvo.getCmt_id());
			map.put("FK_CONSULT_UID", commentvo.getFk_consult_UID());
			map.put("FK_IDX", commentvo.getFk_idx());
			map.put("CONSULT_FK_IDX", commentvo.getConsult_fk_idx());
			map.put("CSCMT_NICKNAME", commentvo.getCscmt_nickname());
			map.put("CSCMT_CONTENTS", commentvo.getCscmt_contents());
			map.put("CSCMT_WRITEDAY", commentvo.getCscmt_writeday());
			map.put("FK_CMT_ID", commentvo.getFk_cmt_id());
			map.put("CSCMT_GROUP", commentvo.getCscmt_group());
			map.put("CSCMT_G_ODR", commentvo.getCscmt_g_odr());
			map.put("CSCMT_DEPTH", commentvo.getCscmt_depth());
			map.put("CSCMT_DEL", commentvo.getCscmt_del());
			mapList.add(map);
		}
		return mapList;
	} // 
	
	// 댓글 totalPage가져오기 ----------------------------------------------------------------------------
	@RequestMapping(value="/commentTotalPage.pet", method={RequestMethod.GET})
	@ResponseBody
	public HashMap<String, Integer> commentTotalPage(HttpServletRequest req) {
		
		HashMap<String, Integer> retrunMap = new HashMap<String, Integer>();
		
		String consult_UID = req.getParameter("consult_UID");
		String sizePerPage = req.getParameter("sizePerPage");
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("CONSULT_UID", consult_UID);
		paraMap.put("SIZEPERPAGE", sizePerPage);
		
		// 댓글 총 갯수
		int totalCount = service.selectCommentTotalCount(paraMap);
	
		int totalPage = (int)Math.ceil((double)totalCount/Integer.parseInt(sizePerPage));
		
		retrunMap.put("TOTALPAGE", totalPage);
		
		return retrunMap;
	} // 
	
	// 대댓글 쓰기 -------------------------------------------------------------------------------------------
	@RequestMapping(value="/consultCommentByCommentAdd.pet", method= {RequestMethod.POST})
	@ResponseBody
	public HashMap<String, String> requireLogin_consultCommentByCommentAdd(HttpServletRequest req, HttpServletResponse res, ConsultCommentVO commentvo) throws Throwable {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		HashMap<String, String> returnMap = new HashMap<String, String>();
		
		String fk_cmt_id = req.getParameter("fk_cmt_id");
		String fk_idx = req.getParameter("fk_idx");	// 댓글 작성자
		String org_fk_idx = req.getParameter("org_fk_idx"); // 원댓글 작성자
		String consult_fk_idx = req.getParameter("consult_fk_idx");	// 상담글 작성자
		String str_cscmt_group = req.getParameter("cscmt_group");
		String str_cscmt_g_odr = req.getParameter("cscmt_g_odr");
		String str_cscmt_depth = req.getParameter("cscmt_depth");
		String cscmt_nickname = req.getParameter("cscmt_nickname");
		String cscmt_contents = req.getParameter("cscmt_contents");
		String fk_consult_UID = req.getParameter("fk_consult_UID");
	
		commentvo.setMembertype(loginuser.getMembertype());
		commentvo.setFk_cmt_id(fk_cmt_id);
		commentvo.setFk_idx(fk_idx);
		commentvo.setOrg_fk_idx(org_fk_idx);
		commentvo.setConsult_fk_idx(consult_fk_idx);
		commentvo.setCscmt_group(Integer.parseInt(str_cscmt_group));
		commentvo.setCscmt_g_odr(Integer.parseInt(str_cscmt_g_odr));
		commentvo.setCscmt_depth(Integer.parseInt(str_cscmt_depth));
		commentvo.setCscmt_nickname(cscmt_nickname);
		commentvo.setCscmt_contents(cscmt_contents);
		commentvo.setFk_consult_UID(fk_consult_UID);
		
		// 대댓글 쓰기
		int n = service.insertCommentByComment(commentvo); // - [consult_comment]commentvo 댓글쓰기 insert + [consult]commentCount 원글의 댓글갯수 1증가 update + [notification] 댓글작성 알림 insert
		
		if(n==1) {
			// 대댓글쓰기insert 및 원글의댓글갯수update 성공시
			returnMap.put("CSCMT_NICKNAME", commentvo.getCscmt_nickname());
			returnMap.put("CSCMT_CONTENTS", commentvo.getCscmt_contents());
			returnMap.put("CSCMT_WRITEDAY", MyUtil.getNowTime());
		}
		
		return returnMap;
	}
	
	// 1:1상담 관리자 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 1:1상담 목록 관리자 페이지 요청 -------------------------------------------------------------------------------------------
	@RequestMapping(value="/adminConsultList.pet", method= {RequestMethod.GET})
	public String requireLoginAdmin_adminConsultList(HttpServletRequest req, HttpServletResponse res) {
		
		List<ConsultVO> AdminConsultList = null;
		
		String colname = req.getParameter("colname");
		String search = req.getParameter("search");
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");
		
	
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("COLNAME", colname);
		paraMap.put("SEARCH", search);
		
		
		int totalCount = 0;			// 총게시물 갯수
		int sizePerPage = 10;		// 한 페이지당 보여줄 게시물 갯수
		int currentShowPageNo = 0;	// 현재 보여주는 페이지번호
		int totalPage = 0; 			// 총페이지수 (웹브라우저상에 보여줄 총 페이지 갯수)
		
		int startRno = 0; 			// 시작행번호
		int endRno = 0; 			// 끝행번호
		
		int blockSize = 10;// '페이지바'에 보여줄 페이지의 갯수 
		
		// - [페이징처리 O, 검색조건 O] 전체글 갯수 totalCount
		if(search!=null && !search.trim().equals("") && !search.trim().equals("null")) {
			totalCount = service.selectAdminTotalCountWithSearch(paraMap);
		}
	 	// - [페이징처리 O, 검색조건 X] 전체글 갯수 totalCount
		else {
			totalCount = service.selectAdminTotalCountNoSearch();
		}
		
		totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		
		
		// 게시판 목록보기 첫화면 (현재페이지번호가 없을경우)
		if(str_currentShowPageNo==null) {
			currentShowPageNo = 1;
		}
		// 게시판 목록보기 특정페이지번호를 보고자 하는 경우
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo<1 || currentShowPageNo>totalPage) { // 페이지가없는 번호를 칠경우
					currentShowPageNo = 1;
				}
			}
			catch (NumberFormatException e) { // 문자칠경우
				currentShowPageNo = 1;
			}
		}
		
		startRno = ((currentShowPageNo-1)*sizePerPage) + 1;
		endRno = startRno + sizePerPage - 1;
		
		paraMap.put("STARTRNO", String.valueOf(startRno));
		paraMap.put("ENDRNO", String.valueOf(endRno));
		
		// - [페이징처리 O, 검색조건 O] 한 페이지 범위마다 보여지는 글목록 // consult:select
		AdminConsultList = service.selectAdminConsultListPaging(paraMap);
		
		String pagebar = "<ul>";	
		pagebar += MyUtil.getPageBarWithSearch(sizePerPage, blockSize, totalPage, currentShowPageNo, colname, search, null, "adminConsultList.pet");
		pagebar += "</ul>";
		
		HttpSession session = req.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		req.setAttribute("AdminConsultList", AdminConsultList);
		
		req.setAttribute("colname", colname);
		req.setAttribute("search", search);
		req.setAttribute("pagebar", pagebar);
		
		String goBackURL = MyUtil.getCurrentURL(req);
		//System.out.println("goBackURL : "+goBackURL);
		
		req.setAttribute("goBackURL", goBackURL);
		
		return "admin/consult/adminConsultList.tiles2";
		
	}
	
	// 1:1상담 상세보기 -----------------------------------------------------------------------------------------------------
	@RequestMapping(value="/adminConsultDetail.pet", method= {RequestMethod.GET})
	public String requireLoginAdmin_adminConsultDetail(HttpServletRequest req, HttpServletResponse res) {
		
		ConsultVO consultvo = null;

		String consult_UID = req.getParameter("consult_UID");
		String gobackURL = req.getParameter("gobackURL");
		
		// - [조회수 증가 X] 글 상세보기
		consultvo = service.selectConsultDetailNoCount(consult_UID);
	
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("CONSULT_UID", consult_UID);
		int totalCount = service.selectCommentTotalCount(paraMap);
	
		int sizePerPage = 10;
		
		int totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		
		req.setAttribute("totalPage", totalPage);
		req.setAttribute("consultvo", consultvo);
		req.setAttribute("gobackURL", gobackURL);
		
		return "admin/consult/adminConsultDetail.tiles2";
	}
	
	// 1:1상담 알림 메세지 보내기 -------------------------------------------------------------------------------------------
	// 기업회원 idx를 List<String> select 해와서
	// notification 테이블에 insert를 for문으로
	@RequestMapping(value="/consultNotification.pet", method= {RequestMethod.GET})
	public String consultNotification(HttpServletRequest req) {
		
		List<String> bizMemberList = new ArrayList<String>();
		
		String str_selected = req.getParameter("selected");
		int selected = Integer.parseInt(str_selected);
		
		String msg = "";
		String loc = "";
		
		if(selected==0) {
			msg = "답변요청을 보내기 위한 상담글을 1개이상 선택하셔야합니다.";
			loc = req.getContextPath()+"/adminConsultList.pet";
		}
		else {
			// - 기업회원 idx 목록 member:select
			//List<String> bizMemberList = service.selectBizMemberList();
			bizMemberList = service.selectBizMemberList();
			//System.out.println(bizMemberList);			// [8, 10]
			//System.out.println(bizMemberList.size());	// 2

			/*
			for(int i=0; i<bizMemberList.size(); i++) { 
				System.out.println("bizMemberList["+i+"] => "+bizMemberList.get(i));
			}
			// bizMemberList[0] => 8
			// bizMemberList[1] => 10
			*/
			
			int n = 0;
			// 기업회원이 있는 경우
			if(bizMemberList.size()>0) {
			
				// - 알림 테이블에 board로 notification:insert
				for(int i=0; i<bizMemberList.size(); i++) { 
					n += service.insertConsultNotification(bizMemberList.get(i));
				}
				System.out.println(n);
				if(bizMemberList.size()==n) {
					// 알림 성공시
					msg = n+"명의 수의사님들께 요청이 완료되었습니다.";
					loc = req.getContextPath()+"/adminConsultList.pet";
				}
				else {
					// 알림 실패시
					msg = "요청 실패!";
					loc = req.getContextPath()+"/adminConsultList.pet";
				}
			}
		}
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	}
	
		
	
	
	
		
}
