package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import com.final2.petopia.model.MemberVO;

public interface InterMemberService {

	List<HashMap<String, String>> selectRecommendTagList(); // 태그 리스트 보여주기

	// *** 사용자 *** //
	// *** 회원가입 *** //
	int insertMemberByMvoTagList(MemberVO mvo, String[] tagNoArr, String[] tagNameArr); // 태그가 있는 경우 회원가입
	int insertMemberByMvo(MemberVO mvo); // 태그가 없는 경우 회원가입

	// *** 아이디 중복 체크 *** //
	int selectMemberIdIsUsed(String userid);

	// *** 로그인 *** //
	MemberVO loginSelectByUseridPwd(HashMap<String, String> loginMap);
	
	// *** SNS 로그인 *** //
	int selectSNSMemberStatus(String userid); // sns 로그인 아이디와 비번이 있는 경우 사용 가능한지 알아보기
	MemberVO loginSelectByUserid(String userid); // sns 로그인해서 정보 가져오기
	
	// *** 회원번호로 회원정보 조회 *** //
	MemberVO selectMemberByIdx(int idx); // 회원정보 조회
	List<HashMap<String, String>> selectHave_tagByIdx(int idx); // 저장된 사용자 태그 조회

	// *** 회원수정 *** //
	// 프로필 사진이 있는 경우
	int updateMemberByMvoTagList(MemberVO mvo, String[] tagNoArr, String[] tagNameArr); // 태그가 있는 회원수정
	int updateMemberByMvo(MemberVO mvo); // 태그가 없는 회원수정
	// 프로필 사진이 없는 경우
	int updateMemberByMvoTagListNoProfile(MemberVO mvo, String[] tagNoArr, String[] tagNameArr); // 태그가 있는 회원수정
	int updateMemberByMvoNoProfile(MemberVO mvo); // 태그가 없는 회원수정

	// *** 회원 탈퇴 *** //
	int updateMemberStatusOutByIdx(int idx);

	// *** 관리자 *** //
	// *** 회원목록 ***//Object
	// 해당하는 총회원 수
	int selectTotalCount(); // 검색 X
	int selectTotalCountBySearch(HashMap<String, Object> paraMap); // 검색 O

	// memberList 조회
	List<MemberVO> selectMemberList(HashMap<String, Object> paraMap); // 검색 X 정렬 X
	List<MemberVO> selectMemberListByOrderBy(HashMap<String, Object> paraMap); // 검색 X 정렬 O
	List<MemberVO> selectMemberListBySearch(HashMap<String, Object> paraMap); // 검색 O 정렬 X
	List<MemberVO> selectMemberListBySearchOrderBy(HashMap<String, Object> paraMap); // 검색 O 정렬 O

	// *** 회원 휴면 해제 *** //
	int updateAdminMemberDateByIdx(int idx);

	// *** 회원 복원 *** //
	int updateMemberStatusInByIdx(int idx);

	// *** 비밀번호 찾기 *** //
	// === 2019.01.24 === 비밀번호 찾기 시작 //
	int selectMemberIsByUseridEmail(HashMap<String, String> paramap); // 아이디와 이메일로 회원이 있는지 찾기
	// === 2019.01.24 === 비밀번호 찾기 //
	
	// === 2019.01.25 === 비밀번호 변경 //
	// *** 비밀번호 변경 *** //
	int updateMemberPwdByUserid(HashMap<String, String> paramap);
	// === 2019.01.25 === 비밀번호 변경 //
	
	// === 2019.02.13 === //
	// 아이디 찾기 
	String selectMemberIdByNamePhone(HashMap<String, String> paraMap);
	// === 2019.02.13 === //
}