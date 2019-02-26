<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- === 2019.01.28 ==== --%>
<style type="text/css">
	.addColor {
		background-color: rgb(252, 118, 106); 
		color: white; 
		font-weight: bold;
	}
</style>

<%-- === 2019.01.31 === 스트립트 추가 시작 --%>
<!-- include summernote css/js-->
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script>


<!-- include codemirror (codemirror.css, codemirror.js, xml.js, formatting.js) -->
<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.css">
<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.css">
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/2.36.0/formatting.js"></script>
<%-- === 2019.01.31 === 스트립트 추가 끝 --%>

<script type="text/javascript">

	$(document).ready(function(){
		
		$("#moreBtn").hide(); // === 2019.01.31 ==== 버튼 숨기기 //
		hospitalListAppend("1");

		// 이미지 크기 맞춤
	    $('.profile').css('height', $(".profile").width()-1);
	    
		$(window).resize(function() { 
			$('.profile').css('height', $(".profile").width());
	    });
		
		// 기간 버튼 클릭하면
		$(".periodBtn").click(function(){
			$(".periodBtn").removeClass("addColor");
			$(this).addClass("addColor");
			
			$("#period").val($(this).val());
			// ==== 2019.01.31 ==== 시작//
			$("#hosResult").html("");
			$("#moreBtn").show();
			$("#nowCnt").val(0);
			$("#totalCnt").val(0);
			// ==== 2019.01.31 ==== 끝//
			hospitalListAppend("1");
		});
		
		// === 2019.01.29 === //
		$(document).on('click', '.btn', function() {
			$('.summernote').summernote({
				// === 2019.02.03 === summernote수정 //
				callbacks: { // 콜백을 사용
                        // 이미지를 업로드할 경우 이벤트를 발생
					    onImageUpload: function(files, editor, welEditable) {
						    sendFile(files[0], this, welEditable);
						}
				},// === 2019.02.03 === summernote수정 //
				placeholder: '병원,약국에 대한 리뷰를 작성해주세요.',
		        tabsize: 2,
		        height: 300,
		        focus: true // === 2019.01.31 === 추가 //
			});
		});
		
		// 별점 주기
		$(document).on('click', '.star', function() {
			var cl = $(this).attr('class');
			var str_cl = String(cl);
			
			// ==== 2019.01.31 ==== 수정 시작 //
			var start = str_cl.indexOf('index');
			var idx = 0;
			if($(this).is(".reviewStar")) {
				var end = str_cl.indexOf('reviewStar');
				idx = str_cl.substring(start+5, end);
			} else {
				idx = str_cl.substring(start+5);
			} // end of if~else
			// ==== 2019.01.31 ==== 수정 끝 //
			
			var reviewCnt = Number($("#reviewCnt"+idx).val());
			if($(this).is(".reviewStar")) {
				$(this).removeClass("reviewStar");
				html = "<img class=\"removeStar\" src=\"<%=request.getContextPath()%>/resources/img/review/star.png\">";
				reviewCnt += 1;
			} else {
				$(this).addClass("reviewStar");
				html = "<img class=\"addStar\" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png\">";
				
				reviewCnt -= 1;
				if(reviewCnt < 0) {
					reviewCnt = 0;
				}
			} // end of if~else
			$(this).html(html);

			$("#reviewCnt"+idx).val(reviewCnt);
		}); // end of $(document).on() 별점 주기
		
		// === 2019.01.30 === 시작 //
		// 더보기 버튼 클릭
		$("#moreBtn").click(function(){
			// === 2019.01.31 === 시작 //
			hospitalListAppend($(this).val());
			// === 2019.01.31 === 끝 //
		}); // end of $("#moreBtn").click();
		// === 2019.01.30 === 끝 //
		
	}); // end of $(document).ready();
	
	// 리뷰 쓸 병원 목록 불러오기
	var len = 4;
	function hospitalListAppend(start) {
		
		selectTotalCount($("#period").val()); // ==== 2019.01.31 ==== 전체 갯수 알아오기 위치 변경 //
		
		var data = {"start":start,
					"len":len,
					"period":$("#period").val()};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectMyReviewList.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				var html = "";
				
				if(json.length > 0){
					$.each(json,function(entryIndex,entry){
						html += '<div class="col-sm-12" style="margin-top: 10px; border: 1px solid #bfbfbf; border-radius: 10px; padding-top: 15px; padding-bottom:15px; font-size: 13pt;">'
									+'<div class="row">'
									+'<div class="col-sm-3">'
										+'<div class="col-offset-sm-2 col-sm-8" style="padding-top: 25px;">'
											+'<div class="col-sm-12">'
												+'<img class="profile" style="border-radius: 100%;" width="100%" height="" src="<%=request.getContextPath() %>/resources/img/care/'+entry.PET_PROFILEIMG+'">' /* === 2019.02.01 === 수정 */
											+'</div>'
											+'<div class="col-sm-12" align="center" style="margin-top: 15px;">'
												+'<span style="font-weight: bold;">'+entry.PET_NAME+'</span>님'
											+'</div>'
										+'</div>'
									+'</div>'
									+'<div class="col-sm-8">'
										+'<div class="row" style="margin-top: 10px;">'
											+'<div style="background-color: rgb(252, 118, 106); padding: 7px 20px; color: white; border-radius: 15px;">'
												+ entry.CHART_TYPE
											+'</div>'
										+'</div>'
										+'<div class="row" style="margin-top: 10px;">'
											+'<img style="border-radius: 100%; margin-right: 20px;" width="70px" height="70px" src="<%=request.getContextPath() %>/resources/img/member/profiles/'+entry.FILENAME+'">'
											+'<span style="font-size: 15pt; line-height: 300%; font-weight: bold;">'+entry.NAME+'</span>	'			
										+'</div>'
										+'<div class="row" style="margin-top: 10px;">'
											+'<div class="col-sm-2" style="font-weight: bold;">방문일자</div>'
											+'<div class="col-sm-10">'+entry.RESERVATION_DATE+'</div>'
										+'</div>'
										+'<div class="row" style="margin-top: 5px;">'
											+'<div class="col-sm-2" style="font-weight: bold;">담당자</div>'
											+'<div class="col-sm-6">'+entry.DOC_NAME+'</div>'
											+'<div class="col-sm-4" align="right">';
								if(entry.REVIEWCNT=="0") {
									html += '<button class="btn addReviewBtn" id="addReview'+entry.FK_RESERVATION_UID+'" onclick="showAddReview('+entry.FK_RESERVATION_UID+');" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold;">리뷰작성 <span class="glyphicon glyphicon-chevron-down" style="color: white;"></span></button>';

								} else {
									html += '<button class="btn" id="showReview'+entry.FK_RESERVATION_UID+'" onclick="showReview('+entry.FK_RESERVATION_UID+');" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold;">리뷰보기 <span class="glyphicon glyphicon-chevron-down" style="color: white;"></span></button>';
								} // end of if
									
								html += '</div>'
										+'</div>'
									+'</div>'
								+'</div>'
								+'<div class="row" id="reviewShow'+entry.FK_RESERVATION_UID+'" style="margin-top: 10px;"></div>'
							+'</div>';
					}); // end of each
				} else {
					html += '<div class="col-sm-12" style="margin-top: 10px; border: 1px solid #bfbfbf; border-radius: 10px; padding-top: 15px; padding-bottom:15px; font-size: 13pt;">'
								+'<div class="row">'
								+'해당하는 데이터가 없습니다.'
								+'</div>'
							+'</div>';
				} // end of if~else
				
				// === 2019.01.30 === 시작 //
				// === 2019.01.31 === 시작 //
				$("#hosResult").append(html);
				
				$("#nowCnt").val(parseInt($("#nowCnt").val())+json.length);
				
				if($("#totalCnt").val() == $("#nowCnt").val() ) {
					$("#moreBtn").hide();
					$("#nowCnt").val(0);
				} else {
					$("#moreBtn").show();
					$("#moreBtn").val(parseInt(start)+len+1);
				} // end of if~else
				// === 2019.01.31 === 끝 //
				// === 2019.01.30 === 끝 //
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function hospitalListAppend(start)
	
	// === 2019.02.03 === summernote 이미지 업로드 //
	/* summernote에서 이미지 업로드시 실행할 함수 */
 	function sendFile(file, editor, welEditable) {
        // 파일 전송을 위한 폼생성
 		data = new FormData();
 	    data.append("uploadFile", file);
 	    $.ajax({ // ajax를 통해 파일 업로드 처리
 	        data : data,
 	        type : "POST",
 	        url : "<%=request.getContextPath()%>/summernoteImgUpload.pet",
 	        cache : false,
 	        contentType : false,
 	        processData : false,
 	        success : function(data) { // 처리가 성공할 경우
 	        	//이미지 경로
                $('.summernote').summernote('insertImage', "<%=request.getContextPath()%>/resources/img/review/"+data);
 	        }
 	    });
 	} // end of function sendFile(file, editor, welEditable)
	// === 2019.02.03 === summernote 이미지 업로드 //
	
	// 리뷰 작성 또는 리뷰 닫기
	function showAddReview(index) {
		var html = "";
		var btnMsg = $("#addReview"+index).html().substring(0, 4);
		
		if(btnMsg == "리뷰작성") {
			html = '<div class="col-sm-offset-1 col-sm-1">'
						+'<button class="btn" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold; color: white;" onclick="addReview('+index+');">등록</button>'
					+'</div>'
					+'<div class="col-sm-offset-7 col-sm-2" align="right">'
						/* ==== 2019.01.31 ==== 수정 시작 */
						+'<span class="star index'+index+' reviewStar"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>'
						+'<span class="star index'+index+' reviewStar"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>'
						+'<span class="star index'+index+' reviewStar"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>'
						+'<span class="star index'+index+' reviewStar"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>'
						+'<span class="star index'+index+' reviewStar"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>'
						/* ==== 2019.01.31 ==== 수정 끝 */
					+'</div>'
					+'<div class="col-sm-offset-1 col-sm-10" style="margin-top: 10px;">'
						/* +'<textarea class="form-control\" rows="10" placeholder="병원,약국에 대한 리뷰를 작성해주세요."></textarea>' */
						+'<input type="hidden" id="reviewCnt'+index+'" id="reviewCnt'+index+'">'
						+'<input type="hidden" id="fk_reservation_UID'+index+'" value="'+index+'">'
						+'<textarea class="summernote" id="rv_contents'+index+'" rows="10"></textarea>'
						/* +'<div class="summernote" name="rv_contents"><div>' */
					+'</div>';
			$("#addReview"+index).html('리뷰닫기 <span class="glyphicon glyphicon-chevron-up" style="color: white;"></span>');
		} else {
			html = "";
			$("#addReview"+index).html('리뷰작성 <span class="glyphicon glyphicon-chevron-down" style="color: white;"></span>');
		}
		$("#reviewShow"+index).html(html);
	} // end of function showReview(index)
	
	// 리뷰 쓰기
	function addReview(idx) {
		var frm = document.addReviewFrm;
		frm.startpoint.value = $("#reviewCnt"+idx).val();
		frm.fk_reservation_UID.value = $("#fk_reservation_UID"+idx).val();
		frm.rv_contents.value = $("#rv_contents"+idx).val();
		
		frm.action = "<%=request.getContextPath()%>/addReview.pet";
		frm.method = "POST";
		frm.submit();
	} // end of function addReview(idx)
	
	// 리뷰 보기 
	function showReview(index) {
		var html = "";
		var btnMsg = $("#showReview"+index).html().substring(0, 4);
		
		if(btnMsg == "리뷰보기") {
			// ajax로 해당하는 값의 리뷰 불러오기 하는중....
			// === 2019.01.30 === 시작//
			
			var data = {"fk_reservation_UID":index};
			var commentIdx = ""; // === 2019.01.31 === 추가 //
			
			$.ajax({
				url: "<%=request.getContextPath()%>/selectMyReview.pet",
				type: "GET",
				data: data,
				dataType: "JSON",
				success: function(json){
					html = '<div class="col-sm-offset-1 col-sm-10" style="margin-top: 10px; border: 1px solid #bfbfbf; border-radius: 10px;">'
							+ '<div class="row" style="padding: 7px;">'
								+'<div class="col-sm-6">';
					
							for(var i = 0; i<json.STARTPOINT; i++) {
								html += '<img class="addStar" width="25px" src=\"<%=request.getContextPath()%>/resources/img/review/star.png">';
							}
							
							for(var i = 0; i<(5-json.STARTPOINT); i++) {
								html += '<img class="addStar" width="25px" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png">';
							}
									
							html += 	'<span style="font-weight: bold; font-size: 10pt;">&nbsp;&nbsp;&nbsp;' + json.STARTPOINT + '</span><br>'
									+ '</div>'
								+ '</div>'
								+ '<div class="row" style="padding: 7px; font-size: 10pt;">'
									+ '<div class="col-sm-6">'
										+ '<span style="font-weight: bold;">' + json.FK_NICKNAME + '</span>&nbsp;'	
										+ '&nbsp;<span>' + json.RV_WRITEDATE + '</span>'
									+ '</div>'
									+ '<div class="col-sm-6" align="right">'
										+'<button class="btn" id="editBtn'+json.FK_RESERVATION_UID+'" onclick="editShow('+json.FK_RESERVATION_UID+');" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold;">수정</button>'
										//'<button class="btn" id="addReview'+entry.FK_RESERVATION_UID+'" onclick="showAddReview('+entry.FK_RESERVATION_UID+');" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold;">리뷰작성 <span class="glyphicon glyphicon-chevron-down" style="color: white;"></span></button>';
										+'<button type="button" class="btn" onclick="delReview('+json.REVIEW_UID+')">삭제</button>'
									+ '</div>'
								+ '</div>'
							/* ==== 2019.02.11 ==== 수정 시작 */
								+ '<div class="row" style="margin-top: 15px; padding: 7px;word-break:break-all;">';
							
							if(json.RV_STATUS == "0" && json.RV_BLIND != "0") {
									html += '블라인드 처리되거나 삭제 된 댓글 입니다.';
							} else {
								html += '<div class="col-sm-12 content" style="background-color: #f7f7f7; word-break:break-all; border: 0px solid #999; overflow-x:auto; height:auto; padding:20px; border-radius:5px; " >'
										+ json.RV_CONTENTS
									+ '</div>';
									}
							html += '</div>'
							/* ==== 2019.02.11 ==== 수정 끝 */
								/* ==== 2019.01.31 ==== 수정 시작 */
								+ '<div class="row" style="border: 0px solid black; padding: 7px; font-size: 10pt;">'
									+ '<div class="col-sm-12" align="right" style="border: 0px solid yellow;">'
										+'<button type="button" onclick="goDetail('+json.REVIEW_UID+')" class="btn"style="background-color: rgb(252, 118, 106); color: white; font-weight: bold;">내 글 보러가기<span class="glyphicon glyphicon-chevron-right"></spans></button>'
									+ '</div>'
								+ '</div>'
								/* ==== 2019.01.31 ==== 수정 끝 */
							+ '</div>';
					
					$("#reviewShow"+index).html(html);
				},
				error: function(request, status, error){ 
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			}); // end of ajax
			
			$("#showReview"+index).html('리뷰닫기 <span class="glyphicon glyphicon-chevron-up" style="color: white;"></span>');
		} else {
			html = "";
			$("#showReview"+index).html('리뷰보기 <span class="glyphicon glyphicon-chevron-down" style="color: white;"></span>');
			$("#reviewShow"+index).html(html);
		} // end of if~else
	} // end of function showReview(index)
	// === 2019.01.29 === //
	
	// 수정 화면 보여주기
	function editShow(index) {
		var html = "";
		
		$("#reviewShow"+index).prepend("<div class='col-sm-offset-1 col-sm-6'><span style='color: red;'>잠시만 기다려주세요...</span></div>");
		
		var data = {"fk_reservation_UID":index};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectMyReview.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				html = '<div class="col-sm-offset-1 col-sm-1">'
							+'<button class="btn" onclick="editReview('+index+');" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold; color: white;">수정</button>'
						+'</div>'
						+'<div class="col-sm-offset-7 col-sm-2" align="right">';
					for(var i = 0; i<json.STARTPOINT; i++) {
						html += '<span class="star index'+index+'"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star.png"></span>';
					}
					
					for(var i = 0; i<(5-json.STARTPOINT); i++) {
						// === 2019.01.31 ==== 수정 //
						html += '<span class="star index'+index+' reviewStar"><img class="addStar" src=\"<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>';
						// === 2019.01.31 ==== 수정 //
					}
					
				html += '</div>'
						+'<div class="col-sm-offset-1 col-sm-10" style="margin-top: 10px;">'
							+'<input type="hidden" id="reviewCnt'+index+'" id="reviewCnt'+index+'" value="'+json.STARTPOINT+'">'
							+'<input type="hidden" id="review_UID'+index+'" value="'+json.REVIEW_UID+'">'
							+'<textarea class="summernote" id="rv_contents'+index+'" rows="10">'+json.RV_CONTENTS+'</textarea>'
							/* +'<div class="summernote" name="rv_contents"><div>' */
						+'</div>';
				
				$("#reviewShow"+index).html(html);
				
				// === 2019.02.03 === summernote수정 //
				$('.summernote').summernote({
					callbacks: { // 콜백을 사용
	                    // 이미지를 업로드할 경우 이벤트를 발생
					    onImageUpload: function(files, editor, welEditable) {
						    sendFile(files[0], this, welEditable);
						}
					},
					placeholder: '병원,약국에 대한 리뷰를 작성해주세요.',
			        tabsize: 2,
			        height: 300,
			        focus: true
				});
				// === 2019.02.03 === summernote수정 //
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function editShow(index)
	
	// 리뷰 수정하기
	function editReview(index) {
		
		var frm = document.editReviewFrm;
		frm.startpoint.value = $("#reviewCnt"+index).val();
		frm.review_uid.value = $("#review_UID"+index).val();
		frm.rv_contents.value = $("#rv_contents"+index).val();
		
		frm.action = "<%=request.getContextPath()%>/updateMyReview.pet";
		frm.method = "POST";
		frm.submit();
		
	} // end of function editReview(idx)
	
	// 리뷰 삭제하기
	function delReview(review_UID) {
		
		var frm = document.delReviewFrm;
		frm.review_UID.value = review_UID;
		
		frm.action = "<%=request.getContextPath()%>/updateMyReviewStatus.pet"; /* === 2019.02.04 === action경로 수정 */
		frm.method = "POST";
		frm.submit();
	} // end of function delReview(review_UID)
	
	// 더보기를 위한 전체 갯수 알아오기
	function selectTotalCount(period) {
		var data = {"period": period};
		
		$.ajax({
			url: "<%=request.getContextPath()%>/selectMyReviewTotalCount.pet",
			type: "GET",
			data: data,
			dataType: "JSON",
			success: function(json){
				$("#totalCnt").val(json);
			},
			error: function(request, status, error){ 
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // enf of function selectTotalCount(period)
	// === 2019.01.30 === 끝 //

	// === 2019.01.31 === 시작 //
	// === 2019.02.03 === 시작 //
	// 더보기 ==> 해당리뷰의 디테일 페이지로...
	function goDetail(fk_review_UID) {
		location.href = "<%=request.getContextPath()%>/reviewDetail.pet?review_UID="+fk_review_UID;
	} // end of function goDetail(fk_review_UID)
	// === 2019.02.03 === 시작 //
	// === 2019.01.31 === 끝 //
</script>

<div class="container" style="margin-bottom: 20px; margin-top: 3%;"> <%-- === 2019.01.30 === margin-top 변경 --%>
	<%-- === 2019.01.29 === --%>
	<div class="col-sm-offset-1 col-sm-10">
		<div class="row">
			<div class="col-sm-6">
				<button class="btn periodBtn addColor" value="0">전체</button>
				<button class="btn periodBtn" value="1">최근 1달</button>
				<button class="btn periodBtn" value="3">최근 3달</button>
				<button class="btn periodBtn" value="6">최근 6달</button>
				<input type="hidden" id="period"><%-- === 2019.01.29 === --%>
			</div>
		</div>
	
		<div class="row" id="hosResult">
		</div>
		
		<%-- === 2019.01.30 === 시작 --%>
		<div class="row" style="margin-top: 20px;">
			<input type="hidden" id="totalCnt"> <%-- === 2019.01.31 === hidden으로 --%>
			<input type="hidden" id="nowCnt" value="0"> <%-- === 2019.01.31 === hidden으로 --%>
						
			<div class="col-sm-offset-5 col-sm-2" align="center">
				<button type="button" class="btn" id="moreBtn" style="background-color: rgb(252, 118, 106); color: white; font-weight: bold; color: white;">더보기...</button>
			</div>
		</div>
		<%-- === 2019.01.30 === 시작 --%>
	</div>
	
	<form name="addReviewFrm">
		<input type="hidden" name="startpoint">
		<input type="hidden" name="fk_reservation_UID">
		<input type="hidden" name="rv_contents">
	</form>
	<%-- === 2019.01.29 === --%>
	
	<%-- === 2019.01.30 === 시작 --%>
	<form name="editReviewFrm">
		<input type="hidden" name="startpoint">
		<input type="hidden" name="review_uid">
		<input type="hidden" name="rv_contents">
	</form>
	
	<form name="delReviewFrm">
		<input type="hidden" name="review_UID">
	</form>
	<%-- === 2019.01.30 === 끝 --%>
</div>
<%-- === 2019.01.28 ==== --%>