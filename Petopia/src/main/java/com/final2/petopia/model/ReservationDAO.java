package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReservationDAO implements InterReservationDAO {
	

//	===== #DI(의존객체) 주입하기
	@Autowired
	private SqlSessionTemplate sqlsession;	
	
	String ns ="reservation.";
//	#병원에 등록되어있는 예약스케줄 목록 가져오기(2주)
	@Override
	public List<ScheduleVO> selectScheduleListByIdx_biz(String idx_biz) {
		List<ScheduleVO> scheduleList = sqlsession.selectList(ns+"selectScheduleListByIdx_biz", idx_biz);
		return scheduleList;
	}

//	#병원 회원 정보 가져오기
	@Override
	public Biz_MemberVO selectBizMemberVOByIdx_biz(String idx_biz) {
		Biz_MemberVO bizmvo = sqlsession.selectOne(ns+"selectBizMemberVOByIdx_biz", idx_biz);
		return bizmvo;
	}
	
//	[190119]-------------------------------------------------------------------------------
//	#로그인 회원 idx로 펫 리스트 select하기
	@Override
	public List<PetVO> selectPetListByIdx(int idx) {
		List<PetVO> petList = sqlsession.selectList(ns+"selectPetListByIdx", idx);
		return petList;
	}
	
//	#반려동물 드롭박스에서 선택시 1마리 동물정보 가져오기
	@Override
	public PetVO selectPetOneByPet_UID(String pet_UID) {
		PetVO petvo = sqlsession.selectOne(ns+"selectPetOneByPet_UID", pet_UID);
		return petvo;
	}
//	[190120]
//	#예약VO로 예약테이블에 insert하기; 결제X
	@Override
	public int insertReservationByRvo(ReservationVO rvo) {
		int result = sqlsession.insert(ns+"insertReservationByRvo", rvo);
		return result;
	}

//	#예약일정 인서트 성공시 스케줄테이블의 스케줄 상태 변경 트랜잭션 처리
//	[190128] 파라미터 타입 String -> HashMap으로 변경
	@Override
	public int updateScheduleStatusBySUID(HashMap<String, String> paraMap) {
		int result = sqlsession.update(ns+"updateScheduleStatusBySUID", paraMap);
		return result;
	}
	
//	#예약테이블 시퀀스 채번
	@Override
	public String selectReservation_Seq() {
		String seq = sqlsession.selectOne(ns+"selectReservation_Seq");
		return seq;
	}
	
//	#예약VO로 예약테이블에 insert하기; 결제O
	@Override
	public int insertReservationSurgeryByRvo(ReservationVO rvo) {
		int result = sqlsession.insert(ns+"insertReservationSurgeryByRvo", rvo);
		return result;
	}
//	#회원번호로 예치금 잔액 가져오기
	@Override
	public int selectSumDepositByIdx(String idx) {
		int depositAmount = sqlsession.selectOne(ns+"selectSumDepositByIdx", idx);
		return depositAmount;
	}
//	#회원번호로 포인트 가져오기
	@Override
	public int selectPointByIdx(String idx) {
		int point = sqlsession.selectOne(ns+"selectPointByIdx", idx);
		return point;
	}	
//	#예약번호로 예약VO 가져오기
	@Override
	public HashMap<String, String> selectUserReservationOneByFkRUID(String fk_reservation_UID) {
		HashMap<String, String> returnMap = sqlsession.selectOne(ns+"selectUserReservationOneByFkRUID", fk_reservation_UID);
		return returnMap;
	}
	
// [190124]	
//	#결제테이블 시퀀스 채번
	@Override
	public int selectPayment_Seq() {
		int seq = sqlsession.selectOne(ns+"selectPayment_Seq");
		return seq;
	}
	
//	#결제시 사용 포인트를 감하고 실결제금액의 10% point 적립하기
	@Override
	public int updatePointMember(HashMap<String, Integer> paraMap) {
		int result = sqlsession.update(ns+"updatePointMember", paraMap);
		return result;
	}
// ----------------------------------------------
	
//	#수술예약 시 예치금결제 후 결제테이블에 insert
	@Override
	public int insertPaymentByPvo(PaymentVO pvo) {
		int result = sqlsession.update(ns+"insertPaymentByPvo", pvo);
		return result;
	}
//	#예치금 잔액에서 결제금액만큼 감한 내용을 예치금 테이블에 insert
	@Override
	public int insertDepositMinus(HashMap<String, Integer> paraMap) {
		int result = sqlsession.update(ns+"insertDepositMinus", paraMap);
		return result;
	}
//	#예치금결제 완료시 예약테이블의 예약상태 변경 트랜잭션 처리
	@Override
	public int updateReservationStatusByFkRUID(String fk_reservation_UID) {
		int result = sqlsession.update(ns+"updateReservationStatusByFkRUID", fk_reservation_UID);
		return result;
	}

	
	
	
//	#검색타입/검색어가 없는 예약 목록 개수 가져오기
	@Override
	public int getTotalCountNoSearch(int idx) {
		int totalCount = sqlsession.selectOne(ns+"getTotalCountNoSearch", idx);
		return totalCount;
	}

//	#검색타입/검색어가 있는 예약목록 가져오기
	@Override
	public List<HashMap<String, String>> selectUserReservationList(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reservationList = sqlsession.selectList(ns+"selectUserReservationList",paraMap);
		return reservationList;
	}

//	[190125] 예치금 히스토리 목록 중 모두보기인 경우
//	[190126] 메소드명 변경 selectDepositListByIdx -> selectDepositListByIdxNoneType
	@Override
	public List<DepositVO> selectDepositListByIdxNoneType(HashMap<String, Object> paraMap) {
		List<DepositVO> depositList = sqlsession.selectList(ns+"selectDepositListByIdxNoneType",paraMap);
		return depositList;
	}
//	[190126] 예치금 히스토리 목록 중 충전 또는 사용 목록인 경우 
	@Override
	public List<DepositVO> selectDepositListByIdx(HashMap<String, Object> paraMap) {
		List<DepositVO> depositList = sqlsession.selectList(ns+"selectDepositListByIdx",paraMap);
		return depositList;
	}
//	#전체목록의 페이지바 만들기
	@Override
	public int selectDepositListTotalCountNoneType(HashMap<String, Object> paraMap) {
		int totalCount = sqlsession.selectOne(ns+"selectDepositListTotalCountNoneType", paraMap);
		return totalCount;
	}
//	#충전 또는 사용목록 페이지바 만들기
	@Override
	public int selectDepositListTotalCount(HashMap<String, Object> paraMap) {
		int totalCount = sqlsession.selectOne(ns+"selectDepositListTotalCount", paraMap);
		return totalCount;
	}
//	#최초 스케줄 생성 프로시저
	@Override
	public void insertScheduleFirst(String idx_biz) {
		sqlsession.insert(ns+"insertScheduleFirst", idx_biz);
		
	}
//	#병원회원의 스케줄 개수 가져오기
	@Override
	public int selectScheduleCountByIdx_biz(String idx_biz) {
		int scheduleCount = sqlsession.selectOne(ns+"selectScheduleCountByIdx_biz", idx_biz);
		return scheduleCount;
	}
//	[190128]
//	#캘린더에서 이벤트 클릭 시 예약 정보 가져오기
	@Override
	public HashMap<String, String> selectScheduleOneByScheduleUID(String schedule_UID) {
		HashMap<String, String> returnMap = sqlsession.selectOne(ns+"selectScheduleOneByScheduleUID", schedule_UID);
		return returnMap;
	}
//	#예약 테이블에서 해당 날짜와 일치하는 예약건이 있는지 확인하기(기업회원)
	public int selectReservationByDate(HashMap<String, String> paraMap) {
		int result = sqlsession.selectOne(ns+"selectReservationByDate", paraMap);
		return result;
	}
//	#스케줄 테이블에서 날짜에 맞는 스케줄 UID 가져오기
	public String selectScheduleOneByDate(HashMap<String, String> paraMap) {
		String schedule_UID = sqlsession.selectOne(ns+"selectScheduleOneByDate", paraMap);
		return schedule_UID;
	}
//	#기업회원 예약 일정 수정하기
	@Override
	public int updateReservationStatusTo4(HashMap<String, String> paraMap) {
		int result = sqlsession.update(ns+"updateReservationStatusTo4", paraMap);
		return result;
	}
//	#예약타입이 수술인 경우 payment 테이블의 예약UID 변경
	@Override
	public int updatePaymentReservationUID(HashMap<String, String> paraMap) {
		int result = sqlsession.update(ns+"updatePaymentReservationUID", paraMap);
		return result;
	}
//	#스케줄 테이블 시퀀스 채번하기
	@Override
	public String selectScheduleSeq() {
		String seq = sqlsession.selectOne(ns+"selectScheduleSeq");
		return seq;
	}
//	#기업회원 스케줄 1개 인서트하기
	@Override
	public int insertBizScheduleOne(ScheduleVO svo) {
		int result = sqlsession.insert(ns+"insertBizScheduleOne", svo);
		return result;
	}
	
//	[190129]
//	#기업회원; 예약 일정 취소하기 - 수술상담 및 결제완료의 경우
//	1) payment테이블에서 실제 결제한 포인트와 예치금금액 select
	@Override
	public PaymentVO selectPayPointAndPayCoin(String reservation_UID) {
		PaymentVO pvo = sqlsession.selectOne(ns+"selectPayPointAndPayCoin", reservation_UID);
		return pvo;
	}
//	2) payment 테이블의 status 2(취소)로 변경
	@Override
	public int updatePaymentStatusTo3ByFK_rvUID(String reservation_UID) {
		int result = sqlsession.update(ns+"updatePaymentStatusTo3ByFK_rvUID", reservation_UID);
		return result;
	}
//	3) deposit 테이블에 취소한 값 insert
	@Override
	public int insertDepositPlus(HashMap<String, String> paraMap) {
		int result = sqlsession.insert(ns+"insertDepositPlus", paraMap);
		return result;
	}
//	4) 일정변경된 내용 알람보내기
	@Override
	public int insertNoteForReservation(HashMap<String, String> noteMap) {
		int result = sqlsession.insert(ns+"insertNoteForReservation", noteMap);
		return result;
	}
	
//	[190130]
//	#예약 상세 페이지
//	[190131] 일반회원, 기업회원이 보는 예약상세 요소 분리
	@Override
	public HashMap<String, String> selectRvDetailByPUIDForMember(String payment_UID){
		HashMap<String, String> resultMap = sqlsession.selectOne(ns+"selectRvDetailByPUIDForMember", payment_UID);
		return resultMap;
	}
	@Override
	public HashMap<String, String> selectRvDetailForBiz(HashMap<String, String> paraMap){
		HashMap<String, String> resultMap = sqlsession.selectOne(ns+"selectRvDetailForBiz", paraMap);
		return resultMap;
	}
	
//	#예약VO로 예약테이블에 insert하기; 결제O
	@Override
	public int insertReservationSurgeryByRvo2(ReservationVO rvo) {
		sqlsession.insert(ns+"insertReservationSurgeryByRvo2", rvo);
		return Integer.parseInt(rvo.getReservation_UID());
	}

//	[190203]
	@Override
	public int selectPaymentTotalCountWithSearch(HashMap<String, String> paraMap) {
		int totalCount = sqlsession.selectOne(ns+"selectPaymentTotalCountWithSearch", paraMap);
		return totalCount;
	}

	@Override
	public int selectPaymentTotalCountNoSearch() {
		int totalCount = sqlsession.selectOne(ns+"selectPaymentTotalCountNoSearch");
		return totalCount;
	}

//	#관리자 예약결제목록 가져오기
	@Override
	public List<HashMap<String, String>> selectPaymentRvListForAdmin(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> paymentRvList = sqlsession.selectList(ns+"selectPaymentRvListForAdmin", paraMap);
		return paymentRvList;
	}

//	[190204]
	@Override
	public List<HashMap<String, String>> selectAdminPaymentRvListAll() {
		List<HashMap<String, String>> returnList = sqlsession.selectList(ns+"selectAdminPaymentRvListAll");
		return returnList;
	}

	@Override
	public List<HashMap<String, String>> selectInfiniteScrollDownPaymentRvList(int rnoToStart) {
		List<HashMap<String, String>> returnList = sqlsession.selectList(ns+"selectInfiniteScrollDownPaymentRvList", rnoToStart);
		return returnList;
	}
	
//	[190207]
//	#관리자 예약결제관리 목록에서 진료기록을 입력한 기업회원에게 예치금 정산하기 
	@Override
	public ChartVO selectChartVOByFk_RUID(String fk_reservation_UID) {
		ChartVO cvo = sqlsession.selectOne(ns+"selectChartVOByFk_RUID", fk_reservation_UID);
		return cvo;
	}

	@Override
	public int updatePaymentStatusTo0(HashMap<String, String> paraMap) {
		int result = sqlsession.update(ns+"updatePaymentStatusTo0", paraMap);
		return result;
	}

//	[190211]
//	#무통장입금 계좌 정보 조회하기
	@Override
	public HashMap<String, String> selectDepositDirectAccount(String deposit_UID) {
		HashMap<String, String> returnMap = sqlsession.selectOne(ns+"selectDepositDirectAccount", deposit_UID);
		return returnMap;
	}

//	#관리자 예치금 히스토리 목록 중 모두보기인 경우
	@Override
	public List<DepositVO> selectDepositListByIdxNoneTypeForAdmin(HashMap<String, Object> paraMap) {
		List<DepositVO> depositList = sqlsession.selectList(ns+"selectDepositListByIdxNoneTypeForAdmin",paraMap);
		return depositList;
	}
//	#관리자 예치금 히스토리 목록 중 충전 또는 사용 목록인 경우 
	@Override
	public List<DepositVO> selectDepositListByIdxForAdmin(HashMap<String, Object> paraMap) {
		List<DepositVO> depositList = sqlsession.selectList(ns+"selectDepositListByIdxForAdmin",paraMap);
		return depositList;
	}
//	#관리자 전체목록의 페이지바 만들기
	@Override
	public int selectDepositListTotalCountNoneTypeForAdmin(HashMap<String, Object> paraMap) {
		int totalCount = sqlsession.selectOne(ns+"selectDepositListTotalCountNoneTypeForAdmin", paraMap);
		return totalCount;
	}
//	#관리자 충전 또는 사용목록 페이지바 만들기
	@Override
	public int selectDepositListTotalCountForAdmin(HashMap<String, Object> paraMap) {
		int totalCount = sqlsession.selectOne(ns+"selectDepositListTotalCountForAdmin", paraMap);
		return totalCount;
	}

	@Override
	public int updateDepositStatusByDUID(String deposit_UID) {
		int result = sqlsession.update(ns+"updateDepositStatusByDUID", deposit_UID);
		return result;
	}
}
