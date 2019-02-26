<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- === 2019.01.31 === 시작 --%>
<style>
	.addColor {
		background-color: rgb(252, 118, 106); 
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
		});
	}); // end of $(document).ready();
	
	// === 2019.02.01 === 시작 //
	function showReviewList(currentPageNo) {
		
		var data = {"currentPageNo":currentPageNo,
					"period":$("#period").val(),
					"searchWhat":$("#searchWhat").val(),
					"search":$("#searchContext").val()
					};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectReviewList.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				
				var html = "";
				if(json.length > 0) {
					$.each(json,function(entryIndex,entry){
						html += '<tr>'
									+'<td>'+entry.RNO+'</td>'
									/* === 2019.02.03 === 수정 */
									+'<td><a href="<%=request.getContextPath()%>/reviewDetail.pet?review_UID='+entry.REVIEW_UID+'" class="Astyle">['+entry.FK_NICKNAME+'] 회원님의 ['+entry.NAME+'] 리뷰입니다.</a></td>'
									/* === 2019.02.03 === 수정 */
									+'<td>'+entry.FK_USERID+'</td>'
									+'<td style="text-align: center;">';
									for(var i=0; i<entry.STARTPOINT; i++) {
										html += '<img class="addStar" width="10px" height="10px" src="<%=request.getContextPath()%>/resources/img/review/star.png">';
									} // 별 추가
									
									for(var i=0; i<5-entry.STARTPOINT; i++) {
										html += '<img class="addStar" width="10px" height="10px" src="<%=request.getContextPath()%>/resources/img/review/star empty.png">';
									} // 반별 추가

									//html += '<span style="font-size: 10pt;">'+entry.STARTPOINT+'</span>';
								html += '</td>'
									+'<td style="text-align: center;">'+entry.RV_WRITEDATE+'</td>'
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
			url: "<%=request.getContextPath()%>/selectReviewListTotalPage.pet",
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
					html += "<li><a href=\"javascript:showReviewList("+(pageNo+1)+")\">다음</a></li>"; // === 2019.02.13 === 수정 //
				} // end of if
				
				$("#pageBar").empty().html(html);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
		
	} // end of function showPageBar()
	
	// === 2019.02.01 === 끝 //

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
						<input type="hidden" id="period"><%-- === 2019.01.29 === --%>
					</div>
					
					<div class="col-sm-6"><%-- 이름, 닉네임, 아이디로 검색 --%>
						<div class="custom-select" style="width:20%; float: left;">
	  						<select name="searchWhat" id="searchWhat" class="form-control">
								<option value="">검색</option>
								<%-- === 2019.02.01 === 수정 --%>
								<option value="fk_userid">아이디</option>
								<option value="fk_nickname">닉네임</option>
								<option value="name">병원</option>
								<%-- === 2019.02.01 === 수정 --%>
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
							<th width="50%" style="text-align: center;">제목</th>
							<th width="20%" style="text-align: center;">아이디</th>
							<th width="10%" style="text-align: center;">평점</th>
							<th width="13%" style="text-align: center;">날짜</th>
						</tr>
					</thead>
					
					<tbody id="result"><%-- === 2019.02.01 === 임시 내용 삭제 --%>
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
<%-- === 2019.01.31 === 끝 --%>