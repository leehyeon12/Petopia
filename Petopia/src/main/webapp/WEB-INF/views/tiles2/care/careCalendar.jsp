<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<% String ctxPath = request.getContextPath(); %>
<style>

	div #title {
		text-align: center; 
		margin-top: 5%;
	}
		
	.pointer {
		cursor: pointer;
	}
	
	.pet-box {
		display: inline-block;
	}
	 
	.petname {
		display: inline-block;
		margin-left:auto;
		margin-right:auto;
	}
	
	.img {
		display: block; 
		margin: 0px 6px;
		text-align: left;
	}
	
	.img img {
		height: 120px; 
		width: 120px;
		margin-left: auto;
		margin-right: auto;
		border-radius: 100%;
	}
	
  	#wrap {
    	width: 1100px;
	    margin: 0px auto;
	    margin-bottom: 10%;
	    padding-top: 10%;
	}
	
	li {
		list-style-type: none;
	}
	
	ul {
		display: inline-block;
		padding: 0px;
	}
	
	.info {
		margin: 0px auto;
	}

	#external-events {
		float: center;
		 margin: 0px auto;
		/* width: 250px; */
		/* margin-left: 20px; */
		/* border: 1px solid #ccc; */
		/* background: #eee; */
		text-align: center;
	}

	#external-events h4 {
		font-size: 16px;
		margin-top: 0;
		padding-top: 1em;
	}

	#external-events .fc-event {
		display: inline-block;
		margin: 0px auto;
		padding: 10px;
		width: 60px;
		border: 1px solid black;
		background-color: transparent;
		color: black;
		cursor: pointer;
	}

	#external-events p {
		margin: 1.5em 0;
		font-size: 11px;
		color: #666;
	}

	#external-events p input {
		margin: 0;
		vertical-align: middle;
	}

	#calendar {
		float: left;
		width: 70%;
	}
	
	fieldset {
		display: block;
		margin-inline-start: 2px;
		margin-inline-end: 2px;
		padding-block-start: 0.35em;
		padding-inline-start: 0.75em;
		padding-inline-end: 0.75em;
		padding-block-end: 0.625em;
		min-inline-size: min-content;
		border-width: 2px;
		border-style: groove;
		border-color: threedface;
		border-image: initial;
	} 
	
	#table {
		border-collapse: collapse;
		width: 100%;
	}
	
	#table th, td {
		text-align: center;
		padding: 8px;
	}
	
	#table tr:nth-child(even) {
		background-color: #f2f2f2
	}
	
	#table th {
		background-color: #4CAF50;
		color: white;
	}
 
</style>


<script type="text/javascript">

	$(document).ready(function() {
		
		getPet();
		getPetcare(); 
		
		$("#changepet").click(function() {
			
			getPet();
			getPetcare(); 
			
		});
		
	});// end of $(document).ready()----------------------------------------
		
	function getPet() { 
	      
	      var form_data = {fk_idx : "${fk_idx}"}; 

	      $.ajax({
	         url : "getPet.pet",   
	         type :"GET",                              
	         data : form_data,                          
	         dataType : "JSON",                        
	         success : function(json) {                
	                 $("#displayPetList").empty();
	                                 
	                 var html = "";
	                  
	                  $.each(json, function(entryIndex, entry) { 
	                      
	                     html += "<div align='center' class='pet-box'>"
	                     	   + "	<span class='pointer changepet petname' onclick='javascript:location.href=\"careCalendar.pet?pet_UID="+ entry.PET_UID +"\"'>" + entry.PET_NAME + "</span>"
	                     	   + "	<div class='img' style='display: block; text-align: left;'><span class='pointer changepet petname' onclick='javascript:location.href=\"careCalendar.pet?pet_UID="+ entry.PET_UID +"\"'><img src='resources/img/care/" + entry.PET_PROFILEIMG + "' /></span></div>"
	                     	   + "</div>";
	                  	                  
	                  });
	                     
	                  	html += "<div align='center' class='pet-box'>"
	                     	  + "	<span class='pointer petname' onclick='javascript:location.href=\"petRegister.pet\"'>반려동물 추가하기</span>"
			                  + "	<div class='img' style='display: block; text-align: left;'><a href='petRegister.pet'><img src='resources/img/care/petAdd.png' width='40px;' height='40px;' style='border-radius: 0%'></a></div>"
	                  		  + "</div>";
	                  	
	                  $("#displayPetList").append(html);
	          },
	          error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	          }         
	      });
	      
	} // end of function getPet()-------------------------------------------
	   
	function getPetcare() { 
	      
	      var form_data = {pet_UID : "${pet_UID}"}; 

	      var str = "";
	      
	      $.ajax({
	         url : "getPetcare.pet",   
	         type :"GET",                              
	         data : form_data,                          
	         dataType : "JSON",                        
	         success : function(json) {     
	        	 	 $("#displayPetcare").empty();
	                 $("#calendar").empty();
	                 
	         		// [19-02-08. 수정 시작_hyunjae]
	         		var resultArr = []; 
						
						for(var i=0; i<json.length; i++) {
							var obj = {
										title: json[i].CARETYPE_NAME
				    	              ,	start: json[i].CARE_START
				    	              , end : json[i].CARE_END
				    	              };
							resultArr.push(obj); // 배열속에 값을 넣기
					} // end of for

					////////////////////////////// FullCalendar 시작 //////////////////////////////
	         		$('#external-events .fc-event').each(function() {
	         	
	         			// store data so the calendar knows to render an event upon drop
	         			$(this).data('event', {
	         				title: $.trim($(this).text()), // use the element's text as the event title
	         				stick: true // maintain when user navigates (see docs on the renderEvent method)
	         			});
	         	
	         			// make the event draggable using jQuery UI
	         			$(this).draggable({
	         				zIndex: 999,
	         				revert: true,      // will cause the event to go back to its
	         				revertDuration: 0  //  original position after the drag
	         			});
	         	
	         		});
	         	
	         		/* initialize the calendar
	         		-----------------------------------------------------------------*/
	         		$('#calendar').fullCalendar({
	         			header: {
	         				left: 'prev,next',
	         				center: 'title',
	         				right: 'today'
	         			},
	         			editable: true,
	         			droppable: true, // this allows things to be dropped onto the calendar
	         			drop: function() {
	         				// is the "remove after drop" checkbox checked?
	         				if ($('#drop-remove').is(':checked')) {
	         					// if so, remove the element from the "Draggable Events" list
	         					$(this).remove();
	         				}
	         				
	         			},
	         			// [19-02-11. 수정 시작_hyunjae]
	         			events: resultArr, 
	         			
	         			eventRender: function(event, element) { 
	         			      eventsdate = moment(event.start).format('hh:mm a'); 
	         			      eventedate = moment(event.end).format('hh:mm a'); 

	         			      element.find('.fc-time').html(eventsdate + " - " + eventedate + "<br>"); 
	         			}
	         			// [19-02-11. 수정 끝_hyunjae]	 

	         		});
					//////////////////////////////FullCalendar 끝 //////////////////////////////
	         		// [19-02-08. 수정 끝_hyunjae]	                 
	                  
	                 var html = "<table id='table' class='table table-sm'>"
             	   			  + "	<thead>"
             	   			  + "		<tr>"
             	   			  + "			<th colspan='3'>${date}</th>"
             	   			  + "		</tr>"
             	   			  + "	</thead>"
                 	   		  + "	<tbody>";
		                  
	                  $.each(json, function(entryIndex, entry){ 
	                      
	                     html += "		<tr>"
	                    	   + "			<td>" + entry.CARETYPE_NAME + "</td>"
	                     	   + "			<td>" + entry.CARE_CONTENTS + "</td>"
	                     	   + "			<td>" + entry.CARE_END + "</td>"
	                     	   + "		<tr>";
	                          
	                  });
	                     
	                  	html += "	</tbody>"
	                  		  + "</table>";
	                  	
	                  $("#displayPetcare").append(html);
	          },
	          error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	          }         
	      });
	      
	} // end of function getPetcareWithCalendar()-------------------------------------------
	
//	#엑셀로 업로드하기
	function goExcelUpload(idx){
		var url = "<%=ctxPath%>/excelUploadCare.pet?idx="+idx;
		window.open(url, "엑셀파일 업로드", "left=350px, top=100px, width=350px, height=200px");
	}  
</script>


<!-- container 시작 -->
<div class="container">
	<div id="title"><h2>케어관리</h2></div>
	
	<!-- profile 시작 -->
	<div class="row profilebody">
		<div class="col-sm-12">
			<div id="displayPetList" class="fl"> 

			</div>
		</div>	
	</div>
	<!-- profile 끝 -->
	
	<!-- 메인 content 시작 -->
	<div class="row">
		<div id='wrap'>
		   
			<!-- calendar 시작 -->	
		    <div id='calendar' class="col-sm-9">
		    
		    </div>
		    <!-- calendar 끝-->
		   
			<!-- info 사이드 시작 -->
			<div class="col-sm-3" >			 
				<div align='center'>
				<!--  
					<span class="petname">케어명</span>
					<div><img src="resources/img/care/feeding-a-dog.png" style="height: 100px; width: 100px;" /></div>
					<div class="petname info" align='center'>케어경고알림</div>
		  		</div>
		  		-->	
				<div id='external-events' align="center">
					<li>
				      	<div>
				      		<ul><a href="careRegister.pet?fk_pet_UID=${pet_UID}&fk_caretype_UID=1" class="fc-event btn btn-lg btn-default"><span class="glyphicon glyphicon-cutlery"></span>&nbsp;식사</a></ul>
				      		<ul><a href="careRegister.pet?fk_pet_UID=${pet_UID}&fk_caretype_UID=2" class="fc-event btn btn-lg btn-default"><span class="glyphicon glyphicon-trash"></span>&nbsp;용변</a></ul> 
				      	</div>
				      	<div>
				      		<ul><a href="careRegister.pet?fk_pet_UID=${pet_UID}&fk_caretype_UID=3" class="fc-event btn btn-lg btn-default"><span class="glyphicon glyphicon-glass"></span>&nbsp;양치</a></ul>
				      		<ul><a href="careRegister.pet?fk_pet_UID=${pet_UID}&fk_caretype_UID=4" class="fc-event btn btn-lg btn-default"><span class="glyphicon glyphicon-tint"></span>&nbsp;목욕</a></ul>
				      	</div>
				      	<div>
				      		<ul><a href="careRegister.pet?fk_pet_UID=${pet_UID}&fk_caretype_UID=5" class="fc-event btn btn-lg btn-default"><span class="glyphicon glyphicon-calendar"></span>&nbsp;달력</a></ul> 
				      		<ul><a href="careRegister.pet?fk_pet_UID=${pet_UID}&fk_caretype_UID=6" class="fc-event btn btn-lg btn-default"><span class="glyphicon glyphicon-pencil"></span>&nbsp;메모</a></ul>
						</div>
					</li>
		 
					<p>
						<input type='checkbox' id='drop-remove' />
						<label for='drop-remove'>remove after drop</label>
					</p>
					<%-- #펫케어 excel로 입력하기 --%> 
					<div class="col-md-8 col-md-offset-2">
						<div class="excel" style="font-weight: bold;">엑셀 입력하기</div>
						<p>xls파일로 케어를 직접 입력하여 업로드할 수 있습니다.<br/>
						아래 양식을 다운로드하여 작성바랍니다.</p>
						<p>
						<a class="btn btn-rounder" href="<%= request.getContextPath() %>/downCareFile.pet">양식다운로드</a><br/><br/>
					    <button type="button" class="btn btn-rounder" onClick="goExcelUpload(${sessionScope.loginuser.idx});">엑셀 업로드</button>
					    </p>
					</div>
			    </div>
	    	</div> 
		 
		    <div style='clear:both'></div>
		  
		</div>
	</div>

	<!-- File Button -->
	<!--  
	<fieldset>
		<div class="row">
			<div id="displayPetcare" class="col-sm-12">
			
			</div>
		</div>
	</fieldset>
	-->
 
</div>
<!-- container 끝 -->	 








