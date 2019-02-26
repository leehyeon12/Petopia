<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<link rel="stylesheet" href="//mugifly.github.io/jquery-simple-datetimepicker/jquery.simple-dtpicker.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//mugifly.github.io/jquery-simple-datetimepicker/jquery.simple-dtpicker.js"></script>

<style type="text/css">
   textarea {
      resize: none;
      width: 99.8%;
   }
   
   form {
      margin: 0 auto;
   }
   
   .m-15 {
      margin-top: 15px;
   }
   
   .reg-title {
      font-size: 17px;
      font-weight: bold;
      letter-spacing: -0.02em;
      margin-top: 10px;
      margin-bottom: 3px;
   }
   
   .profile input[type="file"] {
      /* 파일 필드 숨기기 */
      position: absolute;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      border: 0;
   }
   
   ul {
      list-style-type: none;
      padding: 0px;
   }
   
   .date {
      background-image: url("resources/img/care/calendar.png");
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center right;
   }
   
   .filebox input[type="file"] {
      position: absolute;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      border: 0;
   }
   
   .filebox label { 
      display: inline-block;
      padding: .5em .75em;
      color: #fff;
      font-size: inherit;
      line-height: normal;
      vertical-align: middle;
      cursor: pointer;
      border: 1px solid #f9d16b; /*#fc766a*/
      background:#f9d16b; /*#fc766a*/
      border-radius: .25em;
   }
   
   /* named upload */
   .filebox .upload-name {
      display: inline-block;
      padding: .5em .75em; /* label의 패딩값과 일치 */
      font-size: inherit;
      font-family: inherit;
      line-height: normal;
      vertical-align: middle;
      background-color: #f5f5f5;
      border: 1px solid #ebebeb;
      border-bottom-color: #e2e2e2;
      border-radius: .25em;
      -webkit-appearance: none; /* 네이티브 외형 감추기 */
      -moz-appearance: none;
      appearance: none;
   }
   
   /* imaged preview */
   .filebox .upload-display { /* 이미지가 표시될 지역 */
      margin-bottom: 5px;
   }
   
   @media ( min-width : 768px) {
      .filebox .upload-display {
         display: inline-block;
         margin-right: 5px;
         margin-bottom: 0;
      }
   }
   
   .filebox .upload-thumb-wrap { /* 추가될 이미지를 감싸는 요소 */
      display: inline-block;
      width: 54px;
      padding: 2px;
      vertical-align: middle;
      border: 1px solid #ddd;
      border-radius: 5px;
      background-color: #fff;
   }
   
   .filebox .upload-display img { /* 추가될 이미지 */
      display: block;
      max-width: 100%;
      width: 100% \9;
      height: auto;
   }
</style>

<script type="text/javascript">
   $(document).ready(function() {
      
	    $('.profile').css('height', $(".profile").width()-1);
	    $('.radius-box').css('width', $(".profile").width());
	    $('.radius-box').css('height', $(".radius-box").width()-1);
	    
		$(window).resize(function() { 
			$('.profile').css('height', $(".profile").width());
			$('.radius-box').css('height', $(".profile").width());
			$('.radius-box').css('width', $(".profile").width());
	    });  
	   
      var fileTarget = $('.filebox .upload-hidden');

       fileTarget.on('change', function(){
           if(window.FileReader){
               // 파일명 추출
               var filename = $(this)[0].files[0].name;
           } 

           else {
               // Old IE 파일명 추출
               var filename = $(this).val().split('/').pop().split('\\').pop();
           };

           $(this).siblings('.upload-name').val(filename);
       });

       //preview image 
       var imgTarget = $('.preview-image .upload-hidden');

       imgTarget.on('change', function(){
           var parent = $(this).parent();
           parent.children('.upload-display').remove();

           if(window.FileReader){
               //image 파일만
               if (!$(this)[0].files[0].type.match(/image\//)) return;
               
               var reader = new FileReader();
               reader.onload = function(e){
                   var src = e.target.result;
                   parent.prepend('<div class="upload-display"><div class="upload-thumb-wrap"><img src="'+src+'" class="upload-thumb"></div></div>');
               }
               reader.readAsDataURL($(this)[0].files[0]);
           }

           else {
               $(this)[0].select();
               $(this)[0].blur();
               var imgSrc = document.selection.createRange().text;
               parent.prepend('<div class="upload-display"><div class="upload-thumb-wrap"><img class="upload-thumb"></div></div>');

               var img = $(this).siblings('.upload-display').find('img');
               img[0].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\""+imgSrc+"\")";        
           }
       });

      $('.datetimepicker').appendDtpicker({
         'locale' : 'ko'
      });

      $("#caertype").val("${fk_caretype_UID}");

      getCaretype_info();

      $("#caertype").bind("change", function() {
         getCaretype_info();
      });

      // 등록버튼
      $("#btnRegister").click(function() {

         //폼 submit
         var registerFrm = document.registerFrm;
         registerFrm.action = "careRegisterEnd.pet";
         registerFrm.method = "POST";
         registerFrm.submit();

      });

   }); // end of ready()-------------------------------------------

   function getCaretype_info() {

      var form_data = {
         caertype : $("#caertype").val()
      };

      $.ajax({
               url : "getCaretype_info.pet",
               type : "GET", // method
               data : form_data, // 위의 URL 페이지로 사용자가 보내는 ajax 요청 데이터.
               dataType : "JSON", // URL 페이지로 부터 받아오는 데이터타입
               success : function(json) { // 데이터 전송이 성공적으로 이루어진 후 처리해줄 callback 함수

                  $("#displayCaretype_info").empty();

                  var html = "";

                  $
                        .each(
                              json,
                              function(entryIndex, entry) {
                                 html += "<div style='padding: 10px; border: 1px solid gray;'>"
                                       + entry.CARETYPE_INFO
                                       + "</div>";
                              });

                  $("#displayCaretype_info").append(html);
               },
               error : function(request, status, error) {
                  alert("code: " + request.status + "\n" + "message: "
                        + request.responseText + "\n" + "error: "
                        + error);
               }
            });

   } // end of function getCaretype_info()-------------------------------------------
   
</script>



<div class="container">
   <div class="col-sm-12">
      <div class="col-sm-offset-2 col-md-8" style="background-color: #f2f2f2;">
         <div class="col-sm-12" align="center">
            <h2>케어등록/수정</h2>
         </div>

         <div class="col-sm-12">
            <form name="registerFrm">
               <input type="hidden" name="fk_pet_UID" value="${fk_pet_UID}" /> <%-- 수정_value를 받아와야 한다. --%>
            
               <div class="col-sm-offset-2 col-sm-8 preview-image" style="margin-bottom: 20px;">
               
                  <div class="row">
                     <div class="col-sm-3">
                        <div class="profile" style="background-color: #d9d9d9; height: 150px; border-radius: 100%;" align="center">
                           <!-- 
                           <label for="input-file">프로필</label>  
                           -->
                           <img id="beforeProfile" width="100%" src="resources/img/care/${petInfo.PET_PROFILEIMG}" class="upload-thumb radius-box" style="border-radius: 100%;"> 
                        </div>
                     </div>
                     <div class="col-sm-9">
                        <ul>
                           <li>
                              <select id="caertype" name="fk_caretype_UID">   
                                                                     
                              <c:if test="${caretypeList != null && not empty caretypeList}">
                              
                              <c:forEach var="map" items="${caretypeList}">
                                 <option value="${map.CARETYPE_UID}">${map.CARETYPE_NAME}</option>
                              </c:forEach>
                              
                              </c:if>

                              </select>
                           </li>
                           
                           <div id="displayCaretype_info">

                           </div>
                           
                        </ul>
                     </div>
                  </div>

                  <div class="row" style="margin-top:20px;">
                     <div class="col-sm-12">
                        <ul>
                           <li class="reg-title">내용</li>
                           <li><textarea id="content" name="care_contents" rows="10" cols="100" style="height: 212px;" placeholder="각 항목에 관련된 안내사항 또는 예시"></textarea></li>
                        </ul>                     
                     </div>
                  </div>

                  <!-- Multiple Radios (inline) -->
                  <div class="row">
                     <div class="col-sm-12">
                        <ul>
                           <li class="reg-title">메모</li>
                           <li><textarea id="content" name="care_memo" rows="10" cols="100" style="height: 212px;" placeholder="각 항목에 관련된 안내사항 또는 예시"></textarea></li>
                        </ul>                     
                     </div>
                  </div>
                  
                  <!-- Multiple Radios (inline) -->
                  <div class="row m-15">
                     <div class="col-sm-12">
                        <div class="reg-title">사진 올리기</div>
                        <div class="filebox" style="display: inline-block;">
                           <input id="" class="upload-name" name="" value="사진 올리기" disabled="disabled"/>
                           
                           <label for="ex_filename" style="margin-bottom:0;">업로드</label>
                           <input type="file" id="ex_filename" class="upload-hidden">
                        </div>            
                     </div>
                  </div> 
   
                  <!-- Multiple Radios (inline) -->
                  <div class="row m-15"> 
                     <div class="col-sm-12">
                        <div class="reg-title" style="padding: 0px;">시작 일시</div>
                        <div class="col-sm-4" style="display: inline-block;padding: 0px;"><input type="text" id="care_start" class="datetimepicker date" name="care_start" autocomplete="off" /></div>
                        <div class="col-sm-4" align="center" style="display: inline-block;"><i class="fa fa-angle-double-right" style="font-size: 30pt;"></i></div>
                        <div class="col-sm-4" style="display: inline-block;"><input type="text" id="care_end" class="datetimepicker date" name="care_end" autocomplete="off" /></div>   
                     </div>
                  </div>  
   
                  <!-- Multiple Radios (inline) -->
                  <div class="row m-15"> 
                     <div class="col-sm-12">               
                        <ul>
                           <li class="reg-title">알림</li>
                           <li>
                              <select id="" class="" name="care_alarm">
                                 <option value="5">5분전</option>
                                 <option value="10">10분전</option>
                              </select>
                           </li>
                        </ul>                        
                     </div>
                     <!-- button area -->
                     <div class="col-sm-12" style="text-align:center;margin-top:15px;">
                        <button type="button" class="btn btn-rounder btnmenu" id="btnRegister">등록</button>
                        <button type="button" onclick="javascript:history.back();" class="btn btn-rounder btnmenu" style="color: white; background-color: gray;">취소</button>
                     </div>
                  </div>  
                  
               </div>
            </form>
            
         <!-- <div class="col-sm-12"> -->
         </div>
      </div>
   </div>
</div>