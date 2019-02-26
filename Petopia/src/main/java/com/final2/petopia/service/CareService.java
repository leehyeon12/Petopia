package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.final2.petopia.model.CareVO;
import com.final2.petopia.model.InterCareDAO;
import com.final2.petopia.model.PetVO;

@Service
public class CareService implements InterCareService {

	@Autowired
	private InterCareDAO dao;

	
	//===== 반려동물 리스트 =====
	@Override
	public List<HashMap<String,String>> getPet_infoList(int fk_idx) {
		List<HashMap<String,String>> list = dao.getPet_infoList(fk_idx);
		return list;
	}
	
	
	//===== 반려동물 등록 =====
	@Override
	public int insertPet_info(PetVO pvo) {
		int n = dao.insertPet_info(pvo);
		return n;
	}


	//===== 케어 등록 caretype 가져오기 =====
	@Override
	public List<HashMap<String, String>> getCaretypeList() {
		List<HashMap<String,String>> caretypeList = dao.getCaretypeList();
		return caretypeList;
	}

	
	//===== 케어 등록 caretype 가져오기 =====
	@Override
	public List<HashMap<String, String>> getCaretype_infoList(String caertype) {
		List<HashMap<String,String>> list = dao.getCaretype_infoList(caertype);
		return list;
	}


	//===== 케어 등록 ===== 
	@Override
	public int insertPetcare(CareVO cvo) {
		int n = dao.insertPetcare(cvo);
		return n;
	}


	//===== 특정 반려동물 리스트 =====
	@Override
	public HashMap<String, Object> getPet_info(HashMap<String, String> paramap) {
		HashMap<String, Object> petInfo = dao.getPet_info(paramap);
		return petInfo;
	}


	//===== 특정 반려동물관리 상세페이지 요청(Ajax) =====
	@Override
	public List<HashMap<String, String>> getWeight(String pet_UID) {
		List<HashMap<String,String>> list = dao.getWeight(pet_UID);
		return list; 
	}

	//===== 특정 반려동물관리 체중 추가 =====
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public void addWeight(HashMap<String, String> paraMap) 
		throws Throwable {
		
		dao.addWeight(paraMap);
		dao.addWeightWithPet_info(paraMap);		
	}
	
	//===== 특정 반려동물관리 진료기록(Ajax) =====
	@Override
	public List<HashMap<String, String>> getChart(String pet_UID) {
		List<HashMap<String,String>> list = dao.getChart(pet_UID);
		return list;
	}


	//===== 케어관리페이지 요청 =====
	@Override
	public List<HashMap<String, String>> getPetcare(String pet_UID) {
		List<HashMap<String,String>> list = dao.getPetcare(pet_UID);
		return list;
	}




	

}
