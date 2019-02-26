package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public interface InterChatService {

	int createcode(HashMap<String, String> map) throws Throwable; // 랜덤 코드 생성
	
	int createvideocode(HashMap<String, Object> returnMap) throws Throwable; // 코드 생성 및 insert

	String viewcode(String code) throws Throwable; // 채팅 뷰

	String viewidx(String usercode) throws Throwable; // idx 알아오기

	int insertall(HashMap<String, Object> returnMap) throws Throwable; //  정보 insert

	String viewuserid(String idx); // 병원idx 가져오기

	String viewname_biz(String idx); // 병원이름 가져오기

	String viewdocname(String idx); // 의사이름 가져오기

	List<HashMap<String, Object>> log(int parseInt); // 정보가져와서 리스트로 출력


}
