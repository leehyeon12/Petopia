package com.final2.petopia.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.tools.ant.util.SymbolicLinkUtils;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.final2.petopia.common.AES256;
import com.final2.petopia.coolsms.Coolsms;
import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.model.ChartVO;
import com.final2.petopia.model.DepositVO;
import com.final2.petopia.model.InterReservationDAO;
import com.final2.petopia.model.PaymentVO;
import com.final2.petopia.model.PetVO;
import com.final2.petopia.model.ReservationVO;
import com.final2.petopia.model.ScheduleVO;

@Service
public class ReservationService implements InterReservationService{

	@Autowired
	private InterReservationDAO dao;
	
	// [190120] AES256 의존객체 삽입
	@Autowired
	private AES256 aes;
	
//	#병원에 등록되어있는 예약스케줄 목록 가져오기(2주)	
	@Override
	public List<ScheduleVO> selectScheduleListByIdx_biz(String idx_biz) {
		List<ScheduleVO> scheduleList = dao.selectScheduleListByIdx_biz(idx_biz);
		return scheduleList;
	}

//	#병원 회원 정보 가져오기
	@Override
	public Biz_MemberVO selectBizMemberVOByIdx_biz(String idx_biz) {
		Biz_MemberVO bizmvo = dao.selectBizMemberVOByIdx_biz(idx_biz);
		try {  // [190120] aes256객체를 이용해 기업회원 연락처 복호화
			bizmvo.setPhone(aes.decrypt(bizmvo.getPhone()));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		return bizmvo;
	}

//	[190119]
//	#로그인 회원 idx로 펫 리스트 select하기
	@Override
	public List<PetVO> selectPetListByIdx(int idx) {
		List<PetVO> petList = dao.selectPetListByIdx(idx);
		return petList;
	}
	
//	#반려동물 드롭박스에서 선택시 1마리 동물정보 가져오기
	@Override
	public PetVO selectPetOneByPet_UID(String pet_UID) {
		PetVO petvo = dao.selectPetOneByPet_UID(pet_UID);
		return petvo;
	}
	
//	[190120]
//	#예약VO로 예약테이블에 insert하기; 결제X; 트랜잭션 처리 -> 예약테이블에 인서트가 성공했을 때 스케줄 테이블 예약상태 변경
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int insertReservationByRvo(ReservationVO rvo) throws Throwable {
		int result = dao.insertReservationByRvo(rvo);
		
		if(result==1) {
			// [190128] 스케줄 스테이터스 변경하기 파라미터 타입 변경
			HashMap<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("fk_schedule_UID", rvo.getFk_schedule_UID());
			paraMap.put("status", "1");
			result = dao.updateScheduleStatusBySUID(paraMap);
		}
		
		return result;
	}
	
//	#예약VO로 예약테이블에 insert하기; 결제O; 트랜잭션 처리 -> 예약테이블에 인서트가 성공했을 때 스케줄 테이블 예약상태 변경
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public HashMap<String, String> insertReservationSurgeryByRvo(ReservationVO rvo) throws Throwable {
		HashMap<String, String> returnMap = new HashMap<String, String>();
		
		String seq = dao.selectReservation_Seq();
		rvo.setReservation_UID(seq);
		
		int result = dao.insertReservationSurgeryByRvo(rvo);
		
		if(result==1) {
			// [190128] 스케줄 스테이터스 변경하기 파라미터 타입 변경
			HashMap<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("fk_schedule_UID", rvo.getFk_schedule_UID());
			paraMap.put("status", "1");
			result = dao.updateScheduleStatusBySUID(paraMap);
		}
		
		returnMap.put("seq", seq);
		returnMap.put("result", String.valueOf(result));
		return returnMap;
	}

//	#회원번호로 예치금잔액 가져오기
	@Override
	public int selectSumDepositByIdx(String idx) {
		int depositAmount = dao.selectSumDepositByIdx(idx);
		return depositAmount;
	}
//	#회원번호로 포인트 가져오기
	@Override
	public int selectPointByIdx(String idx) {
		int point = dao.selectPointByIdx(idx);
		return point;
	}
//	#예약번호로 예약 내역 가져오기
	@Override
	public HashMap<String, String> selectUserReservationOneByFkRUID(String fk_reservation_UID) {
		HashMap<String, String>  returnMap = dao.selectUserReservationOneByFkRUID(fk_reservation_UID);
		try {
			returnMap.put("phone", aes.decrypt(returnMap.get("phone")));			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		return returnMap;
	}
//	#예치금 결제 완료; 트랜잭션: payment테이블 insert -> deposit테이블 마이너스값 insert -> reservation테이블 status update
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int goPayReservationDeposit(PaymentVO pvo) {
		int result = 0;
	// [190124] 결제테이블 시퀀스 채번 메소드 추가
		int seq = dao.selectPayment_Seq();
		pvo.setPayment_UID(String.valueOf(seq));
		
		HashMap<String, Integer> paraMap = new HashMap<String, Integer>();
		paraMap.put("depositcoin", pvo.getPayment_pay());
		paraMap.put("fk_idx", pvo.getFk_idx());
		paraMap.put("payment_UID", seq);	// [190124] 시퀀스 채번 파라미터 매핑 추가

		int paypoint = pvo.getPayment_point();
		int payDeposit = pvo.getPayment_pay();
		
		int point = (int)Math.round((payDeposit*-0.1)-paypoint); 
		
		HashMap<String, Integer> paraMap2 = new HashMap<String, Integer>();
		paraMap2.put("fk_idx", pvo.getFk_idx());
		paraMap2.put("point", point);
		int n1 = dao.insertPaymentByPvo(pvo);
		int n2 = 0;
		int n3 = 0;
		int n4 = 0;
		if(n1==1) {
			n2 = dao.insertDepositMinus(paraMap);
		}
		if(n1==1 && n2==1) {
			n3 = dao.updateReservationStatusByFkRUID(pvo.getFk_reservation_UID());
			n4 = dao.updatePointMember(paraMap2); // [190124] 결제시 사용 포인트를 감하고 실결제금액의 10% point 적립하기
		}
		
		if(n1*n2*n3 == 1) {
			result = 1;
		}
		return result;
	}
	
//	#예약 목록 개수 가져오기
	@Override
	public int getTotalCountNoSearch(int idx) {
		int totalCount = dao.getTotalCountNoSearch(idx);
		return totalCount;
	}

//	#예약목록 가져오기
	@Override
	public List<HashMap<String, String>> selectUserReservationList(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> reservationList = dao.selectUserReservationList(paraMap);
		// 1 결제대기/ 2 예약완료 / 3 진료완료 / 4 취소 / 5 no show
		for(HashMap<String, String> map :reservationList) {
			try {
				map.put("phone", aes.decrypt(map.get("phone")));			
			
				if(map.get("reservation_status").equals("1")) {
					map.put("rv_status", "결제대기");
				}
				else if(map.get("reservation_status").equals("2")) {
					map.put("rv_status", "예약완료");
				}
				else if(map.get("reservation_status").equals("3")) {
					map.put("rv_status", "진료완료");
				}
				else if(map.get("reservation_status").equals("4")) {
					map.put("rv_status", "취소");
				}
				else if(map.get("reservation_status").equals("5")) {
					map.put("rv_status", "no-show");
				}
				else {
					map.put("rv_status", "error");
				}
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
		}
		
		return reservationList;
	}

//	[190125] 예치금 히스토리 목록 중 모두보기인 경우 
	@Override
	public List<DepositVO> selectDepositListByIdx(HashMap<String, Object> paraMap) {
		String[] type=(String[])paraMap.get("typeArr");
		List<DepositVO> depositList = null;
		if(type[0].equals("-10")) {
			paraMap.remove("typeArr");
			depositList = dao.selectDepositListByIdxNoneType(paraMap);
		}
		else {
			depositList = dao.selectDepositListByIdx(paraMap);
		}
		return depositList;
	}
//	[190126] 예치금 히스토리 목록 페이지바 만들기
	@Override
	public int selectDepositListTotalCount(HashMap<String, Object> paraMap) {
		int totalCount = 0;
		String[] type=(String[]) paraMap.get("typeArr");
		if(type[0].equals("-10")) {
			paraMap.remove("typeArr");
			totalCount = dao.selectDepositListTotalCountNoneType(paraMap);
		}
		else {
			totalCount = dao.selectDepositListTotalCount(paraMap);
		}
		return totalCount;
	}
//	#최초 스케줄 생성 프로시저
	@Override
	public void insertScheduleFirst(String idx_biz) {
		dao.insertScheduleFirst(idx_biz);
	}
//	#병원회원의 스케줄 개수 가져오기
	@Override
	public int selectScheduleCountByIdx_biz(String idx_biz) {
		int scheduleCount = dao.selectScheduleCountByIdx_biz(idx_biz);
		return scheduleCount;
	}
	
//	[190128]
//	#캘린더에서 이벤트 클릭 시 예약 정보 가져오기
	@Override
	public HashMap<String, String> selectScheduleOneByScheduleUID(String schedule_UID) {
		HashMap<String, String> returnMap = dao.selectScheduleOneByScheduleUID(schedule_UID);
		
		String pet_type = returnMap.get("pet_type");
		switch (pet_type) {
		case "dog":
			pet_type="강아지";
			break;
		case "cat":
			pet_type="고양이";
			break;
		case "smallani":
			pet_type="소동물";
			break;
		case "etc":
			pet_type="기타";
			break;
		default:
			break;
		}
		returnMap.put("pet_type", pet_type);
		return returnMap;
	}
//	#기업회원 예약 일정 수정하기
//	[190129] 추가수정
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int updateReservationSchedule(HashMap<String, String> paraMap, ReservationVO rvo) {
		int result = 0;
		int n = 0;
		int n1 = 0;
		int n2 = 0;
		int n3 = 0;
		int n4 = 0;
		int n5 = 0;
		int n6 = 0;
		String schedule_UID = "";
		String reservation_UID = "";
		
		n = dao.selectReservationByDate(paraMap);	// 1. 예약테이블 일치값 찾기
		if(n!=0) {
			return 2;
		}
		
		schedule_UID = dao.selectScheduleOneByDate(paraMap); // 2. 스케줄 테이블에서 날짜값과 일치하는 값 가져오기
		
		if(schedule_UID ==null || schedule_UID.equals("")) {
			schedule_UID = dao.selectScheduleSeq(); // 스케줄 테이블 시퀀스 채번
			
			ScheduleVO svo = new ScheduleVO();
			svo.setFk_idx_biz(Integer.parseInt(rvo.getFk_idx_biz()));
			svo.setSchedule_DATE(paraMap.get("reservation_DATE"));
			svo.setSchedule_UID(Integer.parseInt(schedule_UID));
			
			n6 = dao.insertBizScheduleOne(svo); 	// 2-2. 스케줄이 없는 경우 스케줄 생성하기
		}
		else {
			n6 = 1;
		}
		
		if(n==0 && n6==1) {
			n1 = dao.updateReservationStatusTo4(paraMap);	// 3. 기존 예약건 취소상태로 변경
		}
		
		if(n1==1) {
//			reservation_UID = dao.selectReservation_Seq();	// 4. 예약테이블 시퀀스 채번
			rvo.setFk_schedule_UID(schedule_UID);
/*			rvo.setReservation_UID(reservation_UID);
			System.out.println("reservation_UID: "+reservation_UID);*/
			if(rvo.getReservation_type().equals("3") && rvo.getReservation_status().equals("1")) {
				n2 = dao.insertReservationSurgeryByRvo2(rvo);	// 5-1. 예약 테이블에 새로운 일정 insert
				System.out.println("reservation_UID; n2: "+n2);
			}
			else {
				n2 = dao.insertReservationByRvo(rvo);	// 5-2. 예약 테이블에 새로운 일정 insert
			}
		}
		
		if(n2!=0) {
			paraMap.put("status", "0");
			n3 = dao.updateScheduleStatusBySUID(paraMap);	// 6. 기존 스케줄 스테이터스 0으로 변경
			
			paraMap.put("status", "1");
			paraMap.put("fk_schedule_UID", schedule_UID);
			n4 = dao.updateScheduleStatusBySUID(paraMap); 	// 7. 새로운 스케줄 스테이터스 1로 변경
		}
		
		if(n3*n4==1) {
			if(rvo.getReservation_type().equals("3") && rvo.getReservation_status().equals("2")) {
				paraMap.put("n_reservation_UID", String.valueOf(n2));
				System.out.println("n_reservation_UID/reservation_UID: "+paraMap.get("n_reservation_UID")+"/"+paraMap.get("reservation_UID"));
				n5 = dao.updatePaymentReservationUID(paraMap);	// 8. 수술인 경우 payment테이블의 예약UID 변경
				
				if(n5==1) {
					result = 1;
				}
			}
			else {
				result = 1;
			}
		}

		return result;
	}
	
//	[190129]
//	#기업회원; 예약 일정 취소하기 - 수술상담 및 결제완료의 경우
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int updateRvAndScdStatusCancleForSurgery(HashMap<String, String> paraMap) {
		int result = 0;
		int n1=0;
		int n2=0;
		int n3=0;
		int n4=0;
		int n5=0;
		int n6=0;
		// 예약UID로 payment테이블에서 결제한 포인트와 실결제금액 가져오기
		PaymentVO pvo = dao.selectPayPointAndPayCoin(paraMap.get("reservation_UID"));
		// 예약 테이블 상태 변경
		n1 = dao.updateReservationStatusTo4(paraMap);
		
		if(n1==1) {
			// 스케줄 테이블 상태 변경
			paraMap.put("status", "0");
			n2 = dao.updateScheduleStatusBySUID(paraMap);
		}
		if(n2==1) {
			// payment 테이블의 status 3(환불)로 변경
			n3 = dao.updatePaymentStatusTo3ByFK_rvUID(paraMap.get("reservation_UID"));
		}
		if(n3==1) {
			// deposit 테이블에 취소한 값 insert
			int payment_pay = pvo.getPayment_pay()*-1;	// 음수인 결제금액을 양수로 치환
			paraMap.put("depositcoin", String.valueOf(payment_pay));
			paraMap.put("deposit_status", "2");
			paraMap.put("deposit_type", "refund");	// 190213 수정
			paraMap.put("payment_UID", "0");		// 190207 fk_payment_UID 추가
			n4 = dao.insertDepositPlus(paraMap);
		}
		if(n4==1) {
			// 포인트값 플러스
			HashMap<String, Integer> pointParaMap = new HashMap<String, Integer>();
			pointParaMap.put("fk_idx", Integer.parseInt(paraMap.get("fk_idx")));
			pointParaMap.put("point", pvo.getPayment_point());
			n5 = dao.updatePointMember(pointParaMap);
		}
		if(n5==1) {
			HashMap<String, String> noteMap = new HashMap<String, String>();
			noteMap.put("fk_idx", paraMap.get("fk_idx"));
			noteMap.put("not_message", "[일정: "+paraMap.get("reservation_DATE")+"] 예약일정 취소 및 예치금 환불 완료. 관련 사항은 해당 병원으로 연락바랍니다.");
			noteMap.put("not_URL", "<%= request.getContextPath() %>/reservationList.pet");
			
			n6=dao.insertNoteForReservation(noteMap);
		}
		if(n1*n2*n3*n4*n5*n6==1) {
			result = 1;
		}
		
		return result;
	}
//	#기업회원; 예약 일정 취소하기 - 미결제 및 수술상담제외 타입의 경우
	@Override
	public int updateRvAndScdStatusCancle(HashMap<String, String> paraMap) {
		int result = 0;
		int n1=0;
		int n2=0;
		int n3=0;
		
		// 예약 테이블 상태 변경
		n1 = dao.updateReservationStatusTo4(paraMap);
				
		if(n1==1) {
			// 스케줄 테이블 상태 변경
			paraMap.put("status", "0");
			n2 = dao.updateScheduleStatusBySUID(paraMap);
		}
		if(n2==1) {
			HashMap<String, String> noteMap = new HashMap<String, String>();
			noteMap.put("fk_idx", paraMap.get("fk_idx"));
			noteMap.put("not_message", "[일정: "+paraMap.get("reservation_DATE")+"] 예약일정이 취소되었습니다. 관련 사항은 해당 병원으로 연락바랍니다.");
			noteMap.put("not_URL", "<%= request.getContextPath() %>/reservationList.pet");
			
			n3=dao.insertNoteForReservation(noteMap);
		}
		if(n1*n2*n3==1) {
			result=1;
		}
		return result;
	}
//	[190130]
//	#예약 상세 페이지
	@Override
	public HashMap<String, String> selectRvDetailByPUID(String payment_UID, String membertype, String idx) {
		HashMap<String, String> resultMap = new HashMap<String, String>();
		
		if(membertype.equals("1")) {
			resultMap = dao.selectRvDetailByPUIDForMember(payment_UID);
		}
		else {
			HashMap<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("payment_UID", payment_UID);
			paraMap.put("idx_biz", idx);
			resultMap = dao.selectRvDetailForBiz(paraMap);
		}
		
		// [190131] 연락처 복호화
		try {
			resultMap.put("phone", aes.decrypt(resultMap.get("phone")));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		return resultMap;
	}

//	[190203]
	@Override
	public int selectPaymentTotalCountWithSearch(HashMap<String, String> paraMap) {
		int totalCount = dao.selectPaymentTotalCountWithSearch(paraMap);
		return totalCount;
	}

	@Override
	public int selectPaymentTotalCountNoSearch() {
		int totalCount = dao.selectPaymentTotalCountNoSearch();
		return totalCount;
	}

	@Override
	public List<HashMap<String, String>> selectPaymentRvListForAdmin(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> paymentRvList = dao.selectPaymentRvListForAdmin(paraMap);
		return paymentRvList;
	}
	
//	[190204]
	@Override
	public List<HashMap<String, String>> selectAdminPaymentRvListAll() {
		List<HashMap<String,String>> returnList = dao.selectAdminPaymentRvListAll();
		for(HashMap<String, String> resultMap:returnList) {
			try {
				resultMap.put("phone", aes.decrypt(resultMap.get("phone")));
				resultMap.put("biz_phone", aes.decrypt(resultMap.get("biz_phone")));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
		}
		return returnList;
	}

	@Override
	public List<HashMap<String, String>> selectInfiniteScrollDownPaymentRvList(int rnoToStart) {
		List<HashMap<String,String>> returnList = dao.selectInfiniteScrollDownPaymentRvList(rnoToStart);
		for(HashMap<String, String> resultMap:returnList) {
			try {
				resultMap.put("phone", aes.decrypt(resultMap.get("phone")));
				resultMap.put("biz_phone", aes.decrypt(resultMap.get("biz_phone")));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
		}
		return returnList;
	}
	
//	[190207]
//	#관리자 예약결제관리 목록에서 진료기록을 입력한 기업회원에게 예치금 정산하기 
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public HashMap<String, String> insertDepositToBiz(HashMap<String, String> paraMap) {
		HashMap<String, String> returnMap = new HashMap<String, String>();
		HashMap<String, Integer> intParaMap = new HashMap<String, Integer>();
		
		String fk_reservation_UID = paraMap.get("reservation_UID");
		ChartVO cvo = dao.selectChartVOByFk_RUID(fk_reservation_UID);
		
		int depositcoin = 0;
		int addpay = cvo.getAddpay();
		int totalpay = cvo.getTotalpay();
		int point = cvo.getPayment_point();
		
		int n1, n2, n3, n4, n5, n6 = 0;
		
		if( addpay < 0 && totalpay< 100000) {	// 10만원 이하로 정산된 경우
			// 일반회원에게 차액 환불
			if(point!=0) {
				if(addpay*-1>=point) {
					intParaMap.put("fk_idx", cvo.getFk_idx());
					intParaMap.put("point", point);
					n1 = dao.updatePointMember(intParaMap);
					if(addpay*-1!=point) {
						paraMap.put("fk_idx", String.valueOf(cvo.getFk_idx()));
						paraMap.put("depositcoin", String.valueOf(addpay*-1-point));
						paraMap.put("deposit_status", "2");
						paraMap.put("deposit_type", "refund");
						n2 = dao.insertDepositPlus(paraMap);
					}
				}
				else {
					intParaMap.put("fk_idx", cvo.getFk_idx());
					intParaMap.put("point", addpay*-1);
					n1 = dao.updatePointMember(intParaMap);
				}
			}
			else if(point==0){
				paraMap.put("fk_idx", String.valueOf(cvo.getFk_idx()));
				paraMap.put("depositcoin", String.valueOf(addpay*-1));
				paraMap.put("deposit_status", "2");
				paraMap.put("deposit_type", "refund");
				n1 = dao.insertDepositPlus(paraMap);
			}
			depositcoin = totalpay-(totalpay*1/10);
		}
		else {
			depositcoin = 100000 - (100000 * 1/10);
		}
		paraMap.put("fk_idx", paraMap.get("idx_biz"));
		paraMap.put("depositcoin", String.valueOf(depositcoin));
		paraMap.put("deposit_status", "1");
		paraMap.put("deposit_type", "income");
		
		n3 = dao.insertDepositPlus(paraMap);
		n4 = dao.updatePaymentStatusTo0(paraMap);
		String biz_name = cvo.getBiz_name();
		
		if(n3*n4== 1) {
			returnMap.put("result", "1");
			returnMap.put("depositcoin", String.valueOf(depositcoin));
			returnMap.put("biz_name", biz_name);
		}
		else {
			returnMap.put("result", "0");
		}
		return returnMap;
	}

//	[190208]
//	#충전 후 예치금테이블에 기록하기
	@Override
	public int insertDeposit(HashMap<String, String> paraMap) {
		int n = dao.insertDepositPlus(paraMap);
		return n;
	}

//	[190211]
//	#무통장입금 계좌 정보 조회하기
	@Override
	public HashMap<String, String> selectDepositDirectAccount(String deposit_UID) {
		HashMap<String, String> returnMap = dao.selectDepositDirectAccount(deposit_UID);
		return returnMap;
	}

	
//	#관리자 예치금 히스토리 목록
	@Override
	public List<DepositVO> selectDepositListByIdxForAdmin(HashMap<String, Object> paraMap) {
		String[] type=(String[]) paraMap.get("typeArr");
		List<DepositVO> depositList = null;
		if(type[0].equals("-10")) {
			paraMap.remove("type");
			depositList = dao.selectDepositListByIdxNoneTypeForAdmin(paraMap);
		}
		else {
			depositList = dao.selectDepositListByIdxForAdmin(paraMap);
		}
		return depositList;
	}
//	#관리자 예치금 히스토리 목록 페이지바 만들기
	@Override
	public int selectDepositListTotalCountForAdmin(HashMap<String, Object> paraMap) {
		int totalCount = 0;
		String[] type=(String[]) paraMap.get("typeArr");
		if(type[0].equals("-10")) {
			totalCount = dao.selectDepositListTotalCountNoneTypeForAdmin(paraMap);
		}
		else {
			totalCount = dao.selectDepositListTotalCountForAdmin(paraMap);
		}
		return totalCount;
	}

	@Override
	public int updateDepositStatusByDUID(String deposit_UID) {
		int result = dao.updateDepositStatusByDUID(deposit_UID);
		return result;
	}
	
//	#CoolSMS    // 본인이 COOL SMS 에 가입하시면 사용하시오.
	@Override
	public int sendSms(HashMap<String, String> paraMap) throws Exception {
		int n = 0;
	      // String api_key = "api발급받은 키";    // 본인이 COOL SMS 에 가입하시면 사용하시오.
	      // String api_secret = "api발급받은 키"; // 본인이 COOL SMS 에 가입하시면 사용하시오. 
		Coolsms coolsms = new Coolsms(api_key, api_secret);

		HashMap<String, String> set = new HashMap<String, String>();
		set.put("to", paraMap.get("to")); // 수신번호

             // set.put("from", "등록된 발신번호")// 발신번호(휴대폰 또는 전화번호) // 본인이 COOL SMS 에 가입하시면 사용하시오.
		set.put("text", paraMap.get("text")); // 문자내용
		set.put("type", "sms"); // 문자 타입

		System.out.println(set);

		JSONObject result = coolsms.send(set); // 보내기&전송결과받기

		if ((boolean) result.get("status") == true) {
			// 메시지 보내기 성공 및 전송결과 출력
			System.out.println("성공");
			System.out.println(result.get("group_id")); // 그룹아이디
			System.out.println(result.get("result_code")); // 결과코드
			System.out.println(result.get("result_message")); // 결과 메시지
			System.out.println(result.get("success_count")); // 메시지아이디
			System.out.println(result.get("error_count")); // 여러개 보낼시 오류난 메시지 수
			n = 1;
		} else {
			// 메시지 보내기 실패
			System.out.println("실패");
			System.out.println(result.get("code")); // REST API 에러코드
			System.out.println(result.get("message")); // 에러메시지
			n = 0;
		}

		return n;
	}
}