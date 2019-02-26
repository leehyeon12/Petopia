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
	
	
	
	// ===== 댓글쓰기 ======
	function goCommentAdd() {
	
		var frm = document.commentAddFrm;
		
		var membertypeval = frm.membertype.value.trim();
		var fk_idxval = frm.fk_idx.value.trim();
		var consult_fk_idxval = frm.consult_fk_idx.value.trim();
		var cscmt_contentsval = frm.cscmt_contents.value.trim();
		
		if( !(membertypeval==2 || (membertypeval==1 && fk_idxval==consult_fk_idxval)) ) {
			alert("다른회원의 글에 댓글을 작성할 수 없습니다.");
			return;
		}
		else if(cscmt_contentsval=="") {
			alert("내용을 입력하세요.");
			frm.cscmt_contents.value = "";
			frm.cscmt_contents.focus();
			return;
		}
		
		var queryString = $("form[name=commentAddFrm]").serialize(); // form의 name이 addWriteFrm인것
		
		console.log(queryString); // form의 name이 addWriteFrm인것의 name값들
		// fk_idx=7&cscmt_nickname=test&cscmt_contents=sodyd&fk_consult_UID=10
		
		$.ajax({
    		url:"<%=request.getContextPath()%>/consultCommentAdd.pet",
    		type:"POST",
    		data:queryString,
    		dataType:"JSON",
    		success:function(json){
    				
    			var html = "<div class='col-xs-12 col-md-12' style='background-color:#F8F8F8;'>"
		    			  +"	<div class='col-xs-12 col-md-12' style='margin-top:2%;'>"
		    			  +"		<span  style='font-weight:bold;'>"+json.CSCMT_NICKNAME+"</span>"
		    			  +"		<span  style='color:#b2b3b2; margin-left:20px; font-size:90%;'>"+json.CSCMT_WRITEDAY+"</span>"
		    			  +"	</div>"
		    			  +"	<div class='col-xs-12 col-md-12' style='margin-bottom:2%;'>"+json.CSCMT_CONTENTS+"</div>"
		    			  +"	<div class='col-xs-11 col-md-11' ></div>"
		    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;'>"
		    			  +"</div>";

    			// 댓글쓰기 할때 위로 쌓이니까 prepend
    			$("#commentView").append(html);
    			frm.cscmt_contents.value = "";
    			if(${consultvo.commentCount > 0}) {
    				goViewComment(${totalPage});
    			}
    			else {
    				goViewComment("1");
    				location.reload();
    			}
    			
    		},
    		error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	});
		
	}

	
	
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
			    			  +"	<div class='col-xs-12 col-md-12' >"+entry.CSCMT_CONTENTS+"</div>"
			    			  +"	<div class='col-xs-11 col-md-11' ></div>"
			    			  +"	<button type='button' class='col-xs-1 col-md-1' id='commentAddBtn"+entryIndex+"' style='margin-bottom:0.5%; border: 1px solid #999; width:7%;' onClick='commentClick();'>답글</button>"
			    			  
			    			  +"<div style='margin:0px;'>"
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;'>"
			    			  +"	<div class='col-xs-12 col-md-12' id='hide"+entryIndex+"' style='background-color:#EAEAEA;'>"
			    			  +"		<input type='hidden' name='fk_idx' value='${sessionScope.loginuser.idx}' />"
			    			  +"		<input type='hidden' name='org_fk_idx' value='"+entry.FK_IDX+"' />"
			    			  +"		<input type='hidden' name='consult_fk_idx' value='"+entry.CONSULT_FK_IDX+"' />"
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
			    			  +"    		<button type='button' id='commentByComment' style='margin-left:1px; width:10%; border-radius:5px; border:1px solid #999; height:100px;' onClick='goCommentByCommentAdd(\"hide"+entryIndex+"\");' >작성</button> "
			    			  +" 		</span>"
			    			  +"	</div>"
			    			  +"</div>"
			    			  
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;' >"
			    			  +"</div>";
			    	}
    		    	
    		    	// 대댓글이 있을때 보여주기
			    	if(entry.CSCMT_DEPTH!=0) {
    		    		resultHTML += "<div class='col-xs-12 col-md-12' style='background-color:#F8F8F8;'>"
			    			  +"	<div class='col-xs-12 col-md-12' style='margin-top:2%; background-color:#EAEAEA;'>"
			    			  +"		<span  style='font-weight:bold; background-color:#EAEAEA; padding-left:"+entry.CSCMT_DEPTH*20+"px;'>┗&nbsp;"+entry.CSCMT_NICKNAME+"</span>"
			    			  +"		<span  style='color:#b2b3b2; margin-left:20px; font-size:90%; background-color:#EAEAEA;'>"+entry.CSCMT_WRITEDAY+"</span>"
			    			  +"	</div>"
			    			  +"	<div class='col-xs-12 col-md-12' style='margin-left:"+entry.CSCMT_DEPTH*20+"px;'>"+entry.CSCMT_CONTENTS+"</div>"
			    			  +"	<div class='col-xs-11 col-md-11' ></div>"
			    			  +"	<button type='button' class='col-xs-1 col-md-1' id='commentAddBtn"+entryIndex+"' style='margin-bottom:0.5%; border: 1px solid #999; width:7%; ' onClick='commentClick();'>답글</button>"
			    			  
			    			  +"<div style='margin:0px; background-color:#EAEAEA;'>"
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;'>"
			    			  +"	<div class='col-xs-12 col-md-12' id='hide"+entryIndex+"' style='background-color:#EAEAEA;'>"
			    			  +"		<input type='hidden' name='fk_idx' value='${sessionScope.loginuser.idx}' />"
			    			  +"		<input type='hidden' name='org_fk_idx' value='"+entry.FK_IDX+"' />"
			    			  +"		<input type='hidden' name='consult_fk_idx' value='"+entry.CONSULT_FK_IDX+"' />"
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
			    			  +"    		<button type='button' id='commentByComment' style='margin-left:1px; width:10%; border-radius:5px; border:1px solid #999; height:100px;' onClick='goCommentByCommentAdd(\"hide"+entryIndex+"\");' >작성</button> "
			    			  +" 		</span>"
			    			  +"	</div>"
			    			  +"</div>"
			    			  
			    			  +"	<hr align='center' width='100%' style='border:0.5px dotted #999; margin:0px;' >"
			    			  +"</div>";
			    	}
    		    	
    		    	$("#commentView").html(resultHTML);
    		    });
    		    
    		    // >>>>>>>>>>>>>>>> 페이지바 함수 호출 (현재페이지 넘겨주기)
    		    makeCommentPageBar(currentShowPageNo); 
    		    
    		    for(var i=0; i<10; i++) {
    				$("#hide"+i).slideUp();
    			}
    		    
    		},
    		error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	});
	}
	
	// 답글 폼
	function commentClick() {
		
		switch(event.target.id) {
		case 'commentAddBtn0':
			$("#hide0").slideToggle();
			break;
		case 'commentAddBtn1':
			$("#hide1").slideToggle();
			break;
		case 'commentAddBtn2':
			$("#hide2").slideToggle();
			break;
		case 'commentAddBtn3':
			$("#hide3").slideToggle();
			break;
		case 'commentAddBtn4':
			$("#hide4").slideToggle();
			break;
		case 'commentAddBtn5':
			$("#hide5").slideToggle();
			break;
		case 'commentAddBtn6':
			$("#hide6").slideToggle();
			break;
		case 'commentAddBtn7':
			$("#hide7").slideToggle();
			break;
		case 'commentAddBtn8':
			$("#hide8").slideToggle();
			break;
		default:
			$("#hide9").slideToggle();
			break;
		}
	}
	
	
	
    
	// 대댓글쓰기
	function goCommentByCommentAdd(id) {
	
		//var queryString = $("#"+id).next().find(document.commentByCommentAddFrm).serialize(); // form의 name이 addWriteFrm인것
		//console.log(queryString);
        
		var consult_fk_idxval = $("#"+id).find("input[name=consult_fk_idx]").val(); // 상담글의 idx
		var org_fk_idxval = $("#"+id).find("input[name=org_fk_idx]").val(); // 원댓글(로그인한 사람이 댓글을 달고있는 윗댓글)의 idx
		var membertypeval = $("#"+id).find("input[name=membertype]").val();
		
		var cmt_idval = $("#"+id).find("input[name=cmt_id]").val();
		var fk_idxval = $("#"+id).find("input[name=fk_idx]").val();	// 로그인한 자기자신 (댓글을 작성하는 idx)
		var cscmt_groupval = $("#"+id).find("input[name=cscmt_group]").val();
		var cscmt_g_odrval = $("#"+id).find("input[name=cscmt_g_odr]").val();
		var cscmt_depthval = $("#"+id).find("input[name=cscmt_depth]").val();
		var cscmt_nicknameval = $("#"+id).find("input[name=cscmt_nickname]").val();
		var cscmt_contentsval = $("#"+id).find("input[name=cscmt_contents]").val();
		var fk_consult_UIDval = $("#"+id).find("input[name=fk_consult_UID]").val();
		
		console.log("consult_fk_idxval 상담글 "+consult_fk_idxval);
		console.log("org_fk_idxval 원댓글 "+org_fk_idxval);
		console.log("fk_idxval 댓글 "+fk_idxval);

		// !(기업회원이거나 일반회원이지만 로그인한 사람과 상담글을 작성한 사람이 같으면 댓글쓰기 가능)
		if( !(membertypeval==2 || (membertypeval==1 && fk_idxval==consult_fk_idxval)) ) {
			alert("다른회원의 글에 댓글을 작성할 수 없습니다.");
			return;
		}
		else if(cscmt_contentsval=="") {
			alert("내용을 입력하세요.");
			frm.cscmt_contents.value = "";
			frm.cscmt_contents.focus();
			return;
		}
		
		var form_data = { "fk_cmt_id":cmt_idval
						, "fk_idx":fk_idxval
						, "org_fk_idx":org_fk_idxval
						, "consult_fk_idx":consult_fk_idxval
						, "cscmt_group":cscmt_groupval
						, "cscmt_g_odr":cscmt_g_odrval
						, "cscmt_depth":cscmt_depthval
						, "cscmt_nickname":cscmt_nicknameval
						, "cscmt_contents":cscmt_contentsval
						, "fk_consult_UID":fk_consult_UIDval
						};
		
		$.ajax({
    		url:"<%=request.getContextPath()%>/consultCommentByCommentAdd.pet",
    		type:"POST",
    		data:form_data,
    		dataType:"json",
    		success:function(json){
    			
    			goViewComment(${totalPage});
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
			<img src="<%=request.getContextPath() %>/resources/img/member/profiles/${consultvo.fileName}" class="col-xs-1 col-md-1" style="border-radius:100%;border:0px solid #999;width:4%;height:5.5%;padding:0px;" />
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
				<div class="col-xs-2 col-md-2 content">
					<button type="button" onClick="javascript:location.href='<%=request.getContextPath()%>/consultEdit.pet?consult_UID=${consultvo.consult_UID}'" 
						style="background-color: #fc766b; border: 1px solid #fc766b; border-radius:50px; width:48%; height:4%; color:#ffffff; font-size:12px;">글수정</button>
					<button type="button" onClick="javascript:location.href='<%=request.getContextPath()%>/consultDelete.pet?consult_UID=${consultvo.consult_UID}'" 
						style="background-color: #fc766b; border: 1px solid #fc766b; border-radius:50px; width:48%; height:4%; color:#ffffff; font-size:12px;">글삭제</button>
				</div>
			</div>
			
			<div class="col-xs-12 col-md-12 content">
				<div class="col-xs-12 col-md-12 content" style="background-color: #F1F1F1; word-break:break-all; border: 0px solid #999; overflow-x:auto; height:auto; padding:20px; border-radius:5px; " >${consultvo.cs_contents}</div>
			</div>
			
			
			<c:if test="${consultvo.previous != null}">
			<div class="col-xs-10 col-md-10">
				<div class="col-xs-1 col-md-1 content">이전글</div>
				<div class="col-xs-11 col-md-11 content" >
				<span class="move" onClick="javascript:location.href='consultDetail.pet?consult_UID=${consultvo.previous}'">▲ ${consultvo.previousTitle}</span></div>
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
				<span class="move" onClick="javascript:location.href='consultDetail.pet?consult_UID=${consultvo.next}'">▼ ${consultvo.nextTitle}</span></div>
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
	
	<div id="commentView" style="margin-top:5%;"></div>
	
	<div class="col-xs-12 col-md-12 " style="background-color:#F8F8F8;">
		<div id="pageBar" style="height:50px; margin-top: 20px;"  align="center"></div>
	
		<br/>
		
		<!-- ===== 원댓글쓰기 폼 추가 ===== -->
		<form name="commentAddFrm" >
			<div class="col-xs-12 col-md-12 " style="background-color:#F8F8F8;">
			<input type="hidden" name="fk_idx" value="${sessionScope.loginuser.idx}"  readonly />
			<input type="hidden" name="consult_fk_idx" value="${consultvo.fk_idx}"  readonly />
			<input type="hidden" name="membertype" value="${sessionScope.loginuser.membertype}"  readonly />
			<span class="col-xs-12 col-md-12 " >
				<span style="font-weight:bold;">작성자</span>
				<!-- 작성자가 기업회원이라면 뒤에 수의사 붙이지 않기 -->
				<c:if test="${sessionScope.loginuser.membertype==1}">
					<input type="text" name="cscmt_nickname" value="${sessionScope.loginuser.nickname}" style="margin-left:30px; color:#fc766b; border:0px solid #999; background-color:#F8F8F8;" readonly/>
				</c:if>
				<!-- 작성자가 기업회원이라면 뒤에 수의사 붙이기 -->
				<c:if test="${sessionScope.loginuser.membertype==2}">
					<input type="text" name="cscmt_nickname" value="${sessionScope.loginuser.nickname}" style="margin-left:30px; color:#fc766b; border:0px solid #999; background-color:#F8F8F8;" readonly/>
				</c:if>
			</span>
			<span class="col-xs-12 col-md-12 " style="margin-right:2%; margin-bottom:3%; ">상담하기
				<input type="text" name="cscmt_contents" class="long" style="text-align:left; margin:2% 0% 2% 2%; width:70%; border-radius:5px; border:1px solid #999; height:100px;"/>
			    <!-- 댓글에 달리는 원게시물 글번호(즉, 댓글의 부모글 글번호) -->
			    <input type="hidden" name="fk_consult_UID" value="${consultvo.consult_UID}" />
			    <button type="button" style="margin-left:1px; width:10%; border-radius:5px; border:1px solid #999; height:100px;" onClick="goCommentAdd();" >작성</button> 
		    </span>
		    </div>
		</form>
	
	</div>
	
</div> <!-- 전체 -->


	
<br/>
	