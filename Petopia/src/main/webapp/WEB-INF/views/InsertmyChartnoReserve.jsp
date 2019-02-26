<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">

	<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" type="text/css" />
	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.css">
	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar-scheduler/1.9.4/scheduler.css">
	  
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" defer="defer"></script> 
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.1/moment.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.js"></script>
	<script type="text/javascript" src="https://fullcalendar.io/releases/fullcalendar-scheduler/1.9.4/scheduler.min.js"></script>
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
						frm.action="<%=ctxPath%>/InsertmyChartnoReserveEnd.pet";
						frm.method="POST";
						frm.submit();
						//window.close();
			}
		});
		
	
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
<div class="container" style=" border:0px solid black;border-radius:10px;background-color: #eaebed"> 
<Form name="chartFrm" >
<div class="row">  
   
   <div class="col-md-12 ">
   <!-- <h4 style="text-align:center; padding-top: 6%;">[ ] 님의 진료기록</h4> -->
   <h4>개인 진료 기록하기</h4>
   <div class="span col-md-12">1.날짜: <input type="date" class="must" name="reservation_DATE"/></div>
   <div class="span col-md-12" >2.병원 이름: <input name="biz_name" class="must" /></div>
   <div class="span col-md-12" >3.담당의사 이름: <input name="doc_name" class="must" /></div>
   <div class="span col-md-12">4.진료 회원 이름: <span>${sessionScope.loginuser.name}</span></div>
   <div class="span col-md-12">5.진료 동물 종류:  ${pmap.pet_type}</div>
   <div class="span col-md-12">6.진료 동물 이름: ${pmap.pet_name}</div>
   <div class="span col-md-12">7.진료종류: 
      <select id="docname" name="chart_type" style="font-weight: normal;">
          <option value=''>-- 선택 --</option>
	      <option value="0">약국</option>
	      <option value="1">일반진료</option>
	      <option value="2">예방접종</option>
	      <option value="3">수술</option>
	      <option value="4">호텔링</option>
     </select>
   </div>
  <div class="span col-md-12"><span>8.처방 정보</span>
    <input id="spinnerOqty1" value="1" style="width: 30px; height: 20px; padding-top: 5%;">
   <table style="border:1px black solid;width:50%; ">
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
	      <td><input type="text" class="must" name="rx_name"/></td>
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
   <div class="span col-md-12"><textarea  name="chart_contents" class="must" style="width:50%; height:15%;"></textarea></div>
   
	<hr style="width:100%; height:3%; color:white;"></hr>
    <div class="span col-md-8 ">11.총 결제 금액 : <input name="totalpay"/>원</div>
   </div>
    <button type="button" id="register" class="btn1" style="margin-left: 42%; margin-top: 4%;margin-bottom:2%;
       background-color:rgb(252, 118, 106);color:white;width:20%;height:5%;border-radius:4px;">등록하기</button> 
    </div>
    <input  type="hidden" name="puid" value="${puid}"/>
<%-- <input type="hidden" name="fk_pet_UID" value="${chartmap.fk_pet_UID}"/>
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
<input type="hidden" name="totalpay" id="totalpay" value=""/>
</c:if>
 --%>
</Form>
</div>