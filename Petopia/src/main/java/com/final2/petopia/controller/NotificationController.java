 package com.final2.petopia.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.final2.petopia.common.MyUtil;
import com.final2.petopia.model.DepositVO;
import com.final2.petopia.model.MemberVO;
import com.final2.petopia.model.NotificationVO;
import com.final2.petopia.service.InterNotificationService;

@Controller
public class NotificationController {

	//===== 의존객체 주입(DI:Dependency Injection)  =====
	@Autowired
	private InterNotificationService service;
	
	// ----------------------------------------------------------------------------------------------------------
	
	// 안읽은 알림 배지 생성(AJAX) ------------------------------------------------------------------------------------
	@RequestMapping(value="/unreadNotificationCount.pet", method= {RequestMethod.GET})
	@ResponseBody
	public HashMap<String, Integer> unreadNotificationCount(HttpServletRequest req, HttpServletResponse res) throws Throwable {
		HashMap<String, Integer> returnMap = new HashMap<String, Integer>();
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");		
		int idx = loginuser.getIdx();
		
		// 회원의 고유번호를 이용한 안읽은 알림 갯수 나타내기
		int unreadNotificationCount = service.selectUnreadNotificationCount(idx);
		
		returnMap.put("UNREADNOTIFICATIONCOUNT", unreadNotificationCount);
		
		// 접속한 페이지주소가 notificationList.pet 라면 카운트를 비교해서 알림리스트를 가져오는 ajax를 실행
		
		return returnMap;
	}
	
	// 알림 아이콘 클릭 시 심플알림창 생성(AJAX) -------------------------------------------------------------------------
	// (안읽은 알림만 생성)
	@RequestMapping(value="/notificationSimpleList.pet", method= {RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, String>> requireLogin_notificationSimpleList(HttpServletRequest req, HttpServletResponse res) throws Throwable {
		
		List<HashMap<String, String>> notificationSimpleList = new ArrayList<HashMap<String, String>>();
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		// 회원의 고유번호를 이용한 심플 알림정보 가져오기(알림타입과 그 갯수)
		List<HashMap<String, String>> n_List = service.selectNotificatioSimplenList(idx);
		
		// HashMap에 nvoList안의 nvo.not_type에 따라 문구 넣기
		for(int i=0; i<n_List.size(); i++) {
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			String simpleMsg = "";
			 
			switch (n_List.get(i).get("NOT_TYPE")) {
			case "0":
				simpleMsg = "댓글이 없는 상담글이 있습니다.";
				break;
			case "1":
				simpleMsg = "케어 알림이 도착했습니다.";
				break;
			case "2":
				simpleMsg = "예약 알림이 있습니다.";
				break;
			case "3":
				simpleMsg = "결제대기 중인 예약이 있습니다.";
				break;
			case "4":
				simpleMsg = "게시글에 새 댓글이 있습니다.";
				break;
			case "5":
				simpleMsg = "화상상담 코드가 도착했습니다.";
				break;
			} // end of switch
			
			map.put("SIMPLEMSG", simpleMsg);
			map.put("COUNT", n_List.get(i).get("COUNT"));
			
			
			notificationSimpleList.add(map);
		} // end of for
		
		return notificationSimpleList;
	}
	
	// 알림 페이지 요청 -----------------------------------------------------------------------------------------------
	@RequestMapping(value="/notificationList.pet", method= {RequestMethod.GET})
	public String requireLogin_notificationList(HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		// 전체 알림 수 가져오기
		int totalNotCount = service.selectTotalNotCount(idx);
		
		req.setAttribute("totalNotCount", totalNotCount);
		
		return "notification/notificationList.tiles2";
	}
	
	// 알림 페이지 내용 생성(AJAX) -------------------------------------------------------------------------------------
	@RequestMapping(value="/notificationListAJAX.pet", method= {RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, String>> requireLogin_notificationListAJAX(HttpServletRequest req, HttpServletResponse res) throws Throwable {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		String start = req.getParameter("start");
		String length = req.getParameter("length");
		
		int startRno = Integer.parseInt(start);
		int endRno = startRno + Integer.parseInt(length) - 1;
		
		HashMap<String, Integer> paraMap = new HashMap<String, Integer>();
		
		paraMap.put("IDX", idx);
		paraMap.put("STARTRNO", startRno);
		paraMap.put("ENDRNO", endRno);
		
		// 알림 리스트 가져오기
		List<NotificationVO> notificationList = service.selectNotificationList(paraMap);
		
		List<HashMap<String, String>> returnMapList = new ArrayList<HashMap<String, String>>();
		
		if(notificationList.size() > 0) {
			for(NotificationVO nvo : notificationList) {
				HashMap<String, String> returnMap = new HashMap<String, String>();
				
				returnMap.put("NOT_UID", nvo.getNot_UID());
				returnMap.put("NOT_TYPE", nvo.getShowNot_type());
				returnMap.put("NOT_MESSAGE", nvo.getNot_message());
				returnMap.put("NOT_MESSAGE_COMMENT", nvo.getShowNot_message());
				returnMap.put("NOT_DATE", nvo.getNot_date());
				returnMap.put("NOT_READCHECK", nvo.getNot_readcheck());
				returnMap.put("NOT_REMINDSTATUS", nvo.getNot_remindstatus());
				returnMap.put("NOT_TIME", nvo.getNot_time());
				returnMap.put("NOT_URL", nvo.getNot_URL());
				
				returnMapList.add(returnMap);
			}
		}
		
		return returnMapList;
	}
	
	// 알림 내용 클릭 시 not_readcheck 컬럼 1로 변경 -------------------------------------------------------------------------
	@RequestMapping(value="/updateReadcheck.pet", method= {RequestMethod.POST})
	public String requireLogin_updateReadcheck(HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		int not_uid = Integer.parseInt(req.getParameter("not_uid"));
		String not_URL = req.getParameter("not_URL");
		
		HashMap<String, Integer> paraMap = new HashMap<String, Integer>();
		
		paraMap.put("IDX", idx);
		paraMap.put("NOT_UID", not_uid);
		
		// 가져온 알림번호를 통해 readcheck를 읽음상태로 업데이트
		int n = service.updateReadcheck(paraMap);
		
		if(n == 1) {
		
			String msg = "해당 게시글로 이동합니다.";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", not_URL);
			
			
		}
		else {
			
			String msg = "다시 시도해주세요!";
			
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
		}
		
		return "msg";
	}

	// 재알림 클릭 시 5분 뒤 시간으로 알림 insert -------------------------------------------------------------------------
	@RequestMapping(value="/insertRemindNot.pet", method= {RequestMethod.POST})
	public String requireLogin_insertRemindNot(HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		int not_uid = Integer.parseInt(req.getParameter("not_uid"));
		
		HashMap<String, Integer> paraMap = new HashMap<String, Integer>();
		
		paraMap.put("IDX", idx);
		paraMap.put("NOT_UID", not_uid);
		
		// 회원고유번호와 알림고유번호를 통해 알림정보 가져오기
		NotificationVO nvo = service.selectNotification(paraMap);
		
		// 재알림 INSERT
		int n = service.insertRemindNot(nvo);
		
		if(n == 1) {
			
			String msg = "재알람 설정이 완료되었습니다.";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", req.getContextPath()+"/notificationList.pet");
			
		}
		else {
			
			String msg = "다시 시도해주세요!";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
		}
		
		return "msg";
	}
	
	// 알림삭제 -------------------------------------------------------------------------
	@RequestMapping(value="/deleteNot.pet", method= {RequestMethod.POST})
	public String requireLogin_deleteNot(HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		int idx = loginuser.getIdx();
		
		int not_uid = Integer.parseInt(req.getParameter("not_uid"));
		
		HashMap<String, Integer> paraMap = new HashMap<String, Integer>();
		
		paraMap.put("IDX", idx);
		paraMap.put("NOT_UID", not_uid);
		
		// 알림 삭제
		int n = service.deleteNot(paraMap);
		
		if(n == 1) {
			
			String msg = "알림이 삭제되었습니다.";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", req.getContextPath()+"/notificationList.pet");
			
			
		}
		else {
			
			String msg = "다시 시도해주세요!";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
		}
		
		return "msg";
		
	}

}
