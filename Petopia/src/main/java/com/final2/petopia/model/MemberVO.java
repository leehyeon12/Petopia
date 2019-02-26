package com.final2.petopia.model;

import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

@Repository
public class MemberVO {

	private int idx;				// 회원고유번호
	private String userid;			// 이메일아이디
	private String pwd;				// 비밀번호
	private String name;           	// 이름
	private String nickname;      	// 닉네임
	private String birthday;		// 생년월일
	private String gender;			// 성별
	private String phone;			// 연락처
	private String membertype;		// 회원타입
	private int point;				// 포인트
	private int totaldeposit;		// 누적예치금
	private int noshow;				// 노쇼지수
	private String registerdate;	// 가입일자
	private String lastlogindate;	// 마지막 로그인일자
	private int member_status;		// 회원 상태(0:탈퇴, 1:활동)
	
	private int lastlogindategap;	// 마지막 로그인일자와 현재날짜 사이의 개월수
	
	private boolean idleStatus;	// 휴면인지 아닌지
	
	private String fileName;        // 톰캣에 저장될 프로필사진명
	private String profileimg;      // 원본 프로필사진명
	private String fileSize;		// 파일 크기
	
	private MultipartFile attach; // 진짜 파일
	
	public MemberVO() {}

	public MemberVO(int idx, String userid, String pwd, String name, String nickname, String birthday, String gender,
			String phone, String membertype, int point, int totaldeposit, int noshow,
			String registerdate, String lastlogindate, int member_status, int lastlogindategap, boolean idleStatus,
			String fileName, String profileimg, String fileSize, MultipartFile attach) {
		this.idx = idx;
		this.userid = userid;
		this.pwd = pwd;
		this.name = name;
		this.nickname = nickname;
		this.birthday = birthday;
		this.gender = gender;
		this.phone = phone;
		this.membertype = membertype;
		this.point = point;
		this.totaldeposit = totaldeposit;
		this.noshow = noshow;
		this.registerdate = registerdate;
		this.lastlogindate = lastlogindate;
		this.member_status = member_status;
		this.lastlogindategap = lastlogindategap;
		this.idleStatus = idleStatus;
		this.fileName = fileName;
		this.profileimg = profileimg;
		this.fileSize = fileSize;
		this.attach = attach;
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
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

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getMembertype() {
		return membertype;
	}

	public void setMembertype(String membertype) {
		this.membertype = membertype;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	public int getTotaldeposit() {
		return totaldeposit;
	}

	public void setTotaldeposit(int totaldeposit) {
		this.totaldeposit = totaldeposit;
	}

	public int getNoshow() {
		return noshow;
	}

	public void setNoshow(int noshow) {
		this.noshow = noshow;
	}

	public String getRegisterdate() {
		return registerdate;
	}

	public void setRegisterdate(String registerdate) {
		this.registerdate = registerdate;
	}

	public String getLastlogindate() {
		return lastlogindate;
	}

	public void setLastlogindate(String lastlogindate) {
		this.lastlogindate = lastlogindate;
	}

	public int getMember_status() {
		return member_status;
	}

	public void setMember_status(int member_status) {
		this.member_status = member_status;
	}

	public int getLastlogindategap() {
		return lastlogindategap;
	}

	public void setLastlogindategap(int lastlogindategap) {
		this.lastlogindategap = lastlogindategap;
	}

	public boolean isIdleStatus() {
		return idleStatus;
	}

	public void setIdleStatus(boolean idleStatus) {
		this.idleStatus = idleStatus;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getProfileimg() {
		return profileimg;
	}

	public void setProfileimg(String profileimg) {
		this.profileimg = profileimg;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}

} // end of class MemberVO
