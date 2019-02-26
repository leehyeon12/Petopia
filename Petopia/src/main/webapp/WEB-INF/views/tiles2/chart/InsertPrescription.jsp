<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<style>
 .span{

	 padding-left:5%;
	 padding-top: 2%;
  } 
  .btn1{
  margin-left: 42%;
  margin-top: 4%;
  margin-bottom:2%;
  background-color:rgb(252, 118, 106);
 color:white;
 width:20%;
 height:5%;
 border-radius:4px;
  }
</style>
<script type="text/javascript">
    
	$(document).ready(function(){

		$("#register").click(function(){
			var frm = document.prescriptFrm;
			frm.action="<%=ctxPath%>/InsertPrescriptionEnd.pet";
			frm.method="POST";
			frm.submit();
		});
		
	});// end of $(document).ready()----------------------
</script>
<div class="container"> 
<Form name="prescriptFrm" 
 style="margin-left:18%; border:0px solid black;border-radius:10px;width:70%; background-color: #eaebed">
<div class="row">  
   
   <div class="col-md-12 ">
   <h4 style="text-align:center; padding-top: 6%;">[ ${premap.pet_name} ] 님의 처방전 등록</h4>
   <div class="span col-md-12 ">1.날짜: <span>${premap.reservation_DATE}</span></div>
   <div class="span col-md-12" >2.병원 이름: <span>${sessionScope.loginuser.name}</span></div>
   <div class="span col-md-12">3.진료 회원 이름: <span>${premap.name}</span></div>
   <div class="span col-md-12">4.진료 동물 종류: <span>${premap.pet_type}</span></div>
   <div class="span col-md-12">5.진료 동물 이름: <span>${premap.pet_name}</span></div>
   <div class="span col-md-12">6.처방 약 이름 : <input type="text" name="rx_name"/></div>
   <div class="span col-md-12">7.투약 량 : <input type="text" name="dosage"/></div>
   <div  class="span col-md-12">8.하루 복용 횟수 :<input type="text" name="dose_number"/></div>  
	<div class="span col-md-12"><span>9.주의 사항:</span></div>
	<div class="span col-md-12"><textarea name="rx_cautions" style="width:50%; height:15%;"></textarea></div>
	<div class="span col-md-12"><span>10.노트 : </span></div>
	<div class="span col-md-12"><textarea name="rx_notice" style="width:50%; height:15%;"></textarea></div>
   
   
   </div>
    <button type="button" id="register" class="btn1">등록하기</button> 


</div>
<input type="hidden" name="chart_UID" value="${premap.cuid}"/>
<input type="hidden" name="bookingdate" value="${premap.bookingdate}"/>
<input type="hidden" name="reservation_DATE" value="${premap.reservation_DATE}"/>
<input type="hidden" name="biz_name" value="${sessionScope.loginuser.name}"/>
<input type="hidden" name="name" value="${premap.name}"/>
<input type="hidden" name="pet_type" value="${premap.pet_type}"/>
<input type="hidden" name="pet_name" value="${premap.pet_name}"/>
<input type="hidden" name="rx_regName" value="${sessionScope.loginuser.name}"/>
</Form>
</div>
