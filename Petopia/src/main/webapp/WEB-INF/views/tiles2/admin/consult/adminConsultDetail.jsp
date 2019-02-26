<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	input, textarea {border: solid gray 1px;}
	
	
	.long {width: 470px;}
	.short {width: 120px;} 
		
	.moveStyle  {text-decoration: underline;
				 color: #fc766b;
   	             cursor: pointer;
				}
	
	.content {
	   padding-top: 15px;
	   padding-bottom: 15px;
	   background-color: #ffffff;
	   /* background-color: rgba(86, 61, 124, .15); */
	   border: 0px solid #999;
	   /* border: 1px solid rgba(86, 61, 124, .2); */
	   margin: 0%;
	   padding: 0.5%;
	   text-align:left;
	}
	
    #hide0 {display:none;}
     #hide1 {display:none;}
      #hide2 {display:none;}
       #hide3 {display:none;}
        #hide4 {display:none;}
	
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
	    
		$(".move").bind("mouseover", function(event){
			 var $target = $(event.target);
			 $target.addClass("moveStyle");
		});
		  
		$(".move").bind("mouseout", function(event){
			 var $target = $(event.target);
			 $target.removeClass("moveStyle");
		});	
		
		if(${consultvo.commentCount > 0}) {
			goViewComment(${totalPage});
		}
	
	}); // end of ready()-------------------------------------------
	
	
	// ===== 댓글보여주기 [Ajax로 페이징처리]  ======
	function goViewComment(currentShowPageNo) {
		
		
		var form_data = {"consult_UID":"${consultvo.consult_UID}", "currentShowPageNo":currentShowPageNo};
			
		$.ajax({
    		url:"<%=request.getContextPath()%>/consultCommentList.pet",
    		type:"GET",
    		data:form_data,
    		dataType:"JSON",
    		success:function(json){

    			var resultHTML = "";
    			var idxArr = [];
    			
    		    $.each(json, function(entryIndex, entry){
    		    	
    		    	// 대댓글이 없을때 보여주기
			    	if(entry.CSCMT_DEPTH==0) {
			    		resultHTML += "<div class='col-xs-12 col-md-12' style='background-color:#F8F8F8;'>"
			    			  +"	<div class='col-xs-12 col-md-12' style='margin-top:2%;'>"
			    			  +"		<span  style='font-weight:bold;'>"+entry.CSCMT_NICKNAME+"</span>"
			    			  +"		<span  style='color:#b2b3b2; margin-left:20px; font-size:90%;'>"+entry.CSCMT_WRITEDAY+"</span>"
			    			  +"	</div>"
			    			  +"	<div class='col-xs-12 col-md-12' style='padding-bottom:1%;' >"+entry.CSCMT_CONTENTS+"</div>"
			    			  +"	<div class='col-xs-11 col-md-11' ></div>"
			    			  /*
			    			  +"<div style='margin:0px;'>"
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;'>"
			    			  +"	<div class='col-xs-12 col-md-12' id='hide"+entryIndex+"' style='background-color:#EAEAEA;'>"
			    			  +"		<input type='hidden' name='fk_idx' value='${sessionScope.loginuser.idx}' />"
			    			  +"		<input type='hidden' name='consult_fk_idx' value='"+entry.FK_IDX+"' />"
			    			  +"		<input type='hidden' name='membertype' value='${sessionScope.loginuser.membertype}' />"
			    			  +"		<input type='hidden' name='cmt_id' value='"+entry.CMT_ID+"' />"
			    			  +"		<input type='hidden' name='cscmt_group' value='"+entry.CSCMT_GROUP+"' />"
			    			  +"		<input type='hidden' name='cscmt_g_odr' value='"+entry.CSCMT_G_ODR+"' />"
			    			  +"		<input type='hidden' name='cscmt_depth' value='"+entry.CSCMT_DEPTH+"' />"
			    			  +"		<span class='col-xs-12 col-md-12' style='margin-top:2%;'>"
			    			  +"			<span style='font-weight:bold; padding-left:20px;' >┗&nbsp;작성자</span>"
			    			  +"			<input type='text' name='cscmt_nickname' value='${sessionScope.loginuser.nickname}' style='margin-left:30px; color:#fc766b; border:0px solid #999; background-color:#EAEAEA;' readonly/>"
			    			  +"		</span>"
			    			  +"		<span class='col-xs-12 col-md-12' style='margin-right:2%; margin-bottom:3%; '>"
			    			  +"			<input type='text' name='cscmt_contents' class='long' style='text-align:left; margin:2% 0% 2% 2%; width:80%; border-radius:5px; border:1px solid #999; height:100px;'/>"
			    			  +"    		<input type='hidden' name='fk_consult_UID' value='"+entry.FK_CONSULT_UID+"' />"
			    			  +" 		</span>"
			    			  +"	</div>"
			    			  +"</div>"
			    			  */
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;' >"
			    			  +"</div>";
			    	}
    		    	
    		    	// 대댓글이 있을때 보여주기
			    	if(entry.CSCMT_DEPTH!=0) {
    		    		resultHTML += "<div class='col-xs-12 col-md-12' style='background-color:#EAEAEA; paddig:0% 2% 0% 2%;'>"
			    			  +"	<div class='col-xs-12 col-md-12' style='margin-top:1%; background-color:#EAEAEA;'>"
			    			  +"		<span  style='font-weight:bold; background-color:#EAEAEA; padding-left:"+entry.CSCMT_DEPTH*20+"px;'>┗&nbsp;"+entry.CSCMT_NICKNAME+"</span>"
			    			  +"		<span  style='color:#b2b3b2; margin-left:20px; font-size:90%; background-color:#EAEAEA;'>"+entry.CSCMT_WRITEDAY+"</span>"
			    			  +"	</div>"
			    			  +"	<div class='col-xs-12 col-md-12' style='margin-left:"+entry.CSCMT_DEPTH*20+"px; padding-bottom:1%; '>"+entry.CSCMT_CONTENTS+"</div>"
			    			  +"	<div class='col-xs-11 col-md-11' ></div>"
			    			  /*
			    			  +"<div style='margin:0px; background-color:#EAEAEA;'>"
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;'>"
			    			  +"	<div class='col-xs-12 col-md-12' id='hide"+entryIndex+"' style='background-color:#EAEAEA;'>"
			    			  +"		<input type='hidden' name='fk_idx' value='${sessionScope.loginuser.idx}' />"
			    			  +"		<input type='hidden' name='consult_fk_idx' value='"+entry.FK_IDX+"' />"
			    			  +"		<input type='hidden' name='membertype' value='${sessionScope.loginuser.membertype}' />"
			    			  +"		<input type='hidden' name='cmt_id' value='"+entry.CMT_ID+"' />"
			    			  +"		<input type='hidden' name='cscmt_group' value='"+entry.CSCMT_GROUP+"' />"
			    			  +"		<input type='hidden' name='cscmt_g_odr' value='"+entry.CSCMT_G_ODR+"' />"
			    			  +"		<input type='hidden' name='cscmt_depth' value='"+entry.CSCMT_DEPTH+"' />"
			    			  +"		<span class='col-xs-12 col-md-12' style='margin-top:2%;'>"
			    			  +"			<span style='font-weight:bold; padding-left:"+entry.CSCMT_DEPTH*30+"px;' >┗&nbsp;작성자</span>"
			    			  +"			<input type='text' name='cscmt_nickname' value='${sessionScope.loginuser.nickname}' style='margin-left:30px; color:#fc766b; border:0px solid #999; background-color:#EAEAEA;' readonly/>"
			    			  +"		</span>"
			    			  +"		<span class='col-xs-12 col-md-12' style='margin-right:2%; margin-bottom:3%; padding-left:"+entry.CSCMT_DEPTH*30+"px; '>"
			    			  +"			<input type='text' name='cscmt_contents' class='long' style='text-align:left; margin:2% 0% 2% 2%; width:80%; border-radius:5px; border:1px solid #999; height:100px;'/>"
			    			  +"    		<input type='hidden' name='fk_consult_UID' value='"+entry.FK_CONSULT_UID+"' />"
			    			  +" 		</span>"
			    			  +"	</div>"
			    			  +"</div>"
			    			  */
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;' >"
			    			  +"</div>";
			    	}
    		    	
    		    	$("#commentView").html(resultHTML);
    		    });
    		    
    		    // >>>>>>>>>>>>>>>> 페이지바 함수 호출 (현재페이지 넘겨주기)
    		    makeCommentPageBar(currentShowPageNo); 
    		},
    		error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	});
	}
	
	
	// ===== 댓글 페이지바 [Ajax로 페이징처리] ======
	function makeCommentPageBar(currentShowPageNo) {
		
		var form_data = {"consult_UID":"${consultvo.consult_UID}","sizePerPage":"10"};
		
		$.ajax({
    		url:"<%=request.getContextPath()%>/commentTotalPage.pet", 
    		type:"GET",
    		data:form_data,
    		dataType:"JSON",
    		success:function(json){
    		    
    		    if(json.TOTALPAGE > 0) {
    		    	
    		    	var totalPage = json.TOTALPAGE;
    		    	var pageBarHTML = ""; 
    		    	
    		    	// ---------------------------------------------------------------------------------
    		    	
    		    	var blockSize = 5; // blockSize는 페이지바에서 1개 블럭(토막)당 보여지는 페이지번호의 갯수이다. 
    		    	var loop = 1; // loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 갯수이다.
    		    	var pageNo = Math.floor((currentShowPageNo-1)/blockSize) * blockSize + 1; 
    		    	
    		    	// >>>>> '이전'
					if(pageNo!=1) { // loop>blockSize 이렇게 빠져나온경우, pageNo는 11인 상태로 옴
    		    		pageBarHTML += "&nbsp;<a href='javascript:goViewComment(\""+(pageNo-1)+"\");'>[이전]</a>&nbsp;";
    		    	}
    		    	
					// ---------------------------------------------------------------------------------
					
    		    	// 현재페이지
    		    	while(!(loop>blockSize || pageNo>totalPage)) { 
    		  	
    		    		if(pageNo==currentShowPageNo) {
    		    			pageBarHTML += "&nbsp;<span style='color:#fc766b; font-size:10pt; text-decoration:underline;'>"+pageNo+"</span>&nbsp;";
    		    		}
    		    		else {
    		    			pageBarHTML += "&nbsp;<a href='javascript:goViewComment(\""+pageNo+"\");'>"+pageNo+"</a>&nbsp;";
    		    		}
    		    		
    		    		loop++;
    		    		pageNo++;
    		    	}
    		    	
    		    	// ---------------------------------------------------------------------------------
    		    	
    		    	// >>>>> '다음'
    		    	if(!(pageNo>totalPage)) {
    		    		pageBarHTML += "&nbsp;<a href='javascript:goViewComment(\""+pageNo+"\");'>[다음]</a>&nbsp;";
    		    	}
    		    	
    		    	// ---------------------------------------------------------------------------------
    		    	
    		    	$("#pageBar").empty().html(pageBarHTML);
    		    	pageBarHTML = "";
    		    }
    		 	// 댓글이 없는 경우
    		    else {
    		    	$("#pageBar").empty();	
    		    }
    		    
    		},
    		error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	});

	} 
	
</script>


<div style="padding-top:8%; margin-bottom: 0.2%;" class="container"> 
	<h3 style="border:0.5px solid #fc766b; border-radius:3px; padding:1%;">&nbsp;&nbsp;&nbsp;1:1상담 상세보기</h3>
	
	<%--<hr align="left" width="100%" style="border:1px solid #999;"> --%>
	<div align="center">
		
		<div class="col-xs-12 col-md-12" style="padding:1.5% 0% 1.5% 3%; text-align: center;">
			<img src="<%=request.getContextPath() %>/resources/img/consultIcon/cat.jpg" class="col-xs-1 col-md-1" style="border-radius:100%;border:0px solid #999;width:4%;height:5.5%;padding:0px;" />
			<span class="col-xs-9 col-md-9 content" style="padding-left:2%; padding-top:0.8%; font-size:100%;">${consultvo.nickname}님 ${consultvo.cs_writeday}</span>
			<c:if test="${consultvo.cs_secret==0}">
				<span class="col-xs-2 col-md-2 content" style="padding-top:0.8%; font-size:110%; color:#b2b3b2;text-align:right;">
				<img src="<%=request.getContextPath() %>/resources/img/consultIcon/secret.png" style="width:20%; padding-right:0px;">
				비공개</span>
			</c:if>
				
			<c:if test="${consultvo.cs_secret==1}">
				<span class="col-xs-2 col-md-2 content" style="padding-top:0.8%; font-size:110%; color:#fc766b;text-align:right;">
				<img src="<%=request.getContextPath() %>/resources/img/consultIcon/open.png" style="width:20%; padding-right:0px;">
				공개</span>
			</c:if>
		</div>
		
		<hr align="center" width="94%" style="border:0.5px solid #b2b3b2;">
		
		<div class="col-xs-12 col-md-12">
			 
			<div class="col-xs-12 col-md-12 content">
				<div class="col-xs-1 col-md-1 content" >글제목</div>
				<div style="border: 0px solid #999; font-size:130%;" class="col-xs-9 col-md-9 content">${consultvo.cs_title}</div>
			</div>
			
			<div class="col-xs-12 col-md-12 content">
				<div class="col-xs-12 col-md-12 content" style="background-color: #F1F1F1; word-break:break-all; border: 0px solid #999; overflow-x:auto; height:auto; padding:20px; border-radius:5px; " >${consultvo.cs_contents}</div>
			</div>
			
			
			<c:if test="${consultvo.previous != null}">
			<div class="col-xs-10 col-md-10">
				<div class="col-xs-1 col-md-1 content">이전글</div>
				<div class="col-xs-11 col-md-11 content" >
				<span class="move" onClick="javascript:location.href='adminConsultDetail.pet?consult_UID=${consultvo.previous}'">▲ ${consultvo.previousTitle}</span></div>
			</div>
			</c:if>
			
			<c:if test="${consultvo.previous == null}">
			<div class="col-xs-10 col-md-10">
				<div class="col-xs-1 col-md-1 content">이전글</div>
				<div class="col-xs-11 col-md-11 content" >
				<span style="color:#b2b3b2;">▲ 이전글이 없습니다.</span></div>
			</div>
			</c:if>
			
			<c:if test="${consultvo.next != null}">
			<div class="col-xs-10 col-md-10" style="margin-bottom:3%;">
				<div class="col-xs-1 col-md-1 content">다음글 </div>
				<div class="col-xs-11 col-md-11 content">
				<span class="move" onClick="javascript:location.href='adminConsultDetail.pet?consult_UID=${consultvo.next}'">▼ ${consultvo.nextTitle}</span></div>
			</div>
			</c:if>
			
			<c:if test="${consultvo.next == null}">
			<div class="col-xs-10 col-md-10" style="margin-bottom:3%;">
				<div class="col-xs-1 col-md-1 content">다음글 </div>
				<div class="col-xs-11 col-md-11 content">
				<span style="color:#b2b3b2;">▼ 다음글이 없습니다.</span></div>
			</div>
			</c:if>
			
			<div class="col-xs-2 col-md-2" >
				<button type="button" onClick="javascript:location.href='<%=request.getContextPath()%>/${gobackURL}'" style="border:0px;" >목록보기</button>
			</div>
		</div>	
		
	</div> 
	
	<%-- <hr align="left" width="100%" style="border:0.5px solid #999;"> --%>
	
	<div id="commentView" style="margin-top:5%; "></div>
	
	<div class="col-xs-12 col-md-12 " style="background-color:#F8F8F8; margin-bottom:5%;">
		<div id="pageBar" style="height:50px; margin-top: 20px;"  align="center"></div>
	
		<br/>
	
	</div>
	
</div> <!-- 전체 -->