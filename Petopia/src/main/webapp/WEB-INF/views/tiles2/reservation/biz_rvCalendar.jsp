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
.modal {
        text-align: center;
}
@media screen and (min-width: 768px) { 
        .modal:before {
                display: inline-block;
                vertical-align: middle;
                content: " ";
                height: 100%;
        }
}
 
.modal-dialog {
        display: inline-block;
        text-align: left;
        vertical-align: middle;
}
</style>

<script type="text/javascript">
 $(document).ready(function(){
	$("#makeSchedule").hide();
	if(${scheduleCount > 0 && scheduleCount !=null} ){
	} 
	else {
		$("#makeSchedule").show();
	}
	
	$('#calendar').fullCalendar({
      selectable: true,
      customButtons: { 
          myCustomButton: { 
              text: '일정입력', 
              click: function(event) { 
                onSelectEvent(event); 
              } 
          } 
	  },
	  editable: true, 
	  disableDragging: false, 
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaSevenDay,agendaDay, myCustomButton' 
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
    	  var form_data = {"idx_biz": ${sessionScope.loginuser.idx}};
        	
        	$.ajax({
        		url: "selectScheduleList.pet",
        		type: "GET",
        		data: form_data,
        		dataType: "JSON",
        		success: function(json){
        			var events = [];
        			$.each(json, function(entryIndex, entry){
        				var schstatus = entry.schedule_status;
        				if(schstatus=="0"){
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
      },
      select: function(start, end) {
  	    
  	  }, 
  	  eventLimit: true,
  	  eventClick: function(eventObj) {
  		  var schedule_UID = eventObj.id;
  		  var status = eventObj.title;
  		  
  		  if(status=="예약가능"){
  			  return false;
  		  }
  		  else if(status=="예약불가"){
  			 getScheduleBySUID(schedule_UID);
  			$("#fullCalModal").modal("show");
  		  }
      }
    }); // end of fullcalendar jqurey
	
	$("#btnMakeSchedule").click(function(){
		location.href="<%= ctxPath %>/insertScheduleFirst.pet?idx_biz=${idx_biz}";
	});

	
 });
 
 
 function getScheduleBySUID(schedule_UID){
	 var form_data = {"schedule_UID":schedule_UID};
			
	$.ajax({
		url: "selectScheduleOneByScheduleUID.pet",
		type: "GET",
		data: form_data,
		dataType: "JSON",
		success: function(json){
			$("#edit_rvUID").val(json.reservation_UID);
			$("#edit_rvDATE_YMD").val(json.reservation_DATE_YMD);
			// [190129] 예약정보 추가
			$(".timeopt").each(function(){
			    if($(this).val()==json.reservation_DATE_HM){
			      $(this).attr("selected","selected"); // attr적용안될경우 prop으로 
			    }
			});
			var rvTypeText = "";
			if(json.reservation_type=="1"){
				rvTypeText = "외래진료";
			}
			else if(json.reservation_type=="2"){
				rvTypeText = "예방접종";
			}
			else if(json.reservation_type=="3"){
				rvTypeText = "수술상담";
			}
			else if(json.reservation_type=="4"){
				rvTypeText = "호텔링상담";
			}
			$("#rvTypeText").val(rvTypeText);
			
			if(json.reservation_type=="3" && json.reservation_status=="1"){
				$("#rvStatus").val("미결제");
			}
			else{
				$("#rvStatus").val("예약완료");
			}
			// 190129 끝 ---------------
			$("#edit_reservation_status").val(json.reservation_status);
			$("#edit_scUID").val(json.schedule_UID);
			$("#edit_memberName").val(json.name);
			$("#edit_pet_name").val(json.pet_name);
			$("#edit_pet_type").val(json.pet_type);
			$("#edit_fk_idx_biz").val(json.fk_idx_biz);
			$("#edit_reservation_type").val(json.reservation_type);
			$("#edit_schedule_status").val(json.schedule_status);
			$("#edit_fk_pet_UID").val(json.fk_pet_UID);
			$("#edit_fk_idx").val(json.fk_idx);
		},// end of success
		error: function(request, status, error){
			if(request.readyState == 0 || request.status == 0) return;
			else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	});// end of $.ajax
 }
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
		
		return result;
	}
	
	function goEditSchedule(){
		var frm = document.scheduleEditFrm;
		frm.method="POST";
		frm.action="<%= ctxPath %>/rvScheduleEdit.pet";
		frm.submit();
	}
//	[190129] 예약 취소	
	function goCancle(){
		var frm = document.scheduleEditFrm;
		frm.method="POST";
		frm.action="<%= ctxPath %>/rvScheduleCancle.pet";
		frm.submit();
	}

</script>
<div class="container">
	<!-- Container (Pricing Section) -->
	<div id="pricing" class="container-fluid">
	  <div class="text-center">
	    <h2>Reservation Calendar</h2>
	    <h4>우리 병원의 스케줄을 확인할 수 있습니다.</h4>
	  </div>
	  <div class="row slideanim">
	    <div class="col-sm-4 col-xs-12 col-md-offset-4" id="makeSchedule">
	      <div class="panel panel-default text-center">
	        <div class="panel-heading">
	          <h3>Create Schedule</h3> 
	        </div>
	        <%-- [190128] 스케줄 버튼 및 정렬 수정 --%>
	        <div class="panel-body text-center">
				<p>최근 2주 내 스케줄이 없습니다.</p>
				<p><button type="button" id="btnMakeSchedule" class="btn btn-default">스케줄 생성하기</button></p>
				<ul class="text-left">
					<li>스케줄 생성하기 버튼을 클릭하시면 금일로부터 2주 분량의 스케줄이 자동 생성됩니다.</li>
					<li>스케줄을 한번 생성하신 이후부터는 매일 자동으로 스케줄이 갱신/생성됩니다.</li>
				</ul>
	        </div>
	        <div class="panel-footer">
	        </div>
	      </div>      
	    </div>
	         
	    <div class="col-sm-8 col-md-8 col-md-offset-2 col-xs-12">
	      <div class="panel panel-default text-center" id="mySchedule">
	        <div class="panel-heading">
	          <h3>My Schedule</h3>
	        </div>
	        <div class="panel-body">
	         <div id="calendar"></div>
	        </div>
	        <div class="panel-footer">
	        </div>
	      </div>      
	    </div>        
	  </div>
	</div>
	<div id="fullCalModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span> <span class="sr-only">close</span></button>
					<h4 id="modalTitle" class="modal-title">일정 수정하기</h4>
				</div>
				<div id="modalBody" class="modal-body">
					<div style="width:90%; text-align:left; padding-left:30px;">
						<ul style="list-style-type: none;">
							<li>
								변경할 시간을 선택해주세요.
								<form name="scheduleEditFrm">
									<input type="date" class="form-control" id="edit_rvDATE_YMD" name="edit_rvDATE_YMD" placeholder="2019-01-28" style="width: 40%; display: inline-block;"/>
									<%-- [190129] 시간 선택 셀렉트박스 추가 --%>
									<select id="edit_rvDATE_HM" name="edit_rvDATE_HM" class="form-control" style="width: 30%; display: inline-block;">
									<option value="">선택하세요.</option>
										<c:forEach items="${timeList}" var="time">
											<option class="timeopt" value="${time.time1}">${time.time1}</option>
											<option class="timeopt" value="${time.time2}">${time.time2}</option>
										</c:forEach>
									</select>
									<input type="hidden" id="edit_rvUID" name="edit_rvUID" />
									<input type="hidden" id="edit_scUID" name="edit_scUID" />
									<input type="hidden" id="edit_fk_idx_biz" name="edit_fk_idx_biz"/>
									<input type="hidden" id="edit_reservation_type" name="edit_reservation_type"/>
									<input type="hidden" id="edit_reservation_status" name="edit_reservation_status" />
									<input type="hidden" id="edit_schedule_status" name="edit_schedule_status"/> 
									<input type="hidden" id="edit_fk_idx" name="edit_fk_idx"/> 
									<input type="hidden" id="edit_fk_pet_UID" name="edit_fk_pet_UID"/>
									
								</form>
							</li>
							<li style="margin-bottom: 3%;">
								예약자 이름
								<input type="text" class="form-control" id="edit_memberName" name="edit_memberName" style="width: 40%;" readonly/>
							</li>
							<li>
								반려동물 정보
								<input type="text" class="form-control" id="edit_pet_name" style="width: 40%;" readonly />
								<input type="text" class="form-control" id="edit_pet_type" style="width: 40%;" readonly /><br/>
							</li>
							<%-- [190129] 예약정보 추가 --%>
							<li>
								예약타입/상태
								<input type="text" class="form-control" id="rvTypeText" style="width: 40%;" readonly/>
								<input type="text" class="form-control" id="rvStatus" style="width: 40%;" readonly/>
							</li>
							
						</ul>
						
					</div>			
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-warning" onClick="goCancle();">일정취소</button>
					<button class="btn btn-primary" onClick="goEditSchedule();">수정</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

</div>