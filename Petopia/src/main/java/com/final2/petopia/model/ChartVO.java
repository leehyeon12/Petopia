package com.final2.petopia.model;

public class ChartVO {

	String fk_reservation_UID; // 예약코드
	int chart_UID; // 차트코드
	int fk_pet_UID; // 반려동물코드
	int fk_idx; // 회원고유번호
	String chart_type; // 진료타입
	String biz_name; // 병원/약국명
	String bookingdate; // 예약완료일시
	String reservation_DATE; // 방문예정일
	String doc_name; // 수의사명
	String cautions; // 주의사항
	String chart_contents; // 내용
	int payment_pay; // 사용예치금
	int payment_point; // 사용포인트
	int addpay; // 본인부담금(추가결제금액)
	int totalpay; // 진료비총액

//처방전 
	int rx_UID; // 처방코드
	String rx_notice; // 처방안내
	String rx_cautions; // 처방주의사항
	String rx_regName; // 등록한사람

	public ChartVO() {
	}

	public ChartVO(String fk_reservation_UID, int chart_UID, int fk_pet_UID, int fk_idx, String chart_type,
			String biz_name, String bookingdate, String reservation_DATE, String doc_name, String cautions,
			String chart_contents, int payment_pay, int payment_point, int addpay, int totalpay, int rx_UID,
			String rx_notice, String rx_cautions, String rx_regName) {
		super();
		this.fk_reservation_UID = fk_reservation_UID;
		this.chart_UID = chart_UID;
		this.fk_pet_UID = fk_pet_UID;
		this.fk_idx = fk_idx;
		this.chart_type = chart_type;
		this.biz_name = biz_name;
		this.bookingdate = bookingdate;
		this.reservation_DATE = reservation_DATE;
		this.doc_name = doc_name;
		this.cautions = cautions;
		this.chart_contents = chart_contents;
		this.payment_pay = payment_pay;
		this.payment_point = payment_point;
		this.addpay = addpay;
		this.totalpay = totalpay;
		this.rx_UID = rx_UID;
		this.rx_notice = rx_notice;
		this.rx_cautions = rx_cautions;
		this.rx_regName = rx_regName;
	}

	public String getFk_reservation_UID() {
		return fk_reservation_UID;
	}

	public void setFk_reservation_UID(String fk_reservation_UID) {
		this.fk_reservation_UID = fk_reservation_UID;
	}

	public int getChart_UID() {
		return chart_UID;
	}

	public void setChart_UID(int chart_UID) {
		this.chart_UID = chart_UID;
	}

	public int getFk_pet_UID() {
		return fk_pet_UID;
	}

	public void setFk_pet_UID(int fk_pet_UID) {
		this.fk_pet_UID = fk_pet_UID;
	}

	public int getFk_idx() {
		return fk_idx;
	}

	public void setFk_idx(int fk_idx) {
		this.fk_idx = fk_idx;
	}

	public String getChart_type() {
		return chart_type;
	}

	public void setChart_type(String chart_type) {
		this.chart_type = chart_type;
	}

	public String getBiz_name() {
		return biz_name;
	}

	public void setBiz_name(String biz_name) {
		this.biz_name = biz_name;
	}

	public String getBookingdate() {
		return bookingdate;
	}

	public void setBookingdate(String bookingdate) {
		this.bookingdate = bookingdate;
	}

	public String getReservation_DATE() {
		return reservation_DATE;
	}

	public void setReservation_DATE(String reservation_DATE) {
		this.reservation_DATE = reservation_DATE;
	}

	public String getDoc_name() {
		return doc_name;
	}

	public void setDoc_name(String doc_name) {
		this.doc_name = doc_name;
	}

	public String getCautions() {
		return cautions;
	}

	public void setCautions(String cautions) {
		this.cautions = cautions;
	}

	public String getChart_contents() {
		return chart_contents;
	}

	public void setChart_contents(String chart_contents) {
		this.chart_contents = chart_contents;
	}

	public int getPayment_pay() {
		return payment_pay;
	}

	public void setPayment_pay(int payment_pay) {
		this.payment_pay = payment_pay;
	}

	public int getPayment_point() {
		return payment_point;
	}

	public void setPayment_point(int payment_point) {
		this.payment_point = payment_point;
	}

	public int getAddpay() {
		return addpay;
	}

	public void setAddpay(int addpay) {
		this.addpay = addpay;
	}

	public int getTotalpay() {
		return totalpay;
	}

	public void setTotalpay(int totalpay) {
		this.totalpay = totalpay;
	}

	public int getRx_UID() {
		return rx_UID;
	}

	public void setRx_UID(int rx_UID) {
		this.rx_UID = rx_UID;
	}

	public String getRx_notice() {
		return rx_notice;
	}

	public void setRx_notice(String rx_notice) {
		this.rx_notice = rx_notice;
	}

	public String getRx_cautions() {
		return rx_cautions;
	}

	public void setRx_cautions(String rx_cautions) {
		this.rx_cautions = rx_cautions;
	}

	public String getRx_regName() {
		return rx_regName;
	}

	public void setRx_regName(String rx_regName) {
		this.rx_regName = rx_regName;
	}

}