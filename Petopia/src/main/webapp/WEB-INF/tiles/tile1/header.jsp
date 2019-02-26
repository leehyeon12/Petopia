<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%  String ctxPath = request.getContextPath();%>


<style>

.notdropbtn {
  cursor: pointer;
}

.notdropdown {
  position: relative;
  display: inline-block;
}

.notdropdown-content {
  display: none;
  position: absolute;
  background-color: white;
  min-width: 320px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
  padding: 20%;
}

.notmassage {
  display: block;
}

.notmassage:hover {
  text-decoration: none;
}
.notdropdown-content .a:hover {font-weight: bold;}

.notdropdown:hover .notdropdown-content {
  display: block;
}

.badge {
	position: absolute;
	top: 10px;
	right: -4px;
	padding: 2px 3px 2px 3px;
	border-radius: 50%;
	background-color: white;
	color: #fc766b;
	letter-spacing: 1pt;
}

</style>

<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<script type="text/javascript">
	
$(document).ready(function(){
	
	// 로그인 시(관리자가 아닐 경우) 알림 아이콘 생성
	if(${sessionScope.loginuser != null && sessionScope.loginuser.membertype != 3}){
		loopShowNotificationCount();
	} // if
	
	// 알림 아이콘 호버 -> 심플 알림창 생성
	$(".notdropbtn").hover(function(){
		
		$.ajax({
			url:"<%=ctxPath%>/notificationSimpleList.pet", 
			type:"GET",
			//data:form_data,
			dataType:"JSON",
			success:function(json){ 
				
				var html = "";
				
				if(json.length > 0){
					$.each(json, function(entryIndex, entry){
						html += "<a class='notmassage' style='color: #fc766b;' href='<%= ctxPath %>/notificationList.pet'>"+entry.SIMPLEMSG+"["+entry.COUNT+"]</a>";
					});
				}
				else{
					html += "<a class='notmassage' style='color: #fc766b;' href='<%= ctxPath %>/notificationList.pet'>새 알림이 없습니다.</a>";
				}
				html += "<hr align='center' width='100%' style='border:0.5px solid #fc766b; margin-top: 20%;'>"
					 + "<a class='notmassage' style='color: #fc766b; border: 0px solid; margin-top: -5%; margin-left: 35%;' href='<%= ctxPath %>/notificationList.pet'>더보기</a>";
				
				$("#notSimpleList").empty().html(html);
			},
			error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // $.ajax({
		
	}); // $(".notdropbtn").hover(function(){
	
}); // $(document).ready(function(){

function logOut(){ 
	// 카카오 로그아웃
	Kakao.init('b5a80832c3cb255d6b0092b12fa51f95');
	Kakao.Auth.getAccessToken();
} // end of logOut

function showNotificationCount(){ // 안읽은 알림 갯수
	
	var form_data = {count : $("#count").val() };
	
	$.ajax({
		url:"<%=ctxPath%>/unreadNotificationCount.pet", 
		type:"GET",
		data:form_data,
		dataType:"JSON",
		success:function(json){
			if(json.UNREADNOTIFICATIONCOUNT > 0) {
				
				$("#badge").show();
				
				var unreadnotificationcount = json.UNREADNOTIFICATIONCOUNT;
		    	$("#badge").empty().html(unreadnotificationcount);
		    	
		    	$("#count").val(unreadnotificationcount);
			}
			else {
				$("#badge").hide();
			}
			
		},
		error: function(request, status, error){
		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // $.ajax({
} // function showNotificationCount(){

function loopShowNotificationCount(){ // 매초마다 안읽은 알림 갯수 갱신
			
	showNotificationCount();
	
	var timeCycle = 1000;   // 1초 마다 자동 갱신
	
	setTimeout(function() {
		loopShowNotificationCount();	
		}, timeCycle);

} // function loopShowNotificationCount(){

</script>

<div class="header">
<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span> 
      </button>
      <a class="navbar-brand logo" href="<%= ctxPath %>/home.pet" style="font-size: 18px; font-weight: bold;">PETOPIA</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav navbar-right">
      	<c:if test="${sessionScope.loginuser == null }">
        <li><a style="color: #ffffff;" href="<%= ctxPath %>/join.pet">회원가입</a></li>
        <li><a style="color: #ffffff;" href="<%= ctxPath %>/login.pet" >로그인</a></li>
        </c:if>
        <c:if test="${sessionScope.loginuser != null }">
        	<c:if test="${sessionScope.loginuser.membertype != 3}">
				<li class="notdropdown">
					<span class="notdropbtn">
						<img src="<%=request.getContextPath() %>/resources/img/notification/icon.png" style="margin-left: 50%; margin-top: 20%; width: 40%;" />
							<span id="badge" class="badge"></span>
					</span>
						<div class="notdropdown-content" id="notSimpleList">
						</div>
				</li>
			</c:if>
        <li><a style="color: #ffffff;" href="<%= ctxPath %>/logout.pet">[${sessionScope.loginuser.nickname }] 로그아웃</a></li>
        <li class="dropdown">
           <a  style="color: #ffffff;" class="dropdown-toggle" data-toggle="dropdown">마이페이지
           <span class="caret"></span></a>
           <ul class="dropdown-menu">
             <li><a href="<%= ctxPath %>/petList.pet">반려동물수첩</a></li>
			<li><a href="<%= ctxPath %>/infoMember.pet">나의정보보기</a></li>
			<li><a href="<%= ctxPath %>/myReviewList.pet">나의병원리뷰</a></li>
			<li><a href="<%= ctxPath %>/InsertMyPrescription.pet">나의진료관리</a></li>
           </ul>
        </li>
        </c:if>
      </ul>
    </div>
  </div>
</nav>
</div>



</body>
</html>