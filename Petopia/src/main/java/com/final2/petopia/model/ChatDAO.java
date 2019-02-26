package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChatDAO implements InterChatDAO {
	
	// 의존객체 주입
	@Autowired
	private SqlSessionTemplate sqlsession;

	@Override
	public int addcode(HashMap<String, String> map) {
		
		int n = sqlsession.insert("chat.addcode", map);
		
		return n;
	}
	
	@Override
	public int addvideocode(HashMap<String, Object> returnmap) {
		
		int n = sqlsession.insert("chat.addvideocode", returnmap);
		
		return n;
	}
	
	@Override
	public String viewcode(String code) {
		
		String n = sqlsession.selectOne("chat.viewcode", code);
		
		return n;
	}


	@Override
	public String viewidx(String usercode) {
		
		String n = sqlsession.selectOne("chat.viewidx", usercode);
		
		return n;
	}


	@Override
	public int insertall(HashMap<String, Object> returnMap) {
		
		int n = sqlsession.insert("chat.insertall", returnMap);
		
		return n;
	}

	@Override
	public String viewuserid(String idx) {
		
		String n = sqlsession.selectOne("chat.viewuserid", idx);
		
		return n;
	}


	@Override
	public String viewname_biz(String idx) {
		
		String n = sqlsession.selectOne("chat.viewname_biz", idx);
		
		return n;
	}


	@Override
	public String viewdocname(String idx) {
		
		String n = sqlsession.selectOne("chat.viewdocname", idx);
		
		return n;
	}


	@Override
	public List<HashMap<String, Object>> getloglist(int fk_idx) {
		
		List<HashMap<String, Object>> list = sqlsession.selectList("chat.getloglist", fk_idx);
		
		return list;
	}

}
