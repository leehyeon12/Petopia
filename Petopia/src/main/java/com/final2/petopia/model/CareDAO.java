package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CareDAO implements InterCareDAO {

	@Autowired
	private SqlSessionTemplate sqlsession;

	
	//===== 반려동물 리스트 =====
	@Override
	public List<HashMap<String,String>> getPet_infoList(int fk_idx) {
		List<HashMap<String,String>> list = sqlsession.selectList("care.getPet_infoList", fk_idx); 
		return list;
	}
	
	
	//===== 반려동물 등록 =====
	@Override
	public int insertPet_info(PetVO pvo) {
		int n = sqlsession.insert("care.insertPet_info", pvo);
		return n;
	}


	//===== 케어 등록 caretype 가져오기 =====
	@Override
	public List<HashMap<String, String>> getCaretypeList() {
		List<HashMap<String,String>> caretypeList = sqlsession.selectList("care.getCaretypeList");
		return caretypeList;
	}


	//===== 케어 등록 caretype 가져오기 =====
	@Override
	public List<HashMap<String, String>> getCaretype_infoList(String caertype) {
		List<HashMap<String,String>> list = sqlsession.selectList("care.getCaretype_infoList", caertype); 
		return list;
	}


	//===== 케어 등록 =====
	@Override
	public int insertPetcare(CareVO cvo) {
		int n = sqlsession.insert("care.insertPetcare", cvo);
		return n;
	}


	//===== 특정 반려동물 리스트 =====
	@Override
	public HashMap<String, Object> getPet_info(HashMap<String, String> paramap) {
		HashMap<String, Object> petInfo = sqlsession.selectOne("care.getPet_info", paramap);
		return petInfo;
	}


	//===== 특정 반려동물관리 상세페이지 요청(Ajax) =====
	@Override
	public List<HashMap<String, String>> getWeight(String pet_UID) {
		List<HashMap<String,String>> list = sqlsession.selectList("care.getWeight", pet_UID); 
		return list;
	}

	//===== 특정 반려동물관리 체중 추가 =====
	@Override
	public void addWeight(HashMap<String, String> paraMap) {
		sqlsession.insert("care.addWeight", paraMap);
	}
	
	//===== 특정 반려동물케어 체중 페이지 완료 =====
	@Override
	public void addWeightWithPet_info(HashMap<String, String> paraMap) {
		sqlsession.update("care.addWeightWithPet_info", paraMap);
	}
	
	//===== 특정 반려동물관리 진료기록(Ajax) =====
	@Override
	public List<HashMap<String, String>> getChart(String pet_UID) {
		List<HashMap<String,String>> list = sqlsession.selectList("care.getChart", pet_UID); 
		return list;
	}


	//===== 케어관리페이지 요청 =====
	@Override
	public List<HashMap<String, String>> getPetcare(String pet_UID) {
		List<HashMap<String,String>> list = sqlsession.selectList("care.getPetcare", pet_UID);
		return list;
	}










}
