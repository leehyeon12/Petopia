<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<style> 
.search {
  width: 130px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  background-color: white;
  background-position: 10px 10px; 
  background-repeat: no-repeat;
  padding: 12px 20px 12px 12px;
  -webkit-transition: width 0.4s ease-in-out;
  transition: width 0.4s ease-in-out;
}

.search:focus {
  width: 100%;
}
td{
	text-align: center;
	font-size: 13px;
}
th{
	text-align: center;
	font-size: 15px;
}

.pagination a {
  color: black;
  float: left;
  padding: 8px 16px;
  text-decoration: none;
  transition: background-color .3s;
}

.pagination a.active_p {
  background-color: rgb(255, 110, 96);
  color: white;
  pointer-events: none;
  cursor: default;
}
</style>
<script type="text/javascript">
	

</script>
<div class="container">
  <h2>병원 예약 관리</h2>
  <p>예약내역을 확인할 수 있습니다.</p>  
  <i class="glyphicon glyphicon-search"></i><input class="form-control search" id="myInput" type="text" name="search" placeholder="Search..">
  <br>
  <table class="table table-bordered table-striped">
    <thead>
      <tr>
        <th>예약번호</th>
        <th>회원명</th>
        <th>회원연락처</th>
        <th>진료과</th>
        <th>반려동물명</th>
        <th>진료타입</th>
        <th>진료일시</th>
        <th>예약일시</th>
        <th>예약상태</th>
        <!-- -버튼 1: 예약완료 2결제(차트작성 처방전작성 노쇼// 예약상태업데이트) 3 진료완료(진료완료 진료기록상세보기)4:노쇼 -->
        <th>진료차트</th>
        <th>취소</th>
        <th>노쇼</th>
      </tr>
    </thead>
    <tbody id="myTable">
      <c:forEach var="rmap" items="${rvchartList}">
      <tr>
		<td>${rmap.reservation_UID}</td>
        <td>${rmap.name}</td>
        <td>${rmap.phone}</td>
        <td>${rmap.pet_type}</td>
        <td>${rmap.pet_name}</td>
        <td>${rmap.reservation_type}</td>
        <td>${rmap.reservation_DATE}</td>
        <td>${rmap.bookingdate}</td>
        <td>
        <c:if test="${rmap.reservation_status=='1'}">
        	<button type="button" class="btn btn-rounder btnmenu">결제대기</button>
        </c:if>
        </td>
        <td>
          <c:if test="${rmap.reservation_status=='2'}"> <!-- 차트처방전 기록이 없으면 클릭 인서트  -->
        	<button type="button" class="btn btn-rounder btnmenu" onclick="location.href='<%=ctxPath%>/InsertChart.pet?reservation_UID=${rmap.reservation_UID}'">차트</button>
            <input type="hidden" name="reservation_UID" value="reservation_UID"/>
          </c:if>  
           <c:if test="${rmap.reservation_status=='3'}"> <!-- 차트처방전 기록이  있으면 셀렉트  -->
        	<button type="button" class="btn btn-rounder btnmenu" style="color: rgb(255, 110, 96); background-color: white;" onclick="location.href='<%=ctxPath%>/SelectChart.pet?reservation_UID=${rmap.reservation_UID}'">차트</button>
            <input type="hidden" name="reservation_UID" value="reservation_UID"/>
          </c:if>
        </td>  
        <td>
        	<c:if test="${rmap.reservation_status=='1'|| rmap.reservation_status=='2'}">
        	<button type="button" class="btn btn-rounder btnmenu" onClick="goRsvCancle(${rmap.reservation_UID})">취소</button>
        	</c:if>
        	<c:if test="${rmap.reservation_status=='3' || rmap.reservation_status=='4' || rmap.reservation_status=='5'}">
        	<a class="btn btn-rounder btnmenu" style="color: white; background-color: gray; cursor: default;">취소</a>
        	</c:if>
        </td>
          <td>
	          <c:if test="${rmap.reservation_status=='4'}">
	        	<button type="button" class="btn btn-rounder btnmenu" onclick="goNoshow()">노쇼</button>
	            <input type="hidden" name="reservation_UID" id="noshow" value="${rmap.reservation_UID}"/>
	          </c:if>
	           <c:if test="${rmap.reservation_status=='5'}">
	           <a class="btn btn-rounder btnmenu" style="color: white; background-color: gray; cursor: default;">노쇼</a>
	          </c:if>
         </td>
      </tr>
	  </c:forEach>
    </tbody>
  </table>
  <div class="text-center">${pageBar}</div>
 
</div>


<script type="text/javascript">
$(document).ready(function(){
  $("#myInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#myTable tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
  
   
});

function goNoshow(){
	   var data ={"reservation_UID":$("#noshow").val()};
	$.ajax({
		  url: "<%=request.getContextPath()%>/goNoshow.pet",
		  type: "GET",
		  data: data,
		  dataType: "JSON",
		  success: function(json){
			
				 alert("노쇼 처리되었습니다.");
				
			  
		  },
		  error: function(request, status, error){
  			if(request.readyState == 0 || request.status == 0) return;
  			else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
  		}
	  }); // end of ajax();
	
} //end of  gonoshow
</script>