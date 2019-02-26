package com.final2.petopia.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.final2.petopia.common.AES256;
import com.final2.petopia.common.FileManager;
import com.final2.petopia.common.MyUtil;
import com.final2.petopia.common.NaverLoginBO;
import com.final2.petopia.common.SHA256;
import com.final2.petopia.model.MemberVO;
import com.final2.petopia.service.InterMemberService;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.google.gson.Gson;

@Controller
public class MemberController {
	
	@Autowired
	private InterMemberService service;
	
	@Autowired
	private AES256 aes;
	 
	@Autowired
	private FileManager fileManager;

	// 네이버 로그인을 위한 naverLoginBO
	@Autowired
	private NaverLoginBO naverLoginBO;
	
	@Autowired
	private void setNaverLoginBO(NaverLoginBO naverLoginBO){
		this.naverLoginBO = naverLoginBO;
	}
	
	// === 2019.01.24 === gmail을 위해 //
	@Autowired
	private JavaMailSender mailSender;
	// === 2019.01.24 === gmail을 위해 //
	
	// *** 회원가입 *** //
	@RequestMapping(value="/join.pet", method={RequestMethod.GET})
	public String join() {
		
		return "join/join.tiles1";
	} // end of public String join()
	
	@RequestMapping(value="/joinMember.pet", method={RequestMethod.GET})
	public String joinMember(HttpServletRequest req) {
		
		List<HashMap<String, String>> tagList = service.selectRecommendTagList();
		
		req.setAttribute("tagList", tagList);
		
		return "join/joinMember.tiles1";
	} // end of public String join()
	
	@RequestMapping(value="/joinMemberInsert.pet", method={RequestMethod.POST})
	public String joinMemberInsert(MultipartHttpServletRequest req, MemberVO mvo) {
		
		MultipartFile attach = mvo.getAttach();
		
		if(!attach.isEmpty()) {
			HttpSession session = req.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root+"resources"+File.separator+"img"+File.separator+"member"+File.separator+"profiles";
			
			/*System.out.println(">>> 확인용 path => "+path);*/
			
			String newFileName = "";
			
			byte[] bytes = null; // 첨부파일을 WAS(톰캣)에 저장할때 사용되는 용도
			long fileSize = 0; // 파일크기를 읽어오기 위한 용도
			
			try {
				bytes = attach.getBytes(); // 첨부된 파일을 바이트 단위로 파일을 다 읽어오는 것
				
				newFileName = fileManager.doFileUpload(bytes, attach.getOriginalFilename(), path);
				// 첨부된 파일을 WAS(톰캣)의 디스크로 파일올리기를 하는 것
				
				/*System.out.println(">>> 확인용 newFileName ==> "+newFileName);*/
				
				mvo.setFileName(newFileName);
				mvo.setProfileimg(attach.getOriginalFilename());
				
			} catch (Exception e) {
				e.printStackTrace();
			} // end of try~catch
		} // end of if --> 첨부파일
		
		String[] tagNoArr = req.getParameterValues("tagNo");
		String[] tagNameArr = req.getParameterValues("tagName");
		
		/*System.out.println("userid : "+mvo.getUserid()+", pwd : "+mvo.getPwd()+", name : "+mvo.getName());
		System.out.println("nicname : "+mvo.getNickname()+", birthday : "+mvo.getBirthday()+", gender : "+mvo.getGender());
		System.out.println("phone : "+mvo.getPhone()+", newFileName : "+mvo.getFileName()+", OriginalFilename : "+mvo.getOrgFilename());
		
		for(int i=0; i<tagNoArr.length; i++) {
			
			System.out.println("tagNoArr[i]: "+tagNoArr[i]);
			System.out.println("tagNameArr[i]: "+tagNameArr[i]);
			
		} // end of for */
		
		try {
			// member pwd, phone 암호화
			mvo.setPwd(SHA256.encrypt(mvo.getPwd()));
			mvo.setPhone(aes.encrypt(mvo.getPhone()));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} // end of try-catch
		
		int result = 0;
		if(tagNoArr != null && tagNameArr != null) {
			// 태그가 있는 경우 회원가입
			result = service.insertMemberByMvoTagList(mvo, tagNoArr, tagNameArr);
		} else {
			// 태그가 없는 경우 회원가입
			result = service.insertMemberByMvo(mvo);
		} // end of if~else
		
		String msg = "";
		String loc = "";
		if(result == 1) {
			msg = "회원가입되었습니다.";
			loc = req.getContextPath()+"/index.pet";
		} else {
			msg = "회원가입 실패하였습니다.";
			loc = "javascript:histroy.back();";
		} // end of if
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	} // end of joinMemberInsert()
	
	// *** 아이디 중복 체크 *** //
	@RequestMapping(value="/idDuplicateCheck.pet", method={RequestMethod.GET})
	@ResponseBody
	public HashMap<String, String> idDuplicateCheck(HttpServletRequest req) {
		
		HashMap<String, String> idDuplicateMap = new HashMap<String, String>();
		
		String userid = req.getParameter("userid");
		//System.out.println("userid: "+userid);
		
		int cnt = service.selectMemberIdIsUsed(userid);
		
		String msg = "";
		if(cnt == 0) {
			msg = "<span style='color: blue;'>사용가능한 아이디입니다.</span>";
		} else {
			msg = "<span  style='color: red;'>이미 사용중인 아이디입니다.</span>";
		} // end of if~else
		
		idDuplicateMap.put("CNT", String.valueOf(cnt));
		idDuplicateMap.put("MSG", msg);
		//System.out.println("msg: "+idDuplicateMap.get("MSG"));
		
		return idDuplicateMap;
	} // end of public HashMap<String, String> idDuplicateCheck(HttpServletRequest req)
	
	// *** 로그인 화면 띄우기 *** //
	@RequestMapping(value="/login.pet", method={RequestMethod.GET})
	public String login(HttpServletRequest req, HttpSession session) {
		
		/* 네아로 인증 URL을 생성하기 위하여 getAuthorizationUrl을 호출 */
        String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
        
        /* 생성한 인증 URL을 View로 전달 */
        req.setAttribute("url", naverAuthUrl);
        
        /* ==== 2019.01.24 ==== 아이디 비번찾기를 위한 상태 표시 */
        //req.setAttribute("status", 0);
        /* ==== 2019.01.24 ==== 아이디 비번찾기를 위한 상태 표시 */
        
		return "join/login.tiles1";
	} // end of public String login(HttpServletRequest req, HttpSession session)
	
	// *** 일반 로그인 하기 *** //
	@RequestMapping(value="/loginSelect.pet", method={RequestMethod.POST})
	public String loginSelect(HttpServletRequest req, HttpServletResponse res) {
		
		String userid = req.getParameter("userid");
		String pwd = req.getParameter("pwd");
		String saveUserid = req.getParameter("saveUserid");
		
		pwd = SHA256.encrypt(pwd);
		
		HashMap<String, String> loginMap = new HashMap<String, String>();
		loginMap.put("USERID", userid);
		loginMap.put("PWD", pwd);
		
		MemberVO loginuser = service.loginSelectByUseridPwd(loginMap);
		
		String msg = "";
		String loc = "";
		if(loginuser == null) {
			// 아이디나 비번이 틀린 경우
			msg = "아이디 또는 비밀번호가 틀립니다.";
			loc = "javascript:history.back();";
		} else if(loginuser != null && loginuser.isIdleStatus() == true) {
			msg = "로그인 한 지 1년이 지나서 휴면계정이 되었습니다. 관리자에게 문의 바랍니다.";
			loc = "javascript:history.back();";
		} else {
			try {
				loginuser.setPhone(aes.decrypt(loginuser.getPhone()));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			HttpSession session = req.getSession();
			session.setAttribute("loginuser", loginuser);
			
			// 쿠키에 아이디 저장
			Cookie cookie = new Cookie("saveUserid", loginuser.getUserid());
			if(saveUserid != null) {
				cookie.setMaxAge(7*24*60*60);
			} else {
				cookie.setMaxAge(0);
			} 
			
			cookie.setPath("/");
			
			res.addCookie(cookie);
			
			msg = "로그인되었습니다.";
			if(session.getAttribute("goBackURL") != null) {
				loc = (String)session.getAttribute("goBackURL");
				
				session.removeAttribute("goBackURL");
			} else {
				loc = req.getContextPath()+"/index.pet";
			}// end of if~else
		} // end of if~else
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	} // end of public String loginSelect()
	
	// *** sns 로그인시 아이디 있는지 확인 *** //
	@RequestMapping(value="/snsIdDuplicateCheck.pet", method={RequestMethod.POST})
	@ResponseBody
	public int snsIdDuplicateCheck(HttpServletRequest req) {
		int result = 0;
		
		String userid = req.getParameter("userid");
		
		//System.out.println("userid : "+userid);
		
		int cnt = service.selectMemberIdIsUsed(userid);
		
		int status = 0;
		if(cnt != 0) {
			// 있는 경우, 아이디가 사용 가능한지 알아보기
			status = service.selectSNSMemberStatus(userid);
			
			if(status == 0) {
				// 사용 불가능한 경우
				result = 2;
			} else {
				// 사용가능한 경우
				result = 1;
			} // end of if~else
		} else {
			// 없는 경우
			result = 0;
		}
		
		// result 0: 아이디가 없는 경우, result 1: 아이디가 있는데 사용가능한 경우, result 2: 아이디가 있는데 사용이 불가능한 경우
	
		//System.out.println("result : "+result);
		
		return result;
	} // end of public int snsIdDuplicateCheck(HttpServletRequest req)
	
	// *** 카카오 로그인 *** //
	@RequestMapping(value="/kakaoLogin.pet", method={RequestMethod.POST})
	public String kakaoLogin(HttpServletRequest req) {
		
		String userid = req.getParameter("userid");
		
		// System.out.println("userid: "+userid);
		
		String msg = "";
		String loc = "";
		
		if(userid != null && !"".equals(userid)) {
			
			MemberVO loginuser = service.loginSelectByUserid(userid);
			
			if(loginuser == null) {
				// 아이디나 비번이 틀린 경우
				msg = "아이디 또는 비밀번호가 틀립니다.";
				loc = req.getContextPath()+"/login.pet";
			} else if(loginuser != null && loginuser.isIdleStatus() == true) {
				msg = "로그인 한 지 1년이 지나서 휴면계정이 되었습니다. 관리자에게 문의 바랍니다.";
				loc = "javascript:history.back();";
			} else {
				HttpSession session = req.getSession();
				session.setAttribute("loginuser", loginuser);
				
				msg = "로그인되었습니다.";
				if(session.getAttribute("goBackURL") != null) {
					loc = (String)session.getAttribute("goBackURL");
					
					session.removeAttribute("goBackURL");
				} else {
					loc = req.getContextPath()+"/index.pet";
				}// end of if~else
			} // end of if~else
		} else {
			msg = "로그인 실패";
			loc = req.getContextPath()+"/login.pet";
			//System.out.println("로그인실패!");
		} // end of if~else
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	} // end of public String kakaoLogin(HttpServletRequest req)
	
	// *** 카카오로 회원가입 *** //
	@RequestMapping(value="/kakaoJoin.pet", method={RequestMethod.POST})
	public String kakaoJoin(HttpServletRequest req) {
		
		String userid = req.getParameter("userid");
		String nickname = req.getParameter("nickname");
		
		MemberVO mvo = new MemberVO();
		mvo.setUserid(userid);
		mvo.setNickname(nickname);
		
		List<HashMap<String, String>> tagList = service.selectRecommendTagList();
		
		req.setAttribute("mvo", mvo);
		req.setAttribute("tagList", tagList);
		
		return "join/joinSNSMember.tiles1";
	} // end of public String kakaoJoin(HttpServletRequest req)
	
	// *** 네이버 로그인 *** //
	// 네이버 로그인  callback 처리(로그인 or 회원가입으로)
	@RequestMapping(value="/loginNaverCallback.pet", method={RequestMethod.GET})
	public String loginNaverCallback(HttpServletRequest req, HttpSession session) {
		// http://localhost:9090/petopia/loginNaverCallback.pet?code=RMF1bsSOMSzf9yO4&state=fadab7f5-41c1-40b4-b505-b7a45f7d36fa
		String code = req.getParameter("code");
		String state = req.getParameter("state");
		
		/* 네아로 인증이 성공적으로 완료되면 code 파라미터가 전달되며 이를 통해 access token을 발급 */
		OAuth2AccessToken oauthToken = null;
		try {
			oauthToken = naverLoginBO.getAccessToken(session, code, state);
		} catch (IOException e) {
			e.printStackTrace();
		} // end of try~catch
    	
		//로그인 사용자 정보를 읽어온다.
		String apiResult = "";
		try {
			apiResult = naverLoginBO.getUserProfile(oauthToken);
		} catch (IOException e) {
			e.printStackTrace();
		}
        System.out.println("result"+apiResult);
		
        int index = apiResult.indexOf("response");
        
        String json = apiResult.substring(index, apiResult.length());
        
        int index2 = json.indexOf("{");
        
        String jsonObject = json.substring(index2, json.length());
       
        JSONObject jsonObj = new JSONObject(jsonObject);
       
        String id = (String) jsonObj.get("id");
        String userid = (String) jsonObj.get("email");
        String name = (String) jsonObj.get("name");
        String nickname = (String) jsonObj.get("nickname");
        String gender = (String) jsonObj.get("gender");
        
        if("F".equals(gender)) {
        	// 여자
        	gender = "2";
        } else {
        	// 남자
        	gender = "1";
        }
  
		System.out.println(id+" "+userid+" "+name);
       
		MemberVO mvo = new MemberVO();
		mvo.setUserid(userid);
		mvo.setName(name);
		mvo.setNickname(nickname);
		mvo.setGender(gender);
		
		// 네이버 아이디 중복검사
		int cnt = service.selectMemberIdIsUsed(userid);	
		
		int status = 0; // 회원 상태
		if(cnt != 0) {
			// 있는 경우, 아이디가 사용 가능한지 알아보기
			status = service.selectSNSMemberStatus(userid);
			
			if(status == 0) {
				// 사용 불가능한 경우 ==> 로그인 불가 alert 띄우고 login 창으로
				String msg = "이미 탈퇴한 회원이거나 잘 못된 회원입니다. 관리자에게 문의하세요!";
				String loc = req.getContextPath()+"/login.pet";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
				
				return "msg";
			} else {
				// 사용가능한 경우 == > 로그인처리
				MemberVO loginuser = service.loginSelectByUserid(userid); // 로그인
				
				String msg = "";
				String loc = "";
				if(loginuser == null) {
					// 아이디나 비번이 틀린 경우
					msg = "아이디 또는 비밀번호가 틀립니다.";
					loc = req.getContextPath()+"/login.pet";
				} else if(loginuser != null && loginuser.isIdleStatus() == true) {
					msg = "로그인 한 지 1년이 지나서 휴면계정이 되었습니다. 관리자에게 문의 바랍니다.";
					loc = "javascript:history.back();";
				} else {
					session.setAttribute("loginuser", loginuser);
					
					msg = "로그인되었습니다.";
					if(session.getAttribute("goBackURL") != null) {
						loc = (String)session.getAttribute("goBackURL");
						
						session.removeAttribute("goBackURL");
					} else {
						loc = "window.close(); opener.document.location.href='"+req.getContextPath()+"/index.pet';";
					}// end of if~else
				} // end of if~else
				
				req.setAttribute("msg", msg);
				req.setAttribute("script", loc);
				
				return "msg";
			} // end of if~else
		} else {
			// 없는 경우 ==> sns회원가입으로
			List<HashMap<String, String>> tagList = service.selectRecommendTagList();
			
			req.setAttribute("mvo", mvo);
			req.setAttribute("tagList", tagList);
			
			return "join/joinSNSMember.tiles1";
		} // end of if~else
		
		// result 0: 아이디가 없는 경우, result 1: 아이디가 있는데 사용가능한 경우, result 2: 아이디가 있는데 사용이 불가능한 경우
	} // end of public String loginNaverCallback(HttpServletRequest req, HttpSession session)
	
	// *** 로그아웃 *** //
	@RequestMapping(value="/logout.pet", method={RequestMethod.GET})
	public String logout(HttpServletRequest req, HttpSession session) {
		session.invalidate();
		
		req.setAttribute("msg", "로그아웃되었습니다.");
		req.setAttribute("loc", req.getContextPath()+"/index.pet");
		
		return "msg";
	} // end of public String logout(HttpServletRequest req, HttpSession session)

	// *** 회원 정보 *** //
	@RequestMapping(value="/infoMember.pet", method={RequestMethod.GET})
	public String requireLogin_infoMember(HttpServletRequest req, HttpServletResponse res) {
		
		List<HashMap<String, String>> tagList = service.selectRecommendTagList();
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		// 로그인 한 사용자의 정보 가져오기
		MemberVO mvo = service.selectMemberByIdx(loginuser.getIdx());
		try {
			mvo.setPhone(aes.decrypt(mvo.getPhone()));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} // end of try~catch
		
		/*System.out.println("userid : "+mvo.getUserid()+", pwd : "+mvo.getPwd()+", name : "+mvo.getName());
		System.out.println("nicname : "+mvo.getNickname()+", birthday : "+mvo.getBirthday()+", gender : "+mvo.getGender());
		System.out.println("phone : "+mvo.getPhone()+", newFileName : "+mvo.getFileName()+", OriginalFilename : "+mvo.getProfileimg());*/
		
		// 저장된 사용자 태그 조회
		List<HashMap<String, String>> haveTagList = service.selectHave_tagByIdx(loginuser.getIdx());
		
		/*for(HashMap<String, String> haveTagMap : haveTagList) {
			
			System.out.println("FK_TAG_UID: "+haveTagMap.get("FK_TAG_UID"));
			System.out.println("FK_TAG_NAME: "+haveTagMap.get("FK_TAG_NAME"));
			 
		} // end of for	*/	
		
		req.setAttribute("tagList", tagList);
		req.setAttribute("mvo", mvo);
		req.setAttribute("haveTagList", haveTagList);
		
		return "member/infoMember.tiles2";
	} // end of requireLogin_infoMember
	
	// *** 회원 수정 *** //
	@RequestMapping(value="/updateMember.pet", method={RequestMethod.POST})
	public String requireLogin_updateMember(MultipartHttpServletRequest req, HttpServletResponse res, MemberVO mvo) {
		MultipartFile attach = mvo.getAttach();
		
		String beforeFile = req.getParameter("beforeFile");
		String[] tagNoArr = req.getParameterValues("tagNo");
		String[] tagNameArr = req.getParameterValues("tagName");
		
		if(!attach.isEmpty()) {
			
			HttpSession session = req.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root+"resources"+File.separator+"img"+File.separator+"member"+File.separator+"profiles";
			
			/*System.out.println(">>> 확인용 path => "+path);*/
			
			String newFileName = "";
			
			byte[] bytes = null; // 첨부파일을 WAS(톰캣)에 저장할때 사용되는 용도
			long fileSize = 0; // 파일크기를 읽어오기 위한 용도
			
			try {
				fileManager.doFileDelete(beforeFile, path);
				
				bytes = attach.getBytes(); // 첨부된 파일을 바이트 단위로 파일을 다 읽어오는 것
				
				newFileName = fileManager.doFileUpload(bytes, attach.getOriginalFilename(), path);
				// 첨부된 파일을 WAS(톰캣)의 디스크로 파일올리기를 하는 것
				
				/*System.out.println(">>> 확인용 newFileName ==> "+newFileName);*/
				
				mvo.setFileName(newFileName);
				mvo.setProfileimg(attach.getOriginalFilename());
				
			} catch (Exception e) {
				e.printStackTrace();
			} // end of try~catch
		} // end of if --> 첨부파일이 있는 경우
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		// mvo에 idx 넣기
		mvo.setIdx(loginuser.getIdx());
		
		/*System.out.println("idx: "+mvo.getIdx()+", userid : "+mvo.getUserid()+", pwd : "+mvo.getPwd()+", name : "+mvo.getName());
		System.out.println("nicname : "+mvo.getNickname()+", birthday : "+mvo.getBirthday()+", gender : "+mvo.getGender());
		System.out.println("phone : "+mvo.getPhone()+", newFileName : "+mvo.getFileName()+", OriginalFilename : "+mvo.getProfileimg());*/
		
		try {
			// member pwd, phone 암호화
			mvo.setPwd(SHA256.encrypt(mvo.getPwd()));
			mvo.setPhone(aes.encrypt(mvo.getPhone()));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} // end of try-catch
		
		int result = 0;
		if(attach.isEmpty()) {
			/*System.out.println("!!!!!!!!!!!!!!!파일없는경우!!!!!!!!!!!!!!!!!");*/
			// 첨부파일이 없는 경우 --> 기존의 이미지 파일을 쓰는 경우
			if(tagNoArr != null && tagNameArr != null) {
				// 태그가 있는 경우 회원수정
				result = service.updateMemberByMvoTagListNoProfile(mvo, tagNoArr, tagNameArr);
			} else {
				// 태그가 없는 경우 회원수정
				result = service.updateMemberByMvoNoProfile(mvo);
			} // end of if~else
		} else {
			// 첨부 파일이 있는 경우
			if(tagNoArr != null && tagNameArr != null) {
				// 태그가 있는 경우 회원수정
				/*for(int i=0; i<tagNoArr.length; i++) {
					
					System.out.println("tagNoArr[i]: "+tagNoArr[i]);
					System.out.println("tagNameArr[i]: "+tagNameArr[i]);
					
				} // end of for
				*/
				result = service.updateMemberByMvoTagList(mvo, tagNoArr, tagNameArr);
			} else {
				// 태그가 없는 경우 회원수정
				result = service.updateMemberByMvo(mvo);
			} // end of if~else
		} // end of if~else
		
		String msg = "";
		String loc = "";
		if(result == 1) {
			msg = "회원 수정되었습니다.";
			loc = req.getContextPath()+"/infoMember.pet";
		} else {
			msg = "회원 수정 실패했습니다.";
			loc = "javascript:histroy.back();";
		} // end of if
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	} // end of editMember()
	
	// *** 회원 탈퇴 *** //
	@RequestMapping(value="/updateMemberStatusOutByIdx.pet", method={RequestMethod.GET})
	public String requireLogin_updateMemberStatusOutByIdx(HttpServletRequest req, HttpServletResponse res) {
		
		// 회원 번호
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		int idx = loginuser.getIdx();
		
		// 회원 탈퇴 --> login_log의 status를 0으로
		int result = service.updateMemberStatusOutByIdx(idx);
		
		String msg = "";
		String loc = "";
		if(result == 1) {
			msg = "회원 탈퇴되었습니다.";
			loc = req.getContextPath()+"/home.pet";
			
			session.invalidate();
		} else {
			msg = "회원 탈퇴 실패하였습니다.";
			loc = "javascript:histroy.back();";
		} // end of if
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		return "msg";
	} // end of public String requireLogin_updateMemberStatusOutByIdx()

	// *** 관리자 *** //
	// *** 회원 목록 *** //
	@RequestMapping(value="/adminMember.pet", method={RequestMethod.GET})
	public String requireLoginAdmin_adminListMember(HttpServletRequest req, HttpServletResponse res) {
		
		return "admin/member/listMember.tiles2";
	} // end of requireLoginAdmin_infoMember
	
	@RequestMapping(value="/selectMemberList.pet", method={RequestMethod.GET})
	@ResponseBody
	public List<MemberVO> requireLoginAdmin_selectMemberList(HttpServletRequest req, HttpServletResponse res) {
		
		List<MemberVO> memberList = null;
		
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");
		
		String searchWhat = req.getParameter("searchWhat");
		String search = req.getParameter("search");
		String orderBy = req.getParameter("orderBy");
		
		// 페이징처리
		int totalCount = 0;
		int sizePerPage = 10;
		int currentShowPageNo = 0;
		int totalPage = 0;
		
		int startRno = 0;
		int endRno = 0;
		
		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("SEARCHWHAT", searchWhat);
		paraMap.put("SEARCH", search);
		paraMap.put("ORDERBY", orderBy);
		
		// System.out.println("searchWhat: "+searchWhat+", search: "+search+", orderBy: "+orderBy);
		
		// 해당하는 총회원 수
		if(search == null || "".equals(search)) {
			totalCount = service.selectTotalCount();
		} else if(search != null && !"".equals(search)) {
			totalCount = service.selectTotalCountBySearch(paraMap);
		}
		
		// 총페이지
		totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		
		// 페이지 currentShowPageNo
		if(str_currentShowPageNo == null || "".equals(str_currentShowPageNo)) {
			currentShowPageNo = 1;
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1;
				}
			} catch (NumberFormatException e) {
				currentShowPageNo = 1;
			} // end of try~catch
		} // end of if~else
		
		startRno = ((currentShowPageNo-1) * sizePerPage) + 1;
		endRno = (currentShowPageNo * sizePerPage);
		
		paraMap.put("STARTRNO", String.valueOf(startRno));
		paraMap.put("ENDRNO", String.valueOf(endRno));
		
		// member List조회
		/* === 2019.01.24 ==== 관리자 회원 리스트 코딩 */
		if((search == null || "".equals(search)) && (orderBy == null || "".equals(orderBy))) {
			// 검색X정렬X
			memberList = service.selectMemberList(paraMap);
		} else if((search == null || "".equals(search)) && (orderBy != null && !"".equals(orderBy))) {
			// 검색X정렬O
			memberList = service.selectMemberListByOrderBy(paraMap);
		} else if((search != null && !"".equals(search)) && (orderBy == null || "".equals(orderBy))) {
			// 검색O정렬X
			memberList = service.selectMemberListBySearch(paraMap);
		} else if((search != null && !"".equals(search)) && (orderBy != null && !"".equals(orderBy))) {
			// 검색X정렬O
			memberList = service.selectMemberListBySearchOrderBy(paraMap);
		} // end of if~else if
		/* === 2019.01.24 ==== 관리자 회원 리스트 코딩 */
		
		for(MemberVO mvo : memberList) {
			try {
				mvo.setPhone(aes.decrypt(mvo.getPhone()));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			} // end of try-catch
		} // end of for
		
		return memberList;
	} // end of public List<MemberVO> requireLoginAdmin_selectMemberList(HttpServletRequest req, HttpServletResponse res)
	
	// 페이지바
	@RequestMapping(value="/selectMemberListPageBar.pet", method={RequestMethod.GET})
	@ResponseBody
	public int selectMemberListPageBar(HttpServletRequest req) {
		
		String searchWhat = req.getParameter("searchWhat");
		String search = req.getParameter("search");
		String orderBy = req.getParameter("orderBy");
		
		// 페이징처리
		int totalCount = 0;
		int sizePerPage = 10;
		int totalPage = 0;
		
		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("SEARCHWHAT", searchWhat);
		paraMap.put("SEARCH", search);
		paraMap.put("ORDERBY", orderBy);
		
		// === 2019.01.25 === 주석 //
		// System.out.println("searchWhat: "+searchWhat+", search: "+search+", orderBy: "+orderBy);
		// === 2019.01.25 === 주석 //
		
		// 해당하는 총회원 수
		if(search == null || "".equals(search)) {
			totalCount = service.selectTotalCount();
		} else if(search != null && !"".equals(search)) {
			totalCount = service.selectTotalCountBySearch(paraMap);
		}
		
		// 총페이지
		totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		
		return totalPage;
	} // end of public int selectMemberListPageBar()
	
	// *** 회원 정보 *** //
	@RequestMapping(value="/adminInfoMember.pet", method={RequestMethod.GET})
	public String requireLoginAdmin_adminInfoMember(HttpServletRequest req, HttpServletResponse res) {
		
		String str_idx = req.getParameter("idx");
		String goBackURL = req.getParameter("goBackURL");
		
		MemberVO mvo = null;
		List<HashMap<String, String>> haveTagList = null;
		int idx = 0;
		if(str_idx == null || "".equals(str_idx)) {
			mvo = null;
		} else {
			try {
				idx = Integer.parseInt(str_idx);
				
				mvo = service.selectMemberByIdx(idx);
				haveTagList = service.selectHave_tagByIdx(idx);
			} catch (NumberFormatException e) {
				mvo = null;
			} // try~catch
		} // if~else
		
		if(mvo == null) {
			// msg로 보내서 없다고 띄우고 뒤로가기!
			req.setAttribute("msg", "해당하는 회원의 정보가 없습니다!");
			req.setAttribute("loc", "javascript:histroy.back();");
			
			return "msg";
		} else {
			// 회원정보를 담아서 회원정보 페이지로
			try {
				mvo.setPhone(aes.decrypt(mvo.getPhone()));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			} // end of try~catch
			
			req.setAttribute("mvo", mvo);
			req.setAttribute("haveTagList", haveTagList);
			req.setAttribute("goBackURL", goBackURL);
			
			return "admin/member/adminInfoMember.tiles2";
		} // end of if~else
		
	} // end of public String requireLoginAdmin_adminInfoMember()
	
	// *** 회원 휴면계정 해제 *** //
	@RequestMapping(value="/updateAdminMemberDateByIdx.pet", method={RequestMethod.POST})
	@ResponseBody
	public int requireLoginAdmin_updateAdminMemberDateByIdx(HttpServletRequest req, HttpServletResponse res) {
		int result = 0;
		
		String str_idx = req.getParameter("idx");
		
		int idx = 0;
		if(str_idx == null || "".equals(str_idx)) {
			result = 0;
		} else {
			try {
				idx = Integer.parseInt(str_idx);
				
				result = service.updateAdminMemberDateByIdx(idx);
			} catch (NumberFormatException e) {
				result = 0;
			} // try~catch
		} // if~else
		
		return result;
	} // end of public int requireLoginAdmin_updateAdminMemberDateByIdx(HttpServletRequest req, HttpServletResponse res)
	
	@RequestMapping(value="/updateAdminMemberStatusOutByIdx.pet", method={RequestMethod.POST})
	@ResponseBody
	public int requireLoginAdmin_updateAdminMemberStatusOutByIdx(HttpServletRequest req, HttpServletResponse res) {
		int result = 0;
		
		String str_idx = req.getParameter("idx");
		
		int idx = 0;
		if(str_idx == null || "".equals(str_idx)) {
			result = 0;
		} else {
			try {
				idx = Integer.parseInt(str_idx);
				
				result = service.updateMemberStatusOutByIdx(idx);
			} catch (NumberFormatException e) {
				result = 0;
			} // try~catch
		} // if~else
		
		return result;
	} // end of public int requireLoginAdmin_updateAdminMemberStatusOutByIdx(HttpServletRequest req, HttpServletResponse res)
	
	// *** 회원 복원 *** //
	@RequestMapping(value="/updateAdminMemberStatusInByIdx.pet", method={RequestMethod.POST})
	@ResponseBody
	public int requireLoginAdmin_updateAdminMemberStatusInByIdx(HttpServletRequest req, HttpServletResponse res) {
		int result = 0;
		
		String str_idx = req.getParameter("idx");
		
		int idx = 0;
		if(str_idx == null || "".equals(str_idx)) {
			result = 0;
		} else {
			try {
				idx = Integer.parseInt(str_idx);
				
				result = service.updateMemberStatusInByIdx(idx);
			} catch (NumberFormatException e) {
				result = 0;
			} // try~catch
		} // if~else
		
		return result;
	} // end of public int requireLoginAdmin_updateAdminMemberStatusInByIdx(HttpServletRequest req, HttpServletResponse res)

	// *** 비밀번호 찾기 *** //
	// === 2019.01.25 === 비밀번호 찾기 수정 //
	// 비밀번호 찾는 모달
	@RequestMapping(value="/findPwd.pet", method={RequestMethod.GET})
	public String findPwd() {
		
		return "tiles1/findMember/findPwd";
	} // end of public String findPwd()
	
	// === 2019.01.24 === 비밀번호 찾기 시작 //
	// 아이디와 이메일로 회원이 있는지 찾고 있을 경우 이메일로 보내기
	@RequestMapping(value="/selectCheckUser.pet", method={RequestMethod.POST})
	@ResponseBody
	public HashMap<String, String> selectCheckUser(HttpServletRequest req) { // HashMap으로 바꾸기 ==> status와 code보내기 위해
		
		HashMap<String, String> resultMap = new HashMap<String, String>();
		
		String userid = req.getParameter("userid");
		String name = req.getParameter("name");
		
		HashMap<String, String> paramap = new HashMap<String, String>();
		paramap.put("USERID", userid);
		paramap.put("NAME", name);
		
		// 아이디와 이메일로 회원이 있는지 찾기
		int cnt = service.selectMemberIsByUseridEmail(paramap);
		
		int status = 0;
		if(cnt == 0) {
			// 회원이 없는 경우
			status = 0; // 회원이 없음
		} else {
			// 코드 생성
			// 인증키를 랜덤하게 생성하도록 한다.
			Random rnd = new Random();
			
			String certificationCode = "";
			
			char randchar = ' ';
			for(int i=0; i<4; i++) {
				randchar = (char)(rnd.nextInt('z'-'a'+1) + 'a');
				
				certificationCode += randchar;
			} // 문자
			
			int randnum = 0;
			for(int i=0; i<4; i++) {
				randnum = rnd.nextInt(9-0+1)+0;
				certificationCode += randnum;
			} // 숫자
			
			// 메일 보내기
			String setfrom = "certification.test.0222@gmail.com";
			String toMail = userid;
			String title = "[PETOPIA]비밀번호 찾기를 위한 코드입니다.";
			String content = "코드 : "+certificationCode;
			
			try {
			      MimeMessage message = mailSender.createMimeMessage();
			      MimeMessageHelper messageHelper 
			                        = new MimeMessageHelper(message, true, "UTF-8");
			 
			      messageHelper.setFrom(setfrom);  // 보내는사람 생략하거나 하면 정상작동을 안함
			      messageHelper.setTo(toMail);     // 받는사람 이메일
			      messageHelper.setSubject(title); // 메일제목은 생략이 가능하다
			      messageHelper.setText(content);  // 메일 내용
			     
			      mailSender.send(message);
		    } catch(Exception e){
		      e.printStackTrace();
		    } // end of try-catch
			
			status = 1;
			
			resultMap.put("certificationCode", certificationCode);
		} // enf of if~else
		
		// System.out.println("cnt: "+cnt);
		
		resultMap.put("status", String.valueOf(status));
		
		return resultMap;
	} // end of public int selectCheckUser(HttpServletRequest req)
	// === 2019.01.24 === 비밀번호 찾기 //
	
	String code = "";
	// 코드 입력하는 창으로 이동
	@RequestMapping(value="/findPwdCodeCheck.pet", method={RequestMethod.GET})
	public String findPwdCodeCheck(HttpServletRequest req) {
		
		String certificationCode = req.getParameter("certificationCode");
		String userEmail = req.getParameter("userEmail");
		code = certificationCode;
		
		//System.out.println("======================================================");
		//System.out.println("certificationCode: "+certificationCode);
		//System.out.println("userEmail: "+userEmail);
		
		req.setAttribute("certificationCode", certificationCode);
		req.setAttribute("userEmail", userEmail);
		
		return "tiles1/findMember/findPwdCodeCheck";
	} // end of public String findPwdCodeCheck(HttpServletRequest req)
	
	// 비밀번호 수정 페이지
	@RequestMapping(value="/changePwd.pet", method={RequestMethod.GET})
	public String changePwd(HttpServletRequest req) {
		
		String userid = req.getParameter("userid");
		String userCode = req.getParameter("code");
		System.out.println("code: "+code);
		
		if(code.equals(userCode)) {
			// 일치하는 경우
			req.setAttribute("userid", userid);
			
			return "tiles1/findMember/changePwd";
		} else {
			// 불일치하는 경우
			req.setAttribute("userEmail", userid);
			req.setAttribute("fail", 1);
			
			return "tiles1/findMember/findPwdCodeCheck";
		} // end of if~else
	} // end of public String changePwd(HttpServletRequest req)
	
	// 비밀번호 변경
	@RequestMapping(value="/updatePwd.pet", method={RequestMethod.POST})
	public String updatePwd(HttpServletRequest req) {
		String userid = req.getParameter("userid");
		String pwd = req.getParameter("pwd");
		
		pwd = SHA256.encrypt(pwd);
		
		HashMap<String, String> paramap = new HashMap<String, String>();
		paramap.put("USERID", userid);
		paramap.put("PWD", pwd);
		
		int result = service.updateMemberPwdByUserid(paramap);
		
		String msg = "";
		if(result == 0) {
			msg = "비밀번호 변경에 실패하였습니다.";
		} else {
			msg = "비밀번호가 변경되었습니다.";
		} // end of if~else
		
		req.setAttribute("msg", msg);
		
		return "tiles1/findMember/changePwdFinish"; // 비밀번호 완료 페이지로 이동
	} // end of public String updatePwd(HttpServletRequest req)
	// === 2019.01.25 === 비밀번호 찾기 수정 //
	
	// === 2019.02.13 === 아이디 찾기 //
	// 비밀번호 찾는 모달
	@RequestMapping(value="/findID.pet", method={RequestMethod.GET})
	public String findId() {
		
		return "tiles1/findMember/findId";
	} // end of public String findId()
	
	@RequestMapping(value="/selectFindId.pet", method={RequestMethod.GET})
	@ResponseBody
	public String selectFindId(HttpServletRequest req) {
		String findId = "";
		
		String name = req.getParameter("name");
		String phone = req.getParameter("phone");
		
		HashMap<String, String> paraMap = new HashMap<String, String>();

		try {
			paraMap.put("NAME", name);
			paraMap.put("PHONE", aes.encrypt(phone));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} // end of try catch
		
		findId = service.selectMemberIdByNamePhone(paraMap);
		//System.out.println("findId: "+findId);
		
		Gson gson = new Gson();
		String gson_findId = gson.toJson(findId);
		return gson_findId;
	} // end of public String selectFindId(HttpServletRequest req)
	// === 2019.02.13 === 아이디 찾기 //
}