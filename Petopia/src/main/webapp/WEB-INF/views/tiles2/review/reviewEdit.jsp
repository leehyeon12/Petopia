<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- include summernote css/js-->
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script>


<!-- include codemirror (codemirror.css, codemirror.js, xml.js, formatting.js) -->
<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.css">
<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.css">
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/2.36.0/formatting.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
		
		$(".star").click(function(){
			var reviewCnt = Number($("#reviewCnt").val());
			var html = "";
			
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
			$("#reviewCnt").val(reviewCnt);
		}); // end of 
		
		$('.summernote').summernote({
			callbacks: { // 콜백을 사용
                    // 이미지를 업로드할 경우 이벤트를 발생
				    onImageUpload: function(files, editor, welEditable) {
					    sendFile(files[0], this, welEditable);
					}
			},
			placeholder: '병원,약국에 대한 리뷰를 작성해주세요.',
	        tabsize: 2,
	        height: 600,
	        focus: true
		});
	}); // end of $(document).ready();
	
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
 	
 	function goEdit() {
 		var frm = document.editFrm;
 		frm.action = "<%=request.getContextPath()%>/updateReview.pet";
 		frm.method = "POST";
 		frm.submit();
 	} // end of function goEdit()

</script>

<div class="container" style="margin-top: 15px; margin-bottom: 15px;">
	<div class="col-sm-offset-1 col-sm-10" style="border: 1px solid #ddd; border-radius: 10px; padding: 10px;">
		<div class="row" style="margin: 10px 0 10px 0;">
			<div class="col-sm-offset-1 col-sm-1">제목</div>
			<div class="col-sm-8">
				<input type="text" class="form-control" value="[${reviewMap.FK_NICKNAME}] 회원님의  [${reviewMap.HOSNAME}] 리뷰입니다." readonly="readonly"/>
			</div>
		</div>
		
		<div class="row" style="margin: 10px 0 10px 0;">
			<div class="col-sm-offset-1 col-sm-1">작성자</div>
			<div class="col-sm-4">
				<input type="text" class="form-control" value="${reviewMap.FK_USERID}" readonly="readonly"/>
			</div>
		</div>
		
		<div class="row" style="margin: 10px 0 10px 0;">
			<div class="col-sm-offset-1 col-sm-1">별점</div>
			<div>
				<c:forEach begin="1" end="${reviewMap.STARTPOINT}">
					<span class="star"><img class="addStar" src="<%=request.getContextPath()%>/resources/img/review/star.png"></span>
				</c:forEach>
				
				<c:forEach begin="1" end="${5 - reviewMap.STARTPOINT}">
					<span class="star reviewStar"><img class="addStar" src="<%=request.getContextPath()%>/resources/img/review/star empty.png"></span>
				</c:forEach>
			</div>
		</div>
		
		<div class="row" style="margin: 10px 0 10px 0;">
			<div class="col-sm-offset-1 col-sm-10">
				<form name="editFrm">
					<input type="hidden" name="review_UID" value="${reviewMap.REVIEW_UID}">
					<input type="hidden" name="startpoint" id="reviewCnt" value="${reviewMap.STARTPOINT}">
					<textarea class="summernote" name="rv_contents">${reviewMap.RV_CONTENTS}</textarea>
				</form>
			</div>
		</div>
		
		<div class="row" style="margin: 10px 0 10px 0;">
			<div class="col-sm-12" align="right">
				<button class="btn" onclick="javascript:location.href='<%=request.getContextPath()%>/reviewDetail.pet?review_UID=${reviewMap.REVIEW_UID}'">취소</button>
				<button class="btn" onclick="goEdit();">수정</button>
			</div>
		</div>
	</div>
</div>