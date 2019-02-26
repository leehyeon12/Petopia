<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>	
<style>
.container-fluid {
	padding-top: 70px;
	padding-bottom: 70px;
}
.noneBorderText{
  padding: 3px;
  border: none;
  font-size: 13px;
  height: 13px; 
  border-bottom: 1px solid #A6A6A6;
}
.selectedEvent{
	border-color: rgb(252, 118, 110);
	background-color: rgb(252, 118, 106);
}
</style>

<script type="text/javascript">
 $(document).ready(function(){
// [190120] 주석 삭제, 진료타입 선택 jquery 추가
	$("#rvType").bind("change", function(){
		var rvType=$("#rvType").val();
		$("#reservation_type").val(rvType);
		if(rvType == "3"){
			$("#notice_reservation").html("<span style='color: red; text-decoration: underline;'>수술 선택시 예치금 10만 코인이 결제됩니다.</span>");
		}
		else{
			$("#notice_reservation").html("");
		}
	});
// [190119]
// #펫목록에서 선택시 아래에 정보 자동 입력
//	[190129] 쓸모없는 코드 삭제
	$("#selectPet").bind("change", function(){
		var pet_UID = $("#selectPet").val();
		var form_data = {"pet_UID" : pet_UID};
			
		$.ajax({
			url: "selectPetOne.pet",
			type: "GET",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				$("#pet_name").val(json.pet_name);
				
				if(json.pet_gender == "1"){
					$("#gender1").attr('checked', true);
				}
				else if(json.pet_gender == "2"){
					$("#gender2").attr('checked', true);
				}
				$("#pet_size").text(json.pet_size);
				$("#pet_weight").text(json.pet_weight);
				$("#pet_UID").val(json.pet_UID);
				$("#fk_pet_UID").val(json.pet_UID);
				$("#mypetopt").text(json.pet_type);
				$("#pet_type").val(json.pet_type);
			},// end of success
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});// end of $.ajax
	});
 	
    $('#calendar').fullCalendar({
      selectable: true,
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaSevenDay,agendaDay' 
      },
      contentHeight: 300,
      views: {
    	  agendaSevenDay: {
    	     type: 'agenda',
    	     duration: { days: 7 },
    	     buttonText: 'week'
    	   }
	  },
      defaultView: 'agendaSevenDay',
      visibleRange: function(currentDate) {
          return {
            start: currentDate.clone().subtract(1, 'days'),
            end: currentDate.clone().add(7, 'days') // exclusive end, so 3
          };
      },
      events: function(start, end, timezone, callback){
    	  // [190129] form_data에 idx_biz 고정값 삭제, 변수 추가
    	  var idx_biz = ${bizmvo.idx_biz};
    	  var form_data = {"idx_biz": idx_biz};
        	
        	$.ajax({
        		url: "selectScheduleList.pet",
        		type: "GET",
        		data: form_data,
        		dataType: "JSON",
        		success: function(json){
        			var events = [];
        			$.each(json, function(entryIndex, entry){
        				var schstatus = entry.schedule_status;
        				if(schstatus=="1"){
	        				events.push({
	        					id: entry.schedule_UID,
	            				title: entry.title, 
	            				start: entry.start,
	            				end: entry.end,
	            				backgroundColor: "gray"
	        				});
        				}
        				else {
        					events.push({
            					id: entry.schedule_UID,
                				title: entry.title, 
                				start: entry.start,
                				end: entry.end
            				});
    					}
        				
        			});
        			callback(events);
        		},// end of success
        		error: function(request, status, error){
        			if(request.readyState == 0 || request.status == 0) return;
        			else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        		}
        	});// end of $.ajax
      }	
      ,	
      eventClick: function(eventObj) {
    	  // [190129] 이벤트객체 중복선택 막기
    	  	var fcevent = $(".fc-time-grid-event").parent();
    	  	fcevent.not($(this)).find('a').removeClass("selectedEvent");
    	  	
    	  	$(this).addClass("selectedEvent"); 
	  		  
	  		var scheduledate = chageDateFormat(eventObj.start);
	  		$("#schedule_date").text(scheduledate);
	  		$("#reservation_DATE").val(eventObj.start);
	  		$("#fk_schedule_UID").val(eventObj.id);
     	}
    });
	 
 });
 
 
 function goReset(){
	 $("#mypetopt").html("");
	 $("#animalopt").val("");
	 
	 $("#schedule_date").html("");
	 $("#schedule_UID").val("");
	 
 }
 
// [190120] 예약하기 함수 생성
 function goReservation(){
	 var frm = document.reservationFrm;
	 var mypetopt = $("#mypetopt").text();
	 var schedate = $("#schedule_date").text();
	 var rvtype=frm.reservation_type.value;
	 if(mypetopt=="" || mypetopt == null){
		 alert("진료받을 반려동물을 선택하세요.");
		 $("#selectPet").focus();
		 return false;
	 }
	 if(schedate=="" || schedate==null){
		 alert("진료일시를 선택하세요.");
		 return false;
	 }
	 if(rvtype == null || rvtype ==""){
		 alert("진료타입을 선택하세요.")
		 $("#rvtype").focus();
		 return false;
	 }
	 else{
		 var flag = confirm("[병원명: ${bizmvo.name}/진료일시: "+schedate+"] 예약하시겠습니까?");
		 if(flag){
			 if(rvtype=="3"){
				 
				 frm.action = "<%=request.getContextPath()%>/goReservationSurgery.pet";
				 frm.method = "POST";
				 frm.submit();
			 }
			 else{
				 frm.action = "<%=request.getContextPath()%>/goReservation.pet";
				 frm.method = "POST";
				 frm.submit();
			 } 
		 }
		 else{
			 goReset();
			 return false;
		 }
	 }
	 
 }
// ---------------------------------

	function chageDateFormat(date) {
//		"Tue  Jan  22   2019       09:    00:    00 GMT+0000" -> "yyyy-mm-dd hh24:mi"
//		 0123 4567 8910 1112131415 161718 192021
//		String[] weekend = {"Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"};
		var Months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		var result = "";
		date = date.toString();
		result += date.substring(11, 15);
		for(var i=0; i<Months.length; i++) {
			if(date.substring(4,7) == Months[i]) {
				if(i+1<10) {
					result += "년 0"+(i+1);
				}
				else {
					result += "년 "+(i+1);
				}
			}
		}
		result += "월 "+date.substring(8, 10) + "일 "+date.substring(16, 21);
		
		console.log("날짜 포맷 변환 결과: "+result);
		return result;
	}


</script>
<div class="container">
	<!-- Container (Pricing Section) -->
	<div id="pricing" class="container-fluid">
	  <div class="text-center">
	    <h2>Reservation</h2>
	    <h4>원하시는 날짜와 시간을 선택하세요.</h4>
	  </div>
	  <div class="row slideanim">
	    <div class="col-sm-4 col-xs-12">
	      <div class="panel panel-default text-center">
	        <div class="panel-heading">
	          <h3>My Pet Info</h3> 
	        </div>
	        <div class="panel-body text-left">
	        	<!-- <p>
	        		<label class="radio-inline"><input type="radio" id="mainPet" name="optradio">기존정보</label>
					<label class="radio-inline"><input type="radio" id="newPet" name="optradio">새로입력하기</label>
				</p> -->
	          <p class="myPetList">
	          	<label for="sel1">반려동물을 선택하세요</label>
	          	 <c:if test="${petList == null || petList.size() == 0 }">
			      등록된 반려동물이 없습니다. <br/>
			      나의 반려동물에서 정보를 추가한 후 진행해주세요.
			      <button type="button" class="btn btn-default" onClick="javascript: location.href='<%=ctxPath%>/petRegister.pet'">반려동물 등록하기</button>
			     </c:if>
			     <c:if test="${petList != null && petList.size() > 0 }">
			      <select class="form-control " id="selectPet">
			      	<option value="0">나의 반려동물</option>
			      <c:forEach var="petvo" items="${petList}">
			        <option value="${petvo.pet_UID}">${petvo.pet_name}</option>
			      </c:forEach>
			      </select>
			     </c:if>
			   </p>  
	          <!-- [190120] 반려동물 이름 삭제, 동물군 select 타입 삭제, input 태그로 교체-->
	          <div class="form-group">
	          	<label class="col">동물군</label>
	          	<input class="form-control" id="pet_type" readonly/>
	          </div>
	          <div class="form-group">
	          	<label class="col">성별</label>
	          	<div class="">
	          	<label class="radio-inline"><input type="radio" id="gender1" name="genderradio" value="1" disabled/>남</label>
			  	<label class="radio-inline"><input type="radio" id="gender2" name="genderradio" value="2" disabled/>여</label>
			  	</div>
			  </div>
	          <div class="form-group">
				  <label for="petcolor" class="col">사이즈</label>
				  <span class="noneBorderText" style="font-weight: bold;" id="pet_size"></span>&nbsp;
				  /<span class="noneBorderText" style="font-weight: bold;" id="pet_weight"></span>kg
			  </div>
			  <div class="form-group">
	          	<label class="col">진료타입</label>
	          	<select class="form-control" id="rvType">
	          		<option value="">선택하세요</option>
	          		<option value="1">외래진료</option>
	          		<option value="2">예방접종</option>
	          		<option value="3">수술</option>
	          		<option value="4">호텔링상담</option>
	          	</select>
	          </div>
	          <div class="text-center" id="notice_reservation"></div>
	        </div>
	        <div class="panel-footer">
	        </div>
	      </div>      
	    </div>     
	    <div class="col-sm-8 col-xs-12">
	      <div class="panel panel-default text-center">
	        <div class="panel-heading">
	          <h3>Choose a Day</h3>
	        </div>
	        <div class="panel-body">
	         <div id="calendar"></div>
	        </div>
	        <div class="panel-footer">
	        </div>
	      </div>      
	    </div>        
	  </div>
	  
	  <div class="row">
	  	 <div class="col-sm-8 col-xs-8 col-sm-offset-2">
	      <div class="panel panel-info text-center">
	        <div class="panel-heading">
	          <h5>Choose Result</h5>
	        </div>
	        <div class="panel-body text-left">
	        <div class="row">
	        
	        <div class="col-md-8 col-sm-8 col-xs-12">
	        <form name="reservationFrm">
	          <p>
	          	<label class="label label-info"> 병원명 </label>
	          	<span class="noneBorderText">${bizmvo.name}</span>
	          	<input type="hidden"  name="fk_idx_biz" value="${bizmvo.idx_biz}"/>
	          	<input type="hidden"  name="fk_idx" value="${sessionScope.loginuser.idx}"/>
	          </p>
	          <p>
	          	<label class="label label-info"> 연락처 </label>
	          	<span class="noneBorderText">${bizmvo.phone}</span>
	          	<input type="hidden"  value=""/>
	          </p>
	          <p>
	          	<label class="label label-info"> 진료과 </label>
	          	<span class="noneBorderText" id="mypetopt"></span>
	          	<input type="hidden" id="fk_pet_UID" name="fk_pet_UID" value=""/>
	          	<input type="hidden" id="reservation_type" name="reservation_type"/>
	          </p>
	          <p>
	          	<label class="label label-info"> 진료일 </label>
	          	<span class="noneBorderText" id="schedule_date"></span>
	          	<input type="hidden" name="reservation_DATE" id="reservation_DATE"/>
	          	<input type="hidden" name="fk_schedule_UID" id="fk_schedule_UID" />
	          </p>
	         </form>
	         </div>
	        
	         <div class="col-md-4 col-sm-4 col-xs-12 text-right" style="position:absolute; right:5%; bottom:20%;">
	         	<button type="button" class="btn btn-info" onClick="goReservation();">예약하기</button>
	         	<button type="button" class="btn btn-default" onClick="goReset();">초기화</button>
	         </div>
	        </div>
	       </div>
	      </div>      
	    </div>  
	  </div>
	  
	</div>
</div>