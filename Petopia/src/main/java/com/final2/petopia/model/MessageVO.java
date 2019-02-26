package com.final2.petopia.model;

//=== #178. (웹채팅관련9) === 

import com.google.gson.Gson;

public class MessageVO {

	private String message;
	private String type;   // all 이면 전체 
	private String to;     // 특정 클라이언트 IP Address
	
	public String getMessage() {
		
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	public static MessageVO convertMessage(String source) {
	    MessageVO messagevo = new MessageVO();
	    Gson gson = new Gson();
	    messagevo = gson.fromJson(source, MessageVO.class); // JSON 형태로 되어진 문자열을 실제 MessageVO 객체로 변환한다. 
	 
	    return messagevo;
	}

}
