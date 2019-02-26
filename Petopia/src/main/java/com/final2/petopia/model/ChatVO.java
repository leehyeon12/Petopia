package com.final2.petopia.model;

public class ChatVO {
	
	private int va_UID;            // 화상상담번호
	private int fk_idx;            // 회원고유번호
	private int fk_idx_biz;        // 병원,약국고유번호
	private String chatcode;       // 채팅방코드
	private String fk_userid;      // 회원아이디
	private String fk_name_biz;    // 병원명
	private String fk_docname;     // 수의사명
	private String usermessage;    // 회원메세지
	private String docmessage;     // 수의사메세지
	private String umtime;         // 회원메세지시각
	private String dmtime;         // 수의사메세지시각
	
	public ChatVO() { }
	
	public ChatVO(int va_UID, int fk_idx, int fk_idx_biz, String chatcode, String fk_userid, String fk_name_biz,
			String fk_docname, String usermessage, String docmessage, String umtime, String dmtime) {

		this.va_UID = va_UID;
		this.fk_idx = fk_idx;
		this.fk_idx_biz = fk_idx_biz;
		this.chatcode = chatcode;
		this.fk_userid = fk_userid;
		this.fk_name_biz = fk_name_biz;
		this.fk_docname = fk_docname;
		this.usermessage = usermessage;
		this.docmessage = docmessage;
		this.umtime = umtime;
		this.dmtime = dmtime;
	}

	public int getVa_UID() {
		return va_UID;
	}

	public void setVa_UID(int va_UID) {
		this.va_UID = va_UID;
	}

	public int getFk_idx() {
		return fk_idx;
	}

	public void setFk_idx(int fk_idx) {
		this.fk_idx = fk_idx;
	}

	public int getFk_idx_biz() {
		return fk_idx_biz;
	}

	public void setFk_idx_biz(int fk_idx_biz) {
		this.fk_idx_biz = fk_idx_biz;
	}

	public String getChatcode() {
		return chatcode;
	}

	public void setChatcode(String chatcode) {
		this.chatcode = chatcode;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getFk_name_biz() {
		return fk_name_biz;
	}

	public void setFk_name_biz(String fk_name_biz) {
		this.fk_name_biz = fk_name_biz;
	}

	public String getFk_docname() {
		return fk_docname;
	}

	public void setFk_docname(String fk_docname) {
		this.fk_docname = fk_docname;
	}

	public String getUsermessage() {
		return usermessage;
	}

	public void setUsermessage(String usermessage) {
		this.usermessage = usermessage;
	}

	public String getDocmessage() {
		return docmessage;
	}

	public void setDocmessage(String docmessage) {
		this.docmessage = docmessage;
	}

	public String getUmtime() {
		return umtime;
	}

	public void setUmtime(String umtime) {
		this.umtime = umtime;
	}

	public String getDmtime() {
		return dmtime;
	}

	public void setDmtime(String dmtime) {
		this.dmtime = dmtime;
	}
	
	
	
	
	
}
