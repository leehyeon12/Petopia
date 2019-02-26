<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.btn1 {
	width: 80px;
	font-size: 15px;
	color: white;
	text-align: center;
	background: grey;
	border: solid 0px grey;
	border-radius: 30px;
}

.btn2 {
	width: 80px;
	font-size: 15px;
	color: white;
	text-align: center;
	background: rgb(252, 118, 106);
	border: solid 0px grey;
	border-radius: 30px;
}
</style>

<script type="text/javascript">

	$(document).ready(function() {
		var dog = ${bizmvo.dog};
		var cat = ${bizmvo.cat};
		var smallani = ${bizmvo.smallani};
		var etc = ${bizmvo.etc};
		
		if(dog == '1'){
			$("#dog").addClass("btn2");
		}
		if(cat == '1'){
			$("#cat").addClass("btn2");
		}
		if(smallani == '1'){
			$("#smallani").addClass("btn2");
		}
		if(etc == '1'){
			$("#etc").addClass("btn2");
		}
	});

</script>


<div class="container">
	<div class="col-sm-12">
		<div class="col-sm-12" align="center">
			<h2>기업상세</h2>
		</div>
			<div class="col-sm-offset-2 col-sm-8 preview-image"
				style="margin-bottom: 15px;">
				<div class="row">
					<div style="width: 100%;">
						<div id="myCarousel" class="carousel slide" data-ride="carousel">
							<!-- Indicators -->
							<ol class="carousel-indicators">
							</ol>

							<!-- Wrapper for slides -->
							<div class="carousel-inner">
								<div class="item active">
									<img src="<%=request.getContextPath()%>/resources/img/member/prontimg/${bizmvo.prontimg}" style="width: 100%; height: 400px;">
								</div>
								
								<c:if test="${imgList != null}">
									<c:forEach items="${imgList}" var="img">
										<div class="item">
											<img src="<%=request.getContextPath()%>/resources/img/member/addimg/${img}" style="width: 100%; height: 400px;">
										</div>
									</c:forEach>
								</c:if>
							</div>

							<!-- Left and right controls -->
							<a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
								<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
								<span class="sr-only">Previous</span>
							</a>
							<a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
								<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
								<span class="sr-only">Next</span>
							</a>
						</div>
					</div>
				</div>

				<div align="center">
					<h3>${bizmvo.name}</h3>
				</div>

				<div class="row">
					<span>${bizmvo.intro}</span>
				</div>

				<div class="row" style="margin-top: 5%;">
					<label>진료/처방가능 동물</label>
				</div>
				<div class="row">
					<button type="button" class="btn1 pettype" id="dog">강아지</button>
					<button type="button" class="btn1 pettype" id="cat">고양이</button>
					<button type="button" class="btn1 pettype" id="smallani">소동물</button>
					<button type="button" class="btn1 pettype" id="etc">기타</button>
				</div>

				<hr style="height: 1px; background-color: grey; border: none; margin-bottom: 0px;">

				<div class="row" style="padding-top: 20px;">
		            <div class="col-sm-6" style="padding-left: 0px;">
		            	<label>진료시간(운영시간)</label><BR>
	            		<span>${bizmvo.weekday}</span>
						<span>${bizmvo.wdstart}-${bizmvo.wdend}</span>
		            </div>
					<div class="col-sm-6">
						<label>점심시간</label><BR>
						<span>${bizmvo.lunchstart}-${bizmvo.lunchend}</span>
					</div>
		            <div class="col-sm-6" style="padding-left: 0px;">
						<label>토요일</label><BR>
						<span>${bizmvo.satstart}-${bizmvo.satend}</span>
					</div>
					
					<div class="col-sm-4">
						<label>일요일/공휴일</label><BR>
						<span>${bizmvo.dayoff}</span>
					</div>
								
               
				</div><!-- row -->
				
				<div class="row" style="margin-top: 30px;">
					<label>연락처</label>
					<div>
						<span>${bizmvo.phone}</span> 
						<span class="glyphicon glyphicon-earphone" style="margin-left: 10px;"></span>
						<button type="button" style="background-color: #ff6e60; color: white; margin-left: 10px; border: 0; border-radius: 6px;" onClick="javascript: location.href='<%=ctxPath%>/reservation.pet?idx_biz=${idx_biz}'">예약하기</button>
					</div>
				</div>

				<div>
					<img src="<%=request.getContextPath()%>/resources/img/hospitalimg/aaa.PNG" style="width: 100%; height: 90px;">
				</div>

				<div class="row" style="margin-top: 30px;">
					<label>병원 특이사항</label>
				</div>
				<div class="row">
					<c:forEach items="${tagList}" var="tag">
						<span style="color: rgb(252, 118, 106); font-weight: bold;">#${tag}</span>&nbsp;&nbsp;
					</c:forEach>
				</div>
				<hr style="height: 1px; background-color: grey; border: none; margin-bottom: 0px;">

				<div class="row" style="margin-top: 20px;">
					<label>위치</label>
				</div>
				
				<div>
					<label>주소</label>
					(${bizmvo.postcode})&nbsp;${bizmvo.addr1}&nbsp;${bizmvo.addr2}
				</div>
				
				<div id="map" style="width:100%;height:350px;"></div>

				<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d95bf006c44a2e98551f0af770a55949&libraries=services"></script>
				<script>
					var latitude = ${bizmvo.latitude};
					var longitude = ${bizmvo.longitude};
				
					var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
					    mapOption = { 
					        center: new daum.maps.LatLng(latitude, longitude), // 지도의 중심좌표
					        level: 3 // 지도의 확대 레벨
					    };
					
					var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
					
					// 마커가 표시될 위치입니다 
					var markerPosition  = new daum.maps.LatLng(latitude, longitude); 
					
					// 마커를 생성합니다
					var marker = new daum.maps.Marker({
					    position: markerPosition
					});
					
					// 마커가 지도 위에 표시되도록 설정합니다
					marker.setMap(map);
					
					var infowindow = new daum.maps.InfoWindow({
			            content: '<div style="width:150px;text-align:center;padding:6px 0;">${bizmvo.name}</div>'
			        });
			        infowindow.open(map, marker);
					
					// 아래 코드는 지도 위의 마커를 제거하는 코드입니다
					// marker.setMap(null);    
				</script>
				
				<div class="row" style="margin-top: 2%;">
					<label>찾아오시는 길</label><BR>
				</div>
					<div class="row">${bizmvo.easyway}</div>
				
				<!-- === 2019.02.11 === 시작 -->
				<div class="row" style="margin-top: 2%; border: 0px solid red;">
					<%@ include file="/WEB-INF/views/tiles2/review/hosReviewList.jsp" %>
				</div>
				<!-- === 2019.02.11 === 끝 -->
				
				<div class="row" style="margin-top: 2%;">
					<label>의료진</label><BR>
					
				</div>
				<c:forEach items="${docList}" var="doc">	
					<div class="row" style="margin-left: 1%;">
						<div style="margin: 1%;">
								${doc.docname}
								
								<c:if test="${doc.dog == '1'}">
									<button type="button" class="btn2 pettype">강아지</button>
								</c:if>
								<c:if test="${doc.dog != '1'}">
									<button type="button" class="btn1 pettype">강아지</button>
								</c:if>
								
								<c:if test="${doc.cat == '1'}">
									<button type="button" class="btn2 pettype">고양이</button>
								</c:if>
								<c:if test="${doc.cat != '1'}">
									<button type="button" class="btn1 pettype">고양이</button>
								</c:if>
								
								<c:if test="${doc.smallani == '1'}">
									<button type="button" class="btn2 pettype">소동물</button>
								</c:if>
								<c:if test="${doc.smallani != '1'}">
									<button type="button" class="btn1 pettype">소동물</button>
								</c:if>
								
								<c:if test="${doc.etc == '1'}">
									<button type="button" class="btn2 pettype">기타</button>
								</c:if>
								<c:if test="${doc.etc != '1'}">
									<button type="button" class="btn1 pettype">기타</button>
								</c:if>
								</div>
						
					</div>
					</c:forEach>
					
			</div>
	</div>
</div>







