
package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public interface InterChartDAO {

	int insertmychart(HashMap<String, String> map);// 마이페이지에서 처방전 입력하기

	ChartVO selectchartinfo(int idx); // 차트 정보 불러오기

	List<HashMap<String, String>> selectreserveinfo(int idx); // 예약정보 가져오기

	int selecttabuid(HashMap<String, Object> paramap); // 탭에 넣을 예약번호 알아오기

	// 0124
	List<HashMap<String, String>> selectBizReservationList(HashMap<String, String> paraMap); // 기업회원예약진료리스트

	int getTotalCountNoSearch(int idx_biz);

	HashMap<String, String> selectReserverInfo(String ruid); // 예약번호로 예약자 정보 불러오기

	List<HashMap<String, String>> selectDocList(String ruid); // 예약번호로 의사 이름 알아오기

	int insertChart(ChartVO cvo);// 병원페이지에서 차트 입력하기
	// 0128

	int insertPre(List<HashMap<String, String>> mlist);// 병원페이지에서 처방전 입력하기

	void updaterstatus(String ruid);// 처방전 인서트 성공하면 예약 스테이터스 변경하기

	HashMap<String, String> selectChart(HashMap<String, String> map); // 병원페이지에서 차트 내용불러오기

	String getChartuid(); // 차트번호가져오기

	String getPuid(HashMap<String, String> map); // 처방전 번호 알아오기

	// 0129
	// 예약자번호로 처방전 인서트 내용 가져오기
	HashMap<String, String> selectpreinfobyruid(String ruid);

	HashMap<String, String> selectPreinfo(HashMap<String, String> map2); // 셀렉트창에서 처방전 내용가져오기

	// 0131 예약번호로 차트번호 알아오기
	String getChartuidbyruid(String ruid);

	int Updatechart(ChartVO cvo);// 병원페이지에서 차트 수정하기

	int Updatepre(List<HashMap<String, String>> plist);// 0131병원페이지에서 차트 수정시 처방전 수정

	List<HashMap<String, String>> selectPre(HashMap<String, String> map);// 병원 차트페이지에서 처방전 부분

	// 0201 캘린더에 넣을 리스트 가져오기
	List<HashMap<String, String>> selectMyPrescription(String fk_pet_uid);

	// 0202 회원이 보유한 펫 마리수 가져오기
	int getPetmaribyidx(int idx);

	// 0202pet_uid가 가장 작은 동물의 puid 알아오기
	int getMinpuidbyidx(int idx);

	// 0202 가장 작은 petuid를 가진 동물의 정보 가져오기
	HashMap<String, Object> getPinfobyminpuid(int minpuid);

	// 0202 idx로 반려동물의 이미지와 이름 리스트 불러오기
	List<HashMap<String, String>> getPmapListbyidx(int idx);

	//0207 예약타입 가져오기 
	int selectrtype(String ruid);

	//0207 결제정보가 없는 차트입력창에서 예약자 정보 가져오기 
	HashMap<String, String> selectReserverInfoNopay(String ruid);

	//0208 결제정보가 없는 차트 인서트 
	int insertChartNopay(ChartVO cvo);

	//0209 결제 정보가 없는 차트 불러오기 
	HashMap<String, String> selectChartNopay(HashMap<String, String> map);

	//0209 펫이미지 버튼 클릭시 보여질 정보 
	HashMap<String, Object> getPinfo(String puid);

	//0210 마이페이지에서 진료관리 클릭시 보여지는 병원 방문 날짜 리스트 가져오기
	List<HashMap<String,String>> getmyreservedaylist(HashMap<String, String> paramap);

	//0210 가장 작은예약번호 알아오기 (마이페이지 진료관리 처방전 입력에 필요 )
	String getminRuid(HashMap<String, String> paramap);

	//0210 마이페이지에서 잔료관리 클릭시  보여지는 처방전  인서트 창에 불러올 기본 정보 
	HashMap<String, String> getmyPreinfo(HashMap<String, String> paramap2);

	//0210 마이페이지 진료관리에서 처방전 인서트할때 필요한 차트 유아이디 
	String getcuid(String minruid);

	//0211 ajax로  탭 클릭시 마이페이지 처방전 기본정보 불러오기
	HashMap<String, String> getmyPreinfobyajax(String reservation_uid);

	//0210 예약 날짜 및 시간과 맞는 펫 유아이디 가져오기
	int getpetuidbyajax(String reservedate);

	//0210 예약날짜 및 시간과 맞는 예약번호 가져오기 
	String getruidbyajax(String reservedate);

	//0213 마이페이지 진료관리 차트 , 결제정보가 없는 
	HashMap<String, String> getmyPreinfobyajaxnopay(HashMap<String, String> paramap2);

	//0213 마이페이지에서 예약정보가 없는 개인 차트 인서트 
	int InsertmyChartnoReserveEnd(ChartVO cvo);

	//0213 마이페이지에서 예약없는 차트 테이블에 cuid인서트후 처방전 테이블에 들어갈 cuid 구하기 
	String getmaxcuid();

	//0214 펫이름 
	HashMap<String, String> getpnames(String puid);

	//0214 마이페이지에서 예약이 없는 차트 업데이트 하기 
	int Updatemychart(ChartVO cvo);

	//0216
	int updateNoshow(String reservation_UID);




	


}