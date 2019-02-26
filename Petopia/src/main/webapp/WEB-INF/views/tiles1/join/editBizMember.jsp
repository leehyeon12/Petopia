<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	
	


</style>

<script type="text/javascript">
   $(document).ready(function(){
      $(".upload-hidden").hide();
      
       $('.profile').css('height', $(".profile").width()-1);
       $('.radius-box').css('width', $(".profile").width());
       $('.radius-box').css('height', $(".radius-box").width()-1);
       
      $(window).resize(function() { 
         $('.profile').css('height', $(".profile").width());
         $('.radius-box').css('height', $(".profile").width());
         $('.radius-box').css('width', $(".profile").width());
       });
      
      // 수정해서 사용****************
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
      });

   });
   
</script>

<!-- ff6e60 -->


<div class="col-sm-12">
   <div class="col-sm-offset-2 col-sm-8" style="background-color: #f2f2f2;`">
      
      <div class="col-sm-12" align="center">
         <h2>기업회원수정</h2>
      </div>
      <form name="joinFrm">
         <div class="col-sm-offset-2 col-sm-8 preview-image" style="margin-bottom: 15px;">
         <div class="row">
               <div class="col-sm-3">
                  <div class="profile" style="background-color: #d9d9d9; height: 150px; border-radius: 100%;" align="center">
                     <label for="input-file">프로필</label>
                     <input type="file" class="upload-hidden" id="input-file" name="profileimg"/>
                  </div>
               </div>
         
            <div class="row">
               <div class="col-sm-4" style="padding-top: 35px;">
                  <span style="color: #999;">ID(email)</span>
                  <input type="text" class="form-control" id="userid" name="userid" />
               </div>
               <div class="col-sm-4" style="padding-top: 35px;">
                  <span style="color: #999;">password</span>
                  <input type="password" class="form-control" id="userid" name="userid" />
               </div>
            </div>
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-3">
                  <span style="color: #999;">병원/약국명</span>
                  <input type="text" class="form-control" id="pwd" name="pwd"/>
               </div>
               <div class="col-xs-2">
                  <span style="color: #999;">대표자명</span>
                  <input type="text" class="form-control" id="pwd" name="pwd"/>
	               </div>
               <div class="col-sm-3" style="width:18%;">
                  <span style="color: #999;">사업자번호</span>
                  <input type="text" class="form-control" id="pwd" name="pwd"/>
               </div>
            </div>
            
            <div class="row" style="padding-top: 20px;" >
               <div class="col-sm-3">
                  <span style="color: #999;">대표 연락처</span>
                  <input type="password" class="form-control" id="pwdCheck" name="pwdCheck" style="width: 80%;"/>
               </div>
            </div>
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-3" style="width: 15%;">
                  <span style="color: #999;">주소</span> 
                  <input type="text" class="form-control" id="name" name="name" />
               </div>
               
               	<button type="button" class="btn" style="background-color: #ff6e60; color: white; margin-top: 20px;">우편번호</button>
            </div>
            <div class="row">
               <div class="col-sm-6" style="padding-top: 5px;">
                  <input type="text" class="form-control" id="name" name="name"/>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-6" style="padding-top: 5px;">
                  <input type="text" class="form-control" id="name" name="name"/>
               </div>
            </div><!-- row -->
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-6">
                  <span style="color: #999;">대표 이미지</span>
                  <input type="file" class="form-control" id="birthday" name="birthday"/>
               </div>
            </div>
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-6">
                  <span style="color: #999;">추가 이미지</span>
                  <input type="file" class="form-control" id="birthday" name="birthday"/>
               </div>
            </div><!-- row -->
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
                  <span style="color: #999;">진료시간(운영시간)</span>
                  <select class="form-control">
                  <option selected="selected">평일</option>
                  <option>월~금(주 5)</option>
                  <option>월~목(주 4)</option>
                  <option>월,수,금(주 3)</option>
                  </select>
               </div>
               
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
               		<input type="time" class="form-control" style="margin-top: 20px;">
               </div>
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
               		<input type="time" class="form-control" style="margin-top: 20px;">
               </div>
               
               <div class="col-sm-2" style="margin-left: 12%;">
               <span style="color: #999;">일요일/공휴일</span>
               		<input type="text" class="form-control" style="width: 130%;">
               </div>
            </div><!-- row -->
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
                  <span style="color: #999;">점심시간</span>
                  <input type="time" class="form-control">
               </div>
               
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
               		<input type="time" class="form-control" style="margin-top: 20px;">
               </div>
               	
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
               <span style="color: #999;">토요일</span>
               		<input type="time" class="form-control">
               </div>
               
               <div class="col-sm-3" style="padding-right: 0px; width: 18%;">
               		<input type="time" class="form-control" style="margin-top: 20px;">
               </div>
            </div><!-- row -->
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-6">
                  <span style="color: #999;">특이사항</span>
                  <input type="test" class="form-control" id="birthday" name="birthday"/>
               </div>
            </div>
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-6">
                  <span style="color: #999;">진료/처방 가능 동물군 (다중 선택 가능)</span><br/>
                  <div style="margin-top: 10px;">
	                  <button type="button" class="btn1">강아지</button>
	                  <button type="button" class="btn1">고양이</button>
	                  <button type="button" class="btn1">소동물</button>
	                  <button type="button" class="btn1">기타</button>
                  </div>
               </div>
            </div>
            
            <div class="row" style="padding-top: 20px;">
               <div class="col-sm-3">
                  <span style="color: #999;">의료진 소개</span><br/>
                  <span style="color: #999;">(성함 및 직책병기)</span>
                  <input type="test" class="form-control" id="birthday" name="birthday" style="width: 100%"/>
               </div>
                <div style="margin-top: 45px;">
	                  <button type="button" class="btn1">강아지</button>
	                  <button type="button" class="btn1">고양이</button>
	                  <button type="button" class="btn1">소동물</button>
                </div>
            </div>
            <div class="row">
               <div class="col-sm-3" style="margin-top: 2%;">
                  <input type="test" class="form-control" id="birthday" name="birthday" style="width: 100%"/>
               </div >
                <div style="margin-top: 20px;">
	                  <button type="button" class="btn1">강아지</button>
	                  <button type="button" class="btn1">고양이</button>
	                  <button type="button" class="btn1">소동물</button>
                </div>
            </div>
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            <!-- <div class="row tagList1" style="margin-top: 3%;">
               <div class="col-sm-2">
                  <span style="color: #999;">시설상태</span>
               </div>
               <div class="col-sm-10">
                  <input type="checkbox" class="" id="tag1" name="tag" value="깨끗함"/> <label style="color: #999;" for="tag1">#깨끗함</label>
                  <input type="checkbox" class="" id="tag2" name="tag" value="세련됨"/> <label style="color: #999;" for="tag2">#세련됨</label>
                  <input type="checkbox" class="" id="tag3" name="tag" value="동물친화적"/> <label style="color: #999;" for="tag3">#동물친화적</label>
                  <input type="checkbox" class="" id="tag4" name="tag" value="대형병원"/> <label style="color: #999;" for="tag4">#대형병원</label>
                  <input type="checkbox" class="" id="tag5" name="tag" value="종합병원"/> <label style="color: #999;" for="tag5">#종합병원</label>
                  <input type="checkbox" class="" id="tag6" name="tag" value="편안한"/> <label style="color: #999;" for="tag6">#편안한</label>
               </div>
            </div>row
            
            <div class="row tagList2" style="margin-top: 3%;">
               <div class="col-sm-2">
                  <span style="color: #999;">서비스</span>
               </div>
               <div class="col-sm-10">
                  <input type="checkbox" class="" id="tag7" name="tag" value="친절한"/> <label style="color: #999;" for="tag7">#친절한</label>
                  <input type="checkbox" class="" id="tag8" name="tag" value="친절한"/> <label style="color: #999;" for="tag8">#세심한</label>
                  <input type="checkbox" class="" id="tag9" name="tag" value="친절한"/> <label style="color: #999;" for="tag9">#잘봐주는</label>
               </div>
            </div>row --><!-- 이 외의 것은 DB 연결후에 하기!!! -->
            
            <div class="row" align="center" style="margin-top: 3%;">
               <input type="checkbox" class="" id="agree" name="agree"/> <label style="color: #999;" for="agree">서비스 이용 및 약관에 동의합니다.</label>
            </div>
         </div>
         
            <hr style="height: 1px; background-color: white; border: none; margin-bottom: 0px;">
            <div class="row">
	            <div class="col-sm-6">
	            <button type="button" class="cancelbtn" style="width: 100%; height: 60px;">CANCEL</button>
	            </div>
	            <div class="col-sm-6">
	            <button type="button" class="submitbtn" style="width: 100%; height: 60px;">SUBMIT</button>
	            </div>
            </div>
         </div>
      </form>
   </div>
</div>