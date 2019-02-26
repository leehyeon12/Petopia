package com.final2.petopia.websocket;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.final2.petopia.model.MessageVO;
import com.final2.petopia.model.MemberVO;

// === #177. (웹채팅관련8) === 

public class WebsocketEchoHandler extends TextWebSocketHandler {

	    // === 웹소켓서버에 연결한 클라이언트 사용자들을 저장하는 리스트 ===
	    private List<WebSocketSession> connectedUsers = new ArrayList<WebSocketSession>();
	        	
	    
	    /*
	       afterConnectionEstablished(WebSocketSession wsession) 메소드는 
	            클라이언트가 웹소켓서버에 연결된 이후에 실행되는 메소드로서
	       WebSocket 연결이 열리고 사용이 준비될 때 호출되어지는(실행되어지는) 메소드이다.
	    */
	    
	    @Override
	    public void afterConnectionEstablished(WebSocketSession wsession) 
	    	throws Exception {
	    	// >>> 파라미터 WebSocketSession wsession 은  웹소켓서버에 접속한 클라이언트 사용자임. <<<
	    	connectedUsers.add(wsession);
	    	
	    	// 웹소켓서버에 접속한 클라이언트의 IP Address 얻어오기
	    	/*
	    	  STS 메뉴의 
	    	  Run --> Run Configuration 
	    	      --> Arguments 탭
	    	      --> VM arguments 속에 맨 뒤에
	    	      --> 한칸 띄우고 -Djava.net.preferIPv4Stack=true 
	    	                  을 추가한다.  
	    	*/
	        System.out.println("====> 웹채팅확인용 : " + wsession.getId() + "님이 접속했습니다.");
	        // ====> 웹채팅확인용 : 0님이 접속했습니다. 
	        // ====> 웹채팅확인용 : 1님이 접속했습니다.
	        // wsession.getId() 는 자동증가되는 고유한 숫자로 나옴.
	        
	        System.out.println("====> 웹채팅확인용 : " + "연결 컴퓨터명 : " + wsession.getRemoteAddress().getHostName());
	        // ====> 웹채팅확인용 : 연결 컴퓨터명 : DESKTOP-QHPLVB1
	        
	        System.out.println("====> 웹채팅확인용 : " + "연결 컴퓨터명 : " + wsession.getRemoteAddress().getAddress().getHostName());
	        // ====> 웹채팅확인용 : 연결 컴퓨터명 : DESKTOP-QHPLVB1
	        
	        System.out.println("====> 웹채팅확인용 : " + "연결 IP : " + wsession.getRemoteAddress().getAddress().getHostAddress()); 
	        // ====> 웹채팅확인용 : 연결 IP : 192.168.50.29
	        
	    }
	 
	    
	    /*
          handleTextMessage(WebSocketSession wsession, TextMessage message) 메소드는 
                 클라이언트가 웹소켓서버로 메시지를 전송했을 때 호출되는(실행되는) 메소드이다.
        */
	    // === 이벤트를 처리 ===
	     // >>> Send : 클라이언트가 서버로 메시지를 보냄
	     
	     // >>> 파라미터  WebSocketSession 은  메시지를 보낸 클라이언트임.
	     // >>> 파라미터  TextMessage 은  메시지의 내용임.
	    // String이 아님
	    @Override
	    protected void handleTextMessage(WebSocketSession wsession, TextMessage message) 
	    	throws Exception {
	    	
	    	// >>> 파라미터 WebSocketSession wsession은  웹소켓서버에 접속한 클라이언트 사용자임. <<<
	    	// >>> 파라미터 TextMessage message 은  클라이언트 사용자가 웹소켓서버로 보낸 웹소켓 메시지임. <<<
	    	
	    	// Spring에서 WebSocket 사용시 HttpSession에 저장된 값 사용하기
	    	/*
	    	       먼저 /webapp/WEB-INF/spring/config/websocketContext.xml 파일에서
		    	websocket:handlers 태그안에 websocket:handshake-interceptors에
	            HttpSessionHandshakeInterceptor를 추가하면 WebSocketHandler에 접근하기 전에 
	                     먼저 HttpSession에 접근하여 저장된 값을 읽어 들여 WebSocketHandler에서 사용할 수 있도록 처리해줌. 
            */
	    	Map<String, Object> map = wsession.getAttributes();
	    	MemberVO loginuser = (MemberVO)map.get("loginuser");  // "loginuser" 은 HttpSession에 저장된 키 값이다. 
	    	
	    	System.out.println("====> 내아이디 : 로그인ID : " + loginuser.getUserid());
	    	// ====> 웹채팅확인용 : 로그인ID : seoyh
	    	
	        MessageVO messageVO = MessageVO.convertMessage(message.getPayload());
	        // 파라미터 message 은  클라이언트 사용자가 웹소켓서버로 보낸 웹소켓 메시지임
	        // message.getPayload() 은  클라이언트 사용자가 보낸 웹소켓 메시지를 String 타입으로 바꾸어주는 것이다.
	        // /Board/src/main/webapp/WEB-INF/views/tiles1/chatting/multichat.jsp 파일에서 
	        // 클라이언트가 보내준 메시지는 JSON 형태를 뛴 문자열(String) 이므로 이 문자열을 Gson을 사용하여 MessageVO 형태의 객체로 변환시켜서 가져온다.
	       
	        String hostAddress = "";
	 
	        for (WebSocketSession webSocketSession : connectedUsers) {
	            if (messageVO.getType().equals("all")) { // 채팅할 대상이 "전체" 일 경우 
	                if (!wsession.getId().equals(webSocketSession.getId())) {  // 메시지를 자기자신을 뺀 나머지 모든 사용자들에게 메시지를 보냄.
	                    webSocketSession.sendMessage(
	                            new TextMessage("<span style='float:right; padding-left:10px; margin-top:3px; background:whitesmoke'>" +" [" +loginuser.getName()+ "]" + " ▶ " + messageVO.getMessage()));  
	                    break;
	                }
	            } 
	        }
	 
	        
	        System.out.println("====> 웹채팅확인용 : 웹세션ID " + wsession.getId() + "의 메시지 : " + message.getPayload() );
	        // ====> 웹채팅확인용 : 웹세션ID 23의 메시지 : {"message":"채팅방에 <span style='color: red;'>입장</span>했습니다","type":"all","to":"all"}
	    }
	 
	    
	    /*
          afterConnectionClosed(WebSocketSession session, CloseStatus status) 메소드는 
                 클라이언트가 연결을 끊었을 때 즉, WebSocket 연결이 닫혔을 때(채팅페이지가 닫히거나 채팅페이지에서 다른 페이지로 이동되는 경우) 호출되어지는(실행되어지는) 메소드이다.
        */
	    @Override
	    public void afterConnectionClosed(WebSocketSession wsession, CloseStatus status) 
	    	throws Exception {
	    	 // 파라미터 WebSocketSession wsession 은 연결을 끊은 웹소켓 클라이언트.
		     // 파라미터 CloseStatus 은 웹소켓 클라이언트의 연결 상태.
	    	
	    	Map<String, Object> map = wsession.getAttributes();
	    	MemberVO loginuser = (MemberVO)map.get("loginuser");
	    	
	    	
	    	connectedUsers.remove(wsession);
	   	 
	        for (WebSocketSession webSocketSession : connectedUsers) {
	            if (!wsession.getId().equals(webSocketSession.getId())) { // 메시지를 자기자신을 뺀 나머지 모든 사용자들에게 메시지를 보냄.
	                webSocketSession.sendMessage(new TextMessage(" [" +loginuser.getName()+ "]" + "님이 <span style='color: red;'>퇴장</span>했습니다.")); 
	            }
	        }
	       
	        System.out.println("====> 웹채팅확인용 : 웹세션ID " + wsession.getId() + "이 퇴장했습니다.");
	    }
	    
	    
		// init-method(@PostConstruct)
		public void init() throws Exception {
			
		}	    
	
}
