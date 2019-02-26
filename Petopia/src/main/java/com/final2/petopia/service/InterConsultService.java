package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;

import com.final2.petopia.model.ConsultCommentVO;
import com.final2.petopia.model.ConsultVO;

@Service
public interface InterConsultService {

	// 1:1상담 글쓰기 // consult:insert
	int insertConsultByCvo(ConsultVO consultvo);

	// [페이징처리 O, 검색조건 O] 전체글 갯수 totalCount
	int selectTotalCountWithSearch(HashMap<String, String> paraMap);

	// [페이징처리 O, 검색조건 X] 일반회원 : 내가쓴글 갯수 totalCount
	int selectMyConsultCountNoSearch(String idx);
	
	// [페이징처리 O, 검색조건 X] 기업회원 : 내가 댓글 단 글 갯수 totalCount
	int selectBizConsultCountNoSearch(String idx);
	
	// [페이징처리 O, 검색조건 X] 전체글 갯수 totalCount
	int selectTotalCountNoSearch();

	// [페이징처리 O, 검색조건 O] 한 페이지 범위마다 보여지는 글목록 // consult:select
	List<ConsultVO> selectConsultListPaging(HashMap<String, String> paraMap);

	// [조회수 증가 O] 글 상세보기
	ConsultVO selectConsultDetailWithCount(String consult_UID, String userid);

	// [조회수 증가 X] 글 상세보기
	ConsultVO selectConsultDetailNoCount(String consult_UID);

	// [조회수 증가 X] 수정하기 위한 글 가져오기
	ConsultVO selectConsultEditNoCount(String consult_UID);
	// 글상세 수정하기
	int updateConsultDetail(HashMap<String, String> paraMap);

	// [조회수증가 X] 삭제할 글 정보 전체 가져오기
	ConsultVO selectConsultDeleteNoCount(String consult_UID);
	// 글상세 삭제하기
	int deleteConsult(String consult_UID) throws Throwable;

	// 댓글 [consult_comment] ---------------------------------------------------------------------
	
	// [consult_comment]commentvo 댓글쓰기 insert + [consult]commentCount 원글의 댓글갯수 1update + [notification] 댓글작성 알림 insert
	int insertComment(ConsultCommentVO commentvo) throws Throwable;

	// 대댓글 쓰기
	int insertCommentByComment(ConsultCommentVO commentvo) throws Throwable;
		
	// 댓글리스트 select
	List<ConsultCommentVO> selectCommentList(HashMap<String, String> paraMap);

	// 댓글 총 갯수
	int selectCommentTotalCount(HashMap<String, String> paraMap);

	// 관리자 -------------------------------------------------------------------------------------
	
	// [페이징처리 O, 검색조건 O] 전체글 갯수 totalCount
	int selectAdminTotalCountWithSearch(HashMap<String, String> paraMap);

	// [페이징처리 O, 검색조건 X] 전체글 갯수 totalCount
	int selectAdminTotalCountNoSearch();

	// - [페이징처리 O, 검색조건 O] 한 페이지 범위마다 보여지는 글목록 // consult:select
	List<ConsultVO> selectAdminConsultListPaging(HashMap<String, String> paraMap);

	// - 기업회원 idx 목록 member:select
	List<String> selectBizMemberList();

	// - 알림 테이블에 board로 notification:insert
	int insertConsultNotification(String idx);

	

	

	

	

	


	
	

}
