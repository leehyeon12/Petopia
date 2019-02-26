package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.final2.petopia.model.InterReviewDAO;

@Service
public class ReviewService implements InterReviewService {
	
	// === 2019.01.28 ==== //
	@Autowired
	private InterReviewDAO dao;

	// *** 리뷰 쓸 병원 리스트 조회 *** //
	// 병원 리스트 카운트
	@Override
	public int selectTotalCount(HashMap<String, Integer> paramap) {
		int cnt = dao.selectTotalCount(paramap);
		
		return cnt;
	} // end of public int selectTotalCount(HashMap<String, Integer> paramap)

	// 병원 리스트 카운트 - 기간이 없는
	@Override
	public int selectTotalCountByPeriod(HashMap<String, Integer> paramap) {
		int cnt = dao.selectTotalCountByPeriod(paramap);
		
		return cnt;
	} // end of public int selectTotalCountByPeriod(HashMap<String, Integer> paramap)

	// 병원 리스트 - 기간이 없는
	@Override
	public List<HashMap<String, String>> selectHosList(HashMap<String, Integer> paramap) {
		List<HashMap<String, String>> hosList = dao.selectHosList(paramap);
		
		return hosList;
	} // end of public List<HashMap<String, Object>> selectHosList(HashMap<String, Integer> paramap)

	// 병원 리스트 - 기간이 있는
	@Override
	public List<HashMap<String, String>> selectHosListByPeriod(HashMap<String, Integer> paramap) {
		List<HashMap<String, String>> hosList = dao.selectHosListByPeriod(paramap);
		
		return hosList;
	} // end of public List<HashMap<String, Object>> selectHosListByPeriod(HashMap<String, Integer> paramap)
	// === 2019.01.28 ==== //
	
	// === 2019.01.29 ==== //
	// *** 리뷰 쓰기 *** //
	@Override
	public int insertReviewByReviewMap(HashMap<String, String> reviewMap) {
		
		// 리뷰를 쓸 기업 번호 알아오기
		String fk_idx_biz = dao.selectBizIdxByReservationUID(reviewMap.get("FK_RESERVATION_UID"));
		
		reviewMap.put("FK_IDX_BIZ", fk_idx_biz);
		
		// review 테이블에 insert
		int result = dao.insertReviewByReviewMap(reviewMap);
		
		return result;
	} // end of public int insertReviewByReviewMap(HashMap<String, String> reviewMap)
	// === 2019.01.29 ==== //
	
	// === 2019.01.30 ==== //
	// *** 예약코드로 리뷰 보기 *** //
	@Override
	public HashMap<String, String> selectMyReviewByReservationUID(int fk_reservation_UID) {
		HashMap<String, String> reviewMap = dao.selectMyReviewByReservationUID(fk_reservation_UID);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectMyReviewByReservationUID(int fk_reservation_UID)
	
	// *** 리뷰번호로 리뷰 수정하기 *** //
	@Override
	public int updateReviewByReviewUID(HashMap<String, String> paraMap) {
		int result = dao.updateReviewByReviewUID(paraMap);
		
		return result;
	} // end of public int updateReviewByReviewUID(HashMap<String, String> paraMap)

	// *** 리뷰번호로 리뷰 삭제하기 *** //
	@Override
	public int updateReviewStatusByReviewUID(int review_UID) {
		int result = dao.updateReviewStatusByReviewUID(review_UID);
		
		return result;
	} // end of public int updateReviewStatusByReviewUID(String review_UID)
	// === 2019.01.30 ==== //

	// === 2019.02.01 === //
	// *** 전체 리뷰 갯수 *** //
	// 기간X검색X
	@Override
	public int selectAllTotalCount(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCount(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCount(HashMap<String, String> paraMap)
	
	// 기간X검색O
	@Override
	public int selectAllTotalCountBySearch(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountBySearch(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountBySearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public int selectAllTotalCountByPeriod(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByPeriod(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public int selectAllTotalCountByPeriodSearch(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByPeriodSearch(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByPeriodSearch(HashMap<String, String> paraMap)
	
	// === 2019.01.31 ==== //
	// *** 전체 리뷰 목록 보기 *** //
	// 기간X검색X
	@Override
	public List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewList(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap)
	// === 2019.01.31 ==== //

	// === 2019.02.01 === //
	// 기간X검색O
	@Override
	public List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListBySearch(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByPeriod(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByPeriodSearch(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap)
	// === 2019.02.01 === //

	// === 2019.02.03 === //
	// *** 리뷰 디테일 *** //
	@Override
	public HashMap<String, String> selectReviewByReview_UID(int review_UID) {
		HashMap<String, String> reviewMap = dao.selectReviewByReview_UID(review_UID);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectReviewByReview_UID(int review_UID)
	// === 2019.02.03 === //

	// === 2019.02.05 === //
	// *** 댓글 쓰기 *** //
	// 댓글 insert
	@Override
	public int insertReviewComments(HashMap<String, String> paraMap) {
		int result = dao.insertReviewComments(paraMap);
		
		return result;
	} // end of public int insertReviewComments(HashMap<String, String> paraMap)

	// 댓글 insert + 알림 insert
	@Override
	public int insertReviewCommentsNotification(HashMap<String, String> paraMap) {
		// === 2019.02.07 === 수정 //
		int result = 0;
		
		int n1 = dao.insertReviewComments(paraMap);
		
		// === 2019.02.14 === //
		// 리뷰의 주인의 idx와 status 알아오기
		System.out.println("paraMap.get(\"FK_USERID\"): "+paraMap.get("FK_USERID"));
		HashMap<String, String> memberInfo = dao.selectMemberIdxByUserId(paraMap.get("FK_USERID"));
		
		int n2 = 0;
		if(memberInfo.get("MEMBER_STATUS") != null && "1".equals(memberInfo.get("MEMBER_STATUS"))) {
			paraMap.remove("FK_IDX");
			paraMap.put("FK_IDX", memberInfo.get("IDX"));
			
			n2 = dao.insertReviewNotification(paraMap);
		} // end of if
		
		if(memberInfo.get("MEMBER_STATUS") != null && "1".equals(memberInfo.get("MEMBER_STATUS"))) {
			if(n1*n2 == 0) {
				result = 0;
			} else {
				result = 1;
			} // end of if~else
		} else {
			if(n1 == 0) {
				result = 0;
			} else {
				result = 1;
			} // end of if~else
		} // end of if~else
		// === 2019.02.14 === //
		
		// === 2019.02.07 === 수정 //
		return result;
	} // end of public int insertReviewCommentsNotification(HashMap<String, String> paraMap)
	
	// === 2019.02.07 === 시작 //
	// *** 대댓글 쓰기 *** //
	// 대댓글 insert
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertReviewCommentsByRc_id(HashMap<String, String> paraMap) {
		int result = 0;
		
		// 만약 FK_RC_ID=#{FK_RC_ID} and RC_GROUP=#{RC_GROUP} and RC_G_ODR=#{RC_G_ODR} and RC_DEPTH = #{RC_G_ODR} 가 있으면 
		// where RC_G_ODR >= #{RC_G_ODR}인 값들을 모두 RC_G_ODR+1하기!
		int rc_groupCnt = dao.selectDupilcationByRc_groupRc_idRc_g_odr(paraMap);
		
		int n1 = 0;
		if(rc_groupCnt != 0) {
			// 있는는 경우 ==> RC_GROUP+1
			n1 = dao.updateRc_g_odgUp(paraMap);
		}
		
		// 대댓글 insert
		int n2 = dao.insertReviewCommentsByRc_id(paraMap);
		
		if(n1 != 0) {
			if(n1*n2 == 0) {
				result = 0;
			} else {
				result = 1;
			}// end of if~else
		} else if(n1 == 0) {
			if(n2 == 0) {
				result = 0;
			} else {
				result = 1;
			}// end of if~else
		} // end of if~else if
		
		return result;
	} // end of public int insertReviewCommentsByRc_id(HashMap<String, String> paraMap)

	// 대댓글 insert + 알림 insert
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertReviewCommentsNotificationByRc_id(HashMap<String, String> paraMap) {
		int result = 0;
		
		// 만약 FK_RC_ID=#{FK_RC_ID} and RC_GROUP=#{RC_GROUP} and RC_G_ODR=#{RC_G_ODR} and RC_DEPTH = #{RC_G_ODR} 가 있으면 
		// where RC_G_ODR >= #{RC_G_ODR}인 값들을 모두 RC_G_ODR+1하기!
		int rc_groupCnt = dao.selectDupilcationByRc_groupRc_idRc_g_odr(paraMap);
		
		int n1 = 0;
		if(rc_groupCnt != 0) {
			// 있는는 경우 ==> RC_GROUP+1
			n1 = dao.updateRc_g_odgUp(paraMap);
		}
		
		// 대댓글 insert
		int n2 = dao.insertReviewCommentsByRc_id(paraMap);
		
		// 알림 insert
		// === 2019.02.14 === //
		// 리뷰의 주인의 idx와 status 알아오기
		HashMap<String, String> memberInfo = dao.selectMemberIdxByUserId(paraMap.get("FK_USERID"));
		
		int n3 = 0;
		if(memberInfo.get("MEMBER_STATUS") != null && "1".equals(memberInfo.get("MEMBER_STATUS"))) {
			paraMap.remove("FK_IDX");
			paraMap.put("FK_IDX", memberInfo.get("IDX"));
			
			n3 = dao.insertReviewNotification(paraMap);
		} // end of if
		
		if(memberInfo.get("MEMBER_STATUS") != null && "1".equals(memberInfo.get("MEMBER_STATUS"))) {
			if(n1 != 0) {
				if(n1*n2*n3 == 0) {
					result = 0;
				} else {
					result = 1;
				}// end of if~else
			} else if(n1 == 0) {
				if(n2*n3 == 0) {
					result = 0;
				} else {
					result = 1;
				}// end of if~else
			} // end of if~else if
		} else {
			if(n1 != 0) {
				if(n1*n2 == 0) {
					result = 0;
				} else {
					result = 1;
				}// end of if~else
			} else if(n1 == 0) {
				if(n2 == 0) {
					result = 0;
				} else {
					result = 1;
				}// end of if~else
			} // end of if~else if
		} // end of if~else
		// === 2019.02.14 === //
		
		return result;
	} // public int insertReviewCommentsNotificationByRc_id(HashMap<String, String> paraMap)
	// === 2019.02.07 === 끝 //
	
	// *** 댓글 목록 *** //
	// 댓글 전체 갯수
	@Override
	public int selectReviewCommentsTotalCount(HashMap<String, Integer> paraMap) {
		int totalCnt = dao.selectReviewCommentsTotalCount(paraMap);
		
		return totalCnt;
	} // end of public int selectReviewCommentsTotalCount(HashMap<String, Integer> paraMap)

	// 댓글 전체 리스트
	@Override
	public List<HashMap<String, String>> selectReviewCommentsListByReviewUID(HashMap<String, Integer> paraMap) {
		List<HashMap<String, String>> reveiewCommentsList = dao.selectReviewCommentsListByReviewUID(paraMap);
		
		return reveiewCommentsList;
	} // end of public List<HashMap<String, String>> selectReviewCommentsListByReviewUID(HashMap<String, Integer> paraMap)
	// === 2019.02.05 === //
	
	// === 2019.02.07 === 시작 //
	// *** 댓글 수정하기 *** //
	// 수정할 댓글 정보 가져오기
	@Override
	public HashMap<String, String> selectReviewCommentsOne(int rc_id) {
		HashMap<String, String> reviewCommentsMap = dao.selectReviewCommentsOne(rc_id);
		
		return reviewCommentsMap;
	} // end of public HashMap<String, String> selectReviewCommentsOne(int rc_id)

	// 댓글 수정하기
	@Override
	public int updateReviewCommentsByRc_id(HashMap<String, String> paraMap) {
		int result = dao.updateReviewCommentsByRc_id(paraMap);
		
		return result;
	} // end of public int updateReviewCommentsByRc_id(HashMap<String, String> paraMap)

	// *** 댓글 삭제하기 *** //
	@Override
	public int updateReviewCommentsStatusByRc_id(int rc_id) {
		int result = dao.updateReviewCommentsStatusByRc_id(rc_id);
		
		return result;
	} // end of public int updateReviewCommentsStatusByRc_id(int rc_id)
	
	// *** 병원 관리자 페이지 *** //
	// *** 병원 리뷰 리스트 갯수 *** //
	// 기간X검색X
	@Override
	public int selectAllTotalCountByBiz_id(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByBiz_id(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_id(HashMap<String, String> paraMap)
	
	// 기간X검색O
	@Override
	public int selectAllTotalCountByBiz_idSearch(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByBiz_idSearch(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_idSearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public int selectAllTotalCountByBiz_idPeriod(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByBiz_idPeriod(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_idPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public int selectAllTotalCountByBiz_idPeriodSearch(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByBiz_idPeriodSearch(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByBiz_idPeriodSearch(HashMap<String, String> paraMap)
	
	// *** 병원 리뷰 리스트 *** //
	// 기간X검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_id(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByBiz_id(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewList(HashMap<String, String> paraMap)

	// 기간X검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_idSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByBiz_idSearch(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListBySearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_idPeriod(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByBiz_idPeriod(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByBiz_idPeriodSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByBiz_idPeriodSearch(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByPeriodSearch(HashMap<String, String> paraMap)

	// *** 기업 회원이 블라인드 처리 요청 *** //
	@Override
	public int updateReviewBlindByReview_uid(HashMap<String, Integer> paraMap) {
		int result = dao.updateReviewBlindByReview_uid(paraMap);
		
		return result;
	} // end of public int updateReviewBlindByReview_uid(HashMap<String, Integer> paraMap)

	// *** 병원 리뷰 디테일 *** //
	@Override
	public HashMap<String, String> selectReviewByBiz_idReview_UID(HashMap<String, Integer> paraMap) {
		HashMap<String, String> reviewMap = dao.selectReviewByBiz_idReview_UID(paraMap);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectReviewByBiz_idReview_UID(HashMap<String, Integer> paraMap)
	// === 2019.02.07 === 끝 //
	
	// === 2019.02.11 === 시작 //
	// *** 댓글 블라인드처리 요청 *** //
	@Override
	public int updateReviewCommentsBlindByRc_id(HashMap<String, Integer> paraMap) {
		int result = dao.updateReviewCommentsBlindByRc_id(paraMap);
		
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
		int totalCnt = dao.selectAllTotalCountByAdmin(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdmin(HashMap<String, String> paraMap)
	
	// 기간X검색O
	@Override
	public int selectAllTotalCountByAdminSearch(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByAdminSearch(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdminSearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public int selectAllTotalCountByAdminPeriod(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByAdminPeriod(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdminPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public int selectAllTotalCountByAdminPeriodSearch(HashMap<String, String> paraMap) {
		int totalCnt = dao.selectAllTotalCountByAdminPeriodSearch(paraMap);
		
		return totalCnt;
	} // end of public int selectAllTotalCountByAdminPeriodSearch(HashMap<String, String> paraMap)
	
	// *** 병원 리뷰 리스트 *** //
	// 기간X검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByAdmin(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByAdmin(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdmin(HashMap<String, String> paraMap)

	// 기간X검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByAdminSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByAdminSearch(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdminSearch(HashMap<String, String> paraMap)

	// 기간O검색X
	@Override
	public List<HashMap<String, String>> selectReviewListByAdminPeriod(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByAdminPeriod(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdminPeriod(HashMap<String, String> paraMap)

	// 기간O검색O
	@Override
	public List<HashMap<String, String>> selectReviewListByAdminPeriodSearch(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reviewList = dao.selectReviewListByAdminPeriodSearch(paraMap);
		
		return reviewList;
	} // end of public List<HashMap<String, String>> selectReviewListByAdminPeriodSearch(HashMap<String, String> paraMap)

	// *** 블라인드 처리 *** //
	// 블라인드 처리
	@Override
	public int updateReviewBlindStatusByReview_uid(HashMap<String, Integer> paraMap) {
		int result = dao.updateReviewBlindStatusByReview_uid(paraMap);
		
		return result;
	} // end of public int updateReviewBlindStatusByReview_uid(HashMap<String, Integer> paraMap)

	// 블라인드 처리 취소
	@Override
	public int updateReviewBlindCancleByReview_uid(int review_uid) {
		int result = dao.updateReviewBlindCancleByReview_uid(review_uid);
		
		return result;
	} // end of public int updateReviewBlindCancleByReview_uid(int review_uid)

	// *** 리뷰 디테일 페이지 정보 가져오기 *** //
	@Override
	public HashMap<String, String> selectReviewByAdminReview_UID(int review_UID) {
		HashMap<String, String> reviewMap = dao.selectReviewByAdminReview_UID(review_UID);
		
		return reviewMap;
	} // end of public HashMap<String, String> selectReviewByAdminReview_UID(int review_UID)
	// === 2019.02.08 === 끝 //

	// === 2019.02.11 ==== //
	// *** 리뷰 댓글 블라인드 처리 *** //
	// 블라인드 처리
	@Override
	public int updateReviewCommentsBlindStatusByRc_id(HashMap<String, Integer> paraMap) {
		int result = dao.updateReviewCommentsBlindStatusByRc_id(paraMap);
		
		return result;
	} // end of public int updateReviewCommentsBlindStatusByRc_id(HashMap<String, Integer> paraMap)

	// 블라인드 처리 취소
	@Override
	public int updateReviewCommentsBlindCancleByRc_id(int rc_id) {
		int result = dao.updateReviewCommentsBlindCancleByRc_id(rc_id);
		
		return result;
	} // end of public int updateReviewCommentsBlindCancleByRc_id(int rc_id)
	
	// *** 병원 상세페이지에서 리뷰 별점 평균 불러오기 *** //
	@Override
	public int selectAvgStarPoint(int idx) {
		int result = dao.selectAvgStarPoint(idx);
		
		return result;
	} // end of public int selectAvgStarPoint(int idx)
	
	// === 2019.02.11 ==== //

}
