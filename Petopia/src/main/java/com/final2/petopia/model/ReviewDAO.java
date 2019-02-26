package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReviewDAO implements InterReviewDAO {

	// === 2019.01.28 ==== //
	@Autowired
	private SqlSessionTemplate sqlsession;
	
	// *** 리뷰 쓸 병원 리스트 조회 *** //
	// 병원 리스트 카운트 - 기간이 없는
	@Override
	public int selectTotalCount(HashMap<String, Integer> paramap) {
		int cnt = sqlsession.selectOne("review.selectTotalCount", paramap);
		
		return cnt;
	} // end of public int selectTotalCount()

	// 병원 리스트 카운트 - 기간이 있는
	@Override
	public int selectTotalCountByPeriod(HashMap<String, Integer> paramap) {
		int cnt = sqlsession.selectOne("review.selectTotalCountByPeriod", paramap);
		
		return cnt;
	} // end of public int selectTotalCountByPeriod(HashMap<String, Integer> paramap)

	// 병원 리스트 - 기간이 없는
	@Override
	public List<HashMap<String, String>> selectHosList(HashMap<String, Integer> paramap) {
		List<HashMap<String, String>> hosList = sqlsession.selectList("review.selectHosList", paramap);
		
		return hosList;
	} // end of public List<HashMap<String, Object>> selectHosList(HashMap<String, Integer> paramap)

	// 병원 리스트 - 기간이 있는
	@Override
	public List<HashMap<String, String>> selectHosListByPeriod(HashMap<String, Integer> paramap) {
		List<HashMap<String, String>> hosList = sqlsession.selectList("review.selectHosListByPeriod", paramap);

		return hosList;
	} // end of public List<HashMap<String, Object>> selectHosListByPeriod(HashMap<String, Integer> paramap)
	// === 2019.01.28 ==== //
	
	// === 2019.01.29 ==== //
	// *** 리뷰 쓰기 *** //
	// 리뷰를 쓸 기업 번호 알아오기
	@Override
	public String selectBizIdxByReservationUID(String reservationUID) {
		String bizIdx = sqlsession.selectOne("review.selectBizIdxByReservationUID", reservationUID);
		
		return bizIdx;
	} // end of public String selectBizIdxByReservationUID(String string)

	// review 테이블에 insert
	@Override
	public int insertReviewByReviewMap(HashMap<String, String> reviewMap) {
		int result = sqlsession.insert("review.insertReviewByReviewMap", reviewMap);
		
		return result;
	} // end of public int insertReviewByReviewMap(HashMap<String, String> reviewMap)
	// === 2019.01.29 ==== //

	// === 2019.01.30 ==== //
	// *** 예약코드로 리뷰 보기 *** //
	@Override
	public HashMap<String, String> selectMyReviewByReservationUID(int fk_reservation_UID) {
		HashMap<String, String> reviewMap = sqlsession.selectOne("review.selectMyReviewByReservationUID", fk_reservation_UID);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectMyReviewByReservationUID(int fk_reservation_UID)

	// *** 리뷰번호로 리뷰 수정하기 *** //
	@Override
	public int updateReviewByReviewUID(HashMap<String, String> paraMap) {
		int result = sqlsession.update("review.updateReviewByReviewUID", paraMap);
		
		return result;
	} // end of public int updateReviewByReviewUID(HashMap<String, String> paraMap)

	// *** 리뷰번호로 리뷰 삭제하기 *** //
	@Override
	public int updateReviewStatusByReviewUID(int review_UID) {
		int result = sqlsession.update("review.updateReviewStatusByReviewUID", review_UID);
		
		return result;
	} // end of public int updateReviewStatusByReviewUID(int review_UID)
	// === 2019.01.30 ==== //

	// === 2019.02.01 === //
	// *** 전체 리뷰 갯수 *** //
	// 기간X검색X
	@Override
	public int selectAllTotalCount(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCount", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCount(HashMap<String, String> paraMap)

	// 기간X검색o
	@Override
	public int selectAllTotalCountBySearch(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountBySearch", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountBySearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public int selectAllTotalCountByPeriod(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByPeriod", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public int selectAllTotalCountByPeriodSearch(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByPeriodSearch", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByPeriodSearch(HashMap<String, String> paraMap)
	
	// === 2019.01.31 ==== //
	// *** 전체 리뷰 목록 보기 *** //
	// 기간X검색X
	@Override
	public List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewList", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap)
	// === 2019.01.31 ==== //

	// === 2019.02.01 === //
	// 기간X검색O
	@Override
	public List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListBySearch", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByPeriod", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByPeriodSearch", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap)
	// === 2019.02.01 === //
	
	// === 2019.02.03 === //
	// *** 리뷰 디테일 *** //
	@Override
	public HashMap<String, String> selectReviewByReview_UID(int review_UID) {
		HashMap<String, String> reviewMap = sqlsession.selectOne("review.selectReviewByReview_UID", review_UID);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectReviewByReview_UID(int review_UID)
	// === 2019.02.03 === //

	// === 2019.02.05 === //
	// *** 댓글 쓰기 *** //
	// 댓글 insert
	@Override
	public int insertReviewComments(HashMap<String, String> paraMap) {
		int result = sqlsession.insert("review.insertReviewComments", paraMap);
		
		return result;
	} // end of public int insertReviewComments(HashMap<String, String> paraMap)

	// 알림 insert
	@Override
	public int insertReviewNotification(HashMap<String, String> paraMap) {
		int result = sqlsession.insert("review.insertReviewNotification", paraMap);
		
		return result;
	} // end of public int insertReviewNotification(HashMap<String, String> paraMap)
	
	// === 2019.02.14 === //
	// 리뷰의 주인의 idx와 status 알아오기
	@Override
	public HashMap<String, String> selectMemberIdxByUserId(String userid) {
		HashMap<String, String> memberInfo = sqlsession.selectOne("review.selectMemberIdxByUserId", userid);
		
		return memberInfo;
	} // end of public int selectMemberIdxByUserId(String string)
	// === 2019.02.14 === //
	
	// === 2019.02.07 === 시작 //
	// *** 대댓글 쓰기 *** //
	// FK_RC_ID, RC_GROUP, RC_G_ODR가 같은 값이 있는지 없는지 알아보기
	@Override
	public int selectDupilcationByRc_groupRc_idRc_g_odr(HashMap<String, String> paraMap) {
		int rc_groupCnt = sqlsession.selectOne("review.selectDupilcationByRc_groupRc_idRc_g_odr", paraMap);
		
		return rc_groupCnt;
	} // end of public int selectRc_groupCntByRc_groupRc_id(HashMap<String, String> paraMap)
	
	// 위의 값이 있는 경우, RC_G_ODR의 값이 그 값보다 크거가 같은 값은 RC_G_ODR+1
	@Override
	public int updateRc_g_odgUp(HashMap<String, String> paraMap) {
		int result  = 0;
		
		int n = sqlsession.update("review.updateRc_g_odgUp", paraMap);
		
		if(n == 0) {
			result = 0;
		} else {
			result = 1;
		} // end of if~else
		
		return result;
	} // end of public int updateRc_g_odgUp(HashMap<String, String> paraMap)
	
	// 대댓글 insert
	@Override
	public int insertReviewCommentsByRc_id(HashMap<String, String> paraMap) {
		int result = sqlsession.insert("review.insertReviewCommentsByRc_id", paraMap);
		
		return result;
	} // end of public int insertReviewCommentsByRc_id(HashMap<String, String> paraMap)
	// === 2019.02.07 === 끝 //
	
	// *** 댓글 목록 *** //
	// 댓글 전체 갯수
	@Override
	public int selectReviewCommentsTotalCount(HashMap<String, Integer> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectReviewCommentsTotalCount", paraMap);
		
		return totalCnt;
	} // end of public int selectReviewCommentsTotalCount(HashMap<String, Integer> paraMap)

	// 댓글 전체 리스트
	@Override
	public List<HashMap<String, String>> selectReviewCommentsListByReviewUID(HashMap<String, Integer> paraMap) {
		List<HashMap<String, String>> reviewCommentsList = sqlsession.selectList("review.selectReviewCommentsListByReviewUID", paraMap);
		
		return reviewCommentsList;
	} // end of public List<HashMap<String, String>> selectReviewCommentsListByReviewUID(HashMap<String, Integer> paraMap)
	// === 2019.02.05 === //

	// === 2019.02.07 === 시작 //
	// *** 댓글 수정하기 *** //
	// 수정할 댓글 정보 가져오기
	@Override
	public HashMap<String, String> selectReviewCommentsOne(int rc_id) {
		HashMap<String, String> reviewCommentsMap = sqlsession.selectOne("review.selectReviewCommentsOne", rc_id);
		
		return reviewCommentsMap;
	} // end of public HashMap<String, String> selectReviewCommentsOne(int rc_id)

	// 댓글 수정하기
	@Override
	public int updateReviewCommentsByRc_id(HashMap<String, String> paraMap) {
		int result = sqlsession.update("review.updateReviewCommentsByRc_id", paraMap);
		
		return result;
	} // end of public int updateReviewCommentsByRc_id(HashMap<String, String> paraMap)

	// *** 댓글 삭제하기 *** //
	@Override
	public int updateReviewCommentsStatusByRc_id(int rc_id) {
		int result = sqlsession.update("review.updateReviewCommentsStatusByRc_id", rc_id);
		
		return result;
	} // end of public int updateReviewCommentsStatusByRc_id(int rc_id)
	
	// *** 병원 관리자 페이지 *** //
	// *** 병원 리뷰 리스트 갯수 *** //
	// 기간X검색X
	@Override
	public int selectAllTotalCountByBiz_id(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByBiz_id", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_id(HashMap<String, String> paraMap)
	
	// 기간X검색O
	@Override
	public int selectAllTotalCountByBiz_idSearch(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByBiz_idSearch", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_idSearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public int selectAllTotalCountByBiz_idPeriod(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByBiz_idPeriod", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_idPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public int selectAllTotalCountByBiz_idPeriodSearch(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByBiz_idPeriodSearch", paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_idPeriodSearch(HashMap<String, String> paraMap)
	
	// *** 병원 리뷰 목록 *** //
	// 기간X검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_id(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByBiz_id", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap)
	// === 2019.01.31 ==== //

	// === 2019.02.01 === //
	// 기간X검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_idSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByBiz_idSearch", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_idPeriod(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByBiz_idPeriod", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_idPeriodSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByBiz_idPeriodSearch", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap)

	// *** 기업 회원이 블라인드 처리 요청 *** //
	@Override
	public int updateReviewBlindByReview_uid(HashMap<String, Integer> paraMap) {
		int result = sqlsession.update("review.updateReviewBlindByReview_uid", paraMap);
		
		return result;
	} // end of public int updateReviewBlindByReview_uid(int review_uid)

	// *** 병원 리뷰 디테일 *** //
	@Override
	public HashMap<String, String> selectReviewByBiz_idReview_UID(HashMap<String, Integer> paraMap) {
		HashMap<String, String> reviewMap = sqlsession.selectOne("review.selectReviewByBiz_idReview_UID", paraMap);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectReviewByBiz_idReview_UID(HashMap<String, Integer> paraMap)
	// === 2019.02.07 === 끝 //
	
	// === 2019.02.11 === 시작 //
	// *** 댓글 블라인드처리 요청 *** //
	@Override
	public int updateReviewCommentsBlindByRc_id(HashMap<String, Integer> paraMap) {
		int result = sqlsession.update("review.updateReviewCommentsBlindByRc_id", paraMap);
		
		return result;
	} // end of public int updateReviewCommentsBlindByRc_id(HashMap<String, Integer> paraMap)
	// === 2019.02.11 === 끝 //
	
	// === 2019.02.08 === 시작 //
	// *** 총관리자 페이지 *** //
	// *** 모든 리뷰 보기 *** //
	// 전체 갯수 알아오기
	// 기간X검색X
	@Override
	public int selectAllTotalCountByAdmin(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByAdmin",paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdmin(HashMap<String, String> paraMap)
	
	// 기간X검색O
	@Override
	public int selectAllTotalCountByAdminSearch(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByAdminSearch",paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdminSearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public int selectAllTotalCountByAdminPeriod(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByAdminPeriod",paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdminPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public int selectAllTotalCountByAdminPeriodSearch(HashMap<String, String> paraMap) {
		int totalCnt = sqlsession.selectOne("review.selectAllTotalCountByAdminPeriodSearch",paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdminPeriodSearch(HashMap<String, String> paraMap)
	
	// *** 병원 리뷰 리스트 *** //
	// 기간X검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByAdmin(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByAdmin", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdmin(HashMap<String, String> paraMap)

	// 기간X검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByAdminSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByAdminSearch", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdminSearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByAdminPeriod(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByAdminPeriod", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdminPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByAdminPeriodSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = sqlsession.selectList("review.selectReviewListByAdminPeriodSearch", paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdminPeriodSearch(HashMap<String, String> paraMap)
	
	// *** 블라인드 처리 *** //
	@Override
	public int updateReviewBlindStatusByReview_uid(HashMap<String, Integer> paraMap) {
		int result = sqlsession.update("review.updateReviewBlindStatusByReview_uid", paraMap);
		
		return result;
	} // end of public int updateReviewBlindStatusByReview_uid(HashMap<String, Integer> paraMap)

	// 블라인드 처리 취소
	@Override
	public int updateReviewBlindCancleByReview_uid(int review_uid) {
		int result = sqlsession.update("review.updateReviewBlindCancleByReview_uid", review_uid);
		
		return result;
	} // end of public int updateReviewBlindCancleByReview_uid(int review_uid)

	// *** 리뷰 디테일 페이지 정보 가져오기 *** //
	@Override
	public HashMap<String, String> selectReviewByAdminReview_UID(int review_UID) {
		HashMap<String, String> reviewMap = sqlsession.selectOne("review.selectReviewByAdminReview_UID", review_UID);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectReviewByAdminReview_UID(int review_UID)
	// === 2019.02.08 === 끝 //
	
	// === 2019.02.11 ==== //
	// *** 리뷰 댓글 블라인드 처리 *** //
	// 블라인드 처리
	@Override
	public int updateReviewCommentsBlindStatusByRc_id(HashMap<String, Integer> paraMap) {
		int result = sqlsession.update("review.updateReviewCommentsBlindStatusByRc_id", paraMap);
		
		return result;
	} // end of public int updateReviewCommentsBlindStatusByRc_id(HashMap<String, Integer> paraMap)
	
	// 블라인드 처리 취소
	@Override
	public int updateReviewCommentsBlindCancleByRc_id(int rc_id) {
		int result = sqlsession.update("review.updateReviewCommentsBlindCancleByRc_id", rc_id);
		
		return result;
	} // end of public int updateReviewCommentsBlindCancleByRc_id(int rc_id)
	
	// *** 병원 상세페이지에서 리뷰 별점 평균 불러오기 *** //
	@Override
	public int selectAvgStarPoint(int idx) {
		int result = sqlsession.selectOne("review.selectAvgStarPoint", idx);
		
		return result;
	} // end of public int selectAvgStarPoint(int idx)
	// === 2019.02.11 ==== //

}

