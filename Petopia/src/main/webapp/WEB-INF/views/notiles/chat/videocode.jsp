<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<%
	String ctxPath = request.getContextPath();

	InetAddress inet = InetAddress.getLocalHost();
	String serverIP = inet.getHostAddress();
	int portnumber = request.getServerPort();
	
	String serverName = "http://"+serverIP+":"+portnumber;
%>    

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="mobile-web-app-capable" content="yes">
<meta id="theme-color" name="theme-color" content="#1e1e1e">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("#code").keydown(function(event){
			
			if(event.keyCode == 13) {
				selectcode();
			}
		}); 
		
		$("#join-button").click(function(){
			selectcode();
		});
		
	}); // end of document.ready
		
	
	
     
     /* 수정해야할부분 */
	function selectcode() {
		
		var chatcode = $("#code").val();
		
		var form_data = {"code" : chatcode};
		
		$.ajax({
			url : "<%= request.getContextPath() %>/viewvideocode.pet",
			type : "GET",
			data : form_data,
			dataType : "JSON",
			success : function(json) {
					var frm = document.videochatFrm;
					parent.location.href="<%= serverName %><%= ctxPath %>/selectchat.pet?"+chatcode;
			},
			
			error : function() {
				alert("올바르지 않은 번호입니다 확인해주세요");
			}
		})

	}

</script>

<body style="background-color: rgb(252, 118, 106);">
<form name="videochatFrm" style="background-color: rgb(252, 118, 106);">
	<div id="div_code" align="center">
		<span style="color: white; font-size: 12pt;">상담을 위한 코드를 생성해주세요</span><br/>
		<input type="text" name="code" id="code" size="15" placeholder="1234" required />
		<input type="text" value="zzz" style="display: none" />
	</div>
	<div id="div_input" align="center">
		<button id="join-button"  onclick="selectcode();" type="button" class="btn btn-default myclose" data-dismiss="modal">확인</button>
	</div>
</form>
</body>