<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	// 선택한 태그 리스트 불러오기
	List<HashMap<String, String>> haveTagList =  (List<HashMap<String, String>>)request.getAttribute("haveTagList");
%>
<style type="text/css">
	.profile label { 
		display: inline-block; 
		padding: 3% 4%;
		color: #999;
		font-size: inherit;
		line-height: normal; 
		vertical-align: middle; 
		cursor: pointer; 
	} 
	.profile input[type="file"] { 
		/* 파일 필드 숨기기 */
		position: absolute; 
		width: 1px; 
		height: 1px; 
		padding: 0; 
		margin: -1px; 
		overflow: hidden; 
		clip:rect(0,0,0,0); 
		border: 0; 
	}
	
	/* imaged preview */ 
	.filebox .upload-display { 
		/* 이미지가 표시될 지역 */ 
		margin-bottom: 5px; 
	} 
	
	.filebox .upload-thumb-wrap { 
		/* 추가될 이미지를 감싸는 요소 */ 
		display: inline-block; 
		vertical-align: middle; 
		border: 1px solid #ddd; 
		border-radius: 100%; 
		background-color: #fff; 
	} 
	
	.filebox .upload-display img { 
		/* 추가될 이미지 */
		display: block; 
		max-width: 100%; 
		width: 100%; 
		height: auto;
	}
	
	.radius-box {
	    width: 125px;
	    height:125px;
	    object-fit: cover;
	    object-position: top;
	    border-radius: 50%;
	}
	
	.btns {
		border:none; 
		background: inherit;
		font-size: 13pt;
	}
	
	.error {
		color: red;
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		$(".upload-hidden").hide();
		$(".error").hide();
		$(".pwdError").hide();
		$(".pwdCheckError").hide();
		$(".phoneError").hide();
		
		$("#userid").val("${mvo.userid}");
		$("#name").val("${mvo.name}");
		$("#nickname").val("${mvo.nickname}");
		$("#birthday").val("${mvo.birthday}");
		$("#phone").val("${mvo.phone}");
		
		// 이미지 크기 맞춤
	    $('.profile').css('height', $(".profile").width()-1);
	    $('.radius-box').css('width', $(".profile").width());
	    $('.radius-box').css('height', $(".radius-box").width()-1);
	    
		$(window).resize(function() { 
			$('.profile').css('height', $(".profile").width());
			$('.radius-box').css('height', $(".profile").width());
			$('.radius-box').css('width', $(".profile").width());
	    });
		
		// profile에 이미지 띄우기
		var imgTarget = $('.preview-image .upload-hidden'); 
		imgTarget.on('change', function(){ 
			var parent = $(this).parent(); 
			parent.children('.upload-display').remove(); 
			if(window.FileReader){ 
				//image 파일만
				if (!$(this)[0].files[0].type.match(/image\//)) return; 
				var reader = new FileReader(); 
				reader.onload = function(e){ 
					$("#beforeProfile").hide();
					var src = e.target.result; parent.prepend('<div class="profile upload-display"><div class="upload-thumb-wrap"><img width="100%" src="'+src+'" class="upload-thumb radius-box"></div></div>'); 
				} 
				reader.readAsDataURL($(this)[0].files[0]); 
				
				$(".profile").css('background-color','#f2f2f2');
			}
		}); // end of imgChange
		
		// 태그 보여주기
		<%
			for(int i=0; i<haveTagList.size(); i++) {
				String tagUid = haveTagList.get(i).get("FK_TAG_UID"); %>
				
				$("#tag<%=tagUid%>").prop("checked", true);
		<%    }	%>
		
		// 유효성 검사
		$(".must").each(function() {
			$(this).blur(function() {
				var data = $(this).val().trim();
				if(data == ""){
					$(this).parent().find(".error").show();
					return;
				} else{
					$(this).parent().find(".error").hide();
				} // end of if~else
			}); // end of $(this).blur();
		});// end of $(".must").each();
		
		// 비밀번호 유효성 검사
		$("#pwd").blur(function(){
			var passwd = $(this).val();
			var regExp_pw = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
			var isUsePasswd = regExp_pw.test(passwd);
			if(passwd.length != 0 && !isUsePasswd){
				$(".pwdError").show();
				$(this).val("");
				return;
			}
			else{
				$(".pwdError").hide();
			}
		});
		
		// 비밀번호 체크
		$("#pwdCheck").blur(function(){
			var password = $("#pwd").val();
			var pwdcheck = $(this).val();
			
			if(password != pwdcheck){
				$(".pwdCheckError").show();
				$(this).val("");
				return;
			} else {
				$(".pwdCheckError").hide();
			}	
		});
		
		// 핸드폰 검사
		$("#phone").blur(function(){
			var phone = $(this).val();
			var isUsePhone = false;
			var regExp_Phone = /^[0-9]+$/g;

			isUsePhone = regExp_Phone.test(phone);
			
			if(phone.length != 0 &&(!isUsePhone || phone.length != 11)) {
				$(".phoneError").show();
				$(this).val("");
				return;
			} else{
				$(".phoneError").hide();
			}	
		});
		
		$("#goEditBtn").click(function(){
			
			// 유효성 검사 -> 비밀번호 유효성이 안됨 ㅜㅜ
			$(".must").each(function() {
				var data = $(this).val().trim();
				
				if(data == ""){
					$(this).parent().find(".error").show();
					return;
				} else{
					$(this).parent().find(".error").hide();
				} // end of if~else
			});// end of $(".must").each();
			
			// 비밀번호 유효성 검사
			var passwd = $("#pwd").val();
			var regExp_pw = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
			var isUsePasswd = regExp_pw.test(passwd);
			if(passwd.length != 0 && !isUsePasswd){
				$(".pwdError").show();
				$(this).val("");
				return;
			} else{
				$(".pwdError").hide();
			}
			
			// 비밀번호 체크
			var password = $("#pwd").val();
			var pwdcheck = $("#pwdCheck").val();
			
			if(password != pwdcheck){
				$(".pwdCheckError").show();
				$(this).val("");
				return;
			} else {
				$(".pwdCheckError").hide();
			}	
			
			// 핸드폰 검사
			var phone = $("#phone").val();
			var isUsePhone = false;
			var regExp_Phone = /^[0-9]+$/g;

			isUsePhone = regExp_Phone.test(phone);
			
			if(phone.length != 0 &&(!isUsePhone || phone.length != 11)) {
				$(".phoneError").show();
				$(this).val("");
				return;
			} else{
				$(".phoneError").hide();
			}
			
			if(!$("input:radio[name=gender]").is(":checked")) {
				alert("성별을 선택하셔야 합니다.");
				return;
			} // end of if
			
			var index = 0;
            $(".tagsNo").each(function(){
				if(!$(this).is(':checked')) {
					// 체크가 안 된 것은 폼점송이 안되어지도록 비활성화 한다.
					$(this).parent().find(":input[name=tagName]").attr("disabled", true);
				} else {
					index++;
               } // if~else
            }); // end of $(".chkboxpnum").each();
            
            if(index > 5) {
            	alert("조건은 최대 5개까지만 가능합니다.");
            	
            	return;
            } // end of if
			
			var frm = document.editFrm;
			frm.action = "<%=request.getContextPath()%>/updateMember.pet";
			frm.method = "POST";
			frm.submit();
			
		}); // end of $("#goEditBtn").click();
		
		$("#goQuitBtn").click(function(){
			var bool = confirm("정말로 탈퇴하시겠습니까?");
			
			if(bool) {
				// 회원탈퇴
				location.href="<%=request.getContextPath()%>/updateMemberStatusOutByIdx.pet";
			} else {
				alert("취소!");
			}
		}); // end of $("#goQuitBtn").click();
		
	}); // end of $(document).ready();
	
</script>

<div class="container" > 
	<div class="col-sm-12" style="background-color: #f2f2f2; margin-top: 5%;">
		
		<div class="col-sm-12" align="center">
			<h2>일반회원 회원수정</h2> <%-- === 2019.02.15 === 제목 수정 --%>
		</div> 
		<div class="col-sm-12">
			<form name="editFrm" enctype="multipart/form-data">
				<div class="col-sm-offset-2 col-md-8 preview-image" style="margin-bottom: 20px;">
					<div class="row">
						<div class="col-sm-3">
							<div class="profile" style="background-color: #d9d9d9; height: 150px; border-radius: 100%;" align="center">
								<img id="beforeProfile" width="100%" src="<%=request.getContextPath() %>/resources/img/member/profiles/${mvo.fileName}" class="upload-thumb radius-box">
								<input type="hidden" name="beforeFile" value="${mvo.fileName}" size="40">
								<label for="input-file">프로필</label>
								<input type="file" class="upload-hidden must" id="input-file" name="attach"/>
							</div>
						</div>
						<div class="col-sm-9" style="padding-top: 28px;">
							<span style="color: #999;">ID(email)</span>
							<input type="text" class="form-control must" id="userid" name="userid" readonly="readonly"/>
						</div>
					</div>
					<br>
					<div class="row">
						<div class="col-sm-12">
							<span style="color: #999;">password</span>
							<input type="password" class="form-control must" id="pwd" name="pwd"/>
							<span class="error">필수 입력사항입니다.</span>
							<span class="pwdError" style="color: red;">비밀번호는 8~16자 영문자,숫자,특수문자 모두 포함해야합니다.</span>
						</div>
					</div>
					
					<div class="row">
						<div class="col-sm-12">
							<span style="color: #999;">password check</span>
							<input type="password" class="form-control must" id="pwdCheck" name="pwdCheck"/>
							<span class="error">필수 입력사항입니다.</span>
							<span class="pwdCheckError" style="color: red;">비밀번호가 일치하지 않습니다.</span>
						</div>
					</div>
					
					<div class="row">
						<div class="col-sm-6">
							<span style="color: #999;">name</span>
							<input type="text" class="form-control must" id="name" name="name"/>
							<span class="error">필수 입력사항입니다.</span>
						</div>
						
						<div class="col-sm-6">
							<span style="color: #999;">nickname</span>
							<input type="text" class="form-control must" id="nickname" name="nickname"/>
							<span class="error">필수 입력사항입니다.</span>
						</div>
					</div><!-- row -->
					
					<div class="row">
						<div class="col-sm-6">
							<span style="color: #999;">birthday</span>
							<input type="date" class="form-control must" id="birthday" name="birthday"/>
							<span class="error">필수 입력사항입니다.</span>
						</div>
						
						<div class="col-sm-6">
							<span style="color: #999;">gender</span><br>
							<input type="radio" class="" id="genderMale" name="gender" value="1"
							<c:if test="${mvo.gender == 1}">
								checked="checked"
							</c:if>
							>
							&nbsp;<label for="genderMale" style="color: #999;">남성</label>
							
							<input type="radio" class="" id="genderFemale" name="gender" value="2"
							<c:if test="${mvo.gender == 2}">
								checked="checked"
							</c:if>
							>
							&nbsp;<label for="genderFemale" style="color: #999;">여성</label>
							<br>
							<span class="error">필수 입력사항입니다.</span>
						</div>
					</div><!-- row -->
					
					<div class="row">
						<div class="col-sm-6">
							<span style="color: #999;">phone</span>
							<input type="text" class="form-control must" id="phone" name="phone"/>
							<span class="error">필수 입력사항입니다.</span>
							<span class="phoneError" style="color: red;">휴대전화는 11자 숫자만 가능합니다.</span>
						</div>
					</div><!-- row -->
					
					<div class="row tagList1" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">시설상태</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '시설상태'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}">
										&nbsp;<label style="color: #999;" for="tag${tag.TAG_UID}">&#35;${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}"/>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div><!-- row -->
					
					<div class="row tagList2" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">서비스</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '서비스'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}"/>
										&nbsp;<label style="color: #999;" for="tag${tag.TAG_UID}">&#35;${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}"/>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div><!-- row -->
					
					<div class="row tagList3" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">가격</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '가격'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}"/>
										&nbsp;<label style="color: #999;" for="tag${tag.TAG_UID}">&#35;${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}"/>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div><!-- row -->
					
					<div class="row tagList4" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">전문분야</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '전문분야'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}"/>
										&nbsp;<label style="color: #999;" for="tag${tag.TAG_UID}">&#35;${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}"/>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div><!-- row -->
					
					<div class="row tagList5" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">시간</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '시간'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}"/>
										&nbsp;<label style="color: #999;" for="tag${tag.TAG_UID}">&#35;${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}"/>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div><!-- row -->
					
					<div class="row tagList6" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">편의시설</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '편의시설'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}"/>
										&nbsp;<label style="color: #999;" for="tag${tag.TAG_UID}">&#35;${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}"/>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div><!-- row -->
					
					<hr style="height: 1px; background-color: #d9d9d9;border: none;"/>
				
					<div class="row">
						<div class="col-sm-offset-1 col-sm-3">
							<button type="button" class="btns" style="color: #999;" onclick="javascript:location.href='<%=request.getContextPath()%>/index.pet'">CANCEL</button>
						</div>
						<div class="col-sm-offset-1 col-sm-3">
							<button type="button" id="goEditBtn" class="btns" style="color: rgb(252, 118, 106);">SUBMIT</button>
						</div>
						<div class="col-sm-offset-1 col-sm-3">
							<button type="button" id="goQuitBtn" class="btns" style="color: rgb(252, 118, 106);">QUIT</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>