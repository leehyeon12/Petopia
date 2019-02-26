package com.final2.petopia.model;

import org.springframework.stereotype.Repository;

@Repository
public class DepositVO {
	String rno;			// rownum	[190126] rownum 추가
	String deposit_UID;	//	예치금코드
	String fk_payment_UID;	// 결제코드
	String fk_idx;		//	회원고유번호
	String depositcoin;	//	예치금
	String deposit_status; // 예치금상태 1 사용가능 / 0 사용불가능 / 2 환불취소신청 / 3 출금
	String deposit_type;	//	충전수단
	String deposit_date;	//	충전일자
	
	String membertype;	// [190213] membertype 추가
	
	public DepositVO() {}
	
	public DepositVO(String rno, String deposit_UID, String fk_payment_UID, String fk_idx, String depositcoin,
			String deposit_status, String deposit_type, String deposit_date, String membertype) {
		super();
		this.rno = rno;
		this.deposit_UID = deposit_UID;
		this.fk_payment_UID = fk_payment_UID;
		this.fk_idx = fk_idx;
		this.depositcoin = depositcoin;
		this.deposit_status = deposit_status;
		this.deposit_type = deposit_type;
		this.deposit_date = deposit_date;
		this.membertype = membertype;
	}

	
	public String getRno() {
		return rno;
	}

	public void setRno(String rno) {
		this.rno = rno;
	}

	public String getDeposit_UID() {
		return deposit_UID;
	}

	public void setDeposit_UID(String deposit_UID) {
		this.deposit_UID = deposit_UID;
	}

	public String getFk_payment_UID() {
		return fk_payment_UID;
	}

	public void setFk_payment_UID(String fk_payment_UID) {
		this.fk_payment_UID = fk_payment_UID;
	}

	public String getFk_idx() {
		return fk_idx;
	}

	public void setFk_idx(String fk_idx) {
		this.fk_idx = fk_idx;
	}

	public String getDepositcoin() {
		return depositcoin;
	}

	public void setDepositcoin(String depositcoin) {
		this.depositcoin = depositcoin;
	}

	public String getDeposit_status() {
		return deposit_status;
	}

	public void setDeposit_status(String deposit_status) {
		this.deposit_status = deposit_status;
	}

	public String getDeposit_type() {
		return deposit_type;
	}

	public void setDeposit_type(String deposit_type) {
		this.deposit_type = deposit_type;
	}

	public String getDeposit_date() {
		return deposit_date;
	}

	public void setDeposit_date(String deposit_date) {
		this.deposit_date = deposit_date;
	}

	public String getMembertype() {
		return membertype;
	}

	public void setMembertype(String membertype) {
		this.membertype = membertype;
	}

	public String getShowDepositStatus() {
		String result = "";
		switch (deposit_status) {
		case "1":
			result = "충전";
			break;
		case "0":
			result = "사용";
			break;
		case "2":
			result = "취소/환불";
			break;
		case "3":
			result = "출금";
			break;
		case "-1": // [190211] -1 일 때 조건 추가
			result = "입금대기";
			break;
		}
		return result;
	}
	
}
