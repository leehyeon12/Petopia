package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public interface InterChatDAO {

	int addcode(HashMap<String, String> map);
	
	int addvideocode(HashMap<String, Object> returnmap);

	String viewcode(String code);

	String viewidx(String usercode); // idx값 알아오기

	int insertall(HashMap<String, Object> returnMap); // videochat DB에 insert

	String viewuserid(String idx);

	String viewname_biz(String idx);

	String viewdocname(String idx);

	List<HashMap<String, Object>> getloglist(int fk_idx);

}
