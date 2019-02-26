package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAO implements InterMemberDAO {

	@Autowired
	private SqlSessionTemplate sqlsession;
	
	// 태그 리스트 보여주기
	@Override
	public List<HashMap<String, String>> selectRecommendTagList() {
		List<HashMap<String, String>> tagList = sqlsession.selectList("member.selectRecommendTagList");
		
		return tagList;
	} // end of public List<HashMap<String, String>> selectRecommendTagList()

	// *** 회원가입 *** //
	// 회원가입할 회원번호 받아오기
	@Override
	public int selectMemberNoSeq() {
		int idx = sqlsession.selectOne("member.selectMemberSeq");
		
		return idx;
	} // end of public int selectMemberNoSeq()

	// member 테이블 insert
	@Override
	public int insertMemberByMvo(MemberVO mvo) {
		int result = sqlsession.insert("member.insertMemberByMvo", mvo);
		
		return result;
	} // end of public int insertMemberByMvo(MemberVO mvo)

	// login_log 테이블 insert
	@Override
	public int insertLogin_logByMvo(MemberVO mvo) {
		int result = sqlsession.insert("member.insertLogin_logByMvo", mvo);
		
		return result;
	} // end of public int insertLogin_logByMvo(MemberVO mvo)
	
	// have_tag 테이블 insert
	@Override
	public int insertHave_tagByTagList(List<HashMap<String, String>> selectTagList) {
		int result = 0;
		for(HashMap<String, String> selectTag : selectTagList) {
			int n = sqlsession.insert("member.insertHave_tagByTagList", selectTag);
			
			if(n == 0) {
				return 0;
			} else {
				result = 1;
			} // end of if
		} // end of for
		
		return result;
	} // end of public int insertHave_tagByTagList(List<HashMap<String, String>> selectTagList)

	// *** 아이디 중복 체크 *** //
	@Override
	public int selectMemberIdIsUsed(String userid) {
		int cnt = sqlsession.selectOne("member.selectMemberIdIsUsed", userid);
		
		return cnt;
	} // end of public int selectMemberIdIsUsed(String userid)

	// *** 로그인 *** //
	// 로그인
	@Override
	public MemberVO loginSelectByUseridPwd(HashMap<String, String> loginMap) {
		MemberVO loginuser = sqlsession.selectOne("member.loginSelectByUseridPwd", loginMap);
		
		return loginuser;
	} // end of public MemberVO loginSelectByUseridPwd(HashMap<String, String> loginMap)

	// 마지막 로그인 날짜 기록하기
	@Override
	public void updateLoginDateByUserid(String userid) {
		sqlsession.update("member.updateLoginDateByUserid", userid);
	} // end of public void updateLoginDateByUserid(HashMap<String, String> loginMap)

	// *** SNS 로그인 *** //
	// sns 로그인 아이디와 비번이 있는 경우 사용 가능한지 알아보기
	@Override
	public int selectSNSMemberStatus(String userid) {
		int status = sqlsession.selectOne("member.selectSNSMemberStatus", userid);
		
		return status;
	} // end of public int selectSNSMemberStatus(HashMap<String, String> paramap)
	
	// sns 로그인해서 정보 가져오기
	@Override
	public MemberVO loginSelectByUserid(String userid) {
		MemberVO loginuser = sqlsession.selectOne("member.loginSelectByUserid", userid);
		
		return loginuser;
	} // end of public MemberVO loginSelectByUserid(String userid)
	
	// *** 아이디로 회원정보 조회 *** //
	// 회원정보 조회
	@Override
	public MemberVO selectMemberByIdx(int idx) {
		MemberVO mvo = sqlsession.selectOne("member.selectMemberByIdx", idx);
		
		return mvo;
	} // end of public MemberVO selectMemberByUserid(String userid)

	// 저장된 사용자 태그 조회
	@Override
	public List<HashMap<String, String>> selectHave_tagByIdx(int idx) {
		List<HashMap<String, String>> haveTagList = sqlsession.selectList("member.selectHave_tagByIdx", idx);
		
		return haveTagList;
	} // end of public List<HashMap<String, String>> selectHave_tagByIdx(int idx)

	// *** 회원수정 *** //
	// member 테이블의 정보수정
	@Override
	public int updateMemberByMvo(MemberVO mvo) {
		int result = sqlsession.update("member.updateMemberByMvo", mvo);
		
		return result;
	} // end of public int updateMemberByMvo(MemberVO mvo)

	// login_log 테이블의 정보수정
	@Override
	public int updateLogin_logByMvo(MemberVO mvo) {
		int result = sqlsession.update("member.updateLogin_logByMvo", mvo);
		
		return result;
	} // end of public int updateLogin_logByMvo(MemberVO mvo)

	// 해당 사용자의 태그 모두 지우기
	@Override
	public int deleteHave_tagByIdx(int idx) {
		int result = sqlsession.delete("member.deleteHave_tagByIdx", idx);
		return result;
	} // end of public int deleteHave_tagByIdx(int idx)

	// 파일 수정이 없는 회원 정보 수정 
	// member 테이블의 정보수정(프로필 사진 변경 X)
	@Override
	public int updateMemberByMvoNoProfile(MemberVO mvo) {
		int result = sqlsession.update("member.updateMemberByMvoNoProfile", mvo);
		
		return result;
	} // end of public int updateMemberByMvoNoProfile(MemberVO mvo)

	// *** 회원 탈퇴 *** //
	@Override
	public int updateMemberStatusOutByIdx(int idx) {
		int result = sqlsession.update("member.updateMemberStatusOutByIdx", idx);
		
		return result;
	} // end of public int updateMemberStatusOutByIdx(int idx)

	
	// *** 관리자 *** //
	// *** 회원목록 ***//
	// 해당하는 총회원 수
	// 검색 X
	@Override
	public int selectTotalCount() {
		int totalCount = sqlsession.selectOne("member.selectTotalCount");
		
		return totalCount;
	} // end of public int selectTotalCount()

	// 검색 O
	@Override
	public int selectTotalCountBySearch(HashMap<String, Object> paraMap) {
		int totalCount = sqlsession.selectOne("member.selectTotalCountBySearch", paraMap);
		
		return totalCount;
	} // end of public int selectTotalCountBySearch(HashMap<String, Object> paraMap)

	// memberList 조회
	// 검색 X 정렬 X
	@Override
	public List<MemberVO> selectMemberList(HashMap<String, Object> paraMap) {
		sqlsession.selectList("member.selectMemberList", paraMap);
		
		List<MemberVO> memberList = (List<MemberVO>)paraMap.get("MEMBERLIST");
		
		return memberList;
	} // end of public List<MemberVO> selectMemberList()

	/* === 2019.01.24 ==== 관리자 회원 리스트 코딩 */
	// 검색 X 정렬 O
	@Override
	public List<MemberVO> selectMemberListByOrderBy(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = sqlsession.selectList("member.selectMemberListByOrderBy", paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberListByOrderBy(HashMap<String, Object> paraMap)

	// 검색 O 정렬 X
	@Override
	public List<MemberVO> selectMemberListBySearch(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = sqlsession.selectList("member.selectMemberListBySearch", paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberListBySearch(HashMap<String, Object> paraMap)

	// 검색 O 정렬 O
	@Override
	public List<MemberVO> selectMemberListBySearchOrderBy(HashMap<String, Object> paraMap) {
		List<MemberVO> memberList = sqlsession.selectList("member.selectMemberListBySearchOrderBy", paraMap);
		
		return memberList;
	} // end of public List<MemberVO> selectMemberListBySearchOrderBy(HashMap<String, Object> paraMap)
	/* === 2019.01.24 ==== 관리자 회원 리스트 코딩 */
	
	// *** 회원 휴면 해제 *** //
	@Override
	public int updateAdminMemberDateByIdx(int idx) {
		int result = sqlsession.update("member.updateAdminMemberDateByIdx", idx);
		
		return result;
	} // end of public int updateAdminMemberDateByIdx(int idx)

	// *** 회원 복원 *** //
	@Override
	public int updateMemberStatusInByIdx(int idx) {
		int result = sqlsession.update("member.updateMemberStatusInByIdx", idx);
		
		return result;
	} // end of public int updateMemberStatusInByIdx(int idx)
	
	// *** 비밀번호 찾기 *** //
	// === 2019.01.24 === 비밀번호 찾기 시작 //
	// 아이디와 이메일로 회원이 있는지 찾기
	@Override
	public int selectMemberIsByUseridEmail(HashMap<String, String> paramap) {
		int cnt = sqlsession.selectOne("member.selectMemberIsByUseridEmail", paramap);
		
		return cnt;
	} // end of public int selectMemberIsByUseridEmail(HashMap<String, String> paramap)
	// === 2019.01.24 === 비밀번호 찾기 //

	// === 2019.01.25 === 비밀번호 변경 //
	// *** 비밀번호 변경 *** //
	// member 테이블 비밀번호 변경
	@Override
	public int updateMemberPwdByUserid(HashMap<String, String> paramap) {
		int result = sqlsession.update("member.updateMemberPwdByUserid", paramap);
		
		return result;
	} // end of public int updateMemberPwdByUserid(HashMap<String, String> paramap)
	
	// login_log 테이블 비밀번호 변경
	@Override
	public int updateLogin_logPwdByUserid(HashMap<String, String> paramap) {
		int result = sqlsession.update("member.updateLogin_logPwdByUserid", paramap);
		
		return result;
	} // end of public int updateLogin_logPwdByUserid(HashMap<String, String> paramap)
	// === 2019.01.25 === 비밀번호 변경 //

	// === 2019.02.13 === //
	// 아이디 찾기 
	@Override
	public String selectMemberIdByNamePhone(HashMap<String, String> paraMap) {
		String findId = sqlsession.selectOne("member.selectMemberIdByNamePhone", paraMap);
		
		return findId;
	} // end of public String selectMemberIdByNamePhone(HashMap<String, String> paraMap)
	// === 2019.02.13 === //
}
