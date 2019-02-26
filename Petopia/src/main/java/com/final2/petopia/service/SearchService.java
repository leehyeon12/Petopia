package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.model.InterSearchDAO;

@Service
public class SearchService implements InterSearchService {

	@Autowired
	private InterSearchDAO dao; 
	
	// 단어를 기준으로 지역명 - 몇건, 병원이름 - 몇건, 약국이름 - 몇건 이런식으로 보여주기
	public HashMap<String, Integer> searchCountMap(String searchWord) {
		HashMap<String, Integer> searchCountMap = dao.searchCountMap(searchWord); 
		return searchCountMap;
	}

	// 검색결과가 1개인 경우(사용자가 병원 또는 약국 이름을 알고 검색 한 경우) 병원 풀네임을 받아 보여주고, 바로 병원 정보로 갈 수 있도록 링크 생성하기
	public Biz_MemberVO getFullnameAndIdx(String searchWord) {
		Biz_MemberVO bizvo = dao.getFullnameAndIdx(searchWord);
		return bizvo;
	}

	// 검색창으로 넘어갈때 검색된 병원/약국 수 보내기 
	public int searchCount(String searchWord,String whereNo) {
		int cnt = dao.searchCount(searchWord, whereNo);
		return cnt;
	}
	
	// 검색어를 기준으로 biz_member 정보 리스트 불러오기
	@Override
	public List<Biz_MemberVO> getBizmemListBySearchWord(String whereNo, String searchWord, String numbers, String orderbyNo) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		if(!numbers.equals("")) {
			map.put("STR_NUMBERS", numbers);
		}

		map.put("WHERENO", whereNo);
		map.put("SEARCHWORD", searchWord);
		map.put("ORDERBYNO", orderbyNo);
		
		List<Biz_MemberVO> bizMemList = dao.getBizmemListBySearchWord(map);
		
		return bizMemList;
	}

	// 맞춤추천 : 로그인 유저의 idx를 기준으로 biz_member 정보 리스트 불러오기 
	@Override
	public List<Biz_MemberVO> getBizmemListByidx(int loginuser_idx, String orderbyNo, String numbers) {
		List<Biz_MemberVO> bizmemList = dao.getBizmemListByidx(loginuser_idx, orderbyNo, numbers);
		return bizmemList;
	}

	// 맞춤추천 : 병원/약국 수 보내기
	@Override
	public int getCntForRecomm(int loginuser_idx) {
		int cnt = dao.getCntForRecomm(loginuser_idx);
		return cnt;
	}


	

}