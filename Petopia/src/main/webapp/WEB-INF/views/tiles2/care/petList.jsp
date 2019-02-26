<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">

	.pet-title{
      font-size:40px;
      font-weight:545;
      letter-spacing:-0.04em;
      text-align:center;
      margin-bottom:10px;
   }
   
   .pet-added {
      position: relative;
      margin: 10px 3px;
      padding: 4% 1% 2% 1%;
      width: 24%;
      border: 1px solid #dadada;
       background: rgba(234, 234, 234, 0.3);
   }

   .pet-box {
      position: relative;
      margin: 10px 3px;
      padding: 4% 1% 2% 1%;
      width: 24%;
      border: 1px solid #dadada;
       background: rgba(234, 234, 234, 0.3);
   }
   
   .box:before { 
       content: "";
       display: block;
       padding-top: 100%; /* 1:1 비율 */
   }  
   
   .pet-img-box {
      width: 100%;
      margin:10px 0 10px 0;
      border: 1px solid #dadada;
      background: #fff;
      text-align: center;
   }
   
   .pet-img-box img {
      width: 100%;
      height: 180px;
   }

   .prod-none {
      display: none;
   } 
   
   .pet-hover {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(252, 118, 106, 0.66);
   }
   
   .pet-hover div {
      font-size: 16px;
      position: relative;
      margin: auto;
      left: 0;
      right: 0;
      top: 30;
      bottom: 0;
      color: #fff;
      font-weight: 1000;
      border: 2px solid #fff;
      width: 100px;
      height: 43px;
      line-height: 45px;
      box-sizing: border-box;
      text-align: center;
   }
   
   ul {
      list-style-type: none;
      padding: 0px;
   }
   
   .pointer{
      cursor: pointer;
   }
   
</style>

<%-- [19-01-24. 수정 시작_hyunjae] --%>
<script type="text/javascript">

   $(document).ready(function() {

      if(${fk_idx != null}){
         $("#fk_idx").val("${fk_idx}");
      }
       
      getPet();
      
   });// end of $(document).ready()----------------------------------------
      
   function getPet() { 
      
      var form_data = {fk_idx : $("#fk_idx").val()}; 

      $.ajax({
         url : "getPet.pet",   
         type :"GET",                               // method
         data : form_data,                          // 위의 URL 페이지로 사용자가 보내는 ajax 요청 데이터.
         dataType : "JSON",                         // URL 페이지로 부터 받아오는 데이터타입
         success : function(json) {                 // 데이터 전송이 성공적으로 이루어진 후 처리해줄 callback 함수
                  $("#displayPetList").empty();
                                 
                  var html = "";
                  
                  $.each(json, function(entryIndex, entry){ 
                                    
                     html += "<div class=\"col-sm-3 pet-box\">"
                          + "   <div class=\"pet-img-box\">"
                          + "      <img src=\"resources/img/care/" + entry.PET_PROFILEIMG + "\">"
                          + "   </div>"
                          + "   <div>" + entry.PET_NAME + "</div>"
                          + "   <div>"
                          + "      <span>" + entry.PET_BIRTHDAY + "</span>"
                          + "   </div>"
                          + "   <div>"
                          + "      <span>" + entry.PET_SIZE + "</span> | <span>" + entry.PET_GENDER + "</span> | <span>" + entry.PET_WEIGHT + " kg</span>"
                          + "   </div>"
                          + "   <div class=\"pet-hover\"><br/>"
                          + "      <div class=\"pointer\" onclick=window.open(\"index.pet\",\"_self\" style=\"margin-top:10%;\")>정보수정</div>"
                          + "      <div class=\"pointer\" onclick=window.open(\"petView.pet?pet_UID=" + entry.PET_UID + "\",\"_self\") style=\"margin-top:10%;\">관리</div>"
                          + "      <div class=\"pointer\" onclick=window.open(\"index.pet\",\"_self\") style=\"margin-top:10%;\">지우기</div>"
                          + "   </div>"
                          + "</div>";
                     
                  });
                  
                     html += "<div class=\"col-sm-3 pet-box\" style=\"height:330px;text-align:center;\">"   
                          + "      <div style=\"margin-top:35%;\">"
                          + "         <a href='petRegister.pet'><img src='resources/img/care/petAdd.png' width='40px;' height='40px;'></a>"
                          + "      </div>"
                          + "      <div style=\"margin-top:5%;font-size:17px;font-weight:bold;\"> 반려동물 추가하기"
                          + "      </div>"
                          + "</div>";
                     
                  $("#displayPetList").append(html);
                  $('.pet-hover').addClass('prod-none');
                  
                  //목록 hover   
                  $('.pet-box').hover(function() {
                     var num = $('.pet-box').index(this);
                     $('.pet-box div.pet-hover').eq(num).removeClass('prod-none'); // class="pet-box"의 <a>와 num이 같다면'
                  }, function() {
                     $('.pet-hover').addClass('prod-none');
                  });
          },
          error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
          }         
      });
      
   }
   
</script>

<div class="container" style="min-height: 800px;">
   <div class="pet-title">반려동물관리</div>
   
   <div class="row">
      
      <!-- <div class="col-sm-12"> 시작 -->
      <!-- n번째 반려동물 -->
      <div id="displayPetList"  class="col-sm-12">
         <input type="hidden" id="fk_idx" />         
         
      <!-- <div class="col-sm-12"> 끝 -->   
      </div>

   </div>
   <%-- [19-01-24. 수정 끝_hyunjae] --%>
   
</div>