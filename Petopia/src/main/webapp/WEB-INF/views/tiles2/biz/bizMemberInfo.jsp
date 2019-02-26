<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/jquery-ui-1.11.4.custom/jquery-ui.css" />
<script type="text/javascript" src="<%= request.getContextPath() %>/resources/jquery-ui-1.11.4.custom/jquery-ui.js"></script>

<style type="text/css">
   .profile label { 
      display: inline-block; 
      padding: 3% 4%;
      color: #999;
      font-size: inherit;
      line-height: normal; 
      vertical-align: middle; 
      cursor: pointer; 
   } 
   .profile input[type="file"] { 
      /* 파일 필드 숨기기 */
      position: absolute; 
      width: 1px; 
      height: 1px; 
      padding: 0; 
      margin: -1px; 
      overflow: hidden; 
      clip:rect(0,0,0,0); 
      border: 0; 
   }
   
   /* imaged preview */ 
   .filebox .upload-display { 
      /* 이미지가 표시될 지역 */ 
      margin-bottom: 5px; 
   } 
   
   .filebox .upload-thumb-wrap { 
      /* 추가될 이미지를 감싸는 요소 */ 
      display: inline-block; 
      vertical-align: middle; 
      border: 1px solid #ddd; 
      border-radius: 100%; 
      background-color: #fff; 
   } 
   
   .filebox .upload-display img { 
      /* 추가될 이미지 */
      display: block; 
      max-width: 100%; 
      width: 100%; 
      height: auto;
   }
   
   .radius-box {
       width: 125px;
       height:125px;
       object-fit: cover;
       object-position: top;
       border-radius: 50%;
   }
   
	.btn1 {
	   width: 80px;
	   font-size:15px;
	   color: white;
	   text-align: center;
	   background: grey;
	   border: solid 0px grey;
	   border-radius: 30px;
	}
	
	.cancelbtn, .submitbtn {
		background-color: inherit;
		border: 1px;
	}
	
	.error {
		color: red;
		align-content: center;
	}
	
	#error_passwd { 
		color: red; 
		padding-left: 10px; 
		margin-bottom: 5px;
	}
	.changColor {
		background-color: rgb(252, 118, 106);
	}
	
</style>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

<script type="text/javascript">
   $(document).ready(function(){
	   
	      $("#spinnerOqty1").spinner({
	  	      spin: function( event, ui ) {
	  	        if( ui.value > 10 ) {
	  	          $( this ).spinner( "value", 0 ); 
	  	          return false;
	  	        } 
	  	        else if ( ui.value < 0 ) {
	  	          $( this ).spinner( "value", 10 );
	  	          return false;
	  	        }
	  	      }
	  	    });
			
			// 추가이미지 스피너
			$("#spinnerOqty1").bind("spinstop", function(){
				// 스핀너는 이벤트가 "change" 가 아니라 "spinstop" 이다.
				var html = "";
				
				var spinnerOqtyVal = $("#spinnerOqty1").val();
				
				if(spinnerOqtyVal == "0") {
					$("#divFileattach").empty();
					return;
				}
				else
				{
					for(var i=0; i<parseInt(spinnerOqtyVal); i++) {
						html += "<br/>";
						html += "<input type='file' name='addimg' class='btn btn-default' />";
					}
					
					$("#divFileattach").empty();
					$("#divFileattach").append(html);	
				}
			});
			$("#spinnerOqty2").spinner({
		  	      spin: function( event, ui ) {
		  	        if( ui.value > 10 ) {
		  	          $( this ).spinner( "value", 0 ); 
		  	          return false;
		  	        } 
		  	        else if ( ui.value < 0 ) {
		  	          $( this ).spinner( "value", 10 );
		  	          return false;
		  	        }
		  	      }
		  	    });
				
				// 의료진 추가 스피너
				$("#spinnerOqty2").bind("spinstop", function(){
					// 스핀너는 이벤트가 "change" 가 아니라 "spinstop" 이다.
					var html = "";
					
					var spinnerOqtyVal = $("#spinnerOqty2").val();
					
					if(spinnerOqtyVal == "0") {
						$("#doc_attached").empty();
						return;
					}
					else // spinnerOqty2
					{
						for(var i=0; i<parseInt(spinnerOqtyVal); i++) {
							html += "<br/>";
							html +='<div class="row">' 
								+'<div class="col-sm-3 col-md-3">'
			                  +'<input type="text" class="form-control must" name="doctor" style="width: 100%"/>'
			               +'</div>'
			                +'<div class="col-sm-6 col-md-6" style="margin-top: 0.5%;">'
			                	+'<button type="button" class="selectbtn btn1 docdog'+i+'">강아지</button>'
			                	+'<input type="hidden" name="docdog" id="docdog'+i+'" value="0">'
				                +'<button type="button" class="selectbtn btn1 doccat'+i+'">고양이</button>'
				                +'<input type="hidden" name="doccat" id="doccat'+i+'" value="0">'
				                +'<button type="button" class="selectbtn btn1 docsma'+i+'">소동물</button>'
				                +'<input type="hidden" name="docsmallani" id="docsma'+i+'" value="0">'
				                +'<button type="button" class="selectbtn btn1 docetc'+i+'">기타</button>'
				                +'<input type="hidden" name="docetc" id="docetc'+i+'" value="0">'
			                +'</div></div>';
						}
						
						$("#doc_attached").empty();
						$("#doc_attached").append(html);	
					}
				});

			$(document).on('click', '.selectbtn', function(){
				var $target = $(event.target);
				
				var cl = $(this).attr('class');
				var str_cl = String(cl);
				var start = str_cl.indexOf('doc');
				var idName = str_cl.substr(start, 7);
				
				var val = $("#"+idName).val();
				
				if(!$target.hasClass("changColor")){
					$target.addClass("changColor");
					
					val = 1;
				}
				else {
					$target.removeClass("changColor");
					
					val = 0;
					
				} // end of if
				
				$("#"+idName).val(val);
			});
		/* $(".selectbtn").click(function(){
			var $target = $(event.target);
			
			if(!$target.hasClass("changColor")){
				$target.addClass("changColor");
			}
			else {
				$target.removeClass("changColor");
			}
		}); */
	   
       $(".upload-hidden").hide();
       $(".error").hide();
       $(".useridError").hide();
       $(".useridDuplicate").hide();
       $(".useridUsed").hide();
       $(".pwdError").hide();
       $(".pwdCheckError").hide();
       $(".phoneError").hide();
      
       $('.profile').css('height', $(".profile").width()-1);
       $('.radius-box').css('width', $(".profile").width());
       $('.radius-box').css('height', $(".radius-box").width()-1);
       
      $(window).resize(function() { 
         $('.profile').css('height', $(".profile").width());
         $('.radius-box').css('height', $(".profile").width());
         $('.radius-box').css('width', $(".profile").width());
       });
      
      // profile에 이미지 띄우기
      var imgTarget = $('.preview-image .upload-hidden'); 
      imgTarget.on('change', function(){ 
         var parent = $(this).parent(); 
         parent.children('.upload-display').remove(); 
         if(window.FileReader){ 
            //image 파일만
            if (!$(this)[0].files[0].type.match(/image\//)) return; 
            var reader = new FileReader(); 
            reader.onload = function(e){ 
               var src = e.target.result; parent.prepend('<div class="profile upload-display"><div class="upload-thumb-wrap"><img width="100%" src="'+src+'" class="upload-thumb radius-box"></div></div>'); 
            } 
            reader.readAsDataURL($(this)[0].files[0]); 
            
            $(".profile").css('background-color','#f2f2f2');
         }
      });// end of imgTarget.on()-----------------------
      
      
      $(".selectbtn").click(function(){
	   	  if($(this).val() == 0) {
	   		$(this).val(1);
	   	  } else {
	   		$(this).val(0);
	   	  }
      });
      
      // 유효성 검사
      $(".must").each(function() {
    	 $(this).blur(function() {
    		 var data = $(this).val().trim();
    		 if(data == "") {
    			 $(this).parent().find(".error").show();
    			 return;
    		 } else {
    			 $(this).parent().find(".error").hide();
    		 }
    	 }) 
      });// end of $(".must").each()------------------------
      
      // 아이디 유효성 검사
      var cnt = 0;
		$("#userid").blur(function(){
			var userid = $(this).val();
			var regExp_EMAIL = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
			var isUseEmail = regExp_EMAIL.test(userid);
			
			if(!isUseEmail){
				$(".useridError").show();
				return;
			}
			else{
				$(".useridError").hide();
				
				var data = {"userid":$("#userid").val()};
				$.ajax({
					url: "<%=request.getContextPath()%>/idDuplicateCheck.pet",
					type: "GET",
					data: data,
					dataType: "JSON",
					success: function(json){
						$(".useridUsed").show();
						$(".useridUsed").html(json.MSG);
						cnt = json.CNT;
					},
					error: function(request, status, error) {
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				}); // end of ajax
			} // end of if~else
		});
      
      // 비밀번호 유효성 검사
      $("#pwd").blur(function() {
    	 var passwd = $(this).val();
    	 var regExp_pw = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
    	 var isUsePasswd = regExp_pw.test(passwd);
    	 if(passwd.length != 0 && !isUsePasswd) {
    		 $(".pwdError").show();
    		 $(this).val("");
    		 return
    	 }
    	 else {
    		 $(".pwdError").hide();
    	 }
      }); // end of $("#pwd").blur()-------------------------------
      
      // 비밀번호 체크
      $("#pwdCheck").blur(function() {
    	 var password = $("#pwd").val();
    	 var pwdcheck = $(this).val();
    	 
    	 if(password != pwdcheck) {
    		 $(".pwdCheckError").show();
    		 $(this).val("");
    		 return;
    	 }
    	 else {
    		 $(".pwdCheckError").hide();
    	 }
      }); // end of $("#pwdCheck").blur()-----------------
      
      // 대표연락처 검사
      $("#phone").blur(function(){
			var phone = $(this).val();
			var isphone = false;
			var regExp_phone = /^[0-9]+$/g;

			isphone = regExp_phone.test(phone);
			
			if(phone.length != 0 && (!isphone || !(phone.length == 11 || phone.length == 10) ) ) {
				$(".phoneError").show();
				$(this).val("");
				return;
			} else{
				$(".phoneError").hide();
			}	
		});
      
      
      $("#goBizJoinBtn").click(function() {
    	 
    	 $(".must").each(function() {
    		 var data = $(this).val().trim();
    		 if(data == "") {
    			 $(this).parent().find(".error").show();
    			 return;
    		 }
    		 else {
    			 $(this).parent().find(".error").hide();
    		 }
    	  });
    	  
    	  var userid = $("#userid").val();
    	  var regExp_EMAIL = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
    	  var isUseEmail = regExp_EMAIL.test(userid);
    	  
    	  if(!isUseEmail) {
    		  $(".useridError").show();
    		  return;
    	  }
    	  else {
    		  $(".useridError").hide();
    	  }
    	  
    	  if(cnt == null || cnt != 0) {
    		  alert("아이디 중복 검사를 하셔야 합니다.");
    		  return;
    	  }
    	  
    	  var passwd = $("#pwd").val();
    	  var regExp_pw = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
    	  var isUsePasswd = regExp_pw.test(passwd);
    	  if(passwd.length != 0 && !isUsePasswd) {
    		  $(".pwdError").show();
    		  $(this).val("");
    		  return;
    	  }
    	  else {
    		  $(".pwdError").hide();
    	  }
    	  
    	  var password = $("#pwd").val();
    	  var pwdcheck = $("#pwdCheck").val();
    	  
    	  if(password != pwdcheck) {
    		  $(".pwdCheckError").show();
    		  $(this).val("");
    		  return;
    	  }
    	  else {
    		  $(".pwdCheckError").hide();
    	  }
    	  
    	  var phone = $("#phone").val();
    	  var isphone = false;
    	  var regExp_phone = /^[0-9]+$/g;
    	  
    	  isphone = regExp_phone.test(phone);
    	  
    	  if(phone.length != 0 && (!isphone || !(phone.length == 11 || phone.length == 10) ) ) {
    		  $(".phoneError").show();
    		  $(this).val("");
    		  return;
    	  }
    	  else {
    		  $(".phoneError").hide();
    	  }
    		  
    	  var isCheckedAgree = $("input:checkbox[id=agree]").is(":checked");
    	  if(!isCheckedAgree) {
    		  alert("이용약관에 동의하셔야 가입이 가능합니다.");
    		  return;
    	  }
    	  
    	  var index = 0;
    	  $(".tagsNo").each(function() {
    		 if(!$(this).is(':checked')) {
    			 $(this).parent().find(":input[name=tagName]").attr("disabled", true);
    		 }
    		 else {
    			 index++;
    		 }
    	  });
    	  
    	  if(index > 5) {
    		  alert("태그는 최대 5개까지만 선택 가능합니다");
    		  return;
    	  } 
    	  
    	  var frm = document.bizjoinFrm;
    	  frm.action = "<%=request.getContextPath()%>/joinBizMemberInsert.pet";
    	  frm.method = "POST";
    	  frm.submit();
      });
      
      
      // 프로필 사진 유효성 검사
      // 크기
      var maxSize = 10*1024*1024; // 10MB
      var fileSize = document.getElementById("attach").files[0].size;
      //alert(fileSize);
      
      // 이미지인지 확인
      var extension = getFileExtension($("#attach").val());
      //alert(extension);
      
      if(typeof $("#attach").val() == "undefined") {
         alert("프로필을 입력하지 않으셨습니다.");
         
         return;
      } else if(fileSize > maxSize) {
         alert("프로필은 "+maxSize+"MB을 초과하였으므로 업로드가 불가합니다!");
         
         //attachFileValueDel();
         return;
      } else {
         img_Check($("#attach").val());
      } // end of if~else
    	  
     
      
   });// end of $(document).ready()----------------------
   
	// 파일 확장자 값 가져오기
	function getFileExtension(filePath){
      var lastIndex = -1;
      lastIndex  = filePath.lastIndexOf('.');
      var extension = "";

      if(lastIndex != -1){
         extension = filePath.substring( lastIndex+1, filePath.len );
      }else{
         extension = "";
      }
      return extension;
   } // end of function getFileExtension(filePath)

   // 파일 확장자 체크하기
   function img_Check(value) {
      var src = getFileExtension(value);
    
      if(!((src.toLowerCase() == "gif") || (src.toLowerCase() == "jpg") || (src.toLowerCase() == "jpeg") || (src.toLowerCase() == "png"))){
         alert('gif, jpg, png 파일만 지원합니다.');
         return;
       }
      
   } // end of function fnImg_Check(value) 
  
   <%-- 주소 --%>
   function address() {
       new daum.Postcode({
           oncomplete: function(data) {
               // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

               // 각 주소의 노출 규칙에 따라 주소를 조합한다.
               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
               var addr = ''; // 주소 변수
               var extraAddr = ''; // 참고항목 변수

               //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
               if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                   addr = data.roadAddress;
               } else { // 사용자가 지번 주소를 선택했을 경우(J)
                   addr = data.jibunAddress;
               }

               // 우편번호와 주소 정보를 해당 필드에 넣는다.
               document.getElementById('postcode').value = data.zonecode;
               document.getElementById("addr1").value = addr;
               // 커서를 상세주소 필드로 이동한다.
               document.getElementById("addr2").focus();
               
               
               
          	    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
           	    mapOption = {
        	        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        	        level: 3 // 지도의 확대 레벨
           	    };  

          	 	// 지도를 생성합니다    
          	 	var map = new daum.maps.Map(mapContainer, mapOption); 
          	
          	 	// 주소-좌표 변환 객체를 생성합니다
          	 	var geocoder = new daum.maps.services.Geocoder();
          	 	
          	 	var address2 = addr
          	 	
          	 	// alert(address2);
          	
          	 	// 주소로 좌표를 검색합니다
          	 	geocoder.addressSearch(address2, function(result, status) {

        	   	    // 정상적으로 검색이 완료됐으면 
        	   	     if (status === daum.maps.services.Status.OK) {
        	
        	   	        var coords = new daum.maps.LatLng(result[0].y, result[0].x);
        	   	        
        	   	        //alert(coords);
        	   	        
        	   	        var spot = String(coords);
        	   	       // alert(spot);
        	   	        spot = spot.substring(1, spot.length-1);
        	   	        //alert(spot);
        	   	        
        	   	        var locSplit = spot.split(',');
        	   	        // alert(locSplit);
        	   	        $("#latitude").val(locSplit[0].trim());
        	   	        $("#longitude").val(locSplit[1].trim());
        	   	        
        	   	        
        	   	    } 
           		});// end of geocoder.addressSearch()
           }
       }).open();
   }
   
</script>


<div id="map" style="width:100%;height:350px; display: none; "></div>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d95bf006c44a2e98551f0af770a55949&libraries=services"></script>

<div class="container">
	<div class="col-sm-12" style="background-color: #f2f2f2; margin-top: 5%;">

		<div class="col-sm-12" align="center">
			<h2>병원정보관리</h2>
		</div>
		<div class="col-sm-12">
			<form name="bizeditFrm" enctype="multipart/form-data">
				<div class="col-sm-offset-2 col-md-8 preview-image" style="margin-bottom: 20px;">
					<div class="row">
						<div class="col-sm-3">
							<div class="profile" style="background-color: #d9d9d9; height: 150px; border-radius: 100%;" align="center">
								<label for="attach">프로필</label> <input type="file" class="upload-hidden must" id="attach" name="attach" />
							</div>
						</div>
						<div class="col-sm-9" style="padding-top: 28px;">
							<span style="color: #999;">ID(email)</span>
							<input type="text" class="form-control must" id="userid" name="userid" />
						</div>
					</div>

					<div class="row">
						<div class="col-sm-4" style="padding-top: 35px;">
							<label style="color: #999;">password</label>
							<input type="password" class="form-control must" id="pwd" name="pwd" />
							<span class="error">필수 입력사항입니다.</span> <span class="pwdError" style="color: red;">비밀번호는 8~16자 영문자,숫자,특수문자 모두 포함해야합니다.</span>
						</div>
						<div class="col-sm-6" style="padding-top: 35px;">
							<label style="color: #999;">password Check</label>
							<input type="password" class="form-control must" id="pwdCheck" name="pwdCheck" />
							<span class="error">필수 입력사항입니다.</span>
							<span class="pwdCheckError" style="color: red;">비밀번호가 일치하지 않습니다.</span>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;" align="center">
						<div class="col-sm-4 text-left">
							<label style="color: #999;">병원/약국명</label>
							<input type="text" class="form-control must" id="name" name="name" />
							<span class="error">필수입력 사항입니다.</span>
						</div>

						<div class="col-sm-4 text-left">
							<label style="color: #999;">대표자명</label><BR>
							<input type="text" class="form-control must" id="repname" name="repname" />
							<span class="error">필수입력 사항입니다.</span>
						</div>

						<div class="col-sm-4 text-left">
							<label style="color: #999;">사업자번호</label><BR>
							<input type="text" class="form-control must" id="biznumber" name="biznumber" />
							<span class="error">필수입력 사항입니다.</span>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-4">
							<label style="color: #999;">대표 연락처</label>
							<input type="text" class="form-control must" id="phone" name="phone" style="width: 80%;" />
							<span class="error">필수입력 사항입니다.</span>
							<span class="phoneError" style="color: red;">대표연락처는 10~11자 숫자만 가능합니다.</span>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<label style="color: #999; padding-left: 15px;">주소</label><BR>
						<div class="col-sm-2">
							<input type="text" class="form-control must" name="postcode" id="postcode" placeholder="우편번호">
							<span class="error">필수입력 사항입니다.</span>
						</div>
						<div class="col-sm-2">
							<input type="button" class="form-control must" onclick="address()" value="우편번호" style="width: 73%; background-color: #ff6e60; color: white;">
						</div>
					</div>

					<div class="row">
						<div class="col-sm-6" style="padding-top: 5px;">
							<input type="text" class="form-control must" name="addr1" id="addr1" placeholder="주소">
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6" style="padding-top: 5px;">
							<input type="text" class="form-control must" name="addr2" id="addr2" placeholder="상세주소">
						</div>
					</div>

					<input type="hidden" name="latitude" id="latitude">
					<input type="hidden" name="longitude" id="longitude">

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-6">
							<label style="color: #999;">대표 이미지</label>
							<input type="file" class="form-control must" id="prontimg" name="attach2" />
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-6">
							<label style="color: #999;" for="spinnerOqty1">추가 이미지</label>
							<input id="spinnerOqty1" value="0" style="width: 30px; height: 20px;">
							<div id="divFileattach"></div>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-6">
							<label style="color: #999;">진료시간(운영시간)</label><BR>
							<div class="col-sm-4" style="padding-left: 0px; padding-right: 0px;">
								<select class="form-control must" id="weekday" name="weekday">
									<option selected="selected" value="월~금(주 5)">월~금(주 5)</option>
									<option value="화~금(주 4)">화~금(주 4)</option>
									<option value="월,수,금(주 3)">월,수,금(주 3)</option>
								</select>
							</div>

							<div class="col-sm-4" style="padding-right: 0px;">
								<select id="wdstart" name="wdstart" class="form-control must" style="width: 111%;">
									<option selected="selected" value="">선택하세요.</option>
									<c:forEach items="${timeList}" var="time">
										<option value="${time.time1}">${time.time1}</option>
										<option value="${time.time2}">${time.time2}</option>
									</c:forEach>
								</select>
							</div>

							<div class="col-sm-4" style="padding-right: 0px;">
								<select id="wdend" name="wdend" class="form-control must" style="width: 111%;">
									<option selected="selected" value="">선택하세요.</option>
									<c:forEach items="${timeList}" var="time">
										<option value="${time.time1}">${time.time1}</option>
										<option value="${time.time2}">${time.time2}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="col-sm-6">
							<label style="color: #999; margin-left: 16%;">점심시간</label><BR>
							<div class="col-sm-4" style="margin-left: 12%;">
								<select id="lunchstart" name="lunchstart" class="form-control must" style="width: 127%;">
									<option selected="selected" value="">선택하세요.</option>
									<c:forEach items="${timeList}" var="time">
										<option value="${time.time1}">${time.time1}</option>
										<option value="${time.time2}">${time.time2}</option>
									</c:forEach>
								</select> <span class="error">필수 입력사항입니다.</span>
							</div>
							<div class="col-sm-4">
								<select id="lunchend" name="lunchend" class="form-control must" style="width: 127%;">
									<option selected="selected" value="">선택하세요.</option>
									<c:forEach items="${timeList}" var="time">
										<option value="${time.time1}">${time.time1}</option>
										<option value="${time.time2}">${time.time2}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-6">
							<label style="color: #999;">토요일</label><BR>
							<span class="error">필수 입력사항입니다.</span>
							<div class="col-sm-4" style="padding-left: 0px;">
								<select id="satstart" name="satstart" class="form-control must" style="width: 111%;">
									<option selected="selected" value="">선택하세요.</option>
									<c:forEach items="${timeList}" var="time">
										<option value="${time.time1}">${time.time1}</option>
										<option value="${time.time2}">${time.time2}</option>
									</c:forEach>
								</select>
							</div>
							<div class="col-sm-4" style="padding-right: 0px;">
								<select id="satend" name="satend" class="form-control must" style="width: 111%;">
									<option selected="selected" value="">선택하세요.</option>
									<c:forEach items="${timeList}" var="time">
										<option value="${time.time1}">${time.time1}</option>
										<option value="${time.time2}">${time.time2}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="col-sm-6">
							<label style="color: #999; margin-left: 16%;">일요일/공휴일</label><BR>
							<span class="error">필수 입력사항입니다.</span>
							<div class="col-sm-8" style="margin-left: 12%;">
								<input type="text" class="form-control must" id="dayoff" name="dayoff" style="widows: 112%;">
							</div>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-6">
							<label style="color: #999;">진료/처방 가능 동물군 (다중 선택 가능)</label><br />
							<div style="margin-top: 10px;">
								<button type="button" class="selectbtn btn1" id="dog" name="dog" value="0">강아지</button>
								<button type="button" class="selectbtn btn1" id="cat" name="cat" value="0">고양이</button>
								<button type="button" class="selectbtn btn1" id="smallani" name="smallani" value="0">소동물</button>
								<button type="button" class="selectbtn btn1" id="etc" name="etc" value="0">기타</button>
							</div>
						</div>
					</div>
					
					<div class="row" style="padding-top: 20px;">
						<div class="col-md-5">
							<label style="color: #999;">의료진 소개</label><br />
							<label style="color: #999;">(성함 및 직책병기)</label>&nbsp;&nbsp;
							<input id="spinnerOqty2" value="0" style="width: 30px; height: 20px;">
						</div>
						<div class="col-md-1"></div>
					</div>

					<div id="doc_attached"></div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-8">
							<label style="color: #999;">찾아오시는길</label><br />
							<textarea class="form-control must" rows="5" cols="" id="easyway" name="easyway"></textarea>
						</div>
					</div>

					<div class="row" style="padding-top: 20px;">
						<div class="col-sm-8">
							<label style="color: #999;">소개</label><br />
							<textarea class="form-control must" rows="5" cols="" id="intro" name="intro"></textarea>
						</div>
					</div>


					<div class="row tagList1" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">시설상태</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '시설상태'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}" /> &nbsp;
										<label style="color: #999;" for="tag${tag.TAG_UID}">#${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}" />
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<div class="row tagList2" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">서비스</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '서비스'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}" /> &nbsp;
										<label style="color: #999;" for="tag${tag.TAG_UID}">#${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}" />
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<div class="row tagList3" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">가격</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '가격'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}" /> &nbsp;
										<label style="color: #999;" for="tag${tag.TAG_UID}">#${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}" />
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<div class="row tagList4" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">전문분야</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '전문분야'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}" /> &nbsp;
										<label style="color: #999;" for="tag${tag.TAG_UID}">#${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}" />
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<div class="row tagList5" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">시간</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '시간'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}" /> &nbsp;
										<label style="color: #999;" for="tag${tag.TAG_UID}">#${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}" />
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<div class="row tagList6" style="margin-top: 3%;">
						<div class="col-sm-2">
							<span style="color: #999;">편의시설</span>
						</div>
						<div class="col-sm-10">
							<c:forEach var="tag" items="${tagList}">
								<c:if test="${tag.TAG_TYPE == '편의시설'}">
									<div class="col-sm-4">
										<input type="checkbox" class="tagsNo" id="tag${tag.TAG_UID}" name="tagNo" value="${tag.TAG_UID}" /> &nbsp;
										<label style="color: #999;" for="tag${tag.TAG_UID}">#${tag.TAG_NAME}</label>
										<input type="hidden" name="tagName" value="${tag.TAG_NAME}" />
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<div class="row" align="center" style="margin-top: 3%;">
						<input type="checkbox" class="requiredInfo" id="agree" name="agree" />
						<label style="color: #999;" for="agree">서비스 이용 및 약관에 동의합니다.</label>
					</div>
				</div>

				<hr style="height: 1px; background-color: white; border: none; margin-bottom: 0px;">
				
				<div class="row">
					<div class="col-sm-6">
						<button type="button" class="cancelbtn" style="width: 100%; height: 60px;" onclick="javascript:location.href='<%=request.getContextPath()%>/index.pet'">CANCEL</button>
					</div>
					<div class="col-sm-6">
						<button type="button" class="submitbtn" id="goBizJoinBtn" style="width: 100%; height: 60px;">SUBMIT</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
