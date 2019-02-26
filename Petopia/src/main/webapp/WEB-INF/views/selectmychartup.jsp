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
		
		var chart_type = "${cinfo.chart_type}";
		
		if(chart_type == "약국") {
			chart_type = "0";
		} else if(chart_type == "일반진료") {
			chart_type = "1";
		} else if(chart_type == "예방접종") {
			chart_type = "2";
		} else if(chart_type == "수술") {
			chart_type = "3";
		} else if(chart_type == "호텔링") {
			chart_type = "4";
		} 
		
		$("#chart_type").val(chart_type);
		
		$("#edit").click(function(){
			var frm = document.chartFrm;
			frm.action="<%=ctxPath%>/UpdatemyChart.pet?chart_uid="+${cinfo.chart_uid};
			frm.method="POST";
			frm.submit();
			opener.reloadPage();
			//window.close();

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
	
	function reloadPage() {
	    location.reload(); 
	}
	
</script>
<div class="container" style="border:0px solid black;border-radius:10px; background-color: #eaebed"> 
<Form name="chartFrm">
<div class="row">  
   
   <div class="col-md-12 ">
   <h4 style="text-align:center; padding-top: 6%;">[${cinfo.pet_name}] 님 진료기록</h4>
   <div class="span col-md-12">1.날짜: <input type="date" name="reservation_DATE" value="${cinfo.reservation_DATE}"/></div>
   <div class="span col-md-12" >2.병원 이름: <input name="biz_name" value="${cinfo.biz_name}"/></div>
   <div class="span col-md-12" >3.담당의사 이름: <input name="doc_name" value="${cinfo.doc_name}"/></div>
   <div class="span col-md-12">4.진료 회원 이름: <input value="${sessionScope.loginuser.name}"/></div>
   <div class="span col-md-12">6.진료 동물 이름: ${cinfo.pet_name}</div>
   <div class="span col-md-12">7.진료종류: 
      <select id="chart_type" name="chart_type" style="font-weight: normal;">
	      <option value="0">약국</option>
	      <option value="1">일반진료</option>
	      <option value="2">예방접종</option>
	      <option value="3">수술</option>
	      <option value="4">호텔링</option>
     </select>
   </div>
  <div class="span col-md-12"><span>8.처방 정보</span>
    <input id="spinnerOqty1" value="1" style="width: 30px; height: 20px; padding-top: 5%;">
   <table style="border:1px black solid;width:50px; ">
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
	      <c:forEach items="${pmap2list}" var="map">
	         <tr>
		      <td><input type="hidden" name="rx_uid" value="${map.rx_uid}"/><input type="text" name="rx_name" value="${map.rx_name}"/></td>
		      <td><input type="text" name="dosage" value="${map.dosage}"/></td>
		      <td><input type="text" name="dose_number" value="${map.dose_number}"/></td>
		      <td><input type="text" name="rx_cautions" value="${map.rx_cautions}"/></td>
		      <td><input type="text" name="rx_notice" value="${map.rx_notice}"/></td>
	         </tr>
	      </c:forEach>
	   </tbody>
   </table> 
   </div>
   
   <div class="span col-md-12">9.주의 사항: </div>
   <div class="span col-md-12"><textarea  name="cautions" style="width:50%; height:15%;">${cinfo.cautions}</textarea></div>
   <div class="span col-md-12">10.노트 : </div>
   <div class="span col-md-12"><textarea  name="chart_contents" style="width:50%; height:15%;">${cinfo.chart_contents}</textarea></div>
   
	<hr style="width:100%; height:3%; color:white;"></hr>
	<c:if test="${cinfo.totalpay != null}">
     <div class="span col-md-8 ">11.총 결제 금액 : <input name="totalpay" value="${cinfo.totalpay}"/>원</div>
    </c:if>
    <c:if test="${cinfo.totalpay == null}">
     <div class="span col-md-8 ">11.총 결제 금액 : <input name="totalpay" value="0"/>원</div>
    </c:if>
   </div>
    <button type="button" id="edit" class="btn1" style="margin-left: 42%; margin-top: 4%;margin-bottom:2%;
       background-color:rgb(252, 118, 106);color:white;width:20%;height:5%;border-radius:4px;">수정하기</button> 
    </div>
    <input  type="hidden" name="puid" value="${puid}"/>
    <input  type="hidden" name="cuid" value="${cuid}"/>
</Form>
</div>