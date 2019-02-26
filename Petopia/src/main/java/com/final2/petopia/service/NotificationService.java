package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.final2.petopia.model.InterNotificationDAO;
import com.final2.petopia.model.NotificationVO;

@Service
public class NotificationService implements InterNotificationService {
	
	//===== 의존객체 주입(DI:Dependency Injection)  =====
	@Autowired
	private InterNotificationDAO dao;
	
	//===== 양방향 암호화 알고리즘인 AES256을 사용하여 암호화/복호화하기 위한 클래스 의존객체 주입(DI:Dependency Injection) =====
	//@Autowired
	//private AES256 aes;
	
	// ----------------------------------------------------------------------------------------------------------
	
	// 회원의 고유번호를 이용한 안읽은 알림 갯수 나타내기
	@Override
	public int selectUnreadNotificationCount(int idx) {
		
		int unreadNotificationCount = dao.selectUnreadNotificationCount(idx);
		
		return unreadNotificationCount;
	}
	
	// 회원의 고유번호를 이용한 심플 알림정보 가져오기(알림타입과 그 갯수)
	@Override
	public List<HashMap<String, String>> selectNotificatioSimplenList(int idx) {
		
		List<HashMap<String, String>> n_List = dao.selectNotificatioSimplenList(idx);
		
		return n_List;
	}
	
	// 알림 리스트 가져오기
	@Override
	public List<NotificationVO> selectNotificationList(HashMap<String, Integer> paraMap) {
		
		List<NotificationVO> notificationList = dao.selectNotificationList(paraMap);
		
		return notificationList;
	}

	// 알림번호 통해 알림 읽음 상태로 업데이트
	@Override
	public int updateReadcheck(HashMap<String, Integer> paraMap) {

		int result = dao.updateReadcheck(paraMap);
	
		return result;
	}
	
	// 회원고유번호와 알림고유번호를 통해 알림정보 가져오기
	@Override
	public NotificationVO selectNotification(HashMap<String, Integer> paraMap) {
		
		NotificationVO nvo = dao.selectNotification(paraMap);
		
		return nvo;
	}

	// 재알림 인서트
	@Override
	public int insertRemindNot(NotificationVO nvo) {
		
		int result = dao.insertRemindNot(nvo);
		
		return result;
	}

	// 알림삭제
	@Override
	public int deleteNot(HashMap<String, Integer> paraMap) {
		
		int result = dao.deleteNot(paraMap);
		
		return result;
	}

	@Override
	public int selectTotalNotCount(int idx) {
		
		int result = dao.selectTotalNotCount(idx);
		
		return result;
	}

}
