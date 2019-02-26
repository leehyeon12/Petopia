package com.final2.petopia.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NotificationDAO implements InterNotificationDAO{
	
	//===== 의존객체 주입(DI:Dependency Injection)  =====
	@Autowired
	private SqlSessionTemplate sqlsession;
	
	// ----------------------------------------------------------------------------------------------------------

	// 회원의 고유번호를 이용한 안읽은 알림 갯수 나타내기
	@Override
	public int selectUnreadNotificationCount(int idx) {
		
		int unreadNotificationCount = sqlsession.selectOne("notification.selectUnreadNotificationCount", idx);
		
		return unreadNotificationCount;
	}
	
	// 회원의 고유번호를 이용한 심플 알림정보 가져오기(알림타입과 그 갯수)
	@Override
	public List<HashMap<String, String>> selectNotificatioSimplenList(int idx) {
		
		List<HashMap<String, String>> n_List = sqlsession.selectList("notification.selectNotificatioSimplenList", idx);
		
		return n_List;
	}

	// 알림 리스트 가져오기
	@Override
	public List<NotificationVO> selectNotificationList(HashMap<String, Integer> paraMap) {
		
		List<NotificationVO> notificationList = sqlsession.selectList("notification.selectNotificatioList", paraMap);
		
		return notificationList;
	}

	// 알림번호 통해 알림 읽음 상태로 업데이트
	@Override
	public int updateReadcheck(HashMap<String, Integer> paraMap) {
		
		
		int result = sqlsession.update("notification.updateReadcheck", paraMap);
		
		return result;
	}
	
	// 회원번호, 알림번호 통해 재알림할 하나의 알림정보 가져오기
	@Override
	public NotificationVO selectNotification(HashMap<String, Integer> paraMap) {
		
		NotificationVO nvo = sqlsession.selectOne("notification.selectNotification", paraMap);
		
		return nvo;
	}

	// 재알림 인서트
	@Override
	public int insertRemindNot(NotificationVO nvo) {
		
		int result = sqlsession.insert("notification.insertRemindNot", nvo);
				
		return result;
	}

	// 알림 삭제
	@Override
	public int deleteNot(HashMap<String, Integer> paraMap) {
		
		int result = sqlsession.delete("notification.deleteNot", paraMap);
		
		return result;
	}

	@Override
	public int selectTotalNotCount(int idx) {
		
		int result = sqlsession.selectOne("notification.selectTotalNotCount", idx);
		
		return result;
	}

	
	
}
