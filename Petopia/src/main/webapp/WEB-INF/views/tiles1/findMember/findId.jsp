<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- === 2019.02.13 === --%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("#findIdCheckMsg").hide();
		$("#failIdCheck").hide();
		
	});
	
	function findId() {
		
		$("#findIdCheckMsg").show();
		$("#failIdCheck").hide();
		
		var name = $("#findIdName").val().trim();
		var phone = $("#findIdPhone").val().trim();
		
		if(name == null || name == "") {
			alert("이름을 입력하세요.");
			$("#findIdCheckMsg").hide();
			return;
		}
		
		if(phone == null || phone == "") {
			alert("휴대폰번호를 입력하세요.");
			$("#findIdCheckMsg").hide();
			return;
		}
		
		var data = {"name":name,
					"phone":phone};
		
		var html = "";
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectFindId.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				console.log(json);
				if(json == null || json == "") {
					$("#findIdCheckMsg").hide();
					$("#failIdCheck").show();
				} else {
					$("#findIdCheckMsg").hide();
					$("#failIdCheck").hide();
					
					html += "<span style='color: red;'>찾으시는 회원의 아이디는 ["+json+"]입니다.</span>";
					
					$("#resultId").html(html);
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
				<span style="color: #999;">NAME</span>
				<input type="text" class="form-control" id="findIdName" name="name" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
			</div>
		</div>
		
		<div class="row" style="margin-top: 20px;">
			<div class=" col-sm-offset-1 col-sm-10">
				<span style="color: #999;">PHONE</span>
				<input type="text" class="form-control" id="findIdPhone" name="phone" style="border: none; border-bottom: 2px solid rgb(252, 118, 106);"/>
			</div>
		</div>
		
		<div class="row" style="margin-top: 20px;">
			<div class="col-sm-offset-1 col-sm-10">
				<button type="button" onclick="findId();" class="form-control" style="background-color: rgb(252, 118, 106); color: white;">아이디 찾기</button>
			</div>
		</div>
	</form>
	<div class="row" style="margin-top: 20px;">
		<div class="col-sm-offset-1 col-sm-10" id="resultId">
		</div>
	</div>
</div>

<div id="findIdCheckMsg" style="color: red; padding-left: 9%; margin-top: 5%;">
	입력하신 정보 확인중입니다....<br>
	잠시만 기다려주세요.
</div>

<div id="failIdCheck" style="color: red; padding-left: 9%; margin-top: 5%;">
	입력하신 정보의 사용자가 없습니다.
</div>
<%-- === 2019.02.13 === --%>