package com.final2.petopia.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.final2.petopia.common.AES256;
import com.final2.petopia.common.FileManager;
import com.final2.petopia.common.SHA256;
import com.final2.petopia.model.Biz_MemberVO;
import com.final2.petopia.service.InterBiz_MemberService;

@Controller
@Component
public class Biz_MemberController {
	@Autowired
	private InterBiz_MemberService service;
	
	@Autowired
	private AES256 aes;
	
	@Autowired
	private FileManager fileManager;
	
	public List<HashMap<String, String>> makeHalfTime() {
		List<HashMap<String, String>> halfTime = new ArrayList<HashMap<String, String>>();
		
		String hour = "";
		String time1 = "";
		String time2 = "";
		
		for(int i=0; i<24; i++) {
			if(i<10) {
				hour="0"+i;
			}
			else {
				hour = String.valueOf(i);
			}
			time1 = hour+":00";
			
			time2 = hour+":30";
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("time1", time1);
			map.put("time2", time2);
			halfTime.add(map);
			
		}
		return halfTime;
	}
	
	
	// 태그뿌리기
	@RequestMapping(value="/joinBizMember.pet", method={RequestMethod.GET})
	public String joinBizMember(HttpServletRequest req) {
		
		List<HashMap<String, String>> tagList = service.selectRecommendTagList();
		
		req.setAttribute("tagList", tagList);
		
		List<HashMap<String, String>> timeList = makeHalfTime();
		
		req.setAttribute("timeList", timeList);
		
		return "join/joinBizMember.tiles1";
	} // end of public String joinBizMember()
	
	// 아이디 중복
	@RequestMapping(value="/bizIdDuplicateCheck.pet", method={RequestMethod. GET})
	@ResponseBody
	public HashMap<String, String> bizIdDuplicateCheck(HttpServletRequest req) {
		
		HashMap<String, String> bizIdDuplicateMap = new HashMap<String, String>();
		
		String userid = req.getParameter("userid");
		
		int cnt = service.selectBizMemberIdIsUsed(userid);
		
		String msg = "";
		if(cnt == 0) {
			msg = "<span style='color: blue;'>사용가능한 아이디입니다.</span>";
		}
		else {
			msg = "<span  style='color: red;'>이미 사용중인 아이디입니다.</span>";
		}
		
		bizIdDuplicateMap.put("CNT", String.valueOf(cnt));
		bizIdDuplicateMap.put("MSG", msg);
		
		return bizIdDuplicateMap;
		
	}// end of bizIdDuplicateCheck()---------------
	
	
	@RequestMapping(value="/bizMemberInfo.pet", method={RequestMethod.GET})
	public String editBizMember() {
		
		return "biz/bizMemberInfo.tiles2";
	} // end of public String editBizMember()
	
	
	
	
	@RequestMapping(value="/bizDetail.pet", method={RequestMethod.GET})
	public String bizDetail(HttpServletRequest req) {
		
		String idx_biz = req.getParameter("idx_biz");
		req.setAttribute("idx_biz", idx_biz);
		
		// 1. 기업회원 vo 객체가져오기
		Biz_MemberVO bizmvo = service.selectBizMemberVOByIdx_biz(idx_biz);
		req.setAttribute("bizmvo", bizmvo);
		
		// 2. 태그목록가져오기
		List<String> tagList = service.selectBizTagList(idx_biz);
		req.setAttribute("tagList", tagList);
		
		// 3. 의료진가져오기
		List<HashMap<String, String>> docList = service.selectDocList(idx_biz);
		req.setAttribute("docList", docList);
		
		// 4. 기업추가이미지
		List<String> imgList = service.selectBizImgList(idx_biz);
		req.setAttribute("imgList", imgList);
		
		return "biz/bizDetail.tiles2";
	} // end of public String bizDetail()

	
	
	
	@RequestMapping(value="/joinBizMemberInsert.pet", method= {RequestMethod.POST})
	public String joinBizMemberInsert(MultipartHttpServletRequest req, Biz_MemberVO bmvo) {
		
		MultipartFile attach = bmvo.getAttach();

		if(!attach.isEmpty()) {
			HttpSession session = req.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root+"resources"+File.separator+"img"+File.separator+"member"+File.separator+"profiles";
			
			
			String newFileName = "";
			
			byte[] bytes = null; // 첨부파일을 WAS(톰캣)에 저장할때 사용되는 용도
			long fileSize = 0; // 파일크기를 읽어오기 위한 용도
			
			try {
				bytes = attach.getBytes(); // 첨부된 파일을 바이트 단위로 파일을 다 읽어오는 것
				
				newFileName = fileManager.doFileUpload(bytes, attach.getOriginalFilename(), path);
				// 첨부된 파일을 WAS(톰캣)의 디스크로 파일올리기를 하는 것
				
				
				bmvo.setFileName(newFileName);
				bmvo.setProfileimg(attach.getOriginalFilename());
				
			} catch (Exception e) {
				e.printStackTrace();
			} // end of try~catch
		} // end of if --> 첨부파일
		
		MultipartFile attach2 = bmvo.getAttach2();
		
		if(!attach2.isEmpty()) {
			HttpSession session = req.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root+"resources"+File.separator+"img"+File.separator+"member"+File.separator+"prontimg";
			
			
			String newFileName = "";
			
			byte[] bytes = null; // 첨부파일을 WAS(톰캣)에 저장할때 사용되는 용도
			long fileSize = 0; // 파일크기를 읽어오기 위한 용도
			
			try {
				bytes = attach2.getBytes(); // 첨부된 파일을 바이트 단위로 파일을 다 읽어오는 것
				
				newFileName = fileManager.doFileUpload(bytes, attach2.getOriginalFilename(), path);
				// 첨부된 파일을 WAS(톰캣)의 디스크로 파일올리기를 하는 것
				
				bmvo.setProntimg(newFileName);
				
			} catch (Exception e) {
				e.printStackTrace();
			} // end of try~catch
		} // end of if --> 첨부파일
		
		List<MultipartFile> addimgList = req.getFiles("addimg");
		
		List<HashMap<String, String>> addImgmapList = new ArrayList<HashMap<String, String>>();
		
		if(addimgList != null) {
			
			HttpSession session = req.getSession();
			String root = session.getServletContext().getRealPath("/"); 
			String path = root+"resources"+File.separator+"img"+File.separator+"member"+File.separator+"addimg";
			
			String newFileName = "";
			
			byte[] bytes = null;
			
			for(int i=0; i<addimgList.size(); i++) {
				try {
					bytes = addimgList.get(i).getBytes(); // 첨부파일의 내용물(byte)을 읽어옴.
					 
					 newFileName = fileManager.doFileUpload(bytes, addimgList.get(i).getOriginalFilename(), path);
					 
					 HashMap<String, String> addImgmap = new HashMap<String, String>();
					 
					 addImgmap.put("IMGFILENAME", newFileName);
					 
					 addImgmapList.add(addImgmap);
					 
				} catch (Exception e) {}
				
				
			} // end of for
			
		} // end of if
		
		
		String[] doctor = req.getParameterValues("doctor");
		String[] docdog = req.getParameterValues("docdog");
		String[] doccat = req.getParameterValues("doccat");
		String[] docsmallani = req.getParameterValues("docsmallani");
		String[] docetc = req.getParameterValues("docetc");
		
		String[] tagNoArr = req.getParameterValues("tagNo");
		String[] tagNameArr = req.getParameterValues("tagName");
		
		
		try {
			// member pwd, phone 암호화
			bmvo.setPwd(SHA256.encrypt(bmvo.getPwd()));
			bmvo.setPhone(aes.encrypt(bmvo.getPhone()));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} // end of try-catch
		
		
		int result = 0;
		if(tagNoArr != null && tagNameArr != null) {
			
			if(addImgmapList == null || addImgmapList.size() == 0) {
				// 태그가 있고 이미지가 없고 의사가 없는 경우 회원가입
				if(doctor == null || doctor.length == 0 || doctor[0] == "") {
					System.out.println(1);
					result = service.insertMemberByMvoTagList(bmvo, tagNoArr, tagNameArr);
				} else {
					System.out.println(2);
					// 태그가 있고 이미지가 없고 의사가 있는 경우 회원가입
					result = service.insertMemberByMvoTagListDoc(bmvo, tagNoArr, tagNameArr, doctor, docdog, doccat, docsmallani, docetc);
				}
			} else {
				if(doctor == null || doctor.length == 0|| doctor[0] == "") {
					// 태그가 있고 이미지가 있고 의사가 없는 경우 회원가입
					System.out.println(3);
					result = service.insertMemberByMvoTagListImg(bmvo, tagNoArr, tagNameArr, addImgmapList);
				} else {
					// 태그가 있고 이미지가 있고 의사가 있는 경우 회원가입
					System.out.println(4);
					result = service.insertMemberByMvoTagImgListDoc(bmvo, tagNoArr, tagNameArr,addImgmapList, doctor, docdog, doccat, docsmallani, docetc);
				}
				
			} // end
			
		} else {
			if(addImgmapList == null || addImgmapList.size() == 0) {
				if(doctor == null || doctor.length == 0|| doctor[0] == "") {
					// 태그가 없고 이미지도 없고 의사도없는 경우 회원가입
					System.out.println(5);
					result = service.insertMemberByMvo(bmvo);
				} else {
					// 태그가 없고 이미지도 없고 의사는 있는 경우 회원가입
					System.out.println(6);
					result = service.insertMemberByMvoDoc(bmvo, doctor, docdog, doccat, docsmallani, docetc);
				}
			} else {
				if(doctor == null || doctor.length == 0|| doctor[0] == "") {
					// 태그가 없고 이미지는 있고 의사는 없는 경우 회원가입
					System.out.println(7);
					result = service.insertMemberByMvoImg(bmvo, addImgmapList);
				} else {
					// 태그가 없고 이미지는 있고 의사도 있는 경우 회원가입
					System.out.println(8);
					result = service.insertMemberByMvoImgDoc(bmvo, addImgmapList, doctor, docdog, doccat, docsmallani, docetc);
				}
			
			}
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
	}
	

}
