<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- === 2019.01.25 === 비번 변경 사용자 정보 확인 페이지 --%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("#findIdCheckMsg").hide();
		$("#failIdCheck").hide();
		
	});
	
	function checkUser() {
		
		$("#findIdCheckMsg").show();
		$("#failIdCheck").hide();
		
		var userid = $("#findPwUserid").val().trim();
		var name = $("#findPwName").val().trim();
		
		if(userid == null || userid == "") {
			alert("아이디를 입력하세요.");
			$("#findIdCheckMsg").hide();
			return;
		}
		
		if(name == null || name == "") {
			alert("이름을 입력하세요.");
			$("#findIdCheckMsg").hide();
			return;
		}
		
		var data = {"userid":userid,
					"name":name};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectCheckUser.pet",
			type: "POST",
			data: data,
			dataType: "JSON",
			success: function(json){
				if(json.status == 0) {
					$("#findIdCheckMsg").hide();
					$("#failIdCheck").show();
				} else {
					location.href = "<%=request.getContextPath()%>/findPwdCodeCheck.pet?certificationCode="+json.certificationCode+"&userEmail="+userid;
				}
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});// end of ajax
		
	} // end of function checkUser()
</script>

<div id="findIdCheck" class="col-sm-10">
	<form name="checkUserFrm">
		<div class="row">
			<div class="col-sm-offset-1 col-sm-10">
				<span style="color: #999;">ID</span>
				<input type="text" class="form-control" id="findPwUserid" name="userid" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
			</div>
		</div>
		
		<div class="row" style="margin-top: 20px;">
			<div class="col-sm-offset-1 col-sm-10">
				<span style="color: #999;">name</span>
				<input type="text" class="form-control" id="findPwName" name="name" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
			</div>
		</div>
		
		<div class="row" style="margin-top: 20px;">
			<div class="col-sm-offset-1 col-sm-10">
				<button type="button" class="form-control" onclick="checkUser();" style="background-color: rgb(252, 118, 106); color: white;">이메일 본인 인증하기</button>
			</div>
		</div>
	</form>
</div>

<div id="findIdCheckMsg" style="color: red; padding-left: 9%; margin-top: 5%;">
	입력하신 정보 확인중입니다....<br>
	잠시만 기다려주세요.
</div>

<div id="failIdCheck" style="color: red; padding-left: 9%; margin-top: 5%;">
	입력하신 정보의 사용자가 없습니다.
</div>
<%-- === 2019.01.25 === 비번 변경 사용자 정보 확인 페이지 --%>