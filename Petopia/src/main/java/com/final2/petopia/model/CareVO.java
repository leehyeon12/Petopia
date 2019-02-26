package com.final2.petopia.model;

import org.springframework.stereotype.Repository;

@Repository
public class CareVO {

	private String care_UID;
	private String fk_pet_UID;
	private String fk_caretype_UID;
	private String care_contents;
	private String care_memo;
	private String care_start;
	private String care_end;
	private String care_alarm;
	private String care_date;
	
	public CareVO() {}
	
	public CareVO(String care_UID, String fk_pet_UID, String fk_caretype_UID, String care_contents, String care_memo,
			String care_start, String care_end, String care_alarm, String care_date) {
		this.care_UID = care_UID;
		this.fk_pet_UID = fk_pet_UID;
		this.fk_caretype_UID = fk_caretype_UID;
		this.care_contents = care_contents;
		this.care_memo = care_memo;
		this.care_start = care_start;
		this.care_end = care_end;
		this.care_alarm = care_alarm;
		this.care_date = care_date;
	}

	public String getCare_UID() {
		return care_UID;
	}

	public void setCare_UID(String care_UID) {
		this.care_UID = care_UID;
	}

	public String getFk_pet_UID() {
		return fk_pet_UID;
	}

	public void setFk_pet_UID(String fk_pet_UID) {
		this.fk_pet_UID = fk_pet_UID;
	}

	public String getFk_caretype_UID() {
		return fk_caretype_UID;
	}

	public void setFk_caretype_UID(String fk_caretype_UID) {
		this.fk_caretype_UID = fk_caretype_UID;
	}

	public String getCare_contents() {
		return care_contents;
	}

	public void setCare_contents(String care_contents) {
		this.care_contents = care_contents;
	}

	public String getCare_memo() {
		return care_memo;
	}

	public void setCare_memo(String care_memo) {
		this.care_memo = care_memo;
	}

	public String getCare_start() {
		return care_start;
	}

	public void setCare_start(String care_start) {
		this.care_start = care_start;
	}

	public String getCare_end() {
		return care_end;
	}

	public void setCare_end(String care_end) {
		this.care_end = care_end;
	}

	public String getCare_alarm() {
		return care_alarm;
	}

	public void setCare_alarm(String care_alarm) {
		this.care_alarm = care_alarm;
	}

	public String getCare_date() {
		return care_date;
	}

	public void setCare_date(String care_date) {
		this.care_date = care_date;
	}
	
} // end of class CareVO
