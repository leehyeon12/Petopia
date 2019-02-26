<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    
<style> 
	.subjectstyle { color: #fc766b;
    	            cursor: pointer; }

</style>
<script type="text/javascript">

	$(document).ready(function(){
		
		$(".subject").bind("mouseover", function(event){
			 var $target = $(event.target);
			 $target.addClass("subjectstyle");
		});
		  
		$(".subject").bind("mouseout", function(event){
			 var $target = $(event.target);
			 $target.removeClass("subjectstyle");
		});
		
		/* 뷰단에서 검색시 검색어 그대로 있도록 */
		searchKeep();
		
		// 전체선택
		$('.checkAll').click(function(){
	          $('.checkSelectAll').prop('checked',this.checked);
	    });
	  
		// 미답변선택
		$('.checkNoCount').click(function(){
	          $('.checkSelectNoCount').prop('checked',this.checked);
	    });
		
		
	}); // $(document).ready(function(){});
	
	// 뷰단에서 검색시 검색어 그대로 있도록
	function searchKeep(){
		if(${search!=null && search!="" && search!="null"}) {
			$("#colname").val("${colname}");
			$("#search").val("${search}");
		}
	}
	
	// 글목록에서 제목, 작성자, 글내용으로 검색 
	function goSearch() {
		var frm = document.AdminSearchFrm;
		frm.action = "<%=request.getContextPath()%>/adminConsultList.pet";
		frm.method = "GET";
		frm.submit();
	}
	
	// 글제목 클릭시 글 상세보기
	function goDetail(consult_UID, goBackURL) {
		var frm = document.goDetailFrm;
		frm.consult_UID.value = consult_UID;
		frm.gobackURL.value = goBackURL;
		frm.action = "adminConsultDetail.pet";
		frm.method = "GET";
		frm.submit();
	}
	
	// 체크된 값들이 1개 이상일 경우 기업회원한테 알림메세지 보내기
	function goNotification() {
		var selectAll =  $("input:checkbox[name=checkSelectAll]:checked").length;
		var selectNoCount = $("input:checkbox[name=checkSelectNoCount]:checked").length;
		
		if(selectAll+selectNoCount==0) {
			alert("답변요청을 보내기 위한 상담글을 1개이상 선택하셔야합니다.");
			return;
		}
		
		var frm = document.notificationFrm;
		frm.selected.value = selectAll+selectNoCount;
		frm.action = "consultNotification.pet";
		frm.method = "GET";
		frm.submit();
	}
	
	/*
	
	$("input:checkbox[name=]").length; // 체크박스 전체 갯수
	$("input:checkbox[name=checkSelectNoCount]:checked").length; // 선택된 갯수
	
	alert( $("input:checkbox[name=checkSelectNoCount]:checked").length );
	alert( $("input:checkbox[name=checkSelectAll]:checked").length );
	
	$("input:checkbox[name=]:checked").each(function(){
		this.checked = true;
	}); 
	
	
	
	var flag = false;
	
	$(".checkbox").each(function(){
		if($(this).is(':checked') == true) {
			flag = true;
			return false;
		}
	}); 

	if(flag == false) {
		alert("1개 이상 선택");
		return;
	}
	*/
	
</script>


<div class="container">
  <h2>수의사 1:1 상담관리</h2>
  <p>상담내역을 확인할 수 있습니다.</p>  

  <br>
  
  <div class="row">
	 <div class="col-xs-12 col-md-3" style="background-color: #ffffff;">
		<form name="notificationFrm" >
		<input type="hidden" name="selected">
		<input  type="checkbox" class="checkNoCount" id="noCount"><label for="noCount">&nbsp;미답변 선택&nbsp;&nbsp;</label>
		<%-- 
		<button type="button" class="btn btnmenu btn-rounder"  style="border: 1px solid #fc766b; border-radius:50px; width:40%; height:4%; font-size:12px;" onClick="goNotification();">
		답변요청 알림보내기
		</button>
		--%>
		<a style="cursor: pointer; padding:1% 5% 1% 5%;" class="btn btnmenu btn-rounder" data-toggle="modal" data-target="#notification" data-dismiss="modal" >답변요청 알림보내기</a>
		</form>
	 </div>
			
	  <div class="col-xs-12 col-md-9" style="background-color: #ffffff;">
		<form name="AdminSearchFrm" >
		<select name="colname" id="colname" style="background-color:#ffffff; border: 1px solid #999; height:4%; width:15%; margin-left:35%;">
			<option value="cs_title">제목</option>
			<option value="userid">작성자ID</option>
			<option value="cs_contents">글내용</option>
		</select>
		
		<input type="text" name="search" id="search" size="30" style="border: 1px solid #999; border-radius: 25px;" />
		<button type="button" class="btn btnmenu btn-rounder"  style="border: 1px solid #fc766b; border-radius:50px; width:10%; height:4%; padding-right:10px; font-size:12px;" onClick="goSearch();">
			<img src="<%=request.getContextPath() %>/resources/img/consultIcon/search-01-01.png" style="width:38%; padding-right:1px;">검색
		</button>
		</form>
	 </div>
 </div>
 
    
    <div class="col-xs-12 col-md-12 row" style=" background-color:#f2f2f2; border-top: 1px solid #999; border-bottom: 1px solid #999; padding:1% 0% 1% 0%;">
	    <div class="col-xs-2 col-md-2" ><input type="checkbox" class="checkAll" id="all"/><label for="all">&nbsp;전체선택</label></div>
	    <div class="col-xs-3 col-md-3" align="left">1:1상담제목</div>
	    <div class="col-xs-3 col-md-3" align="center">작성자ID</div>
	    <div class="col-xs-2 col-md-2" align="center">작성일자</div>
	    <div class="col-xs-1 col-md-1" align="center">답변여부</div>
	    <div class="col-xs-1 col-md-1" align="center">공개여부</div>
    </div>
  
 	<c:forEach var="adminConsultvo" items="${AdminConsultList}">
	    <div class="col-xs-12 col-md-12 row" style="padding:1% 0% 1% 0%;; border-bottom: 1px solid #999;" >
	    	<div class="col-xs-2 col-md-2" >
		    	<c:if test="${adminConsultvo.commentCount > 0 }">
		    		<input type="checkbox" class="checkSelectAll" name="checkSelectAll" id="check${adminConsultvo.consult_UID}"/><label for="check${adminConsultvo.consult_UID}">&nbsp;${adminConsultvo.consult_UID}</label>
		    	</c:if>
		    	<c:if test="${adminConsultvo.commentCount == 0 }">
		    		<input type="checkbox" class="checkSelectAll checkSelectNoCount" name="checkSelectNoCount" id="check${adminConsultvo.consult_UID}"/><label for="check${adminConsultvo.consult_UID}">&nbsp;${adminConsultvo.consult_UID}</label>
		    	</c:if>
	    	</div>
	    	
			<div class="col-xs-3 col-md-3 subject" align="left" onClick="goDetail('${adminConsultvo.consult_UID}', '${goBackURL}');">${adminConsultvo.cs_title}</div>
			<div class="col-xs-3 col-md-3" align="center" >${adminConsultvo.userid}</div>
			<div class="col-xs-2 col-md-2" align="center" >${adminConsultvo.cs_writeday}</div>
			<c:if test="${adminConsultvo.commentCount > 0 }">
				<div class="col-xs-1 col-md-1" align="center" >O</div>
			</c:if>
			<c:if test="${adminConsultvo.commentCount == 0 }">
				<div class="col-xs-1 col-md-1" align="center" >X</div>
			</c:if>
			<c:if test="${adminConsultvo.cs_secret == '1'}">
				<div class="col-xs-1 col-md-1" align="center" >공개</div>
			</c:if>
			<c:if test="${adminConsultvo.cs_secret == '0'}">
				<div class="col-xs-1 col-md-1" align="center" >비공개</div>
			</c:if>
	    </div>
	</c:forEach>
  
  <div class="col-xs-12 col-md-12" align="center" style="padding:3% 0% 3% 0%">${pagebar}</div>
  <br/>
 
 <form name="goDetailFrm" >
	<input type="hidden" name="consult_UID" />
	<input type="hidden" name="gobackURL" />
</form>

</div>





<%-- 알림 모달 --%>
<div class="modal fade" id="notification" role="dialog" style="z-index: 100000; margin-top:5%;">
  <div class="modal-dialog">
  
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close myclose" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">답변요청 알림보내기</h4>
      </div>
      
      <div class="modal-body">
        <div id="consultNotification" align="center" style="margin-bottom:10%;">
        	<div style="margin:5% 0% 5% 0%; font-size:16px;">선택한 1:1 상담에 대하여<br/>수의사 답변 요청 알림을 보내시겠습니까?</div>
        	<button type="button" class="btn btnmenu btn-default myclose" style="width:18%;" data-dismiss="modal">cancel</button>
        	<button type="button" class="btn btnmenu btn-default" style="width:18%;" data-dismiss="modal" onClick="goNotification();">OK</button>
        	<%--<iframe style="border: none; width: 90%; height: 200px;" src="<%= request.getContextPath() %>/consultNotification.pet"></iframe> --%>
        </div>
      </div>
    </div>
    
  </div>
</div>

