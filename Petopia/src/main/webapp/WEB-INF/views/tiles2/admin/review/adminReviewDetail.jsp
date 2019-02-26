<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- ==== 2019.02.08 ==== -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	.addColor {
		background-color: rgb(252, 118, 106); 
		color: white; 
		font-weight: bold;
	}
	
	.addColor2 {
		background-color: #C46376; 
		color: white; 
		font-weight: bold;
	}
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		showComments("1");
		
		// 블라인드 처리 모달에서 OK를 누르면
		$("#blindModalOK").click(function(){
			
			var frm = document.blindModalFrm;
			
			var review_uid = frm.review_uid.value;
			var blindNo = frm.blindNo.value;
			
			//alert("review_uid: "+review_uid+", currentPageNo: "+currentPageNo+", blindNo: "+blindNo);
			
			reviewBlind(review_uid, blindNo);
			
			$('[type=radio]').prop('checked', false);
		}); // end of $("#blindModalOK").click(); 
		
		/* === 2019.02.11 ==== */
		// 댓글 블라인드 처리
		$("#commentsBlindModalOK").click(function(){
			
			var frm = document.commentsBlindModalFrm;
			
			var rc_id = frm.rc_id.value;
			var blindNo = frm.blindNo.value;
			var currentPageNo = frm.currentPageNo.value;
			
			//alert("rc_id: "+rc_id+", currentPageNo: "+currentPageNo+", blindNo: "+blindNo);
			
			reviewCommentsBlind(rc_id, blindNo, currentPageNo);
			
			$('[type=radio]').prop('checked', false);
		}); // end of $("#blindModalOK").click(); 
		/* === 2019.02.11 ==== */
		
	}); // end of $(document).ready()
	
	// 댓글 리스트 보기
	function showComments(currentPageNo) {
		
		var data = {"currentPageNo":currentPageNo,
					"review_uid":${reviewMap.REVIEW_UID}};
		
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
											+'<div class="row" style="margin-top: 5px;">';
								if(entry.RC_STATUS == "0" && entry.RC_BLIND != "0") {
									html += '<button class="btn" onclick="reviewCommentsBlindCancle('+entry.RC_ID+', '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">블라인드 처리 취소</button>';
								} else if(entry.RC_STATUS == "1" && entry.RC_BLIND == "2") {
									html += '<button class="btn addColor2" onclick="reviewCommentsBlind('+entry.RC_ID+', 2, '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px;">기업블라인드요청</button>';								
								} else  {
									// === 2019.02.11 === 시작 //
									html += '<button class="btn addColor" onclick="setCommentsBlind('+entry.RC_ID+', '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px;" data-toggle="modal" data-target="#showCommentsBlind">블라인드 처리</button>';
									// === 2019.02.11 === 끝 //
								}// end of if

									html += '</div>'
											+'<div class="row" id="commentsShow'+entry.RC_ID+'" style="margin-top: 5px;">'
											+'</div>'
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
											+'<div class="row" style="margin-top: 5px;">';
											
										if(entry.RC_STATUS == "0" && entry.RC_BLIND != "0") {
											html += '<button class="btn" onclick="reviewCommentsBlindCancle('+entry.RC_ID+', '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px; background-color: white;">블라인드 처리 취소</button>';
											// === 2019.02.11 === 시작 //
										} else if(entry.RC_STATUS == "1" && entry.RC_BLIND == "2") {
											html += '<button class="btn addColor2" onclick="reviewCommentsBlind('+entry.RC_ID+', 2, '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px;">기업블라인드요청</button>';								
										} else {
											
											html += '<button class="btn addColor" onclick="setCommentsBlind('+entry.RC_ID+', '+currentPageNo+');" style="font-size: 8pt; border: none; padding: 7px;" data-toggle="modal" data-target="#showCommentsBlind">블라인드 처리</button>';
											// === 2019.02.11 === 끝 //
										}// end of if
											
											html += '</div>'
											+'<div class="row" id="commentsShow'+entry.RC_ID+'" style="margin-top: 5px;">'
											+'</div>'
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
	
	// 댓글 페이지바 만들기
	function showPageBar(currentPageNo) {
		var data = {"review_uid":${reviewMap.REVIEW_UID}};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectReviewCommentsTotalCnt.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				var html = "";
				
				var totalCnt = json;
				var sizePerPage = 10;
				
				var totalPage = parseInt(Math.ceil(parseFloat(totalCnt/sizePerPage)));
				
				$("#totalPageSpan").html(totalCnt);
				$("#totalPage").val(totalPage);
				
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
	
	// 리뷰 블라인드
	function reviewBlind(review_uid, blindNo) {
		
		var bool = confirm("해당 리뷰를 블라인드 처리하시겠습니까?");
		
		if(bool == true) {
			
			var data = {"review_uid":review_uid,
						"rv_blind":blindNo};
			
			$.ajax({
				url: "<%=request.getContextPath()%>/updateReviewBlindStatusByReview_uid.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					
					if(json == 0) {
						alert("블라인드 처리 실패하였습니다.");
					} else {
						alert("블라인드 처리되었습니다.");
					}
					location.reload();
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax()
			
		} else {
			$(':focus').blur();
			
			return;
		} // end of if~else
	} // end of function setBlindReviewUID(review_uid, currentPageNo)
	
	// 리뷰 블라인드 취소
	function reviewBlindCancle(review_uid) {
		
		var bool = confirm("해당 리뷰를 블라인드 요청을 취소하시겠습니까?");
		
		if(bool == true) {
			
			var data = {"review_uid":review_uid};
			
			$.ajax({
				url: "<%=request.getContextPath()%>/updateReviewBlindCancleByReview_uid.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					
					if(json == 0) {
						alert("블라인드 취소가 실패하였습니다.");
					} else {
						alert("블라인드 취소되었습니다.");
					}
					showComments(currentPageNo);
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax()
			
		} else {
			$(':focus').blur();
			return;
		} // end of if~else
	} // end of function reviewBlindCancle(review_uid, currentPageNo)
	
	// 블라인드 버튼 누르면 해당 정보 넘기기
	function setBlind(rc_id, currentPageNo) {
		
		$("#modalReview_uid").val(rc_id);
		
	} // end of function setBlind(review_uid, currentPageNo)
	
	/* === 2019.02.11 === */
	// 댓글 블라인드 버튼 누르면 해당 정보 넘기기
	function setCommentsBlind(rc_id, currentPageNo) {
		
		$("#modalCommentsRc_id").val(rc_id);
		$("#modalCommentsCurrentPageNo").val(currentPageNo);
		
	} // end of function setBlind(review_uid, currentPageNo)
	
	// 댓글 블라인드
	function reviewCommentsBlind(rc_id, blindNo, currentPageNo) {
		
		var bool = confirm("해당 댓글을 블라인드 처리하시겠습니까?");
		
		if(bool == true) {
			
			var data = {"rc_id":rc_id,
						"rc_blind":blindNo};
			
			$.ajax({
				url: "<%=request.getContextPath()%>/updateReviewCommentsBlindStatusByRc_id.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					
					if(json == 0) {
						alert("블라인드 처리 실패하였습니다.");
					} else {
						alert("블라인드 처리되었습니다.");
					}
					showComments(currentPageNo);
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax()
			
		} else {
			$(':focus').blur();
			
			return;
		} // end of if~else
	} // end of function reviewCommentsBlind(rc_id, blindNo, currentPageNo)
	
	// 댓글 블라인드 취소
	function reviewCommentsBlindCancle(rc_id, currentPageNo) {
		
		var bool = confirm("해당 댓글의 블라인드 요청을 취소하시겠습니까?");
		
		if(bool == true) {
			
			var data = {"rc_id":rc_id};
			
			$.ajax({
				url: "<%=request.getContextPath()%>/updateReviewCommentsBlindCancleByRc_id.pet",
				type: "POST",
				data: data,
				dataType: "JSON",
				success: function(json){
					
					if(json == 0) {
						alert("블라인드 취소가 실패하였습니다.");
					} else {
						alert("블라인드 취소되었습니다.");
					}
					showComments(currentPageNo);
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax()
			
		} else {
			$(':focus').blur();
			return;
		} // end of if~else
	} // end of function reviewCommentsBlindCancle(rc_id, currentPageNo)
	/* === 2019.02.11 === */
	
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
				<c:if test="${reviewMap.RV_STATUS == '0' && reviewMap.RV_BLIND != '0'}">
					<button type="button" class="btn" onclick="reviewBlindCancle(${reviewMap.REVIEW_UID});">블라인드처리취소</button>
				</c:if>
				<c:if test="${reviewMap.RV_STATUS == '1' && reviewMap.RV_BLIND == '2'}">
					<button type="button" class="btn addColor2" onclick="reviewBlind(${reviewMap.REVIEW_UID}, 2);">기업블라인드요청</button>
				</c:if>
				<c:if test="${reviewMap.RV_STATUS == '1' && reviewMap.RV_BLIND == '0'}">
					<button type="button" class="btn addColor" onclick="setBlind(${reviewMap.REVIEW_UID});" data-toggle="modal" data-target="#showBlind">블라인드처리</button>
				</c:if>
				
				<button class="btn" onclick="javascript:location.href='<%=request.getContextPath()%>/adminReviewList.pet'">목록</button>
			</div>
		</div>
		
		<div class="row">
			<div class="col-sm-offset-1 col-sm-10">
				<div class="col-sm-12" style="margin-top: 10px;">
					<input type="hidden" id="totalPage" />
					<span style="font-weight: bold;">댓글 <span id="totalPageSpan"></span>개</span>
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
			</div>
		</div>
	</div>
</div>

<!-- Modal -->
<div id="showBlind" class="modal fade" role="dialog" style="margin-top: 50px;">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">블라인드 처리</h4>
			</div>
			
			<div class="modal-body">
				<p>블라인드 처리를 하시겠습니까?</p>
				<p style="font-weight: bold; margin-top: 10px;">블라인드 사유</p>
				<form name="blindModalFrm">
					<input type="hidden" name="review_uid" id="modalReview_uid" />
					
					<label for="blind1"><input type="radio" name="blindNo" id="blind1" value="1"/> 욕설/비방</label><br>
					<label for="blind2"><input type="radio" name="blindNo" id="blind2" value="2"/> 기업회원의 요청</label><br>
					<label for="blind3"><input type="radio" name="blindNo" id="blind3" value="3"/> 신고 누적</label><br>
					<label for="blind4"><input type="radio" name="blindNo" id="blind4" value="4"/> 기타</label>
				</form>
			</div>
			
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
				<button type="button" class="btn btn-default addColor" data-dismiss="modal" id="blindModalOK">OK</button>
			</div>
		</div>
	</div>
</div>

<!-- ==== 2019.02.11 ==== -->
<!-- Modal -->
<div id="showCommentsBlind" class="modal fade" role="dialog" style="margin-top: 50px;">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">댓글 블라인드 처리</h4>
			</div>
			
			<div class="modal-body">
				<p>블라인드 처리를 하시겠습니까?</p>
				<p style="font-weight: bold; margin-top: 10px;">블라인드 사유</p>
				<form name="commentsBlindModalFrm">
					<input type="hidden" name="rc_id" id="modalCommentsRc_id" />
					<input type="hidden" name="currentPageNo" id="modalCommentsCurrentPageNo" />
					
					<label for="blindComments1"><input type="radio" name="blindNo" id="blindComments1" value="1"/> 욕설/비방</label><br>
					<label for="blindComments2"><input type="radio" name="blindNo" id="blindComments2" value="2"/> 기업회원의 요청</label><br>
					<label for="blindComments3"><input type="radio" name="blindNo" id="blindComments3" value="3"/> 신고 누적</label><br>
					<label for="blindComments4"><input type="radio" name="blindNo" id="blindComments4" value="4"/> 기타</label>
				</form>
			</div>
			
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
				<button type="button" class="btn btn-default addColor" data-dismiss="modal" id="commentsBlindModalOK">OK</button>
			</div>
		</div>
	</div>
</div>
<!-- ==== 2019.02.11 ==== -->
<!-- ==== 2019.02.08 ==== -->