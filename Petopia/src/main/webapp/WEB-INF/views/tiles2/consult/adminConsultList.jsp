<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<style> 


</style>
<script type="text/javascript">

	$(document).ready(function(){
		
	 
	  
	}); // $(document).ready(function(){});
	
	
</script>

<script type="text/javascript">

</script>

<div class="container">
  <h2>수의사 1:1 상담관리</h2>
  <p>상담내역을 확인할 수 있습니다.</p>  

  <br>
  
  <div class="row">
	 <div class="col-xs-12 col-md-4" style="background-color: #ffffff;">
		<form name="myConsultFrm" >
		<input type="checkbox" style="margin-right:2%;" /> 전체선택
		<button type="button" class="btn btnmenu btn-rounder"  style="border: 1px solid #fc766b; margin-left:5%; border-radius:50px; width:40%; height:4%; font-size:12px;" onClick="goMyConsult();">
		답변요청 알림보내기
		</button>
		</form>
	 </div>
			
	  <div class="col-xs-12 col-md-8" style="background-color: #ffffff;">
		<form name="searchFrm" >
		<select name="colname" id="colname" class="content" style="background-color:#ffffff; border: 1px solid #999; height:4%; width:23%; margin-left:35%;">
			<option value="cs_title">제목</option>
			<option value="nickname">작성자</option>
			<option value="cs_contents">글내용</option>
		</select>
		
		<input type="text" name="search" id="search" size="30" style="border: 1px solid #999; border-radius: 25px;" />
		<button type="button" class="btn btnmenu btn-rounder"  style="border: 1px solid #fc766b; border-radius:50px; width:10%; height:4%; padding-right:10px; font-size:12px;" onClick="goSearch();">
			<img src="<%=request.getContextPath() %>/resources/img/consultIcon/search-01-01.png" style="width:38%; padding-right:1px;">검색
		</button>
		</form>
	 </div>
 </div>
 
    
    <div class="row" style="border-top: 1px solid #999; border-bottom: 1px solid #999; padding:1% 0% 1% 0%;">
	    <div class="col-xs-1 col-md-1"><input type="checkbox"></div>
	    <div class="col-xs-2 col-md-2">1:1상담제목</div>
	    <div class="col-xs-3 col-md-3">내용</div>
	    <div class="col-xs-2 col-md-2">작성자ID</div>
	    <div class="col-xs-2 col-md-2">작성일자</div>
	    <div class="col-xs-1 col-md-1">답변여부</div>
	    <div class="col-xs-1 col-md-1">공개여부</div>
    </div>
  
 
    <div>
		<div></div>
		<div></div>
		<div></div>
		<div></div>
		<div></div>
		<div></div>
		<div></div>
    </div>
   

  
  <div class="text-center">${pageBar}</div>
  <p>Note that we start the search in tbody, to prevent filtering the table headers.</p>
  
</div>


