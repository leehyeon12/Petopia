package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;


public interface InterSearchDAO {

   // 단어를 기준으로 지역명 - 몇건, 병원이름 - 몇건, 약국이름 - 몇건 이런식으로 보여주기
   HashMap<String, Integer> searchCountMap(String searchWord);
   
   // 검색결과가 1개인 경우(사용자가 병원 또는 약국 이름을 알고 검색 한 경우) 병원 풀네임을 받아 보여주고, 바로 병원 정보로 갈 수 있도록 링크 생성하기
   Biz_MemberVO getFullnameAndIdx(String searchWord);

   // 검색창으로 넘어갈때 검색된 병원/약국 수 보내기 
   int searchCount(String searchWord, String whereNo);

   // 검색어를 기준으로 biz_member 정보 리스트 불러오기
   List<Biz_MemberVO> getBizmemListBySearchWord(HashMap<String, Object> map);

   // 맞춤추천 : 로그인 유저의 idx를 기준으로 biz_member 정보 리스트 불러오기 
   List<Biz_MemberVO> getBizmemListByidx(int loginuser_idx, String orderbyNo, String numbers);

   // 맞춤추천 : 병원/약국 수 보내기
   int getCntForRecomm(int loginuser_idx);
   
}