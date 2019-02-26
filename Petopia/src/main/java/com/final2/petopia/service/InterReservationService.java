package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.model.DepositVO;
import com.final2.petopia.model.PaymentVO;
import com.final2.petopia.model.PetVO;
import com.final2.petopia.model.ReservationVO;
import com.final2.petopia.model.ScheduleVO;

public interface InterReservationService {

//	#병원에 등록되어있는 예약스케줄 목록 가져오기(2주)
	List<ScheduleVO> selectScheduleListByIdx_biz(String idx_biz);

//	#예약 페이지 갈 때 병원정보 조회하기
	Biz_MemberVO selectBizMemberVOByIdx_biz(String idx_biz);

//	[190119]
//	#로그인된 회원 idx를 받아와 펫 리스트 select하기
	List<PetVO> selectPetListByIdx(int idx);

//	#반려동물 드롭박스에서 선택시 1마리 동물정보 가져오기
	PetVO selectPetOneByPet_UID(String pet_UID);

//	[190120]
//	#예약VO로 예약테이블에 insert하기; 결제X
	int insertReservationByRvo(ReservationVO rvo) throws Throwable;
	
//	#예약VO로 예약테이블에 insert하기; 결제O
	HashMap<String, String> insertReservationSurgeryByRvo(ReservationVO rvo) throws Throwable;

//	#회원번호로 예치금잔액 가져오기
	int selectSumDepositByIdx(String idx);
//	#회원번호로 포인트 가져오기
	int selectPointByIdx(String idx);
//	#예약번호로 예약VO 가져오기
	HashMap<String, String> selectUserReservationOneByFkRUID(String fk_reservation_UID);
	
//	#예치금 결제 완료; 트랜잭션
	int goPayReservationDeposit(PaymentVO pvo);
	
	
//	#예약목록
	int getTotalCountNoSearch(int idx);
	List<HashMap<String, String>> selectUserReservationList(HashMap<String, String> paraMap);

	
//	[190126] 예치금 히스토리 목록
	List<DepositVO> selectDepositListByIdx(HashMap<String, Object> paraMap);
//	[190126] 예치금 히스토리 목록 페이지바 만들기
	int selectDepositListTotalCount(HashMap<String, Object> paraMap);
//	#최초 스케줄 생성 프로시저
	void insertScheduleFirst(String idx_biz);
//	#병원회원의 스케줄 개수 가져오기
	int selectScheduleCountByIdx_biz(String idx_biz);
//	[190128]
//	#캘린더에서 이벤트 클릭 시 예약 정보 가져오기
	HashMap<String, String> selectScheduleOneByScheduleUID(String schedule_UID);
//	#기업회원 예약 일정 수정하기
	int updateReservationSchedule(HashMap<String, String> paraMap, ReservationVO rvo);
	
//	[190129]
//	#기업회원; 예약 일정 취소하기 - 수술상담 및 결제완료의 경우
	int updateRvAndScdStatusCancleForSurgery(HashMap<String, String> paraMap);
//	#기업회원; 예약 일정 취소하기 - 미결제 및 수술상담제외 타입의 경우
	int updateRvAndScdStatusCancle(HashMap<String, String> paraMap);

//	[190130]
//	#예약 상세 페이지
	HashMap<String, String> selectRvDetailByPUID(String payment_UID, String membertype, String idx);	// [190131] membertype 추가 190211 idx 추가

//	[190203]
	int selectPaymentTotalCountWithSearch(HashMap<String, String> paraMap);

	int selectPaymentTotalCountNoSearch();

	List<HashMap<String, String>> selectPaymentRvListForAdmin(HashMap<String, String> paraMap);

//	[190204]
	List<HashMap<String, String>> selectAdminPaymentRvListAll();

	List<HashMap<String, String>> selectInfiniteScrollDownPaymentRvList(int rnoToStart);

//	[190207]
//	#관리자 예약결제관리 목록에서 진료기록을 입력한 기업회원에게 예치금 정산하기 
	HashMap<String, String> insertDepositToBiz(HashMap<String, String> paraMap);

//	[190208]
//	#결제시 deposit테이블에 정보 insert
	int insertDeposit(HashMap<String, String> paraMap);

//	[190211]
//	#deposit테이블에서 무통장입금 계좌 정보 가져오기
	HashMap<String, String> selectDepositDirectAccount(String deposit_UID);

	List<DepositVO> selectDepositListByIdxForAdmin(HashMap<String, Object> paraMap);

	int selectDepositListTotalCountForAdmin(HashMap<String, Object> paraMap);

	int updateDepositStatusByDUID(String deposit_UID);

	int sendSms(HashMap<String, String> paraMap) throws Exception;

}
