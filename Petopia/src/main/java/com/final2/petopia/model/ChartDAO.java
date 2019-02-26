package com.final2.petopia.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChartDAO implements InterChartDAO {

	@Autowired
	private SqlSessionTemplate sqlsession;

	// 마이페이지에서 처방전 입력하기
	@Override
	public int insertmychart(HashMap<String, String> map){
		int n = sqlsession.insert("chart.insertmychart", map);
		return n;
	}

	@Override
	public ChartVO selectchartinfo(int idx) {
		ChartVO chartinfo = sqlsession.selectOne("chart.selectchartinfo", idx);
		return chartinfo;
	}

	@Override
	public int selecttabuid(HashMap<String, Object> paramap) {
		int ruid = sqlsession.selectOne("chart.selecttabuid", paramap);
		return ruid;
	}

	@Override
	public List<HashMap<String, String>> selectreserveinfo(int idx) {
		List<HashMap<String, String>> maplist = sqlsession.selectList("chart.selectreserveinfo", idx);
		return maplist;
	}

	// 0124
	@Override
	public List<HashMap<String, String>> selectBizReservationList(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> maplist = sqlsession.selectList("chart.selectBizReservationList", paraMap);
		return maplist;
	}

	@Override
	public int getTotalCountNoSearch(int idx_biz) {
		int n = sqlsession.selectOne("chart.getTotalCountNoSearch", idx_biz);
		return n;
	}

	// 예약번호로 예약자 정보 불러오기
	@Override
	public HashMap<String, String> selectReserverInfo(String ruid) {

		HashMap<String, String> chartmap = sqlsession.selectOne("chart.selectReserverInfo", ruid);

		return chartmap;
	}

	// 0125 예약번호로 의사 이름 가져오기
	@Override
	public List<HashMap<String, String>> selectDocList(String ruid) {
		List<HashMap<String, String>> doclist = sqlsession.selectList("chart.selectDocList", ruid);
		return doclist;
	}

	// 병원페이지에서 차트 입력하기 0126
	@Override
	public int insertChart(ChartVO cvo) {

		int n = sqlsession.insert("chart.insertChart", cvo);
		return n;
	}

	// 병원페이지에서 처방전 입력하기 0128 0130
	@Override
	public int insertPre(List<HashMap<String, String>> mlist) {
		int result = 0;
		for (HashMap<String, String> map : mlist) {
			int n = sqlsession.insert("chart.insertPre", map);
			if (n == 0) {
				result = 0;
			} else {
				result = 1;
			}
		}
		return result;
	}

	// 처방전 인서트 완료후 예약스테이터스 변경하기
	@Override
	public void updaterstatus(String ruid) {
		sqlsession.update("chart.updaterstatus", ruid);

	}

	// 병원페이지에서 차트 내역불러오기
	@Override
	public HashMap<String, String> selectChart(HashMap<String, String> map) {
		HashMap<String, String> cmap = sqlsession.selectOne("chart.selectChart", map);

		return cmap;
	}

	// 차트번호 가져오기
	@Override
	public String getChartuid() {
		String cuid = sqlsession.selectOne("chart.getChartuid");
		return cuid;
	}

	// 처방전 번호 알아오기
	@Override
	public String getPuid(HashMap<String, String> map) {
		String puid = sqlsession.selectOne("chart.getPuid", map);
		return puid;
	}

	// 0129
	// 예약자번호로 처방전 인서트 내용 가져오기
	@Override
	public HashMap<String, String> selectpreinfobyruid(String ruid) {
		HashMap<String, String> preinfo = sqlsession.selectOne("chart.selectpreinfobyruid", ruid);
		return preinfo;
	}

	// 셀렉트창에서 처방전 내용가져오기
	@Override
	public HashMap<String, String> selectPreinfo(HashMap<String, String> map2) {
		HashMap<String, String> pmap = sqlsession.selectOne("chart.selectPreinfo", map2);
		return pmap;
	}

	// 0131 예약번호로 차트번호 알아오기
	@Override
	public String getChartuidbyruid(String ruid) {
		String cuid = sqlsession.selectOne("chart.getChartuidbyruid", ruid);
		return cuid;
	}
///////////////////////////////////////////////////////////////////////////////////////
	// 0131병원페이지에서 차트 수정하기
	@Override
	public int Updatechart(ChartVO cvo) {
		int n = sqlsession.update("chart.Updatechart", cvo);
		return n;
	}

	// 0131병원페이지에서 차트 수정시 처방전 수정
	@Override
	public int Updatepre(List<HashMap<String, String>> plist) {
		int result =0;
		for (HashMap<String, String> pmap : plist) {
			
			int n = sqlsession.update("chart.Updatepre",pmap);
			
			if (n == 0) {
				result = 0;
			} else {
				result = 1;
			}
		}
		return result;
		
	}
//////////////////////////////////////////////////////////////////////
	// 병원 차트페이지에서 처방전 부분
	@Override
	public List<HashMap<String, String>> selectPre(HashMap<String, String> map) {
		List<HashMap<String, String>> plist = sqlsession.selectList("chart.selectPre", map);
		return plist;
	}

	// 0201 캘린더에 넣을 정보 리스트 가벼오기
	@Override
	public List<HashMap<String, String>> selectMyPrescription(String fk_pet_uid) {
		List<HashMap<String, String>> calist = sqlsession.selectList("chart.selectMyPrescription", fk_pet_uid);
		return calist;
	}

	// 0202 회원이 보유한 펫 마리수 가져오기
	@Override
	public int getPetmaribyidx(int idx) {
		int pnum = sqlsession.selectOne("chart.getPetmaribyidx", idx);
		return pnum;
	}

	// 0202pet_uid가 가장 작은 동물의 puid 알아오기
	@Override
	public int getMinpuidbyidx(int idx) {
		int minpuid = sqlsession.selectOne("chart.getMinpuidbyidx", idx);
		return minpuid;
	}

	// 0202 가장 작은 petuid를 가진 동물의 정보 가져오기
	@Override
	public HashMap<String, Object> getPinfobyminpuid(int minpuid) {
		HashMap<String, Object> minpinfo = sqlsession.selectOne("chart.getPinfobyminpuid", minpuid);
		return minpinfo;
	}

	// 0202 idx로 반려동물의 이미지와 이름 리스트 불러오기
	@Override
	public List<HashMap<String, String>> getPmapListbyidx(int idx) {
		List<HashMap<String, String>> pmaplist = sqlsession.selectList("chart.getPmapListbyidx", idx);
		return pmaplist;
	}

	//0207 예약 타입 알아오기 
	@Override
	public int selectrtype(String ruid) {
		int selectrtype = sqlsession.selectOne("chart.selectrtype",ruid);
		return selectrtype;
	}
    //0207 차트에서 결제정보가 없는 예약자 정보 불러오기 
	@Override
	public HashMap<String, String> selectReserverInfoNopay(String ruid) {
		HashMap<String, String> chartmap = sqlsession.selectOne("chart.selectReserverInfoNopay",ruid);
		return chartmap;
	}

	//0208 결제정보가 없는 차트 인서트 
	@Override
	public int insertChartNopay(ChartVO cvo) {
		int n = sqlsession.insert("chart.insertChartNopay", cvo);
		return n;
	}
	//0209 결제 정보가 없는 차트 불러오기 
	@Override
	public HashMap<String, String> selectChartNopay(HashMap<String, String> map) {
		HashMap<String, String> cmap = sqlsession.selectOne("chart.selectChartNopay",map);
		return cmap;
	}

	//0209 펫이미지 버튼 클릭시 보여질 정보 
	@Override
	public HashMap<String, Object> getPinfo(String puid) {
		HashMap<String, Object> pinfo =sqlsession.selectOne("chart.getPinfo", puid);
		return pinfo;
	}

	//0210 마이페이지에서 진료관리 클릭시 보여지는 병원 방문 날짜 리스트 가져오기
	@Override
	public List<HashMap<String,String>> getmyreservedaylist(HashMap<String, String> paramap) {
		List<HashMap<String,String>> myreservedaylist = sqlsession.selectList("chart.getmyreservedaylist", paramap);
		return myreservedaylist;
	}

	//0210 가장 작은예약번호 알아오기 (마이페이지 진료관리 처방전 입력에 필요 )
	@Override
	public String getminRuid(HashMap<String, String> paramap) {
		String minRuid = sqlsession.selectOne("chart.getminRuid",paramap);
		return minRuid;
	}

	//0210 마이페이지에서 잔료관리 클릭시  보여지는 처방전  인서트 창에 불러올 기본 정보 
	@Override
	public HashMap<String, String> getmyPreinfo(HashMap<String, String> paramap2) {
		HashMap<String, String> myPreinfo = sqlsession.selectOne("chart.getmyPreinfo",paramap2);
		return myPreinfo;
	}

	//0210 마이페이지 진료관리에서 처방전 인서트할때 필요한 차트 유아이디 
	@Override
	public String getcuid(String minruid) {
		String cuid = sqlsession.selectOne("chart.getcuid",minruid);
		return cuid;
	}

	//0211 ajax로  탭 클릭시 마이페이지 처방전 기본정보 불러오기
	@Override
	public HashMap<String, String> getmyPreinfobyajax(String chart_uid) {
		HashMap<String, String> myPreinfobyajax =sqlsession.selectOne("chart.getmyPreinfobyajax",chart_uid);
		return myPreinfobyajax;
	}

	//0210 예약 날짜 및 시간과 맞는 펫 유아이디 가져오기
	@Override
	public int getpetuidbyajax(String reservedate) {
		int petuidbyajax = sqlsession.selectOne("chart.getpetuidbyajax",reservedate);
		return petuidbyajax;
	}

	//0210 예약날짜 및 시간과 맞는 예약번호 가져오기 
	@Override
	public String getruidbyajax(String reservedate) {
		String ruidbyajax = sqlsession.selectOne("chart.getruidbyajax",reservedate);
		return ruidbyajax;
	}

	//0213 마이페이지 진료관리 차트 , 결제정보가 없는 
	@Override
	public HashMap<String, String> getmyPreinfobyajaxnopay(HashMap<String, String> paramap2) {
		HashMap<String, String> myPreinfobyajaxnopay =sqlsession.selectOne("chart.getmyPreinfobyajaxnopay",paramap2);
		return myPreinfobyajaxnopay;
	}

	//0213 마이페이지에서 예약정보가 없는 개인 차트 인서트 
	@Override
	public int InsertmyChartnoReserveEnd(ChartVO cvo) {
		int n =sqlsession.insert("chart.InsertmyChartnoReserveEnd",cvo);
		return n;
	}

	//0213 마이페이지에서 예약없는 차트 테이블에 cuid인서트후 처방전 테이블에 들어갈 cuid 구하기 
	@Override
	public String getmaxcuid() {
		String mcuid=sqlsession.selectOne("chart.getmaxcuid");
		return mcuid;
	}

	//펫이름 
	@Override
	public HashMap<String, String> getpnames(String puid) {
		HashMap<String, String> pnames =sqlsession.selectOne("chart.getpnames",puid);
		return pnames;
	}
	//0214 마이페이지에서 예약이 없는 차트 업데이트 하기 
	@Override
	public int Updatemychart(ChartVO cvo) {
		int n = sqlsession.update("chart.Updatemychart", cvo);
		return n;
	}

	//0216
	@Override
	public int updateNoshow(String reservation_UID) {
		int n = sqlsession.update("chart.updateNoshow",reservation_UID);
		return n;
	}

	
	
	

	
	

}
