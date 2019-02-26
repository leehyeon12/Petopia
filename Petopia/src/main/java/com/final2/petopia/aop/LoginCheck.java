package com.final2.petopia.aop;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import com.final2.petopia.common.MyUtil;
// import com.final2.petopia.common.MyUtil;
import com.final2.petopia.model.MemberVO;

//===== #52. 공통관심사(Aspect)클래스; 로그인 체크 =====
@Aspect
@Component
public class LoginCheck {

//	#포인트컷 생성하기; execution(public(생략가능) *(리턴타입 모두) com.spring..(com.spring다음 패키지 유무 상관없음)*Controller(controller객체).requireLogin_*(..)) 
	@Pointcut("execution(public * com.final2..*Controller.requireLogin_*(..))")
	public void requireLogin() {}	// 포인트컷의 식별자는 메소드명으로 지정
	
//	#Advice 만들기(보조업무); BeforeAdvice 선언 및 실행 내용 구현하기
	@Before("requireLogin()")
	public void before(JoinPoint joinpoint) {
//		>> 포인트컷한 주업무의 메소드를 JoinPoint 객체로 가져옴
		
//		1) Controller에서 파라미터로 보낸 request객체를 통하여 session객체를 가져오기
		HttpServletRequest req = (HttpServletRequest)joinpoint.getArgs()[0]; // 파라미터 배열의 첫번째 방번호 [0]
		HttpServletResponse res = (HttpServletResponse)joinpoint.getArgs()[1];
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String msg = "";
		String loc = "";
		if(loginuser==null) {
			try {
				String ajaxCall = (String) req.getHeader("AJAX");
				if("true".equals(ajaxCall)){
					res.sendError(901);
				}else{
					
					msg="로그인 후 이용 가능 합니다.";
					loc=req.getContextPath()+"/login.pet";
					
					req.setAttribute("msg", msg);
					req.setAttribute("loc", loc);
					
					String url = MyUtil.getCurrentURL(req);
					session.setAttribute("goBackURL", url);
					
					RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/msg.jsp");
					dispatcher.forward(req, res);
					
					return;
				}
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}
		}
	}	// end of before()
	
	// === 2019.02.07 ==== 시작 //
//	#포인트컷 생성하기; execution(public(생략가능) *(리턴타입 모두) com.spring..(com.spring다음 패키지 유무 상관없음)*Controller(controller객체).requireLogin_*(..)) 
	@Pointcut("execution(public * com.final2..*Controller.requireLoginBiz_*(..))")
	public void requireLoginBiz() {}	// 포인트컷의 식별자는 메소드명으로 지정
	
//	#Advice 만들기(보조업무); BeforeAdvice 선언 및 실행 내용 구현하기
	@Before("requireLoginBiz()")
	public void Bizbefore(JoinPoint joinpoint) {
//		>> 포인트컷한 주업무의 메소드를 JoinPoint 객체로 가져옴
		
//		1) Controller에서 파라미터로 보낸 request객체를 통하여 session객체를 가져오기
		HttpServletRequest req = (HttpServletRequest)joinpoint.getArgs()[0]; // 파라미터 배열의 첫번째 방번호 [0]
		HttpServletResponse res = (HttpServletResponse)joinpoint.getArgs()[1];
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String msg = "";
		String loc = "";
		if(loginuser==null || !"2".equals(loginuser.getMembertype())) {
			try {
//			2) 로그인 하지 않은 경우 로그인 페이지로 이동
				msg="병원 관리자로 로그인 후 이용 가능 합니다.";
				loc=req.getContextPath()+"/home.pet";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
//			3) 로그인 성공 후 로그인 전 페이지로 돌아가는 작업; req에 담겨있는 add.action URL 가져와서 세션에 저장
				String url = MyUtil.getCurrentURL(req);
				session.setAttribute("goBackURL", url);
				
//			4) 메시지와 함께 디스패쳐로 뷰 페이지로 보내기
				RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/msg.jsp");
				dispatcher.forward(req, res);
				
				return;
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}
		}
	}	// end of Adminbefore()
	// === 2019.02.07 ==== 끝 //
	
//	#포인트컷 생성하기; execution(public(생략가능) *(리턴타입 모두) com.spring..(com.spring다음 패키지 유무 상관없음)*Controller(controller객체).requireLogin_*(..)) 
	@Pointcut("execution(public * com.final2..*Controller.requireLoginAdmin_*(..))")
	public void requireLoginAdmin() {}	// 포인트컷의 식별자는 메소드명으로 지정
	
//	#Advice 만들기(보조업무); BeforeAdvice 선언 및 실행 내용 구현하기
	@Before("requireLoginAdmin()")
	public void Adminbefore(JoinPoint joinpoint) {
//		>> 포인트컷한 주업무의 메소드를 JoinPoint 객체로 가져옴
		
//		1) Controller에서 파라미터로 보낸 request객체를 통하여 session객체를 가져오기
		HttpServletRequest req = (HttpServletRequest)joinpoint.getArgs()[0]; // 파라미터 배열의 첫번째 방번호 [0]
		HttpServletResponse res = (HttpServletResponse)joinpoint.getArgs()[1];
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String msg = "";
		String loc = "";
		if(loginuser==null || !"3".equals(loginuser.getMembertype())) {
			try {
//			2) 로그인 하지 않은 경우 로그인 페이지로 이동
				msg="관리자로 로그인 후 이용 가능 합니다.";
				loc=req.getContextPath()+"/home.pet";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
//			3) 로그인 성공 후 로그인 전 페이지로 돌아가는 작업; req에 담겨있는 add.action URL 가져와서 세션에 저장
				String url = MyUtil.getCurrentURL(req);
				session.setAttribute("goBackURL", url);
				
//			4) 메시지와 함께 디스패쳐로 뷰 페이지로 보내기
				RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/msg.jsp");
				dispatcher.forward(req, res);
				
				return;
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}
		}
	}	// end of Adminbefore()
}
