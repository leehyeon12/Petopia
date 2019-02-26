package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import com.final2.petopia.model.Biz_MemberVO;

public interface InterBiz_MemberService {

	// 태그 리스트 보여주기
	List<HashMap<String, String>> selectRecommendTagList();
	
	// 아이디 중복체크
	int selectBizMemberIdIsUsed(String userid);
	
	// 태그가 있는 경우 회원가입
	int insertMemberByMvoTagList(Biz_MemberVO mvo, String[] tagNoArr, String[] tagNameArr);
	
	// 태그가 있고 이미지가 있는 경우 회원가입
	int insertMemberByMvoTagListImg(Biz_MemberVO mvo, String[] tagNoArr, String[] tagNameArr, List<HashMap<String,String>> addImgmapList);


	// 태그가 없는 경우 회원가입
	int insertMemberByMvo(Biz_MemberVO mvo);

	//
	int insertMemberByMvoImg(Biz_MemberVO mvo,  List<HashMap<String,String>> addImgmapList);

	// 태그가 있고 이미지가 없고 의사가 있는 경우 회원가입
	int insertMemberByMvoTagListDoc(Biz_MemberVO mvo, String[] tagNoArr, String[] tagNameArr, String[] doctor, String[] docdog,String[] doccat, String[] docsmallani, String[] docetc);
	
	// 태그가 있고 이미지가 있고 의사가 있는 경우 회원가입
	int insertMemberByMvoTagImgListDoc(Biz_MemberVO bmvo, String[] tagNoArr, String[] tagNameArr,
			List<HashMap<String, String>> addImgmapList, String[] doctor, String[] docdog, String[] doccat,
			String[] docsmallani, String[] docetc);

	// 태그가 없고 이미지도 없고 의사는 있는 경우 회원가입
	int insertMemberByMvoDoc(Biz_MemberVO bmvo, String[] doctor, String[] docdog, String[] doccat, String[] docsmallani,
			String[] docetc);
	
	// 태그가 없고 이미지는 있고 의사도 있는 경우 회원가입
	int insertMemberByMvoImgDoc(Biz_MemberVO bmvo, List<HashMap<String, String>> addImgmapList, String[] doctor,
			String[] docdog, String[] doccat, String[] docsmallani, String[] docetc);
	
	// 상세페이지 기업명
	Biz_MemberVO selectBizMemberVOByIdx_biz(String idx_biz);
	
	//태그목록가져오기
	List<String> selectBizTagList(String idx_biz);
	
	// 의료진 가죠오기
	List<HashMap<String, String>> selectDocList(String idx_biz);
	
	// 기업추가이미지
	List<String> selectBizImgList(String idx_biz);

}
