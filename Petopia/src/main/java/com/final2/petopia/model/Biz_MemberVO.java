package com.final2.petopia.model;

import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

@Repository
public class Biz_MemberVO {
	
	private String userid;			// 이메일아이디
	private String pwd;				// 비밀번호
	private int idx_biz;  // 병원/약국고유번호
	private String name;  // 기업명
	private int biztype; // 기업구분
	private String repname;    // 대표자명
	private String biznumber;   // 사업자번호
	private String phone;  // 연락처
	private String postcode;    // 우편번호
	private String addr1;       // 주소
	private String addr2;      // 주소2
	private String latitude;    // 위도
	private String longitude;   // 경도
	private String prontimg;   // 대표이미지
	private String weekday;   // 평일
	private String wdstart;    // 평일시작시간
	private String wdend;     // 평일종료시간
	private String lunchstart;  // 점심시작시간
	private String lunchend;    // 점심종료시간
	private String satstart;   // 토요일시작
	private String satend;      // 토요일종료
	private String dayoff;      // 일요일/공휴일
	private int dog;         // 강아지
	private int cat;         // 고양이
	private int smallani;    // 소동물
	private int etc;         // 기타
	private String note;       // 특이사항
	private String intro;      // 소개글
	private String easyway;     // 찾아오시는길
	private int avg_startpoint;	   // 평균 평점
	private String membertype;		// 회원타입
	private int member_status;		// 회원 상태(0:탈퇴, 1:활동)
	private int lastlogindategap;	// 마지막 로그인일자와 현재날짜 사이의 개월수
	private boolean idleStatus;	// 휴면인지 아닌지
	private String fileName;        // 톰캣에 저장될 프로필사진명
	private String profileimg;      // 원본 프로필사진명
	private MultipartFile attach; // 프로필사진 진짜 파일
	private MultipartFile attach2; // 대표이미지 진짜 파일
	
	
	
	public Biz_MemberVO() { }



	public Biz_MemberVO(String userid, String pwd, int idx_biz, String name, int biztype, String repname,
			String biznumber, String phone, String postcode, String addr1, String addr2, String latitude,
			String longitude, String prontimg, String weekday, String wdstart, String wdend, String lunchstart,
			String lunchend, String satstart, String satend, String dayoff, int dog, int cat, int smallani, int etc,
			String note, String intro, String easyway, int avg_startpoint, String membertype, int member_status,
			int lastlogindategap, boolean idleStatus, String fileName, String profileimg, MultipartFile attach,
			MultipartFile attach2) {
		super();
		this.userid = userid;
		this.pwd = pwd;
		this.idx_biz = idx_biz;
		this.name = name;
		this.biztype = biztype;
		this.repname = repname;
		this.biznumber = biznumber;
		this.phone = phone;
		this.postcode = postcode;
		this.addr1 = addr1;
		this.addr2 = addr2;
		this.latitude = latitude;
		this.longitude = longitude;
		this.prontimg = prontimg;
		this.weekday = weekday;
		this.wdstart = wdstart;
		this.wdend = wdend;
		this.lunchstart = lunchstart;
		this.lunchend = lunchend;
		this.satstart = satstart;
		this.satend = satend;
		this.dayoff = dayoff;
		this.dog = dog;
		this.cat = cat;
		this.smallani = smallani;
		this.etc = etc;
		this.note = note;
		this.intro = intro;
		this.easyway = easyway;
		this.avg_startpoint = avg_startpoint;
		this.membertype = membertype;
		this.member_status = member_status;
		this.lastlogindategap = lastlogindategap;
		this.idleStatus = idleStatus;
		this.fileName = fileName;
		this.profileimg = profileimg;
		this.attach = attach;
		this.attach2 = attach2;
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



	public int getIdx_biz() {
		return idx_biz;
	}



	public void setIdx_biz(int idx_biz) {
		this.idx_biz = idx_biz;
	}



	public String getName() {
		return name;
	}



	public void setName(String name) {
		this.name = name;
	}



	public int getBiztype() {
		return biztype;
	}



	public void setBiztype(int biztype) {
		this.biztype = biztype;
	}



	public String getRepname() {
		return repname;
	}



	public void setRepname(String repname) {
		this.repname = repname;
	}



	public String getBiznumber() {
		return biznumber;
	}



	public void setBiznumber(String biznumber) {
		this.biznumber = biznumber;
	}



	public String getPhone() {
		return phone;
	}



	public void setPhone(String phone) {
		this.phone = phone;
	}



	public String getPostcode() {
		return postcode;
	}



	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}



	public String getAddr1() {
		return addr1;
	}



	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}



	public String getAddr2() {
		return addr2;
	}



	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}



	public String getLatitude() {
		return latitude;
	}



	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}



	public String getLongitude() {
		return longitude;
	}



	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}



	public String getProntimg() {
		return prontimg;
	}



	public void setProntimg(String prontimg) {
		this.prontimg = prontimg;
	}



	public String getWeekday() {
		return weekday;
	}



	public void setWeekday(String weekday) {
		this.weekday = weekday;
	}



	public String getWdstart() {
		return wdstart;
	}



	public void setWdstart(String wdstart) {
		this.wdstart = wdstart;
	}



	public String getWdend() {
		return wdend;
	}



	public void setWdend(String wdend) {
		this.wdend = wdend;
	}



	public String getLunchstart() {
		return lunchstart;
	}



	public void setLunchstart(String lunchstart) {
		this.lunchstart = lunchstart;
	}



	public String getLunchend() {
		return lunchend;
	}



	public void setLunchend(String lunchend) {
		this.lunchend = lunchend;
	}



	public String getSatstart() {
		return satstart;
	}



	public void setSatstart(String satstart) {
		this.satstart = satstart;
	}



	public String getSatend() {
		return satend;
	}



	public void setSatend(String satend) {
		this.satend = satend;
	}



	public String getDayoff() {
		return dayoff;
	}



	public void setDayoff(String dayoff) {
		this.dayoff = dayoff;
	}



	public int getDog() {
		return dog;
	}



	public void setDog(int dog) {
		this.dog = dog;
	}



	public int getCat() {
		return cat;
	}



	public void setCat(int cat) {
		this.cat = cat;
	}



	public int getSmallani() {
		return smallani;
	}



	public void setSmallani(int smallani) {
		this.smallani = smallani;
	}



	public int getEtc() {
		return etc;
	}



	public void setEtc(int etc) {
		this.etc = etc;
	}



	public String getNote() {
		return note;
	}



	public void setNote(String note) {
		this.note = note;
	}



	public String getIntro() {
		return intro;
	}



	public void setIntro(String intro) {
		this.intro = intro;
	}



	public String getEasyway() {
		return easyway;
	}



	public void setEasyway(String easyway) {
		this.easyway = easyway;
	}



	public int getAvg_startpoint() {
		return avg_startpoint;
	}



	public void setAvg_startpoint(int avg_startpoint) {
		this.avg_startpoint = avg_startpoint;
	}



	public String getMembertype() {
		return membertype;
	}



	public void setMembertype(String membertype) {
		this.membertype = membertype;
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



	public MultipartFile getAttach() {
		return attach;
	}



	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}



	public MultipartFile getAttach2() {
		return attach2;
	}



	public void setAttach2(MultipartFile attach2) {
		this.attach2 = attach2;
	}
	
	
	

}