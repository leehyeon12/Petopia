<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String ctxPath = request.getContextPath();
	String whereNo = request.getParameter("whereNo");
	
	if(whereNo == null || whereNo.trim().isEmpty()) {
		whereNo = "1";
	}

%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">

	.jumbotron {
		background-color: white;
		color: black;
	}
	
	#myInput {
	  background-image: url('<%= request.getContextPath() %>/resources/img/homeheader/magnifying-glass.png');
	  background-position: 10px 12px;
	  background-repeat: no-repeat;
	  width: 100%;
	  font-size: 16px;
	  padding: 12px 20px 12px 40px;
	  border: 1px solid #ddd;
	  margin-bottom: 12px;
	}
	
	#myUL {
	  list-style-type: none;
	  padding: 0;
	  
	  margin: 0;
	}
	
	#myUL li a {
	  border: 1px solid #ddd;
	  margin-top: -1px; /* Prevent double borders */
	  background-color: #f6f6f6;
	  padding: 12px;
	  text-decoration: none;
	  font-size: 18px;
	  color: black;
	  display: block;
	}
	
	#myUL li a:hover:not(.header) {
	  background-color: #eee;
	}
	
	h2 {
		margin-bottom: 3%;
		font-weight: bold;
	}
	
	hr {
		border-color: #a6a6a6;
	}
	
	
	.card-img-top {
		max-width: 100%;
		cursor:pointer;
	}
	
	.card {
		margin: 5%;
	}
	
	.card-title {
		font-weight: bold;
		cursor:pointer;
	}
	
	.resultHeader h3 {
		font-weight: bold; margin-bottom: 10%;
	}
	
	.resultHeader select {
		margin-top: 15%; margin-bottom: 10%; 
		font-size: 8pt;
	}
	
	#cnt {
		font-weight: bold;
		color: #993333;
	}
	
	.modal {
        text-align: center;
        padding: 0!important;
    }

    .modal:before {
        content: '';
        display: inline-block;
        vertical-align: middle;
        margin: -2px;
        height: 100%;
    }

    .modal-dialog {
        display: inline-block;
        vertical-align: middle;
    }
    
    .dot {overflow:hidden;float:left;width:12px;height:12px;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/mini_circle.png');}    
	.dotOverlay {position:relative;bottom:10px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;font-size:12px;padding:5px;background:#fff;}
	.dotOverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}    
	.number {font-weight:bold;color:#ee6152;}
	.dotOverlay:after {content:'';position:absolute;margin-left:-6px;left:50%;bottom:-8px;width:11px;height:8px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white_small.png')}
	.distanceInfo {position:relative;top:5px;left:5px;list-style:none;margin:0;}
	.distanceInfo .label {display:inline-block;width:50px;color:black;font-size:8pt;}
	.distanceInfo:after {content:none;}

	table {
	  border-collapse: collapse;
	  border-spacing: 0;
	  width: 100%;
	  border: 1px solid #ddd;
	}
	
	th, td {
	  text-align: left;
	  padding: 16px;
	}
	
	tr {
	  background-color: #fff;
	}
	
	tr:nth-child(even) {
	  background-color: #f2f2f2
	}
	
	/* Style tab links */
	.tablink {
	  background-color: #555;
	  color: white;
	  float: left;
	  border: none;
	  outline: none;
	  cursor: pointer;
	  padding: 14px 16px;
	  font-size: 17px;
	  width: 50%;
	}
	
	.tablink:hover {
	  background-color: #777;
	}
	
	/* Style the tab content (and add height:100% for full page content) */
	.tabcontent {
	  color: white;
	  display: none;
	  padding: 100px 20px;
	  height: 120%;
	}
	
	#Pharmacy, #Hospital {background-color: #f9ecf2;}

	.pagination a {
	  color: black;
	  float: left;
	  padding: 8px 16px;
	  text-decoration: none;
	  transition: background-color .3s;
	}
	
	.pagination a.active {
	  background-color: rgb(252, 118, 106);
	  color: white;
	}
	
	.pagination a:hover:not(.active) {background-color: #ddd;}
	
</style>


<script type="text/javascript">
	
	$(document).on("click",".card-img-top",function() {
		location.href="<%= ctxPath%>/bizDetail.pet?idx_biz="+$(this).parent().find(".idx_biz").val();
	});
	
	$(document).on("click",".card-title",function() {
		var idx_biz = $(this).parent().parent().find(".idx_biz").val();
		location.href="<%= ctxPath%>/bizDetail.pet?idx_biz="+idx_biz;
	});
	
	$(document).ready(function(){

		$("#myUL").hide();
		$("#myInput").val("${searchWord}");		
		var cnt = $("#cnt").text("${cnt}");
		
		if(cnt != 0) {
			setBounds();
		}

		getHospitalTotalCnt();
		getPharmacyTotalCnt();
		
	});

	document.addEventListener("DOMContentLoaded", function(event) { 
	    document.getElementById("defaultOpen").click();
	});

	var hospitalArr = [];
	var pharmacyArr = [];
	
	function getHospitalTotalCnt() {
		
		$.ajax({
			url:"http://openapi.seoul.go.kr:8088/6b556842446c656533304b4a684e76/xml/vtrHospitalInfo/1/1/",
			success: function(xml){

				var rootElement = $(xml).find(":root");
				
				var totalCount = $(rootElement).find("list_total_count").text(); 
				
				getHospitalList(totalCount);
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}			
			
		});
		
		
	};
	
	
	function getHospitalList(totalCount) {
		
		$.ajax({
			url:"http://openapi.seoul.go.kr:8088/6b556842446c656533304b4a684e76/json/vtrHospitalInfo/1/"+totalCount+"/",
			success: function(json){
				
				// console.log(json.vtrHospitalInfo);
				
				// console.log(entry.row[1].ADDR);
				for(var i=0;i<totalCount;i++) {

					var addr = json.vtrHospitalInfo.row[i].ADDR.trim()==""?json.vtrHospitalInfo.row[i].ADDR_OLD:json.vtrHospitalInfo.row[i].ADDR;
					// console.log(addr);
					
					if(addr.includes("${searchWord}")) {
						hospitalArr.push(json.vtrHospitalInfo.row[i]);
						hospitalArr.slice(-1)[0].ADDR = addr;
					}
					
					// hospitalArr.push(json.vtrHospitalInfo.row[i]);
				}
				
				console.log(hospitalArr);
				
				if(hospitalArr.length == 0) {
					var html = "<tr><th>병원이름</th><th>주소</th><th>전화번호</th></tr><tr><td colspan='3'>검색결과가 없습니다. </td></tr>";	
					$("#TblHospital").html(html);
				}
				else {
					showHospitalByWord(1);	
				}
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}		
			
		});
		
	}
	
	function showHospitalByWord(currentShowPageNo) {
		// console.log(hospitalArr);
		// console.log(currentShowPageNo);
		
		var sizePerPage = 10;
		
		var startno = (currentShowPageNo*sizePerPage) - (sizePerPage - 1);
		var endno = (currentShowPageNo*sizePerPage);
		
		endno = (hospitalArr.length<endno)?(hospitalArr.length):(currentShowPageNo*sizePerPage);
		
		console.log(startno);
		console.log(endno);
		
		var html = "<tr><th>병원이름</th><th>주소</th><th>전화번호</th></tr>";		
		
		for(var i=startno;i<endno;i++) {
			
			html += "<tr><td>"+hospitalArr[i].NM+"</th><td>"+hospitalArr[i].ADDR+"</th><td>"+hospitalArr[i].TEL+"</th></tr>";	
			
		}

		$("#TblHospital").html(html);
		
		showHospitalByWordPageBar(currentShowPageNo);
		
	}
	
	
	function showHospitalByWordPageBar(currentShowPageNo) {
		
		var sizePerPage = 10;
		
		var totalPage = Math.ceil(hospitalArr.length/sizePerPage);
		
	    var pageBarHTML = "";
		 
	    var blockSize = 10;
	    
	    var loop = 1;
        
	    var pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1; 
            					     
		 // *** [이전] 만들기 *** //
		 if(pageNo != 1) {
	    	  pageBarHTML += "<a href='javascript:showHospitalByWord("+(pageNo-1)+")'>&laquo;</a>";
	     }
            /////////////////////////////////////////////////
	     while( !(loop > blockSize || pageNo > totalPage) ) {
	       	 
	    	  if(pageNo == currentShowPageNo) {
	    		  pageBarHTML += "<a class='active'>"+pageNo+"</a>";
	    	  }
	    	  else {
	    	  	  pageBarHTML += "<a href='javascript:showHospitalByWord("+pageNo+")'>"+pageNo+"</a>";
	     	  }
            
	       	 loop++;
	    	 pageNo++;
	     } // end of while-----------------------------------
               /////////////////////////////////////////////////

	  	  // *** [다음] 만들기 *** //
	     if( !(pageNo > totalPage) ) {
	    	 pageBarHTML += "<a href='javascript:showHospitalByWord("+pageNo+")'>&raquo;</a>";
	     }
		 	
	     $(".pagenation_H").empty().html(pageBarHTML);
	     
	     pageBarHTML = "";

	}
	

	

	function getPharmacyTotalCnt() {
		
		$.ajax({
			url:"http://openapi.seoul.go.kr:8088/6b556842446c656533304b4a684e76/xml/animalPharmacyInfo/1/1/",
			success: function(xml){

				var rootElement = $(xml).find(":root");
				var totalCount = $(rootElement).find("list_total_count").text(); 
				
				getPharmacyList(totalCount);
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}			
			
		});
		
		
	};
	
	
	function getPharmacyList(totalCount) {
		
		$.ajax({
			url:"http://openapi.seoul.go.kr:8088/6b556842446c656533304b4a684e76/json/animalPharmacyInfo/1/"+totalCount+"/",
			success: function(json){
				
				// console.log(json.vtrHospitalInfo);
				
				// console.log(entry.row[1].ADDR);
				for(var i=0;i<totalCount;i++) {

					var addr = json.animalPharmacyInfo.row[i].ADDR.trim()==""?json.animalPharmacyInfo.row[i].ADDR_OLD:json.animalPharmacyInfo.row[i].ADDR;
					// console.log(addr);
					
					if(addr.includes("${searchWord}")) {
						pharmacyArr.push(json.animalPharmacyInfo.row[i]);
						pharmacyArr.slice(-1)[0].ADDR = addr;
					}
					
					// pharmacyArr.push(json.animalPharmacyInfo.row[i]);
				}
				
				console.log(pharmacyArr);
				
				if(pharmacyArr.length == 0) {
					var html = "<tr><th>약국이름</th><th>주소</th><th>전화번호</th></tr><tr><td colspan='3'>검색결과가 없습니다.</td></tr>";	
					$("#TblPharmacy").html(html);
				}
				else {
					showPharmacyByWord(1);
				}

			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}		
			
		});
		
	}
	
	function showPharmacyByWord(currentShowPageNo) {
		// console.log(pharmacyArr);
		// console.log(currentShowPageNo);
		
		var sizePerPage = 10;
		
		var startno = (currentShowPageNo*sizePerPage) - (sizePerPage - 1);
		var endno = (currentShowPageNo*sizePerPage);
		
		endno = (pharmacyArr.length<endno)?(pharmacyArr.length):(currentShowPageNo*sizePerPage);
		
		console.log(startno);
		console.log(endno);
		
		var html = "<tr><th>약국이름</th><th>주소</th><th>전화번호</th></tr>";		
		
		for(var i=startno;i<endno;i++) {
			
			html += "<tr><td>"+pharmacyArr[i].NM+"</th><td>"+pharmacyArr[i].ADDR+"</th><td>"+pharmacyArr[i].TEL+"</th></tr>";	
			
		}

		$("#TblPharmacy").html(html);
		
		showPharmacyByWordPageBar(currentShowPageNo);
		
	}
	
	
	function showPharmacyByWordPageBar(currentShowPageNo) {
		
		var sizePerPage = 10;
		
		var totalPage = Math.ceil(pharmacyArr.length/sizePerPage);
		
	    var pageBarHTML = "";
		 
	    var blockSize = 10;
	    
	    var loop = 1;
        
	    var pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1; 
            					     
		 // *** [이전] 만들기 *** //
		 if(pageNo != 1) {
	    	  pageBarHTML += "<a href='javascript:showPharmacyByWord("+(pageNo-1)+")'>&laquo;</a>";
	     }
            /////////////////////////////////////////////////
	     while( !(loop > blockSize || pageNo > totalPage) ) {
	       	 
	    	  if(pageNo == currentShowPageNo) {
	    		  pageBarHTML += "<a class='active'>"+pageNo+"</a>";
	    	  }
	    	  else {
	    	  	  pageBarHTML += "<a href='javascript:showPharmacyByWord("+pageNo+")'>"+pageNo+"</a>";
	     	  }
            
	       	 loop++;
	    	 pageNo++;
	     } // end of while-----------------------------------
               /////////////////////////////////////////////////

	  	  // *** [다음] 만들기 *** //
	     if( !(pageNo > totalPage) ) {
	    	 pageBarHTML += "<a href='javascript:showPharmacyByWord("+pageNo+")'>&raquo;</a>";
	     }
		 	
	     $(".pagenation_P").empty().html(pageBarHTML);
	     
	     pageBarHTML = "";

	}	
	
	function searchEnter(event) {
		
		/* $("#myUL").show();
		
		var input, filter, ul, li, a, i, txtValue;
	    input = document.getElementById("myInput");
	    filter = input.value.toUpperCase();
	    ul = document.getElementById("myUL");
	    li = ul.getElementsByTagName("li");
	    for (i = 0; i < li.length; i++) {
	        a = li[i].getElementsByTagName("a")[0];
	        txtValue = a.textContent || a.innerText;
	        if (txtValue.toUpperCase().indexOf(filter) > -1) {
	            li[i].style.display = "";
	        } else {
	            li[i].style.display = "none";
	        }
	    } */
	    
	    if(event.keyCode == 13) {	
	    	searchEnd();
	    }
	    
	}
	
	function searchEnd() {
		var whereNo = $("#selectWhere option:selected").val();
    	var searchWord = $("#myInput").val();
    	// console.log(whereNo);
    	location.href="<%= ctxPath%>/search.pet?searchWord="+searchWord+"&whereNo="+whereNo;
	}
	
	function selectOrderby(event) {
		
		var whereNo = $("#selectWhere option:selected").val();
		var orderbyNo = $(event.target).val();
		var searchWord = $("#myInput").val();
		var pattern = "${pattern}";
		
		if(orderbyNo == 1) {
			// 평점순이라면

			$.getJSON("<%= ctxPath%>/selectOrderbyNo.pet?orderbyNo="+orderbyNo+"&searchWord="+searchWord+"&whereNo="+whereNo+"&pattern="+pattern, 
					  function(json){
				
							var html = "";
							
							$.each(json, function(entryIndex, entry){
							
								// 데이터넣고
								html += "<div class='card text-left border-secondary' >";
								html += "  <input type='hidden' class='idx_biz' value='"+entry.idx_biz+"'/>";
								html += "  <img class='card-img-top' src='<%= ctxPath %>/resources/img/member/prontimg/"+entry.prontimg+"' alt='Card image cap' style='width: 500px; height: 350px;'>";
								html += "  	<div class='card-body'>";
								html += "	    <h5 class='card-title'>"+entry.name+"</h5>";
								html += "	    <p class='card-text'>평점&nbsp;";
								
								for(var i=0;i<entry.avg_startpoint;i++) {
									html += "<span class='glyphicon glyphicon-star'></span>&nbsp;"; 
								}
								
								if(entry.biztype == 1) {
									html += "</p><a href='<%= ctxPath %>/reservation.pet?idx_biz="+entry.idx_biz+"' class='btn btn-primary'>예약하기</a>";	
								}
								
								html += "</div></div>";
								
							});
						  	
							$("#cards").empty().html(html);
							
			});
			
		}
		
		if(orderbyNo == 2) {
			// 거리순이라면
			$('#myModal').modal('show');

		}
		
	}
	
	function enterGeocoder(event) {
		if(event.keyCode == 13) {
			$('#myModal').modal('hide');
			setGeocoder();
		}
	}

	function openPage(pageName, elmnt, color) {
		  // Hide all elements with class="tabcontent" by default */
		  var i, tabcontent, tablinks;
		  tabcontent = document.getElementsByClassName("tabcontent");
		  for (i = 0; i < tabcontent.length; i++) {
		    tabcontent[i].style.display = "none";
		  }

		  // Remove the background color of all tablinks/buttons
		  tablinks = document.getElementsByClassName("tablink");
		  for (i = 0; i < tablinks.length; i++) {
		    tablinks[i].style.backgroundColor = "";
		  }

		  // Show the specific tab content
		  document.getElementById(pageName).style.display = "block";

		  // Add the specific color to the button used to open the tab content
		  elmnt.style.backgroundColor = color;
	}

	// 오류잡기용
	function setBounds() {}
	
</script>





<div class="jumbotron">
	<h2 align="center">병원/약국 찾기</h2> 
	<div class="row">
		<div class="col-sm-2"></div>
		<div class="col-sm-2">
		  	<div class="form-group">
			  <select class="form-control input-lg" id="selectWhere">
		        <option value="1" <%=whereNo.equals("1")?"selected":""%>>지역별</option>
		        <option value="2" <%=whereNo.equals("2")?"selected":""%>>동물병원</option>
		        <option value="3" <%=whereNo.equals("3")?"selected":""%>>동물약국</option>
		      </select>
			</div>
		</div>
		<div class="col-sm-4">
			<input type="text" id="myInput" onkeyup="searchEnter(event)" placeholder="Search for names.." title="Type in a name">
			
			<!-- <ul id="myUL">
			  <li><a href="#">Adele</a></li>
			  <li><a href="#">Agnes</a></li>
			
			  <li><a href="#">Billy</a></li>
			  <li><a href="#">Bob</a></li>
			
			  <li><a href="#">Calvin</a></li>
			  <li><a href="#">Christina</a></li>
			  <li><a href="#">Cindy</a></li>
			</ul> -->
			
		</div>
		<div class="col-sm-2">
			<div class="row">
				<div class="col-sm-4">
					<input type="button" class="btn input-lg" id="inputlg" value="검색" onclick="searchEnd()"/>
				</div>
				<div class="col-sm-8">
					<input type="button" class="btn btn-primary btn-block input-lg" id="inputlg" value="맞춤추천" onclick="javascript:location.href='<%= ctxPath%>/requireLogin_search.pet'" />
				</div>
			</div>
		</div>
		<div class="col-sm-2"></div>
	</div>
</div>


<div class="row">
	<div class="col-sm-1"></div>
	<div class="col-sm-10">
		<hr/>
	</div>
	<div class="col-sm-1"></div>	
</div>

	<div class="container">
		<div class="row">
			<c:if test="${ cnt != 0 }">
			<div class="col-sm-7">
				<div id="map" style="width:100%; height:100%; position:relative;overflow:hidden;"></div>
				
				<%-- 다음 지도 api --%>
				<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=253c8ea93d1bdcc279a9c6f660649767&libraries=services,clusterer,drawing"></script>
				<script>
					
					// *** 지도 생성 시작 *** //
					var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
					    mapOption = { 
					        center: new daum.maps.LatLng(37.54699, 127.09598), // 지도의 중심좌표
					        level: 4 // 지도의 확대 레벨
					    };

					var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
					// *** 지도 생성 끝 *** //
					
					// *** 지도 컨트롤바 생성 시작 ***//
					// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
					var mapTypeControl = new daum.maps.MapTypeControl();

					// 지도에 컨트롤을 추가해야 지도위에 표시됩니다
					// daum.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
					map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);
				
					// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
					var zoomControl = new daum.maps.ZoomControl();
					map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
					// *** 지도 컨트롤바 생성 끝 ***//
					
					
					// *** 검색된 병원/약국의 좌표 정보를 불러와 마커 찍어주기 시작 ***// 
					var positions = ${gson_bizmemList};
					
					var positions_array = [];

					var imageSrc = '<%= request.getContextPath() %>/resources/img/search/spotpin.png'; // 마커이미지의 주소입니다    
	
					for (var i = 0; i < positions.length; i ++) {
					    
					    // 마커 이미지의 이미지 크기 입니다
					    var imageSize = new daum.maps.Size(44, 49); 
					    
					    // 마커 이미지를 생성합니다    
					    var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize); 
					    
					    // 마커를 생성합니다
					    var marker = new daum.maps.Marker({
					        map: map, // 마커를 표시할 지도
					        position: new daum.maps.LatLng(positions[i].latitude, positions[i].longitude ), // 마커를 표시할 위치
					        title : positions[i].name, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
					        image : markerImage // 마커 이미지 
					    });
					    
					    positions_array.push({idx:positions[i].idx_biz,position:new daum.maps.LatLng(positions[i].latitude, positions[i].longitude ),distance:0})
					    
					}
					// *** 검색된 병원/약국의 좌표 정보를 불러와 마커 찍어주기 종료 ***// 
					
					
					// *** 거리순일때 현재 위치 표시하기 시작 ***//
					function setGeocoder() {
						
						var address = $("#address").val();
						console.log(address);
						
						// 주소-좌표 변환 객체를 생성합니다
						var geocoder = new daum.maps.services.Geocoder();

						// 주소로 좌표를 검색합니다
						geocoder.addressSearch(address, function(result, status) {

						    // 정상적으로 검색이 완료됐으면 
						     if (status === daum.maps.services.Status.OK) {

						        var coords = new daum.maps.LatLng(result[0].y, result[0].x);
						        
						        positions_array.push({idx:'현재위치',position:coords,distance:0});
						        
								var imageSrc = '<%= request.getContextPath() %>/resources/img/search/spotpin_mylocation.png'; // 마커이미지의 주소입니다    

							    // 마커 이미지의 이미지 크기 입니다
							    var imageSize = new daum.maps.Size(44, 49); 
							    
							    // 마커 이미지를 생성합니다    
							    var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize); 

							    // 마커를 생성합니다
							    var marker = new daum.maps.Marker({
							        map: map, // 마커를 표시할 지도
							        position: coords, // 마커를 표시할 위치
							        title : '현재위치', // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
							        image : markerImage // 마커 이미지 
							    });
							    
							 	// 인포윈도우를 생성합니다
							    var infowindow = new daum.maps.InfoWindow({
							        position : coords, 
							        content : '<div style="width:150px;text-align:center;padding:6px 0;">현재위치</div>',
							        removable : true
							    });
							      
							    // 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
							    infowindow.open(map, marker); 
							    
							    // 현재위치와 좌표 사이의 선 그리기
							    for(var i=0;i<positions_array.length;i++) {
							    	var linePath = [coords, positions_array[i].position];

							    	var polyline = new daum.maps.Polyline({
							    	    path: linePath, // 선을 구성하는 좌표배열 입니다
							    	    strokeWeight: 3, // 선의 두께 입니다
							    	    strokeColor: '#fc766a', // 선의 색깔입니다
							    	    strokeOpacity: 0.7, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
							    	    strokeStyle: 'solid' // 선의 스타일입니다
							    	});

							    	// 지도에 선을 표시합니다 
							    	polyline.setMap(map);  
							    	
							    	// console.log(polyline.getLength());
							    	
							    	// 거리를 계산해서 배열에 입력합니다.
							    	positions_array[i].distance = Math.ceil(polyline.getLength());
									
							    }

						    	// console.log(positions_array);
						    	
							    // 배열을 거리를 기준으로 하여 오름차순으로 정렬 
							    positions_array.sort(function(a, b) {
							        return parseFloat(a.distance) - parseFloat(b.distance);
							    });
							    

								var numbers = [];
								for(var i=0;i<positions_array.length;i++) {
								    numbers.push(positions_array[i].idx);
								}
								
								// console.log(numbers);
								
								$.ajax({
									url:'selectOrderbydistance.pet',
									data:{'numbers' : numbers, 'searchWord': $("#myInput").val(), 'whereNo': $("#selectWhere option:selected").val(), 'pattern': "${pattern}"},
									type:'GET',
									dataType:'JSON',
									traditional : true,
									async : false,
									success: function(data) {

										if(data.length > 0) {

											var html = "";
											
											$.each(data, function(entryIndex, entry){
												
												html += "<div class='card text-left border-secondary' >";
												html += "  <input type='hidden' class='idx_biz' value='"+entry.idx_biz+"'/>";
												html += "  <img class='card-img-top' src='<%= ctxPath %>/resources/img/member/prontimg/"+entry.prontimg+"' alt='Card image cap' style='width: 500px; height: 350px;'>";
												html += "  	<div class='card-body'>";
												html += "	    <h5 class='card-title'>"+entry.name+"</h5>";
												html += "	    <p class='card-text'>평점&nbsp;";
												
												for(var i=0;i<entry.avg_startpoint;i++) {
													html += "<span class='glyphicon glyphicon-star'></span>&nbsp;"; 
												}

												if(entry.biztype == 1) {
													html += "</p><a href='<%= ctxPath %>/reservation.pet?idx_biz="+entry.idx_biz+"' class='btn btn-primary'>예약하기</a>";	
												}
												
												html += "</div></div>";
												
											});
										  	
											$("#cards").empty().html(html);
											
										}
										
									},
									error: function(request, status, error){
										alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
									}
									
								});
								
						        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
						        map.setCenter(coords);
						        
						    } 
						});    
						
						gocalc('1');
						
					}
					// *** 거리순일때 현재 위치 표시하기 끝 ***//
					
					// *** 모든 마커를 보여주기 위해 중심좌표와 비율을 다시 설정하기 시작 *** //
					// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성합니다
					var bounds = new daum.maps.LatLngBounds();   
					
					var i, marker;
					for (i = 0; i < positions_array.length; i++) {
					    
					    // LatLngBounds 객체에 좌표를 추가합니다
					    bounds.extend(positions_array[i].position);
					}
	
					function setBounds() {
					    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
					    // 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
					    map.setBounds(bounds);
					}
					// *** 모든 마커를 보여주기 위해 중심좌표와 비율을 다시 설정하기 끝 *** //
					
					
					
					// *** 선의 거리 계산하기 만들기 시작 ***//
					function gocalc(flag) {
						
						if(flag == '1') {

							var drawingFlag = false; // 선이 그려지고 있는 상태를 가지고 있을 변수입니다
							var moveLine; // 선이 그려지고 있을때 마우스 움직임에 따라 그려질 선 객체 입니다
							var clickLine // 마우스로 클릭한 좌표로 그려질 선 객체입니다
							var distanceOverlay; // 선의 거리정보를 표시할 커스텀오버레이 입니다
							var dots = {}; // 선이 그려지고 있을때 클릭할 때마다 클릭 지점과 거리를 표시하는 커스텀 오버레이 배열입니다.
							
							// 지도에 클릭 이벤트를 등록합니다
							// 지도를 클릭하면 선 그리기가 시작됩니다 그려진 선이 있으면 지우고 다시 그립니다
							daum.maps.event.addListener(map, 'click', function(mouseEvent) {
							
							    // 마우스로 클릭한 위치입니다 
							    var clickPosition = mouseEvent.latLng;
							
							    // 지도 클릭이벤트가 발생했는데 선을 그리고있는 상태가 아니면
							    if (!drawingFlag) {
							
							        // 상태를 true로, 선이 그리고있는 상태로 변경합니다
							        drawingFlag = true;
							        
							        // 지도 위에 선이 표시되고 있다면 지도에서 제거합니다
							        deleteClickLine();
							        
							        // 지도 위에 커스텀오버레이가 표시되고 있다면 지도에서 제거합니다
							        deleteDistnce();
							
							        // 지도 위에 선을 그리기 위해 클릭한 지점과 해당 지점의 거리정보가 표시되고 있다면 지도에서 제거합니다
							        deleteCircleDot();
							    
							        // 클릭한 위치를 기준으로 선을 생성하고 지도위에 표시합니다
							        clickLine = new daum.maps.Polyline({
							            map: map, // 선을 표시할 지도입니다 
							            path: [clickPosition], // 선을 구성하는 좌표 배열입니다 클릭한 위치를 넣어줍니다
							            strokeWeight: 3, // 선의 두께입니다 
							            strokeColor: '#db4040', // 선의 색깔입니다
							            strokeOpacity: 1, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
							            strokeStyle: 'solid' // 선의 스타일입니다
							        });
							        
							        // 선이 그려지고 있을 때 마우스 움직임에 따라 선이 그려질 위치를 표시할 선을 생성합니다
							        moveLine = new daum.maps.Polyline({
							            strokeWeight: 2, // 선의 두께입니다 
							            strokeColor: '#993333', // 선의 색깔입니다
							            strokeOpacity: 0.5, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
							            strokeStyle: 'solid' // 선의 스타일입니다    
							        });
							    
							        // 클릭한 지점에 대한 정보를 지도에 표시합니다
							        displayCircleDot(clickPosition, 0);
							
							            
							    } else { // 선이 그려지고 있는 상태이면
							
							        // 그려지고 있는 선의 좌표 배열을 얻어옵니다
							        var path = clickLine.getPath();
							
							        // 좌표 배열에 클릭한 위치를 추가합니다
							        path.push(clickPosition);
							        
							        // 다시 선에 좌표 배열을 설정하여 클릭 위치까지 선을 그리도록 설정합니다
							        clickLine.setPath(path);
							
							        var distance = Math.round(clickLine.getLength());
							        displayCircleDot(clickPosition, distance);
							    }
							});
							    
							// 지도에 마우스무브 이벤트를 등록합니다
							// 선을 그리고있는 상태에서 마우스무브 이벤트가 발생하면 그려질 선의 위치를 동적으로 보여주도록 합니다
							daum.maps.event.addListener(map, 'mousemove', function (mouseEvent) {
							
							    // 지도 마우스무브 이벤트가 발생했는데 선을 그리고있는 상태이면
							    if (drawingFlag){
							        
							        // 마우스 커서의 현재 위치를 얻어옵니다 
							        var mousePosition = mouseEvent.latLng; 
							
							        // 마우스 클릭으로 그려진 선의 좌표 배열을 얻어옵니다
							        var path = clickLine.getPath();
							        
							        // 마우스 클릭으로 그려진 마지막 좌표와 마우스 커서 위치의 좌표로 선을 표시합니다
							        var movepath = [path[path.length-1], mousePosition];
							        moveLine.setPath(movepath);    
							        moveLine.setMap(map);
							        
							        var distance = Math.round(clickLine.getLength() + moveLine.getLength()), // 선의 총 거리를 계산합니다
							            content = '<div class="dotOverlay distanceInfo">총거리 <span class="number">' + distance + '</span>m</div>'; // 커스텀오버레이에 추가될 내용입니다
							        
							        // 거리정보를 지도에 표시합니다
							        showDistance(content, mousePosition);   
							    }             
							});                 
							
							// 지도에 마우스 오른쪽 클릭 이벤트를 등록합니다
							// 선을 그리고있는 상태에서 마우스 오른쪽 클릭 이벤트가 발생하면 선 그리기를 종료합니다
							daum.maps.event.addListener(map, 'rightclick', function (mouseEvent) {
							
							    // 지도 오른쪽 클릭 이벤트가 발생했는데 선을 그리고있는 상태이면
							    if (drawingFlag) {
							        
							        // 마우스무브로 그려진 선은 지도에서 제거합니다
							        moveLine.setMap(null);
							        moveLine = null;  
							        
							        // 마우스 클릭으로 그린 선의 좌표 배열을 얻어옵니다
							        var path = clickLine.getPath();
							    
							        // 선을 구성하는 좌표의 개수가 2개 이상이면
							        if (path.length > 1) {
							
							            // 마지막 클릭 지점에 대한 거리 정보 커스텀 오버레이를 지웁니다
							            if (dots[dots.length-1].distance) {
							                dots[dots.length-1].distance.setMap(null);
							                dots[dots.length-1].distance = null;    
							            }
							
							            var distance = Math.round(clickLine.getLength()), // 선의 총 거리를 계산합니다
							                content = getTimeHTML(distance); // 커스텀오버레이에 추가될 내용입니다
							                
							            // 그려진 선의 거리정보를 지도에 표시합니다
							            showDistance(content, path[path.length-1]);  
							             
							        } else {
							
							            // 선을 구성하는 좌표의 개수가 1개 이하이면 
							            // 지도에 표시되고 있는 선과 정보들을 지도에서 제거합니다.
							            deleteClickLine();
							            deleteCircleDot(); 
							            deleteDistnce();
							
							        }
							        
							        // 상태를 false로, 그리지 않고 있는 상태로 변경합니다
							        drawingFlag = false;          
							    }  
							});    
							
							// 클릭으로 그려진 선을 지도에서 제거하는 함수입니다
							function deleteClickLine() {
							    if (clickLine) {
							        clickLine.setMap(null);    
							        clickLine = null;        
							    }
							}
							
							// 마우스 드래그로 그려지고 있는 선의 총거리 정보를 표시하거
							// 마우스 오른쪽 클릭으로 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 생성하고 지도에 표시하는 함수입니다
							function showDistance(content, position) {
							    
							    if (distanceOverlay) { // 커스텀오버레이가 생성된 상태이면
							        
							        // 커스텀 오버레이의 위치와 표시할 내용을 설정합니다
							        distanceOverlay.setPosition(position);
							        distanceOverlay.setContent(content);
							        
							    } else { // 커스텀 오버레이가 생성되지 않은 상태이면
							        
							        // 커스텀 오버레이를 생성하고 지도에 표시합니다
							        distanceOverlay = new daum.maps.CustomOverlay({
							            map: map, // 커스텀오버레이를 표시할 지도입니다
							            content: content,  // 커스텀오버레이에 표시할 내용입니다
							            position: position, // 커스텀오버레이를 표시할 위치입니다.
							            xAnchor: 0,
							            yAnchor: 0,
							            zIndex: 3  
							        });      
							    }
							}
							
							// 그려지고 있는 선의 총거리 정보와 
							// 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 삭제하는 함수입니다
							function deleteDistnce () {
							    if (distanceOverlay) {
							        distanceOverlay.setMap(null);
							        distanceOverlay = null;
							    }
							}
							
							// 선이 그려지고 있는 상태일 때 지도를 클릭하면 호출하여 
							// 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 표출하는 함수입니다
							function displayCircleDot(position, distance) {
							
							    // 클릭 지점을 표시할 빨간 동그라미 커스텀오버레이를 생성합니다
							    var circleOverlay = new daum.maps.CustomOverlay({
							        content: '<span class="dot"></span>',
							        position: position,
							        zIndex: 1
							    });
							
							    // 지도에 표시합니다
							    circleOverlay.setMap(map);
							
							    if (distance > 0) {
							        // 클릭한 지점까지의 그려진 선의 총 거리를 표시할 커스텀 오버레이를 생성합니다
							        var distanceOverlay = new daum.maps.CustomOverlay({
							            content: '<div class="dotOverlay">거리 <span class="number">' + distance + '</span>m</div>',
							            position: position,
							            yAnchor: 1,
							            zIndex: 2
							        });
							
							        // 지도에 표시합니다
							        distanceOverlay.setMap(map);
							    }
							
							    // 배열에 추가합니다
							    dots.push({circle:circleOverlay, distance: distanceOverlay});
							}
							
							// 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 지도에서 모두 제거하는 함수입니다
							function deleteCircleDot() {
							    var i;
							
							    for ( i = 0; i < dots.length; i++ ){
							        if (dots[i].circle) { 
							            dots[i].circle.setMap(null);
							        }
							
							        if (dots[i].distance) {
							            dots[i].distance.setMap(null);
							        }
							    }
							
							    dots = [];
							}
							
							// 마우스 우클릭 하여 선 그리기가 종료됐을 때 호출하여 
							// 그려진 선의 총거리 정보와 거리에 대한 도보, 자전거 시간을 계산하여
							// HTML Content를 만들어 리턴하는 함수입니다
							function getTimeHTML(distance) {
							
							    // 도보의 시속은 평균 4km/h 이고 도보의 분속은 67m/min입니다
							    var walkkTime = distance / 67 | 0;
							    var walkHour = '', walkMin = '';
							
							    // 계산한 도보 시간이 60분 보다 크면 시간으로 표시합니다
							    if (walkkTime > 60) {
							        walkHour = '<span class="number">' + Math.floor(walkkTime / 60) + '</span>시간 '
							    }
							    walkMin = '<span class="number">' + walkkTime % 60 + '</span>분'
							
							    // 자전거의 평균 시속은 16km/h 이고 이것을 기준으로 자전거의 분속은 267m/min입니다
							    var bycicleTime = distance / 227 | 0;
							    var bycicleHour = '', bycicleMin = '';
							
							    // 계산한 자전거 시간이 60분 보다 크면 시간으로 표출합니다
							    if (bycicleTime > 60) {
							        bycicleHour = '<span class="number">' + Math.floor(bycicleTime / 60) + '</span>시간 '
							    }
							    bycicleMin = '<span class="number">' + bycicleTime % 60 + '</span>분'
							
							    // 거리와 도보 시간, 자전거 시간을 가지고 HTML Content를 만들어 리턴합니다
							    var content = '<ul class="dotOverlay distanceInfo">';
							    content += '    <li>';
							    content += '        <span class="label">총거리</span><span class="number">' + distance + '</span>m';
							    content += '    </li>';
							    content += '    <li>';
							    content += '        <span class="label">도보</span>' + walkHour + walkMin;
							    content += '    </li>';
							    content += '    <li>';
							    content += '        <span class="label">자전거</span>' + bycicleHour + bycicleMin;
							    content += '    </li>';
							    content += '</ul>'
							
							    return content;
							}
							
						}
						
					}
				
				</script>
			</div>
		    <div class="col-sm-5" align="center">
		    	<div class="row resultHeader">
		    		<div class="col-sm-8">
						<h3 align="right">검색결과 <span id="cnt"></span>건</h3>
					</div>
					<div class="col-sm-4">
		  				<div class="form-group">
							<select class="form-control input-sm" onchange="selectOrderby(event)" >
						        <option value="1">평점순</option>
					    	    <option value="2">거리순</option>
							</select>
						</div>
					</div>
					<div style="width: 100%; height: 87%; overflow-y: auto;" id="cards" >
						<%-- 
					    <div class="card text-left border-secondary">
						  <img class="card-img-top" src="<%= ctxPath %>/resources/img/hospitalimg/bbb.jpg" alt="Card image cap">
						  	<div class="card-body">
							    <h5 class="card-title">서서울동물병원</h5>
							    <p class="card-text">평점 <span class="glyphicon glyphicon-star"></span>
						    							<span class="glyphicon glyphicon-star"></span>
						    							<span class="glyphicon glyphicon-star"></span>
						    							<span class="glyphicon glyphicon-star"></span>
						    							<span class="glyphicon glyphicon-star"></span></p>
							    <a href="#" class="btn btn-primary">예약하기</a>
							</div>
					  	</div>
					  	 --%>
				  		<c:forEach items="${ bizmemList }" var="biz_mem">
				  			<div class="card text-left">
				  			  <input type="hidden" class="idx_biz" value="${biz_mem.idx_biz }"/>
							  <img class="card-img-top" src="<%= ctxPath %>/resources/img/member/prontimg/${biz_mem.prontimg}" alt="Card image cap" onclick="javascript:location.href='<%= ctxPath%>/bizDetail.pet?idx_biz=${biz_mem.idx_biz}'" style="width: 500px; height: 350px;" />
							  	<div class="card-body">
								    <h5 class="card-title" onclick="javascript:location.href='<%= ctxPath%>/bizDetail.pet?idx_biz=${biz_mem.idx_biz}'">${biz_mem.name }</h5>
								    <p class="card-text">평점
								    <c:forEach begin="1" end="${biz_mem.avg_startpoint }">
								    	<span class="glyphicon glyphicon-star"></span>
								    </c:forEach>
								    </p>
								    <c:if test="${ biz_mem.biztype == 1 }">
								    <a href="<%= ctxPath %>/reservation.pet?idx_biz=${biz_mem.idx_biz}" class="btn btn-primary">예약하기</a>
								    </c:if>
								</div>
						  	</div>
				  		</c:forEach>
					</div>
				</div>
			</div>
		</c:if>
		<c:if test="${ cnt == 0 }">
			<div class="col-sm-4"></div>
			<div class="col-sm-4">
				<h3 >검색된 결과가 없습니다.</h3>
			</div>
			<div class="col-sm-4"></div>
		</c:if>
	</div>
</div>



<div class="container" style="margin-top: 10%; margin-bottom: 10%;">
	<div class="row">
		<div class="col-sm-12">	
			<button class="tablink" id="defaultOpen" onclick="openPage('Hospital', this, 'rgb(252, 118, 106)')">동물병원</button>
			<button class="tablink" onclick="openPage('Pharmacy', this, 'rgb(252, 118, 106)')">동물약국</button>
			
			<div id="Hospital" class="tabcontent">
			  <h3 style="color: black;">서울시 공공데이터를 기반으로 '<span style="color: #990000">${ searchWord}</span>'로 검색하여 나온 결과입니다. </h3>
			  <p style="color: black;">※ 바로예약 서비스는 제공되지 않습니다. 내방 전 전화로 먼저 확인하시기 바랍니다. </p>
				<table id="TblHospital"></table>
				<div class="row">
					<div class="col-sm-2"></div>
					<div class="col-sm-8" align="center">
						<div class="pagination pagenation_H"></div>
					</div>
					<div class="col-sm-2"></div>
				</div>
			</div>
			
			<div id="Pharmacy" class="tabcontent">
			  <h3 style="color: black;">서울시 공공데이터를 기반으로 '<span style="color: #990000">${ searchWord}</span>'로 검색하여 나온 결과입니다. </h3>
			  <p>&nbsp;</p>
			 	 <table id="TblPharmacy"></table>
			 	 <div class="row">
					<div class="col-sm-2"></div>
					<div class="col-sm-8" align="center">
						<div class="pagination pagenation_P"></div>
					</div>
					<div class="col-sm-2"></div>
				</div>
			</div>
		</div>
	</div>
</div>


<!-- Modal -->
<div class="modal fade" id="myModal" role="dialog">
  <div class="modal-dialog">
  
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">주소를 입력해주세요</h4>
      </div>
      <div class="modal-body">
	    <form onsubmit="return false;">
		  <div class="form-group" align="center">
			<input type="text" class="form-control" id="address" placeholder="예) 서울시 강남구 논현동 55 " style="width: 50%;" onkeyup="enterGeocoder(event)">
		  </div>
		</form>
      </div>
      <div class="modal-footer">
        <input type="button" class="btn btn-primary" data-dismiss="modal" value="입력" onclick="setGeocoder()">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
    
  </div>
</div>