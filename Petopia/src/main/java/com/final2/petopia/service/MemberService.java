package com.final2.petopia.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.final2.petopia.common.SHA256;
import com.final2.petopia.model.InterMemberDAO;
import com.final2.petopia.model.MemberVO;

@Service
public class MemberService implements InterMemberService {
	
	@Autowired
	private InterMemberDAO dao;

	// 태그 리스트 보여주기
	@Override
	public List<HashMap<String, String>> selectRecommendTagList() {
		List<HashMap<String, String>> tagList = dao.selectRecommendTagList();
		
		return tagList;
	} // end of public List<HashMap<String, String>> selectRecommendTagList()

	// *** 회원가입 *** //
	// 태그가 있는 경우 회원가입
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertMemberByMvoTagList(MemberVO mvo, String[] tagNoArr, String[] tagNameArr) {
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		mvo.setIdx(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(mvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(mvo);
		
		// have_tag 테이블 insert
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(idx));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n3 = dao.insertHave_tagByTagList(selectTagList);
		
		if(n1*n2*n3 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		return result;
	} // end of public int insertMemberByMvoTagList(MemberVO mvo, List<HashMap<String, String>> selectTagList)
	
	// 태그가 없는 경우 회원가입
	@Override
	public int insertMemberByMvo(MemberVO mvo) {
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		mvo.setIdx(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(mvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(mvo);
		
		if(n1*n2 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		return result;
	} // end of public int insertMemberByMvo(MemberVO mvo)

	// *** 아이디 중복 체크 *** //
	@Override
	public int selectMemberIdIsUsed(String userid) {
		int cnt  = dao.selectMemberIdIsUsed(userid);
		
		return cnt;
	} // end of public int selectMemberIdIsUsed(String userid)

	// *** 로그인 *** //
	@Override
	public MemberVO loginSelectByUseridPwd(HashMap<String, String> loginMap) {
		MemberVO loginuser = dao.loginSelectByUseridPwd(loginMap);
		if(loginuser == null) {
			return null;
		} else if(loginuser.getLastlogindategap() >= 12) {
			// 마지막 로그인 날짜 확인 후 12개월 이상이면 휴면으로
			loginuser.setIdleStatus(true);
			
			return loginuser;
		} else {
			// 마지막 로그인 날짜 기록하기
			dao.updateLoginDateByUserid(loginMap.get("USERID"));
			
			return loginuser;
		} // end of if~else
		
	} // public MemberVO loginSelectByUseridPwd(HashMap<String, String> loginMap)

	// *** SNS 로그인 *** //
	// sns 로그인 아이디와 비번이 있는 경우 사용 가능한지 알아보기
	@Override
	public int selectSNSMemberStatus(String userid) {
		int status = dao.selectSNSMemberStatus(userid);
		
		return status;
	} // end of public int selectSNSMemberStatus(String userid)
	
	// sns 로그인해서 정보 가져오기
	@Override
	public MemberVO loginSelectByUserid(String userid) {
		MemberVO loginuser = dao.loginSelectByUserid(userid);
		
		if(loginuser == null) {
			return null;
		} else if(loginuser.getLastlogindategap() >= 12) {
			// 마지막 로그인 날짜 확인 후 12개월 이상이면 휴면으로
			loginuser.setIdleStatus(true);
			
			return loginuser;
		} else {
			// 마지막 로그인 날짜 기록하기
			dao.updateLoginDateByUserid(userid);
			
			return loginuser;
		} // end of if~else
	} // end of public MemberVO loginSelectByUserid(String userid)
	
	// *** 회원번호로 회원정보 조회 *** //
	// 회원정보 조회
	@Override
	public MemberVO selectMemberByIdx(int idx) {
		MemberVO mvo = dao.selectMemberByIdx(idx);
		
		return mvo;
	} // end of public MemberVO selectMemberByUserid(String userid)

	// 저장된 사용자 태그 조회
	@Override
	public List<HashMap<String, String>> selectHave_tagByIdx(int idx) {
		List<HashMap<String, String>> haveTagList = dao.selectHave_tagByIdx(idx);
		
		return haveTagList;
	} // end of public List<HashMap<String, String>> selectHave_tagByIdx(int idx)

	// *** 회원수정 *** //
	// 태그가 있는 회원수정
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int updateMemberByMvoTagList(MemberVO mvo, String[] tagNoArr, String[] tagNameArr) {
		int result = 0;
		
		// member 테이블의 정보수정
		int n1 = dao.updateMemberByMvo(mvo);
		
		// login_log 테이블의 정보수정
		int n2 = dao.updateLogin_logByMvo(mvo);
		
		// 해당 사용자의 태그 모두 지우기
		int n3 = dao.deleteHave_tagByIdx(mvo.getIdx());
		
		// 선택된 태그 새로 넣기
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(mvo.getIdx()));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n4 = dao.insertHave_tagByTagList(selectTagList);
		
		if(n1*n2*n4 == 0) {
			result = 0;
		} else {
			result = 1; 
		} // end of if~else
		
		return result;
	} // end of public int updateMemberByMvoTagList(MemberVO mvo, String[] tagNoArr, String[] tagNameArr)

	// 태그가 없는 회원수정 
	@Override
	public int updateMemberByMvo(MemberVO mvo) {
		int result = 0;
		
		// member 테이블의 정보수정
		int n1 = dao.updateMemberByMvo(mvo);
		
		// login_log 테이블의 정보수정
		int n2 = dao.updateLogin_logByMvo(mvo);
		
		// 해당 사용자의 태그 모두 지우기
		int n3 = dao.deleteHave_tagByIdx(mvo.getIdx()); 
		
		if(n1*n2 == 0) {
			result = 0;
		} else {
			result = 1;
		} // end of if~else
		
		return result;
	} // end of public int updateMemberByMvo(MemberVO mvo)

	// 프로필 사진이 없는 경우
	// 태그가 있는 회원수정
	@Override
	public int updateMemberByMvoTagListNoProfile(MemberVO mvo, String[] tagNoArr, String[] tagNameArr) {
		int result = 0;
		
		// member 테이블의 정보수정(프로필 사진 변경 X)
		int n1 = dao.updateMemberByMvoNoProfile(mvo);
		
		// login_log 테이블의 정보수정
		int n2 = dao.updateLogin_logByMvo(mvo);
		
		// 해당 사용자의 태그 모두 지우기
		int n3 = dao.deleteHave_tagByIdx(mvo.getIdx());
		
		// 선택된 태그 새로 넣기
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(mvo.getIdx()));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n4 = dao.insertHave_tagByTagList(selectTagList);
		
		if(n1*n2*n4 == 0) {
			result = 0;
		} else {
			result = 1; 
		} // end of if~else
		
		return result;
	} // end of public int updateMemberByMvoTagListNoProfile(MemberVO mvo)

	// 태그가 없는 회원수정
	@Override
	public int updateMemberByMvoNoProfile(MemberVO mvo) {
		int result = 0;
		
		// member 테이블의 정보수정
		int n1 = dao.updateMemberByMvoNoProfile(mvo);
		
		// login_log 테이블의 정보수정
		int n2 = dao.updateLogin_logByMvo(mvo);
		
		// 해당 사용자의 태그 모두 지우기
		int n3 = dao.deleteHave_tagByIdx(mvo.getIdx()); 
		
		if(n1*n2 == 0) {
			result = 0;
		} else {
			result = 1;
		} // end of if~else
		
		return result;
	} // end of public int updateMemberByMvoNoProfile(MemberVO mvo)

	// *** 회원 탈퇴 *** //
	@Override
	public int updateMemberStatusOutByIdx(int idx) {
		int result = dao.updateMemberStatusOutByIdx(idx);
		
		return result;
	} // end of public int deleteMemberByIdx(int idx)

	// *** 관리자 *** //
	// *** 회원목록 ***//
	// 해당하는 총회원 수
	// 검색 X
	@Override
	public int selectTotalCount() {
		int totalCount = dao.selectTotalCount();
		
		return totalCount;
	} // end of public int selectTotalCount()

	// 검색 O
	@Override
	public int selectTotalCountBySearch(HashMap<String, Object> paraMap) {
		int totalCount = dao.selectTotalCountBySearch(paraMap);
		
		return totalCount;
	} // end of public int selectTotalCountBySearch(HashMap<String, Object> paraMap)

	// memberList 조회
	// 검색 X 정렬 X
	@Override
	public List<MemberVO> selectMemberList(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = dao.selectMemberList(paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberList(HashMap<String, Object> paraMap)

	// 검색 X 정렬 O
	@Override
	public List<MemberVO> selectMemberListByOrderBy(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = dao.selectMemberListByOrderBy(paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberListByOrderBy(HashMap<String, Object> paraMap)

	// 검색 O 정렬 X
	@Override
	public List<MemberVO> selectMemberListBySearch(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = dao.selectMemberListBySearch(paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberListBySearch(HashMap<String, Object> paraMap)

	// 검색 O 정렬 O
	@Override
	public List<MemberVO> selectMemberListBySearchOrderBy(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = dao.selectMemberListBySearchOrderBy(paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberListBySearchOrderBy(HashMap<String, Object> paraMap)

	
	// *** 회원 휴면 해제 *** //
	@Override
	public int updateAdminMemberDateByIdx(int idx) {
		int result = dao.updateAdminMemberDateByIdx(idx);
		
		return result;
	} // end of public int updateAdminMemberDateByIdx(int idx)

	// *** 회원 복원 *** //
	@Override
	public int updateMemberStatusInByIdx(int idx) {
		int result = dao.updateMemberStatusInByIdx(idx);
		
		return result;
	} // end of public int updateMemberStatusInByIdx(int idx)

	// *** 비밀번호 찾기 *** //
	// === 2019.01.24 === 비밀번호 찾기 시작 //
	// 아이디와 이메일로 회원이 있는지 찾기
	@Override
	public int selectMemberIsByUseridEmail(HashMap<String, String> paramap) {
		int cnt = dao.selectMemberIsByUseridEmail(paramap);
		
		return cnt;
	} // end of public int selectMemberIsByUseridEmail(HashMap<String, String> paramap)
	// === 2019.01.24 === 비밀번호 찾기 //

	// === 2019.01.25 === 비밀번호 변경 //
	// *** 비밀번호 변경 *** //
	@Override
	public int updateMemberPwdByUserid(HashMap<String, String> paramap) {
		int result = 0;
		
		int n1 = dao.updateMemberPwdByUserid(paramap);
		int n2 = dao.updateLogin_logPwdByUserid(paramap);
		
		if(n1*n2 == 0) {
			result = 0;
		} else {
			result = 1;
		} // end of if
		
		return result;
	} // end of public int updateMemberPwdByUserid(HashMap<String, String> paramap)
	// === 2019.01.25 === 비밀번호 변경 //

	// === 2019.02.13 === //
	// 아이디 찾기 
	@Override
	public String selectMemberIdByNamePhone(HashMap<String, String> paraMap) {
		String findId = dao.selectMemberIdByNamePhone(paraMap);
		
		return findId;
	} // end of public String selectMemberIdByNamePhone(HashMap<String, String> paraMap)
	// === 2019.02.13 === //
}