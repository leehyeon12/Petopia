<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@page import="java.text.SimpleDateFormat"%>

<%@page import="java.util.Calendar"%>


<style>


.divbox1{ /*전체 */
   margin-top: 3%;
   width:75%;
   background-color: #eaebed; 
   border: 0px solid gray;
   border-radius:10px;
   margin-bottom: 1%;
}

.divbox2{ /* 이미지 */
margin-top:3%;
display:inline-block;
}

.divbox3{ 
/* 펫정보*/
border: 1px solid gray; 
witdh:80%; 
height:20%; 
margin-top:3%;
padding-left:1%;
background-color:white;
padding-bottom:3%;
border-radius:10px;
}

.divbox4{ 
/* 캘린더 자리 */
 margin-top:3%;
 margin-bottom:5%;
 border: 1px solid gray;
 witdh:80%; 
 
 margin-top:3%;
 padding:3% 3% 3% 3%;
 border-radius:10px;
 background-color:white;
}

.divbox5{ /* 마지막 탭  */
background-color:white;
border: 1px solid gray;
border-top-style:none;
margin-top:5%;

padding-top:1%;
border-radius:10px; 
margin-bottom: 1%;
width:100%;

}
.btn2{
background-color:rgb(252, 118, 106);
color:white;
width:20%;
height:5%;
border-radius:15px;
margin-left: 38%;
margin-top: 1%;
margin-bottom: 2%;
}
.h3_1 {
margin-left: 1%;
margin-top:2%;
color:rgb(252, 118, 106);
}

.span{
	 
  } 

</style>
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/fullcalendar.css"> 
<link rel="stylesheet" href="<%=ctxPath%>/resources/css/fullcalendar.min.css">

<script type="text/javascript" src="<%=ctxPath%>/resources/js/ko.js"></script>
<script type="text/javascript">
    
	$(document).ready(function(){
		
		//ajaxData();
			 
			/*  onclick -> 사진에
			var classes = $(this).attr('class');
			 //alert(classes); //petimg petUid3
			 var str_classes = String(classes); // String으로 변환
			 var index = str_classes.indexOf('petUid'); // petUid의 자릿수
			 //alert(index); // 7
			 var petUid = str_classes.substring(index+6);
			 //alert(petUid);
			
			 $("#petUidNo").val(petUid); */
			 
			// 펫정보 불러오기
			 showPet(); // 1
			// 함수 showPet은 puid를 이용하여 한 마리의 반려동물 정보 불러오기 (ajax)
			
			// 캘린더  클릭한 펫이미지의 스케줄을 달력으로 불러오기 
		

			 $('#calendar').fullCalendar({
			 selectable: true,
		      header: {
		        left: 'prev,next today',
		        center: 'title',
		        right: 'month,agendaSevenDay,agendaDay' 
		      },
		      contentHeight: 600,
		      views: {
		    	  agendaSevenDay: {
		    	     type: 'agenda',
		    	     duration: { days: 7 },
		    	     buttonText: 'week'
		    	   }
			  },
			  defaultView: 'month',
			  visibleRange: function(currentDate) {
		          return {
		            start: currentDate.clone().subtract(1, 'days'),
		            end: currentDate.clone().add(7, 'days') // exclusive end, so 3
		          };
		      },
		      lang: "ko",
		      events: function(start, end, timezone, callback){
		    	  
		    	  var data = {"fk_pet_uid":$("#petUidNo").val()};
		    	 
		    	  $.ajax({
		    		  url: "<%=request.getContextPath()%>/selectMyPrescription.pet",
		    		  type: "GET",
		    		  data: data,
		    		  dataType: "JSON",
		    		  success: function(json){
		    			  var events=[];
		    			  $.each(json, function(entryIndex,entry){
		    				  
		    				  events.push({
		        					id: entry.chart_uid,
		            				title: entry.chart_type, 
		            				start: entry.reservation_date,
		            				end: entry.reservation_date,
		            				backgroundColor: "gray"
		        				});
		    			  });
		    			  callback(events);
		    		  },
		    		  error: function(request, status, error){
		        			if(request.readyState == 0 || request.status == 0) return;
		        			//else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        		}
		    	  }); // end of ajax();
		    	 
		      } //end of events;
		      
		  }); // end 
		  
			
		        
		$(".datetab").click(function(){ //날짜 탭을 누르면 
		
			var tabs =$(this).attr('class');
			//alert(tabs);
			var str_tabs =String(tabs);
			
			var index=str_tabs.indexOf('rdate');
			//alert(index);//8
			var redate = str_tabs.substring(index+5);
			//alert(redate);
			
			$("#reservedate").val(redate);
			
			showPreinfo(); //처방전 인서트 기본창 정보 불러오기 
		});
	 
	//수정하기하기 버튼 
	 $("#edit").click(function(){
		 
		var frm=document.editFrm;
		frm.action = "<%=ctxPath%>/UpdateMyChartEnd.pet";
		frm.method="POST";
		frm.submit();
	 });
	
	});// end of $(document).ready()----------------------
	
	function showPet(){
         var data = {"fk_pet_uid":$("#petUidNo").val()};
          $.ajax({
    		  url: "<%=request.getContextPath()%>/getPinfobyminpuid.pet",
    		  type: "GET",
    		  data:data,
    		  dataType: "JSON",
    		  success: function(json){ 
    			  $("#container").empty();
    			  var html = "<p style='padding-top:1%;'>생년월일: "+json.pet_birthday+"</p></br>"
    			             +"<p>성별: "+json.pet_gender+"</p></br>"
    			             +"<p>몸무게: "+json.pet_weight+"kg</p>";
    			  $("#container").append(html);
    		  },error: function(request, status, error){
		           if(request.readyState == 0 || request.status == 0) return;
		        else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	                }
    		  });
	 }// show pet end
	 //탭 클릭시 처방전 기본정보 불러오기 
	 function showPreinfo(){
		 var data ={"reservedate":$("#reservedate").val()};
		    $.ajax({
	    		  url: "<%=request.getContextPath()%>/selectMyPreInfo.pet",
	    		  type: "GET",
	    		  data:data,
	    		  dataType: "JSON",
	    		  success: function(json){ 
	    			  $("#infocontainer").empty();
	    			  $("#infocontainer2").empty();
	    			  var html1 = "<h3>"+json.biz_name+"</h3>"
	    			             +"<p>"+json.bookingdate+"</p>"
	    			             +"<p>"+json.reservation_DATE+"</p>";
	    			  
	    			  var html2="<p>결제 포인트: "+json.payment_point+"POINT</p>"+
				    			   "<p>추가 결제금액: "+json.addpay+"원</p>"+
				    			   "<p>실제 결제 금액: "+json.payment_pay+"원</p>"+
				    			   "<p> 총  합 : "+json.payment_total+"원</p>";          
	    			  $("#infocontainer").append(html1);
	    			  $("#infocontainer2").append(html2);
	    		  },error: function(request, status, error){
			           if(request.readyState == 0 || request.status == 0) return;
			        else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		                }
	    		  });
	 }
	
</script>
<div class="container divbox1">
   <h3 class="h3_1">진료기록 관리하기</h3>
   
   <div class="row" >
   
	   <c:forEach items="${pmaplist}" var="pvo" varStatus="status">
		    <div class="col-md-3" style="display:inlineblock;float:left;">
			    <input type="hidden" value="${pvo.pet_uid}" id="imgpuid${pvo.pet_uid}"/>
			    <img src="<%=ctxPath%>/resources/img/chart/${pvo.pet_profileimg}" onclick="javascript:location.href='<%=ctxPath%>/InsertMyPrescription.pet?puid=${pvo.pet_uid}'"  class="petimg petUid${pvo.pet_uid}" width="30%"style="border-radius: 50%;display:block;"/> 
			    <span style="font-weight: bold;padding-left: 10%;">[${pvo.pet_name}] 님</span>
		    </div>
	    </c:forEach>
  
   </div>
  
  <div class="divbox3">
  <input type="hidden" id="petUidNo" value="${minpuid}"/>
	   <div id="container" Style="width:100%; padding-top: 1%;">
			  <p style="padding-top:1.5%;">생년월일: ${minpinfo.pet_birthday}</p>
			  <p>성별:   ${minpinfo.pet_gender}</p>
			  <p>몸무게: ${minpinfo.pet_weight} kg</p>
	   </div>
  </div>
   <!-- 달력칸  -->
<div class="divbox4" id="content" style="width:100%" >
	<div id="calendar">
	</div>
</div>

 
<div class="tab-content divbox5 container">
   <div class="container" Style="width:100%;">
	    <ul class="nav nav-tabs">
		    <c:forEach items="${myreservedaylist}" var="daymap">
		    <input type="hidden" id="redate${daymap.reservedate}" value="${daymap.reservedate}">
			   <li><a data-toggle="tab" href="#home" class="datetab rdate${daymap.reservedate}">${daymap.reservation_date}-${daymap.chart_type}</a></li>
			</c:forEach>
			
	    </ul>
    </div>
    <form name="editFrm">
    <div id="home" class="tab-pane fade in active" style="padding-left:2%;">
       <div id="infocontainer">
        <input type="hidden" id="reservedate"/>
	       <h3>${mypreinfo.biz_name}</h3>
	       <p>진료예약일자: ${mypreinfo.bookingdate} </p>
	       <p>방문일자: ${mypreinfo.reservation_DATE}</p>
       </div>
       <hr Style="width:100%; height:2%;"></hr>
        <div class="span col-md-10"><h3 style="font-weight:bold;color:pink; margin-top:0">진료결과 </h3></div>
        <div class="span col-md-10"><p>담당수의사: ${mypreinfo.doc_name}</p></div>
        <div class="span col-md-10"><p>처방약: </p><input type="text" name="rx_name" style="margin-bottom: 1%;"/></div>
        <div class="span col-md-10"><p>하루 복용 횟수 :</p><input type="text" name="dose_number" style="margin-bottom: 1%;"/></div>
        <div class="span col-md-10"><p>복용량: </p><input type="text" name="dosage" style="margin-bottom: 1%;"/></div>
        <div class="span col-md-10"><p>주의사항: </p><textarea name="rx_cautions" style="width:40%;height:20%; margin-bottom: 1%;"></textarea></div>
        <div class="span col-md-10"><p>내  용: </p><textarea name="rx_notice" style="width:40%;height:20%;"></textarea></div>
        <hr style="width:100%; height:2%;"></hr>
        <div style="margin-left: 70%;" id="infocontainer2">
	       <p>결제 포인트: ${mypreinfo.payment_point} POINT</p>
	       <p>본인 부담금:${mypreinfo.addpay} 원</p>
	       <p>실제 결제 금액:${mypreinfo.payment_pay}원</p>
	       <p>진료비 총액: ${mypreinfo.payment_total} 원</p>
        </div>
      </div>
        <input type="hidden" value="${sessionScope.loginuser.name}" name="rx_regname"/>
        </form>
       
        <button type="button" class="btn3" id="edit">수정하기</button> 
    </div> <!--  컨테이너 5 -->
   
</div>



