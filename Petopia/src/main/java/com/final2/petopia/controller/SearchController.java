package com.final2.petopia.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;

import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.model.MemberVO;
import com.final2.petopia.service.InterSearchService;
import com.google.gson.Gson;

@Controller
public class SearchController {
	
	@Autowired
	private InterSearchService service;
	
	// 검색어를 입력 후 엔터했을때 지도화면으로 보내기
	@RequestMapping(value="/search.pet", method= {RequestMethod.GET})
	public String search(HttpServletRequest req) {
		
		String searchWord = req.getParameter("searchWord");
		String orderbyNo = req.getParameter("orderbyNo");
		String[] numbers = req.getParameterValues("numbers");
		String str_numbers = "";
		String whereNo = req.getParameter("whereNo");
		
		String pattern = (String)req.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
		// /search.pet
		
		if(searchWord == null || searchWord.trim().isEmpty()) {
			searchWord = "";
		}
		
		if(orderbyNo == null || orderbyNo.trim().isEmpty()) {
			orderbyNo = "1";
		}
		
		if(whereNo == null || whereNo.trim().isEmpty()) {
			whereNo = "1";
		}
		
		// 지도화면으로 넘어갈때 몇건 검색되었는지도 보내기
		int	cnt = service.searchCount(searchWord,whereNo);

		if(numbers != null && !numbers[0].trim().isEmpty()) {
			for(int i=0;i<numbers.length;i++) {
				if(numbers[i].equals("현재위치")) {
					continue;
				}
				if(i == 1) {
					str_numbers += "DECODE(idx_biz,";
				}
				
				str_numbers += (i!=(numbers.length-1))?numbers[i]+","+i+",":numbers[i]+","+i+")";
			}
		}
		
		List<Biz_MemberVO> bizmemList = service.getBizmemListBySearchWord(whereNo,searchWord,str_numbers,orderbyNo);
		// 검색어를 기준으로 biz_member 정보 리스트 불러오기
		
		Gson gson = new Gson();
		String gson_bizmemList = gson.toJson(bizmemList);
		
		req.setAttribute("searchWord", searchWord);
		req.setAttribute("cnt", cnt);
		req.setAttribute("gson_bizmemList", gson_bizmemList);
		req.setAttribute("bizmemList", bizmemList);
		req.setAttribute("whereNo", whereNo);
		req.setAttribute("pattern", pattern);
		
		return "search/index.tiles2";
	
	}
	
	// 검색어를 기준으로 지역별, 병원별, 약국별 갯수 보여주는 AJAX
	@RequestMapping(value="/getNumberbysearchWord.pet", method= {RequestMethod.GET})
	@ResponseBody
	public HashMap<String, Integer> getNumberbysearchWord(HttpServletRequest req) {
		
		String searchWord = req.getParameter("searchWord");

		HashMap<String, Integer> CountMap = new HashMap<String, Integer>();
		
		if(searchWord != null && !searchWord.trim().isEmpty()) {		
			CountMap = service.searchCountMap(searchWord);
			// 단어를 기준으로 지역명 - 몇건, 병원이름 - 몇건, 약국이름 - 몇건 이런식으로 보여주기
		}
		
		return CountMap;
		
	}
	
	
	// 검색결과가 1개인 경우(사용자가 병원 또는 약국 이름을 알고 검색 한 경우) 병원 풀네임을 받아 보여주고, 바로 병원 정보로 갈 수 있도록 링크 생성하기
	@RequestMapping(value="wordCompleteAndSetDirect.pet", method= {RequestMethod.GET})
	@ResponseBody
	public Biz_MemberVO wordCompleteAndSetDirect(HttpServletRequest req) {
		
		String searchWord = req.getParameter("searchWord");
		
		Biz_MemberVO bizvo = service.getFullnameAndIdx(searchWord);
		
		return bizvo;
		
	}
	
	// 검색결과 창에서 평점순으로 정렬을 요청했을때 order by 해서 넘겨주는 AJAX
	@RequestMapping(value="selectOrderbyNo.pet", method= {RequestMethod.GET}, produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String selectOrderbyNo(HttpServletRequest req) {

		String whereNo = req.getParameter("whereNo");
		String orderbyNo = req.getParameter("orderbyNo");
		String searchWord = req.getParameter("searchWord");
		String pattern = req.getParameter("pattern");

		List<Biz_MemberVO> bizmemList = null;
		
		if(pattern.equals("/requireLogin_search.pet")) {
			HttpSession session = req.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			int loginuser_idx = loginuser.getIdx();

			bizmemList = service.getBizmemListByidx(loginuser_idx, "1", "");
		}
		else {
			bizmemList = service.getBizmemListBySearchWord(whereNo,searchWord,"",orderbyNo);
		}

		Gson gson = new Gson();
		String gson_bizmemList = gson.toJson(bizmemList);
		
		return gson_bizmemList;
		
	}

	// 검색결과 창에서 거리순으로 정렬을 요청했을때 order by 해서 넘겨주는 AJAX
	@RequestMapping(value="selectOrderbydistance.pet", method= {RequestMethod.GET}, produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String selectOrderbydistance(HttpServletRequest req) {

		String[] numbers = req.getParameterValues("numbers");
		String searchWord = req.getParameter("searchWord");
		String whereNo = req.getParameter("whereNo");
		String pattern = req.getParameter("pattern");
		
		List<Biz_MemberVO> bizmemList = null;
		
		if(pattern.equals("/requireLogin_search.pet")) {

			HttpSession session = req.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			int loginuser_idx = loginuser.getIdx();

			String str_numbers = "";
			
			if(numbers != null && !numbers[0].trim().isEmpty()) {
				for(int i=0;i<numbers.length;i++) {
					if(numbers[i].equals("현재위치")) {
						continue;
					}
					if(i == 1) {
						str_numbers += "DECODE(idx_biz,";
					}
					
					str_numbers += (i!=(numbers.length-1))?numbers[i]+","+i+",":numbers[i]+","+i+")";
				}
			}
			
			
			bizmemList = service.getBizmemListByidx(loginuser_idx, "2", str_numbers);
			
		}
		else {

			if(searchWord == null || searchWord.trim().isEmpty()) {
				searchWord = "";
			}
			
			if(whereNo == null || whereNo.trim().isEmpty()) {
				whereNo = "1";
			}
			
			String str_numbers = "";
			for(int i=0;i<numbers.length;i++) {
				if(numbers[i].equals("현재위치")) {
					continue;
				}
				if(i == 1) {
					str_numbers += "DECODE(idx_biz,";
				}
				
				str_numbers += (i!=(numbers.length-1))?numbers[i]+","+i+",":numbers[i]+","+i+")";
			}
			
			// System.out.println(str_numbers);
			
			bizmemList = service.getBizmemListBySearchWord(whereNo,searchWord,str_numbers,"2");

		}
		
		Gson gson = new Gson();
		String gson_bizmemList = gson.toJson(bizmemList);
		
		return gson_bizmemList;
	}
	
	// 맞춤추천_로그인필요
	@RequestMapping(value="requireLogin_search.pet", method= {RequestMethod.GET})
	public String requireLogin_search(HttpServletRequest req, HttpServletResponse res) {

		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String pattern = (String)req.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
		// /requireLogin_search.pet
		
		if(loginuser != null) {

			int loginuser_idx = loginuser.getIdx();
			// System.out.println(loginuser_idx);

			List<Biz_MemberVO> bizmemList = service.getBizmemListByidx(loginuser_idx, "1", "");

			int cnt = service.getCntForRecomm(loginuser_idx);
			
			Gson gson = new Gson();
			String gson_bizmemList = gson.toJson(bizmemList);
			
			req.setAttribute("cnt", cnt);
			req.setAttribute("gson_bizmemList", gson_bizmemList);
			req.setAttribute("bizmemList", bizmemList);
			req.setAttribute("pattern", pattern);

		}

		return "search/index.tiles2";
	
	}
	
}