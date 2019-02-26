<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
		

	}); // end of $(document).ready();
	
	// *** 휴면계정 해제 *** //
	function memberUpdate(idx) { 
		var bool = confirm("해당 회원의 상태를 휴면 해제로 변경하시겠습니까?");
		
		var data = {"idx":idx};
		
		if(bool) {
			$.ajax({
				url: "<%=request.getContextPath()%>/updateAdminMemberDateByIdx.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					if(json == 0) {
						alert("휴면 해제가 실패되었습니다.");
						window.location.reload();
					} else {
						alert("휴면 해제되었습니다.");
						window.location.reload();
					} // end of if~else
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax
		} else {
			alert("취소되었습니다.");
		} // end of if~else
	} // end of function memberUpdate(idx)
	
	// *** 회원 탈퇴 ***//
	function memberOut(idx) { // 탈퇴
		var bool = confirm("해당 회원의 상태를 탈퇴 상태로 변경하시겠습니까?");
	
		var data = {"idx":idx};
	
		if(bool) {
			$.ajax({
				url: "<%=request.getContextPath()%>/updateAdminMemberStatusOutByIdx.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					if(json == 0) {
						alert("탈퇴가 실패되었습니다.");
						window.location.reload();
					} else {
						alert("탈퇴되었습니다.");
						window.location.reload();
					} // end of if~else
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax
		} else {
			alert("취소되었습니다.");
		} // end of if~else
	} // end of function memberOut(idx)
	
	function memberIn(idx) { // 복귀
		var bool = confirm("해당 회원의 상태를 활동 상태로 변경하시겠습니까?");
		
		var data = {"idx":idx};
	
		if(bool) {
			$.ajax({
				url: "<%=request.getContextPath()%>/updateAdminMemberStatusInByIdx.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					if(json == 0) {
						alert("복원이 실패되었습니다.");
						window.location.reload();
					} else {
						alert("복원되었습니다.");
						window.location.reload();
					} // end of if~else
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax
		} else {
			alert("취소되었습니다.");
		} // end of if~else
	} // end of function memberIn(idx)
	
</script>

<div class="container" style="margin-top: 15px; margin-bottom: 15px;">
	<div class="col-sm-12" style="margin-top: 20px;background-color: #f2f2f2;">
		<div class="col-sm-12" align="center">
			<h2>${mvo.name}님 회원정보</h2>
		</div>
		
		<div class="col-sm-12">
			<div class="col-sm-offset-2 col-md-8 preview-image" style="margin-bottom: 20px;">
				<div class="row">
					<div class="col-sm-3">
						<div class="profile" style="height: 150px; border-radius: 100%;" align="center">
							<img width="100%" src="<%=request.getContextPath() %>/resources/img/member/profiles/${mvo.fileName}" class="upload-thumb radius-box">
						</div>
					</div>
					<div class="col-sm-9" style="padding-top: 28px;">
						<span style="color: #999;">ID(email)</span>
						<input type="text" class="form-control must" id="userid" name="userid" value="${mvo.userid}" readonly="readonly"/>
					</div>
				</div>
				<br>
				
				<div class="row">
					<div class="col-sm-6">
						<span style="color: #999;">name</span>
						<input type="text" class="form-control must" id="name" name="name" value="${mvo.name}" readonly="readonly"/>
					</div>
					
					<div class="col-sm-6">
						<span style="color: #999;">nickname</span>
						<input type="text" class="form-control must" id="nickname" name="nickname" value="${mvo.nickname}" readonly="readonly"/>
					</div>
				</div><!-- row -->
				
				<div class="row">
					<div class="col-sm-6">
						<span style="color: #999;">birthday</span>
						<input type="date" class="form-control must" id="birthday" name="birthday" value="${mvo.birthday}" readonly="readonly"/>
					</div>
					
					<div class="col-sm-6">
						<span style="color: #999;">gender</span><br>
						<input type="text" class="form-control" readonly="readonly"
						<c:if test="${mvo.gender == 1}">
							value="남성"
						</c:if>
						
						<c:if test="${mvo.gender == 2}">
							value="여성"
						</c:if>
						>
					</div>
				</div><!-- row -->
				
				<div class="row">
					<div class="col-sm-6">
						<span style="color: #999;">phone</span>
						<input type="text" class="form-control must" id="phone" name="phone" value="${mvo.phone}" readonly="readonly"/>
					</div>
				</div><!-- row -->
				
				<div class="row tagList2" style="margin-top: 3%;">
					<div class="col-sm-2">
						<span style="color: #999;">보유태그</span>
					</div>
					<div class="col-sm-10">
						<c:forEach var="tag" items="${haveTagList}">
							<div class="col-sm-4">
								<label style="color: #999;" for="tag1">#${tag.FK_TAG_NAME}</label>
							</div>
						</c:forEach>
					</div>
				</div><!-- row -->
				
				<hr style="height: 1px; background-color: #d9d9d9;border: none;"/>
			
				<div class="row">
					<div class="col-sm-offset-1 col-sm-5">
						<button type="button" class="btns" style="color: #999;" onclick="javascript:location.href='<%=request.getContextPath()%>/adminMember.pet'">CANCEL</button>
					</div>
					<c:if test="${mvo.lastlogindategap >= 12}">
						<div class="col-sm-offset-1 col-sm-5">
							<button type="button" id="goJoinBtn" class="btns" onclick="memberUpdate(${mvo.idx});" style="color: rgb(252, 118, 106);">휴면해제</button>
						</div>
					</c:if>
						
					<c:if test="${mvo.member_status == 1}">
						<div class="col-sm-offset-1 col-sm-5">
							<button type="button" id="goJoinBtn" class="btns" onclick="memberOut(${mvo.idx});" style="color: rgb(252, 118, 106);">탈퇴</button>
						</div>
					</c:if>
					
					<c:if test="${mvo.member_status == 0}">
						<div class="col-sm-offset-1 col-sm-5">
							<button type="button" id="goJoinBtn" class="btns" onclick="memberIn(${mvo.idx})" style="color: rgb(252, 118, 106);">복원</button>
						</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>
</div>