package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

public interface InterCareDAO {
	
	//===== 반려동물 리스트 =====
	List<HashMap<String,String>> getPet_infoList(int fk_idx);

	//===== 반려동물 등록 =====
	int insertPet_info(PetVO pvo);

	//===== 케어 등록 caretype 가져오기 =====
	List<HashMap<String, String>> getCaretypeList();

	//===== 케어 등록 caretype 가져오기 =====
	List<HashMap<String, String>> getCaretype_infoList(String caertype);

	//===== 케어 등록 =====
	int insertPetcare(CareVO cvo);

	//===== 특정 반려동물 리스트 =====
	HashMap<String, Object> getPet_info(HashMap<String, String> paramap);

	//===== 특정 반려동물관리 상세페이지 요청(Ajax) =====
	List<HashMap<String, String>> getWeight(String pet_UID);
	
	
	void addWeight(HashMap<String, String> paraMap); //===== 특정 반려동물관리 체중 추가 =====
	void addWeightWithPet_info(HashMap<String, String> paraMap); //===== 특정 반려동물관리 체중 추가 =====

	//===== 특정 반려동물관리 진료기록(Ajax) =====
	List<HashMap<String, String>> getChart(String pet_UID);

	//===== 케어관리페이지 요청 =====
	List<HashMap<String, String>> getPetcare(String pet_UID);

	

	

}
