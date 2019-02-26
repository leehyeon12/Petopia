<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- === 2019.01.25 === 비번 변경 코드 확인 페이지 --%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">
	
	$(document).ready(function(){
		if("${fail}" != 1) {
			$("#failMsg").hide();
		} else {
			$("#failMsg").show();
		}
	});
	
	function codeCheck() {
		//var certificationCode = $("#certificationCode").val();
		var code = $("#passwdCode").val();
		var userid = $("#userEmail").html();
		
		//if(certificationCode == code) {
			location.href = "<%=request.getContextPath()%>/changePwd.pet?userid="+userid+"&code="+code;
		//} else {
			//alert("입력하신 코드가 일치하지 않습니다.");
			
			//return;
		//} // end of if~else
	} // end of 
</script>

<%-- 정보가 있는 경우 --%>
<div id="codeCheck" class="col-sm-10">
	<div class="row" style="margin-top: 20px;">
		<div class="col-sm-offset-1 col-sm-10">
			<span><span id="userEmail">${userEmail}</span>로 보낸<br> 인증번호를 입력해주세요.</span>
		</div>
	</div>
	
	<div class="row" style="margin-top: 20px;">
		<div class=" col-sm-offset-1 col-sm-10">
			<span style="color: #999;">인증번호</span>
			<input type="text" class="form-control" id="passwdCode" name="passwdCode" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
			<%-- <input type="hidden" id="certificationCode" value="${certificationCode}" style="display: none;"> --%>
		</div>
	</div>
	
	<div class="row" id="failMsg" style="margin-top: 20px;">
		<div class=" col-sm-offset-1 col-sm-10">
			<span style="color: red;">인증번호가 일치하지 않습니다!</span>
		</div>
	</div>
	
	<div class="row" style="margin-top: 20px;">
		<div class="col-sm-offset-1 col-sm-10">
			<button type="button" class="form-control" onclick="codeCheck();" style="background-color: rgb(252, 118, 106); color: white;">확인</button>
		</div>
	</div>
</div>
<%-- === 2019.01.25 === 비번 변경 코드 확인 페이지 --%>