package com.final2.petopia.model;

import org.springframework.stereotype.Repository;

@Repository
public class ConsultVO {

	
	private String consult_UID;			// 상담코드 
	private String fk_idx;				// 회원고유번호
	private String userid;				// 아이디
	private String name;				// 회원이름
	private String nickname;			// 닉네임
	private String cs_pet_type;			// 동물분류 (1 강아지 / 2 고양이 / 3 소동물 / 4 기타)
	private String cs_title;			// 상담제목
	private String cs_contents;			// 상담내용
	private int cs_hit;					// 조회수
	private String cs_writeday;			// 작성일자
	private String cs_secret;			// 공개여부 (0 비공개 / 1 공개)
	
	private String previous;      		// 이전글번호
 	private String previousTitle;  		// 이전글제목
 	private String next;          		// 다음글번호
 	private String nextTitle;     		// 다음글제목
 	
 	private int commentCount;			// 댓글갯수
 	//private String profileimg;      	// 원본 프로필사진명
 	private String fileName;        	// 톰캣에 저장될 프로필사진명
 	
	public ConsultVO() { }

	public ConsultVO(String consult_UID, String fk_idx, String userid, String name, String nickname, String cs_pet_type,
			String cs_title, String cs_contents, int cs_hit, String cs_writeday, String cs_secret
			, String previous, String previousTitle, String next, String nextTitle, int commentCount, String fileName) {
		this.consult_UID = consult_UID;
		this.fk_idx = fk_idx;
		this.userid = userid;
		this.name = name;
		this.nickname = nickname;
		this.cs_pet_type = cs_pet_type;
		this.cs_title = cs_title;
		this.cs_contents = cs_contents;
		this.cs_hit = cs_hit;
		this.cs_writeday = cs_writeday;
		this.cs_secret = cs_secret;
		this.previous = previous;
		this.previousTitle = previousTitle;
		this.next = next;
		this.nextTitle = nextTitle;
		this.commentCount = commentCount;
		this.fileName = fileName;
	}
	
	public String getConsult_UID() {
		return consult_UID;
	}
	public void setConsult_UID(String consult_UID) {
		this.consult_UID = consult_UID;
	}

	public String getFk_idx() {
		return fk_idx;
	}
	public void setFk_idx(String fk_idx) {
		this.fk_idx = fk_idx;
	}

	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	
	public String getCs_pet_type() {
		return cs_pet_type;
	}
	public void setCs_pet_type(String cs_pet_type) {
		this.cs_pet_type = cs_pet_type;
	}

	public String getCs_title() {
		return cs_title;
	}
	public void setCs_title(String cs_title) {
		this.cs_title = cs_title;
	}

	public String getCs_contents() {
		return cs_contents;
	}
	public void setCs_contents(String cs_contents) {
		this.cs_contents = cs_contents;
	}

	public int getCs_hit() {
		return cs_hit;
	}
	public void setCs_hit(int cs_hit) {
		this.cs_hit = cs_hit;
	}

	public String getCs_writeday() {
		return cs_writeday;
	}
	public void setCs_writeday(String cs_writeday) {
		this.cs_writeday = cs_writeday;
	}

	public String getCs_secret() {
		return cs_secret;
	}
	public void setCs_secret(String cs_secret) {
		this.cs_secret = cs_secret;
	}

	public String getPrevious() {
		return previous;
	}
	public void setPrevious(String previous) {
		this.previous = previous;
	}

	public String getPreviousTitle() {
		return previousTitle;
	}
	public void setPreviousTitle(String previousTitle) {
		this.previousTitle = previousTitle;
	}

	public String getNext() {
		return next;
	}
	public void setNext(String next) {
		this.next = next;
	}

	public String getNextTitle() {
		return nextTitle;
	}
	public void setNextTitle(String nextTitle) {
		this.nextTitle = nextTitle;
	}

	public int getCommentCount() {
		return commentCount;
	}
	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}

	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	

	
}
