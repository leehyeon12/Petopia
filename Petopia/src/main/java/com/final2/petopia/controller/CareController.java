package com.final2.petopia.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import com.final2.petopia.model.CareVO;
import com.final2.petopia.model.MemberVO;
import com.final2.petopia.model.PetVO;
import com.final2.petopia.service.InterCareService;
import com.final2.petopia.service.InterMemberService;

@Controller
@Component
public class CareController {

	@Autowired
	private InterCareService service;
	
	@Autowired
	private InterMemberService member_service;
	

	//===== 반려동물 리스트 페이지 요청 ===== 
	@RequestMapping(value="/petList.pet", method={RequestMethod.GET})
	public String requireLogin_petList(HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null && loginuser.getMembertype().equals("1")) {
		
			String fk_idx = String.valueOf(loginuser.getIdx());
			req.setAttribute("fk_idx", fk_idx);
			 
		}
		
		return "care/petList.tiles2";
	}
	
	//===== 반려동물 리스트 가져오기(Ajax) =====
	@RequestMapping(value="/getPet.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> getPet(HttpServletRequest req) {

		String fk_idx = req.getParameter("fk_idx");
		
		List<HashMap<String, Object>> returnmapList = new ArrayList<HashMap<String, Object>>(); 
		
		List<HashMap<String,String>> list = service.getPet_infoList(Integer.parseInt(fk_idx));
		
		if(list != null) {
			for(HashMap<String,String> datamap : list) {
				HashMap<String, Object> submap = new HashMap<String, Object>(); 
				submap.put("PET_UID", datamap.get("PET_UID"));
				submap.put("FK_IDX", datamap.get("FK_IDX"));
				submap.put("PET_NAME", datamap.get("PET_NAME"));
				submap.put("PET_TYPE", datamap.get("PET_TYPE"));
				submap.put("PET_BIRTHDAY", datamap.get("PET_BIRTHDAY"));
				submap.put("PET_SIZE", datamap.get("PET_SIZE"));
				submap.put("PET_WEIGHT", datamap.get("PET_WEIGHT"));
				submap.put("PET_GENDER", datamap.get("PET_GENDER"));
				submap.put("PET_NEUTRAL", datamap.get("PET_NEUTRAL"));
				submap.put("MEDICAL_HISTORY", datamap.get("MEDICAL_HISTORY"));
				submap.put("ALLERGY", datamap.get("ALLERGY"));
				submap.put("PET_PROFILEIMG", datamap.get("PET_PROFILEIMG"));
				
				returnmapList.add(submap);
			}
		}
		
		return returnmapList;
	}
	
	
	//===== 반려동물 등록 페이지 요청 ===== 
	@RequestMapping(value="/petRegister.pet", method={RequestMethod.GET})
	public String register(HttpServletRequest req) {
		
		return "care/petRegister.tiles2";
	}
	//===== 반려동물 등록 페이지 완료 =====
	@RequestMapping(value="/petRegisterEnd.pet", method={RequestMethod.POST})
	public String registerEnd(PetVO pvo, HttpServletRequest req) {
	
		int n = service.insertPet_info(pvo);

		String msg = "";
		String loc = "";
		
		if(n == 1) {
			msg = "반려동물 등록 성공!!";
			loc = "/petopia/petList.pet";
		}
		else {
			msg = "반려동물 등록 실패!!";
			loc = "javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);

		return "msg";
	}
	
	
	//===== 특정 반려동물관리 상세정보 페이지 요청 =====
	@RequestMapping(value="/petView.pet", method={RequestMethod.GET})
	public String view(HttpServletRequest req) {
	
		String pet_UID = "";
		
		try {		

			HttpSession session = req.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			String fk_idx = String.valueOf(loginuser.getIdx());

			pet_UID = req.getParameter("pet_UID");	
			
			HashMap<String, String> paramap = new HashMap<String, String>();
			paramap.put("fk_idx", fk_idx);
			paramap.put("pet_UID", pet_UID);
			
			HashMap<String, Object> petInfo = service.getPet_info(paramap); 
			
			req.setAttribute("pet_UID", pet_UID);
			req.setAttribute("petInfo", petInfo);
			
			return "care/petView.tiles2";
			
		} catch (NumberFormatException e) {
			req.setAttribute("pet_UID", pet_UID);
			return "care/petRegister.tiles2";			
		}
		
	}
	
	//===== 특정 반려동물관리 몸무게(Ajax) 가져오기 =====
	@RequestMapping(value="/getWeight.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> getWeight(HttpServletRequest req) {
		
		String pet_UID = req.getParameter("pet_UID");
		
		List<HashMap<String, Object>> returnmapList = new ArrayList<HashMap<String, Object>>(); 
		
		List<HashMap<String,String>> list = service.getWeight(pet_UID);
		
		if(list != null) {
			for(HashMap<String,String> datamap : list) {
				HashMap<String, Object> submap = new HashMap<String, Object>(); 
				submap.put("PETWEIGHT_UID", datamap.get("PETWEIGHT_UID"));
				submap.put("FK_PET_UID", datamap.get("FK_PET_UID"));
				submap.put("PETWEIGHT_PAST", datamap.get("PETWEIGHT_PAST"));
				submap.put("PETWEIGHT_TARGETED", datamap.get("PETWEIGHT_TARGETED"));
				submap.put("PETWEIGHT_DATE", datamap.get("PETWEIGHT_DATE"));
				returnmapList.add(submap);
			}
		}
		
		return returnmapList;
	}
	
	//===== 특정 반려동물케어 몸무게 추가 페이지 요청 =====
	@RequestMapping(value="/addWeight.pet", method={RequestMethod.GET})
	public String addWeight(HttpServletRequest req) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		// 로그인 한 사용자의 정보 가져오기
		MemberVO mvo = member_service.selectMemberByIdx(loginuser.getIdx());
		
		String pet_UID = req.getParameter("pet_UID");
		
		req.setAttribute("mvo", mvo);
		req.setAttribute("pet_UID", pet_UID);
		
		return "care/addWeight.notiles";
	}
	//===== 특정 반려동물케어 몸무게 추가 페이지 완료 =====
	@RequestMapping(value="/addWeightEnd.pet", method={RequestMethod.POST})       
	public String addWeightEnd(HttpServletRequest req) 
		throws Throwable {
		
		// 1. form 에서 넘어온 값 받기
		String pet_UID = req.getParameter("pet_UID");
		String petweight_past = req.getParameter("petweight_past");
		String petweight_targeted = req.getParameter("petweight_targeted");
		String petweight_date = req.getParameter("petweight_date");
		
		// 2. HashMap으로 저장시킨다. 
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("PET_UID", pet_UID);
		paraMap.put("PETWEIGHT_PAST", petweight_past);
		paraMap.put("PETWEIGHT_TARGETED", petweight_targeted);
		paraMap.put("PETWEIGHT_DATE", petweight_date);

		// 3. Service 단으로 HashMap 을 넘긴다.
		String msg = "";
		String loc = "";
		
		try {
			
			service.addWeight(paraMap);
			msg = "체중 추가 성공!!";
			loc = "/petopia/petView.pet?pet_UID" + pet_UID;
			String script = "javascript:opener.parent.location='/petopia/petView.pet?pet_UID=" + pet_UID + "'";
			String script1 = "javascript:self.close();";
			req.setAttribute("script", script);
			req.setAttribute("script1", script1);
			
		} catch(Exception e) { 
			
			msg = "체중 추가 실패!!";
			loc = "/petopia/addWeight.pet?pet_UID=" + pet_UID;
			
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";	
	}

	//===== 특정 반려동물관리 진료기록(Ajax) 가져오기 =====
	@RequestMapping(value="/getChart.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> getChart(HttpServletRequest req) {

		String pet_UID = req.getParameter("pet_UID");
		
		List<HashMap<String, Object>> returnmapList = new ArrayList<HashMap<String, Object>>(); 

		List<HashMap<String,String>> list = service.getChart(pet_UID);
		
		if(list != null) {
			for(HashMap<String,String> datamap : list) {
				HashMap<String, Object> submap = new HashMap<String, Object>(); 
				submap.put("CHART_UID", datamap.get("CHART_UID"));
				submap.put("BIZ_NAME", datamap.get("BIZ_NAME"));
				submap.put("RESERVATION_DATE", datamap.get("RESERVATION_DATE"));
				
				returnmapList.add(submap);
			}
		}

		return returnmapList;
	}
	
	
	//===== 케어 건강수첩 페이지 요청 =====
	@RequestMapping(value="/careCalendar.pet", method={RequestMethod.GET})
	public String calendar(HttpServletRequest req) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월");
	    String date = sdf.format(new Date());
		
		if(loginuser != null && loginuser.getMembertype().equals("1")) {
		
			String fk_idx = String.valueOf(loginuser.getIdx());
			String pet_UID = req.getParameter("pet_UID");
			
			req.setAttribute("date", date);
			req.setAttribute("fk_idx", fk_idx);
			req.setAttribute("pet_UID", pet_UID);
		}
		
		return "care/careCalendar.tiles2";
	}
	
	// ===== 반려동물 리스트(Ajax) 가져오기 =====
	@RequestMapping(value="/getPetcare.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> getPetcare(HttpServletRequest req) {
	
		String pet_UID = req.getParameter("pet_UID");
		
		List<HashMap<String, Object>> returnmapList = new ArrayList<HashMap<String, Object>>(); 
		
		List<HashMap<String,String>> list = service.getPetcare(pet_UID);
		
		if(list != null) {
			for(HashMap<String,String> datamap : list) {
				HashMap<String, Object> submap = new HashMap<String, Object>(); 
				submap.put("CARETYPE_UID", datamap.get("CARETYPE_UID"));
				submap.put("CARETYPE_NAME", datamap.get("CARETYPE_NAME"));
				submap.put("CARETYPE_INFO", datamap.get("CARETYPE_INFO"));
				submap.put("CARE_UID", datamap.get("CARE_UID"));
				submap.put("FK_PET_UID", datamap.get("FK_PET_UID"));
				submap.put("FK_CARETYPE_UID", datamap.get("FK_CARETYPE_UID"));
				submap.put("CARE_CONTENTS", datamap.get("CARE_CONTENTS"));
				submap.put("CARE_MEMO", datamap.get("CARE_MEMO"));
				submap.put("CARE_START", datamap.get("CARE_START"));
				submap.put("CARE_END", datamap.get("CARE_END"));
				submap.put("CARE_ALARM", datamap.get("CARE_ALARM"));
				submap.put("CARE_DATE", datamap.get("CARE_DATE"));
				
				returnmapList.add(submap);
			}
		}
		
		return returnmapList;
	}
	
	
	//===== 케어 건강수첩 등록 페이지 요청 =====
	@RequestMapping(value="/careRegister.pet", method={RequestMethod.GET})
	public String careRegister(HttpServletRequest req) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String fk_idx = String.valueOf(loginuser.getIdx());
		
		String fk_pet_UID = req.getParameter("fk_pet_UID");
		String fk_caretype_UID = req.getParameter("fk_caretype_UID");
		
		List<HashMap<String,String>> caretypeList = service.getCaretypeList();
		
		HashMap<String, String> paramap = new HashMap<String, String>();
		paramap.put("fk_idx", fk_idx);
		paramap.put("pet_UID", fk_pet_UID);
		
		HashMap<String, Object> petInfo = service.getPet_info(paramap);		
		
		req.setAttribute("fk_pet_UID", fk_pet_UID);
		req.setAttribute("fk_caretype_UID", fk_caretype_UID);
		
		req.setAttribute("caretypeList", caretypeList);
		req.setAttribute("petInfo", petInfo);
		
		return "care/careRegister.tiles2";
	}
	
	//===== 케어 건강수첩 코드 가져오기 =====
	@RequestMapping(value="/getCaretype_info.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<HashMap<String, Object>> getCaretype_info(HttpServletRequest req) {
		
		List<HashMap<String, Object>> returnmapList = new ArrayList<HashMap<String, Object>>(); 
		
		String caretype = req.getParameter("caertype");
		List<HashMap<String,String>> list = service.getCaretype_infoList(caretype);
		
		if(list != null) {
			for(HashMap<String,String> datamap : list) {
				HashMap<String, Object> submap = new HashMap<String, Object>(); 
				submap.put("CARETYPE_INFO", datamap.get("CARETYPE_INFO"));
				
				returnmapList.add(submap);
			}
		}
	
		return returnmapList;
	}
	
	//===== 케어 건강수첩 등록 페이지 요청 완료 =====
	@RequestMapping(value="/careRegisterEnd.pet", method={RequestMethod.POST})
	public String careRegisterEnd(CareVO cvo, HttpServletRequest req) {
		
		String pet_UID = req.getParameter("fk_pet_UID");
	
		int n = service.insertPetcare(cvo);
		
		String msg = "";
		String loc = "";
		 
		if(n == 1) {
			msg = "케어 등록 성공!!";
			loc = "/petopia/careCalendar.pet?pet_UID="+pet_UID;
		}
		else {
			msg = "케어 등록 실패!!";
			loc = "javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);

		return "msg";		
	}
	
	
} // end of class CareController
