<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- ==== 2019.02.04 ==== -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script type="text/javascript">
	
	$(document).ready(function(){
		showComments("1"); /* === 2019.02.06 === */
		
		/* === 2019.02.07 === 시작 */
		$(".contents").click(function(){
			if(${sessionScope.loginuser == null}) {
				var bool = confirm("댓글은 로그인 후에 작성할 수 있습니다. 로그인 하시겠습니까?");
				
				if(bool == true) {
					location.href = "<%=request.getContextPath()%>/login.pet";
					
					return;
				} else {
					$(':focus').blur();
					
					return;
				} // end of if~else
			} // end of if
		}); // end of $(".contents").click();
		/* === 2019.02.07 === 끝 */
		
	}); // end of $(document).ready()
	
	function goDel(review_UID) {
		var frm = document.delReviewFrm;
		frm.review_UID.value = review_UID;
		
		frm.action = "<%=request.getContextPath()%>/updateReviewStatus.pet";
		frm.method = "POST";
		frm.submit();
	} // end of function goDel(review_UID)
	
	// === 2019.02.05 ==== //
	// 댓글쓰기
	function addComments() {
		// === 2019.02.07 ==== 시작 //
		var contents = $("#rc_content").val();
		contents= contents.replace(/(?:\r\n|\r|\n)/g, '<br />');
		
		var data = {"review_uid":$("#review_uid").val(),
					"rc_content":contents,
					"fk_userid":$("#fk_userid").val()};
		// === 2019.02.07 ==== 끝 //
		
		$.ajax({
			url: "<%=request.getContextPath()%>/addComments.pet",
			type: "POST",
			data: data,
			dataType: "JSON",
			success: function(json){
				$("#rc_content").val("");
				
				showComments($("#totalPage").val());/* === 2019.02.07 === 수정 */
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
		
	} // end of function addComments()
	
	/* === 2019.02.06 === */
	// 댓글 리스트 보기
	function showComments(currentPageNo) {
		
		var data = {"currentPageNo":currentPageNo,
					"review_uid":$("#review_uid").val()};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectReviewCommentsList.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				var html = "";
				
				if(json.length > 0) {
					$.each(json, function(entryIndex,entry){
						if(entry.FK_RC_ID == "0") {
							var rc_userid = "'"+entry.RC_USERID+"'";
							html += '<div class="row" style="padding: 10px;">'
										+'<div class="col-sm-12">'
											+'<div class="row">'
												+'<img src="<%=request.getContextPath() %>/resources/img/member/profiles/'+entry.FILENAME+'" width="20px" height="20px" style="border-radius: 10px;">'
												+'&nbsp;<span style="font-weight: bold;">'+entry.RC_NICKNAME+'</span>'
											+'</div>'
											+'<div class="row" style="margin-top: 5px;">';
									if(entry.RC_STATUS == "0") {
										html += '블라인드 처리되거나 삭제 된 댓글 입니다.';
									} else {
										html += entry.RC_CONTENT;
									}
									html += '</div>'
											+'<div class="row" style="margin-top: 5px; color: gray;">'
												+'<span>'+entry.RC_WRITEDATE+'</span>'
											+'</div>'
									/* === 2019.02.07 === 시작 */
											+'<div class="row" style="margin-top: 5px;">';
								if(entry.RC_STATUS != "0") {
									if("${sessionScope.loginuser != null}") {
										if("${sessionScope.loginuser.idx}" == entry.FK_IDX) {
											html += '<button class="btn" onclick="goCommentsEditShow('+entry.RC_ID+', '+currentPageNo+')" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">수정</button>'
												  + '<button class="btn" onclick="goCommentsDel('+entry.RC_ID+', '+currentPageNo+')" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">삭제</button>';
										}
										html +='<button class="btn" onclick="goCommentsAddShow('+entry.RC_ID+', '+rc_userid+', '+entry.RC_GROUP+', '+entry.RC_G_ODR+', '+entry.RC_DEPTH+', '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">답글</button>';
									} 
								}// end of if

									html += '</div>'
											+'<div class="row" id="commentsShow'+entry.RC_ID+'" style="margin-top: 5px;">'
											+'</div>'
									/* === 2019.02.07 === 끝 */
										+'</div>'
									+'</div>';
						} else {
							var rc_userid = "'"+entry.RC_USERID+"'";
							html += '<div class="row" style="padding: 10px 10px 10px '+(30*Number(entry.RC_DEPTH))+'px; background-color: #f2f2f2; border-bottom: 2px solid white;">'
										+'<div class="col-sm-1" align="right">'
											+'<span class="glyphicon glyphicon-menu-right"></span>'
										+'</div>'
										+'<div class="col-sm-11">'
											+'<div class="row">'
												+'<img src="<%=request.getContextPath() %>/resources/img/member/profiles/'+entry.FILENAME+'" width="20px" height="20px" style="border-radius: 10px;">'
												+'&nbsp;<span style="font-weight: bold;">'+entry.RC_NICKNAME+'</span>'
											+'</div>'
											+'<div class="row" style="margin-top: 5px;">';
											if(entry.RC_STATUS == "0") {
												html += '블라인드 처리되거나 삭제 된 댓글 입니다.';
											} else {
												html += entry.RC_CONTENT;
											}
											html += '</div>'
											+'<div class="row" style="margin-top: 5px; color: gray;">'
												+'<span>'+entry.RC_WRITEDATE+'</span>'
											+'</div>'
										/* === 2019.02.07 === */
											+'<div class="row" style="margin-top: 5px;">';
										if(entry.RC_STATUS != "0") {
											if("${sessionScope.loginuser != null}") {
												if("${sessionScope.loginuser.idx}" == entry.FK_IDX) {
													html += '<button class="btn" onclick="goCommentsEditShow('+entry.RC_ID+', '+currentPageNo+')" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">수정</button>'
														  + '<button class="btn" onclick="goCommentsDel('+entry.RC_ID+', '+currentPageNo+')" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">삭제</button>';
												}
												html +='<button class="btn" onclick="goCommentsAddShow('+entry.RC_ID+', '+rc_userid+', '+entry.RC_GROUP+', '+entry.RC_G_ODR+', '+entry.RC_DEPTH+', '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">답글</button>';
											} 
										}// end of if
											
											html += '</div>'
											+'<div class="row" id="commentsShow'+entry.RC_ID+'" style="margin-top: 5px;">'
											+'</div>'
										/* === 2019.02.07 === */
										+'</div>'
									+'</div>';
						} // end of if~else
						
					}); // end of each
				} else {
					html = "";
				} // end of if~else
					
				$("#commentsResult").html(html);
				showPageBar(currentPageNo);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
		
	} // end of function showComments(currentPageNo)
	// === 2019.02.05 ==== //
	
	// 댓글 페이지바 만들기
	function showPageBar(currentPageNo) {
		var data = {"review_uid":$("#review_uid").val()};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectReviewCommentsTotalCnt.pet",  /* === 2019.02.06 === */
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				var html = "";
				
				/* === 2019.02.08 === 수정 */
				var totalCnt = json;
				var sizePerPage = 10;
				
				var totalPage = parseInt(Math.ceil(parseFloat(totalCnt/sizePerPage)));
				
				$("#totalPageSpan").html(totalCnt);
				/* === 2019.02.08 === 수정 */
				
				$("#totalPage").val(totalPage);/* === 2019.02.06 === 추가 */
				
				var blockSize = 5;
				var loop = 1;
				
				var pageNo = Math.floor((currentPageNo - 1)/blockSize) * blockSize + 1;
				
				if(pageNo != 1) {
					html += "<li><a href=\"javascript:showComments("+(pageNo-1)+")\">이전</a></li>";
				}
				
				while(!(loop > blockSize || pageNo > totalPage)) {
					if(pageNo == currentPageNo) {
						html += "<li><a style='color:black;'>"+pageNo+"</a></li>";
					} else {
						html += "<li><a href=\"javascript:showComments("+pageNo+")\">"+pageNo+"</a></li>";
					} // end of if~else
						
					pageNo++;
					loop++;
				} // end of while
					
				if(!(pageNo > totalPage)) {
					html += "<li><a href=\"javascript:showComments("+(pageNo+1)+")\">다음</a></li>";
				} // end of if
				
				$("#pageBar").empty().html(html);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});// end of ajax
	} // end of function showPageBar(currentPageNo)
	/* === 2019.02.06 === */
	
	/* === 2019.02.07 === 시작 */
	// *** 댓글 수정하기 ***//
	// 수정 폼 보여주기
	function goCommentsEditShow(idx, currentPageNo) {
		var html = '';
		
		var data = {"rc_id":idx};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectReviewCommentsOne.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				var contents = json.RC_CONTENT;
				contents = contents.replace(/<br\s*[\/]?>/gi, '\r');
				
				if(json != null) {
					html = '<div class="col-sm-12" style="border: 1px solid #bfbfbf; background-color: #ffffff; border-radius: 10px;">'
								+'<div class="row">'
									+'<input type="hidden" id="rc_id'+idx+'" name="rc_id" value="'+json.RC_ID+'"/>'
									+'<textarea class="form-control" id="rc_content'+idx+'" name="rc_content" rows="5" placeholder="주제와 무관한 댓글, 악플은 삭제될 수 있습니다." style="border: none;resize: none;">'+contents+'</textarea>'
							+'</div>'
							+'<div class="row" align="right" style="border-top: 1px solid #bfbfbf; background-color: #ffffff;">'
								+'<div class="col-sm-offset-10 col-sm-2">'
									+'<button type="button" class="btn" onclick="goCommentsEdit('+idx+', '+currentPageNo+')" style="margin-top: 2px; background-color: rgb(252, 118, 106); color: white; font-weight: bold; color: white;">수정</button>'
								+'</div>'
							+'</div>'
						+'</div>';
				}
				$("#commentsShow"+idx).html(html);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function goCommentsEditShow(idx, currentPageNo)
	
	// 수정 처리하기
	function goCommentsEdit(idx, currentPageNo) {
		//alert("idx: "+idx+", currentPageNo: "+currentPageNo);
		var contents = $("#rc_content"+idx).val();
		contents = contents.replace(/(?:\r\n|\r|\n)/g, '<br />')
		var data = {"rc_id":idx,
					"rc_content":contents};

		$.ajax({
			url:"<%=request.getContextPath()%>/updateReviewComments.pet",
			type: "POST",
			data: data,
			dataType: "JSON",
			success: function(json){
				
				if(json == 0) {
					alert("댓글 수정 실패했습니다.");
				} else {
					alert("댓글 수정되었습니다.");
				} // end of if~else
				showComments(currentPageNo);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function goCommentsEdit(idx, currentPageNo)
	
	// *** 댓글 삭제 ***//
	function goCommentsDel(idx, currentPageNo) {
		var data = {"rc_id":idx}
		
		$.ajax({
			url:"<%=request.getContextPath()%>/updateReviewCommentsStatus.pet",
			type: "POST",
			data: data,
			dataType: "JSON",
			success: function(json){
				
				if(json == 0) {
					alert("댓글 삭제 실패했습니다.");
				} else {
					alert("댓글 삭제되었습니다.");
				} // end of if~else
				showComments(currentPageNo);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function goCommentsDel(idx, currentPageNo)
	
	// *** 대댓글 추가하는 폼 보여주기 ***//
	function goCommentsAddShow(idx, rc_userid, rc_group, rc_g_odr, rc_depth, currentPageNo) {
		
		var html = '<div class="col-sm-12" style="border: 1px solid #bfbfbf; border-radius: 10px; background-color: #ffffff;">'
						+'<div class="row">'
						+'<input type="hidden" id="rc_id'+idx+'" name="rc_id" value="'+idx+'"/>'
						+'<input type="hidden" id="rc_userid'+idx+'" name="rc_userid" value="'+rc_userid+'"/>'
						+'<input type="hidden" id="rc_group'+idx+'" name="rc_group" value="'+rc_group+'"/>'
						+'<input type="hidden" id="rc_g_odr'+idx+'" name="rc_g_odr" value="'+rc_g_odr+'"/>'
						+'<input type="hidden" id="rc_depth'+idx+'" name="rc_depth" value="'+rc_depth+'"/>'
						+'<textarea class="form-control" id="rc_content'+idx+'" name="rc_content" rows="5" placeholder="주제와 무관한 댓글, 악플은 삭제될 수 있습니다." style="border: none;resize: none;"></textarea>'
					+'</div>'
					+'<div class="row" align="right" style="border-top: 1px solid #bfbfbf; background-color: #ffffff;">'
						+'<div class="col-sm-offset-10 col-sm-2">'
							+'<button type="button" class="btn" onclick="goCommentsAdd('+idx+', '+currentPageNo+');" style="margin-top: 2px; background-color: rgb(252, 118, 106); color: white; font-weight: bold; color: white;">등록</button>'
						+'</div>'
					+'</div>'
				+'</div>';
		
		$("#commentsShow"+idx).html(html);
	} // end of function goCommentsAddShow(rc_id, rc_group, rc_g_odg, rc_depth, currentPageNo)
	
	// *** 대댓글 추가하기 *** //
	function goCommentsAdd(idx, currentPageNo) {
		
		var contents = $("#rc_content"+idx).val();
		contents= contents.replace(/(?:\r\n|\r|\n)/g, '<br />');
		
		var data = {"review_uid":$("#review_uid").val(),
					"rc_content":contents,
					"fk_userid":$("#rc_userid"+idx).val(),
					"rc_id":idx,
					"rc_group":$("#rc_group"+idx).val(),
					"rc_g_odr":$("#rc_g_odr"+idx).val(),
					"rc_depth":$("#rc_depth"+idx).val()};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/addComments.pet",
			type: "POST",
			data: data,
			dataType: "JSON",
			success: function(json){
				$("#rc_content").val("");
				
				showComments(currentPageNo);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function goCommentsAdd(idx, currentPageNo)
	/* === 2019.02.07 === 끝 */
	
</script>

<div class="container" style="margin-top: 15px; margin-bottom: 15px;">
	<div class="col-sm-offset-1 col-sm-10" style="border: 1px solid #ddd; border-radius: 10px; padding: 10px;">
		<div class="row">
			<div class="col-sm-6">
				<span style="font-size: 13pt; font-weight: bold;">[${reviewMap.FK_NICKNAME}] 회원님의 [${reviewMap.HOSNAME}] 리뷰입니다.</span>
			</div>
		</div>
		
		<div class="row">
			<div class="col-sm-3">
				<img class="profile" style="border-radius: 100%;" width="15%" src="<%=request.getContextPath() %>/resources/img/member/profiles/${reviewMap.FILENAME}">
				<span>${reviewMap.FK_NICKNAME}&nbsp;${reviewMap.RV_WRITEDATE}</span>
			</div>
			<div class="col-sm-offset-7 col-sm-2" align="right">
				<c:forEach begin="1" end="${reviewMap.STARTPOINT}">
					<img class="addStar" width="15px" height="15px" src="<%=request.getContextPath()%>/resources/img/review/star.png">
				</c:forEach>
				
				<c:forEach begin="1" end="${5-reviewMap.STARTPOINT}">
					<img class="addStar" width="15px" height="15px" src="<%=request.getContextPath()%>/resources/img/review/star empty.png">
				</c:forEach>
			</div>
		</div>
		
		<hr style="margin: 0; margin-top: 10px; margin-bottom: 10px;">
		
		<div class="row">
			<div class="col-sm-12">
				${reviewMap.RV_CONTENTS}
			</div>
		</div>
		
		
		<div class="row">
			<div class="col-sm-offset-8 col-sm-4" align="right">
				<button class="btn" onclick="javascript:location.href='<%=request.getContextPath()%>/allReviewList.pet'">목록</button>
				<c:if test="${sessionScope.loginuser != null}">
					<c:if test="${sessionScope.loginuser.userid == reviewMap.FK_USERID}">
						<button class="btn" onclick="jsvascript:location.href='<%=request.getContextPath()%>/editReview.pet?review_UID=${reviewMap.REVIEW_UID}'">수정</button>
						<button class="btn"onclick="goDel(${reviewMap.REVIEW_UID});">삭제</button>
					</c:if>
				</c:if>
			</div>
		</div>
	
		<form name="delReviewFrm">
			<input type="hidden" name="review_UID"/>
		</form>
		
		<%-- ==== 2019.02.05 ==== --%>
		<div class="row">
			<div class="col-sm-offset-1 col-sm-10">
				<div class="col-sm-12" style="border: 1px solid #bfbfbf; border-radius: 10px;">
					<div class="row">
						<input type="hidden" id="review_uid" name="review_uid" value="${reviewMap.REVIEW_UID}"/>
						<input type="hidden" id="fk_userid" name="fk_userid" value="${reviewMap.FK_USERID}"/>
						<%-- ==== 2019.02.07 ==== --%>
						<textarea class="form-control contents" id="rc_content" name="rc_content" rows="5" placeholder="주제와 무관한 댓글, 악플은 삭제될 수 있습니다." style="border: none;resize: none;"></textarea>
						<%-- ==== 2019.02.07 ==== --%>
					</div>
					<div class="row" align="right" style="border-top: 1px solid #bfbfbf;">
						<div class="col-sm-offset-10 col-sm-2"><%-- ==== 2019.02.07 ==== --%>
							<button type="button" class="btn" onclick="addComments();" style="margin-top: 2px; background-color: rgb(252, 118, 106); color: white; font-weight: bold; color: white;">등록</button>
						</div>
					</div>
				</div>
				<%-- ==== 2019.02.05 ==== --%>
				<%-- ==== 2019.02.06 ==== --%>
				<div class="col-sm-12" style="margin-top: 10px;">
					<input type="hidden" id="totalPage" /><%-- ==== 2019.02.07 ==== --%>
					<span style="font-weight: bold;">댓글 <span id="totalPageSpan"></span>개</span> <%-- === 2019.02.08 === 수정 --%>
					<button type="button" onclick="showComments('1')" class="btn" style="background-color: white;"><span class="glyphicon glyphicon-repeat"></span></button>
				</div>
				
				<div class="col-sm-12" id="commentsResult">
				</div>
				
				<div class="col-sm-12" align="center">
					<div class="col-sm-12">
						<ul class="pagination pagination-sm" id="pageBar">
					  	</ul>
				  	</div>
				</div>
				<%-- ==== 2019.02.06 ==== --%>
			</div>
		</div>
	</div>
</div>
<!-- ==== 2019.02.04 ==== -->