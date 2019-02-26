package com.final2.petopia.service;

import java.util.HashMap;
import java.util.List;

import com.final2.petopia.model.NotificationVO;

public interface InterNotificationService {

	// 회원의 고유번호를 이용한 안읽은 알림 갯수 나타내기
	int selectUnreadNotificationCount(int idx);

	// 회원의 고유번호를 이용한 심플 알림정보 가져오기(알림타입과 그 갯수)
	List<HashMap<String, String>> selectNotificatioSimplenList(int idx);
	
	// 알림 리스트 가져오기
	List<NotificationVO> selectNotificationList(HashMap<String, Integer> paraMap);

	// 알림번호 통해 알림 읽음 상태로 업데이트
	int updateReadcheck(HashMap<String, Integer> paraMap);

	// 회원고유번호와 알림고유번호를 통해 재알림할 하나의 알림정보 가져오기
	NotificationVO selectNotification(HashMap<String, Integer> paraMap);

	// 재알림 인서트
	int insertRemindNot(NotificationVO nvo);

	// 알림삭제
	int deleteNot(HashMap<String, Integer> paraMap);

	// 전체 알림 수 가져오기
	int selectTotalNotCount(int idx);

}
