<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<style>
.navbar {
     margin-bottom: 0;
     background-color: rgb(252, 118, 106);
     z-index: 9999;
     border: 0;
     font-size: 12px !important;
     line-height: 1.42857143 !important;
     letter-spacing: 4px;
     border-radius: 0;
   }
   
   .navbar li a, .navbar .navbar-brand {
     color: white;
   }
   
   .navbar-brand{
   	font-size: 30px;
  	font-weight: bold;
  	margin-left: 2.5%;
  	padding: 15px 15px;
   }
   .navbar-nav li a:hover, .navbar-nav li.active a {
     font-weight: bold;
   }
   
   .navbar-default .navbar-toggle {
     border-color: transparent;
     color: #fff !important;
   }
       
   .navbar-default .navbar-nav .dropdown .dropdown-toggle:focus,
    .navbar-default .navbar-nav .dropdown .dropdown-toggle:hover
     {
        color: #fff;
        background-color: rgb(252, 118, 106);
     }
   
    /*-- change navbar dropdown color --*/
     .navbar-default .navbar-nav .open .dropdown-menu>li>a,.navbar-default .navbar-nav .open .dropdown-menu {
       background-color: #fff !important;
       color: rgb(252, 118, 106) !important;
     } 
    
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

.notdropdown-content .a:hover {font-weight: bold; }

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

<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
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
			beforeSend : function(xmlHttpRequest){
				xmlHttpRequest.setRequestHeader("AJAX", "true");
			},
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
				if(request.status==400){
					location.href="<%=ctxPath%>/login.pet";
				}
				else {
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
				
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

<div>
	<div class="header">
		<!-- <a href="#default" class="logo">PETOPIA</a>
		<div class="header-right">
			<div class="row">
				<button type="button" class="btn btn-rounder" id="btnRegister">&nbsp;&nbsp;회원가입&nbsp;&nbsp;</button>&nbsp;&nbsp;
				<button type="button" class="btn btn-rounder" id="btnLogin">&nbsp;&nbsp;로그인&nbsp;&nbsp;</button>
			</div>
		</div> -->
		<nav class="navbar navbar-default navbar-fixed-top">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand logo" href="<%= ctxPath %>/home.pet" style="font-size: 18px; font-weight: bold;padding: 15px 15px;">PETOPIA</a>
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
						
							<li><a onclick="logOut();" style="color: #ffffff;" href="<%= ctxPath %>/logout.pet">[${sessionScope.loginuser.nickname }] 로그아웃</a></li>
							<c:if test="${sessionScope.loginuser != null && sessionScope.loginuser.membertype == 1 }"><%-- 관리자일 경우 없애기 --%>
								<li class="dropdown">
									<a class="dropdown-toggle" style="color: #ffffff;" data-toggle="dropdown">마이페이지<span class="caret"></span></a>
									<ul class="dropdown-menu">
										<!-- [19-01-25] /careIndex.pet -> petList.pet 수정 -->
										<li><a href="<%= ctxPath %>/petList.pet">반려동물수첩</a></li>
										<li><a href="<%= ctxPath %>/infoMember.pet">나의정보보기</a></li>
										<li><a href="<%= ctxPath %>/myReviewList.pet">나의병원리뷰</a></li>
										<li><a href="<%= ctxPath %>/InsertMyPrescription.pet">나의진료관리</a></li>
									</ul>
								</li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</div>
		</nav>
	</div>
	
	<c:if test="${sessionScope.loginuser == null || (sessionScope.loginuser.membertype != 2 && sessionScope.loginuser.membertype != 3) }"><%-- 일반회원인 경우 --%>
		<div class="navbar1">
			<div class="dropdown1">
				<div class="row">
					<div class="col-md-2"></div>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;" onclick="javascript:location.href='<%= ctxPath %>/search.pet?searchWord='">병원/약국찾기</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">병원예약관리</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">상담</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">반려동물수첩</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">커뮤니티</button>
				</div>
				<div class="dropdown-content"> 
					<div class="row">
						<div class="col-md-2"></div>
						<div class="column" id="search">
						</div>
						<div class="column" id="reservation">
							<a href="<%= ctxPath %>/reservationList.pet">예약내역</a>
							<a href="<%= ctxPath %>/deposit.pet">예치금관리</a>
						</div>
						<div class="column" id="consult">
							<a href="<%= ctxPath %>/consultList.pet">1:1 문의상담</a>
							<a href="<%= ctxPath %>/chat.pet">화상채팅진료</a>
							<a href="<%= ctxPath %>/video.pet">화상진료</a>
						</div>
						<div class="column" id="petCare">
							<!-- [19-01-25] /careIndex.pet -> petList.pet 수정 -->
							<a href="<%= ctxPath %>/petList.pet">반려동물관리</a>
							<%-- <a href="<%= ctxPath %>/careCalendar.pet">반려동물케어</a> --%>
							<a href="<%= ctxPath %>/InsertMyPrescription.pet">진료기록관리</a>
							<a href="<%= ctxPath %>/myReviewList.pet">나의 병원리뷰</a>
						</div>
						<div class="column" id="board">
							<a href="#">공지사항</a>
							<a href="#">이벤트</a>
							<a href="<%= ctxPath %>/allReviewList.pet">전체리뷰</a>
							<a href="#">자유게시판</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
	
	<c:if test="${sessionScope.loginuser != null && sessionScope.loginuser.membertype == 2 }"><%-- 병원관리자인 경우 --%>
		<div class="navbar1">
		   	<div class="dropdown1">
		   		<div class="row">
					<div class="col-md-3"></div>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">마이페이지</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">진료관리</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">상담</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">커뮤니티관리</button>
				</div>
				
				<div class="dropdown-content"> 
					<div class="row">
						<div class="col-md-3"></div>
						<div class="column" id="bizMember">
							<a href="<%= ctxPath %>/bizMemberInfo.pet">병원정보관리</a>
							<a href="<%= ctxPath %>/bizDepositAccount.pet">예치금관리</a>
							<a href="<%= ctxPath %>/bizReviewList.pet">우리병원리뷰</a>
						</div>
						<div class="column" id="bizReservation">
							<a href="<%= ctxPath %>/bizReservationList.pet">병원예약관리</a>
							<a href="<%= ctxPath %>/SelectChartSearch.pet">예약스케쥴</a>
						</div>
						<div class="column" id="bizConsult">
							<a href="<%= ctxPath %>/consultList.pet">1:1 문의상담</a>
							<a href="<%= ctxPath %>/chat.pet">화상채팅진료</a>
							<a href="<%= ctxPath %>/video.pet">화상진료</a>
						</div>
						<div class="column" id="bizBoard">
							<a href="#">공지사항</a>
							<a href="#">이벤트</a>
							<a href="<%= ctxPath %>/bizReviewList.pet">전체리뷰</a>
							<a href="#">자유게시판</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
	
	<c:if test="${sessionScope.loginuser != null && sessionScope.loginuser.membertype == 3 }"><%-- 관리자인 경우 --%>
		<div class="navbar1">
		   	<div class="dropdown1">
		   		<div class="row">
					<div class="col-md-3"></div>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">회원관리</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">예치금관리</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;" onClick="javascript: location.href='<%= ctxPath %>/adminReviewList.pet'">리뷰관리</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">상담</button>
					<button type="button" class="btnmenu dropbtn" style="font-size: 16px;">커뮤니티관리</button>
				</div>
				
				<div class="dropdown-content"> 
					<div class="row">
						<div class="col-md-3"></div>
						<div class="column" id="adminMember">
							<a href="<%= ctxPath %>/adminMember.pet">일반회원</a>
							<a href="<%= ctxPath %>/adminBiz_member.pet">병원회원</a>
						</div>
						<div class="column" id="adminDeposit">
							<a href="<%= ctxPath %>/adminPaymentList.pet">예약결제관리</a>
							<a href="<%= ctxPath %>/admin_depositList.pet">입금관리</a>
						</div>
						<div class="column" id="adminReview">
						</div>
						<div class="column" id="adminConsult">
							<a href="<%= ctxPath %>/adminConsultList.pet">1:1 문의상담</a>
							 <a href="">화상진료</a>
						</div>
						<div class="column" id="adminBoard">
							<a href="#">공지사항</a>
							<a href="#">이벤트</a>
							<a href="#">자유게시판</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
</div>

<form name="countfrm">
<input type="hidden" id="count" name="count"/>
</form>