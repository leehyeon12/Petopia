<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- === 2019.01.25 === 비번 변경 페이지 --%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">
	function changPwd() {
		
		var passwd = $("#changePwd").val().trim();
		var regExp_pw = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
		var isUsePasswd = regExp_pw.test(passwd);
		
		if(passwd.length != 0 && !isUsePasswd){
			alert("비밀번호는 8~16자 영문자,숫자,특수문자 모두 포함해야합니다.");
			$(this).val("");
			return;
		} // end of if
		
		var pwdcheck = $("#changePwdCheck").val().trim();
		
		if(passwd != pwdcheck){
			alert("비밀번호가 일치하지 않습니다.");
			$(this).val("");
			return;
		} // end of if
			
		var frm = document.changePwdFrm;
		frm.method = "POST";
		frm.action = "<%=request.getContextPath()%>/updatePwd.pet";
		frm.submit();
		
	} // end of function changPwd()
</script>

<%-- 비밀번호 수정 --%>
<div id="changePwdModal" class="col-sm-10">
	<form name="changePwdFrm">
		<div class="row" style="margin-top: 20px;">
			<div class="col-sm-offset-1 col-sm-10">
				<span style="color: #999;">새비밀번호</span>
				<input type="password" class="form-control" id="changePwd" name="pwd" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
			</div>
			
			<div class="col-sm-offset-1 col-sm-10" style="margin-top: 20px;">
				<span style="color: #999; margin-top: 20px;">새비밀번호 재입력</span>
				<input type="password" class="form-control" id="changePwdCheck" name="pwdCheck" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
				
				<input type="hidden" name="userid" value="${userid}">
			</div>
		</div>
	</form>
	<div class="row" style="margin-top: 20px;">
		<div class="col-sm-offset-1 col-sm-10">
			<button type="button" class="form-control" onclick="changPwd();" style="background-color: rgb(252, 118, 106); color: white;">확인</button>
		</div>
	</div>
</div>
<%-- === 2019.01.25 === 비번 변경 페이지 --%>