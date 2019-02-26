<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style type="text/css">
	.addColor {
		background-color: rgb(252, 118, 106); 
		color: white; 
		font-weight: bold;
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		
		var data = {"idx":${idx_biz}};
		
		showReviewList("1");
		
		$.ajax({
			url: "<%= request.getContextPath()%>/selectAvgStarPoint.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json) {
				var html = '<div class="col-sm-12">';
				var starpoint = json;
				
				for(var i = 0; i<starpoint; i++) {
					html += '<img class="addStar" width="30px" height="30px" src="<%=request.getContextPath()%>/resources/img/review/star.png">';
				}
				
				for(var i = 0; i<5 - starpoint; i++) {
					html += '<img class="addStar" width="30px" height="30px" src="<%=request.getContextPath()%>/resources/img/review/star empty.png">';
				}
				
				html += '</div>';
				
				$("#resultStarPoint").html(html);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax 
		
	}); // end of $(document).ready();
	
	// === 2019.02.13 ==== //
	// 리뷰 목록 보여주기
	function showReviewList(currentPageNo) {
		
		var data = {"idx":${idx_biz},
					"currentPageNo":currentPageNo};
		
		$.ajax({
			url: "<%= request.getContextPath()%>/showHosReview.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				var html = "";
				
				if(json.length > 0) {
					$.each(json, function(entryIndex, entry){
						
						html += '<div class="col-sm-12" style="margin-top: 10px;">'
									+'<div class="col-sm-3">'
										+'<img class="profile" style="border-radius: 100%;" width="15%" src="<%=request.getContextPath() %>/resources/img/member/profiles/'+entry.FILENAME+'">'
										+'<span>&nbsp;'+entry.FK_NICKNAME+'&nbsp;'+entry.RV_WRITEDATE+'</span>'
									+'</div>'
									+'<div class="col-sm-offset-7 col-sm-2" align="right">';
									for(var i = 0; i<entry.STARTPOINT; i++) {
										html += '<img class="addStar" width="15px" height="15px" src="<%=request.getContextPath()%>/resources/img/review/star.png">';
									}
									
									for(var i = 0; i<5 - entry.STARTPOINT; i++) {
										html += '<img class="addStar" width="15px" height="15px" src="<%=request.getContextPath()%>/resources/img/review/star empty.png">';
									}
									
								html += '</div>'
								+'</div>'
								+'<div class="col-sm-12" style="margin-top: 10px; border-bottom: 1px solid #e6e6e6;">'
									+'<div class="col-sm-12">'
										+entry.RV_CONTENTS
									+'</div>'
									+'<div class="col-sm-12" align="right">'
										// === 2019.02.13 ==== //
										+'<button class="btn btn-xs" onclick="goDetil('+entry.REVIEW_UID+')" style="background-color: white; border: none;"><img src="<%=request.getContextPath()%>/resources/img/review/sms-bubble-speech.png">&nbsp;댓글보기</button>'
										// === 2019.02.13 ==== //
									+'</div>'
								+'</div>';
					});
				} else {
					html += '<div class="col-sm-12" style="margin-top: 10px;">'
								+'해당하는 리뷰가 없습니다'
							+'</div>';
				}
				
				$("#resultReview").html(html);
				showReviewListPageBar(currentPageNo);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function showReviewList(currentPageNo)
	
	// 페이지바 생성
	function showReviewListPageBar(currentPageNo) {
		var html = "";
		
		var data = {"idx":${idx_biz}};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/showHosReviewTotal.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json) {
				
				var totalPage = json;
				var blockSize = 10;
				var loop = 1;
				
				var pageNo = Math.floor((currentPageNo - 1)/blockSize) * blockSize + 1;
				
				if(pageNo != 1) {
					html += "<li><a href=\"javascript:showReviewList("+(pageNo-1)+")\">이전</a></li>";
				} // end of if
				
				while(!(loop > blockSize || pageNo > totalPage)) {
					
					if(pageNo == currentPageNo) {
						html += "<li><a style='color:black;'>"+pageNo+"</a></li>";
					} else {
						html += "<li><a href=\"javascript:showReviewList("+pageNo+")\">"+pageNo+"</a></li>";
					} // end of if~else
						
					pageNo++;
					loop++;
					//alert("pageNo: "+pageNo+", loop: "+loop+", html: "+html);
				} // end of while
				
				if(!(pageNo > totalPage)) {
					html += "<li><a href=\"javascript:showReviewList("+(pageNo+1)+")\">다음</a></li>";
				} // end of if
				
				$("#pageBar").html(html);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
		
	} // end of function showReviewListPageBar(currentPageNo)
	
	// 디테일 페이지로 이동
	function goDetil(review_UID) {
		location.href = "<%=request.getContextPath()%>/reviewDetail.pet?review_UID="+review_UID;
	} // end of function goDetil(review_uid)
	// === 2019.02.13 ==== //
</script>

<label style="font-weight: bold;">병원리뷰</label>

<div class="col-sm-12">
	<div id="resultStarPoint"></div>
	<div id="resultReview"></div>
	<%-- === 2019.02.13 === --%>
	<div class="col-sm-12" align="center">
		<ul class="pagination pagination-sm" id="pageBar">
	  	</ul>
  	</div>
  	<%-- === 2019.02.13 === --%>
</div>
