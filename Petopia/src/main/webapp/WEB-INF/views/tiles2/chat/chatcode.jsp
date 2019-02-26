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
		
		var chatcode = $('input#code').val();
		
		$("#code").keydown(function(event){
			
			if(event.keyCode == 13) {
				viewcode(chatcode);
			}
		}); 
		
		$("#join-button").click(function(){
			viewcode(chatcode);
		});
		
	}); // end of document.ready
		
	<%-- function join() {
		
		var chatcode = $('input#code').val();
		/* var confirmcode = $("#div_code").find("input[id=hide]").val(); */
		var confirmcode = $('input#hide').val();
		if(chatcode == confirmcode) {
			var frm = document.videochatFrm;
			parent.location.href="<%= serverName %><%= ctxPath %>/videochat.pet";
			frm.submit();
		}
		else{
			alert("번호가 일치하지 않습니다 다시입력해주세요");
		}
	} --%>
	
	function viewcode() {
		
		var chatcode = $("#code").val();
		
		var form_data = {"code" : chatcode};
		
		$.ajax({
			url : "<%= request.getContextPath() %>/viewcode.pet",
			type : "GET",
			data : form_data,
			dataType : "JSON",
			success : function(json) {
				var result = json.code;
				if(chatcode == result) {
					var frm = document.videochatFrm;
					parent.location.href="<%= serverName %><%= ctxPath %>/videochat.pet";
				}
				else{
					alert("번호가 일치하지 않습니다 다시입력해주세요");
				}
			},
			
			error : function() {
				alert("코드불러오는데 실패했습니다. DB를 확인해주세요");
			}
		})

	}

</script>

<body style="background-color: white;">
<form name="videochatFrm">
	<div id="div_code" align="center">
		<span style="color: black; font-size: 12pt;">상담을 위한 코드를 입력해주세요</span><br/><br/>
		<div class="row">
			<div class="col-md-3">
				<input type="text" class="form-control" name="code" id="code" size="15" placeholder="123456" required />
				<input type="text" value="zzz" style="display: none"/>
			</div>
			<div class="col-md-2" id="div_input" align="center" style="margin-top: 5%;">
				<button id="join-button"  onclick="viewcode();" type="button" class="btn btn-rounder myclose" data-dismiss="modal">확인</button>
			</div>
		</div>
	</div>
	
</form>
</body>