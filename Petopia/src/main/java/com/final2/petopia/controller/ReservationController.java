package com.final2.petopia.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.final2.petopia.common.MyUtil;
import com.final2.petopia.coolsms.Coolsms;
import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.model.DepositVO;
import com.final2.petopia.model.MemberVO;
import com.final2.petopia.model.PaymentVO;
import com.final2.petopia.model.PetVO;
import com.final2.petopia.model.ReservationVO;
import com.final2.petopia.model.ScheduleVO;
import com.final2.petopia.service.InterReservationService;

@Controller
public class ReservationController {
	
	@Autowired
	private InterReservationService service;
	
	public String chageDateFormat(String date) {
//		"Tue  Jan  22   2019       09:    00:    00 GMT+0000" -> "yyyy-mm-dd hh24:mi"
//		 0123 4567 8910 1112131415 161718 192021
//		String[] weekend = {"Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"};
		String[] Months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
		String result = "";
		result += date.substring(11, 15);
		for(int i=0; i<Months.length; i++) {
			if(date.substring(4,7).equals(Months[i])) {
				if(i+1<10) {
					result += "-0"+(i+1);
				}
				else {
					result += "-"+(i+1);
				}
			}
		}
		result += "-"+date.substring(8, 10) + " "+date.substring(16, 21);
		
//		System.out.println("날짜 포맷 변환 결과: "+result);
		return result;
	}
	public List<HashMap<String, String>> makeHalfTime() {
		List<HashMap<String, String>> halfTime = new ArrayList<HashMap<String, String>>();
		
		String hour = "";
		String time1 = "";
		String time2 = "";
		
		for(int i=0; i<24; i++) {
			if(i<10) {
				hour="0"+i;
			}
			else {
				hour = String.valueOf(i);
			}
			time1 = hour+":00";
			
			time2 = hour+":30";
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("time1", time1);
			map.put("time2", time2);
			halfTime.add(map);
			
		}
		
		return halfTime;
	}
//	[190211] 랜덤 무통장입금 계좌 만들기
	public String makeAccountNumber() {
		int certNumLength = 12;

        Random random = new Random(System.currentTimeMillis());
        
        int range = (int)Math.pow(12,certNumLength);
        int trim = (int)Math.pow(12, certNumLength-1);
        int result = random.nextInt(range)+trim;
         
        if(result>range){
            result = result - trim;
        }
        if(result<0) {
        	result = result*-1;
        }
        String str_result = String.valueOf(result).substring(0, 3)+"-"+String.valueOf(result).substring(3, 6)+"-"+String.valueOf(result).substring(6);
        return str_result;
	}
	
	@RequestMapping(value="/reservation.pet", method= {RequestMethod.GET})
	public String requireLogin_goReservationPage(HttpServletRequest req, HttpServletResponse res) {
		// [190129] idx_biz getParameter 주석 해제
		String idx_biz = req.getParameter("idx_biz");
//		String idx_biz="5";
//		[190119]---------------------------------------------------------
//		#로그인한 유저 정보로 펫 정보 가져오기
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		int idx = loginuser.getIdx();
		
		List<PetVO> petList = service.selectPetListByIdx(idx);
//		-----------------------------------------------------------------
		
		Biz_MemberVO bizmvo = service.selectBizMemberVOByIdx_biz(idx_biz);
		
		req.setAttribute("bizmvo", bizmvo);
		req.setAttribute("petList", petList);
		return "reservation/reservation.tiles2";
	}
	
	@RequestMapping(value="/selectScheduleList.pet", method= {RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, String>> selectScheduleList(HttpServletRequest req) {
		List<HashMap<String, String>> returnMapList = new ArrayList<HashMap<String, String>>();
		
		String idx_biz = req.getParameter("idx_biz");
		
		List<ScheduleVO> scheduleList = service.selectScheduleListByIdx_biz(idx_biz);
		
		for(ScheduleVO svo : scheduleList) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			
//			returnMap.put("title", svo.getSchedule_DATE().substring(svo.getSchedule_DATE().indexOf(" "))+"("+svo.getShowSchedule_status()+")");
			returnMap.put("title", svo.getShowSchedule_status());
			returnMap.put("start", svo.getSchedule_DATE());
			returnMap.put("end", svo.getEndtime());
			returnMap.put("schedule_status", Integer.toString(svo.getSchedule_status()));
			returnMap.put("schedule_UID", Integer.toString(svo.getSchedule_UID()));
			returnMapList.add(returnMap);
		}
		
		return returnMapList;
	}
	
	@RequestMapping(value="/selectPetOne.pet", method= {RequestMethod.GET})
	@ResponseBody
	public HashMap<String, String> selectPetOne(HttpServletRequest req){
		HashMap<String, String> returnMap = new HashMap<String, String>();
		
		String pet_UID = req.getParameter("pet_UID");
		PetVO petvo = service.selectPetOneByPet_UID(pet_UID);
		
		returnMap.put("pet_UID", String.valueOf(petvo.getPet_UID()));
		returnMap.put("pet_name", petvo.getPet_name());
		
		String pet_type=petvo.getPet_type();
		if(pet_type.equals("cat")) {
			pet_type="고양이";
		}
		else if(pet_type.equals("dog")) {
			pet_type="강아지";
		}
		else if(pet_type.equals("smallani")) {
			pet_type="소동물";
		}
		else if(pet_type.equals("etc")) {
			pet_type="기타분류";
		}
		returnMap.put("pet_type",pet_type);
		returnMap.put("pet_gender", petvo.getPet_gender());
		returnMap.put("pet_size", petvo.getPet_size());
		returnMap.put("pet_weight", String.valueOf(petvo.getPet_weight()));
		return returnMap;
	}
	
//	[190120] 예약하기 메소드
	@RequestMapping(value="/goReservation.pet", method= {RequestMethod.POST})
	public String goReservation(ReservationVO rvo, HttpServletRequest req) throws Throwable {
		String str_date = rvo.getReservation_DATE();
		String reservation_DATE = chageDateFormat(str_date);
		
		rvo.setReservation_DATE(reservation_DATE);
		
		if(rvo.getReservation_status() == null || rvo.getReservation_status() == "") {
			rvo.setReservation_status("1");
		}
		int result = service.insertReservationByRvo(rvo);
		
		String loc="";
		String msg = "";
		
		if(result ==1) {
			msg = "예약 성공";
			loc = req.getContextPath()+"/reservationList.pet";
		}
		else {
			msg = "예약 실패";
			loc="javascript:history.back();";
		}
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	}
	
//	[190120] 예약하기 메소드; 수술 예약시
	@RequestMapping(value="/goReservationSurgery.pet", method= {RequestMethod.POST})
	public String goReservationSurgery(ReservationVO rvo, HttpServletRequest req) throws Throwable {
		
		String str_date = rvo.getReservation_DATE();
		String reservation_DATE = chageDateFormat(str_date);
		
		rvo.setReservation_DATE(reservation_DATE);
		HashMap<String, String> resultMap = service.insertReservationSurgeryByRvo(rvo);
		
		String loc="";
		String msg = "";
		String result = resultMap.get("result");
		
		if(result.equals("1")) {
			msg = "선예약 성공! 예치금 결제 페이지로 이동합니다.";
			loc = req.getContextPath()+"/goPayDeposit.pet?fk_reservation_UID="+resultMap.get("seq")+"&fk_idx="+rvo.getFk_idx();
		}
		else {
			msg = "예약 실패";
			loc="javascript:history.back();";
		}
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	}

//	#수술 예약하기; 예치금 결제페이지로 이동
	@RequestMapping(value="/goPayDeposit.pet", method= {RequestMethod.GET})
	public String goPayDeposit(HttpServletRequest req, HttpServletResponse res) throws Throwable {
		String fk_reservation_UID = req.getParameter("fk_reservation_UID");
		String idx = req.getParameter("fk_idx");

		int depositAmount = service.selectSumDepositByIdx(idx);

		int point = service.selectPointByIdx(idx);
		HashMap<String, String> returnMap = service.selectUserReservationOneByFkRUID(fk_reservation_UID);

		if(depositAmount<100000) {
			req.setAttribute("msg", "예치금 잔액이 부족합니다. 예치금 충전 후 예약목록에서 예치금 결제를 진행하세요.");
			req.setAttribute("loc", req.getContextPath()+"/chargeDepositPage.pet?idx="+idx);	// 190207 depositcoin 삭제, Coin 삭제
			return "msg";
		}
		else {
			req.setAttribute("idx", idx);
			req.setAttribute("depositAmount", depositAmount);
			req.setAttribute("point", point);
			req.setAttribute("fk_reservation_UID", fk_reservation_UID);
			req.setAttribute("returnMap", returnMap);
			return "reservation/payDeposit.tiles2";
		}
	}
	
//	#예치금 코인 결제 완료페이지; 트랜잭션 처리
	@RequestMapping(value="/goPayDepositEnd.pet", method= {RequestMethod.POST})
	public String goPayDepositEnd(PaymentVO pvo, HttpServletRequest req) throws Throwable {
		
		int result = service.goPayReservationDeposit(pvo);
		String loc="";
		String msg = "";
		
		if(result ==1) {
			msg = "결제 성공";
			loc = req.getContextPath()+"/reservationList.pet";
		}
		else {
			msg = "결제 실패";
			loc="javascript:history.back();";
		}
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		return "msg";
	}
	
	
//	#예약목록
	@RequestMapping(value="/reservationList.pet", method={RequestMethod.GET})
	public String requireLogin_reservationList(HttpServletRequest req, HttpServletResponse res) {
		List<HashMap<String, String>> reservationList = null;
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		HashMap<String, String> paraMap = new HashMap<String ,String>();
		paraMap.put("idx", String.valueOf(idx));
		
//		2) 페이지 구분을 위한 변수 선언하기
		int totalCount = 0;			// 조건에 맞는 총게시물의 개수
		int sizePerPage = 10;		// 한 페이지당 보여줄 게시물 개수
		int currentShowPageNo = 0;	// 현재 보여줄 페이지번호(초기치 1)
		int totalPage = 0;			// 총 페이지 수(웹브라우저 상에서 보여줄 총 페이지의 개수)
		
		int startRno = 0;			// 시작행 번호
		int endRno = 0;				// 마지막행 번호
		
		int blockSize = 3;			// 페이지바의 블럭(토막) 개수
		
		totalCount = service.getTotalCountNoSearch(idx);

		totalPage=(int)Math.ceil((double)totalCount/sizePerPage);
		
//		4) 현재 페이지 번호 셋팅하기
		if(str_currentShowPageNo == null) {
//			게시판 초기 화면의 경우
			currentShowPageNo=1;
		}
		else {
//			특정 페이지를 조회한 경우
			try {
			currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
			if(currentShowPageNo<1 || currentShowPageNo>totalPage) {
				currentShowPageNo = 1;
			}
			} catch(NumberFormatException e) {
				currentShowPageNo = 1;
			}
		}
		
//		5) 가져올 게시글의 범위 구하기(기존 공식과 다른 버전)
		startRno = ((currentShowPageNo-1) * sizePerPage)+1;
		endRno = startRno+sizePerPage -1; 
		
//		6) DB에서 조회할 조건들을 paraMap에 넣기
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
//		7) 게시글 목록 가져오기
		reservationList = service.selectUserReservationList(paraMap);

//		#120. 페이지바 만들기(MyUtil에 있는 static메소드 사용)
		String pageBar = "<ul class='pagination'>";	// 페이지바 클래스 부여
		pageBar += MyUtil.getPageBar(sizePerPage, blockSize, totalPage, currentShowPageNo, "reservationList.pet");
		pageBar += "</ul>";
		
		session.setAttribute("readCountPermission", "yes");

		req.setAttribute("reservationList", reservationList);
		
//		#페이지바 넘겨주기
		req.setAttribute("pageBar", pageBar);
		
//		#currentURL 뷰로 보내기
		String currentURL = MyUtil.getCurrentURL(req);
		
		if(currentURL.substring(currentURL.length()-5).equals("?null")) {
			currentURL = currentURL.substring(0 , currentURL.length()-5);
		}
		req.setAttribute("currentURL", currentURL);
		return "reservation/reservationList.tiles2";
	}

	
	@RequestMapping(value="/deposit.pet", method={RequestMethod.GET})
	public String requireLogin_depositList(HttpServletRequest req, HttpServletResponse res) {
		// [190206] 예치금합계 추가하기
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String idx = String.valueOf(loginuser.getIdx());
		int sumDeposit = service.selectSumDepositByIdx(idx);
		int sumPoint = service.selectPointByIdx(idx);
		req.setAttribute("sumDeposit", sumDeposit);
		req.setAttribute("sumPoint", sumPoint);
		// 190206 끝
		return "reservation/depositList.tiles2";
	}
	
//	[190126] 예치금 히스토리 목록
	@RequestMapping(value="/depositHistory.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> requireLogin_depositHistory(HttpServletRequest req, HttpServletResponse res) {
		List<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		String currentShowPageNo = req.getParameter("currentShowPageNo");
		if(currentShowPageNo == null || "".equals(currentShowPageNo)) {
			currentShowPageNo = "1";
		}
		String type = req.getParameter("type");
		if(type == null || "".equals(type)) {
			type = "-10";
		}
		
		String [] typeArr = type.split(",");
		
		int sizePerPage = 10;	// 한 페이지 당 보여줄 댓글의 갯수
		int rno1 = Integer.parseInt(currentShowPageNo) * sizePerPage - (sizePerPage-1);
		int rno2 = Integer.parseInt(currentShowPageNo) * sizePerPage;
		
		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("idx", String.valueOf(idx));
		paraMap.put("rno1", String.valueOf(rno1));
		paraMap.put("rno2", String.valueOf(rno2));
		paraMap.put("typeArr", typeArr);
		// [190211] 관리자 경우 추가
		List<DepositVO> depositList = new ArrayList<DepositVO>();
		
		if(loginuser.getMembertype().equals("3")) {
			depositList = service.selectDepositListByIdxForAdmin(paraMap);
		}
		else {
			depositList = service.selectDepositListByIdx(paraMap);
		}
		
		for(DepositVO dvo : depositList) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("deposit_UID", dvo.getDeposit_UID());
			map.put("depositcoin", dvo.getDepositcoin());
			map.put("deposit_date", dvo.getDeposit_date());
			map.put("showDepositStatus", dvo.getShowDepositStatus());
			map.put("deposit_status", dvo.getDeposit_status());
			map.put("fk_payment_UID", dvo.getFk_payment_UID()); // [190130] fk_payment_UID 추가
			map.put("deposit_type", dvo.getDeposit_type());	// [190213] deposit_type 추가
			map.put("fk_idx", dvo.getFk_idx());
			map.put("membertype", dvo.getMembertype());
			mapList.add(map);
		}
		
		return mapList;
	}
	
	@RequestMapping(value="/depositHistoryPageBar.pet", method={RequestMethod.GET})
	@ResponseBody
	public HashMap<String, Integer> requireLogin_depositHistoryPageBar(HttpServletRequest req, HttpServletResponse res) {
		HashMap<String, Integer> returnMap = new HashMap<String, Integer>();
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser"); 
		String idx = String.valueOf(loginuser.getIdx());
		String sizePerPage = req.getParameter("sizePerPage");
		String type = req.getParameter("type");
		
		if(type == null || "".equals(type)) {
			type = "-10";
		}
		if(sizePerPage == null || "".equals(sizePerPage)) {
			sizePerPage = "10"; // [190130] 페이지바 수정
		}
		
		String[] typeArr = type.split(",");
		
		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("idx", idx);
		paraMap.put("typeArr", typeArr);
		paraMap.put("sizePerPage", sizePerPage);
		
		// [190211] 관리자 추가
		int totalCount = 0;
		if(loginuser.getMembertype().equals("3")) {
			totalCount = service.selectDepositListTotalCountForAdmin(paraMap);
		}
		else {
			totalCount = service.selectDepositListTotalCount(paraMap);
		}
//		총 페이지 수 구하기
//		ex) 57.0(행 개수)/10(sizePerPage) => 5.7 => 6.0 => 6
//		ex2) 57.0(행 개수)/5(sizePerPage) => 11.4 => 12.0 => 12
		int totalPage = (int)Math.ceil((double)totalCount/Integer.parseInt(sizePerPage));

		returnMap.put("totalPage", totalPage);
		returnMap.put("type", Integer.parseInt(typeArr[0]));
		return returnMap;

	}
	@RequestMapping(value="/SelectChartSearch.pet", method={RequestMethod.GET})
	public String requireLogin_selectChartSearch(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String membertype = loginuser.getMembertype();
		String idx_biz = String.valueOf(loginuser.getIdx());
		if(!"2".equals(membertype)) {
			session.invalidate(); // 강제 로그아웃(세션에서 지움)
			
			String msg = "접근이 불가합니다.";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
			return "msg";

		}
		else {
			int scheduleCount = service.selectScheduleCountByIdx_biz(idx_biz);
			req.setAttribute("idx_biz", idx_biz);
			req.setAttribute("scheduleCount", scheduleCount);
			// [190129] 시간 드롭박스 생성
			List<HashMap<String, String>> timeList = makeHalfTime();
			req.setAttribute("timeList", timeList);
			return "reservation/biz_rvCalendar.tiles2";
		}
	}
	
	@RequestMapping(value="/insertScheduleFirst.pet", method= {RequestMethod.GET})
	public String insertScheduleFirst(HttpServletRequest req) {
		String idx_biz = req.getParameter("idx_biz");

		String msg = "";
		String loc = "";
		
		try {
			service.insertScheduleFirst(idx_biz);
			msg = "스케줄 생성 성공!";
			loc = "javascript:location.href='"+req.getContextPath()+"/SelectChartSearch.pet'"; // [190128] 오타 수정
		} catch (Exception e) {
			msg = "스케줄 생성 실패";
			loc="javascript:history.back();";
		}
	
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		return "msg";
	}
//	------------- 190126 끝

//	[190128]
//	#캘린더에서 이벤트 클릭 시 예약 정보 가져오기
	@RequestMapping(value="selectScheduleOneByScheduleUID.pet", method= {RequestMethod.GET})
	@ResponseBody
	public HashMap<String, String> selectScheduleOneByScheduleUID(HttpServletRequest req){
		HashMap<String, String> returnMap = new HashMap<String, String>();
		
		String schedule_UID = req.getParameter("schedule_UID");
		
		returnMap = service.selectScheduleOneByScheduleUID(schedule_UID);
		
		return returnMap;
	}
//	#기업회원 예약 일정 수정하기
	@RequestMapping(value="rvScheduleEdit.pet", method= {RequestMethod.POST})
	public String updateReservationSchedule(HttpServletRequest req) {
		String rvdate1 = req.getParameter("edit_rvDATE_YMD");
		String rvdate2 = req.getParameter("edit_rvDATE_HM");
		String reservation_DATE = rvdate1 + " " + rvdate2;
		
		String reservation_UID = req.getParameter("edit_rvUID");
		String fk_schedule_UID = req.getParameter("edit_scUID");
		String fk_idx_biz = req.getParameter("edit_fk_idx_biz");
		String reservation_type = req.getParameter("edit_reservation_type");
		String reservation_status = req.getParameter("edit_reservation_status");
		String schedule_status = req.getParameter("edit_schedule_status");
		String fk_idx = req.getParameter("edit_fk_idx");
		String fk_pet_UID = req.getParameter("edit_fk_pet_UID");
		
		ReservationVO rvo = new ReservationVO();
		rvo.setFk_idx(fk_idx);
		rvo.setFk_idx_biz(fk_idx_biz);
		rvo.setFk_pet_UID(fk_pet_UID);
		rvo.setReservation_type(reservation_type);
		rvo.setReservation_status(reservation_status);
		rvo.setReservation_DATE(reservation_DATE);	// [190129] 예약시간 추가
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("reservation_DATE", reservation_DATE);
		paraMap.put("reservation_UID", reservation_UID);
		paraMap.put("fk_schedule_UID", fk_schedule_UID);
		paraMap.put("schedule_status", schedule_status);
		paraMap.put("fk_idx_biz", fk_idx_biz);
		
		int result = service.updateReservationSchedule(paraMap, rvo);
		
		String msg = "";
		String loc = "";
		if(result==1) {
			msg="일정 수정 완료";
			loc="javascript:location.href='"+req.getContextPath()+"/SelectChartSearch.pet'";
		}
		else if(result==2) {
			msg="입력하신 스케줄에 기예약건이 있습니다.";
			loc="javascript:history.back();";
		}
		else {
			msg="일정 수정 실패";
			loc="javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		return "msg";
	}
	
//	[190129]
//	#기업회원 예약 취소
	@RequestMapping(value="rvScheduleCancle.pet", method= {RequestMethod.POST})
	public String rvScheduleCancle(HttpServletRequest req) {
		HashMap<String, String> paraMap = new HashMap<String, String>();
		String rvdate1 = req.getParameter("edit_rvDATE_YMD");
		String rvdate2 = req.getParameter("edit_rvDATE_HM");
		String reservation_DATE = rvdate1 + " " + rvdate2;
		
		String reservation_UID = req.getParameter("edit_rvUID");
		String fk_schedule_UID = req.getParameter("edit_scUID");
		String fk_idx_biz = req.getParameter("edit_fk_idx_biz");
		String fk_idx = req.getParameter("edit_fk_idx");
		String reservation_type = req.getParameter("edit_reservation_type");
		String reservation_status = req.getParameter("edit_reservation_status");
		
		paraMap.put("reservation_UID", reservation_UID);
		paraMap.put("fk_schedule_UID", fk_schedule_UID);
		paraMap.put("fk_idx_biz", fk_idx_biz);
		paraMap.put("fk_idx", fk_idx);
		paraMap.put("reservation_type", reservation_type);
		paraMap.put("reservation_status", reservation_status);
		paraMap.put("reservation_DATE", reservation_DATE);
		
		int result = 0;
		if(reservation_type.equals("3") && reservation_status.equals("2")) {
			result = service.updateRvAndScdStatusCancleForSurgery(paraMap);
		}
		else {
			result = service.updateRvAndScdStatusCancle(paraMap);
		}
		
		String msg = "";
		String loc = "";
		if(result==1) {
			msg="일정 취소 완료";
			loc="javascript:location.href='"+req.getContextPath()+"/SelectChartSearch.pet'";
		}
		else {
			msg="일정 취소 실패";
			loc="javascript:history.back();";
		}
			
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	}
	
	
//	[190130]
//	#일반회원 예약리스트에서 예약 취소하기
	@RequestMapping(value="goCancleReservationMember.pet", method={RequestMethod.GET})
	public String requireLogin_goCancleReservationMember(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String fk_idx = String.valueOf(loginuser.getIdx());
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		String reservation_UID = req.getParameter("reservation_UID");
		String fk_schedule_UID = req.getParameter("fk_schedule_UID");
		String reservation_status = req.getParameter("reservation_status");
		String reservation_type = req.getParameter("reservation_type");
		String reservation_DATE = req.getParameter("reservation_DATE");
		paraMap.put("reservation_UID", reservation_UID);
		paraMap.put("fk_schedule_UID", fk_schedule_UID);
		paraMap.put("fk_idx", fk_idx);
		paraMap.put("reservation_status", reservation_status);
		paraMap.put("reservation_type", reservation_type);
		paraMap.put("reservation_DATE", reservation_DATE);
		int result = 0;
		if(reservation_status.equals("2") && reservation_type.equals("3")) {
			result = service.updateRvAndScdStatusCancleForSurgery(paraMap);
		}
		else {
			result = service.updateRvAndScdStatusCancle(paraMap);
		}
		
		String msg = "";
		String loc = "";
		if(result==1) {
			msg="일정 취소 완료";
			loc="javascript:location.href='"+req.getContextPath()+"/reservationList.pet'";
		}
		else {
			msg="일정 취소 실패";
			loc="javascript:history.back();";
		}
			
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	}

//	#예약 상세 보기
	@RequestMapping(value="reservationDetail.pet", method={RequestMethod.GET})
	@ResponseBody
	public HashMap<String, String> requireLogin_reservationDetail(HttpServletRequest req, HttpServletResponse res) {	
		String payment_UID = req.getParameter("payment_UID");
		
//		[190131] 세션에서 멤버타입 변수 가져오기
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String membertype = loginuser.getMembertype();
		String idx = String.valueOf(loginuser.getIdx()); // [190211] 
		HashMap<String, String> resultMap = service.selectRvDetailByPUID(payment_UID, membertype, idx); 
		
		return resultMap;
	}
	
	@RequestMapping(value="bizDepositAccount.pet", method= {RequestMethod.GET})
	public String requireLogin_biz_depositList(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String idx = String.valueOf(loginuser.getIdx());
		
		int sumDeposit = service.selectSumDepositByIdx(idx);
		req.setAttribute("sumDeposit", sumDeposit);
		return "reservation/biz_depositList.tiles2";
	}
	
//	[190203]
//	#관리자 예약/예치금목록 페이지
//	@RequestMapping(value="adminPaymentList.pet", method= {RequestMethod.GET})
	public String requireLogin_adminReservationList(HttpServletRequest req, HttpServletResponse res) {
		List<HashMap<String, String>> paymentRvList = null;
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");
		String colname = req.getParameter("colname");
		String search = req.getParameter("search");
		
		if(colname==null) {
			colname="name";
		}
		if(search==null) {
			search="";
		}
		HashMap<String, String> paraMap = new HashMap<String ,String>();
		paraMap.put("colname", colname);
		paraMap.put("search",search);

//		2) 페이지 구분을 위한 변수 선언하기
		int totalCount = 0;			// 조건에 맞는 총게시물의 개수
		int sizePerPage = 10;		// 한 페이지당 보여줄 게시물 개수
		int currentShowPageNo = 0;	// 현재 보여줄 페이지번호(초기치 1)
		int totalPage = 0;			// 총 페이지 수(웹브라우저 상에서 보여줄 총 페이지의 개수)
		
		int startRno = 0;			// 시작행 번호
		int endRno = 0;				// 마지막행 번호
		
		int blockSize = 3;			// 페이지바의 블럭(토막) 개수
		
//		3) 총 페이지수 구하기
		if(search != null && !search.trim().equals("") && !search.trim().equals("null")) {
//			a. 검색어가 있을 때(search!=null || search!="") 총 게시물 개수 구하기
			totalCount = service.selectPaymentTotalCountWithSearch(paraMap);
		}
		else {
//			b. 검색어가 없을 때(search==null || search=="") 총 게시물 개수 구하기
			totalCount = service.selectPaymentTotalCountNoSearch();
		}


		totalPage=(int)Math.ceil((double)totalCount/sizePerPage);
		
//		4) 현재 페이지 번호 셋팅하기
		if(str_currentShowPageNo == null) {
//			게시판 초기 화면의 경우
			currentShowPageNo=1;
		}
		else {
//			특정 페이지를 조회한 경우
			try {
			currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
			if(currentShowPageNo<1 || currentShowPageNo>totalPage) {
				currentShowPageNo = 1;
			}
			} catch(NumberFormatException e) {
				currentShowPageNo = 1;
			}
		}
		
//		5) 가져올 게시글의 범위 구하기(기존 공식과 다른 버전)
		startRno = ((currentShowPageNo-1) * sizePerPage)+1;
		endRno = startRno+sizePerPage -1; 
		
//		6) DB에서 조회할 조건들을 paraMap에 넣기
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
//		7) 목록 가져오기
		paymentRvList = service.selectPaymentRvListForAdmin(paraMap);

//		#120. 페이지바 만들기(MyUtil에 있는 static메소드 사용)
		String pageBar = "<ul>";
		pageBar += MyUtil.getPageBarWithSearch(sizePerPage, blockSize, totalPage, currentShowPageNo, colname, search, "", "adminPaymentList.pet");
		pageBar += "</ul>";
		
		HttpSession session = req.getSession();
		session.setAttribute("readCountPermission", "yes");

		req.setAttribute("paymentRvList", paymentRvList);
		
//		#페이지바 넘겨주기
		req.setAttribute("pageBar", pageBar);
		
//		#currentURL 뷰로 보내기
		String currentURL = MyUtil.getCurrentURL(req);
		if(currentURL.substring(currentURL.length()-5).equals("?null")) {
			currentURL = currentURL.substring(0 , currentURL.length()-5);
		}
		req.setAttribute("currentURL", currentURL);
		return "reservation/adminPaymentList.tiles2";
	}

//	[190204]
	@RequestMapping(value="adminPaymentList.pet", method= {RequestMethod.GET})
	public String requireLogin_adminPaymentRvListAll(HttpServletRequest req, HttpServletResponse res) {
		List<HashMap<String, String>> returnList = service.selectAdminPaymentRvListAll();
		req.setAttribute("paymentRvList", returnList);
		return "reservation/adminPaymentList.tiles2";
	}
	
// [190206] 수정; ResponseBody 형식 변경, 리턴값 변수명 변경
	@RequestMapping(value="adminPaymentRvList_InfiniteScrollDown.pet", method= {RequestMethod.POST})
	@ResponseBody 
	public List<HashMap<String, String>> adminPaymentRvList_InfiniteScrollDown(HttpServletRequest req) {
		List<HashMap<String, String>> paymentRvList = new ArrayList<HashMap<String, String>>();
		
		int rnoToStart = Integer.parseInt(req.getParameter("rno"));
		paymentRvList = service.selectInfiniteScrollDownPaymentRvList(rnoToStart);

		return paymentRvList;
	}
	@RequestMapping(value="adminPaymentRvList_InfiniteScrollUp.pet", method= {RequestMethod.POST})
	@ResponseBody 
	public List<HashMap<String, String>> adminPaymentRvList_InfiniteScrollUp(HttpServletRequest req) {
		
		int rnoToStart = Integer.parseInt(req.getParameter("rno"));
		List<HashMap<String, String>> paymentRvList = service.selectInfiniteScrollDownPaymentRvList(rnoToStart);
	
		return paymentRvList;
	}
// [190206] 끝
	
//	[190207]
//	#관리자 예약결제관리 목록에서 진료기록을 입력한 기업회원에게 예치금 정산하기 
	@RequestMapping(value="payForDepositToBiz.pet", method= {RequestMethod.GET})
	@ResponseBody 
	public HashMap<String, String> payForDepositToBiz(HttpServletRequest req) {
		String reservation_UID = req.getParameter("reservation_UID");
		String payment_UID = req.getParameter("payment_UID");
		String idx_biz = req.getParameter("idx_biz");
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("reservation_UID", reservation_UID);
		paraMap.put("payment_UID", payment_UID);
		paraMap.put("idx_biz", idx_biz);
		
		HashMap<String, String> returnMap = service.insertDepositToBiz(paraMap);
		
		return returnMap;
	}
	
	
//	[190208]
//	#예치금 충전하기 chargeDeposit  requireLogin 추가
	@RequestMapping(value="chargeDeposit.pet", method= {RequestMethod.GET})
	public String requireLogin_chargeDeposit(HttpServletRequest req, HttpServletResponse res) {
		
		String idx = req.getParameter("idx");
		int depositAmount = service.selectSumDepositByIdx(idx);
		
		req.setAttribute("idx", idx);
		req.setAttribute("depositAmount", depositAmount);
		
		return "tiles2/reservation/chargeDeposit";
	}
	
//	[190217]
//	#예치금 충전하기 페이지
	@RequestMapping(value="chargeDepositPage.pet", method= {RequestMethod.GET})
	public String requireLogin_chargeDepositPage(HttpServletRequest req, HttpServletResponse res) {
		
		String idx = req.getParameter("idx");
		int depositAmount = service.selectSumDepositByIdx(idx);
		
		req.setAttribute("idx", idx);
		req.setAttribute("depositAmount", depositAmount);
		
		return "reservation/chargeDeposit2.tiles2";
	}
	
//	#PG결제 연결하기
	@RequestMapping(value="chargeDepositEnd.pet", method= {RequestMethod.GET})
	public String requireLogin_chargeDepositEnd(HttpServletRequest req, HttpServletResponse res) {
		// [190209] name 추가
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String name = loginuser.getName();
		String idx = req.getParameter("idx");
		String deposit_type=req.getParameter("depositType");
		String depositCoin = req.getParameter("depositCoin");
		String coinmoney = "";
		
		if(depositCoin.equals("100000")) {
			coinmoney = "100";
		}
		else if(depositCoin.equals("200000")) {
			coinmoney = "200";
		}
		else if(depositCoin.equals("300000")) {
			coinmoney = "300";
		}
		else if(depositCoin.equals("400000")) {
			coinmoney = "400";
		}
		else if(depositCoin.equals("500000")) {
			coinmoney = "500";
		}
		
		if(deposit_type.equals("card")) {	// 카드결제 아임포트로 연결
			req.setAttribute("idx", idx);
			req.setAttribute("name", name);
			req.setAttribute("coinmoney", coinmoney);
			req.setAttribute("realDeposit", depositCoin);
			req.setAttribute("depositType", deposit_type);
			
			return "tiles2/reservation/paymentGateway";
		}
		else if(deposit_type.equals("direct")) { 	// 무통장입금
			HashMap<String, String> paraMap = new HashMap<String, String>();
			
			paraMap.put("fk_idx", idx);
			paraMap.put("depositcoin", depositCoin);
			paraMap.put("deposit_status", "-1");
			
			paraMap.put("payment_UID", "0");
			String accountNumber = makeAccountNumber();
			paraMap.put("deposit_type", accountNumber);
			int n = service.insertDeposit(paraMap);
			
			String msg = "";
			String loc = "";
			int m = 0;
			try {
				paraMap.put("text", "[PETOPIA] 무통장입금 신청 성공! 24시간 이내에 신한 "+accountNumber+"으로 "+depositCoin+"원을 입금해주세요.");
				paraMap.put("to", loginuser.getPhone());
			     // m = service.sendSms(paraMap);  // 본인이 COOL SMS 에 가입하시면 사용하시오.
			} catch (Exception e) {
				e.printStackTrace();
			}
			
	            // if(n*m==1) {  // 본인이 COOL SMS 에 가입하시면 사용하시오.
			if(n==1) {
				msg = "무통장입금 신청 성공! 24시간 이내에 신한 "+accountNumber+"으로 입금 바랍니다.";
				loc = "javascript:self.close(); opener.close(); opener.opener.location.href='"+req.getContextPath()+"/deposit.pet';";
			}
			else {
				msg = "충전 실패";
				loc = "javascript:history.back();";
			}
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
		}
		
		return "msg";

	}

//	#예치금 충전 후 결제정보 저장하기
//	[190209] POST방식으로 변경
	@RequestMapping(value="insertDeposit.pet", method= {RequestMethod.POST})
	public String insertDeposit(HttpServletRequest req, HttpServletResponse res) {
		
		String idx = req.getParameter("idx");
		String realDeposit = req.getParameter("realDeposit");
		String depositType = req.getParameter("depositType");
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		
		paraMap.put("fk_idx", idx);
		paraMap.put("depositcoin", realDeposit);
		paraMap.put("deposit_status", "1");
		paraMap.put("deposit_type", depositType);
		paraMap.put("payment_UID", "0");
		
		int n = service.insertDeposit(paraMap);
		
		String msg="";
		String loc="";
		if(n==1) {
			msg="충전완료"; // [190209] loc 경로 변경
			loc="javascript:self.close(); opener.location.href='"+req.getContextPath()+"/deposit.pet';";
		}
		else {
			msg="충전실패";
			loc="javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		return "msg";
	}
	
	@RequestMapping(value="selectDirectAccountView.pet", method= {RequestMethod.GET})
	@ResponseBody
	public HashMap<String, String> selectDirectAccountView(HttpServletRequest req, HttpServletResponse res) {
		HashMap<String, String> returnMap = new HashMap<String, String>();
		
		String deposit_UID = req.getParameter("deposit_UID");
		
		returnMap = service.selectDepositDirectAccount(deposit_UID);
		
		return returnMap;
	}
	
	@RequestMapping(value="admin_depositList.pet", method= {RequestMethod.GET})
	public String requireLogin_admin_depositList(HttpServletRequest req, HttpServletResponse res) {
		
		return "reservation/admin_depositList.tiles2";
	}
	
	@RequestMapping(value="goUpdateDepositStatus.pet", method= {RequestMethod.GET})
	public String goUpdateDepositStatus(HttpServletRequest req, HttpServletResponse res) {
		String deposit_UID = req.getParameter("deposit_UID");
		
		int result = service.updateDepositStatusByDUID(deposit_UID);
		
		String msg="";
		String loc="";
		
		if(result==1) {
			msg="입금확인 완료!";
			loc=req.getContextPath()+"/admin_depositList.pet";
		}
		else {
			msg="상태변경 실패";
			loc="javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		return "msg";
	}
	
	@RequestMapping(value="withdrawForBiz.pet", method= {RequestMethod.GET})
	public String requireLogin_withdrawForBiz(HttpServletRequest req, HttpServletResponse res) {
		String idx = req.getParameter("idx");
		int depositAmount = service.selectSumDepositByIdx(idx);
		req.setAttribute("idx", idx);
		req.setAttribute("depositAmount", depositAmount);
		return "tiles2/reservation/biz_withdraw";
	}
	
	@RequestMapping(value="withdrawForBizEnd.pet", method= {RequestMethod.POST})
	public String requireLogin_withdrawForBizEnd(HttpServletRequest req, HttpServletResponse res) {
		String idx_biz = req.getParameter("idx");
		String depositCoin = "-"+req.getParameter("depositCoin");
		String depositType = req.getParameter("depositType");
		String accountNumber = req.getParameter("accountNumber");
		
		HashMap<String, String> paraMap = new HashMap<String, String>();
		
		paraMap.put("fk_idx", idx_biz);
		paraMap.put("depositcoin", depositCoin);
		paraMap.put("depositType", depositType+" "+accountNumber);
		paraMap.put("deposit_status", "3");
		paraMap.put("deposit_type", depositType);
		paraMap.put("payment_UID", "0");
		
		String msg = "";
		String loc = "";
		
		int n = service.insertDeposit(paraMap);
		if(n==1) {
			msg="출금완료! 5분~3시간 이내 확인 바랍니다.";
			loc="javascript:self.close(); opener.location.reload();";
		}
		else {
			msg="출금실패";
			loc="javascript:history.back();";
		}
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		return "msg";
	}
	
	
}
