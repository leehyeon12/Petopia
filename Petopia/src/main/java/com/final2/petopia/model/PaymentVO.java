package com.final2.petopia.model;

import org.springframework.stereotype.Repository;

@Repository
public class PaymentVO {
	String payment_UID;			// 결제코드
	String fk_reservation_UID;	// 예약코드
	int fk_idx;					// 회원번호
	int payment_total;			// 결제총액
	int payment_point;			// 결제포인트
	int payment_pay;			// 실결제금액
	String payment_date;		// 결제일자
	String payment_status;		// 결제상태 1 결제완료 / 0 미결제 / 2 취소 / 3 환불
	
	public PaymentVO() {}
	public PaymentVO(String payment_UID, String fk_reservation_UID, int fk_idx, int payment_total, int payment_point,
			int payment_pay, String payment_date, String payment_status) {
		super();
		this.payment_UID = payment_UID;
		this.fk_reservation_UID = fk_reservation_UID;
		this.fk_idx = fk_idx;
		this.payment_total = payment_total;
		this.payment_point = payment_point;
		this.payment_pay = payment_pay;
		this.payment_date = payment_date;
		this.payment_status = payment_status;
	}

	
	public String getPayment_UID() {
		return payment_UID;
	}


	public void setPayment_UID(String payment_UID) {
		this.payment_UID = payment_UID;
	}


	public String getFk_reservation_UID() {
		return fk_reservation_UID;
	}


	public void setFk_reservation_UID(String fk_reservation_UID) {
		this.fk_reservation_UID = fk_reservation_UID;
	}


	public int getFk_idx() {
		return fk_idx;
	}


	public void setFk_idx(int fk_idx) {
		this.fk_idx = fk_idx;
	}


	public int getPayment_total() {
		return payment_total;
	}


	public void setPayment_total(int payment_total) {
		this.payment_total = payment_total;
	}


	public int getPayment_point() {
		return payment_point;
	}


	public void setPayment_point(int payment_point) {
		this.payment_point = payment_point;
	}


	public int getPayment_pay() {
		return payment_pay;
	}


	public void setPayment_pay(int payment_pay) {
		this.payment_pay = payment_pay;
	}


	public String getPayment_date() {
		return payment_date;
	}


	public void setPayment_date(String payment_date) {
		this.payment_date = payment_date;
	}


	public String getPayment_status() {
		return payment_status;
	}


	public void setPayment_status(String payment_status) {
		this.payment_status = payment_status;
	}


	public String getShowPayment_status() {
		String result ="";
		if(payment_status=="1") {
			result ="결제완료";
		}
		else if(payment_status=="2") {
			result ="취소";
		}
		else if(payment_status=="3") {
			result ="환불";
		}
		else {
			result ="미결제";
		}
		return result;
	}
	
}
