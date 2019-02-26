<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<style>
.notList	{
			border-bottom: 1px solid #fc766b;
			background-color: ivory;
			padding: 1%;
					
			}
	
.notList.read	{
				background-color: #eee;
				}
					
.message, img	{
				cursor: pointer;
				}
				
.message:hover	{
				font-weight: bold;
				}


</style>


<script type="text/javascript">

	$(document).ready(function(){

		$("#refresh").click(function(){
			showNotificationList("1")
		});

		$("#totalListCount").hide();
		$("#listCount").hide();
		
		showNotificationList("1");
		
		$("#btnMoreList").click(function(){
			
			if($(this).text() == "TOP▲") {
				$("#notificationList").empty();
				showNotificationList("1");
				$(this).text("더보기▼");
			}
			else {
				showNotificationList($(this).val());
			}
		});
		
	}); // end of $(document).ready()----------------------
	
	var listLength = 10;
	
	function showNotificationList(start){
		
		var form_data = { "start" : start,
						  "length" : listLength};
		
		$.ajax({
			url:"<%=ctxPath%>/notificationListAJAX.pet", 
			type:"GET",
			data:form_data,
			dataType:"JSON",
			success:function(json){ 
				
				var html = "";
				
				if(json.length > 0){
					$.each(json, function(entryIndex, entry){

						if(entry.NOT_READCHECK == 1) {
							html += "<div class='row notList read'>"
								  + "<div class='col-xs-1 col-md-1 notContent'>["+entry.NOT_UID+"]</div>"
								  + "<div class='col-xs-1 col-md-1 notContent'>["+entry.NOT_TYPE+"]</div>"
								  + "<div class='col-xs-8 col-md-8 notContent message' onClick='location.href=\""+entry.NOT_URL+"\"'>"+entry.NOT_MESSAGE+"</div>"
								  + '<div class="col-xs-1 col-md-1 notContent" onClick="goRemindNot(\''+entry.NOT_UID+'\');"><img src=\"<%=request.getContextPath() %>/resources/img/notification/clock.png\" style=\"width:40%;\"/></div>'
								  + '<div class="col-xs-1 col-md-1 notContent" onClick="goDelete(\''+entry.NOT_UID+'\');"><img src=\"<%=request.getContextPath() %>/resources/img/notification/delete.png\" style=\"width:40%;\"/></div>'
								  + "</div>";
						}
						else {
							html += "<div class='row notList unread'>"
								  + "<div class='col-xs-1 col-md-1 notContent'>["+entry.NOT_UID+"]</div>"
							  	  + "<div class='col-xs-1 col-md-1 notContent' style=''>["+entry.NOT_TYPE+"]</div>"
							  	  + '<div class="col-xs-8 col-md-8 notContent message" onClick="goUpdateNMove(\''+entry.NOT_UID+'\',\''+entry.NOT_URL+'\');">'+entry.NOT_MESSAGE+'</div>'
							   	  + '<div class="col-xs-1 col-md-1 notContent" onClick="goRemindNot(\''+entry.NOT_UID+'\');"><img src=\"<%=request.getContextPath() %>/resources/img/notification/clock.png\" style=\"width:40%;\"/></div>'
							   	  + '<div class="col-xs-1 col-md-1 notContent" onClick="goDelete(\''+entry.NOT_UID+'\');"><img src=\"<%=request.getContextPath() %>/resources/img/notification/delete.png\" style=\"width:40%;\"/></div>'
							  	  + "</div>";
						}
					});
					
					$("#notificationList").html(html);
					$("#btnMoreList").val(parseInt(start) + listLength);
				}
				else{
					$("#notificationList").empty().html("<div>알림이 없습니다.</div>");
				}
				
				$("#listCount").text(parseInt($("#listCount").text()) + json.length);
				
				if($("#listCount").text() == $("#totalListCount").text()) {
					$("#btnMoreList").text("TOP▲");
					$("#listCount").text("0");
				}
			},
			error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		
		}); // $.ajax({
	
	} // function showNotificationList(){
	
	function goUpdateNMove(uid, url){
		
		var frm = document.notificationFrm;
		
		frm.not_uid.value=uid;
		frm.not_URL.value=url;
		frm.action = "updateReadcheck.pet";
		frm.method = "POST";
		frm.submit();
		
	} // function goUpdateNMove(uid, url){
		
	function goRemindNot(uid){
		
		var frm = document.notificationFrm;
		
		frm.not_uid.value=uid;
		frm.action = "insertRemindNot.pet";
		frm.method = "POST";
		frm.submit();
	
	} // function goRemindNot(){
		
	function goDelete(uid){
		
		var frm = document.notificationFrm;
		
		frm.not_uid.value=uid;
		frm.action = "deleteNot.pet";
		frm.method = "POST";
		frm.submit();
	
	} // function goDelete(){
		

</script>

<div class="container" style="padding-top:8%; margin-bottom: 0.2%;">
	<h3 style="border:0.5px solid #fc766b; border-radius:3px; padding:1%;">NOTIFICATION LIST
	<img src="<%=request.getContextPath() %>/resources/img/notification/refresh.png" id="refresh" style="width: 2%; margin-left: 1%; margin-bottom: 0.5%;"/></h3>
	<div align="center">
		
		<div id="notificationList" style="width:90%; margin-top:5%; margin-bottom:5%; "></div>
		<button type="button" id="btnMoreList" value="">더보기 ▼</button>
		<span id="totalListCount">${totalNotCount}</span>
		<span id="listCount">0</span>
		
	</div>
</div>

<form name="notificationFrm">
	<input type="hidden" id="not_uid" name="not_uid" value=""/>
	<input type="hidden" id="not_URL" name="not_URL" value=""/>
</form>
