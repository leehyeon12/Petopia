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
		
		var chatcode = $('input#sessionInput').val();
		
		$("#sessionInput").keydown(function(event){
			
			if(event.keyCode == 13) {
				selectcode();
			}
		}); 
		
		$("#join-button").click(function(){
			selectcode();
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
	
	
	/* 방생성 */
	var room = location.search && location.search.split('?')[1];

            // create our webrtc connection
            var webrtc = new SimpleWebRTC({
                // the id/element dom element that will hold "our" video
                localVideoEl: 'localVideo',
                // the id/element dom element that will hold remote videos
                remoteVideosEl: '',
                // immediately ask for camera access
                autoRequestMedia: true,
                debug: false,
                detectSpeakingEvents: true
            });

            // when it's ready, join if we got a room from the URL
            webrtc.on('readyToCall', function () {
                // you can name it anything
                if (room) webrtc.joinRoom(room);
        });
	
	 function setRoom(name) {
         $('form').remove();
         $('h1').text(name);
         $('#subTitle').text('Link to join: ' + location.href);
         $('body').addClass('active');
     }

     if (room) {
         setRoom(room);
     } else {
         $('form').submit(function () {
             var val = $('#sessionInput').val().toLowerCase().replace(/\s/g, '-').replace(/[^A-Za-z0-9_\-]/g, '');
             webrtc.createRoom(val, function (err, name) {
                 console.log(' create room cb', arguments);
             
                 var newUrl = location.pathname + '?' + name;
                 if (!err) {
                     history.replaceState({foo: 'bar'}, null, newUrl);
                     setRoom(name);
                 } else {
                     console.log(err);
                 }
             });
             return false;          
         });
     }
	
     
     /* 수정해야할부분 */
	function selectcode() {
		
		var chatcode = $("#sessionInput").val();
		
		var form_data = {"code" : chatcode};
		
		$.ajax({
			url : "<%= request.getContextPath() %>/viewvideocode.pet",
			type : "GET",
			data : form_data,
			dataType : "JSON",
			success : function(json) {
				var result = json.code;
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
		<input type="text" value="zzz" style="display: none" />
	</div>
	<div id="createRoom" align="center">
		<input type="text" style="display: none" id="subTitle"/>
		<input id="sessionInput" placeholder="1234" />
		<button id="join-button"  onclick="selectcode();" type="submit" class="btn btn-default myclose" data-dismiss="modal">입장 코드 생성</button>
	</div>
</form>
</body>