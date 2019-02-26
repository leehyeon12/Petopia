package com.final2.petopia.model;

import org.springframework.stereotype.Repository;

// [190121] reservationVO 데이터타입 변경, getter setter, 생성자 변경
@Repository
public class ReservationVO {

	String reservation_UID;       // 예약코드
	String fk_idx;                //회원고유번호
	String fk_idx_biz;				// 기업회원 고유번호 [190120] 기업회원 고유번호 추가
	String fk_schedule_UID;       // 스케쥴코드
	String fk_pet_UID;            // 반려동물코드
	String bookingdate ;          // 예약완료일시
	String reservation_DATE;     // 방문예정일
	String reservation_status;   // 예약진행상태 1 예약완료/ 2 결제완료 / 3 진료완료 / 4 취소 / 5 no show
	String reservation_type;     // 예약타입 1 진료 / 2 예방접종 / 3 수술/ 4 호텔링
	
	public ReservationVO() {}
	public ReservationVO(String reservation_UID, String fk_idx, String fk_idx_biz, String fk_schedule_UID,
			String fk_pet_UID, String bookingdate, String reservation_DATE, String reservation_status,
			String reservation_type) {
		super();
		this.reservation_UID = reservation_UID;
		this.fk_idx = fk_idx;
		this.fk_idx_biz = fk_idx_biz;
		this.fk_schedule_UID = fk_schedule_UID;
		this.fk_pet_UID = fk_pet_UID;
		this.bookingdate = bookingdate;
		this.reservation_DATE = reservation_DATE;
		this.reservation_status = reservation_status;
		this.reservation_type = reservation_type;
	}
	public String getReservation_UID() {
		return reservation_UID;
	}
	public void setReservation_UID(String reservation_UID) {
		this.reservation_UID = reservation_UID;
	}
	public String getFk_idx() {
		return fk_idx;
	}
	public void setFk_idx(String fk_idx) {
		this.fk_idx = fk_idx;
	}
	public String getFk_idx_biz() {
		return fk_idx_biz;
	}
	public void setFk_idx_biz(String fk_idx_biz) {
		this.fk_idx_biz = fk_idx_biz;
	}
	public String getFk_schedule_UID() {
		return fk_schedule_UID;
	}
	public void setFk_schedule_UID(String fk_schedule_UID) {
		this.fk_schedule_UID = fk_schedule_UID;
	}
	public String getFk_pet_UID() {
		return fk_pet_UID;
	}
	public void setFk_pet_UID(String fk_pet_UID) {
		this.fk_pet_UID = fk_pet_UID;
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
	public String getReservation_status() {
		return reservation_status;
	}
	public void setReservation_status(String reservation_status) {
		this.reservation_status = reservation_status;
	}
	public String getReservation_type() {
		return reservation_type;
	}
	public void setReservation_type(String reservation_type) {
		this.reservation_type = reservation_type;
	}
}