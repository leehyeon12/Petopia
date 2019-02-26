<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- === 2019.02.08 === 시작 --%>
<style>
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
	
	.Astyle {
		color: black;
		text-decoration: none;
	}
	
	.Astyle:hover {
		color: rgb(252, 118, 106);
		text-decoration: none;
	}
</style>

<script type="text/javascript">

	$(document).ready(function(){
		showReviewList("1");
		
		// 기간 버튼 클릭하면
		$(".periodBtn").click(function(){
			$(".periodBtn").removeClass("addColor");
			$(this).addClass("addColor");
			
			$("#period").val($(this).val());
			showReviewList("1");
		}); // end of $(".periodBtn").click();
		
		// 검색 버튼을 클릭하면
		$("#searchBtn").click(function(){
			if($("#searchWhat").val() == "") {
				alert("검색 조건을 선택해주세요.");
				
				return;
			} else if($("#searchContext").val() == "") {
				alert("검색 내용을 입력해주세요.");
				
				return;
			}
			
			showReviewList("1");
		}); // end of $("#searchBtn").click();
		
		// 검색 enter
		$("#search").keydown(function(event){
			if($("#searchWhat").val() == "") {
				alert("검색 조건을 선택해주세요.");
				
				return;
			} else if($("#searchContext").val() == "") {
				alert("검색 내용을 입력해주세요.");
				
				return;
			}
			
			if(event.keyCode == 13) {
				showReviewList("1");
			}
		}); // end of $("#search").keydown();
		
		// 블라인드 처리 모달에서 OK를 누르면
		$("#blindModalOK").click(function(){
			
			var frm = document.blindModalFrm;
			
			var review_uid = frm.review_uid.value;
			var currentPageNo = frm.currentPageNo.value;
			var blindNo = frm.blindNo.value;
			
			//alert("review_uid: "+review_uid+", currentPageNo: "+currentPageNo+", blindNo: "+blindNo);
			
			reviewBlind(review_uid, blindNo, currentPageNo);
			
			$('[type=radio]').prop('checked', false);
		}); // end of $("#blindModalOK").click();
	}); // end of $(document).ready();
	
	function showReviewList(currentPageNo) {
		
		var data = {"currentPageNo":currentPageNo,
					"period":$("#period").val(),
					"searchWhat":$("#searchWhat").val(),
					"search":$("#searchContext").val()
					};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectAdminReviewList.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				
				var html = "";
				if(json.length > 0) {
					$.each(json,function(entryIndex,entry){
						html += '<tr>'
									+'<td>'+entry.RNO+'</td>'
									+'<td><a href="<%=request.getContextPath()%>/adminReviewDetail.pet?review_UID='+entry.REVIEW_UID+'" class="Astyle">['+entry.FK_NICKNAME+'] 회원님의 ['+entry.NAME+'] 리뷰입니다.</a></td>'
									+'<td>'+entry.FK_USERID+'</td>'
									+'<td style="text-align: center;">';
									for(var i=0; i<entry.STARTPOINT; i++) {
										html += '<img class="addStar" width="10px" height="10px" src="<%=request.getContextPath()%>/resources/img/review/star.png">';
									} // 별 추가
									
									for(var i=0; i<5-entry.STARTPOINT; i++) {
										html += '<img class="addStar" width="10px" height="10px" src="<%=request.getContextPath()%>/resources/img/review/star empty.png">';
									} // 빈별 추가

								html += '</td>'
									+'<td style="text-align: center;">'+entry.RV_WRITEDATE+'</td>'
									+'<td style="text-align: center;">';
								if(entry.RV_STATUS == "1" && entry.RV_BLIND == "0") {
									html += '<button type="button" class="btn btn-xs addColor" onclick="setBlind('+entry.REVIEW_UID+', '+currentPageNo+');" data-toggle="modal" data-target="#showBlind">블라인드처리</button>';
								} else if(entry.RV_STATUS == "0" && entry.RV_BLIND != "0") {
									html += '<button type="button" class="btn btn-xs" onclick="reviewBlindCancle('+entry.REVIEW_UID+', '+currentPageNo+')">블라인드처리취소</button>';
								} else if(entry.RV_STATUS == "1" && entry.RV_BLIND == "2") {
									html += '<button type="button" class="btn btn-xs addColor2" onclick="reviewBlind('+entry.REVIEW_UID+', 2, '+currentPageNo+')">기업블라인드요청</button>';
								}
									html += '</td>'
								+'</tr>';
					});
				} else {
					html += '<tr><td colspan="5" style="text-align: center;">해당하는 리뷰가 없습니다.</td></tr>';
				}
				
				$("#result").html(html);
				showPageBar(currentPageNo);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function showReviewList(currentPageNo)
	
	function showPageBar(currentPageNo) {
		var data = {"currentPageNo":currentPageNo,
					"period":$("#period").val(),
					"searchWhat":$("#searchWhat").val(),
					"search":$("#searchContext").val()};
		$.ajax({
			url: "<%=request.getContextPath()%>/selectAdminReviewListTotalPage.pet",
			type: "GET",
			data: data,
			datatype: "JSON",
			success: function(json){
				var html = "";
				
				var totalPage = json;
				var blockSize = 5;
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
					
				} // end of while
					
				if(!(pageNo > totalPage)) {
					html += "<li><a href=\"javascript:showMemberList("+(pageNo+1)+")\">다음</a></li>";
				} // end of if
				
				$("#pageBar").empty().html(html);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function showPageBar()
	
	// 리뷰 블라인드
	function reviewBlind(review_uid, blindNo, currentPageNo) {
		
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
					showReviewList(currentPageNo);
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
	function reviewBlindCancle(review_uid, currentPageNo) {
		
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
					showReviewList(currentPageNo);
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
	function setBlind(review_uid, currentPageNo) {
		
		$("#modalReview_uid").val(review_uid);
		$("#modalCurrentPageNo").val(currentPageNo);
		
	} // end of function setBlind(review_uid, currentPageNo)
	
</script>

<div class="container" style="margin-top: 15px; margin-bottom: 15px;">
	<div class="row">
		<div class="col-sm-offset-1 col-sm-10" style="margin-top: 20px;background-color: white;">
			<form name="searchFrm" onsubmit="return false">
				<div class="row" style="margin-top: 10px; margin-bottom: 10px;">
					<div class="col-sm-6">
						<button class="btn periodBtn addColor" value="0">전체</button>
						<button class="btn periodBtn" value="1">최근 1달</button>
						<button class="btn periodBtn" value="3">최근 3달</button>
						<button class="btn periodBtn" value="6">최근 6달</button>
						<input type="hidden" id="period">
					</div>
					
					<div class="col-sm-6"><%-- 이름, 닉네임, 아이디로 검색 --%>
						<div class="custom-select" style="width:20%; float: left;">
	  						<select name="searchWhat" id="searchWhat" class="form-control">
								<option value="">검색</option>
								<option value="fk_userid">아이디</option>
								<option value="fk_nickname">닉네임</option>
							</select>
						</div>
						<input type="text" id="searchContext" class="form-control" placeholder="Search.." style="width: 60%; float: left;">
						<button type="button" class="btn" id="searchBtn" style="width: 20%; height: 34px;background-color: rgb(252, 118, 106); color: white; font-weight: bold;"><i class="fa fa-search"></i></button>
					</div>
				</div>
			</form>
		</div>
	</div><%-- 검색 --%>
	
	<div class="row" id="reviewList">
		<div class="col-sm-offset-1 col-sm-10" style="">
			<div class="table-responsive">
				<table class="table" style="margin-top: 20px;width: 100%;">
					<thead style="background-color: #f2f2f2;">
						<tr>
							<th width="7%" style="text-align: center;">번호</th>
							<th width="40%" style="text-align: center;">제목</th>
							<th width="20%" style="text-align: center;">아이디</th>
							<th width="10%" style="text-align: center;">평점</th>
							<th width="13%" style="text-align: center;">날짜</th>
							<th width="10%" style="text-align: center;">블라인드</th>
						</tr>
					</thead>
					
					<tbody id="result">
					</tbody>
				</table>
			</div>
		</div>
	</div><%-- 내용 --%>
	
	<div class="row" align="center">
		<div class="col-sm-12">
			<ul class="pagination pagination-sm" id="pageBar">
		  	</ul>
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
					<input type="hidden" name="currentPageNo" id="modalCurrentPageNo" />
					
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

<%-- === 2019.02.08 === 끝 --%>