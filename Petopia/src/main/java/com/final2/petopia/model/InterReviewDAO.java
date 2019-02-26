package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

public interface InterReviewDAO {

	// === 2019.01.28 ==== //
	// *** 리뷰 쓸 병원 리스트 조회 *** //
	int selectTotalCount(HashMap<String, Integer> paramap); // 병원 리스트 카운트 - 기간이 없는
	int selectTotalCountByPeriod(HashMap<String, Integer> paramap); // 병원 리스트 카운트 - 기간이 있는
	
	List<HashMap<String, String>> selectHosList(HashMap<String, Integer> paramap); // 병원 리스트 - 기간이 없는
	List<HashMap<String, String>> selectHosListByPeriod(HashMap<String, Integer> paramap);// 병원 리스트 - 기간이 있는
	// === 2019.01.28 ==== //

	// === 2019.01.29 ==== //
	// *** 리뷰 쓰기 *** //
	String selectBizIdxByReservationUID(String reservationUID); // 리뷰를 쓸 기업 번호 알아오기
	int insertReviewByReviewMap(HashMap<String, String> reviewMap); // review 테이블에 insert
	// === 2019.01.29 ==== //
	
	// === 2019.01.30 ==== //
	// *** 예약코드로 리뷰 보기 *** //
	HashMap<String, String> selectMyReviewByReservationUID(int fk_reservation_UID);
	
	// *** 리뷰번호로 리뷰 수정하기 *** //
	int updateReviewByReviewUID(HashMap<String, String> paraMap);
	
	// *** 리뷰번호로 리뷰 삭제하기 *** //
	int updateReviewStatusByReviewUID(int review_UID);
	// === 2019.01.30 ==== //
	
	// *** 전체 리뷰 갯수 *** //
	// === 2019.02.01 === //
	int selectAllTotalCount(HashMap<String, String> paraMap); // 기간X검색X
	int selectAllTotalCountBySearch(HashMap<String, String> paraMap); // 기간X검색O
	int selectAllTotalCountByPeriod(HashMap<String, String> paraMap); // 기간O검색X
	int selectAllTotalCountByPeriodSearch(HashMap<String, String> paraMap); // 기간O검색O
	// === 2019.02.01 === //
	
	// === 2019.01.31 ==== //
	// *** 전체 리뷰 목록 보기 *** //
	List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap); // 기간X검색X
	// === 2019.01.31 ==== //
	// === 2019.02.01 === //
	List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap); // 기간X검색O
	List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap); // 기간O검색X
	List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap); // 기간O검색O
	// === 2019.02.01 === //
	
	// === 2019.02.03 === //
	// *** 리뷰 디테일 *** //
	HashMap<String, String> selectReviewByReview_UID(int review_UID);
	// === 2019.02.03 === //
	
	// === 2019.02.05 === //
	// *** 댓글 쓰기 *** //
	int insertReviewComments(HashMap<String, String> paraMap); // 댓글 insert
	int insertReviewNotification(HashMap<String, String> paraMap); // 알림 insert
	
	// === 2019.02.14 === //
	HashMap<String, String> selectMemberIdxByUserId(String userid); // 리뷰의 주인의 idx와 status 알아오기
	// === 2019.02.14 === //
	
	// === 2019.02.07 === 시작 //
	// *** 대댓글 쓰기 *** //
	int selectDupilcationByRc_groupRc_idRc_g_odr(HashMap<String, String> paraMap); // FK_RC_ID, RC_GROUP, RC_G_ODR가 같은 값이 있는지 없는지 알아보기
	int updateRc_g_odgUp(HashMap<String, String> paraMap); // 위의 값이 있는 경우, RC_G_ODR의 값이 그 값보다 크거가 같은 값은 RC_G_ODR+1
	int insertReviewCommentsByRc_id(HashMap<String, String> paraMap); // 대댓글 insert
	// === 2019.02.07 === 끝 //
	
	// *** 댓글 목록 *** //
	int selectReviewCommentsTotalCount(HashMap<String, Integer> paraMap); // 댓글 전체 갯수
	List<HashMap<String, String>> selectReviewCommentsListByReviewUID(HashMap<String, Integer> paraMap); // 댓글 전체 리스트
	// === 2019.02.05 === //
	
	// === 2019.02.07 === 시작//
	// *** 댓글 수정하기 *** //
	HashMap<String, String> selectReviewCommentsOne(int rc_id); // 수정할 댓글 정보 가져오기
	int updateReviewCommentsByRc_id(HashMap<String, String> paraMap); // 댓글 수정하기
	
	// *** 댓글 삭제하기 *** //
	int updateReviewCommentsStatusByRc_id(int rc_id);
	
	// *** 병원 관리자 페이지 *** //
	// *** 병원 리뷰 리스트 갯수 *** //
	int selectAllTotalCountByBiz_id(HashMap<String, String> paraMap); // 기간X검색X
	int selectAllTotalCountByBiz_idSearch(HashMap<String, String> paraMap); // 기간X검색O
	int selectAllTotalCountByBiz_idPeriod(HashMap<String, String> paraMap); // 기간O검색X
	int selectAllTotalCountByBiz_idPeriodSearch(HashMap<String, String> paraMap); // 기간O검색O
	
	// *** 병원 리뷰 리스트 *** //
	List<HashMap<String, String>> selectReviewListByBiz_id(HashMap<String, String> paraMap); // 기간X검색X
	List<HashMap<String, String>> selectReviewListByBiz_idSearch(HashMap<String, String> paraMap); // 기간X검색O
	List<HashMap<String, String>> selectReviewListByBiz_idPeriod(HashMap<String, String> paraMap); // 기간O검색X
	List<HashMap<String, String>> selectReviewListByBiz_idPeriodSearch(HashMap<String, String> paraMap); // 기간O검색O
	
	// *** 기업 회원이 블라인드 처리 요청 *** //
	int updateReviewBlindByReview_uid(HashMap<String, Integer> paraMap);
	
	// *** 병원 리뷰 디테일 *** //
	HashMap<String, String> selectReviewByBiz_idReview_UID(HashMap<String, Integer> paraMap);
	// === 2019.02.07 === 끝 //
	
	// === 2019.02.11 === 시작 //
	// *** 댓글 블라인드처리 요청 *** //
	int updateReviewCommentsBlindByRc_id(HashMap<String, Integer> paraMap);
	// === 2019.02.11 === 끝 //
	
	// === 2019.02.08 === 시작 //
	// === 2019.02.08 ==== //
	// *** 총관리자 페이지 *** //
	// *** 모든 리뷰 보기 *** //
	// 전체 갯수 알아오기
	int selectAllTotalCountByAdmin(HashMap<String, String> paraMap); // 기간X검색X
	int selectAllTotalCountByAdminSearch(HashMap<String, String> paraMap); // 기간X검색O
	int selectAllTotalCountByAdminPeriod(HashMap<String, String> paraMap); // 기간O검색X
	int selectAllTotalCountByAdminPeriodSearch(HashMap<String, String> paraMap); // 기간O검색O
	
	// *** 병원 리뷰 리스트 *** //
	List<HashMap<String, String>> selectReviewListByAdmin(HashMap<String, String> paraMap); // 기간X검색X
	List<HashMap<String, String>> selectReviewListByAdminSearch(HashMap<String, String> paraMap); // 기간X검색O
	List<HashMap<String, String>> selectReviewListByAdminPeriod(HashMap<String, String> paraMap); // 기간O검색X
	List<HashMap<String, String>> selectReviewListByAdminPeriodSearch(HashMap<String, String> paraMap); // 기간O검색O
	
	// *** 블라인드 처리 *** //
	int updateReviewBlindStatusByReview_uid(HashMap<String, Integer> paraMap); // 블라인드 처리
	int updateReviewBlindCancleByReview_uid(int review_uid); // 블라인드 처리 취소
	
	// *** 리뷰 디테일 페이지 정보 가져오기 *** //
	HashMap<String, String> selectReviewByAdminReview_UID(int review_UID);
	// === 2019.02.08 === 끝 //
	
	// === 2019.02.11 ==== //
	// *** 리뷰 댓글 블라인드 처리 *** //
	int updateReviewCommentsBlindStatusByRc_id(HashMap<String, Integer> paraMap); // 블라인드 처리
	int updateReviewCommentsBlindCancleByRc_id(int rc_id); // 블라인드 처리 취소
	
	// *** 병원 상세페이지에서 리뷰 별점 평균 불러오기 *** //
	int selectAvgStarPoint(int idx);
	// === 2019.02.11 ==== //
	
	
}