package com.final2.petopia.model;

public class ConsultCommentVO {

	private String cmt_id;					// 댓글고유번호
	private String name;				// 이름
	private String userid;				// 이름
	private String nickname;			// 닉네임
	private String membertype;			// 기업회원, 일반회원, 관리자 구분
	private String fk_consult_UID;		// 상담코드
	private String consult_fk_idx;		// 상담글 회원고유번호
	private String org_fk_idx;			// 원댓글 회원고유번호
	private String fk_idx;				// 댓글 회원고유번호
	private String cscmt_nickname;		// 댓글작성자
	private String cscmt_contents;		// 댓글내용
	private String cscmt_writeday;		// 댓글작성일시
	private String fk_cmt_id;				// 원댓글 고유번호
	private int cscmt_group;			// 댓글그룹번호
	private int cscmt_g_odr;			// 댓글그룹순서
	private int cscmt_depth;			// 계층
	private int cscmt_del;				// 삭제여부 0삭제 / 1사용가능
	
	
	public ConsultCommentVO() { }
	
	public ConsultCommentVO(String cmt_id, String name, String userid, String nickname, String membertype, String fk_consult_UID, String fk_idx, String org_fk_idx, String consult_fk_idx, String cscmt_nickname, String cscmt_contents,
			String cscmt_writeday, String fk_cmt_id, int cscmt_group, int cscmt_g_odr, int cscmt_depth, int cscmt_del) {
		this.cmt_id = cmt_id;
		this.name = name;
		this.userid = userid;
		this.nickname = nickname;
		this.fk_consult_UID = fk_consult_UID;
		this.fk_idx = fk_idx;
		this.org_fk_idx = org_fk_idx;
		this.consult_fk_idx = consult_fk_idx;
		this.cscmt_nickname = cscmt_nickname;
		this.cscmt_contents = cscmt_contents;
		this.cscmt_writeday = cscmt_writeday;
		this.fk_cmt_id = fk_cmt_id;
		this.cscmt_group = cscmt_group;
		this.cscmt_g_odr = cscmt_g_odr;
		this.cscmt_depth = cscmt_depth;
		this.cscmt_del = cscmt_del;
	}

	public String getCmt_id() {
		return cmt_id;
	}
	public void setCmt_id(String cmt_id) {
		this.cmt_id = cmt_id;
	}	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getMembertype() {
		return membertype;
	}
	public void setMembertype(String membertype) {
		this.membertype = membertype;
	}

	public String getFk_consult_UID() {
		return fk_consult_UID;
	}
	public void setFk_consult_UID(String fk_consult_UID) {
		this.fk_consult_UID = fk_consult_UID;
	}

	public String getFk_idx() {
		return fk_idx;
	}
	public void setFk_idx(String fk_idx) {
		this.fk_idx = fk_idx;
	}
	
	public String getOrg_fk_idx() {
		return org_fk_idx;
	}
	public void setOrg_fk_idx(String org_fk_idx) {
		this.org_fk_idx = org_fk_idx;
	}

	public String getConsult_fk_idx() {
		return consult_fk_idx;
	}
	public void setConsult_fk_idx(String consult_fk_idx) {
		this.consult_fk_idx = consult_fk_idx;
	}

	public String getCscmt_nickname() {
		return cscmt_nickname;
	}
	public void setCscmt_nickname(String cscmt_nickname) {
		this.cscmt_nickname = cscmt_nickname;
	}

	public String getCscmt_contents() {
		return cscmt_contents;
	}
	public void setCscmt_contents(String cscmt_contents) {
		this.cscmt_contents = cscmt_contents;
	}

	public String getCscmt_writeday() {
		return cscmt_writeday;
	}
	public void setCscmt_writeday(String cscmt_writeday) {
		this.cscmt_writeday = cscmt_writeday;
	}

	public String getFk_cmt_id() {
		return fk_cmt_id;
	}
	public void setFk_cmt_id(String fk_cmt_id) {
		this.fk_cmt_id = fk_cmt_id;
	}

	public int getCscmt_group() {
		return cscmt_group;
	}
	public void setCscmt_group(int cscmt_group) {
		this.cscmt_group = cscmt_group;
	}

	public int getCscmt_g_odr() {
		return cscmt_g_odr;
	}
	public void setCscmt_g_odr(int cscmt_g_odr) {
		this.cscmt_g_odr = cscmt_g_odr;
	}

	public int getCscmt_depth() {
		return cscmt_depth;
	}
	public void setCscmt_depth(int cscmt_depth) {
		this.cscmt_depth = cscmt_depth;
	}

	public int getCscmt_del() {
		return cscmt_del;
	}
	public void setCscmt_del(int cscmt_del) {
		this.cscmt_del = cscmt_del;
	}
	
	
	
	
}
