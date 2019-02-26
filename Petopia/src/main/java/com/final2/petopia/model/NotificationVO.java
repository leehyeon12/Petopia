package com.final2.petopia.model;

public class NotificationVO {
	
	private String not_UID;					// 알림코드
	private String fk_idx;					// 회원고유번호
	private String not_type;				// 알림유형 (0:전체공지 1:petcare 2:reservation 3:payment 4:board 5:화상채팅)
	private String not_message;				// 알림내용
	private String not_date;				// 알림발송일시
	private String not_readcheck;			// 확인여부 (0:미확인 1:확인)
	private String not_remindstatus;		// 재알림 여부 (0:재알림x 1:재알림)
	private String not_time;				// 예약알림 예정시간
	private String not_URL;					// 이동할 url
	
	
	public NotificationVO() {}
	
	public NotificationVO(String not_UID, String fk_idx, String not_type, String not_message, String not_date, String not_readcheck, 
						  String not_remindstatus, String not_time, String not_URL) {
		
		this.not_UID = not_UID;
		this.fk_idx = fk_idx;
		this.not_type = not_type;
		this.not_message = not_message;
		this.not_date = not_date;
		this.not_readcheck = not_readcheck;
		this.not_remindstatus = not_remindstatus;
		this.not_time = not_time;
		this.not_URL = not_URL;
	}

	public String getNot_UID() {
		return not_UID;
	}

	public void setNot_UID(String not_UID) {
		this.not_UID = not_UID;
	}

	public String getFk_idx() {
		return fk_idx;
	}

	public void setFk_idx(String fk_idx) {
		this.fk_idx = fk_idx;
	}

	public String getNot_type() {
		return not_type;
	}

	public void setNot_type(String not_type) {
		this.not_type = not_type;
	}

	public String getNot_message() {
		return not_message;
	}

	public void setNot_message(String not_message) {
		this.not_message = not_message;
	}

	public String getNot_date() {
		return not_date;
	}

	public void setNot_date(String not_date) {
		this.not_date = not_date;
	}

	public String getNot_readcheck() {
		return not_readcheck;
	}

	public void setNot_readcheck(String not_readcheck) {
		this.not_readcheck = not_readcheck;
	}

	public String getNot_remindstatus() {
		return not_remindstatus;
	}

	public void setNot_remindstatus(String not_remindstatus) {
		this.not_remindstatus = not_remindstatus;
	}

	public String getNot_time() {
		return not_time;
	}

	public void setNot_time(String not_time) {
		this.not_time = not_time;
	}

	public String getNot_URL() {
		return not_URL;
	}

	public void setNot_URL(String not_URL) {
		this.not_URL = not_URL;
	}
	
	public String getShowNot_type() {
		
		String result = "";
		
		switch (not_type) {
		case "0":
			result = "공지";
			break;
		case "1":
			result = "케어";
			break;
		case "2":
			result = "예약";
			break;
		case "3":
			result = "결제";
			break;
		case "4":
			result = "댓글";
			break;
		case "5":
			result = "화상상담";
			break;
		default:
			break;
		}
		
		return result;
		
	}
	
	public String getShowNot_message() {
		
		String result = "";
		
		switch (not_type) {
		case "0":
			result = "";
			break;
		case "1":
			result = "";
			break;
		case "2":
			result = "";
			break;
		case "3":
			result = "";
			break;
		case "4":
			result = "";
			break;
		case "5":
			result = "";
			break;
		default:
			break;
		}
		
		return result;
	}
	
}
