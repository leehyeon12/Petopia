package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class Biz_MemberDAO implements InterBiz_MemberDAO {
	
	@Autowired
	private SqlSessionTemplate sqlsession;
	
	@Override
	public List<HashMap<String, String>> selectRecommendTagList() {
		
		List<HashMap<String, String>> tagList = sqlsession.selectList("biz_member.selectRecommendTagList");
		
		return tagList;
	}

	@Override
	public int selectBizMemberIdIsUsed(String userid) {
		
		int cnt = sqlsession.selectOne("biz_member.selectBizMemberIdIsUsed", userid);
		
		return cnt;
	}

	@Override
	public int selectMemberNoSeq() {
		
		int idx = sqlsession.selectOne("biz_member.selectBizMemberSeq");
		
		return idx;
	}

	@Override
	public int insertMemberByMvo(Biz_MemberVO mvo) {
		int result = sqlsession.insert("biz_member.insertMemberByMvo", mvo);
		
		return result;
	}

	@Override
	public int insertLogin_logByMvo(Biz_MemberVO mvo) {
		int result = sqlsession.insert("biz_member.insertLogin_logByMvo", mvo);
		
		return result;
	}

	@Override
	public int insertHave_tagByTagList(List<HashMap<String, String>> selectTagList) {
		int result = 0;
		for(HashMap<String, String> selectTag : selectTagList) {
			int n = sqlsession.insert("biz_member.insertHave_tagByTagList", selectTag);
			
			if(n == 0) {
				return 0;
			} else {
				result = 1;
			} // end of if
		} // end of for
		
		return result;
	}

	@Override
	public int insertBizInfo(Biz_MemberVO bmvo) {
		
		int result = sqlsession.insert("biz_member.insertBizInfo", bmvo);
		return result;
	}

	// biz_info_img 테이블 insert
	@Override
	public int insertBizInfoImg(List<HashMap<String, String>> addImgmapList) {
		int result = 0;		
		
		for(HashMap<String, String> addImgMap : addImgmapList) {
			result = sqlsession.insert("biz_member.insertBizInfoImg", addImgMap);
			
			if(result == 0) {
				return 0;
			} else {
				result = 1;
			}
		} // end
		
		return result;
	}

	@Override
	public int insertDoctor(List<HashMap<String, String>> docList) {
		int result = 0;
		
		for(HashMap<String, String> docMap : docList) {
			result = sqlsession.insert("biz_member.insertDoctor", docMap);
			
			if(result == 0) {
				return 0;
			} else {
				result = 1;
			}
		}
		
		return result;
	}

	@Override
	public Biz_MemberVO selectBizMemberVOByIdx_biz(String idx_biz) {
		Biz_MemberVO bizmvo = sqlsession.selectOne("biz_member.selectBizMemberVOByIdx_biz", idx_biz);
		return bizmvo;
	}
	
	
	// 태그목록가져오기
	@Override
	public List<String> selectBizTagList(String idx_biz) {
		
		
		List<String> tagList = sqlsession.selectList("biz_member.selectBizTagList", idx_biz);
		
		return tagList;
	}
	
	
	// 의료진가져오기
	@Override
	public List<HashMap<String, String>> selectDocList(String idx_biz) {
		
		List<HashMap<String, String>> docList =  sqlsession.selectList("biz_member.selectDocList", idx_biz);
		
		return docList;
	}
	
	
	// 기업추가이미지
	@Override
	public List<String> selectBizImgList(String idx_biz) {
		
		List<String> imgList = sqlsession.selectList("biz_member.selectBizImgList", idx_biz);
		
		return imgList;
	}


	

}
