package com.final2.petopia.model;

import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;

public class ScheduleVO {
	private int schedule_UID; //스케쥴코드
	private int fk_idx_biz; // 병원약국 고유번호
	private String schedule_DATE; // 예약일정
	private int schedule_status; // 일정상태 예약: 1/ 비예약: 0/default: 0
	private String endtime;
	
	public ScheduleVO() {}
	public ScheduleVO(int schedule_UID, int fk_idx_biz, String schedule_DATE, int schedule_status, String endtime) {
		super();
		this.schedule_UID = schedule_UID;
		this.fk_idx_biz = fk_idx_biz;
		this.schedule_DATE = schedule_DATE;
		this.schedule_status = schedule_status;
		this.endtime = endtime;
	}
	public int getSchedule_UID() {
		return schedule_UID;
	}
	public void setSchedule_UID(int schedule_UID) {
		this.schedule_UID = schedule_UID;
	}
	public int getFk_idx_biz() {
		return fk_idx_biz;
	}
	public void setFk_idx_biz(int fk_idx_biz) {
		this.fk_idx_biz = fk_idx_biz;
	}
	public String getSchedule_DATE() {
		return schedule_DATE;
	}
	public void setSchedule_DATE(String schedule_DATE) {
		this.schedule_DATE = schedule_DATE;
	}
	public int getSchedule_status() {
		return schedule_status;
	}
	public void setSchedule_status(int schedule_status) {
		this.schedule_status = schedule_status;
	}
	
	public String getEndtime() {
		
		return endtime;
	}
	public void setEndtime(String endtime) {
		this.endtime = endtime;
	}
	public String getShowSchedule_status() {
		
		String result = "";
		
		switch (schedule_status) {
		case 1:
			result ="예약불가";
		break;
		case 0:
			result ="예약가능";
			break;

		default:
			break;
		}
		return result;
	}
	
	
}
