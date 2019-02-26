package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.final2.petopia.model.ChartVO;
import com.final2.petopia.model.InterChartDAO;


@Service
public class ChartService implements InterChartService {

	@Autowired
	private InterChartDAO dao;

	// 마이페이지에서 처방전 입력하기
	@Override
	public int insertmychart(HashMap<String, String> map) {
		int n = dao.insertmychart(map);
		return n;
	}

	// 차트 정보 불러오기
	@Override
	public ChartVO selectchartinfo(int idx) {
		ChartVO chartinfo = dao.selectchartinfo(idx);
		return chartinfo;
	}

	// 예약 정보 가져오기
	@Override
	public List<HashMap<String, String>> selectreserveinfo(int idx) {
		List<HashMap<String, String>> maplist = dao.selectreserveinfo(idx);
		return maplist;
	}

	// 탭에 넣을 예약번호 알아오기
	@Override
	public int selecttabuid(HashMap<String, Object> paramap) {
		int ruid = dao.selecttabuid(paramap);
		return ruid;
	}

	// 0124
	@Override
	public List<HashMap<String, String>> selectBizReservationList(HashMap<String, String> paraMap) {
		List<HashMap<String, String>> maplist = dao.selectBizReservationList(paraMap);
		return maplist;
	}

	@Override
	public int getTotalCountNoSearch(int idx_biz) {
		int totalCount = dao.getTotalCountNoSearch(idx_biz);
		return totalCount;
	}

	// 예약번호로 예약자 정보 얻어오기  0207
	@Override
	public HashMap<String, String> selectReserverInfo(String ruid) {
		HashMap<String, String> chartmap =null;
		int reservation_type =dao.selectrtype(ruid);
		
		if(reservation_type == 3) { //결제 정보가 있을때 (수술)
			chartmap = dao.selectReserverInfo(ruid);
		}else if(reservation_type != 3) { //결제정보가 없을때  (수술 이외 )
			chartmap=dao.selectReserverInfoNopay(ruid);
		}
		return chartmap;
	}

	// 0125
	// 예약번호로 의사이름 목록 알아오기
	@Override
	public List<HashMap<String, String>> selectDocList(String ruid) {
		List<HashMap<String, String>> doclist = dao.selectDocList(ruid);
		return doclist;
	}

	// 병원페이지에서 차트내용 인서트하기 0126  0207 0208
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int insertChart(ChartVO cvo, List<HashMap<String, String>> mlist,HashMap<String, String> map) throws Throwable {
   
		int n1 =0;
		int n2=0;
		int result =0; 
		
		String ruid =map.get("ruid");
		
		int reservation_type =dao.selectrtype(ruid);
		
		if(reservation_type ==3) {//결제정보가 있는 경우에 인서트
			n1 = dao.insertChart(cvo);	
			
		}else if(reservation_type !=3) { //결제정보가 없는 경우에 인서트 
			n1=dao.insertChartNopay(cvo);
		}
		
		if (n1 ==1) { // 차트 인서트에 성공하면 
			
			n2 = dao.insertPre(mlist); //처방전에 인서트하기 
			
		   if(n2==1) {
			   dao.updaterstatus(ruid); //스테이터스 변경하기 
			}
		}
		
		if(n1*n2 ==1) {
			result=1;
		}
		return result;
	}


	// 병원페이지에서 처방전 내용 불러오기 0209 결제 정보 유무로 나누기 
	@Override
	public HashMap<String, String> selectChart(HashMap<String, String> map) {
		
		HashMap<String, String> cmap =null;
		String ruid=map.get("ruid");
		
		int reservation_type =dao.selectrtype(ruid);
		
		if (reservation_type ==3) { //결제정보가 있으면 수술
			 cmap = dao.selectChart(map);
			 
		}else if(reservation_type !=3) { //결제 정보가 없으면 
			 cmap=dao.selectChartNopay(map);
			 
		}
		return cmap;
	}

	// 차트번호 불러오기
	@Override
	public String getChartuid() {
		String cuid = dao.getChartuid();
		return cuid;
	}

	// 처방전번호 알아오기
	@Override
	public String getPuid(HashMap<String, String> map) {
		String puid = dao.getPuid(map);
		return puid;
	}

	// 0129
	// 예약자번호로 처방전 인서트 내용 가져오기
	@Override
	public HashMap<String, String> selectpreinfobyruid(String ruid) {
		HashMap<String, String> preinfo = dao.selectpreinfobyruid(ruid);
		return preinfo;
	}

	// 셀렉트창에서 처방전 내용가져오기
	@Override
	public HashMap<String, String> selectPreinfo(HashMap<String, String> map2) {
		HashMap<String, String> pmap = dao.selectPreinfo(map2);
		return pmap;
	}

	// 0131 예약번호로 차트 번호 알아오기
	@Override
	public String getChartuidbyruid(String ruid) {
		String cuid = dao.getChartuidbyruid(ruid);
		return cuid;
	}

	// 0131병원페이지에서 차트 수정하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int Updatechart(HashMap<String, String> map,ChartVO cvo,List<HashMap<String, String>> plist) {
		
		int n1 = dao.Updatechart(cvo);
		
		int result =0;
		 int n2=0;
		if (n1== 1) {
			 n2 = dao.Updatepre(plist);// 병원페이지에서 차트 수정시 처방전 수정
			
		}
		if (n1*n2==1) {
			result=1;
		}
		return result;
	}

/*   // 병원페이지에서 차트 수정시 처방전 수정
	@Override
	public int updatepre(HashMap<String, String> map) {
		int n = dao.Updatepre(map);
		return n;
	} */

	// 병원 차트페이지에서 처방전 부분
	@Override
	public List<HashMap<String, String>> selectPre(HashMap<String, String> map) {
		List<HashMap<String, String>> pmap2list = dao.selectPre(map);
		return pmap2list;
	}

	// 0201캘린더에 넣을 정보 가져오기
	@Override
	public List<HashMap<String, String>> selectMyPrescription(String fk_pet_uid) {
		List<HashMap<String, String>> callist = dao.selectMyPrescription(fk_pet_uid);
		return callist;
	}

	// 0202 회원이 보유한 펫 마리수 가져오기
	@Override
	public int getPetmaribyidx(int idx) {
		int pnum = dao.getPetmaribyidx(idx);
		return pnum;
	}

	// 0202 pet_uid가 가장 작은 동물의 puid 알아오기
	@Override
	public int getMinpuidbyidx(int idx) {
		int minpuid = dao.getMinpuidbyidx(idx);
		return minpuid;
	}

	// 0202 가장 작은 petuid를 가진 동물의 정보 가져오기
	@Override
	public HashMap<String, Object> getPinfobyminpuid(int minpuid) {
		HashMap<String, Object> minpinfo = dao.getPinfobyminpuid(minpuid);
		return minpinfo;
	}

	// 0202 idx로 반려동물의 이미지와 이름 리스트 불러오기
	@Override
	public List<HashMap<String, String>> getPmapListbyidx(int idx) {
		List<HashMap<String, String>> pmaplist = dao.getPmapListbyidx(idx);
		return pmaplist;
	}

	@Override
	public int selectrtype(String ruid) {
		int rtype =dao.selectrtype(ruid);
		return rtype;
	}

	//0209 펫이미지 클릭시 보여질 정보
	@Override
	public HashMap<String, Object> getPinfo(String puid) {
		HashMap<String, Object> piinfo = dao.getPinfo(puid);
		
		return piinfo;
	}

	//0210 마이페이지에서 진료관리 클릭시 보여지는 병원 방문 날짜 리스트 가져오기 
	@Override
	public List<HashMap<String,String>> getmyreservedaylist(HashMap<String, String> paramap) {
		List<HashMap<String,String>> reservedaylist = dao.getmyreservedaylist(paramap);
		return reservedaylist;
	}

	//0210 가장 작은예약번호 알아오기 (마이페이지 진료관리 처방전 입력에 필요 )
	@Override
	public String getminRuid(HashMap<String, String> paramap) {
		String minRuid = dao.getminRuid(paramap);
		return minRuid;
	}

	//0210 마이페이지에서 잔료관리 클릭시  보여지는 처방전  인서트 창에 불러올 기본 정보 
	@Override
	public HashMap<String, String> getmyPreinfo(HashMap<String, String> paramap2) {
		HashMap<String, String> myPreinfo = dao.getmyPreinfo(paramap2);
		return myPreinfo;
	}

	//0210 마이페이지 진료관리에서 처방전 인서트할때 필요한 차트 유아이디 
	@Override
	public String getcuid(String minruid) {
	  String cuid=dao.getcuid(minruid);
		return cuid;
	}

	//0211 ajax로  탭 클릭시 마이페이지 처방전 기본정보 불러오기 
	@Override
	public HashMap<String, String> getmyPreinfobyajax(String chart_uid) {
		
		HashMap<String, String> myPreinfobyajax = dao.getmyPreinfobyajax(chart_uid);
		
		return myPreinfobyajax;
	}

	//0210 예약 날짜 및 시간과 맞는 펫 유아이디 가져오기 
	@Override
	public int getpetuidbyajax(String reservedate) {
		int petuidbyajax =dao.getpetuidbyajax(reservedate);
		return petuidbyajax;
	}

	//0210 예약날짜 및 시간과 맞는 예약번호 가져오기 
	@Override
	public String getruidbyajax(String reservedate) {
	    String ruidbyajax =dao.getruidbyajax(reservedate);
		return ruidbyajax;
	}



	//0213 마이페이지 진료관리 차트 , 결제정보가 없는 
	@Override
	public HashMap<String, String> getmyPreinfobyajaxnopay(HashMap<String, String> paramap2) {
		HashMap<String, String> myPreinfobyajaxnopay =dao.getmyPreinfobyajaxnopay(paramap2);
		return myPreinfobyajaxnopay;
	}

	//0213 마이페이지에서 예약정보가 없는 개인 차트 인서트 
	//0216 수정
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int InsertmyChartnoReserveEnd(ChartVO cvo,int idx, List<HashMap<String, String>> mlist) {
		System.out.println("cuid:"+cvo.getChart_UID());
		
		int n1 =dao.InsertmyChartnoReserveEnd(cvo);
		int n2=0;
		int result =0;
		 
		if(n1==1) {
		    n2 = dao.insertPre(mlist); //0213마이페이지에서 예약없는 처방전에 인서트하기 
		    
		}
		if(n1*n2==1) {
			result=1;
		}
		return result;
	}

	//0213 마이페이지에서 예약없는 차트 테이블에 cuid인서트후 처방전 테이블에 들어갈 cuid 구하기 
	@Override
	public String getmaxcuid() {
	    String mcuid=dao.getmaxcuid();
		return mcuid;
	}

	//펫이름
	@Override
	public HashMap<String, String> getpnames(String puid) {
		HashMap<String, String> pnames=dao.getpnames(puid);
		return pnames;
	}

	// 0214 마이 페이지 예약없는 차트 수정하기 
	@Override
	public int Updatemychart(ChartVO cvo, List<HashMap<String, String>> plist) {
        int n1 = dao.Updatemychart(cvo);
       
		int result =0;
		 int n2=0;
		if (n1== 1) {
			 n2 = dao.Updatepre(plist);//  차트 수정시 처방전 수정
			
		}
		if (n1*n2==1) {
			result=1;
		}
		return result;
		
	}
	
//0216
	@Override
	public int updateNoshow(String reservation_UID) {
		int n = dao.updateNoshow(reservation_UID);
		return n;
	}

	

	




}
