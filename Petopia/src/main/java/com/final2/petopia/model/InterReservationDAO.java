package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

public interface InterReservationDAO {

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
	int insertReservationByRvo(ReservationVO rvo);
	
//	#예약일정 인서트 성공시 스케줄테이블의 스케줄 상태 변경 트랜잭션 처리
	int updateScheduleStatusBySUID(HashMap<String, String> paraMap);
	
//	#예약테이블 시퀀스 채번
	String selectReservation_Seq();
	
//	#예약VO로 예약테이블에 insert하기; 결제O
	int insertReservationSurgeryByRvo(ReservationVO rvo);
	
//	#회원번호로 예치금잔액 가져오기
	int selectSumDepositByIdx(String idx);	
//	#회원번호로 포인트 가져오기
	int selectPointByIdx(String idx);
//	#예약번호로 예약 내역 가져오기
	HashMap<String, String> selectUserReservationOneByFkRUID(String fk_reservation_UID);

// [190124]	
//	#결제테이블 시퀀스 채번
	int selectPayment_Seq();
//	#결제시 사용 포인트를 감하고 실결제금액의 10% point 적립하기
	int updatePointMember(HashMap<String, Integer> paraMap);
// ----------------------------------------------
//	#수술예약 시 예치금결제 후 결제테이블에 insert
	int insertPaymentByPvo(PaymentVO pvo);
//	#예치금 잔액에서 결제금액만큼 감한 내용을 예치금 테이블에 insert
	int insertDepositMinus(HashMap<String, Integer> paraMap);	
//	#결제 완료시 예약테이블 상태 변경 트랜잭션 처리 
	int updateReservationStatusByFkRUID(String fk_reservation_UID);


//	#예약목록(페이징처리)
	int getTotalCountNoSearch(int idx);
	List<HashMap<String, String>> selectUserReservationList(HashMap<String, String> paraMap);

//	[190125] 예치금 히스토리 목록 중 모두보기인 경우
//	[190126] 메소드명 변경 selectDepositListByIdx -> selectDepositListByIdxNoneType
	List<DepositVO> selectDepositListByIdxNoneType(HashMap<String, Object> paraMap);
//	[190126] 예치금 히스토리 목록 중 충전 또는 충전 목록인 경우 
	List<DepositVO> selectDepositListByIdx(HashMap<String, Object> paraMap);
//	#전체목록의 페이지바 만들기
	int selectDepositListTotalCountNoneType(HashMap<String, Object> paraMap);
//	#충전 또는 사용목록 페이지바 만들기
	int selectDepositListTotalCount(HashMap<String, Object> paraMap);
//	#최초 스케줄 생성 프로시저
	void insertScheduleFirst(String idx_biz);
//	#병원회원의 스케줄 개수 가져오기
	int selectScheduleCountByIdx_biz(String idx_biz);
//	[190128]
//	#캘린더에서 이벤트 클릭 시 예약 정보 가져오기
	HashMap<String, String> selectScheduleOneByScheduleUID(String schedule_UID);
//	#예약 테이블에서 해당 날짜와 일치하는 예약건이 있는지 확인하기(기업회원)
	int selectReservationByDate(HashMap<String, String> paraMap);
//	#스케줄 테이블에서 날짜에 맞는 스케줄 UID 가져오기
	String selectScheduleOneByDate(HashMap<String, String> paraMap);
//	#기업회원 예약건을 취소로 변경
	int updateReservationStatusTo4(HashMap<String, String> paraMap);
//	#예약타입이 수술인 경우 payment 테이블의 예약UID 변경
	int updatePaymentReservationUID(HashMap<String, String> paraMap);
//	#스케줄 테이블 시퀀스 채번하기
	String selectScheduleSeq();
//	#기업회원 스케줄 1개 인서트하기
	int insertBizScheduleOne(ScheduleVO svo);

//	[190129]
//	#기업회원; 예약 일정 취소하기 - 수술상담 및 결제완료의 경우
//	1) payment테이블에서 실제 결제한 포인트와 예치금금액 select
	PaymentVO selectPayPointAndPayCoin(String reservation_UID);
//	2) payment 테이블의 status 3(환불)로 변경
	int updatePaymentStatusTo3ByFK_rvUID(String reservation_UID);
//	3) deposit 테이블에 취소한 값 insert
	int insertDepositPlus(HashMap<String, String> paraMap);
//	4) 일정변경된 내용 알람보내기
	int insertNoteForReservation(HashMap<String, String> noteMap);
	
//	[190130]
//	#예약 상세 페이지
//	[190131] 일반회원, 기업회원이 보는 예약상세 요소 분리
	HashMap<String, String> selectRvDetailByPUIDForMember(String payment_UID);
	HashMap<String, String> selectRvDetailForBiz(HashMap<String, String> paraMap);	// 190211 변경
	
//	[190202]
//	#예약VO로 예약테이블에 insert하기; 결제O
	int insertReservationSurgeryByRvo2(ReservationVO rvo);

//	[190203]
	int selectPaymentTotalCountWithSearch(HashMap<String, String> paraMap);

	int selectPaymentTotalCountNoSearch();

	List<HashMap<String, String>> selectPaymentRvListForAdmin(HashMap<String, String> paraMap);

//	[190204]
	List<HashMap<String, String>> selectAdminPaymentRvListAll();

	List<HashMap<String, String>> selectInfiniteScrollDownPaymentRvList(int rnoToStart);

//	[190207]
//	#관리자 예약결제관리 목록에서 진료기록을 입력한 기업회원에게 예치금 정산하기
//	#예약번호로 차트 VO 객체 가져오기
	ChartVO selectChartVOByFk_RUID(String fk_reservation_UID);

//	#정산 후 payment status를 0으로 변경하기
	int updatePaymentStatusTo0(HashMap<String, String> paraMap);
	
//	[190211]
//	#무통장입금 계좌 정보 조회하기
	HashMap<String, String> selectDepositDirectAccount(String deposit_UID);
//	#관리자 예치금 히스토리 목록 중 모두보기인 경우
	List<DepositVO> selectDepositListByIdxNoneTypeForAdmin(HashMap<String, Object> paraMap);
//	#관리자 예치금 히스토리 목록 중 충전 또는 사용 목록인 경우 
	List<DepositVO> selectDepositListByIdxForAdmin(HashMap<String, Object> paraMap);
//	#관리자 전체목록의 페이지바 만들기
	int selectDepositListTotalCountNoneTypeForAdmin(HashMap<String, Object> paraMap);
//	#관리자 충전 또는 사용목록 페이지바 만들기
	int selectDepositListTotalCountForAdmin(HashMap<String, Object> paraMap);

	int updateDepositStatusByDUID(String deposit_UID);


	

}
