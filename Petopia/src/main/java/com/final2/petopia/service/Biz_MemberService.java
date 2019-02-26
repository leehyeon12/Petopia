package com.final2.petopia.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.final2.petopia.common.AES256;
import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.model.InterBiz_MemberDAO;

@Service
public class Biz_MemberService implements InterBiz_MemberService {
	
	@Autowired
	private InterBiz_MemberDAO dao;
	
	@Autowired
	private AES256 aes;

	@Override
	public List<HashMap<String, String>> selectRecommendTagList() {
		
		List<HashMap<String, String>> tagList = dao.selectRecommendTagList();
		
		return tagList;
	}

	@Override
	public int selectBizMemberIdIsUsed(String userid) {
		
		int cnt = dao.selectBizMemberIdIsUsed(userid);
		
		return cnt;
	}
	
	// 태그가 있고 이미지가 없고 의사가 없는 경우 회원가입
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertMemberByMvoTagList(Biz_MemberVO bmvo, String[] tagNoArr, String[] tagNameArr) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		// have_tag 테이블 insert
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(idx));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n3 = dao.insertBizInfo(bmvo);
		
		int n4 = dao.insertHave_tagByTagList(selectTagList);
		
		
		
		if(n1*n2*n3*n4 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		return result;
	}
	
	// 태그가 있고 이미지가 있는 경우 회원가입
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertMemberByMvoTagListImg(Biz_MemberVO bmvo, String[] tagNoArr, String[] tagNameArr, List<HashMap<String,String>> addImgmapList) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		// have_tag 테이블 insert
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(idx));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n3 = dao.insertHave_tagByTagList(selectTagList);
		
		int n4 = dao.insertBizInfo(bmvo);
		
		for(HashMap<String, String> addImgMap : addImgmapList) {
			addImgMap.put("FK_IDX_BIZ", String.valueOf(idx));
		} // end of for
		
		int n5 = dao.insertBizInfoImg(addImgmapList);
		
		
		if(n1*n2*n3*n4*n5 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		return result;
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertMemberByMvo(Biz_MemberVO bmvo) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		int n3 = dao.insertBizInfo(bmvo);
		
		if(n1*n2*n3 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		
		return result;	
	}

	// 태그없고 이미지있고 의사없고
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertMemberByMvoImg(Biz_MemberVO bmvo,  List<HashMap<String,String>> addImgmapList) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		for(HashMap<String, String> addImgMap : addImgmapList) {
			addImgMap.put("FK_IDX_BIZ", String.valueOf(idx));
		} // end of for
		
		int n3 = dao.insertBizInfo(bmvo);
		
		int n4 = dao.insertBizInfoImg(addImgmapList);
		
		
		if(n1*n2*n3*n4 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		
		return result;	
	}

	// 태그가 있고 이미지가 없고 의사가 있는 경우 회원가입
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int insertMemberByMvoTagListDoc(Biz_MemberVO bmvo, String[] tagNoArr, String[] tagNameArr, String[] doctor, String[] docdog,String[] doccat, String[] docsmallani, String[] docetc) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		// have_tag 테이블 insert
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(idx));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n3 = dao.insertHave_tagByTagList(selectTagList);
		
		int n4 = dao.insertBizInfo(bmvo);
		
		
		// 의사
		List<HashMap<String, String>> docList = new ArrayList<HashMap<String, String>>();
		for(int i=0; i<doctor.length; i++) {
			HashMap<String, String> docMap = new HashMap<String, String>();
			docMap.put("DOCTOR", doctor[i]);
			docMap.put("DOCDOG", docdog[i]);
			docMap.put("DOCCAT", doccat[i]);
			docMap.put("DOCSMALLANI", docsmallani[i]);
			docMap.put("DOCETC", docetc[i]);
			docMap.put("IDX", String.valueOf(idx));
			
			docList.add(docMap);
		}
		
		int n5 = dao.insertDoctor(docList); 
		
		if(n1*n2*n3*n4*n5 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		return result;
	}
	
	// 태그가 있고 이미지가 있고 의사가 있는 경우 회원가입
	@Override
	public int insertMemberByMvoTagImgListDoc(Biz_MemberVO bmvo, String[] tagNoArr, String[] tagNameArr,
			List<HashMap<String, String>> addImgmapList, String[] doctor, String[] docdog, String[] doccat,
			String[] docsmallani, String[] docetc) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		// have_tag 테이블 insert
		List<HashMap<String, String>> selectTagList = new ArrayList<HashMap<String, String>>();
		
		for(int i=0; i<tagNoArr.length; i++) {
			HashMap<String, String> selectTagMap = new HashMap<String, String>();
			selectTagMap.put("FK_TAG_UID", tagNoArr[i]);
			selectTagMap.put("FK_TAG_NAME", tagNameArr[i]);
			selectTagMap.put("FK_IDX", String.valueOf(idx));
			
			selectTagList.add(selectTagMap);
		} // end of for
		
		int n3 = dao.insertHave_tagByTagList(selectTagList);
		
		int n4 = dao.insertBizInfo(bmvo);
		
		for(HashMap<String, String> addImgMap : addImgmapList) {
			addImgMap.put("FK_IDX_BIZ", String.valueOf(idx));
		} // end of for
		
		int n5 = dao.insertBizInfoImg(addImgmapList);
		
		// 의사
		List<HashMap<String, String>> docList = new ArrayList<HashMap<String, String>>();
		for(int i=0; i<doctor.length; i++) {
			HashMap<String, String> docMap = new HashMap<String, String>();
			docMap.put("DOCTOR", doctor[i]);
			docMap.put("DOCDOG", docdog[i]);
			docMap.put("DOCCAT", doccat[i]);
			docMap.put("DOCSMALLANI", docsmallani[i]);
			docMap.put("DOCETC", docetc[i]);
			docMap.put("IDX", String.valueOf(idx));
			
			docList.add(docMap);
		}
		
		int n6 = dao.insertDoctor(docList);
		
		
		if(n1*n2*n3*n4*n5*n6 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		return result;

	}
	
	// 태그가 없고 이미지도 없고 의사는 있는 경우 회원가입
	@Override
	public int insertMemberByMvoDoc(Biz_MemberVO bmvo, String[] doctor, String[] docdog, String[] doccat,
			String[] docsmallani, String[] docetc) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		int n4 = dao.insertBizInfo(bmvo);
		
		// 의사
		List<HashMap<String, String>> docList = new ArrayList<HashMap<String, String>>();
		for(int i=0; i<doctor.length; i++) {
			HashMap<String, String> docMap = new HashMap<String, String>();
			docMap.put("DOCTOR", doctor[i]);
			docMap.put("DOCDOG", docdog[i]);
			docMap.put("DOCCAT", doccat[i]);
			docMap.put("DOCSMALLANI", docsmallani[i]);
			docMap.put("DOCETC", docetc[i]);
			docMap.put("IDX", String.valueOf(idx));
			
			docList.add(docMap);
		}
		
		int n3 = dao.insertDoctor(docList);
		
		if(n1*n2*n3*n4 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		
		return result;	
		
	}
	
	// 태그가 없고 이미지는 있고 의사도 있는 경우 회원가입
	@Override
	public int insertMemberByMvoImgDoc(Biz_MemberVO bmvo, List<HashMap<String, String>> addImgmapList, String[] doctor,
			String[] docdog, String[] doccat, String[] docsmallani, String[] docetc) {
		
		int result = 0;
		
		// 회원가입할 회원번호 받아오기
		int idx = dao.selectMemberNoSeq();
		
		// 회원번호 mvo에 넣기
		bmvo.setIdx_biz(idx);
		
		// member 테이블 insert
		int n1 = dao.insertMemberByMvo(bmvo);

		// login_log 테이블 insert
		int n2 = dao.insertLogin_logByMvo(bmvo);
		
		int n3 = dao.insertBizInfo(bmvo);
		
		for(HashMap<String, String> addImgMap : addImgmapList) {
			addImgMap.put("FK_IDX_BIZ", String.valueOf(idx));
		} // end of for
		
		int n4 = dao.insertBizInfoImg(addImgmapList);
		
		// 의사
		List<HashMap<String, String>> docList = new ArrayList<HashMap<String, String>>();
		for(int i=0; i<doctor.length; i++) {
			HashMap<String, String> docMap = new HashMap<String, String>();
			docMap.put("DOCTOR", doctor[i]);
			docMap.put("DOCDOG", docdog[i]);
			docMap.put("DOCCAT", doccat[i]);
			docMap.put("DOCSMALLANI", docsmallani[i]);
			docMap.put("DOCETC", docetc[i]);
			docMap.put("IDX", String.valueOf(idx));
			
			docList.add(docMap);
		}
		
		int n5 = dao.insertDoctor(docList);
		
		if(n1*n2*n3*n4*n5 == 0) {
			// 회원가입 실패
			result = 0;
		} else {
			// 회원가입 성공
			result = 1;
		} // end of if~else
		
		
		return result;	
	}

	@Override
	public Biz_MemberVO selectBizMemberVOByIdx_biz(String idx_biz) {
		
		Biz_MemberVO bizmvo = dao.selectBizMemberVOByIdx_biz(idx_biz);
		
		try {
			bizmvo.setPhone(aes.decrypt(bizmvo.getPhone()));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return bizmvo;
	}
	
	// 태그목록가져오기
	@Override
	public List<String> selectBizTagList(String idx_biz) {
		
		List<String> tagList = dao.selectBizTagList(idx_biz);
		
		return tagList;
	}
	
	
	// 의료진가져오기
	@Override
	public List<HashMap<String, String>> selectDocList(String idx_biz) {
		
		List<HashMap<String, String>> docList = dao.selectDocList(idx_biz);
		
		return docList;
	}
	
	
	// 기업추가이미지
	@Override
	public List<String> selectBizImgList(String idx_biz) {
		
		List<String> imgList = dao.selectBizImgList(idx_biz);
		
		return imgList;
	}
	
}
