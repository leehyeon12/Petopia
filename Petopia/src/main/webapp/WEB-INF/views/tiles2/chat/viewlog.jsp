<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
	.chatbody {font-family: NanumGothic, 나눔 고딕, 맑은 고딕, dotum;}
	.modal-header {background-color: rgb(252, 118, 106);}
	.modal-body {background-color: rgb(252, 118, 106);}
	.modal-footer {background-color: rgb(252, 118, 106);}
	.modal-title {
    color: white;
    font-family: 'Roboto', 'Open Sans', 'Lucida Grande', sans-serif;}
    .btn2 {
		  background:#ff9577;
		  color:white;
		  border:1px solid white;
		  cursor:pointer;
		  transition:800ms ease all;
		  outline:none;
		  cursor: pointer; 
		  margin-top:60%; 
		  float:right;
    }
    .btn2:hover{
		  background:white;
		  color:#ff9577;
	}
	.event-list {
		list-style: none;
		font-family: 'Lato', sans-serif;
		margin: 0px;
		padding: 0px;
	}
	.event-list > li {
		background-color: rgb(255, 255, 255);
		box-shadow: 0px 0px 5px rgb(51, 51, 51);
		box-shadow: 0px 0px 5px rgba(51, 51, 51, 0.7);
		padding: 0px;
		margin: 0px 0px 20px;
	}
	.event-list > li > time {
		display: inline-block;
		width: 40%;
		color: rgb(255, 255, 255);
		background-color: rgb(247, 158, 150);
		padding: 5px;
		text-align: center;
		text-transform: uppercase;
	}
	.event-list > li:nth-child(even) > time {
		background-color: rgb(252, 111, 98);
	}
	.event-list > li > time > span {
		display: none;
	}
	.event-list > li > time > .day {
		display: block;
		font-size: 15pt;
		font-weight: 100;
		line-height: 1;
	}
	.event-list > li time > .month {
		display: block;
		font-size: 24pt;
		font-weight: 900;
		line-height: 1;
	}
	.event-list > li > .info {
		padding: 3% 3% 0% 3%;
	}
	
	.event-list > li > .info > .title {
		font-size: 17pt;
		font-weight: 700;
		margin: 0px;
	}
	.event-list > li > .info > .desc {
		font-size: 13pt;
		font-weight: 300;
		margin: 0px;
	}
	.event-list > li > .info > ul,
	.event-list > li > ul {
		display: table;
		list-style: none;
		margin: 10px 0px 0px;
		padding: 0px;
		width: 100%;
		text-align: center;
	}
	.event-list > li > ul {
		margin: 0px;
	}
	.event-list > li > .info > ul > li,
	.event-list > li > ul > li {
		display: table-cell;
		cursor: pointer;
		color: rgb(30, 30, 30);
		font-size: 11pt;
		font-weight: 300;
        padding: 3px 0px;
	}
    .event-list > li > .info > ul > li > a {
		display: block;
		width: 100%;
		color: rgb(30, 30, 30);
		text-decoration: none;
	} 
    .event-list > li > ul > li {    
        padding: 0px;
    }
    .event-list > li > ul > li > a {
        padding: 3px 0px;
	} 
	.event-list > li > .info > ul > li:hover,
	.event-list > li > ul > li:hover {
		color: rgb(30, 30, 30);
		background-color: rgb(200, 200, 200);
	}
	.fa{
		font-size: 15pt;
	}
	.colums{
		font-weight: bold;
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		
		viewlog();	
		
	}); // end of document.ready
	
	function viewlog() {
			
			var form_data = {"idx":"${loginuser.idx}"};
			
			$.ajax({
				url:"log.pet",
				type:"GET",
				data:form_data,
				dataType:"JSON",
				success:function(json) {
					$.each(json, function(entryIndex, entry){
						var html = "<li>";
							html += "<time datetime=''>";
							html += "<span class='day'>" +entry.time+"</span>";
							html += "</time>";
							html += "<div class='info'>";
							html += "<p class='desc'><span class='colums' style='padding-right: 2%;'>상담회원아이디</span>"+entry.fk_userid+"</p>";
							html += "<p class='desc'><span class='colums' style='padding-right: 10%;'>상담코드</span>"+entry.chatcode+"</p>";
							html += "<p class='desc'><span class='colums' style='padding-right: 10%;'>담당병원</span>"+entry.fk_name_biz+"</p></br>";
							html += "<p class='desc'><span class='colums' style='padding-right: 7.2%;'>담당수의사</span>"+entry.fk_docname+"</p>";
							html += "<ul style='margin-top: 5%;'>";
							html += "<li style='width:50%; padding: 2% 0% 2% 0%;'><a href='#website'><span class='fa fa-globe'></span>빈도수 보기</a></li>";
							html += "<li style='width:50%; padding: 2% 0% 2% 0%;'><span class='fa fa-money'></span>예치금 내역 보기</li>";
							html += "</ul>";
							html += "</div>";
							html += "</li>";
						$(".event-list").append(html);
					});
				},
				error:function() {
					alert("정보를 불러오는데 실패했습니다.");
				}
			});
		}
	
</script>

<form name="chatFrm" action="<%=ctxPath%>/log.pet">
  <div class="container" style="margin-left: 20%; margin-top: 10%;">
	<div class="row">
	  <div class="chat" style="margin-bottom: 5%;">
	    	<h2>화상 진료 내역</h2>
	  </div>
	</div>
	  <div class="chatbody" style="weight: 100%; height: 100%; padding:40px; border-top: 1px solid #dfdfdf; border-bottom: 1px solid #dfdfdf; background-color: #fbfbfb;">
	  	<div class="col-md-offset-2 col-md-8" style="font-weight: bold; font-size: 18px; margin-bottom: 3%;">
	  		온라인 채팅ㆍ화상 상담 내역
	  	</div>
	  	<div class="col-md-offset-2 col-md-8 col-lg-8 col-sm-12">
		   <ul class="event-list">
		   </ul>
	   </div>
	  </div>
  </div>
	
</form>