<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="<%= request.getContextPath() %>/resources/jquery-ui-1.11.4.custom/jquery-ui.js"></script>

<style>
 .span{
	padding-left:5%;
	padding-top: 2%;
	font-weight: bold;
  } 
  .span input  {
   font-weight: normal;
  }
  .btn1{
  
  }
</style>
<script type="text/javascript">
    
	$(document).ready(function(){
		
		$("#register").click(function(){
			// 유효성 검사
			var flag = false;
		      $(".must").each(function() {
		            var data = $(this).val().trim();
		            if(data == ""){
		               alert("필수입력사항입니다.");
		               flag = true;
		               $(this).focus();
		               return false;
		            } else {
		            	flag = false;
		            }
		      });// end of $(".must").each();
		      
				if(flag == true) {
					return;
				} else {
					var frm = document.chartFrm;
					frm.action="<%=ctxPath%>/InsertChartEnd.pet";
					frm.method="POST";
					frm.submit();
				}
		});
		
		  $("#btnplus").click(function(){
			var payment_pay =$("#payment_pay").val();
			var payment_point=$("#payment_point").val();
			var addpay=$("#addpay").val();
			
			var sum = addpay*1+payment_point*1+payment_pay*1;
			
			$("#paytotal").text(sum);
			$("#totalpay").val(sum);
			
		});  // 합계버튼  
	
		//0130 스피너  추가복용약 
		$("#spinnerOqty1").spinner({
	  	      spin: function( event, ui ) {
	  	        if( ui.value > 10 ) {
	  	          $( this ).spinner( "value", 1 ); 
	  	          return false;
	  	        } 
	  	        else if ( ui.value < 1 ) {
	  	          $( this ).spinner( "value", 10 );
	  	          return false;
	  	        }
	  	      }
	  	    });
		
		$("#spinnerOqty1").bind("spinstop", function(){
			
			//var html = "<div class='span col-md-8'>추가 처방 정보</div>";
			var html ="";
			var spinnerOqtyVal = $("#spinnerOqty1").val();
			
			if(spinnerOqtyVal == "0") {
				$("#textbox1").empty();
				return;
			}
			else
			{
				for(var i=0; i<parseInt(spinnerOqtyVal); i++) {
				
					  html +=    '<tr>'+
						         '<td><input type="text" class="must" name="rx_name"/></td>'+
				                 '<td><input type="text" class="must" name="dosage"/></td>'+
				                 '<td><input type="text" class="must" name="dose_number"/></td>'
				                 +  '<td><input type="text" class="must" name="rx_cautions"/></td>'
				       	      +'<td><input type="text" class="must" name="rx_notice"/></td>'
				                 +'</tr>';
				                 
				}
				
				$("#textbox1").empty();
				$("#textbox1").append(html);	
			}
		});
		
		
	      
	      
	});// end of $(document).ready()----------------------
</script>
<div class="container" style=" border:0px solid black;border-radius:10px;margin-bottom:1%; background-color: #eaebed"> 
<Form name="chartFrm" >
  
<div class="row">  
   
   <div class="col-md-12 ">
   <h4 style="text-align:center; padding-top: 6%;">[ ${chartmap.pet_name} ] 님의 진료기록</h4>
   <div class="span col-md-12">1.날짜: <span>${chartmap.reservation_DATE}</span></div>
   <div class="span col-md-12" >2.병원 이름: <span>${sessionScope.loginuser.name}</span></div>
   <div class="span col-md-12" >3.담당의사 이름: 
     <select id="docname" name="doc_name" style="font-weight: normal;">
	     <c:forEach var="map" items="${doclist}">
	       <option value="${map.DOCNAME}">${map.DOCNAME}</option>
	      </c:forEach>
     </select>
   </div>
   <div class="span col-md-12">4.진료 회원 이름: <span>${chartmap.name}</span></div>
   <div class="span col-md-12">5.진료 동물 종류: <span>${chartmap.pet_type}</span></div>
   <div class="span col-md-12">6.진료 동물 이름: <span>${chartmap.pet_name}</span></div>
   <div class="span col-md-12">7.진료종류: <span>${chartmap.reservation_type}</span></div>
  <div class="span col-md-12"><span>8.처방 정보</span>
    <input id="spinnerOqty1"  class="must" value="1" style="width: 30px; height: 20px; padding-top: 5%;">
   <table style="border:1px black solid;">
	   <thead style="text-align: center;">
	    <tr>
	      <th>처방약</th>
	      <th>투약 량</th>
	      <th>하루 복용횟수</th>
	      <th>주의 사항</th>
	      <th>메  모</th>
	    </tr>
	   </thead>
	   <tbody id="textbox1">
	    <tr>
	      <td><input type="text"  class="must" name="rx_name"/></td>
	      <td><input type="text" class="must" name="dosage"/></td>
	      <td><input type="text" class="must" name="dose_number"/></td>
	      <td><input type="text" class="must" name="rx_cautions"/></td>
	      <td><input type="text" class="must" name="rx_notice"/></td>
	    </tr>
	   </tbody>
   </table>
   </div>
   
   <div class="span col-md-12">9.주의 사항: </div>
   <div class="span col-md-12"><textarea  name="cautions" class="must" style="width:50%; height:15%;"></textarea></div>
   <div class="span col-md-12">10.노트 : </div>
   <div class="span col-md-12"><textarea  name="chart_contents" class="must"  style="width:50%; height:15%;"></textarea></div>
   
	<hr style="width:100%; height:3%; color:white;"></hr>
	<c:if test="${rtype==3}">
		<div class="span col-md-8 ">11.사용한 예치금 : <span id="pament_pay"> ${chartmap.payment_pay}원 </span></div>
		<div class="span col-md-8 ">12.사용한 포인트 : <span id="">${chartmap.payment_point} POINT</span></div>
		<div class="span col-md-8 ">13.본인 부담금 :   <span> <input type="number" class="must"  id="addpay" name="addpay" value="0"/>원</span>
		 <button type="button" id="btnplus">총합</button></div>
		<div class="span col-md-8 ">14.총     합 : <span id="paytotal"></span>원</div>
    </c:if>
   
   </div>
    <button type="button" id="register" class="btn1" style="margin-left: 42%; margin-top: 4%;margin-bottom:2%;
       background-color:rgb(252, 118, 106);color:white;width:20%;height:5%;border-radius:4px;">등록하기</button> 
</div>
<input type="hidden" name="fk_reservation_UID" value="${chartmap.fk_reservation_UID}"/>
<input type="hidden" name="fk_pet_UID" value="${chartmap.fk_pet_UID}"/>
<input type="hidden" name="fk_idx" value="${chartmap.fk_idx}"/>
<input type="hidden" name="fk_idx_biz" value="${chartmap.fk_idx_biz}"/>
<input type="hidden" name="chart_UID" value="${chartmap.chart_UID}"/>
<input type="hidden" name="chart_type" value="${chartmap.reservation_type}"/>
<input type="hidden" name="bookingdate" value="${chartmap.bookingdate}"/>
<input type="hidden" name="reservation_DATE" value="${chartmap.reservation_DATE}"/>
<input type="hidden" name="biz_name" value="${sessionScope.loginuser.name}"/>
<input type="hidden" name="name" value="${chartmap.name}"/>
<input type="hidden" name="pet_type" value="${chartmap.pet_type}"/>
<input type="hidden" name="pet_name" value="${chartmap.pet_name}"/>
<input type="hidden" name="reservation_type" value="${chartmap.reservation_type}"/>
<input type="hidden" name="rx_regName" value="${sessionScope.loginuser.name}"/> 
<c:if test="${rtype==3}">
<input type="hidden" name="payment_pay" id="payment_pay"    value="${chartmap.payment_pay}"/>
<input type="hidden" name="payment_point" id="payment_point"  value="${chartmap.payment_point}"/>
<input type="hidden" name="totalpay" id="totalpay" value=""/>
</c:if>

</Form>
</div>