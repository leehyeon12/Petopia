<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<script type="text/javascript">
    
	$(document).ready(function(){
		
		
/* 달력 시작  */
		  <%-- $('#calendar').fullCalendar({
			  
			 
		      header: {
		        left: 'prev,next today',
		        center: 'title',
		        right: 'month,agendaWeek,agendaDay,listWeek'
		      },
		      defaultDate: '2019-01-12',
		      navLinks: true, 
		      editable: true,
		      eventLimit: true, 
		      events:function(start,end,title) {//json 타입의 배열을 ajax로 가져오기 
		    	  
		    	  var data ={ "bidx":"2"}; //기업회원 채번해오기!!
					$.ajax({
			            url : "<%=ctxPath%>/selectReserveinfo.pet" ,
			            type:"GET",
			            data: data,
			            dataType :"json", 
			            success : function(json) {
			            	var events=[];
			            	$.each(json,function(entryIndex,entry){
			            		event.push({
			            			title:entry.title,
			            			start:entry.start,
			            		    end:entry.end
			            		  });	
			            	}); //end of each
			            }, //end of success
			            error : function(request,status,error) {
			                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: " +error);
			            }
			        }); //end f ajax
		      }
		    }); // end of  $('#calendar').fullCalendar --%>

	/* 달력  끝  */
	
	});// end of $(document).ready()----------------------
</script>
<style>
.btn1{
	background-color:rgb(252, 118, 106); 
	color:white; 
	width:15%;
	height:8%;
	border-radius: 10px;
	margin-top:37%;
    padding-top:0;
 }
 .btn2{
	background-color:rgb(252, 118, 106); 
	color:white; 
	width:5%;
	height:8%;
	border-radius: 10px;
 }
 
 .div1{
    width:70%;
    heigth:40%;
    float:left;
 }
 

 .div2{
   width:25%;
   height:8%;
   overflow:hidden;
   margin-top: 5%;
   margin-right:20%; 
   
    body {
    margin: 0;
    padding: 0;
    font-size: 14px;
  }

  #top,
  #calendar.fc-unthemed {
    font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
  }

  #top {
    background: #eee;
    border-bottom: 1px solid #ddd;
    padding: 0 10px;
    line-height: 40px;
    font-size: 12px;
    color: #000;
  }

  #top .selector {
    display: inline-block;
    margin-right: 10px;
  }

  #top select {
    font: inherit; 
  }

  .left { float: left }
  .right { float: right }
  .clear { clear: both }

  #calendar {
    max-width: 80%;
    max-width: 900px;
    margin: 40px auto;
    padding: 0 10px;
  }
  
 }
</style>
<div class="container" style="margin-top: 3%; ">
   
   <h3 style="color:rgb(252, 118, 106);margin-left: 3%;" >진료 & 예약 관리</h3>
  
  <div class="div1">
	<div id="calendar"  class="calendar"
	 style ="border: 1px solid gray;
	   height:80%;width:80%;border-radius:10px; padding:3% 3% 3% 3%;margin-bottom: 3%; ">
	</div>
 </div>
	<div class="div2">  
	  <input type="text" class="input1"  placeholder="회원 이름으로 검색하기"/>
	  <button type="button" class="btn2" style="width:30%; height:50%">검색</button>
     </div> 
      <button  type="button" class="btn1">오늘 진료관리</button>
  </div>
   

</div>