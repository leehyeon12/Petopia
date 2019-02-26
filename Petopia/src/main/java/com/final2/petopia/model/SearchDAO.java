package com.final2.petopia.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SearchDAO implements InterSearchDAO {
	
	@Autowired
	private SqlSessionTemplate sqlsession;	

	
	// 단어를 기준으로 지역명 - 몇건, 병원이름 - 몇건, 약국이름 - 몇건 이런식으로 보여주기
	@Override
	public HashMap<String, Integer> searchCountMap(String searchWord) {
		
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		
		int addrCnt = sqlsession.selectOne("search.addrCount",searchWord);
		int hsptalCnt = sqlsession.selectOne("search.hsptalCount",searchWord);
		int pharmCnt = sqlsession.selectOne("search.pharmCount",searchWord);
		
		map.put("ADDRCOUNT", addrCnt);
		map.put("HSPTALCOUNT", hsptalCnt);
		map.put("PHARMCOUNT", pharmCnt);
		
		return map;
		
	}

	
	// 검색결과가 1개인 경우(사용자가 병원 또는 약국 이름을 알고 검색 한 경우) 병원 풀네임을 받아 보여주고, 바로 병원 정보로 갈 수 있도록 링크 생성하기
	@Override
	public Biz_MemberVO getFullnameAndIdx(String searchWord) {
		
		Biz_MemberVO bizvo = sqlsession.selectOne("search.getFullnameAndIdx", searchWord);
		
		return bizvo;
	}


	// 검색창으로 넘어갈때 검색된 병원/약국 수 보내기 
	@Override
	public int searchCount(String searchWord, String whereNo) {
		
		int cnt = 0;
		
		switch (whereNo) {
			case "1":
				cnt = sqlsession.selectOne("search.addrCount", searchWord);
				break;
			case "2":
				cnt = sqlsession.selectOne("search.hsptalCount", searchWord);
				break;
			case "3":
				cnt = sqlsession.selectOne("search.pharmCount", searchWord);
				break;
	
			default:
				cnt = sqlsession.selectOne("search.addrCount", searchWord);
				break;
		}
		
		return cnt;
	}

	// 검색어를 기준으로 biz_member 정보 리스트 불러오기
	@Override
	public List<Biz_MemberVO> getBizmemListBySearchWord(HashMap<String, Object> map) {
		List<Biz_MemberVO> bizMemList = sqlsession.selectList("search.getBizmemListByword", map);
		return bizMemList;
	}


	// 맞춤추천 : 로그인 유저의 idx를 기준으로 biz_member 정보 리스트 불러오기 
	@Override
	public List<Biz_MemberVO> getBizmemListByidx(int loginuser_idx, String orderbyNo, String numbers) {
		
		List<Biz_MemberVO> bizmemList = null;
		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("LOGINUSER_IDX", loginuser_idx);
		map.put("ORDERBYNO", orderbyNo);
		map.put("NUMBERS", numbers);
		
		// 예약기록이 있는 회원 : user based collaborative filtering 사용
		//				     1)제일 많이 다녀온 병원 1개를 뽑아 2)그 병원을 예약했던 회원 리스트를 기준으로 3)그 회원들이 다녀온 다른 병원 리스트를 뽑아 가장 많이 나오는 순서대로 출력한다.
		
		// 예약기록이 없는 회원 : contents based Recommendation 사용
		//				     회원가입시 선택한 태그 5개를 기준으로 가장 많이 태그를 보유한 병원 순서대로 출력한다.
		
		// 예약기록이 있는지 없는지 확인 
		int cnt = sqlsession.selectOne("search.getCountReservRecord",loginuser_idx);
		
		if(cnt == 0) {
			// 예약기록이 없다면
			bizmemList = sqlsession.selectList("search.getBizmemListByidx", map);
		}
		else {
			// 예약기록이 있다면
			bizmemList = sqlsession.selectList("search.getBizmemListByRecord", map);
			
			// 예약기록이 있지만 해당 병원에 다른 예약자가 없는 경우
	         if(bizmemList == null || bizmemList.isEmpty()) {
	            bizmemList = sqlsession.selectList("search.getBizmemListByidx", map);
	         }
		}
		
		return bizmemList;
		
	}


	@Override
	public int getCntForRecomm(int loginuser_idx) {
		
		int cnt = 0;

		// 예약기록이 있는지 없는지 확인 
		int recCnt = sqlsession.selectOne("search.getCountReservRecord",loginuser_idx);
		
		if(recCnt == 0) {
			// 예약기록이 없다면
			cnt = sqlsession.selectOne("search.recommCount", loginuser_idx);
		}
		else {
			// 예약기록이 있다면
			cnt = sqlsession.selectOne("search.RecordCount", loginuser_idx);
			
			// 예약기록이 있지만 해당 병원에 다른 예약자가 없는 경우
	         if(cnt == 0) {
	            cnt = sqlsession.selectOne("search.recommCount", loginuser_idx);
	         }
		}
		return cnt;
	}




}
