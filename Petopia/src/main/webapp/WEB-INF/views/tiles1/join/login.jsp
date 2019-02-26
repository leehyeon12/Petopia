<%@page import="com.final2.petopia.model.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
	.btns {
		margin-top: 5px;
	}
	
	a {
		text-decoration: none;
	}
	
	a:hover {
		text-decoration: none;
	}
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		$("#pwd").keydown(function(event){
			if(event.keyCode == 13) {
				goLogin();
			}
		});
		
		$("#loginBtn").click(function(){
			goLogin();
		}); // end of $("#loginBtn").click()
		
		// ==== 2019.01.25 ==== 모달 닫으면 새로고침 //
		$(".modalColse").click(function(){
			javascript:history.go(0);
		});
		// ==== 2019.01.25 ==== 모달 닫으면 새로고침 //
		
	}); // end of $(document).ready();
	
	function goLogin() {
		var userid = $("#userid").val().trim();
		var pwd = $("#pwd").val().trim();
		
		if(userid == null || userid == "") {
			alert("아이디를 입력하세요!");
			
			return;
		}
		
		if(pwd == null || pwd == "") {
			alert("비밀번호를 입력하세요!");
			
			return;
		}
		
		var frm = document.loginFrm;
		frm.action = "<%=request.getContextPath()%>/loginSelect.pet";
		frm.method = "POST";
		frm.submit();
	} // end of function goLogin()
	
</script>

<%
	MemberVO loginuser = (MemberVO)request.getAttribute("loginuser");
	if(loginuser == null) {
		Cookie[] cookies = request.getCookies();
		
		String cookie_key = "";
		String cookie_value = "";
		boolean flag = false;
		
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				cookie_key = cookie.getName();
				if("saveUserid".equals(cookie_key)) {
					cookie_value = cookie.getValue();
					flag = true;
					break;
				} // end of if
			} // end of for
		} // end of if
%>

<div class="col-sm-12" style="margin-top: 5%; margin-bottom: 5%">
	<div class="row" align="center">
		<div class="col-sm-offset-2 col-md-8" style="background-color: #f2f2f2; margin-bottom: 20px; padding-bottom: 20px;">
			<div class="col-sm-offset-4 col-sm-4">
				<h3>Login</h3>
				<hr style="height: 1px; background-color: #d9d9d9;border: none;"/>
				<form name="loginFrm">
					<div class="form-group">
						<div class="input-group">
							<input type="text" class="form-control" id="userid" name="userid" placeholder="Login"
							<% if(flag == true) { %>
								value=<%=cookie_value %>
							<%} %>
							>
							<label for="uLogin" class="input-group-addon glyphicon glyphicon-user"></label>
						</div>
					</div> <!-- /.form-group -->

					<div class="form-group">
						<div class="input-group">
							<input type="password" class="form-control" id="pwd" name="pwd" placeholder="Password">
							<label for="uPassword" class="input-group-addon glyphicon glyphicon-lock"></label>
						</div> <!-- /.input-group -->
					</div> <!-- /.form-group -->
					
					<%-- === 2019.02.13 === 수정 --%>
					<div class="row">
						<button type="button" class="btn" id="loginBtn" style="background-color: rgb(252, 118, 106); color: white; width: 90%;">Login</button>
					</div>
					
					<div class="checkbox" align="left">
						<label>
							<input type="checkbox" name="saveUserid"
								<% if(flag == true) { %>
								checked="checked"
								<%} %>
							> Remember me
						</label>
					</div> <!-- /.checkbox -->
					
					<hr style="background-color: white; color: white; border: 2px solid white;">
					
					<div class="row">
						<span data-toggle="modal" data-target="#idFindModal" style="cursor: pointer; font-size: 8pt;">아이디 찾기</span>
						<span>&nbsp;|&nbsp;</span>
						<span data-toggle="modal" data-target="#pwFindModal" style="cursor: pointer; font-size: 8pt;">비밀번호 찾기</span>
						<span>&nbsp;|&nbsp;</span>
						<span style="cursor: pointer; font-size: 8pt;" onclick="javascript:location.href='join.pet'">회원가입</span>
					</div>
				</form>
				<%-- === 2019.02.13 === 수정 --%>
				
				<h4>OR</h4>
				<div class="row">
					<span>sns 로그인은 일반회원만 가능합니다.</span>
				</div>
				
				<div id="kakao-login-btn" style="text-align:center; margin-top:5px;"></div>
	   			<!-- *** 카카오 로그인 시작 *** -->
	   			<script type="text/javascript">
	   				Kakao.init('b5a80832c3cb255d6b0092b12fa51f95');
	   				Kakao.Auth.createLoginButton({
						container: '#kakao-login-btn',
						success: function(authObj) {
							Kakao.API.request({
								url: "/v1/user/me",
					        	success:function(res){
					        		var id = res.id;
					        		var email = res.kaccount_email;
					        		var nickname = res.properties.nickname;
					        		var profile = res.properties.thumbnail_image
									
					        		console.log("id: "+id+", email: "+email+", nickname: "+nickname+", profile: "+profile);
					        		var data ={"userid":email};
					        		
					        		$.ajax({
					        			url: "<%=request.getContextPath()%>/snsIdDuplicateCheck.pet",
					        			type: "POST",
					        			data: data,
					        			dataType: "JSON",
					        			success:function(json){
					        				if(json == 0) {
					        					// 회원의 아이디가 없는 경우 ==> 회원가입
					        					var frm = document.kakaoRegister;
					        					frm.userid.value=email;
					        					frm.nickname.value=nickname;
					        					
					        					frm.method="POST";
					      		        		frm.action="<%=request.getContextPath()%>/kakaoJoin.pet";
					      		        		frm.submit();
					        				} else if(json == 1) {
					        					// 회원의 아이디가 있는 경우 ==> 로그인
					        					// 이미 카카오 회원가입 과정을 거쳤으므로 아이디로만 검색 ==> 아이디는 고유하므로 1개만 뜸!
					        					var frm = document.kakaoLogin;
					      		        		frm.userid.value=email;  		        	
					      		        		
					      		        		frm.method="POST";
					      		        		frm.action="<%=request.getContextPath()%>/kakaoLogin.pet";
					      		        		frm.submit();
				      		        		  
					        				} else if(json == 2) {
					        					// 회원의 아이디는 있지만 사용이 불가능한 경우 ==> alert 관리자에게 문의 & 로그아웃!
					        					alert("이미 탈퇴한 회원이거나 잘 못된 회원입니다. 관리자에게 문의하세요!");
					        					// 카카오 로그아웃
					        					Kakao.Auth.getAccessToken(); // 일단 임시용... 되는지 확인은 로그아웃에서
					        				} // end of if else
					        			},
					        			error: function(request, status, error){
					    					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					        			}
					        		}); // end of ajax
					        	},fail:function(error){
					        		alert(JSON.stringify(error));
					        	} // end
							}); // end of Kakao.API.request()
						},
						fail: function(err) {
							alert(JSON.stringify(err));
						}
	   				}); // end of Kakao.Auth.createLoginButton()
	   			</script>
	   			<!-- *** 카카오 로그인 끝 *** -->
	   			
	   			<div id="naver_id_login" style="text-align:center">
	   				<a href="${url}" onClick="window.open(this.href,'_blank','width=400,height=600'); return false">
						<img width="223" src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png"/>
					</a>
				</div>
	   				  
				<!-- <button type="button" class="form-control btns" style="background-color: #2DB400; color: white; border: none;">Login with Naver</button> -->
				<!-- <button type="button" class="form-control btns" style="background-color: #80e5ff; color: white; border: none;">Login with Google</button>
				<button type="button" class="form-control btns" style="background-color: #3b5998; color: white; border: none;">Login with Facebook</button> -->
			</div>
		</div>
	</div>

	<form name="kakaoLogin">
		<input type="hidden" name="userid" />
	</form>
	
	<form name="kakaoRegister">
		<input type="hidden" name="userid" />
		<input type="hidden" name="nickname" />
	</form>
	
	<%-- 아이디 찾기는 cool sms 사용할 예정으로 나중에... --%>
	<%-- === 2019.01.24 === 아이디 찾기 위치 수정 및 나누기 --%>
	<div class="modal fade" id="idFindModal" role="dialog" style="margin-top: 10%;">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Find ID</h4>
				</div>
				
				<%-- === 2019.02.13 === --%>
				<div class="modal-body">
					<iframe src="<%=request.getContextPath()%>/findID.pet" style="width: 100%; height: 250px; border: none; overflow: hidden;"></iframe>
				</div>
				<%-- === 2019.02.13 === --%>
				
				<div class="modal-footer">
					<button type="button" class="btn btn-default modalColse" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<%-- === 2019.01.24 === 아이디 찾기 위치 수정 및 나누기 --%>
	
	<%-- === 2019.01.25 === 비번 찾기 코딩 --%>
	<%-- === 2019.01.24 === 비번 찾기 위치 수정 및 코딩 --%>
	<%-- status = 0; 초기값 / status = 1; 회원없음 / status = 2; 회원있음 / status = 3; 코드 불일치 / status = 4; 코드 일치 --%>
	<div class="modal fade" id="pwFindModal" role="dialog" style="margin-top: 10%;">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Find Password</h4>
				</div>
				
				<div class="modal-body">
					<iframe src="<%=request.getContextPath()%>/findPwd.pet" style="width: 100%; height: 250px; border: none; overflow: hidden;"></iframe>
				</div>	
				<div class="modal-footer">
					<button type="button" class="btn btn-default modalColse" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<%-- === 2019.01.24 === 비번 찾기 위치 수정 및 코딩 --%>
	<%-- === 2019.01.25 === 비번 찾기 코딩 --%>

</div>
<% } else { %>
	<script type="text/javascript">
		alert("이미 로그인 하셨습니다!!");
		location.href=histroy.back();
	</script>
<%	} %>