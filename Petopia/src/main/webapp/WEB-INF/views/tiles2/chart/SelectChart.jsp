<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="<%= request.getContextPath() %>/resources/jquery-ui-1.11.4.custom/jquery-ui.js"></script>

<style>
 .span{
	padding-left:5%;
	padding-top: 2%;
  } 
  .btn1{
  
  }
</style>
<script type="text/javascript">
    
	$(document).ready(function(){
		
		var dname="${cmap.doc_name}";
		$("#docname").val(dname);
		// alert(dname);
		
		$("#Edit").click(function(){
			var frm = document.chartFrm;
			frm.action="<%=ctxPath%>/EditChart.pet";
			frm.method="POST";
			frm.submit();
		});
		
		//0131 스피너  추가복용약 
		$("#spinnerOqty1").spinner({
	  	      spin: function( event, ui ) {
	  	        if( ui.value > 10 ) {
	  	          $( this ).spinner( "value", 0 ); 
	  	          return false;
	  	        } 
	  	        else if ( ui.value < 1 ) {
	  	          $( this ).spinner( "value", 10 );
	  	          return false;
	  	        }
	  	      }
	  	    });
		
		$("#spinnerOqty1").bind("spinstop", function(){
			
			var html = "";
			
			var spinnerOqtyVal = $("#spinnerOqty1").val();
			
			if(spinnerOqtyVal == "0") {
				$("#textbox1").empty();
				return;
			}
			else
			{
				for(var i=0; i<parseInt(spinnerOqtyVal); i++) {
					html += '<tr>'+
					         '<td><input type="text" name="rx_name"/></td>'+
			                 '<td><input type="text" name="dosage"/></td>'+
			                 '<td><input type="text" name="dose_number"/></td>' 
			                 +  '<td><input type="text" name="rx_cautions"/></td>'
				       	      +'<td><input type="text" name="rx_notice"/></td>'
				                 +'</tr>';
				}
				
				$("#textbox1").empty();
				$("#textbox1").append(html);	
			}
		});
		
		
	});// end of $(document).ready()----------------------
</script>
<div class="container" style=" border:0px solid black;border-radius:10px;margin-bottom:1%; background-color: #eaebed"> 
<Form name="chartFrm">
  
<div class="row">  
   
   <div class="col-md-12 ">
   <h4 style="text-align:center; padding-top: 6%;">[ ${cmap.pet_name} ] 님의 진료기록</h4>
   <div class="span col-md-12">1.날짜: <span>${cmap.reservation_DATE}</span></div>
   <div class="span col-md-12" >2.병원 이름: <span>${sessionScope.loginuser.name}</span></div>
   <div class="span col-md-12" >3.담당의사 이름: 
     <select id="docname" name="doc_name" style="font-weight: normal;">
           
	      <c:forEach var="map" items="${doclist}">
	       <option value="${map.DOCNAME}">${map.DOCNAME}</option>
	      </c:forEach>
     </select>
   </div>
   <div class="span col-md-12">4.진료 회원 이름: <span>${cmap.name}</span></div>
   <div class="span col-md-12">5.진료 동물 종류: <span>${cmap.pet_type}</span></div>
   <div class="span col-md-12">6.진료 동물 이름: <span>${cmap.pet_name}</span></div>
   <div class="span col-md-12">7.진료종류: <span>${cmap.reservation_type}</span></div>
   
   <div class="span col-md-12"><span>8.처방 정보</span>
    <input id="spinnerOqty1" value="1" style="width: 30px; height: 20px; padding-top: 5%;">
    <table style="border:1px black solid;">
	   <thead style="text-align: center;">
	    <tr>
	      <th>처방약</th>
	      <th>투약 량</th>
	      <th>하루 복용횟수</th>
	      <th>주의 사항</th>
	      <th>노  트 </th>
	    </tr>
	   </thead>
	   <tbody id="textbox1">
	     <c:forEach var="pmap" items="${pmap2list}">
	     <tr>
	      <td><input type="hidden" name="rx_uid" value="${pmap.rx_uid}"/><input type="text" name="rx_name" value="${pmap.rx_name}"/></td>
	      <td><input type="text" name="dosage" value="${pmap.dosage}"/></td>
	      <td><input type="text" name="dose_number" value="${pmap.dose_number}"/></td>
	      <td><input type="text" name="rx_cautions" value="${pmap.rx_cautions}"/></td>
	      <td><input type="text" name="rx_notice" value="${pmap.rx_notice}"/></td>
	      </tr>
	     </c:forEach>
	   </tbody>
   </table>
   </div> 
   
   <div class="span col-md-12">9.주의 사항: </div>
   <div class="span col-md-12"><textarea  name="cautions" style="width:50%; height:15%;" placeholder="">${cmap.cautions}</textarea></div>
   <div class="span col-md-12">10.노트 : </div>
   <div class="span col-md-12"><textarea  name="chart_contents" style="width:50%; height:15%;"placeholder="">${cmap.chart_contents}</textarea></div>
   <c:if test="${rtype==3}">
	   <div class="span col-md-8 ">11.사용한 예치금 : <span id="pament_pay"> ${cmap.payment_pay}원 </span></div>
	   <div class="span col-md-8 ">12.사용한 포인트 : <span id="">${cmap.payment_point} POINT</span></div>
	   <div class="span col-md-8 ">13.본인 부담금 : <span> ${cmap.addpay}원</span></div>
	   <div class="span col-md-8 ">14.총     합 : ${cmap.totalpay}원</div>
   </c:if>
    <button type="button" id="Edit" class="btn1" style="margin-left: 42%; margin-top: 4%;margin-bottom:2%;
       background-color:rgb(252, 118, 106);color:white;width:20%;height:5%;border-radius:4px;">수정하기</button> 

</div>
</div>
<input type="hidden" name="fk_pet_UID" value="${cmap.fk_pet_UID}"/>
<input type="hidden" name="fk_idx" value="${cmap.fk_idx}"/>
<input type="hidden" name="fk_idx_biz" value="${cmap.fk_idx_biz}"/>
<input type="hidden" name="chart_UID" value="${cmap.chart_UID}"/>
<input type="hidden" name="chart_type" value="${cmap.reservation_type}"/>
<input type="hidden" name="bookingdate" value="${cmap.bookingdate}"/>
<input type="hidden" name="reservation_DATE" value="${cmap.reservation_DATE}"/>
<input type="hidden" name="biz_name" value="${sessionScope.loginuser.name}"/>
<input type="hidden" name="name" value="${cmap.name}"/>
<input type="hidden" name="pet_type" value="${cmap.pet_type}"/>
<input type="hidden" name="pet_name" value="${cmap.pet_name}"/>
<input type="hidden" name="reservation_type" value="${cmap.reservation_type}"/>
<c:if test="${rtype==3}">
	<input type="hidden" name="payment_pay" id="payment_pay"    value="${cmap.payment_pay}"/>
	<input type="hidden" name="payment_point" id="payment_point"  value="${cmap.payment_point}"/>
</c:if>
</Form>
</div>